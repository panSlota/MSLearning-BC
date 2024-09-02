page 150021 "Plan Job_jq"
{
    ApplicationArea = All;
    Caption = 'Plan Job';
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "Job Queue Entry";
    SourceTableTemporary = true;
    Editable = false;
    Extensible = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Object Type to Run"; Rec."Object Type to Run")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of object that is to be run.';
                }
                field("Object ID to Run"; Rec."Object ID to Run")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the object that is to be run.';
                }
                field("Object Caption to Run"; Rec."Object Caption to Run")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the caption of the object that is to be run.';
                }
                field("Maximum No. of Attempts to Run"; Rec."Maximum No. of Attempts to Run")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum number of attempts to run the job.';
                }
                field("No. of Attempts to Run"; Rec."No. of Attempts to Run")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of attempts to run the job.';
                }
                field("Rerun Delay (sec.)"; Rec."Rerun Delay (sec.)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the delay in seconds before the job is rerun.';
                }
                field("Priority Within Category"; Rec."Priority Within Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority of the job within the category.';
                }
                field(Scheduled; Rec.Scheduled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the scheduled date and time of the job.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Run Immediately")
            {
                ApplicationArea = All;
                Caption = 'Run Immediately';
                Image = Start;
                ToolTip = 'Runs the job immediately.';

                trigger OnAction()
                begin
                    PrepareRecForRunImmediately();
                    NonTempJobQueueEntry.Copy(Rec);
                    JobQueueEnqueue.Run(NonTempJobQueueEntry);
                end;
            }
            action("Plan Run")
            {
                ApplicationArea = All;
                Caption = 'Plan Run';
                Image = Timesheet;
                ToolTip = 'Plans the job to run at a later time.';

                trigger OnAction()
                begin
                    JobQueueEnqueue.Run(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        InitializeRec();
    end;

    var
        NonTempJobQueueEntry: Record "Job Queue Entry";
        JobQueueEnqueue: Codeunit "Job Queue - Enqueue";

    local procedure InitializeRec()
    begin
        Rec.Init();
        Rec.Validate(ID, CreateGuid());
        Rec.Insert(true);

        Rec.Validate("Object Type to Run", Rec."Object Type to Run"::Codeunit);
        Rec.Validate("Object ID to Run", Codeunit::"Scheduled Procedure_jq");
        Rec.Validate("Maximum No. of Attempts to Run", 5);
        Rec.Validate("No. of Attempts to Run", 1);
        Rec.Validate("Rerun Delay (sec.)", 30);
        Rec.Validate("Priority Within Category", Enum::"Job Queue Priority"::High);

        Rec.Modify(true);

        Rec.CalcFields("Object Caption to Run", Scheduled);
    end;

    local procedure PrepareRecForRunImmediately()
    begin
        Rec.Validate("Recurring Job", true);
        Rec.Validate("Starting Time", Time());
        Rec.Validate(Status, Rec.Status::Ready);
        Rec.Modify(true);
    end;

}
