codeunit 150003 "Insert Transaction_tf" implements ITransactionType_tf
{
    Access = Internal;

    var
        TransactionFunctions: Codeunit "Transaction Functions_tf";
        ProcessNameLbl: Label 'insert';

    procedure Process(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        RecordPrimaryKeyValue: Record "Record Primary Key Value_tf";
        RecRefToInsert: RecordRef;
    begin
        RecRefToInsert := TransactionFunctions.OpenRecordRef(TransactionWorksheetLine."Table ID");

        RecordPrimaryKeyValue.SetRange("Transaction Setup Code", TransactionWorksheetLine."Transaction Setup Code");
        RecordPrimaryKeyValue.SetRange("Table ID", TransactionWorksheetLine."Table ID");
        RecordPrimaryKeyValue.SetAutoCalcFields(Type, "Field Length", "Field No.");
        RecordPrimaryKeyValue.SetCurrentKey(Position);
        RecordPrimaryKeyValue.Ascending(true);
        RecordPrimaryKeyValue.FindSet();
        repeat
            TransactionFunctions.ValidateRecordRefField(RecRefToInsert,
                                                        RecordPrimaryKeyValue."Field No.",
                                                        RecordPrimaryKeyValue.Value,
                                                        RecordPrimaryKeyValue.Type,
                                                        RecordPrimaryKeyValue."Field Length");
        until RecordPrimaryKeyValue.Next() = 0;

        RecRefToInsert.Insert(true);
        RecRefToInsert.Close();
    end;

    procedure ProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var ErrInfo: ErrorInfo)
    begin
        Process(TransactionWorksheetLine);
        ErrInfo := ErrorInfo.Create(TransactionFunctions.GetProcessError(ProcessNameLbl));
    end;

    procedure TFProcess(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"): Boolean
    begin
        if RTFProcess(TransactionWorksheetLine) then
            exit(true)
        else
            exit(false);
    end;

    procedure TFProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var ErrInfo: ErrorInfo): Boolean
    begin
        if RTFProcessError(TransactionWorksheetLine, ErrInfo) then
            exit(true)
        else
            exit(false);
    end;

    [TryFunction]
    local procedure RTFProcess(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    begin
        Process(TransactionWorksheetLine);
    end;

    [TryFunction]
    local procedure RTFProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var ErrInfo: ErrorInfo)
    begin
        ProcessError(TransactionWorksheetLine, ErrInfo);
    end;
}
