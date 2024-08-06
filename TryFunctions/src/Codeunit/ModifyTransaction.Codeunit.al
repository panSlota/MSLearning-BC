codeunit 150004 "Modify Transaction" implements ITransactionType
{
    TableNo = "Transaction Worksheet Line";
    Access = Internal;

    trigger OnRun()
    begin

    end;

    procedure Process(var TransactionWorksheetLine: Record "Transaction Worksheet Line")
    begin
    end;

    procedure ProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line")
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
