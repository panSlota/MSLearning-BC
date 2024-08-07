enum 150000 "Record Action Type_tf" implements ITransactionType_tf
{
    DefaultImplementation = ITransactionType_tf = "Empty Transaction_tf";
    UnknownValueImplementation = ITransactionType_tf = "Empty Transaction_tf";
    Access = Internal;

    value(0;
    " ")
    {
        Caption = ' ';
    }
    value(1; Read)
    {
        Caption = 'Read';
        Implementation = ITransactionType_tf = "Read Transaction_tf";
    }
    value(2; Insert)
    {
        Caption = 'Insert';
        Implementation = ITransactionType_tf = "Insert Transaction_tf";
    }
    value(3; "Modify")
    {
        Caption = 'Modify';
        Implementation = ITransactionType_tf = "Modify Transaction_tf";
    }
    value(4; Delete)
    {
        Caption = 'Delete';
        Implementation = ITransactionType_tf = "Delete Transaction_tf";
    }
}
