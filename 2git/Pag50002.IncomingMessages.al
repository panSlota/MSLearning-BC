page 50002 "Incoming Messages"
{
    ApplicationArea = All;
    Caption = 'Incoming Messages';
    PageType = List;
    SourceTable = "Incoming Message";
    UsageCategory = Lists;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ToolTip = 'Specifies the value of the Sender ID field.', Comment = '%';
                }
                field("Sender Name"; Rec."Sender Name")
                {
                    ToolTip = 'Specifies the value of the Sender Name field.', Comment = '%';
                }
                field(Subject; Rec.Subject)
                {
                    ToolTip = 'Specifies the value of the Subject field.', Comment = '%';
                }
                field(Content_txt; Rec.Content)
                {
                    ToolTip = 'Specifies the value of the Content field.', Comment = '%';
                }
                field(Attachment; Format(Rec.Attachment))
                {
                    ToolTip = 'Specifies the value of the Attachment field.', Comment = '%';
                    Caption = 'Attachment';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(DownloadContent)
            {
                ApplicationArea = All;
                Caption = 'Download Content';
                ToolTip = 'Downloads the subject and content of the message.';
                Image = Download;

                trigger OnAction()
                var
                    ContentStream: InStream;
                    ToFile: Text;
                begin
                    Rec."Content Blob".CreateInStream(ContentStream);
                    DownloadFromStream(ContentStream, '', '', '', ToFile);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ShowNotifications();
    end;

    local procedure ShowNotifications()
    var
        IncomingMessage: Record "Incoming Message";
        Notification: Notification;
        NoContentLbl: Label 'The message (%1, %2) has no BLOB content.', Comment = '%1 = Message ID, %2 = Message Type';
        UpdateContentLbl: Label 'Update content';
    begin
        if not IncomingMessage.FindSet() then
            exit;

        IncomingMessage.SetAutoCalcFields("Content Blob");
        repeat
            if not IncomingMessage."Content Blob".HasValue() then begin
                Notification.Message := StrSubstNo(NoContentLbl, Format(IncomingMessage.ID), Format(IncomingMessage."Type".AsInteger()));
                Notification.SetData('Message ID', Format(IncomingMessage.ID));
                Notification.SetData('Message Type', Format(IncomingMessage."Type".AsInteger()));
                Notification.AddAction(UpdateContentLbl, Codeunit::"Notification Actions", 'UpdateContent');
                Notification.Send();
            end;
        until IncomingMessage.Next() = 0;
    end;
}
