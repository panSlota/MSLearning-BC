enum 150001 "Transaction Run Result_tf"
{
    Access = Internal;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Success)
    {
        Caption = 'Success';
    }
    value(2; "Success Consumed")
    {
        Caption = 'Success Consumed';
    }
    value(3; Fail)
    {
        Caption = 'Fail';
    }
    value(4; "Fail Consumed")
    {
        Caption = 'Fail Consumed';
    }
}
