table 150020 "Job Q App Setup_jq"
{
    Caption = 'Job Q App Setup';
    DataClassification = CustomerContent;
    Access = Internal;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Param. String Separator"; Text[1])
        {
            Caption = 'Param. String Separator';
        }
        field(3; "Expected Parameter Count"; Integer)
        {
            Caption = 'Expected Parameter Count';
            MinValue = 0;
        }
        field(4; Enabled; Boolean)
        {
            Caption = 'Enabled';
        }
        field(5; "Use Checksum"; Boolean)
        {
            Caption = 'Use Checksum';
        }
        field(6; "Hash Algorithm Type"; Option)
        {
            Caption = 'Hash Algorithm Type';
            OptionMembers = MD5,SHA1,SHA256,SHA384,SHA512;
            OptionCaption = 'MD5,SHA1,SHA256,SHA384,SHA512', Locked = true;
            InitValue = SHA256;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        RecordHasBeenRead: Boolean;

    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;

        Get();
        RecordHasBeenRead := true;
    end;
}
