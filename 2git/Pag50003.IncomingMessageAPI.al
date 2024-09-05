page 50003 "Incoming Message API"
{
    APIGroup = 'comm';
    APIPublisher = 'donAlberto';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'incomingMessageAPI';
    DelayedInsert = true;
    EntityName = 'incomingMessage';
    EntitySetName = 'incomingMessages';
    PageType = API;
    SourceTable = "Incoming Message";
    ODataKeyFields = ID, Type;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.ID)
                {
                    Caption = 'ID';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(senderID; Rec."Sender ID")
                {
                    Caption = 'Sender ID';
                }
                field(senderName; Rec."Sender Name")
                {
                    Caption = 'Sender Name';
                }
                field(subject; Rec.Subject)
                {
                    Caption = 'Subject';
                }
                field(contentTxt; Rec.Content)
                {
                    Caption = 'Content';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        // z dokumentace - dava to smysl, chci pristupovat jen k datum, ktery uz fakt mam v DB
        Rec.ReadIsolation := IsolationLevel::ReadCommitted;
    end;

    trigger OnAfterGetRecord()
    var
        OutStream: OutStream;
    begin
        Rec."Content Blob".CreateOutStream(OutStream);
        OutStream.WriteText(Rec.Content);
        //TODO: modify?
    end;
}
