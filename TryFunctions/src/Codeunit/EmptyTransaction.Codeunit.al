codeunit 150006 "Empty Transaction_tf" implements ITransactionType_tf
{
    Access = Internal;

    procedure Process(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    begin
    end;

    procedure ProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    begin
    end;

    [TryFunction]
    procedure TFProcess(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    begin
    end;

    [TryFunction]
    procedure TFProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    begin
    end;
}
