page 150002 "Transaction Setup"
{
    ApplicationArea = All;
    Caption = 'Transaction Setup';
    PageType = List;
    SourceTable = "Transaction Setup";
    UsageCategory = Administration;
    DelayedInsert = true;

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
                        SelectionFilterManagement: Codeunit SelectionFilterManagement;
                        AllObjectsWithCaption: Page "All Objects with Caption";
                        AllObjWithCaption: Record AllObjWithCaption;
                    begin
                        AllObjectsWithCaption.LookupMode(true);
                        AllObjWithCaption.FilterGroup(2);
                        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
                        AllObjWithCaption.FilterGroup(0);
                        AllObjectsWithCaption.SetTableView(AllObjWithCaption);
                        if AllObjectsWithCaption.RunModal() = Action::LookupOK then begin
                            Text := AllObjectsWithCaption.GetSelectionFilter();
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
    }
    actions
    {
        area(Navigation)
        {
            action("Primary Key Values")
            {
                ApplicationArea = All;
                Caption = 'Primary Key Values';
                ToolTip = 'Displays the primary key values for the selected table.';
                Image = TextFieldConfirm;
                Visible = PrimaryKeyValuesVisible;

                trigger OnAction()
                var
                    RecordPrimaryKeyValues: Page "Record Primary Key Values";
                    RecordPrimaryKeyValue: Record "Record Primary Key Value";
                begin
                    RecordPrimaryKeyValue.FilterGroup(2);
                    RecordPrimaryKeyValue.SetRange("Transaction Setup Code", Rec.Code);
                    RecordPrimaryKeyValue.SetFilter("Table ID", Rec."ID Filter");
                    RecordPrimaryKeyValue.FilterGroup(0);
                    RecordPrimaryKeyValues.SetTableView(RecordPrimaryKeyValue);
                    RecordPrimaryKeyValues.Run();
                end;
            }
        }
        area(Promoted)
        {
            actionref("Primary Key Values_Promoted"; "Primary Key Values") { }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetFilter("Object ID", Rec."ID Filter");
        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
        PrimaryKeyValuesVisible := AllObjWithCaption.Count() = 1;
    end;

    var
        PrimaryKeyValuesVisible: Boolean;
}
