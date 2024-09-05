codeunit 50001 ErrorHandler
{
    Access = Internal;

    procedure HandleErrorRaisedByWizard(var ErrorInfo: ErrorInfo)
    var
        Callstack: Text;
        ErrorOccurredMsg: Label 'An error has occurred, the callstack is:\%1', Comment = '%1 = callstack';
    begin
        Callstack := ErrorInfo.CallStack();
        Message(ErrorOccurredMsg, Callstack);
    end;

    procedure AddAction(var ErrorInfo: ErrorInfo)
    var
        DisplayCallStackLbl: Label 'Display Call Stack';
    begin
        ErrorInfo.Verbosity(Verbosity::Verbose);
        ErrorInfo.AddAction(DisplayCallStackLbl, Codeunit::ErrorHandler, 'HandleErrorRaisedByWizard');
    end;
}
