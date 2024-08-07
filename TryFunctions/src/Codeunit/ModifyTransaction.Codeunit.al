codeunit 150004 "Modify Transaction_tf" implements ITransactionType_tf
{
    Access = Internal;

    var
        TransactionFunctions: Codeunit "Transaction Functions_tf";
        ProcessNameLbl: Label 'modify';

    procedure Process(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    var
        Field: Record Field;
        RecRefToModify: RecordRef;
        Value: Text;
    begin
        TransactionFunctions.GetRecordRef(RecRefToModify, TransactionWorksheetLine);
        Field.SetRange(TableNo, TransactionWorksheetLine."Table ID");
        Field.SetRange(IsPartOfPrimaryKey, false);
        Field.SetRange(Enabled, true);
        Field.SetRange(ObsoleteState, Field.ObsoleteState::No);
        Field.SetRange(Class, Field.Class::Normal);
        Field.SetFilter(Type, '%1|%2', Field.Type::Code, Field.Type::Text);
        if Field.FindFirst() then begin
            Value := RecRefToModify.Field(Field."No.").Value();
            Value += '_MOD';
            Value := CopyStr(Value, 1, Field.Len);
            TransactionFunctions.ValidateRecordRefField(RecRefToModify, Field."No.", Value, Field.Type, Field.Len);
            RecRefToModify.Modify(true);
        end;
    end;

    procedure ProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var ErrInfo: ErrorInfo)
    begin
        Process(TransactionWorksheetLine);
        ErrInfo := ErrorInfo.Create(TransactionFunctions.GetProcessError(ProcessNameLbl));
    end;

    procedure TFProcess(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"): Boolean
    begin
        exit(RTFProcess(TransactionWorksheetLine));
    end;

    procedure TFProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var ErrInfo: ErrorInfo): Boolean;
    begin
        exit(RTFProcessError(TransactionWorksheetLine, ErrInfo));
    end;

    [TryFunction]
    local procedure RTFProcess(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf")
    begin
        Process(TransactionWorksheetLine);
    end;

    [TryFunction]
    local procedure RTFProcessError(var TransactionWorksheetLine: Record "Transaction Worksheet Line_tf"; var ErrInfo: ErrorInfo)
    begin
        ProcessError(TransactionWorksheetLine, ErrInfo);
    end;
}
