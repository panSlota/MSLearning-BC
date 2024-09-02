permissionset 150020 JQPermissions_jq
{
    Assignable = true;
    Permissions = report "Scheduled Report_jq" = X,
        codeunit "Scheduled Procedure_jq" = X,
        codeunit "Job Queue Utils_jq" = X,
        tabledata "Job Q App Setup_jq" = RIMD,
        table "Job Q App Setup_jq" = X,
        page "Job Q App Setup_jq" = X;
}