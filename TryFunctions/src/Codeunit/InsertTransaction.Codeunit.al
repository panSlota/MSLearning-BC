codeunit 150003 "Insert Transaction_tf" implements ITransactionType_tf
{
    Access = Internal;

    var
        TransactionFunctions: Codeunit "Transaction Functions_tf";
        ProcessNameLbl: Label 'Insert';

    procedure Process(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        RecordPrimaryKeyValue: Record "Record Primary Key Value_tf";
        RecRefToInsert: RecordRef;
    begin
        RecRefToInsert := TransactionFunctions.OpenRecordRef(TransactionWorksheetLine."Table ID");
        TransactionFunctions.GetRecordRef(RecRefToInsert, TransactionWorksheetLine);
    end;

    procedure ProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    begin
        Process(TransactionWorksheetLine);
        Error(TransactionFunctions.GetProcessError(ProcessNameLbl));
    end;

    [TryFunction]
    procedure TFProcess(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    begin
        Process(TransactionWorksheetLine);
    end;

    [TryFunction]
    procedure TFProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    begin
        ProcessError(TransactionWorksheetLine);
    end;
}
