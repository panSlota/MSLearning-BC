interface ITransactionType
{
    Access = Internal;

    procedure Process(var TransactionWorksheetLine: Record "Transaction Worksheet Line");
    procedure ProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line");
    procedure TFProcess(var TransactionWorksheetLine: Record "Transaction Worksheet Line"): Boolean;
    procedure TFProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line"): Boolean;
}
