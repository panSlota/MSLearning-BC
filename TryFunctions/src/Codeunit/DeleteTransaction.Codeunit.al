/// <summary>
/// odstraneni zaznamu
/// 
/// obsahuje funkce pro odsraneni zaznamu
/// </summary>
codeunit 150005 "Delete Transaction_tf" implements ITransactionType_tf
{
    Access = Internal;

    var
        TransactionFunctions: Codeunit "Transaction Functions_tf";
        ProcessNameLbl: Label 'delete';

    /// <summary>
    /// natahne si zaznam z DB a smaze ho
    /// </summary>
    /// <param name="TransactionWorksheetLine">radek sesitu transakce</param>
    procedure Process(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        RecRefToDelete: RecordRef;
    begin
        TransactionFunctions.GetRecordRef(RecRefToDelete, TransactionWorksheetLine);
        RecRefToDelete.Delete(true);
    end;

    /// <summary>
    /// provede operaci mazani s chybou
    /// </summary>
    /// <param name="TransactionWorksheetLine">radek sesitu transakce</param>
    /// <param name="ErrInfo">informace o chybe vznikle pri mazani</param>
    procedure ProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var ErrInfo: ErrorInfo)
    begin
        Process(TransactionWorksheetLine);
        ErrInfo := ErrorInfo.Create(TransactionFunctions.GetProcessError(ProcessNameLbl));
    end;

    /// <summary>
    /// provede operaci mazani uvnitr TryFunction
    /// </summary>
    /// <param name="TransactionWorksheetLine">radek sesitu transakce</param>
    /// <returns>ocekavam **TRUE**</returns>
    procedure TFProcess(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"): Boolean;
    begin
        exit(RTFProcess(TransactionWorksheetLine));
    end;

    /// <summary>
    /// provede operaci mazani s chybou uvnitr TryFunction
    /// </summary>
    /// <param name="TransactionWorksheetLine">radek sesitu transakce</param>
    /// <param name="ErrInfo">informace o vznikle chybe</param>
    /// <returns>ocekavam **FALSE**</returns>
    procedure TFProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var ErrInfo: ErrorInfo): Boolean;
    begin
        exit(RTFProcessError(TransactionWorksheetLine, ErrInfo));
    end;

    /// <summary>
    /// provede operaci mazani uvnitr TryFunction
    ///
    /// je to opravdova TF kvuli implementaci v interface
    /// </summary>
    /// <param name="TransactionWorksheetLine">radek sesitu transakce</param>
    /// <returns>ocekavam **TRUE**</returns>
    [TryFunction]
    local procedure RTFProcess(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    begin
        Process(TransactionWorksheetLine);
    end;

    /// <summary>
    /// provede operaci mazani s chybou uvnitr TryFunction
    ///
    /// je to opravdova TF kvuli implementaci v interface
    /// </summary>
    /// <param name="TransactionWorksheetLine">radek sesitu transakce</param>
    /// <param name="ErrInfo">informace o vznikle chybe</param>
    /// <returns>ocekavam **FALSE**</returns>
    [TryFunction]
    local procedure RTFProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var ErrInfo: ErrorInfo)
    begin
        ProcessError(TransactionWorksheetLine, ErrInfo);
    end;
}
