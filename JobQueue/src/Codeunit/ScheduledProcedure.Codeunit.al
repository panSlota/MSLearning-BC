codeunit 150020 "Scheduled Procedure_jq"
{
    TableNo = "Job Queue Entry";
    Access = Internal;

    trigger OnRun()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.Copy(Rec);
        Code(JobQueueEntry);
        Rec := JobQueueEntry;
    end;

    var
        JobQAppSetup: Record "Job Q App Setup_jq";
        JobQueueUtils: Codeunit "Job Queue Utils_jq";

    local procedure "Code"(var JobQueueEntry: Record "Job Queue Entry")
    var
        Parameters: List of [Text];
    begin
        JobQAppSetup.GetRecordOnce();
        Parameters := JobQueueUtils.ParseParameterString(JobQueueEntry."Parameter String");
        CheckParametersDataTypes(Parameters);
    end;

    local procedure CheckParametersDataTypes(Parameters: List of [Text])
    var

    begin
        Error('f:%1', Parameters);
    end;

}
