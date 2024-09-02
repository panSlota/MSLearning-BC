pageextension 150020 "Job Queue Entry Card_jq" extends "Job Queue Entry Card"
{
    actions
    {
        addafter(RunInForeground)
        {
            action("Compute Param. String Hash_jq")
            {
                ApplicationArea = All;
                Caption = 'Compute Param. String Hash';
                ToolTip = 'Computes hash of the parameter string and adds it as the last parameter.';
                Image = CalculateHierarchy;
                Visible = false;

                trigger OnAction()
                var
                    JobQAppSetup: Record "Job Q App Setup_jq";
                    CryptographyManagement: Codeunit "Cryptography Management";
                    JobQueueUtils: Codeunit "Job Queue Utils_jq";
                    Hash: Text;
                    HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
                begin
                    JobQAppSetup.GetRecordOnce();
                    if not JobQAppSetup.Enabled then
                        exit;

                    if Rec."Parameter String".Trim() = '' then
                        exit;

                    if JobQueueUtils.CheckHash(Rec."Parameter String") then
                        exit;

                    Hash := CryptographyManagement.GenerateHash(Rec."Parameter String", HashAlgorithmType::SHA256);
#pragma warning disable AA0139  // zkracuju text
                    Rec."Parameter String" := Rec."Parameter String".TrimEnd(JobQAppSetup."Param. String Separator");
#pragma warning restore AA0139
                    Rec."Parameter String" += JobQAppSetup."Param. String Separator" + Hash;
                    Rec.Modify(true);
                end;
            }
        }
        addafter(RunInForeground_Promoted)
        {
            actionref("Compute Param. String Hash_Promoted_jq"; "Compute Param. String Hash_jq") { }
        }
    }
}
