codeunit 150001 "Transaction Worksheet Mgt"
{
    Access = Internal;

    procedure ClearResults(var TransactionWorksheetLine: Record "Transaction Worksheet Line")
    begin
        TransactionWorksheetLine.Result := Enum::"Transaction Run Result"::" ";
        TransactionWorksheetLine."Result Reason" := '';
        TransactionWorksheetLine.ModifyAll(Result, Enum::"Transaction Run Result"::" ");
        TransactionWorksheetLine.ModifyAll("Result Reason", '');
    end;

    procedure SuggestLines(TransactionSetupCode: Code[20])
    var
        TransactionWorksheetLine, TransactionWorksheetLine2 : Record "Transaction Worksheet Line";
        TempTransactionWorksheetLine: Record "Transaction Worksheet Line" temporary;
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

    local procedure InsertLinesFromSetup(TransactionSetupCode: Code[20])
    var
        TransactionSetup: Record "Transaction Setup";
        AllObjWithCaption: Record AllObjWithCaption;
        TransactionWorksheetLine: Record "Transaction Worksheet Line";
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
        TransactionWorksheetLine: Record "Transaction Worksheet Line";
    begin
        TransactionWorksheetLine.SetRange("Transaction Setup Code", TransactionSetupCode);
        if not TransactionWorksheetLine.IsEmpty() then
            TransactionWorksheetLine.DeleteAll(true);
    end;

    local procedure LineExists
    (
        TransactionSetupCode: Code[20];
        TableID: Integer;
        ActionType: Enum "Record Action Type";
        RunTryFunction: Boolean;
        var ConsumeTryFunctionResult: Boolean
    ) Exists: Boolean
    var
        TransactionWorksheetLine: Record "Transaction Worksheet Line";
        LineExistsFalse, LineExistsTrue : Boolean;
    begin
        TransactionWorksheetLine.SetRange("Transaction Setup Code", TransactionSEtupCode);
        TransactionWorksheetLine.SetRange("Table ID", TableID);
        TransactionWorksheetLine.SetRange("Action Type", ActionType);
        TransactionWorksheetLine.SetRange("Run TryFunction", RunTryFunction);
        TransactionWorksheetLine.SetRange("Consume TryFunction Result", false);

        LineExistsFalse := not TransactionWorksheetLine.IsEmpty();

        TransactionWorksheetLine.SetRange("Consume TryFunction Result", true);

        LineExistsTrue := not TransactionWorksheetLine.IsEmpty();

        if LineExistsFalse and LineExistsTrue then begin
            Exists := true;
            exit;
        end;

        if LineExistsFalse then
            ConsumeTryFunctionResult := true
        else if LineExistsTrue then
            ConsumeTryFunctionResult := false;
    end;

    local procedure ValidateLineFields
    (
        var TransactionWorksheetLine: Record "Transaction Worksheet Line";
        TableID: Integer;
        RecordActionType: Enum "Record Action Type";
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
        TransactionWorksheetLine: Record "Transaction Worksheet Line";
    begin
        TransactionWorksheetLine.SetRange("Transaction Setup Code", TransactionSetupCode);
        if TransactionWorksheetLine.FindLast() then
            exit(TransactionWorksheetLine."Line No.");
    end;
}
