codeunit 150002 "Read Transaction" implements ITransactionType
{
    Access = Internal;

    procedure Process(var TransactionWorksheetLine: Record "Transaction Worksheet Line");
    begin
    end;

    procedure ProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line");
    begin
    end;

    [TryFunction]
    procedure TFProcess(var TransactionWorksheetLine: Record "Transaction Worksheet Line")
    begin
    end;

    [TryFunction]
    procedure TFProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line")
    begin
    end;
}
