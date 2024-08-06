pageextension 150000 "All Objects with Caption_ext" extends "All Objects with Caption"
{

    procedure GetSelectionFilter() Filter: Text
    var
        AllObjWithCaption: Record AllObjWithCaption;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
    begin
        CurrPage.SetSelectionFilter(AllObjWithCaption);
        RecRef.GetTable(AllObjWithCaption);
        Filter := SelectionFilterManagement.GetSelectionFilter(RecRef, AllObjWithCaption.FieldNo("Object ID"));
    end;

}
