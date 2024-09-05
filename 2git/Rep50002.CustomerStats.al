report 50002 "Customer Stats."
{
    ApplicationArea = All;
    Caption = 'Customer Stats.';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = RDLC;

    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No_; "No.") { }
            column(Name; "Name") { }
            column(Balance__LCY_; "Balance (LCY)") { }
            column(Balance_Due__LCY_; "Balance Due (LCY)") { }
            column(Credit_Limit__LCY_; "Credit Limit (LCY)") { }
            column(Blocked; Blocked) { }

            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No.");

                column(Posting_Date; "Posting Date") { }
                column(Document_Date; "Document Date") { }
                column(Document_Type; "Document Type") { }
                column(Document_No_; "Document No.") { }
                column(Customer_No_; "Customer No.") { }
                column(Customer_Name; "Customer Name") { }
                column(Customer_Posting_Group; "Customer Posting Group") { }
                column(Description; Description) { }
            }
        }
    }

    rendering
    {
        layout(RDLC)
        {
            Type = RDLC;
            LayoutFile = '.\Customer Stats.rdlc';
        }
        layout(EXCEL)
        {
            Type = Excel;
            LayoutFile = '.\Customer Stats.xlsx';
        }
    }
    labels
    {
        CustomerLbl = 'Customer';
    }
}
