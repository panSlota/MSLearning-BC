/// <summary>
/// vysledek behu transakce
/// 
/// slouzi pro zobrazeni vysledku behu transakce
/// </summary>
enum 150001 "Transaction Run Result_tf"
{
    Access = Internal;

    /// <summary>
    /// vychozi hodnota - nedefinovano
    ///
    /// nastavuje se funkci ClearResults() v *CU150001 "Transaction Worksheet Mgt"
    /// </summary>
    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    /// <summary>
    /// uspech
    /// </summary>
    value(1; Success)
    {
        Caption = 'Success';
    }
    /// <summary>
    /// uspech spotrebovan
    ///
    /// podobne jako Success, ale navratova hodnota TryFunction byla vyuzita
    /// </summary>
    value(2; "Success Consumed")
    {
        Caption = 'Success Consumed';
    }
    /// <summary>
    /// chyba
    /// </summary>
    value(3; Fail)
    {
        Caption = 'Fail';
    }
    /// <summary>
    /// chyba spotrebovana
    ///
    /// podobne jako Fail, ale navratova hodnota TryFunction byla vyuzita
    /// </summary>
    value(4; "Fail Consumed")
    {
        Caption = 'Fail Consumed';
    }
}
