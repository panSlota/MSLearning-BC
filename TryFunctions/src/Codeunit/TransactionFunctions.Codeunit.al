/// <summary>
/// spousti operace nad tabulkami uvedenymi v radcich sesitu transakci
/// 
/// pousti prislusnou CU na zaklade hodnoty v E150000 "Record Action Type_tf"
/// </summary>
codeunit 150000 "Transaction Functions_tf"
{
    TableNo = "Transaction Worksheet Line_tf";
    Access = Internal;

    trigger OnRun()
    var
        lreTransactionWorksheetLine: Record "Transaction Worksheet Line_tf";
    begin
        lreTransactionWorksheetLine.Copy(Rec);
        Code(lreTransactionWorksheetLine);
        Rec := lreTransactionWorksheetLine;
    end;

    var
        NoTableWithIDFoundErr: Label 'No table with ID %1 has been found.', Comment = '%1 = Table ID';

    #region Transactions

    /// <summary>
    /// spousti operace nad tabulkami uvedenymi v radcich sesitu transakci
    ///
    /// pousti prislusnou CU na zaklade hodnoty v E150000 "Record Action Type_tf"
    ///
    /// na zaklade poli *"Run TryFunction"*, *"Consume TryFunction Result"* a *"Throw Error"* urcuje, jakou operaci spustit &amp;
    /// jake pole na radku sesitu transakci validovat
    /// </summary>
    /// <param name="TransactionWorksheetLine">radek sesitu transakce</param>
    local procedure "Code"(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        ITransactionType: Interface ITransactionType_tf;
        ErrInfo: ErrorInfo;
    begin
        TransactionWorksheetLine.SetRange("No. of PK Fields Missing", 0);
        if TransactionWorksheetLine.FindSet() then
            repeat
                ITransactionType := TransactionWorksheetLine."Action Type";

                if TransactionWorksheetLine."Run TryFunction" then begin
                    if TransactionWorksheetLine."Consume TryFunction Result" then begin
                        if TransactionWorksheetLine."Throw Error" then begin
                            if ITransactionType.TFProcessError(TransactionWorksheetLine, ErrInfo) then;
                            TransactionWorksheetLine.Result := Enum::"Transaction Run Result_tf"::"Fail Consumed";
                            TransactionWorksheetLine."Result Reason" := CopyStr(ErrInfo.Message(), 1, MaxStrLen(TransactionWorksheetLine."Result Reason"));
                        end
                        else begin
                            if ITransactionType.TFProcess(TransactionWorksheetLine) then;
                            TransactionWorksheetLine.Result := Enum::"Transaction Run Result_tf"::"Success Consumed";
                        end;
                    end else
                        if TransactionWorksheetLine."Throw Error" then begin
                            if ITransactionType.TFProcessError(TransactionWorksheetLine, ErrInfo) then;
                            TransactionWorksheetLine.Result := Enum::"Transaction Run Result_tf"::"Fail";
                            TransactionWorksheetLine."Result Reason" := CopyStr(ErrInfo.Message(), 1, MaxStrLen(TransactionWorksheetLine."Result Reason"));
                        end
                        else begin
                            if ITransactionType.TFProcess(TransactionWorksheetLine) then;
                            TransactionWorksheetLine.Result := Enum::"Transaction Run Result_tf"::"Success";
                        end;
                end else
                    if TransactionWorksheetLine."Throw Error" then begin
                        ITransactionType.ProcessError(TransactionWorksheetLine, ErrInfo);
                        TransactionWorksheetLine.Result := Enum::"Transaction Run Result_tf"::Fail;
                        TransactionWorksheetLine."Result Reason" := CopyStr(ErrInfo.Message(), 1, MaxStrLen(TransactionWorksheetLine."Result Reason"));
                    end
                    else begin
                        ITransactionType.Process(TransactionWorksheetLine);
                        TransactionWorksheetLine.Result := Enum::"Transaction Run Result_tf"::Success;
                    end;

                TransactionWorksheetLine."Last Run Time" := CurrentDateTime();
                TransactionWorksheetLine.Modify(true);
            until TransactionWorksheetLine.Next() = 0;
    end;

    #endregion Transactions


    #region Setup

    [Scope('OnPrem')]
    procedure GetDisableWriteInsideTryFunctions(var Config: Text; var Disabled: Boolean)
    var
        ActiveSession: Record "Active Session";
        TypeHelper: Codeunit "Type Helper";

        Process: Dotnet Process_tf;
        ProcessStartInfo: Dotnet ProcessStartInfo_tf;

        GetNavServerConfigurationLbl: Label 'Get-NavServerConfiguration -ServerInstance %1', Comment = '%1 = Instance Name', Locked = true;
        ImportModuleLbl: Label 'Import-Module -Name ''C:\Program Files\Microsoft Dynamics NAV\240\Service\NavAdminTool.ps1'' -Verbose > $null', Locked = true;
        FileNameLbl: Label 'PowerShell.exe', Locked = true;
        ArgumentsLbl: Label '-NoProfile -ExecutionPolicy Bypass -Command "%1; %2"', Comment = '%1 = Import-Module, %2 = Get-NavServerConfiguration', Locked = true;
        DisableWriteInsideTryFunctionsLbl: Label 'DisableWriteInsideTryFunctions', Locked = true;
        ConfigOutputLbl: Label '{"%1" : %2}', Comment = '%1 = DisableWriteInsideTryFunctions, %2 = Value', Locked = true;

        Output, ErrorMessage, Line : Text;
        StartPos, LineStart, EndPos : Integer;
    begin
        ProcessStartInfo := ProcessStartInfo.ProcessStartInfo();
        ProcessStartInfo.FileName(FileNameLbl);

        ActiveSession.SetRange("Server Instance ID", ServiceInstanceId());
        ActiveSession.SetRange("Session ID", SessionId());
        ActiveSession.FindFirst();

        ProcessStartInfo.Arguments(StrSubstNo(ArgumentsLbl,
                                              ImportModuleLbl,
                                              StrSubstNo(GetNavServerConfigurationLbl,
                                                         ActiveSession."Server Instance Name")));

        ProcessStartInfo.RedirectStandardOutput(true);
        ProcessStartInfo.RedirectStandardError(true);
        ProcessStartInfo.UseShellExecute(false);
        ProcessStartInfo.CreateNoWindow(true);

        Process := Process.Start(ProcessStartInfo);
        Output := Process.StandardOutput().ReadToEnd();
        ErrorMessage := Process.StandardError().ReadToEnd();
        Process.WaitForExit();

        StartPos := StrPos(Output, DisableWriteInsideTryFunctionsLbl);
        LineStart := Output.LastIndexOf(TypeHelper.CRLFSeparator(), StartPos) + 1;
        if LineStart = 0 then
            LineStart := 1;

        EndPos := Output.IndexOf(TypeHelper.CRLFSeparator(), StartPos);
        if EndPos = 0 then
            EndPos := StrLen(Output) + 1;

        Line := Output.Substring(LineStart, EndPos - LineStart);

        Disabled := Line.ToLower().Contains('true');
        Config := StrSubstNo(ConfigOutputLbl, DisableWriteInsideTryFunctionsLbl, Format(Disabled, 0, 9));
    end;

    /// <summary>
    /// provede RecordRef.Open na zaklade ID tabulky
    ///
    /// zkontroluje, ze tabulka s danym ID existuje
    /// </summary>
    /// <param name="TableNo">ID tabulky</param>
    /// <returns>otevreny RecordRef</returns>
    procedure OpenRecordRef(TableNo: Integer) RecRef: RecordRef;
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
        AllObjWithCaption.SetRange("Object ID", TableNo);
        if AllObjWithCaption.IsEmpty() then
            Error(NoTableWithIDFoundErr, TableNo);

        RecRef.Open(TableNo);
    end;

    /// <summary>
    /// provede "GET" na zaznamu podle ID tabulky a hodnot v PK
    ///
    /// misto *GET* provede v cyklu serii *SetFilter* na polich PK
    ///
    /// hodnoty PK bere na zaklade pole *Position*, aby zachoval poradi
    /// </summary>
    /// <param name="RecRef">pozadovany zaznam</param>
    /// <param name="TransactionWorksheetLine">radek sesitu transakce</param>
    /// <returns>**TRUE**, pokud nasel, jinak **FALSE**</returns>
    procedure GetRecordRef(var RecRef: RecordRef; var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"): Boolean;
    var
        RecordPrimaryKeyValue: Record "Record Primary Key Value_tf";
    begin
        RecordPrimaryKeyValue.SetRange("Table ID", TransactionWorksheetLine."Table ID");
        RecordPrimaryKeyValue.SetRange("Transaction Setup Code", TransactionWorksheetLine."Transaction Setup Code");
        RecordPrimaryKeyValue.SetCurrentKey(Position);
        RecordPrimaryKeyValue.Ascending(true);
        RecordPrimaryKeyValue.SetAutoCalcFields("Field No.");
        if RecordPrimaryKeyValue.FindSet() then begin
            RecRef.Open(TransactionWorksheetLine."Table ID");
            repeat
                RecRef.Field(RecordPrimaryKeyValue."Field No.").SetFilter(RecordPrimaryKeyValue.Value);
            until RecordPrimaryKeyValue.Next() = 0;
        end;

        exit(RecRef.FindFirst());
    end;

    /// <summary>
    /// slouzi pro validaci poli PK na zaznamu
    ///
    /// bere v potaz datovy typ pole a jeho delku
    /// </summary>
    /// <param name="RecRef">zaznam</param>
    /// <param name="FieldNo">cislo pole</param>
    /// <param name="Value">hodnota pole</param>
    /// <param name="Type">datovy typ pole</param>
    /// <param name="Length">delka pole</param>
    procedure ValidateRecordRefField
    (
        var RecRef: RecordRef;
        FieldNo: Integer;
        Value: Text;
        Type: Option TableFilter,RecordID,OemText,Date,Time,DateFormula,Decimal,Media,MediaSet,Text,Code,Binary,BLOB,Boolean,Integer,OemCode,Option,BigInteger,Duration,GUID,DateTime;
        Length: Integer
    )
    var
        ValueDate: Date;
        ValueTime: Time;
        ValueDecimal: Decimal;
        ValueCode10: Code[10];
        ValueCode20: Code[20];
        ValueBoolean: Boolean;
        ValueInteger: Integer;
        ValueBigInteger: BigInteger;
        ValueGUID: Guid;
        ValueDateTime: DateTime;
    begin
        case Type of
            Type::Date:
                begin
                    Evaluate(ValueDate, Value);
                    RecRef.Field(FieldNo).Validate(ValueDate);
                end;
            Type::Time:
                begin
                    Evaluate(ValueTime, Value);
                    RecRef.Field(FieldNo).Validate(ValueTime);
                end;
            Type::Decimal:
                begin
                    Evaluate(ValueDecimal, Value);
                    RecRef.Field(FieldNo).Validate(ValueDecimal);
                end;
            Type::Text:
                RecRef.Field(FieldNo).Validate(Value);
            Type::Code:
                case Length of
                    10:
                        begin
                            Evaluate(ValueCode10, Value);
                            RecRef.Field(FieldNo).Validate(ValueCode10);
                        end;
                    20:
                        begin
                            Evaluate(ValueCode20, Value);
                            RecRef.Field(FieldNo).Validate(ValueCode20);
                        end;
                    else    // nepredpokladam, ze by delka mohla byt jina nez 10/20, ale pro jistotu
                        RecRef.Field(FieldNo).Validate(Value);
                end;
            Type::Boolean:
                begin
                    Evaluate(ValueBoolean, Value);
                    RecRef.Field(FieldNo).Validate(ValueBoolean);
                end;
            Type::Integer,  //enum, option & integer beru jako int32
            Type::Option:
                begin
                    Evaluate(ValueInteger, Value);
                    RecRef.Field(FieldNo).Validate(ValueInteger);
                end;
            Type::BigInteger:
                begin
                    Evaluate(ValueBigInteger, Value);
                    RecRef.Field(FieldNo).Validate(ValueBigInteger);
                end;
            Type::GUID:
                begin
                    Evaluate(ValueGUID, Value);
                    RecRef.Field(FieldNo).Validate(ValueGUID);
                end;
            Type::DateTime:
                begin
                    Evaluate(ValueDateTime, Value);
                    RecRef.Field(FieldNo).Validate(ValueDateTime);
                end;
            else
                RecRef.Field(FieldNo).Validate(Value);
        end;
    end;

    /// <summary>
    /// vrati text chyby pro dany proces (cteni, zapis, modifikace, mazani)
    /// </summary>
    /// <param name="ProcessName">nazev procesu</param>
    /// <returns>text chyby</returns>
    procedure GetProcessError(ProcessName: Text): Text
    var
        ErrorTxt: Label 'An error occured during the %1 process.', Comment = '%1 = Process Name';
    begin
        exit(StrSubstNo(ErrorTxt, ProcessName));
    end;

    #endregion Setup
}
