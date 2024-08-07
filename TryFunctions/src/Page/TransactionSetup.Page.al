page 150002 "Transaction Setup_tf"
{
    ApplicationArea = All;
    Caption = 'Transaction Setup';
    PageType = List;
    SourceTable = "Transaction Setup_tf";
    UsageCategory = Administration;
    DelayedInsert = true;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the code of the setup.';
                }
                field("ID Filter"; Rec."ID Filter")
                {
                    ToolTip = 'Specifies the Object ID filter for the tables.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AllObjWithCaption: Record AllObjWithCaption;
                        AllObjectsWithCaption: Page "All Objects with Caption";
                    begin
                        AllObjectsWithCaption.LookupMode(true);
                        AllObjWithCaption.FilterGroup(2);
                        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
                        AllObjWithCaption.FilterGroup(0);
                        AllObjectsWithCaption.SetTableView(AllObjWithCaption);
                        if AllObjectsWithCaption.RunModal() = Action::LookupOK then begin
                            Text := AllObjectsWithCaption.GetSelectionFilter_tf();
                            Rec."ID Filter" := CopyStr(Text, 1, MaxStrLen(Rec."ID Filter"));
                            exit(true);
                        end
                        else
                            exit(false);
                    end;
                }
                field("Default Action"; Rec."Default Action")
                {
                    ToolTip = 'Specifies the default aciton. This action is applied when suggesting lines in the worksheet.';
                }
                field("Run TryFunction"; Rec."Run TryFunction")
                {
                    ToolTip = 'Specifies if the operation should be run inside a TryFunction.';
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1000001; Notes) { }
            systempart(Control1000002; Links) { }
        }
    }
}
