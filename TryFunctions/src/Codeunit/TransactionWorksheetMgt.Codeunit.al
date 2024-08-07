codeunit 150001 "Transaction Worksheet Mgt_tf"
{
    Access = Internal;

    procedure ClearResults(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    begin
        TransactionWorksheetLine.Result := Enum::"Transaction Run Result_tf"::" ";
        TransactionWorksheetLine."Result Reason" := '';
        TransactionWorksheetLine.ModifyAll(Result, Enum::"Transaction Run Result_tf"::" ");
        TransactionWorksheetLine.ModifyAll("Result Reason", '');
    end;

    procedure SuggestLines(TransactionSetupCode: Code[20])
    var
        TransactionWorksheetLine, TransactionWorksheetLine2 : Record "Transaction Worksheet Line_tf";
        TempTransactionWorksheetLine: Record "Transaction Worksheet Line_tf" temporary;
        LastLineNo: Integer;
    begin
        DeleteLines(TransactionSetupCode);

        InsertLinesFromSetup(TransactionSetupCode);
        LastLineNo := GetLastLineNo(TransactionSetupCode);

        TransactionWorksheetLine.SetRange("Transaction Setup Code", TransactionSetupCode);

        if TransactionWorksheetLine.FindSet() then
            repeat
                TempTransactionWorksheetLine.Reset();
                TempTransactionWorksheetLine.Init();
                TempTransactionWorksheetLine."Transaction Setup Code" := TransactionWorksheetLine."Transaction Setup Code";
                TempTransactionWorksheetLine."Line No." := LastLineNo + 10000;
                ValidateLineFields(TempTransactionWorksheetLine,
                                   TransactionWorksheetLine."Table ID",
                                   TransactionWorksheetLine."Action Type",
                                   not TransactionWorksheetLine."Run TryFunction",
                                   TransactionWorksheetLine."Consume TryFunction Result");

                LastLineNo += 10000;
                TempTransactionWorksheetLine.Insert(true);

                TempTransactionWorksheetLine.Reset();
                TempTransactionWorksheetLine.Init();
                TempTransactionWorksheetLine."Transaction Setup Code" := TransactionWorksheetLine."Transaction Setup Code";
                TempTransactionWorksheetLine."Line No." := LastLineNo + 10000;
                ValidateLineFields(TempTransactionWorksheetLine,
                                   TransactionWorksheetLine."Table ID",
                                   TransactionWorksheetLine."Action Type",
                                   not TransactionWorksheetLine."Run TryFunction",
                                   not TransactionWorksheetLine."Consume TryFunction Result");

                LastLineNo += 10000;
                TempTransactionWorksheetLine.Insert(true);
            until TransactionWorksheetLine.Next() = 0;

        TempTransactionWorksheetLine.FindSet();
        repeat
            TransactionWorksheetLine2.Reset();
            TransactionWorksheetLine2.Init();
            TransactionWorksheetLine2 := TempTransactionWorksheetLine;
            TransactionWorksheetLine2.Insert(true);
        until TempTransactionWorksheetLine.Next() = 0;
    end;

    procedure CheckDefinedPKValues(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        RecordPrimaryKeyValue: Record "Record Primary Key Value_tf";
        Field: Record Field;
        UserPKCount, DefinedPKCount : Integer;
    begin
        TransactionWorksheetLine.FindSet();
        repeat
            RecordPrimaryKeyValue.SetRange("Table ID", TransactionWorksheetLine."Table ID");
            RecordPrimaryKeyValue.SetRange("Transaction Setup Code", TransactionWorksheetLine."Transaction Setup Code");
            RecordPrimaryKeyValue.SetFilter(Value, '<>%1', ''); //nejen, ze tam musi to pole byt definovano, ale k tomu nesmi byt prazdne
            UserPKCount := RecordPrimaryKeyValue.Count();

            Field.SetRange(TableNo, TransactionWorksheetLine."Table ID");
            Field.SetRange(IsPartOfPrimaryKey, true);
            DefinedPKCount := Field.Count();

            TransactionWorksheetLine."Defined PK Checked" := true;
            TransactionWorksheetLine."No. of PK Fields Missing" := 0;

            if UserPKCount <> DefinedPKCount then
                TransactionWorksheetLine."No. of PK Fields Missing" := DefinedPKCount - UserPKCount;

            TransactionWorksheetLine.Modify(true);
        until TransactionWorksheetLine.Next() = 0;
    end;

    local procedure InsertLinesFromSetup(TransactionSetupCode: Code[20])
    var
        TransactionSetup: Record "Transaction Setup_tf";
        AllObjWithCaption: Record AllObjWithCaption;
        TransactionWorksheetLine: Record "Transaction Worksheet Line_tf";
        ConsumeTryFunctionResult: Boolean;
        LastTransactionWorksheetLineNo: Integer;
    begin
        if TransactionSetupCode = '' then
            exit;

        LastTransactionWorksheetLineNo := GetLastLineNo(TransactionSetupCode);

        TransactionSetup.Get(TransactionSetupCode);
        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
        AllObjWithCaption.SetFilter("Object ID", TransactionSetup."ID Filter");
        if AllObjWithCaption.FindSet() then
            repeat
                if not LineExists(TransactionSetupCode,
                                  AllObjWithCaption."Object ID",
                                  TransactionSetup."Default Action",
                                  TransactionSetup."Run TryFunction",
                                  ConsumeTryFunctionResult) then begin

                    TransactionWorksheetLine.Reset();
                    TransactionWorksheetLine.Init();
                    TransactionWorksheetLine."Transaction Setup Code" := TransactionSetupCode;
                    TransactionWorksheetLine."Line No." := LastTransactionWorksheetLineNo + 10000;
                    ValidateLineFields(TransactionWorksheetLine,
                                       AllObjWithCaption."Object ID",
                                       TransactionSetup."Default Action",
                                       TransactionSetup."Run TryFunction",
                                       ConsumeTryFunctionResult);
                    TransactionWorksheetLine.Insert(true);

                    LastTransactionWorksheetLineNo += 10000;
                end;
            until AllObjWithCaption.Next() = 0;
    end;

    local procedure DeleteLines(TransactionSetupCode: Code[20])
    var
        TransactionWorksheetLine: Record "Transaction Worksheet Line_tf";
    begin
        TransactionWorksheetLine.SetRange("Transaction Setup Code", TransactionSetupCode);
        if not TransactionWorksheetLine.IsEmpty() then
            TransactionWorksheetLine.DeleteAll(true);
    end;

    local procedure LineExists
    (
        TransactionSetupCode: Code[20];
        TableID: Integer;
        ActionType: Enum "Record Action Type_tf";
        RunTryFunction: Boolean;
        var ConsumeTryFunctionResult: Boolean
    ) Exists: Boolean
    var
        TransactionWorksheetLine: Record "Transaction Worksheet Line_tf";
        LineExistsConsumeFalse, LineExistsConsumeTrue : Boolean;
    begin
        TransactionWorksheetLine.SetRange("Transaction Setup Code", TransactionSEtupCode);
        TransactionWorksheetLine.SetRange("Table ID", TableID);
        TransactionWorksheetLine.SetRange("Action Type", ActionType);
        TransactionWorksheetLine.SetRange("Run TryFunction", RunTryFunction);
        TransactionWorksheetLine.SetRange("Consume TryFunction Result", false);

        LineExistsConsumeFalse := not TransactionWorksheetLine.IsEmpty();

        TransactionWorksheetLine.SetRange("Consume TryFunction Result", true);

        LineExistsConsumeTrue := not TransactionWorksheetLine.IsEmpty();

        if LineExistsConsumeFalse and LineExistsConsumeTrue then begin
            Exists := true;
            exit;
        end;

        if LineExistsConsumeFalse then
            ConsumeTryFunctionResult := true
        else
            if LineExistsConsumeTrue then
                ConsumeTryFunctionResult := false;
    end;

    local procedure ValidateLineFields
    (
        var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf";
        TableID: Integer;
        RecordActionType: Enum "Record Action Type_tf";
        RunTryFunction: Boolean;
        ConsumeTryFunctionResult: Boolean
    )
    begin
        TransactionWorksheetLine."Table ID" := TableID;
        TransactionWorksheetLine."Action Type" := RecordActionType;
        TransactionWorksheetLine."Run TryFunction" := RunTryFunction;
        if RunTryFunction then
            TransactionWorksheetLine."Consume TryFunction Result" := ConsumeTryFunctionResult
        else
            TransactionWorksheetLine."Consume TryFunction Result" := false;
    end;

    local procedure GetLastLineNo(TransactionSetupCode: Code[20]): Integer
    var
        TransactionWorksheetLine: Record "Transaction Worksheet Line_tf";
    begin
        TransactionWorksheetLine.SetRange("Transaction Setup Code", TransactionSetupCode);
        if TransactionWorksheetLine.FindLast() then
            exit(TransactionWorksheetLine."Line No.");
    end;
}
