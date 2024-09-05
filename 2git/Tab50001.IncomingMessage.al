table 50001 "Incoming Message"
{
    Caption = 'Incoming Message';
    DataClassification = CustomerContent;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
        }
        field(2; "Type"; Enum "Incoming Message Type")
        {
            Caption = 'Type';
        }
        field(3; "Sender ID"; Integer)
        {
            Caption = 'Sender ID';
        }
        field(4; "Sender Name"; Text[250])
        {
            Caption = 'Sender Name';
        }
        field(5; Subject; Text[250])
        {
            Caption = 'Subject';
        }
        field(6; Content; Text[2048])
        {
            Caption = 'Content';
        }
        field(7; "Content Blob"; Blob)
        {
            Caption = 'Content Blob';
        }
        field(8; Attachment; Blob)
        {
            Caption = 'Attachment';
        }
    }
    keys
    {
        key(PK; ID, Type)
        {
            Clustered = true;
        }
    }
}
