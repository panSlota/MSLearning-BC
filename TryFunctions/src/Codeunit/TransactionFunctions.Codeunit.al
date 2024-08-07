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
        Result: Boolean;
    begin
        TransactionWorksheetLine.FindSet();
        repeat
            ITransactionType := TransactionWorksheetLine."Action Type";

            if TransactionWorksheetLine."Run TryFunction" then begin
                if TransactionWorksheetLine."Consume TryFunction Result" then begin
                    if TransactionWorksheetLine."Throw Error" then
                        Result := ITransactionType.TFProcessError(TransactionWorksheetLine)
                    else
                        Result := ITransactionType.TFProcess(TransactionWorksheetLine);
                end else
                    if TransactionWorksheetLine."Throw Error" then
                        ITransactionType.TFProcessError(TransactionWorksheetLine)
                    else
                        ITransactionType.TFProcess(TransactionWorksheetLine);
            end else
                if TransactionWorksheetLine."Throw Error" then
                    ITransactionType.ProcessError(TransactionWorksheetLine)
                else
                    ITransactionType.Process(TransactionWorksheetLine);

        until TransactionWorksheetLine.Next() = 0;
    end;

    #region Insert

    #endregion Insert

    #region Modify

    local procedure Modify(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        Result: Boolean;
    begin
        if TransactionWorksheetLine."Run TryFunction" then begin
            if TransactionWorksheetLine."Consume TryFunction Result" then begin
                if TransactionWorksheetLine."Throw Error" then
                    Result := TFModifyRecordError(TransactionWorksheetLine)
                else
                    Result := TFModifyRecord(TransactionWorksheetLine);
            end else
                if TransactionWorksheetLine."Throw Error" then
                    TFModifyRecordError(TransactionWorksheetLine)
                else
                    TFModifyRecord(TransactionWorksheetLine);
        end else
            if TransactionWorksheetLine."Throw Error" then
                ModifyRecordError(TransactionWorksheetLine)
            else
                ModifyRecord(TransactionWorksheetLine);
    end;

    local procedure ModifyRecord(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        myInt: Integer;
    begin
        // TransactionWorksheetLine.
    end;

    local procedure ModifyRecordError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        myInt: Integer;
    begin

    end;

    [TryFunction()]
    local procedure TFModifyRecord(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    begin
        ModifyRecord(TransactionWorksheetLine);
    end;

    [TryFunction()]
    local procedure TFModifyRecordError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    begin
        ModifyRecordError(TransactionWorksheetLine);
    end;

    #endregion Modify


    #region Read

    local procedure Read(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        Result: Boolean;
    begin
        if TransactionWorksheetLine."Run TryFunction" then begin
            if TransactionWorksheetLine."Consume TryFunction Result" then begin
                if TransactionWorksheetLine."Throw Error" then begin
                    Result := TFReadRecordError(TransactionWorksheetLine);
                    TransactionWorksheetLine.Result := Enum::"Transaction Run Result_tf"::"Fail Consumed";
                    TransactionWorksheetLine."Result Reason" := CopyStr(GetLastErrorText(), 1, MaxStrLen(TransactionWorksheetLine."Result Reason"));
                end
                else begin
                    Result := TFReadRecord(TransactionWorksheetLine);
                    TransactionWorksheetLine.Result := Enum::"Transaction Run Result_tf"::"Success Consumed";
                end;
            end else
                if TransactionWorksheetLine."Throw Error" then begin
                    TFReadRecordError(TransactionWorksheetLine);
                    TransactionWorksheetLine.Result := Enum::"Transaction Run Result_tf"::Fail;
                    TransactionWorksheetLine."Result Reason" := CopyStr(GetLastErrorText(), 1, MaxStrLen(TransactionWorksheetLine."Result Reason"));
                end
                else begin
                    TFReadRecord(TransactionWorksheetLine);
                    TransactionWorksheetLine.Result := Enum::"Transaction Run Result_tf"::Success;
                end;
        end else
            if TransactionWorksheetLine."Throw Error" then begin
                ReadRecordError(TransactionWorksheetLine);
                TransactionWorksheetLine.Result := Enum::"Transaction Run Result_tf"::Fail;
                TransactionWorksheetLine."Result Reason" := CopyStr(GetLastErrorText(), 1, MaxStrLen(TransactionWorksheetLine."Result Reason"));
            end
            else begin
                ReadRecord(TransactionWorksheetLine);
                TransactionWorksheetLine.Result := Enum::"Transaction Run Result_tf"::Success;
            end;
    end;

    local procedure ReadRecord(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        ReadRecordRef: RecordRef;
    begin
        GetRecordRef(ReadRecordRef, TransactionWorksheetLine);
    end;

    local procedure ReadRecordError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        myInt: Integer;
    begin

    end;

    [TryFunction()]
    local procedure TFReadRecord(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        myInt: Integer;
    begin

    end;

    [TryFunction()]
    local procedure TFReadRecordError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        myInt: Integer;
    begin

    end;

    #endregion Read


    #region Delete

    local procedure Delete(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        Result: Boolean;
    begin
        if TransactionWorksheetLine."Run TryFunction" then begin
            if TransactionWorksheetLine."Consume TryFunction Result" then begin
                if TransactionWorksheetLine."Throw Error" then
                    Result := TFDeleteRecordError(TransactionWorksheetLine)
                else
                    Result := TFDeleteRecord(TransactionWorksheetLine);
            end else
                if TransactionWorksheetLine."Throw Error" then
                    TFDeleteRecordError(TransactionWorksheetLine)
                else
                    TFDeleteRecord(TransactionWorksheetLine);
        end else
            if TransactionWorksheetLine."Throw Error" then
                DeleteRecordError(TransactionWorksheetLine)
            else
                DeleteRecord(TransactionWorksheetLine);
    end;

    local procedure DeleteRecord(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        myInt: Integer;
    begin

    end;

    local procedure DeleteRecordError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        myInt: Integer;
    begin

    end;

    [TryFunction()]
    local procedure TFDeleteRecord(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        myInt: Integer;
    begin

    end;

    [TryFunction()]
    local procedure TFDeleteRecordError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        myInt: Integer;
    begin

    end;


    #endregion Delete


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

    procedure GetRecordRef(var RecRef: RecordRef; var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
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

        if RecRef.FindFirst() then
            TransactionWorksheetLine.Result := Enum::"Transaction Run Result_tf"::Success
        else begin
            TransactionWorksheetLine.Result := Enum::"Transaction Run Result_tf"::Fail;
            TransactionWorksheetLine."Result Reason" := CopyStr(GetLastErrorText(), 1, MaxStrLen(TransactionWorksheetLine."Result Reason"));
        end;
        TransactionWorksheetLine.Modify(true);
    end;

    procedure GetProcessError(ProcessName: Text): Text
    var
        ErrorTxt: Label 'An error occured during the %1 process.', Comment = '%1 = Process Name';
    begin
        exit(StrSubstNo(ErrorTxt, ProcessName));
    end;

    #endregion Setup
}
