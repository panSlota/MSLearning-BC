report 50001 MoveItemLinksToAttachmentsNew
{
    ApplicationArea = All;
    Caption = 'MoveItemLinksToAttachmentsNew';
    // UsageCategory = Administration;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {

        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        Message('SUBSTITUTED');
    end;
}
