interface ITransactionType_tf
{
    Access = Internal;

    procedure Process(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf");
    procedure ProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf");
    procedure TFProcess(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"): Boolean;
    procedure TFProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"): Boolean;
}
