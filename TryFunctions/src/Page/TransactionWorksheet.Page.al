page 150001 "Transaction Worksheet_tf"
{
    ApplicationArea = All;
    Caption = 'Transaction Worksheet';
    PageType = Worksheet;
    SourceTable = "Transaction Worksheet Line_tf";
    UsageCategory = Administration;
    SaveValues = true;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            group(Setup)
            {
                ShowCaption = false;
                field("Transaction Setup Code"; CurrentTransactionSetupCode)
                {
                    Caption = 'Transaction Setup Code';
                    ToolTip = 'Specifies the code of the setup.';
                    Lookup = true;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        CurrPage.SaveRecord();
                        Rec.LookupTransactionSetupCode(Rec, CurrentTransactionSetupCode);
                        Rec.FilterGroup(2);
                        Rec.SetRange("Transaction Setup Code", CurrentTransactionSetupCode);
                        Rec.FilterGroup(0);
                        CurrPage.Update(false);
                    end;

                    trigger OnValidate()
                    var
                        TransactionSetup: Record "Transaction Setup_tf";
                    begin
                        TransactionSetup.Get(CurrentTransactionSetupCode);
                        Rec.FilterGroup(2);
                        Rec.SetRange("Transaction Setup Code", CurrentTransactionSetupCode);
                        Rec.FilterGroup(0);
                        CurrPage.Update(false);
                    end;
                }
            }
            repeater(Control1)
            {

                field("Table ID"; Rec."Table ID")
                {
                    ToolTip = 'Specifies the ID of the table on which the transaction is being executed.';
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the name of the table.';
                }
                field("Action Type"; Rec."Action Type")
                {
                    ToolTip = 'Specifies the action to perform on the table.';
                }
                field("Run TryFunction"; Rec."Run TryFunction")
                {
                    ToolTip = 'Specifies if the operation should be run inside a TryFunction.';
                }
                field("Consume TryFunction Result"; Rec."Consume TryFunction Result")
                {
                    ToolTip = 'Specifies whether the TryFunction return value should be consumed (i.e. wrapped in a conditional statement or assigned to a variable).';
                    Editable = Rec."Run TryFunction";
                }
                field("Throw Error"; Rec."Throw Error")
                {
                    ToolTip = 'Specifies if an error should be thrown during the transaction.';
                }
                field(Result; Rec.Result)
                {
                    ToolTip = 'Specifies the result of the transaction run.';
                    Style = Favorable;
                    StyleExpr = ResultEmphasize;
                }
                field("Result Reason"; Rec."Result Reason")
                {
                    ToolTip = 'Specifies the reason why the transaction failed.';
                    DrillDown = true;
                    Style = Unfavorable;
                    StyleExpr = Rec."Result Reason" <> '';

                    trigger OnDrillDown()
                    begin
                        if Rec."Result Reason" <> '' then
                            Message(Rec."Result Reason");
                    end;
                }
                field("Last Run Time"; Rec."Last Run Time")
                {
                    ToolTip = 'Specifies the last date and time the transaction has been executed.';
                }
            }
        }
        area(FactBoxes)
        {
            part("Record PK Values FB"; "Record PK Values FactBox_tf")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = field("Table ID"),
                              "Transaction Setup Code" = field("Transaction Setup Code"),
                              "Line No." = field("Line No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Transactions)
            {
                Caption = 'Transactions';

                action("Run Transaction")
                {
                    ApplicationArea = All;
                    Caption = 'Run Transaction';
                    ToolTip = 'Runs the transaction for the selected lines.';
                    Image = Start;

                    trigger OnAction()
                    var
                        TransactionWorksheetLine: Record "Transaction Worksheet Line_tf";
                    begin
                        CurrPage.SetSelectionFilter(TransactionWorksheetLine);
                        TransactionFunctions.Run(TransactionWorksheetLine);
                    end;
                }
                action("Run All Transactions")
                {
                    ApplicationArea = All;
                    Caption = 'Run All Transactions';
                    ToolTip = 'Runs all transactions for the current sheet.';
                    Image = Allocate;

                    trigger OnAction()
                    begin
                        TransactionFunctions.Run(Rec);
                    end;
                }
            }
            action("Suggest Lines")
            {
                ApplicationArea = All;
                Caption = 'Suggest Lines';
                ToolTip = 'Suggests all operations for the current table.';
                Image = SuggestLines;

                trigger OnAction()
                var
                begin
                    TransactionWorksheetMgt.SuggestLines(CurrentTransactionSetupCode);
                end;
            }
            action("Clear Results")
            {
                ApplicationArea = All;
                Caption = 'Clear Results';
                ToolTip = 'Clears all results of the transaction runs from the worksheet.';
                Image = ClearLog;

                trigger OnAction()
                begin
                    TransactionWorksheetMgt.ClearResults(Rec);
                end;
            }
            action("Delete All")
            {
                ApplicationArea = All;
                Caption = 'Delete All';
                ToolTip = 'Deletes all lines from the worksheet.';
                Image = DeleteRow;

                trigger OnAction()
                var
                    TransactionWorksheetLine: Record "Transaction Worksheet Line_tf";
                begin
                    TransactionWorksheetLine.SetRange("Transaction Setup Code", CurrentTransactionSetupCode);
                    if not TransactionWorksheetLine.IsEmpty() then begin
                        TransactionWorksheetLine.DeleteAll(true);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
        area(Navigation)
        {
            action("Primary Key Values")
            {
                ApplicationArea = All;
                Caption = 'Primary Key Values';
                ToolTip = 'Opens the primary key values for the selected table.';
                Image = TextFieldConfirm;
                Scope = Repeater;

                RunObject = page "Record Primary Key Values_tf";
                RunPageLink = "Table ID" = field("Table ID"),
                              "Transaction Setup Code" = field("Transaction Setup Code"),
                              "Line No." = field("Line No.");
            }
        }
        area(Promoted)
        {
            group(Transactions_Promoted)
            {
                Caption = 'Transactions';
                ShowAs = SplitButton;
                actionref("Run Transaction_Promoted"; "Run Transaction") { }
                actionref("Run All Transactions_Promoted"; "Run All Transactions") { }
            }
            actionref("Suggest Lines_Promoted"; "Suggest Lines") { }
            actionref("Clear Results_Promoted"; "Clear Results") { }
            actionref("Delete All_Promoted"; "Delete All") { }

            group(Navigation_Promoted)
            {
                Caption = 'Navigation';
                actionref("Primary Key Values_Promoted"; "Primary Key Values") { }
            }

        }
    }

    trigger OnOpenPage()
    var
        TransactionSetup: Record "Transaction Setup_tf";
    begin
        if CurrentTransactionSetupCode <> '' then
            if not TransactionSetup.Get(CurrentTransactionSetupCode) then begin
                CurrentTransactionSetupCode := '';
                if TransactionSetup.FindFirst() then
                    CurrentTransactionSetupCode := TransactionSetup.Code;
            end;

        Rec.FilterGroup(2);
        Rec.SetRange("Transaction Setup Code", CurrentTransactionSetupCode);
        Rec.FilterGroup(0);
    end;

    trigger OnAfterGetRecord()
    begin
        ResultEmphasize := Rec.Result in [Enum::"Transaction Run Result_tf"::Success, Enum::"Transaction Run Result_tf"::"Success Consumed"];
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewLine(xRec);
    end;

    var
        TransactionWorksheetMgt: Codeunit "Transaction Worksheet Mgt_tf";
        TransactionFunctions: Codeunit "Transaction Functions_tf";
        CurrentTransactionSetupCode: Code[20];
        ResultEmphasize: Boolean;
}
