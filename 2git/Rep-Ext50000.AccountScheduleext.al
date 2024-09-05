reportextension 50000 "Add Contacts_ext" extends "Add Contacts"
{
    dataset
    {

        add("Interaction Log Entry")
        {
            column(ContactOK; ContactOK) { }
            column(Comment; Comment) { }
        }
        addafter("Interaction Log Entry")
        {
            dataitem("Interaction Group"; "Interaction Group")
            {
                RequestFilterFields = Code;

                column(Code; Code) { }
                column(Description; Description) { }
            }
        }
    }
}
