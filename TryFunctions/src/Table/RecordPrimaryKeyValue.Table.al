table 150000 "Record Primary Key Value_tf"
{
    Caption = 'Record Primary Key Value';
    DataClassification = CustomerContent;
    DrillDownPageId = "Record Primary Key Values_tf";
    LookupPageId = "Record Primary Key Values_tf";
    Access = Internal;

    fields
    {
        field(1; Name; Text[30])
        {
            Caption = 'Name';
            NotBlank = true;

            trigger OnLookup()
            var
                Field: Record Field;
            begin
                Field.SetRange(TableNo, "Table ID");
                Field.SetRange(IsPartOfPrimaryKey, true);
                Field.SetRange(ObsoleteState, Field.ObsoleteState::No);
                Field.SetRange(Class, Field.Class::Normal);
                if Page.RunModal(page::"Fields Lookup", Field) = Action::LookupOK then begin
                    Name := Field.FieldName;
                    CalcFields("Type Name", Type, "Field No.");
                end;
            end;
        }
        field(2; "Type Name"; Text[30])
        {
            Caption = 'Type Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Field."Type Name" where(TableNo = field("Table ID"),
                                                         FieldName = field(Name),
                                                         IsPartOfPrimaryKey = const(true),
                                                         ObsoleteState = const(No)));
            Editable = false;
        }
        field(3; "Transaction Setup Code"; Code[20])
        {
            Caption = 'Transaction Setup Code';
        }
        field(4; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(6; Value; Text[250])
        {
            Caption = 'Value';
        }
        field(7; Position; Integer)
        {
            Caption = 'Position';
        }
        field(8; "Field No."; Integer)
        {
            Caption = 'Field No.';
            FieldClass = FlowField;
            CalcFormula = lookup(Field."No." where(TableNo = field("Table ID"),
                                                      FieldName = field(Name),
                                                      IsPartOfPrimaryKey = const(true),
                                                      ObsoleteState = const(No)));
            Editable = false;
        }
        field(9; Type; Option)
        {
            Caption = 'Type';
            FieldClass = FlowField;
            CalcFormula = lookup(Field.Type where(TableNo = field("Table ID"),
                                                 FieldName = field(Name),
                                                 IsPartOfPrimaryKey = const(true),
                                                 ObsoleteState = const(No)));
            OptionMembers = TableFilter,RecordID,OemText,Date,Time,DateFormula,Decimal,Media,MediaSet,Text,Code,Binary,BLOB,Boolean,Integer,OemCode,Option,BigInteger,Duration,GUID,DateTime;
            Editable = false;
        }
        field(10; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
    }
    keys
    {
        key(PK; Name, "Table ID", "Transaction Setup Code", "Line No.")
        {
            Clustered = true;
        }
        key(FK1; Position) { }
    }
}
