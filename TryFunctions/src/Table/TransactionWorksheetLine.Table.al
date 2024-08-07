table 150001 "Transaction Worksheet Line_tf"
{
    Caption = 'Transaction Worksheet Line';
    DataClassification = CustomerContent;
    Access = Internal;

    fields
    {
        field(1; "Transaction Setup Code"; Code[20])
        {
            Caption = 'Transaction Setup Code';
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            NotBlank = true;
            Editable = false;
        }
        field(3; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(4; "Table Name"; Text[30])
        {
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Table),
                                                                       "Object ID" = field("Table ID")));
        }
        field(5; "Action Type"; Enum "Record Action Type_tf")
        {
            Caption = 'Action';
        }
        field(6; Result; Enum "Transaction Run Result_tf")
        {
            Caption = 'Result';
            Editable = false;
        }
        field(7; "Result Reason"; Text[250])
        {
            Caption = 'Result Reason';
            Editable = false;
        }
        field(8; "Run TryFunction"; Boolean)
        {
            Caption = 'Run TryFunction';

            trigger OnValidate()
            begin
                if not "Run TryFunction" then
                    "Consume TryFunction Result" := false;
            end;
        }
        field(9; "Consume TryFunction Result"; Boolean)
        {
            Caption = 'Consume TryFunction Result';
        }
        field(10; "Last Run Time"; DateTime)
        {
            Caption = 'Last Run Time';
            Editable = false;
        }
        field(11; "Throw Error"; Boolean)
        {
            Caption = 'Throw Error';
        }
    }
    keys
    {
        key(PK; "Transaction Setup Code", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        myInt := 3;
    end;

    var
        TransactionWorksheetMgt: Codeunit "Transaction Worksheet Mgt_tf";

    procedure LookupTransactionSetupCode(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var TransactionSetupCode: Code[20])
    var
        TransactionSetup: Record "Transaction Setup_tf";
        CurrentFilterGroup: Integer;
    begin
        if Page.RunModal(page::"Transaction Setup_tf", TransactionSetup) = Action::LookupOK then
            TransactionSetupCode := TransactionSetup.Code;

        CurrentFilterGroup := TransactionWorksheetLine.FilterGroup();
        TransactionWorksheetLine.FilterGroup(2);
        TransactionWorksheetLine.SetRange("Transaction Setup Code", TransactionSetupCode);
        TransactionWorksheetLine.FilterGroup(CurrentFilterGroup);
    end;

    procedure SetupNewLine(var LastTransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
    begin
        "Transaction Setup Code" := LastTransactionWorksheetLine."Transaction Setup Code";
        "Action Type" := LastTransactionWorksheetLine."Action Type";
    end;
}
