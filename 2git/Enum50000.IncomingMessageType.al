enum 50000 "Incoming Message Type"
{
    Extensible = true;
    
    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Formal)
    {
        Caption = 'Formal';
    }
    value(2; Casual)
    {
        Caption = 'Casual';
    }
}
