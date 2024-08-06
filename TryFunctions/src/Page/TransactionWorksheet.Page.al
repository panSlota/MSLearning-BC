page 150001 "Transaction Worksheet"
{
    ApplicationArea = All;
    Caption = 'Transaction Worksheet';
    PageType = Worksheet;
    SourceTable = "Transaction Worksheet Line";
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
                        TransactionSetup: Record "Transaction Setup";
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
                    ToolTip = 'Specifies the value of the Table ID field.';
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the value of the Table Name field.';
                }
                field("Action Type"; Rec."Action Type")
                {
                    ToolTip = 'Specifies the value of the Action field.';
                }
                field("Run TryFunction"; Rec."Run TryFunction")
                {
                    ToolTip = 'Specifies the value of the Run TryFunction field.';
                }
                field("Consume TryFunction Result"; Rec."Consume TryFunction Result")
                {
                    ToolTip = 'Specifies whether the TryFunction return value should be consumed (i.e. wrapped in a conditional statement or assigned to a variable).';
                    Editable = Rec."Run TryFunction";
                }
                field("Throw Error"; Rec."Throw Error")
                {
                    ToolTip = 'Specifies the value of the Throw Error field.';
                }
                field(Result; Rec.Result)
                {
                    ToolTip = 'Specifies the value of the Result field.';
                    Style = Favorable;
                    StyleExpr = ResultEmphasize;
                }
                field("Result Reason"; Rec."Result Reason")
                {
                    ToolTip = 'Specifies the value of the Result Reason field.';
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
                    ToolTip = 'Specifies the value of the Last Run Time field.';
                }
            }
        }
        area(FactBoxes)
        {
            part("Record PK Values FB"; "Record PK Values FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = field("Table ID"),
                              "Transaction Setup Code" = field("Transaction Setup Code");
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
                        TransactionWorksheetLine: Record "Transaction Worksheet Line";
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
        }
        area(Navigation)
        {
            action("Primary Key Values")
            {
                ApplicationArea = All;
                Caption = 'Primary Key Values';
                ToolTip = 'Opens the primary key values for the selected table.';
                Image = TextFieldConfirm;

                RunObject = page "Record Primary Key Values";
                RunPageLink = "Table ID" = field("Table ID"),
                              "Transaction Setup Code" = field("Transaction Setup Code");
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

            group(Navigation_Promoted)
            {
                Caption = 'Navigation';
                actionref("Primary Key Values_Promoted"; "Primary Key Values") { }
            }

        }
    }

    trigger OnOpenPage()
    var
        TransactionSetup: Record "Transaction Setup";
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
        ResultEmphasize := Rec.Result in [Enum::"Transaction Run Result"::Success, Enum::"Transaction Run Result"::"Success Consumed"];
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewLine(xRec);
    end;

    var
        TransactionWorksheetMgt: Codeunit "Transaction Worksheet Mgt";
        TransactionFunctions: Codeunit "Transaction Functions";
        CurrentTransactionSetupCode: Code[20];
        ResultEmphasize: Boolean;
}
