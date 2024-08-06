table 150002 "Transaction Setup"
{
    Caption = 'Transaction Setup';
    DataClassification = CustomerContent;
    DrillDownPageId = "Transaction Setup";
    LookupPageId = "Transaction Setup";
    Access = Internal;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; "ID Filter"; Text[250])
        {
            Caption = 'ID Filter';
        }
        field(3; "Default Action"; Enum "Record Action Type")
        {
            Caption = 'Default Action';
        }
        field(4; "Run TryFunction"; Boolean)
        {
            Caption = 'Run TryFunction';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        RecordPrimaryKeyValue: Record "Record Primary Key Value";
        TransactionWorksheetLine: Record "Transaction Worksheet Line";
        ConfirmManagement: Codeunit "Confirm Management";
        DeleteSetupQst: Label 'Do you want to delete the setup %1?', Comment = '%1 = Setup Code';
    begin
        if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(DeleteSetupQst, Code), false) then
            exit;

        RecordPrimaryKeyValue.SetFilter("Table ID", "ID Filter");
        RecordPrimaryKeyValue.SetRange("Transaction Setup Code", Code);
        RecordPrimaryKeyValue.DeleteAll(true);

        TransactionWorksheetLine.SetRange("Transaction Setup Code", Code);
        TransactionWorksheetLine.DeleteAll(true);
    end;
}
