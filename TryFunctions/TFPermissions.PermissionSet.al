permissionset 150000 "TF Permissions_tf"
{
    Assignable = true;
    Permissions = tabledata "Record Primary Key Value_tf" = RIMD,
        tabledata "Transaction Setup_tf" = RIMD,
        tabledata "Transaction Worksheet Line_tf" = RIMD,
        table "Record Primary Key Value_tf" = X,
        table "Transaction Setup_tf" = X,
        table "Transaction Worksheet Line_tf" = X,
        codeunit "Delete Transaction_tf" = X,
        codeunit "Empty Transaction_tf" = X,
        codeunit "Insert Transaction_tf" = X,
        codeunit "Modify Transaction_tf" = X,
        codeunit "Read Transaction_tf" = X,
        codeunit "Transaction Functions_tf" = X,
        codeunit "Transaction Worksheet Mgt_tf" = X,
        page "Record PK Values FactBox_tf" = X,
        page "Record Primary Key Values_tf" = X,
        page "Transaction Setup_tf" = X,
        page "Transaction Worksheet_tf" = X;
}
