using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using CrystalDecisions.Shared;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_MonitoringReport : System.Web.UI.Page
{
    TotalSummaryBLL aSummaryBll = new TotalSummaryBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            fromDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            toDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            DropDownlist();
        }
    }

    protected void loadGridView_OnRowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            GridView HeaderGrid = (GridView)sender;
            GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);

            TableCell HeaderCell = new TableCell();

            HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");

            HeaderCell.ColumnSpan = 0;
            HeaderGridRow.Cells.Add(HeaderCell);

            //HeaderCell = new TableCell();
            //HeaderCell.Text = " ";
            //HeaderCell.BackColor = Color.FromName("#F5F5F5");
            //HeaderCell.BorderColor = Color.FromName("#F5F5F5");


            //HeaderCell.ColumnSpan = 1;

            //HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Invoice";
            HeaderCell.ColumnSpan = 4;
            HeaderCell.BackColor = Color.DeepSkyBlue;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Return";
            HeaderCell.ColumnSpan = 3;
            HeaderCell.BackColor = Color.Red;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Sales";
            HeaderCell.BackColor = Color.GreenYellow;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Collection";
            HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Receivable";
            HeaderCell.BackColor = Color.Yellow;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            gv_DistributionCenter.Controls[0].Controls.AddAt(0, HeaderGridRow);

        }
    }



    protected void gv_Zone_OnRowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            GridView HeaderGrid = (GridView)sender;
            GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);

            TableCell HeaderCell = new TableCell();

            HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");

            HeaderCell.ColumnSpan = 0;
            HeaderGridRow.Cells.Add(HeaderCell);

           



            HeaderCell = new TableCell();
            HeaderCell.Text = "Invoice";
            HeaderCell.ColumnSpan = 3;
            HeaderCell.BackColor = System.Drawing.ColorTranslator.FromHtml("#00808");
            HeaderCell.ForeColor = Color.White;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Sales";
            HeaderCell.ColumnSpan = 3;
            HeaderCell.ForeColor = Color.White;
            HeaderCell.Font.Bold = true;
            HeaderCell.BackColor = System.Drawing.ColorTranslator.FromHtml("#90EE9");
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Discount";
            HeaderCell.BackColor = System.Drawing.ColorTranslator.FromHtml("#66CDA");
            HeaderCell.ColumnSpan = 3;
            HeaderCell.ForeColor = Color.White;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Return";
            HeaderCell.BackColor = System.Drawing.ColorTranslator.FromHtml("#6B8E2");
            HeaderCell.ColumnSpan = 3;
            HeaderCell.ForeColor = Color.White;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "";
            HeaderCell.BackColor = Color.WhiteSmoke;
            HeaderCell.ColumnSpan = 2;
            HeaderCell.ForeColor = Color.White;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Closing Invoice";
            HeaderCell.BackColor = System.Drawing.ColorTranslator.FromHtml("#FF450");
            HeaderCell.ColumnSpan = 3;
            HeaderCell.ForeColor = Color.White;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);




            gv_Zone.Controls[0].Controls.AddAt(0, HeaderGridRow);

        }
    }
    protected void gv_Area_OnRowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            GridView HeaderGrid = (GridView)sender;
            GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);

            TableCell HeaderCell = new TableCell();

            HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");

            HeaderCell.ColumnSpan = 2;
            HeaderGridRow.Cells.Add(HeaderCell);

            //HeaderCell = new TableCell();
            //HeaderCell.Text = " ";
            //HeaderCell.BackColor = Color.FromName("#F5F5F5");
            //HeaderCell.BorderColor = Color.FromName("#F5F5F5");


            //HeaderCell.ColumnSpan = 1;

            //HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Invoice";
            HeaderCell.ColumnSpan = 4;
            HeaderCell.BackColor = Color.DeepSkyBlue;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Return";
            HeaderCell.ColumnSpan = 3;
            HeaderCell.BackColor = Color.Red;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Sales";
            HeaderCell.BackColor = Color.GreenYellow;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Collection";
            HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Receivable";
            HeaderCell.BackColor = Color.Yellow;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            gv_Area.Controls[0].Controls.AddAt(0, HeaderGridRow);

        }
    }
    protected void gv_Territory_OnRowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            GridView HeaderGrid = (GridView)sender;
            GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);

            TableCell HeaderCell = new TableCell();

            HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");

            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);

            //HeaderCell = new TableCell();
            //HeaderCell.Text = " ";
            //HeaderCell.BackColor = Color.FromName("#F5F5F5");
            //HeaderCell.BorderColor = Color.FromName("#F5F5F5");


            //HeaderCell.ColumnSpan = 1;

            //HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Invoice";
            HeaderCell.ColumnSpan = 4;
            HeaderCell.BackColor = Color.DeepSkyBlue;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Return";
            HeaderCell.ColumnSpan = 3;
            HeaderCell.BackColor = Color.Red;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Sales";
            HeaderCell.BackColor = Color.GreenYellow;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Collection";
            HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Receivable";
            HeaderCell.BackColor = Color.Yellow;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            gv_Territory.Controls[0].Controls.AddAt(0, HeaderGridRow);

        }
    }
    public void DropDownlist()
    {
        try
        {
            OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
            aOrderInfoBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());
            aOrderInfoBll.LoadTerritory(territoryDropDownList, Session["UserId"].ToString());
            aOrderInfoBll.LoadZone(zoneDropDownList, Session["UserId"].ToString());
        }
        catch (Exception)
        {
            
            //throw;
        }
        // salesCenterDropDownList.SelectedIndex = 1;
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        LoadInfo();
    }


    protected void rbReportTypeName_SelectedIndexChanged(object sender, EventArgs e)
    {
        gv_DistributionCenter.DataSource = null;
        gv_DistributionCenter.DataBind();

        gv_Zone.DataSource = null;
        gv_Zone.DataBind();

        gv_Area.DataSource = null;
        gv_Area.DataBind();

        gv_Territory.DataSource = null;
        gv_Territory.DataBind();
    }
    private void LoadInfo()
    {
        gv_DistributionCenter.DataSource = null;
        gv_DistributionCenter.DataBind();

        gv_Zone.DataSource = null;
        gv_Zone.DataBind();

        gv_Area.DataSource = null;
        gv_Area.DataBind();

        gv_Territory.DataSource = null;
        gv_Territory.DataBind();
        if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {
            DataTable aDataTable = new DataTable();

            string Type = ""; 
            if (rbReportTypeName.Items[0].Selected)
            {
                Type = "SC";
            }
            else if (rbReportTypeName.Items[1].Selected)
            {
                Type = "Zone";
            }

            else if (rbReportTypeName.Items[2].Selected)
            {
             

                if (rbAmount.Items[0].Selected)
                {
                    Type = "AreaTran";
                }
                else
                {
                    Type = "AreaNONTran";
                }
            }

            else if (rbReportTypeName.Items[3].Selected)
            {
              

                if (rbAmount.Items[0].Selected)
                {
                    Type = "TerritoryTran";
                }
                else
                {
                    Type = "TerritoryNONTran";
                }
            }

            aDataTable = aSummaryBll.rptMonitoringReport(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()), Type);
            if (aDataTable.Rows.Count > 0)
            {

                if (Type == "SC")
                {
                    gv_DistributionCenter.DataSource = aDataTable;
                    gv_DistributionCenter.DataBind();

                    try
                    {
                        decimal total = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofProformaInvoice") == null ? 0 : row.Field<int>("NumberofProformaInvoice"));
                        gv_DistributionCenter.FooterRow.Cells[1].Text = "Total";
                        gv_DistributionCenter.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
                        gv_DistributionCenter.FooterRow.Cells[2].Text = Math.Round(total).ToString();

                        decimal total2 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetProformaAmount") == null ? 0 : row.Field<decimal>("SumofNetProformaAmount"));

                        gv_DistributionCenter.FooterRow.Cells[4].Text = Math.Round(total2).ToString("#,##0");


                        decimal total3 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ProTpVat") == null ? 0 : row.Field<decimal>("ProTpVat"));

                        gv_DistributionCenter.FooterRow.Cells[5].Text = Math.Round(total3).ToString("#,##0");


                        decimal total4 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetInvoiceAmt") == null ? 0 : row.Field<decimal>("NetInvoiceAmt"));

                        gv_DistributionCenter.FooterRow.Cells[6].Text = Math.Round(total4).ToString("#,##0");


                        decimal total5 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetReturnAmount") == null ? 0 : row.Field<decimal>("SumofNetReturnAmount"));

                        gv_DistributionCenter.FooterRow.Cells[8].Text = Math.Round(total5).ToString("#,##0");


                        decimal total6 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));

                        gv_DistributionCenter.FooterRow.Cells[9].Text = Math.Round(total6).ToString("#,##0");

                        decimal total7 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetReturnAmt") == null ? 0 : row.Field<decimal>("NetReturnAmt"));

                        gv_DistributionCenter.FooterRow.Cells[10].Text = Math.Round(total7).ToString("#,##0");

                        decimal total8 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("salesTP") == null ? 0 : row.Field<decimal>("salesTP"));

                        gv_DistributionCenter.FooterRow.Cells[11].Text = Math.Round(total8).ToString("#,##0");

                        decimal total9 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesVat") == null ? 0 : row.Field<decimal>("SalesVat"));

                        gv_DistributionCenter.FooterRow.Cells[12].Text = Math.Round(total9).ToString("#,##0");

                        decimal total10 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesTotal") == null ? 0 : row.Field<decimal>("SalesTotal"));

                        gv_DistributionCenter.FooterRow.Cells[13].Text = Math.Round(total10).ToString("#,##0");


                        decimal total11 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));

                        gv_DistributionCenter.FooterRow.Cells[15].Text = Math.Round(total11).ToString("#,##0");

                        decimal total12 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelTpVat") == null ? 0 : row.Field<decimal>("DelTpVat"));

                        gv_DistributionCenter.FooterRow.Cells[16].Text = Math.Round(total12).ToString("#,##0");

                        decimal total13 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetSalesAmt") == null ? 0 : row.Field<decimal>("NetSalesAmt"));

                        gv_DistributionCenter.FooterRow.Cells[17].Text = Math.Round(total13).ToString("#,##0");



                        decimal total14 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding1") == null ? 0 : row.Field<decimal>("Outstanding1"));

                        gv_DistributionCenter.FooterRow.Cells[19].Text = Math.Round(total14).ToString("#,##0");

                        decimal total15 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding2") == null ? 0 : row.Field<decimal>("Outstanding2"));

                        gv_DistributionCenter.FooterRow.Cells[20].Text = Math.Round(total15).ToString("#,##0");

                        decimal total16 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding3") == null ? 0 : row.Field<decimal>("Outstanding3"));

                        gv_DistributionCenter.FooterRow.Cells[21].Text = (Math.Round((total16)).ToString("#,##0"));

                        gv_DistributionCenter.FooterRow.BackColor = System.Drawing.Color.Beige;
                        gv_DistributionCenter.FooterRow.Font.Bold = true;
                    }
                    catch { }
                }



                if (Type == "Zone")
                {
                    gv_Zone.DataSource = aDataTable;
                    gv_Zone.DataBind();

                      try
                    {

                        gv_Zone.FooterRow.Cells[0].Text = "Total";
                        gv_Zone.FooterRow.Cells[0].HorizontalAlign = HorizontalAlign.Right;

                        decimal Invoice_PreviousPeriodOpening = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Invoice_PreviousPeriodOpening") == null ? 0 : row.Field<decimal>("Invoice_PreviousPeriodOpening"));
                       
                        gv_Zone.FooterRow.Cells[1].Text = Invoice_PreviousPeriodOpening.ToString();

                        decimal Invoice_CurrentPeriod = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Invoice_CurrentPeriod") == null ? 0 : row.Field<decimal>("Invoice_CurrentPeriod"));

                        gv_Zone.FooterRow.Cells[2].Text = Invoice_CurrentPeriod.ToString();

                        decimal Invoice_Period_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Invoice_Period_Total") == null ? 0 : row.Field<decimal>("Invoice_Period_Total"));

                        gv_Zone.FooterRow.Cells[3].Text = Invoice_Period_Total.ToString();


                        decimal Sales_PreviousPeriod = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Sales_PreviousPeriod") == null ? 0 : row.Field<decimal>("Sales_PreviousPeriod"));

                        gv_Zone.FooterRow.Cells[4].Text =  Sales_PreviousPeriod .ToString();


                        decimal Sales_CurrentPeriod = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Sales_CurrentPeriod") == null ? 0 : row.Field<decimal>("Sales_CurrentPeriod"));

                        gv_Zone.FooterRow.Cells[5].Text = Sales_CurrentPeriod.ToString();


                        decimal Sales_Period_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Sales_Period_Total") == null ? 0 : row.Field<decimal>("Sales_Period_Total"));

                        gv_Zone.FooterRow.Cells[6].Text = Sales_Period_Total.ToString();


                        decimal Discount_PreviousPeriod = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Discount_PreviousPeriod") == null ? 0 : row.Field<decimal>("Discount_PreviousPeriod"));

                        gv_Zone.FooterRow.Cells[7].Text = Discount_PreviousPeriod.ToString();

                        decimal Discount_CurrentPeriod = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Discount_CurrentPeriod") == null ? 0 : row.Field<decimal>("Discount_CurrentPeriod"));

                        gv_Zone.FooterRow.Cells[8].Text = Discount_CurrentPeriod.ToString() ;

                        decimal Discount_Period_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Discount_Period_Total") == null ? 0 : row.Field<decimal>("Discount_Period_Total"));

                        gv_Zone.FooterRow.Cells[9].Text = Discount_Period_Total.ToString();

                        decimal Return_PreviousPeriod = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Return_PreviousPeriod") == null ? 0 : row.Field<decimal>("Return_PreviousPeriod"));

                        gv_Zone.FooterRow.Cells[10].Text = Return_PreviousPeriod.ToString();
 

                        decimal Return_CurrentPeriod = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Return_CurrentPeriod") == null ? 0 : row.Field<decimal>("Return_CurrentPeriod"));

                        gv_Zone.FooterRow.Cells[11].Text = Return_CurrentPeriod.ToString();

                        decimal Return_Period_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Return_Period_Total") == null ? 0 : row.Field<decimal>("Return_Period_Total"));

                        gv_Zone.FooterRow.Cells[12].Text = Return_Period_Total.ToString();

                        decimal BankDeposit = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("BankDeposit") == null ? 0 : row.Field<decimal>("BankDeposit"));

                        gv_Zone.FooterRow.Cells[13].Text = BankDeposit.ToString();



                        decimal CashinHand = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("CashinHand") == null ? 0 : row.Field<decimal>("CashinHand"));

                        gv_Zone.FooterRow.Cells[14].Text = CashinHand.ToString();

                        decimal ClosingInvoice_PreviousPeriod = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ClosingInvoice_PreviousPeriod") == null ? 0 : row.Field<decimal>("ClosingInvoice_PreviousPeriod"));

                        gv_Zone.FooterRow.Cells[15].Text = ClosingInvoice_PreviousPeriod.ToString();

                        decimal ClosingInvoice_CurrentPeriod = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ClosingInvoice_CurrentPeriod") == null ? 0 : row.Field<decimal>("ClosingInvoice_CurrentPeriod"));

                        gv_Zone.FooterRow.Cells[16].Text = ClosingInvoice_CurrentPeriod.ToString();

                        decimal ClosingInvoice__Period_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ClosingInvoice__Period_Total") == null ? 0 : row.Field<decimal>("ClosingInvoice__Period_Total"));

                        gv_Zone.FooterRow.Cells[17].Text = ClosingInvoice__Period_Total.ToString();

                       
                        gv_Zone.FooterRow.BackColor = System.Drawing.Color.Beige;
                        gv_Zone.FooterRow.Font.Bold = true;
                    }
                    catch { }
            }


                if (Type == "AreaTran" || Type == "AreaNONTran")
                {
                    gv_Area.DataSource = aDataTable;
                    gv_Area.DataBind();

                    try
                    {
                        decimal total = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofProformaInvoice") == null ? 0 : row.Field<int>("NumberofProformaInvoice"));
                        gv_Area.FooterRow.Cells[2].Text = "Total";
                        gv_Area.FooterRow.Cells[2].HorizontalAlign = HorizontalAlign.Right;
                        gv_Area.FooterRow.Cells[3].Text = Math.Round(total).ToString();

                        decimal total2 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetProformaAmount") == null ? 0 : row.Field<decimal>("SumofNetProformaAmount"));

                        gv_Area.FooterRow.Cells[4].Text = Math.Round(total2).ToString("#,##0");


                        decimal total3 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ProTpVat") == null ? 0 : row.Field<decimal>("ProTpVat"));

                        gv_Area.FooterRow.Cells[5].Text = Math.Round(total3).ToString("#,##0");


                        decimal total4 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetInvoiceAmt") == null ? 0 : row.Field<decimal>("NetInvoiceAmt"));

                        gv_Area.FooterRow.Cells[6].Text = Math.Round(total4).ToString("#,##0");


                        decimal total5 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetReturnAmount") == null ? 0 : row.Field<decimal>("SumofNetReturnAmount"));

                        gv_Area.FooterRow.Cells[7].Text = Math.Round(total5).ToString("#,##0");


                        decimal total6 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));

                        gv_Area.FooterRow.Cells[8].Text = Math.Round(total6).ToString("#,##0");

                        decimal total7 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetReturnAmt") == null ? 0 : row.Field<decimal>("NetReturnAmt"));

                        gv_Area.FooterRow.Cells[9].Text = Math.Round(total7).ToString("#,##0");

                        decimal total8 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("salesTP") == null ? 0 : row.Field<decimal>("salesTP"));

                        gv_Area.FooterRow.Cells[10].Text = Math.Round(total8).ToString("#,##0");

                        decimal total9 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesVat") == null ? 0 : row.Field<decimal>("SalesVat"));

                        gv_Area.FooterRow.Cells[11].Text = Math.Round(total9).ToString("#,##0");

                        decimal total10 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesTotal") == null ? 0 : row.Field<decimal>("SalesTotal"));

                        gv_Area.FooterRow.Cells[12].Text = Math.Round(total10).ToString("#,##0");


                        decimal total11 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));

                        gv_Area.FooterRow.Cells[13].Text = Math.Round(total11).ToString("#,##0");

                        decimal total12 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelTpVat") == null ? 0 : row.Field<decimal>("DelTpVat"));

                        gv_Area.FooterRow.Cells[14].Text = Math.Round(total12).ToString("#,##0");

                        decimal total13 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetSalesAmt") == null ? 0 : row.Field<decimal>("NetSalesAmt"));

                        gv_Area.FooterRow.Cells[15].Text = Math.Round(total13).ToString("#,##0");



                        decimal total14 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding1") == null ? 0 : row.Field<decimal>("Outstanding1"));

                        gv_Area.FooterRow.Cells[16].Text = Math.Round(total14).ToString("#,##0");

                        decimal total15 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding2") == null ? 0 : row.Field<decimal>("Outstanding2"));

                        gv_Area.FooterRow.Cells[17].Text = Math.Round(total15).ToString("#,##0");

                        decimal total16 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding3") == null ? 0 : row.Field<decimal>("Outstanding3"));

                        gv_Area.FooterRow.Cells[18].Text = (Math.Round((total16)).ToString("#,##0"));

                        gv_Area.FooterRow.BackColor = System.Drawing.Color.Beige;
                        gv_Area.FooterRow.Font.Bold = true;
                    }
                    catch { }
                }


                if (Type == "TerritoryTran" || Type == "TerritoryNONTran")
                {
                    gv_Territory.DataSource = aDataTable;
                    gv_Territory.DataBind();

                    try
                    {
                        decimal total = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofProformaInvoice") == null ? 0 : row.Field<int>("NumberofProformaInvoice"));
                        gv_Territory.FooterRow.Cells[3].Text = "Total";
                        gv_Territory.FooterRow.Cells[3].HorizontalAlign = HorizontalAlign.Right;
                        gv_Territory.FooterRow.Cells[4].Text = Math.Round(total).ToString();

                        decimal total2 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetProformaAmount") == null ? 0 : row.Field<decimal>("SumofNetProformaAmount"));

                        gv_Territory.FooterRow.Cells[5].Text = Math.Round(total2).ToString("#,##0");


                        decimal total3 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ProTpVat") == null ? 0 : row.Field<decimal>("ProTpVat"));

                        gv_Territory.FooterRow.Cells[6].Text = Math.Round(total3).ToString("#,##0");


                        decimal total4 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetInvoiceAmt") == null ? 0 : row.Field<decimal>("NetInvoiceAmt"));

                        gv_Territory.FooterRow.Cells[7].Text = Math.Round(total4).ToString("#,##0");


                        decimal total5 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetReturnAmount") == null ? 0 : row.Field<decimal>("SumofNetReturnAmount"));

                        gv_Territory.FooterRow.Cells[8].Text = Math.Round(total5).ToString("#,##0");


                        decimal total6 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));

                        gv_Territory.FooterRow.Cells[9].Text = Math.Round(total6).ToString("#,##0");

                        decimal total7 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetReturnAmt") == null ? 0 : row.Field<decimal>("NetReturnAmt"));

                        gv_Territory.FooterRow.Cells[10].Text = Math.Round(total7).ToString("#,##0");

                        decimal total8 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("salesTP") == null ? 0 : row.Field<decimal>("salesTP"));

                        gv_Territory.FooterRow.Cells[11].Text = Math.Round(total8).ToString("#,##0");

                        decimal total9 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesVat") == null ? 0 : row.Field<decimal>("SalesVat"));

                        gv_Territory.FooterRow.Cells[12].Text = Math.Round(total9).ToString("#,##0");

                        decimal total10 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesTotal") == null ? 0 : row.Field<decimal>("SalesTotal"));

                        gv_Territory.FooterRow.Cells[13].Text = Math.Round(total10).ToString("#,##0");


                        decimal total11 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));

                        gv_Territory.FooterRow.Cells[14].Text = Math.Round(total11).ToString("#,##0");

                        decimal total12 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelTpVat") == null ? 0 : row.Field<decimal>("DelTpVat"));

                        gv_Territory.FooterRow.Cells[15].Text = Math.Round(total12).ToString("#,##0");

                        decimal total13 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetSalesAmt") == null ? 0 : row.Field<decimal>("NetSalesAmt"));

                        gv_Territory.FooterRow.Cells[16].Text = Math.Round(total13).ToString("#,##0");



                        decimal total14 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding1") == null ? 0 : row.Field<decimal>("Outstanding1"));

                        gv_Territory.FooterRow.Cells[17].Text = Math.Round(total14).ToString("#,##0");

                        decimal total15 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding2") == null ? 0 : row.Field<decimal>("Outstanding2"));

                        gv_Territory.FooterRow.Cells[18].Text = Math.Round(total15).ToString("#,##0");

                        decimal total16 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding3") == null ? 0 : row.Field<decimal>("Outstanding3"));

                        gv_Territory.FooterRow.Cells[19].Text = (Math.Round((total16)).ToString("#,##0"));

                        gv_Territory.FooterRow.BackColor = System.Drawing.Color.Beige;
                        gv_Territory.FooterRow.Font.Bold = true;

                    }
                    catch { }
                }
                //catch (Exception)
                //{

                //  //  throw;
                //}

            }
            else
            {
                showMessageBox("No Data Found!!");
                gv_DistributionCenter.DataSource = null;
                gv_DistributionCenter.DataBind();

                gv_Zone.DataSource = null;
                gv_Zone.DataBind();

                gv_Area.DataSource = null;
                gv_Area.DataBind();

                gv_Territory.DataSource = null;
                gv_Territory.DataBind();
            }

        }
        else
        {
            showMessageBox("Please Select Date Range!!");
        }
    }


    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void excelButton1_Click(object sender, EventArgs e)
    {
         if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {
        string fromDate = fromDateTextBox.Text;
        string toDate = toDateTextBox.Text;

        string url = "../SInventory_RPTVIEW/BusinessSummaryViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate;
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
         else
         {
             showMessageBox("Please Select Date Range!!");
         }

    }
    protected void OnPageIndexChanging(object sender, GridViewPageEventArgs e)
    {
       
    }
    protected void rptTypeDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (rptTypeDropDownList.SelectedValue == "BranchWise")
        //{
            
        //}

        //else if ()
        //{
            
        //}

        //else
        //{
            
        //}
    }
    public override void VerifyRenderingInServerForm(Control control)
    {
        // //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
    }  
    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        //if (gv_DistributionCenter.Rows.Count > 0)
        //{
        try
        {
            string Type = "";
            if (rbReportTypeName.Items[0].Selected)
            {
                Type = "Distribution Center_Wise_";

                string attachment = "attachment; filename=" + Type + "Invoice, Sales & Deposit Statement " + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
                Response.ClearContent();
                Response.AddHeader("content-disposition", attachment);
                Response.ContentType = "application/ms-excel";
                StringWriter sw = new StringWriter();
                HtmlTextWriter htw = new HtmlTextWriter(sw);

                gv_DistributionCenter.AllowPaging = false;




                this.LoadInfo();

                // Create a form to contain the grid  
                HtmlForm frm = new HtmlForm();
                gv_DistributionCenter.Parent.Controls.Add(frm);
                //frm.Attributes["runat"] = "server";
                //frm.Controls.Add(gv_DistributionCenter);
                //frm.RenderControl(htw);

                gv_DistributionCenter.HeaderRow.Style.Add("background-color", "#E5EEF1");

                // Set background color of each cell of GridView1 header row
                foreach (TableCell tableCell in gv_DistributionCenter.HeaderRow.Cells)
                {
                    tableCell.Style["background-color"] = "#E5EEF1";
                }

                // Set background color of each cell of each data row of GridView1
                foreach (GridViewRow gridViewRow in gv_DistributionCenter.Rows)
                {
                    gridViewRow.BackColor = System.Drawing.Color.White;

                    foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                    {
                        gridViewRowTableCell.Style["background-color"] = "#FFFFFF";

                    }
                }


                gv_DistributionCenter.RenderControl(htw);


                string headerTable = @"<span  style='text-align:center'><h3>" + Type + " Business Summary Report  (Date Range : " + fromDateTextBox.Text + "- " + toDateTextBox.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

                HttpContext.Current.Response.Write(headerTable);

                Response.Write(sw.ToString());
                Response.End();
            }
            else if (rbReportTypeName.Items[1].Selected)
            {
                Type = "Zoner_Wise_";


                string attachment = "attachment; filename=" + Type + "Monitoring Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
                Response.ClearContent();
                Response.AddHeader("content-disposition", attachment);
                Response.ContentType = "application/ms-excel";
                StringWriter sw = new StringWriter();
                HtmlTextWriter htw = new HtmlTextWriter(sw);

                gv_Zone.AllowPaging = false;




                this.LoadInfo();

                // Create a form to contain the grid  
                HtmlForm frm = new HtmlForm();
                gv_Zone.Parent.Controls.Add(frm);
                //frm.Attributes["runat"] = "server";
                //frm.Controls.Add(gv_DistributionCenter);
                //frm.RenderControl(htw);

                gv_Zone.HeaderRow.Style.Add("background-color", "#E5EEF1");

                // Set background color of each cell of GridView1 header row
                foreach (TableCell tableCell in gv_Zone.HeaderRow.Cells)
                {
                    tableCell.Style["background-color"] = "#E5EEF1";
                }

                // Set background color of each cell of each data row of GridView1
                foreach (GridViewRow gridViewRow in gv_Zone.Rows)
                {
                    gridViewRow.BackColor = System.Drawing.Color.White;

                    foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                    {
                        gridViewRowTableCell.Style["background-color"] = "#FFFFFF";

                    }
                }


                gv_Zone.RenderControl(htw);


                string headerTable = @"<span  style='text-align:center'><h3>" + Type + " Invoice, Sales & Deposit Statement Report (Monitoring Report)  (Date Range : " + fromDateTextBox.Text + "- " + toDateTextBox.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

                HttpContext.Current.Response.Write(headerTable);

                Response.Write(sw.ToString());
                Response.End();
            }

            else if (rbReportTypeName.Items[2].Selected)
            {
                Type = "Area_Wise_";


                string attachment = "attachment; filename=" + Type + "BusinessSummary_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
                Response.ClearContent();
                Response.AddHeader("content-disposition", attachment);
                Response.ContentType = "application/ms-excel";
                StringWriter sw = new StringWriter();
                HtmlTextWriter htw = new HtmlTextWriter(sw);

                gv_Area.AllowPaging = false;




                this.LoadInfo();

                // Create a form to contain the grid  
                HtmlForm frm = new HtmlForm();
                gv_Area.Parent.Controls.Add(frm);
                //frm.Attributes["runat"] = "server";
                //frm.Controls.Add(gv_DistributionCenter);
                //frm.RenderControl(htw);

                gv_Area.HeaderRow.Style.Add("background-color", "#E5EEF1");

                // Set background color of each cell of GridView1 header row
                foreach (TableCell tableCell in gv_Area.HeaderRow.Cells)
                {
                    tableCell.Style["background-color"] = "#E5EEF1";
                }

                // Set background color of each cell of each data row of GridView1
                foreach (GridViewRow gridViewRow in gv_Area.Rows)
                {
                    gridViewRow.BackColor = System.Drawing.Color.White;

                    foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                    {
                        gridViewRowTableCell.Style["background-color"] = "#FFFFFF";

                    }
                }


                gv_Area.RenderControl(htw);


                string headerTable = @"<span  style='text-align:center'><h3>" + Type + " Business Summary Report  (Date Range : " + fromDateTextBox.Text + "- " + toDateTextBox.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

                HttpContext.Current.Response.Write(headerTable);

                Response.Write(sw.ToString());
                Response.End();

            }

            else if (rbReportTypeName.Items[3].Selected)
            {
                Type = "Territory_Wise_";




                string attachment = "attachment; filename=" + Type + "BusinessSummary_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
                Response.ClearContent();
                Response.AddHeader("content-disposition", attachment);
                Response.ContentType = "application/ms-excel";
                StringWriter sw = new StringWriter();
                HtmlTextWriter htw = new HtmlTextWriter(sw);

                gv_Territory.AllowPaging = false;




                this.LoadInfo();

                // Create a form to contain the grid  
                HtmlForm frm = new HtmlForm();
                gv_Territory.Parent.Controls.Add(frm);
                //frm.Attributes["runat"] = "server";
                //frm.Controls.Add(gv_DistributionCenter);
                //frm.RenderControl(htw);

                gv_Territory.HeaderRow.Style.Add("background-color", "#E5EEF1");

                // Set background color of each cell of GridView1 header row
                foreach (TableCell tableCell in gv_Territory.HeaderRow.Cells)
                {
                    tableCell.Style["background-color"] = "#E5EEF1";
                }

                // Set background color of each cell of each data row of GridView1
                foreach (GridViewRow gridViewRow in gv_Territory.Rows)
                {
                    gridViewRow.BackColor = System.Drawing.Color.White;

                    foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                    {
                        gridViewRowTableCell.Style["background-color"] = "#FFFFFF";

                    }
                }


                gv_Territory.RenderControl(htw);


                string headerTable = @"<span  style='text-align:center'><h3>" + Type + " Business Summary Report  (Date Range : " + fromDateTextBox.Text + "- " + toDateTextBox.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

                HttpContext.Current.Response.Write(headerTable);

                Response.Write(sw.ToString());
                Response.End();
            }
        }
        catch
        {
            showMessageBox("No Data Found!!");
        }

         
        //}
        //else
        //{
        //    showMessageBox("No Data Found!!");
        //}
    }


    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("TotalSummaryNew2.aspx");
    }

    protected void fromDateTextBox_TextChanged(object sender, EventArgs e)
    {
        DateTime Fromd = Convert.ToDateTime("01-Apr-2022");
        DateTime inputDateTime = Convert.ToDateTime(fromDateTextBox.Text);
        if (inputDateTime < Fromd)
        {
            fromDateTextBox.Text = DateTime.Now.ToString("01 April, 2022");
        }
    }
}