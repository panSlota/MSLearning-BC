codeunit 50101 Events
{
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company Triggers", 'OnCompanyOpen', '', false, false)]
    // local procedure OnCompanyOpen()
    // begin
    //     WorkDate(Today());
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, OnAfterSubstituteReport, '', false, false)]
    local procedure ReportManagement_OnAfterSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = Report::MoveItemLinksToAttachments then
            NewReportId := Report::MoveItemLinksToAttachmentsNew;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", OnRegisterAssistedSetup, '', false, false)]
    local procedure GuidedExperience_OnRegisterAssistedSetup()
    var
        AssistedSetup: Codeunit "Guided Experience";
        GuidedExperienceType: Enum "Guided Experience Type";
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
    begin
        if not AssistedSetup.Exists(GuidedExperienceType::"Assisted Setup", ObjectType::Page, Page::"The Wizard") then
            AssistedSetup.InsertAssistedSetup('The Wizard', 'Here is the task for the team', 'Run The Wizard', 1, ObjectType::Page, Page::"The Wizard", AssistedSetupGroup::Tasks, 'https://www.youtube.com/watch?v=uFU53swvUus', VideoCategory::Learning, '');
    end;
}
