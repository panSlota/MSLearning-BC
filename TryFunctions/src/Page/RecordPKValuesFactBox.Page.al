page 150003 "Record PK Values FactBox"
{
    ApplicationArea = All;
    Caption = 'Record PK Values FactBox';
    PageType = ListPart;
    SourceTable = "Record Primary Key Value";

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
                field("Type"; Rec."Type Name")
                {
                    ToolTip = 'Specifies the name of the data type of the field.';
                }
                field("Value"; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description.';
                }
            }
        }
    }
}
