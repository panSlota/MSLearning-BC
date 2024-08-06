codeunit 150003 "Insert Transaction" implements ITransactionType
{
    Access = Internal;

    var
        TransactionFunctions: Codeunit "Transaction Functions";

    procedure Process(var TransactionWorksheetLine: Record "Transaction Worksheet Line")
    var
        RecordPrimaryKeyValue: Record "Record Primary Key Value";
        RecRefToInsert: RecordRef;
    begin
        RecRefToInsert := TransactionFunctions.OpenRecordRef(TransactionWorksheetLine."Table ID");
        TransactionFunctions.GetRecordRef(RecRefToInsert, TransactionWorksheetLine);
    end;

    procedure ProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line")
    begin
        Process(TransactionWorksheetLine);
        Error('');
    end;

    [TryFunction]
    procedure TFProcess(var TransactionWorksheetLine: Record "Transaction Worksheet Line")
    begin
        Process(TransactionWorksheetLine);
    end;

    [TryFunction]
    procedure TFProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line")
    begin
        ProcessError(TransactionWorksheetLine);
    end;
}
