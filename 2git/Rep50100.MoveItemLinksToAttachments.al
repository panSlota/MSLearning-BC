report 50100 MoveItemLinksToAttachments
{
    ApplicationArea = All;
    Caption = 'MoveItemLinksToAttachments';
    UsageCategory = Administration;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                MoveLinkToAttachment(Item);
            end;
        }
    }

    local procedure MoveLinkToAttachment(var Item: Record Item)
    var
        RecordLink, RecordLinkToDelete : Record "Record Link";
        DocumentAttachment, DocumentAttachment2 : Record "Document Attachment";
        DocumentAttachmentDetails: Page "Document Attachment Details";
        Links: List of [Text[2048]];
        Link: Text[2048];
        FileName: Text[250];
        Extension: Text[30];
        i: Integer;
        TempBlob: Codeunit "Temp Blob";
        AddOnIntegrManagement: Codeunit 5403;
    begin
        RecordLink.SetRange("Record ID", Item.RecordId());
        if not RecordLink.FindSet() then
            exit;

        repeat
            if Exists(RecordLink.URL1) then begin
                ParseUrl(RecordLink.URL1, FileName, Extension);
                DocumentAttachment.SetRange("File Name", FileName);
                DocumentAttachment.SetRange("File Extension", Extension);
                DocumentAttachment.SetRange("No.", Item."No.");
                DocumentAttachment.SetRange("Table ID", Database::Item);
                DocumentAttachment.SetRange("Line No.", 0);
                DocumentAttachment.SetRange("Document Type", Enum::"Attachment Document Type"::Quote);

                if DocumentAttachment.IsEmpty() then begin
                    DocumentAttachment2.Reset();
                    DocumentAttachment2.Init();
                    DocumentAttachment2.Validate("No.", Item."No.");
                    DocumentAttachment2.Validate("File Name", FileName);
                    DocumentAttachment2.Validate("File Extension", Extension);
                    DocumentAttachment2.Validate("Table ID", Database::Item);
                    DocumentAttachment2.Validate("Line No.", 0);
                    DocumentAttachment2.Validate("Document Type", Enum::"Attachment Document Type"::Quote);
                    DocumentAttachment2."Document Reference ID".ImportFile(RecordLink.URL1, FileName);
                    DocumentAttachment2.Insert(true);
                end;

                RecordLinkToDelete.Get(RecordLink."Link ID");
                RecordLinkToDelete.Delete(true);
            end;
        until RecordLink.Next() = 0;
    end;

    /// <summary>
    /// rozdeli adresu z recordLiku na fileName &amp; priponu
    /// </summary>
    /// <param name="Url">cela adresa</param>
    /// <param name="FileName">nazev souboru</param>
    /// <param name="Extension">pripona</param>
    local procedure ParseUrl(Url: Text[2048]; var FileName: Text[250]; var Extension: Text[30])
    var
        FileManagement: Codeunit "File Management";
    begin
        FileName := FileManagement.GetFileNameWithoutExtension(Url);
        Extension := FileManagement.GetExtension(Url);
    end;
}
