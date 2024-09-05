codeunit 50002 "Notification Actions"
{
    procedure UpdateContent(Notification: Notification)
    var
        IncomingMessage: Record "Incoming Message";
        ContentOutStream: OutStream;
        MessageID: Integer;
        MessageType: Enum "Incoming Message Type";
        MessageTypeInt: Integer;
        MessageTxt: Text;
    begin
        Evaluate(MessageID, Notification.GetData('Message ID'));
        Evaluate(MessageTypeInt, Notification.GetData('Message Type'));
        MessageType := Enum::"Incoming Message Type".FromInteger(MessageTypeInt);

        IncomingMessage.Get(MessageID, MessageType);
        IncomingMessage.CalcFields("Content Blob");
        IncomingMessage."Content Blob".CreateOutStream(ContentOutStream);
        MessageTxt := IncomingMessage.Content;
        ContentOutStream.WriteText(MessageTxt);
        IncomingMessage.Modify();
    end;
}
