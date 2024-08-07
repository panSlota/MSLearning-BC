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

    local procedure "Code"(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        ITransactionType: Interface ITransactionType_tf;
        ErrInfo: ErrorInfo;
    begin
        TransactionWorksheetLine.SetRange("No. of PK Fields Missing", 0);
        TransactionWorksheetLine.FindSet();
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

    procedure GetProcessError(ProcessName: Text): Text
    var
        ErrorTxt: Label 'An error occured during the %1 process.', Comment = '%1 = Process Name';
    begin
        exit(StrSubstNo(ErrorTxt, ProcessName));
    end;

    #endregion Setup
}
