page 150020 "Job Q App Setup_jq"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Job Q App Setup';
    AdditionalSearchTerms = 'Job Queue App Setup';
    PageType = Card;
    SourceTable = "Job Q App Setup_jq";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Param. String Separator"; Rec."Param. String Separator")
                {
                    ToolTip = 'Specifies the char that is used to separate values in the parameter string found in the job queue entry.';
                }
                field("Expected Parameter Count"; Rec."Expected Parameter Count")
                {
                    ToolTip = 'Specifies the count of parameters that are expected to be present in the parameter string.';
                }
                field(Enabled; Rec.Enabled)
                {
                    ToolTip = 'Specifies whether the setup is enabled or not.';
                }
                field("Use Checksum"; Rec."Use Checksum")
                {
                    ToolTip = 'Specifies whether the checksum is used or not. If enabled, the parameter string is expected to contain an extra value (also separated) that represents the hash of the previous parameters.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var

    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
