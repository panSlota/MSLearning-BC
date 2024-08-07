/// <summary>
/// typ operace nad tabulkou
/// 
/// slouzi pro nastaveni operace nad tabulkou v radku sesitu transakce
/// </summary>
enum 150000 "Record Action Type_tf" implements ITransactionType_tf
{
    DefaultImplementation = ITransactionType_tf = "Empty Transaction_tf";
    UnknownValueImplementation = ITransactionType_tf = "Empty Transaction_tf";
    Access = Internal;

    /// <summary>
    /// vychozi hodnota - nedefinovano
    ///
    /// spusti CU150006 "Empty Transaction_tf" - nevykona nic
    /// </summary>
    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }

    /// <summary>
    /// cist
    ///
    /// spusti CU150002 "Read Transaction_tf" - cteni zaznamu
    /// </summary>
    value(1; Read)
    {
        Caption = 'Read';
        Implementation = ITransactionType_tf = "Read Transaction_tf";
    }

    /// <summary>
    /// vlozit
    ///
    /// spusti CU150003 "Insert Transaction_tf" - vlozeni zaznamu
    /// </summary>
    value(2; Insert)
    {
        Caption = 'Insert';
        Implementation = ITransactionType_tf = "Insert Transaction_tf";
    }

    /// <summary>
    /// zmenit
    ///
    /// spusti CU150004 "Modify Transaction_tf" - zmena zaznamu
    /// </summary>
    value(3; "Modify")
    {
        Caption = 'Modify';
        Implementation = ITransactionType_tf = "Modify Transaction_tf";
    }

    /// <summary>
    /// odstranit
    ///
    /// spusti CU150005 "Delete Transaction_tf" - odstraneni zaznamu
    /// </summary>
    value(4; Delete)
    {
        Caption = 'Delete';
        Implementation = ITransactionType_tf = "Delete Transaction_tf";
    }
}
