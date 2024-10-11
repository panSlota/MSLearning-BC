page 150004 "TryFunction Test_tf"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'TryFunction Test';
    PageType = Card;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("TF_Without Error")
            {
                ApplicationArea = All;
                Caption = 'TryFunction Without Error';
                ToolTip = 'Executes a TryFunction without error.';
                Image = Apply;

                trigger OnAction()
                var
                    RunInfo: Dictionary of [Text, Boolean];
                    RunInfoKey: Text;
                    RunInfoTxt: Text;
                    SubstTok: Label '%1: %2\', Comment = '%1 = ThrowError, %2 = ConsumeResult', Locked = true;
                begin
                    Func(true, true, RunInfo);
                    Func(true, false, RunInfo);
                    Func(false, true, RunInfo);
                    Func(false, false, RunInfo);

                    foreach RunInfoKey in RunInfo.Keys() do
                        RunInfoTxt += StrSubstNo(SubstTok, RunInfoKey, RunInfo.Get(RunInfoKey));

                    Message(RunInfoTxt);
                end;
            }
            action("TF_DBWRITE_ERR")
            {
                ApplicationArea = All;
                Caption = 'TryFunction DBWrite Error';
                ToolTip = 'Executes a TryFunction, attempts to modfiy a record and then raises na exception.';
                Image = Error;

                trigger OnAction()
                begin
                    if DBWrite() then;
                end;
            }
            action("Get-NavServerConfiguration::DisableWriteInsideTryFunctions")
            {
                ApplicationArea = All;
                Caption = 'Get-NavServerConfiguration::DisableWriteInsideTryFunctions';
                ToolTip = 'Get-NavServerConfiguration::DisableWriteInsideTryFunctions';
                Image = Text;

                trigger OnAction()
                var
                    TransactionFunctions: Codeunit "Transaction Functions_tf";
                    Config: Text;
                    Disabled: Boolean;
                begin
                    TransactionFunctions.GetDisableWriteInsideTryFunctions(Config, Disabled);
                    Message('Config: %1\Disabled: %2', Config, Disabled);
                end;
            }
            action("MSG")
            {
                ApplicationArea = All;
                Caption = 'Message';
                ToolTip = 'Message';
                Image = Text;

                trigger OnAction()
                begin
                    Message('Hello World');
                end;
            }
        }
        area(Promoted)
        {
            actionref("TF_Without Error_Promoted"; "TF_Without Error") { }
            actionref("TF_DBWRITE_ERR_Promoted"; "TF_DBWRITE_ERR") { }
            actionref("Get-NavServerConfiguration::DisableWriteInsideTryFunctions_Promoted"; "Get-NavServerConfiguration::DisableWriteInsideTryFunctions") { }
        }
    }

    [TryFunction()]
    local procedure DBWrite()
    var
        Customer: Record Customer;
        TransactionFunctions: Codeunit "Transaction Functions_tf";
        Config: Text;
        Disabled: Boolean;
        DeathWarningQst: Label 'This action will end up with the BC instance crash, do you wish to continue? This is caused because the server configuration (%1).', Comment = '%1 = server configuration part';
    begin
        TransactionFunctions.GetDisableWriteInsideTryFunctions(Config, Disabled);

        if Disabled then
            if not Confirm(DeathWarningQst, false, Config) then
                exit;

        Customer.FindFirst();
        Customer.Name += '_MODIFIED';
        Customer.Modify(true);
        Error('');
    end;

    local procedure Func(ThrowError: Boolean; ConsumeResult: Boolean; var RunInfo: Dictionary of [Text, Boolean])
    var
        Result: Boolean;
        InfoLbl: Label 'ThrowError = %1, ConsumeResult = %2', Comment = '%1 = hodi chybu nebo ne, %2 = zpracovat výsledek nebo ne';
    begin
        if ThrowError then begin
            if ConsumeResult then begin
                Result := TryFunc(true);
                RunInfo.Add(StrSubstNo(InfoLbl, true, true), Result);
            end
            else begin
                if TryFunc(true) then;  //aby to nespadlo
                RunInfo.Add(StrSubstNo(InfoLbl, true, false), false);
            end;
        end
        else
            if ConsumeResult then begin
                Result := TryFunc(false);
                RunInfo.Add(StrSubstNo(InfoLbl, false, true), Result);
            end
            else begin
                TryFunc(false);
                RunInfo.Add(StrSubstNo(InfoLbl, false, false), true);
            end;
    end;

    [TryFunction()]
    local procedure TryFunc(ThrowError: Boolean)
    var
        Dividend, Divisor, Result : Decimal;
    begin
        Dividend := 10;

        if ThrowError then
            Divisor := 0
        else
            Divisor := 1;

        Result := Dividend / Divisor;
        Message('Result: %1', Result);
    end;


}
