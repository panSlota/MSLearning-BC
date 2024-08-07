codeunit 150005 "Delete Transaction_tf" implements ITransactionType_tf
{
    Access = Internal;

    var
        TransactionFunctions: Codeunit "Transaction Functions_tf";
        ProcessNameLbl: Label 'delete';

    procedure Process(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        RecRefToDelete: RecordRef;
    begin
        TransactionFunctions.GetRecordRef(RecRefToDelete, TransactionWorksheetLine);
        RecRefToDelete.Delete(true);
    end;

    procedure ProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var ErrInfo: ErrorInfo)
    begin
        Process(TransactionWorksheetLine);
        ErrInfo := ErrorInfo.Create(TransactionFunctions.GetProcessError(ProcessNameLbl));
    end;

    procedure TFProcess(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"): Boolean;
    begin
        exit(RTFProcess(TransactionWorksheetLine));
    end;

    procedure TFProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var ErrInfo: ErrorInfo): Boolean;
    begin
        exit(RTFProcessError(TransactionWorksheetLine, ErrInfo));
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
