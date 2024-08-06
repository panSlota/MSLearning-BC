page 150000 "Record Primary Key Values"
{
    ApplicationArea = All;
    Caption = 'Record Primary Key Values';
    PageType = List;
    SourceTable = "Record Primary Key Value";
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
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Type"; Rec."Type Name")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Value"; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the Value field.';
                }
                field(Position; Rec.Position)
                {
                    ToolTip = 'Specifies the value of the Position field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}
