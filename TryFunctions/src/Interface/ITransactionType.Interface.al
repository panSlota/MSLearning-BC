/// <summary>
/// obsahuje funkce pro zpracovani transakce
/// - Process - zpracovani transakce
/// - ProcessError - zpracovani transakce s chybou
/// - TFProcess - zpracovani transakce uvnitr TryFunction
/// - TFProcessError - zpracovani transakce s chybou uvnitr TryFunction
/// </summary>
interface ITransactionType_tf
{
    Access = Internal;

    /// <summary>
    /// zpracuje transakci
    /// </summary>
    /// <param name="TransactionWorksheetLine">radek sesitu transakce</param>
    procedure Process(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf");

    /// <summary>
    /// zpracuje transakci s chybou
    /// </summary>
    /// <param name="TransactionWorksheetLine">radek sesitu transakce</param>
    /// <param name="ErrInfo">informace o vznikle chybe</param>
    procedure ProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var ErrInfo: ErrorInfo);

    /// <summary>
    /// zpracuje transakci uvnitr TryFunction
    /// </summary>
    /// <param name="TransactionWorksheetLine">radek sesitu transakce</param>
    /// <returns>**TRUE**, pokud transakce probehne bez chyby, jinak **FALSE**; ocekava se **TRUE**</returns>
    procedure TFProcess(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"): Boolean;

    /// <summary>
    /// zpracuje transakci s chybou uvnitr TryFunction
    /// </summary>
    /// <param name="TransactionWorksheetLine">radek sesitu transakce</param>
    /// <param name="ErrInfo">informace o vznikle chybe</param>
    /// <returns>**TRUE**, pokud transakce probehne bez chyby, jinak **FALSE**; ocekava se **FALSE**</returns>
    procedure TFProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var ErrInfo: ErrorInfo): Boolean;
}
