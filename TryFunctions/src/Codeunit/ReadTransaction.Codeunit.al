/// <summary>
/// cteni zaznamu
/// 
/// obsahuje funkce pro cteni zaznamu
/// </summary>
codeunit 150002 "Read Transaction_tf" implements ITransactionType_tf
{
    Access = Internal;

    var
        TransactionFunctions: Codeunit "Transaction Functions_tf";
        ProcessNameLbl: Label 'read';

    /// <summary>
    /// natahne si zaznam z DB
    /// </summary>
    /// <param name="TransactionWorksheetLine">radek sesitu transakce</param>
    procedure Process(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf");
    var
        RecRefToRead: RecordRef;
    begin
        TransactionFunctions.GetRecordRef(RecRefToRead, TransactionWorksheetLine);
    end;

    procedure ProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var ErrInfo: ErrorInfo);
    begin
        Process(TransactionWorksheetLine);
        ErrInfo := ErrorInfo.Create(TransactionFunctions.GetProcessError(ProcessNameLbl));
    end;

    procedure TFProcess(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"): Boolean
    begin
        exit(RTFProcess(TransactionWorksheetLine));
    end;


    procedure TFProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var ErrInfo: ErrorInfo): Boolean
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
