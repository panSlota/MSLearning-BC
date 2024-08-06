enum 150000 "Record Action Type" implements ITransactionType
{
    DefaultImplementation = ITransactionType = "Empty Transaction";
    UnknownValueImplementation = ITransactionType = "Empty Transaction";
    Access = Internal;

    value(0;
    " ")
    {
        Caption = ' ';
}
    value(1; Read)
    {
        Caption = 'Read';
        Implementation = ITransactionType = "Read Transaction";
    }
    value(2; Insert)
    {
        Caption = 'Insert';
        Implementation = ITransactionType = "Insert Transaction";
    }
    value(3; "Modify")
    {
        Caption = 'Modify';
        Implementation = ITransactionType = "Modify Transaction";
    }
    value(4; Delete)
    {
        Caption = 'Delete';
        Implementation = ITransactionType = "Delete Transaction";
    }
}
