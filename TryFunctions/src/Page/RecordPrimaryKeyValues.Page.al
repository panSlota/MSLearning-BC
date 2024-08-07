page 150000 "Record Primary Key Values_tf"
{
    ApplicationArea = All;
    Caption = 'Record Primary Key Values';
    PageType = List;
    SourceTable = "Record Primary Key Value_tf";
    UsageCategory = None;
    DelayedInsert = true;
    SourceTableView = sorting(Position) order(ascending);

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the field.';
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the number of the field.';
                }
                field("Type"; Rec."Type Name")
                {
                    ToolTip = 'Specifies the name of the data type of the field.';
                }
                field("Value"; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the field.';
                }
                field(Position; Rec.Position)
                {
                    ToolTip = 'Specifies the position of the field in the primary key.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description.';
                }
            }
        }
    }
}
