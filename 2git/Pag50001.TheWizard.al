page 50001 "The Wizard"
{
    ApplicationArea = All;
    Caption = 'The Wizard';
    PageType = NavigatePage;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Credentials)
            {
                ShowCaption = false;
                Visible = Step = Step::Credentials;

                label(CredentialsInfoLbl)
                {
                    Caption = 'Please enter your credentials.';
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Your name.';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field(Surname; Surname)
                {
                    ApplicationArea = All;
                    Caption = 'Surname';
                    ToolTip = 'Your surname.';
                    ShowMandatory = true;
                    NotBlank = true;
                }
            }
            group(Address)
            {
                ShowCaption = false;
                Visible = Step = Step::Address;

                label(AddressInfoLbl)
                {
                    Caption = 'Please enter your address.';
                }
                field(City; City)
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                    ToolTip = 'Your address.';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field(Street; Street)
                {
                    ApplicationArea = All;
                    Caption = 'Street';
                    ToolTip = 'The street you live on.';
                    ShowMandatory = true;
                    NotBlank = true;
                }
            }
            group(House)
            {
                ShowCaption = false;
                Visible = Step = Step::House;

                label(HouseInfoLbl)
                {
                    Caption = 'Please enter your house information.';
                }
                field(HouseSize; HouseSize)
                {
                    ApplicationArea = All;
                    Caption = 'House Size.';
                    ToolTip = 'The size of your house.';
                }
                field(NoOfRooms; NoOfRooms)
                {
                    ApplicationArea = All;
                    Caption = 'Number of Rooms';
                    ToolTip = 'The number of rooms in your house.';
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field(HouseColor; HouseColor)
                {
                    ApplicationArea = All;
                    Caption = 'House Color';
                    ToolTip = 'The color of your house.';
                    NotBlank = true;
                    ShowMandatory = true;
                }
            }
            group(Car)
            {
                ShowCaption = false;
                Visible = Step = Step::Car;

                label(CarInfoLbl)
                {
                    Caption = 'Please enter your car information.';
                }
                field(CarMake; CarMake)
                {
                    ApplicationArea = All;
                    Caption = 'Car Make';
                    ToolTip = 'The make of your car.';
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field(CarModel; CarModel)
                {
                    ApplicationArea = All;
                    Caption = 'Car Model';
                    ToolTip = 'The model of your car.';
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field(Year; Year)
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    ToolTip = 'The year of your car.';
                    NotBlank = true;
                    ShowMandatory = true;
                    Numeric = true;
                }
                field(KMStand; KMStand)
                {
                    ApplicationArea = All;
                    Caption = 'Mileage';
                    ToolTip = 'The mileage of your car.';
                    NotBlank = true;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        if KMStand < 200000 then
                            KMStand += 200000;
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Back)
            {
                ApplicationArea = All;
                Caption = 'Back';
                // Enabled = Step in [Step::Address .. Step::Car];
                Enabled = (Step >= Step::Address) and (Step <= Step::Car);
                InFooterBar = true;
                Image = PreviousRecord;

                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }
            action(Next)
            {
                ApplicationArea = All;
                Caption = 'Next';
                // Enabled = Step in [Step::Credentials .. Step::Car];
                Enabled = (Step >= Step::Credentials) and (Step <= Step::House);
                InFooterBar = true;
                Image = NextRecord;

                trigger OnAction()
                begin
                    NextStep(false);
                end;
            }
            action(DisplayInfo)
            {
                ApplicationArea = All;
                Caption = 'Display Info';
                Enabled = Step = Step::Car;
                InFooterBar = true;

                trigger OnAction()
                var
                    GuidedExperience: Codeunit "Guided Experience";
                    InfoLbl: Label 'Here you have your information:\Name: %1, Surname: %2\City: %3, Street: %4\House Size: %5, No of Rooms: %6, House Color: %7\Car Make: %8, Car Model: %9, Year: %10, Mileage: %11';
                begin
                    CheckValuesAtStep();
                    Message(InfoLbl, Name, Surname, City, Street, HouseSize, NoOfRooms, HouseColor, CarMake, CarModel, Year, KMStand);
                    GuidedExperience.CompleteAssistedSetup(ObjectType::Page, Page::"The Wizard");
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnInit()
    begin
        Step := Step::Credentials;
    end;

    var
        ErrorHandler: Codeunit ErrorHandler;
        Name: Text;
        Surname: Text;
        City: Text;
        Street: Text;
        Step: Option Credentials,Address,House,Car;
        HouseSize: Option Small,Medium,Large,Mansion;
        NoOfRooms: Integer;
        HouseColor: Text;
        CarMake: Text;
        CarModel: Text;
        Year: Code[4];
        KMStand: Integer;

    local procedure NextStep(Backwards: Boolean)
    begin
        if Backwards then begin
            if Step - 1 in [Step::Credentials .. Step::Car] then
                Step := Step - 1;
        end
        else
            if Step + 1 in [Step::Credentials .. Step::Car] then begin
                CheckValuesAtStep();
                Step := Step + 1;
            end;
    end;

    [ErrorBehavior(ErrorBehavior::Collect)]
    local procedure CheckValuesAtStep()
    var
        MandatoryValueErr: Label 'The value for %1 is mandatory.', Comment = '%1 = Field Caption';
        NameLbl: Label 'Name';
        SurnameLbl: Label 'Surname';
        CityLbl: Label 'City';
        StreetLbl: Label 'Street';
        NoOfRoomsLbl: Label 'Number of Rooms';
        HouseColorLbl: Label 'House Color';
        CarMakeLbl: Label 'Car Make';
        CarModelLbl: Label 'Car Model';
        YearLbl: Label 'Year';
        ErrInfo: ErrorInfo;
    begin
        case Step of
            Step::Credentials:
                begin
                    if Name.Trim() = '' then begin
                        ErrInfo := ErrorInfo.Create(StrSubstNo(MandatoryValueErr, NameLbl));
                        ErrorHandler.AddAction(ErrInfo);
                        Error(ErrInfo);
                        NextStep(true);
                    end;
                    if Surname.Trim() = '' then begin
                        ErrInfo := ErrorInfo.Create(StrSubstNo(MandatoryValueErr, SurnameLbl));
                        ErrorHandler.AddAction(ErrInfo);
                        Error(ErrInfo);
                        NextStep(true);
                    end;
                end;
            Step::Address:
                begin
                    if City.Trim() = '' then begin
                        ErrInfo := ErrorInfo.Create(StrSubstNo(MandatoryValueErr, CityLbl));
                        ErrorHandler.AddAction(ErrInfo);
                        Error(ErrInfo);
                        NextStep(true);
                    end;
                    if Street.Trim() = '' then begin
                        ErrInfo := ErrorInfo.Create(StrSubstNo(MandatoryValueErr, StreetLbl));
                        ErrorHandler.AddAction(ErrInfo);
                        Error(ErrInfo);
                        NextStep(true);
                    end;
                end;
            Step::House:
                begin
                    if NoOfRooms = 0 then begin
                        ErrInfo := ErrorInfo.Create(StrSubstNo(MandatoryValueErr, NoOfRoomsLbl));
                        ErrorHandler.AddAction(ErrInfo);
                        Error(ErrorInfo.Create(StrSubstNo(MandatoryValueErr, NoOfRoomsLbl)));
                        NextStep(true);
                    end;
                    if HouseColor.Trim() = '' then begin
                        ErrInfo := ErrorInfo.Create(StrSubstNo(MandatoryValueErr, HouseColorLbl));
                        ErrorHandler.AddAction(ErrInfo);
                        Error(ErrInfo);
                        NextStep(true);
                    end;
                end;
            Step::Car:
                begin
                    if CarMake.Trim() = '' then
                        Error(ErrorInfo.Create(StrSubstNo(MandatoryValueErr, CarMakeLbl)));
                    if CarModel.Trim() = '' then
                        Error(ErrorInfo.Create(StrSubstNo(MandatoryValueErr, CarModelLbl)));
                    if Year = '' then
                        Error(ErrorInfo.Create(StrSubstNo(MandatoryValueErr, YearLbl)));
                end;
        end;
    end;
}
