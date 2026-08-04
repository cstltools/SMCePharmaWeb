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

public partial class SInventory_UI_RptBussinessSummary_Loading : System.Web.UI.Page
{
    TotalSummaryBLL aSummaryBll = new TotalSummaryBLL();

    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = ""; string areaId = "";
    string masArea = "";
    string strRole = "";
    private DropDownList F_GroupSelect, F_ZoneSelect, F_AreaSelect, F_TeritorySelect, F_SubTeritory, F_MarketSelect;
    protected void Page_Load(object sender, EventArgs e)
    {


        try
        {
            RoleTypeName = Session["RoleTypeName"].ToString();
            EmpInfoId = Session["EmpInfoId"].ToString();
            ToRoleTypeId = Session["RoleTypeId"].ToString();

        }
        catch { }
        F_GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        F_ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        F_AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        F_TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        F_SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        F_MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;
        if (!IsPostBack)
        {
            fromDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            toDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            DropDownlist();

            if (RoleTypeName == "DZSM")
            {
                ListItem item = rbReportTypeName.Items.FindByValue("1");
                ListItem item2 = rbReportTypeName.Items.FindByValue("2");
                ListItem item3 = rbReportTypeName.Items.FindByValue("3");
                item3.Selected = true;

                rbReportTypeName_SelectedIndexChanged(null, null);
                F_ZoneSelect.Enabled = false;
                // If the item is found, make it invisible
                if (item != null)
                {
                    item.Enabled = false;
                }
                if (item2 != null)
                {
                    item2.Enabled = false;
                }
            }
            if (RoleTypeName == "AM")
            {
                ListItem item = rbReportTypeName.Items.FindByValue("1");
                ListItem item2 = rbReportTypeName.Items.FindByValue("2");
                ListItem item3 = rbReportTypeName.Items.FindByValue("3");
                item3.Selected = true;

                rbReportTypeName_SelectedIndexChanged(null, null);
                F_ZoneSelect.Enabled = false;
                F_AreaSelect.Enabled = false;
                F_GroupSelect.Enabled = false;

                // If the item is found, make it invisible
                if (item != null)
                {
                    item.Enabled = false;
                }
                if (item2 != null)
                {
                    item2.Enabled = false;
                }
            }

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
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
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
            HeaderCell.ColumnSpan = 3;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.FromName("#3CB371");
            HeaderGridRow.Cells.Add(HeaderCell);




            HeaderCell = new TableCell();
            HeaderCell.Text = "Invoice Rejection";
            HeaderCell.ColumnSpan = 2;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.Tomato;
           
            HeaderGridRow.Cells.Add(HeaderCell);
    


            HeaderCell = new TableCell();
            HeaderCell.Text = "Sales Confirmation";
            HeaderCell.ColumnSpan = 2;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.FromName("#6495ED");
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Sales Retun";
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.MediumVioletRed;
            HeaderCell.ColumnSpan = 2;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Net Sales";
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.DodgerBlue;
            HeaderCell.ColumnSpan = 2;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Collection";
            HeaderCell.BackColor = Color.FromName("#00FFFF"); 
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.ColumnSpan = 2;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Receivable";
            HeaderCell.BackColor = Color.Violet;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.ColumnSpan = 2;
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
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
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
            HeaderCell.ColumnSpan = 3;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.FromName("#3CB371");
            HeaderGridRow.Cells.Add(HeaderCell);




            HeaderCell = new TableCell();
            HeaderCell.Text = "Invoice Rejection";
            HeaderCell.ColumnSpan = 2;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.Tomato;

            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Sales Confirmation";
            HeaderCell.ColumnSpan = 2;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.FromName("#6495ED");
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Sales Retun";
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.MediumVioletRed;
            HeaderCell.ColumnSpan = 2;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Net Sales";
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.DodgerBlue;
            HeaderCell.ColumnSpan = 2;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Collection";
            HeaderCell.BackColor = Color.FromName("#00FFFF");
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.ColumnSpan = 2;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Receivable";
            HeaderCell.BackColor = Color.Violet;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.ColumnSpan = 2;
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
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
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
            HeaderCell.ColumnSpan = 3;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.FromName("#3CB371");
            HeaderGridRow.Cells.Add(HeaderCell);




            HeaderCell = new TableCell();
            HeaderCell.Text = "Invoice Rejection";
            HeaderCell.ColumnSpan = 2;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.Tomato;

            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Sales Confirmation";
            HeaderCell.ColumnSpan = 2;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.FromName("#6495ED");
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Sales Retun";
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.MediumVioletRed;
            HeaderCell.ColumnSpan = 2;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Net Sales";
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.DodgerBlue;
            HeaderCell.ColumnSpan = 2;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Collection";
            HeaderCell.BackColor = Color.FromName("#00FFFF");
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.ColumnSpan = 2;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Receivable";
            HeaderCell.BackColor = Color.Violet;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.ColumnSpan = 2;
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
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
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
            HeaderCell.ColumnSpan = 3;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.FromName("#3CB371");
            HeaderGridRow.Cells.Add(HeaderCell);




            HeaderCell = new TableCell();
            HeaderCell.Text = "Invoice Rejection";
            HeaderCell.ColumnSpan = 2;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.Tomato;

            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Sales Confirmation";
            HeaderCell.ColumnSpan = 2;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.FromName("#6495ED");
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Sales Retun";
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.MediumVioletRed;
            HeaderCell.ColumnSpan = 2;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Net Sales";
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.DodgerBlue;
            HeaderCell.ColumnSpan = 2;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Collection";
            HeaderCell.BackColor = Color.FromName("#00FFFF");
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.ColumnSpan = 2;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Receivable";
            HeaderCell.BackColor = Color.Violet;
            HeaderCell.Font.Bold = true;

            // Center-align the cell content
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.ColumnSpan = 2;
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


        divMrk.Visible = false;
        try
        {
           // F_ZoneSelect.SelectedIndex = 0;
        }
        catch
        {

        }
        try
        {
           // F_AreaSelect.SelectedIndex = 0;
        }
        catch
        {

        }
        try
        {


         //   F_AreaSelect.Items.Clear();
        //F_TeritorySelect.Items.Clear();
        F_TeritorySelect.Enabled = false;
        }
        catch
        {

        }

        if (rbReportTypeName.Items[2].Selected==true)
        {
            divMrk.Visible = true;
        }
        if (rbReportTypeName.Items[3].Selected == true)
        {
            F_TeritorySelect.Enabled = true;

            divMrk.Visible = true;
        }
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
            string Area = ""; string Terr = "";
            string Type = "";
            string ZonId = "";
            if (rbReportTypeName.Items[0].Selected)
            {
                Type = "SC";
            }
            else if (rbReportTypeName.Items[1].Selected)
            {
                Type = "Zone";


              //  ZonId = F_ZoneSelect.SelectedValue;

            }

            else if (rbReportTypeName.Items[2].Selected)
            {

                ZonId = F_ZoneSelect.SelectedValue;
                Area = F_AreaSelect.SelectedValue;


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
                ZonId = F_ZoneSelect.SelectedValue;
                Area = F_AreaSelect.SelectedValue;
                Terr = F_TeritorySelect.SelectedValue;
                if (rbAmount.Items[0].Selected)
                {
                    Type = "TerritoryTran";
                }
                else
                {
                    Type = "TerritoryNONTran";
                }
            }

            aDataTable = aSummaryBll.LoadRptBussinessSummary_LoadingDAL(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()), Type, ZonId, Area, Terr );
            if (aDataTable.Rows.Count > 0)
            {

                if (Type == "SC")
                {
                    gv_DistributionCenter.DataSource = aDataTable;
                    gv_DistributionCenter.DataBind();




                    try
                    {

                        gv_DistributionCenter.FooterRow.Cells[0].Text = "Total:";



                        decimal NumberofInvoice = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofInvoice") == null ? 0 : row.Field<int>("NumberofInvoice"));
                        gv_DistributionCenter.FooterRow.Cells[1].Text = Math.Round(NumberofInvoice).ToString();

                        decimal InvoieAmountTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("InvoieAmountTP") == null ? 0 : row.Field<decimal>("InvoieAmountTP"));
                        gv_DistributionCenter.FooterRow.Cells[2].Text = Math.Round(InvoieAmountTP).ToString("#,##0");

                       

                        decimal InvoiceGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("InvoiceGrossAmt") == null ? 0 : row.Field<decimal>("InvoiceGrossAmt"));
                        gv_DistributionCenter.FooterRow.Cells[3].Text = Math.Round(InvoiceGrossAmt).ToString("#,##0");


                        decimal RejectAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("RejectAmtTP") == null ? 0 : row.Field<decimal>("RejectAmtTP"));
                        gv_DistributionCenter.FooterRow.Cells[4].Text = Math.Round(RejectAmtTP).ToString("#,##0");

                         

                        decimal RejectGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("RejectGrossAmt") == null ? 0 : row.Field<decimal>("RejectGrossAmt"));
                        gv_DistributionCenter.FooterRow.Cells[5].Text = Math.Round(RejectGrossAmt).ToString("#,##0");



                        decimal SalesAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesAmtTP") == null ? 0 : row.Field<decimal>("SalesAmtTP"));
                        gv_DistributionCenter.FooterRow.Cells[6].Text = Math.Round(SalesAmtTP).ToString("#,##0");
 

                        decimal SalesGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesGrossAmt") == null ? 0 : row.Field<decimal>("SalesGrossAmt"));
                        gv_DistributionCenter.FooterRow.Cells[7].Text = Math.Round(SalesGrossAmt).ToString("#,##0");



                        decimal ReturnAmountTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReturnAmountTP") == null ? 0 : row.Field<decimal>("ReturnAmountTP"));
                        gv_DistributionCenter.FooterRow.Cells[8].Text = Math.Round(ReturnAmountTP).ToString("#,##0");



                    

                        decimal ReturnGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReturnGrossAmt") == null ? 0 : row.Field<decimal>("ReturnGrossAmt"));
                        gv_DistributionCenter.FooterRow.Cells[9].Text = Math.Round(ReturnGrossAmt).ToString("#,##0");




                        decimal JustSalesAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesAmtTP") == null ? 0 : row.Field<decimal>("JustSalesAmtTP"));
                        gv_DistributionCenter.FooterRow.Cells[10].Text = Math.Round(JustSalesAmtTP).ToString("#,##0");



                      


                        decimal JustSalesGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesGrossAmt") == null ? 0 : row.Field<decimal>("JustSalesGrossAmt"));
                        gv_DistributionCenter.FooterRow.Cells[11].Text = Math.Round(JustSalesGrossAmt).ToString("#,##0");




                        decimal CollectionAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("CollectionAmtTP") == null ? 0 : row.Field<decimal>("CollectionAmtTP"));
                        gv_DistributionCenter.FooterRow.Cells[12].Text = Math.Round(CollectionAmtTP).ToString("#,##0");



 

                        decimal CollectionGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("CollectionGrossAmt") == null ? 0 : row.Field<decimal>("CollectionGrossAmt"));
                        gv_DistributionCenter.FooterRow.Cells[13].Text = Math.Round(CollectionGrossAmt).ToString("#,##0");

                        try
                        {
                            decimal ReceivableTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReceivableTP") == null ? 0 : row.Field<decimal>("ReceivableTP"));
                            gv_DistributionCenter.FooterRow.Cells[14].Text = Math.Round(ReceivableTP).ToString("#,##0");
                        }
                        catch(Exception ex)
                        {

                        }


                        decimal ReceivableGrossAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReceivableGrossAmount") == null ? 0 : row.Field<decimal>("ReceivableGrossAmount"));
                        gv_DistributionCenter.FooterRow.Cells[15].Text = Math.Round(ReceivableGrossAmount).ToString("#,##0");



                      


                        gv_DistributionCenter.FooterRow.BackColor = System.Drawing.Color.Bisque;
                        gv_DistributionCenter.FooterRow.Font.Bold = true;
                        gv_DistributionCenter.FooterRow.HorizontalAlign = HorizontalAlign.Right;
                    }

                    catch { }
                }



                if (Type == "Zone")
                {
                    gv_Zone.DataSource = aDataTable;
                    gv_Zone.DataBind();

                      try
                    {
                        gv_Zone.FooterRow.Cells[0].Text = "Total:";



                        decimal NumberofInvoice = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofInvoice") == null ? 0 : row.Field<int>("NumberofInvoice"));
                        gv_Zone.FooterRow.Cells[1].Text = Math.Round(NumberofInvoice).ToString();

                        decimal InvoieAmountTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("InvoieAmountTP") == null ? 0 : row.Field<decimal>("InvoieAmountTP"));
                        gv_Zone.FooterRow.Cells[2].Text = Math.Round(InvoieAmountTP).ToString("#,##0");



                        decimal InvoiceGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("InvoiceGrossAmt") == null ? 0 : row.Field<decimal>("InvoiceGrossAmt"));
                        gv_Zone.FooterRow.Cells[3].Text = Math.Round(InvoiceGrossAmt).ToString("#,##0");


                        decimal RejectAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("RejectAmtTP") == null ? 0 : row.Field<decimal>("RejectAmtTP"));
                        gv_Zone.FooterRow.Cells[4].Text = Math.Round(RejectAmtTP).ToString("#,##0");



                        decimal RejectGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("RejectGrossAmt") == null ? 0 : row.Field<decimal>("RejectGrossAmt"));
                        gv_Zone.FooterRow.Cells[5].Text = Math.Round(RejectGrossAmt).ToString("#,##0");



                        decimal SalesAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesAmtTP") == null ? 0 : row.Field<decimal>("SalesAmtTP"));
                        gv_Zone.FooterRow.Cells[6].Text = Math.Round(SalesAmtTP).ToString("#,##0");


                        decimal SalesGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesGrossAmt") == null ? 0 : row.Field<decimal>("SalesGrossAmt"));
                        gv_Zone.FooterRow.Cells[7].Text = Math.Round(SalesGrossAmt).ToString("#,##0");



                        decimal ReturnAmountTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReturnAmountTP") == null ? 0 : row.Field<decimal>("ReturnAmountTP"));
                        gv_Zone.FooterRow.Cells[8].Text = Math.Round(ReturnAmountTP).ToString("#,##0");





                        decimal ReturnGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReturnGrossAmt") == null ? 0 : row.Field<decimal>("ReturnGrossAmt"));
                        gv_Zone.FooterRow.Cells[9].Text = Math.Round(ReturnGrossAmt).ToString("#,##0");




                        decimal JustSalesAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesAmtTP") == null ? 0 : row.Field<decimal>("JustSalesAmtTP"));
                        gv_Zone.FooterRow.Cells[10].Text = Math.Round(JustSalesAmtTP).ToString("#,##0");






                        decimal JustSalesGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesGrossAmt") == null ? 0 : row.Field<decimal>("JustSalesGrossAmt"));
                        gv_Zone.FooterRow.Cells[11].Text = Math.Round(JustSalesGrossAmt).ToString("#,##0");




                        decimal CollectionAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("CollectionAmtTP") == null ? 0 : row.Field<decimal>("CollectionAmtTP"));
                        gv_Zone.FooterRow.Cells[12].Text = Math.Round(CollectionAmtTP).ToString("#,##0");





                        decimal CollectionGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("CollectionGrossAmt") == null ? 0 : row.Field<decimal>("CollectionGrossAmt"));
                        gv_Zone.FooterRow.Cells[13].Text = Math.Round(CollectionGrossAmt).ToString("#,##0");

                        try
                        {
                            decimal ReceivableTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReceivableTP") == null ? 0 : row.Field<decimal>("ReceivableTP"));
                            gv_Zone.FooterRow.Cells[14].Text = Math.Round(ReceivableTP).ToString("#,##0");
                        }
                        catch (Exception ex)
                        {

                        }


                        decimal ReceivableGrossAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReceivableGrossAmount") == null ? 0 : row.Field<decimal>("ReceivableGrossAmount"));
                        gv_Zone.FooterRow.Cells[15].Text = Math.Round(ReceivableGrossAmount).ToString("#,##0");






                        gv_Zone.FooterRow.BackColor = System.Drawing.Color.Bisque;
                        gv_Zone.FooterRow.Font.Bold = true;
                        gv_Zone.FooterRow.HorizontalAlign = HorizontalAlign.Right;
                    }
                    catch { }
            }


                if (Type == "AreaTran" || Type == "AreaNONTran")
                {
                    gv_Area.DataSource = aDataTable;
                    gv_Area.DataBind();

                    try
                    {

                        gv_Area.FooterRow.Cells[1].Text = "Total:";




                        decimal NumberofInvoice = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofInvoice") == null ? 0 : row.Field<int>("NumberofInvoice"));
                        gv_Area.FooterRow.Cells[2].Text = Math.Round(NumberofInvoice).ToString();

                        decimal InvoieAmountTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("InvoieAmountTP") == null ? 0 : row.Field<decimal>("InvoieAmountTP"));
                        gv_Area.FooterRow.Cells[3].Text = Math.Round(InvoieAmountTP).ToString("#,##0");



                        decimal InvoiceGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("InvoiceGrossAmt") == null ? 0 : row.Field<decimal>("InvoiceGrossAmt"));
                        gv_Area.FooterRow.Cells[4].Text = Math.Round(InvoiceGrossAmt).ToString("#,##0");


                        decimal RejectAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("RejectAmtTP") == null ? 0 : row.Field<decimal>("RejectAmtTP"));
                        gv_Area.FooterRow.Cells[5].Text = Math.Round(RejectAmtTP).ToString("#,##0");



                        decimal RejectGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("RejectGrossAmt") == null ? 0 : row.Field<decimal>("RejectGrossAmt"));
                        gv_Area.FooterRow.Cells[6].Text = Math.Round(RejectGrossAmt).ToString("#,##0");



                        decimal SalesAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesAmtTP") == null ? 0 : row.Field<decimal>("SalesAmtTP"));
                        gv_Area.FooterRow.Cells[7].Text = Math.Round(SalesAmtTP).ToString("#,##0");


                        decimal SalesGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesGrossAmt") == null ? 0 : row.Field<decimal>("SalesGrossAmt"));
                        gv_Area.FooterRow.Cells[8].Text = Math.Round(SalesGrossAmt).ToString("#,##0");



                        decimal ReturnAmountTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReturnAmountTP") == null ? 0 : row.Field<decimal>("ReturnAmountTP"));
                        gv_Area.FooterRow.Cells[9].Text = Math.Round(ReturnAmountTP).ToString("#,##0");





                        decimal ReturnGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReturnGrossAmt") == null ? 0 : row.Field<decimal>("ReturnGrossAmt"));
                        gv_Area.FooterRow.Cells[10].Text = Math.Round(ReturnGrossAmt).ToString("#,##0");




                        decimal JustSalesAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesAmtTP") == null ? 0 : row.Field<decimal>("JustSalesAmtTP"));
                        gv_Area.FooterRow.Cells[11].Text = Math.Round(JustSalesAmtTP).ToString("#,##0");






                        decimal JustSalesGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesGrossAmt") == null ? 0 : row.Field<decimal>("JustSalesGrossAmt"));
                        gv_Area.FooterRow.Cells[12].Text = Math.Round(JustSalesGrossAmt).ToString("#,##0");




                        decimal CollectionAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("CollectionAmtTP") == null ? 0 : row.Field<decimal>("CollectionAmtTP"));
                        gv_Area.FooterRow.Cells[13].Text = Math.Round(CollectionAmtTP).ToString("#,##0");





                        decimal CollectionGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("CollectionGrossAmt") == null ? 0 : row.Field<decimal>("CollectionGrossAmt"));
                        gv_Area.FooterRow.Cells[14].Text = Math.Round(CollectionGrossAmt).ToString("#,##0");

                        try
                        {
                            decimal ReceivableTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReceivableTP") == null ? 0 : row.Field<decimal>("ReceivableTP"));
                            gv_Area.FooterRow.Cells[15].Text = Math.Round(ReceivableTP).ToString("#,##0");
                        }
                        catch (Exception ex)
                        {

                        }


                        decimal ReceivableGrossAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReceivableGrossAmount") == null ? 0 : row.Field<decimal>("ReceivableGrossAmount"));
                        gv_Area.FooterRow.Cells[16].Text = Math.Round(ReceivableGrossAmount).ToString("#,##0");






                        gv_Area.FooterRow.BackColor = System.Drawing.Color.Bisque;
                        gv_Area.FooterRow.Font.Bold = true;
                        gv_Area.FooterRow.HorizontalAlign = HorizontalAlign.Right;
                    }

                    catch { }
                }


                if (Type == "TerritoryTran" || Type == "TerritoryNONTran")
                {
                    gv_Territory.DataSource = aDataTable;
                    gv_Territory.DataBind();


                    try
                    {

                        gv_Territory.FooterRow.Cells[2].Text = "Total:";


                        decimal NumberofInvoice = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofInvoice") == null ? 0 : row.Field<int>("NumberofInvoice"));
                        gv_Territory.FooterRow.Cells[3].Text = Math.Round(NumberofInvoice).ToString();

                        decimal InvoieAmountTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("InvoieAmountTP") == null ? 0 : row.Field<decimal>("InvoieAmountTP"));
                        gv_Territory.FooterRow.Cells[4].Text = Math.Round(InvoieAmountTP).ToString("#,##0");



                        decimal InvoiceGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("InvoiceGrossAmt") == null ? 0 : row.Field<decimal>("InvoiceGrossAmt"));
                        gv_Territory.FooterRow.Cells[5].Text = Math.Round(InvoiceGrossAmt).ToString("#,##0");


                        decimal RejectAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("RejectAmtTP") == null ? 0 : row.Field<decimal>("RejectAmtTP"));
                        gv_Territory.FooterRow.Cells[6].Text = Math.Round(RejectAmtTP).ToString("#,##0");



                        decimal RejectGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("RejectGrossAmt") == null ? 0 : row.Field<decimal>("RejectGrossAmt"));
                        gv_Territory.FooterRow.Cells[7].Text = Math.Round(RejectGrossAmt).ToString("#,##0");



                        decimal SalesAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesAmtTP") == null ? 0 : row.Field<decimal>("SalesAmtTP"));
                        gv_Territory.FooterRow.Cells[8].Text = Math.Round(SalesAmtTP).ToString("#,##0");


                        decimal SalesGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesGrossAmt") == null ? 0 : row.Field<decimal>("SalesGrossAmt"));
                        gv_Territory.FooterRow.Cells[9].Text = Math.Round(SalesGrossAmt).ToString("#,##0");



                        decimal ReturnAmountTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReturnAmountTP") == null ? 0 : row.Field<decimal>("ReturnAmountTP"));
                        gv_Territory.FooterRow.Cells[10].Text = Math.Round(ReturnAmountTP).ToString("#,##0");





                        decimal ReturnGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReturnGrossAmt") == null ? 0 : row.Field<decimal>("ReturnGrossAmt"));
                        gv_Territory.FooterRow.Cells[11].Text = Math.Round(ReturnGrossAmt).ToString("#,##0");




                        decimal JustSalesAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesAmtTP") == null ? 0 : row.Field<decimal>("JustSalesAmtTP"));
                        gv_Territory.FooterRow.Cells[12].Text = Math.Round(JustSalesAmtTP).ToString("#,##0");






                        decimal JustSalesGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesGrossAmt") == null ? 0 : row.Field<decimal>("JustSalesGrossAmt"));
                        gv_Territory.FooterRow.Cells[13].Text = Math.Round(JustSalesGrossAmt).ToString("#,##0");




                        decimal CollectionAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("CollectionAmtTP") == null ? 0 : row.Field<decimal>("CollectionAmtTP"));
                        gv_Territory.FooterRow.Cells[14].Text = Math.Round(CollectionAmtTP).ToString("#,##0");





                        decimal CollectionGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("CollectionGrossAmt") == null ? 0 : row.Field<decimal>("CollectionGrossAmt"));
                        gv_Territory.FooterRow.Cells[15].Text = Math.Round(CollectionGrossAmt).ToString("#,##0");

                        try
                        {
                            decimal ReceivableTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReceivableTP") == null ? 0 : row.Field<decimal>("ReceivableTP"));
                            gv_Territory.FooterRow.Cells[16].Text = Math.Round(ReceivableTP).ToString("#,##0");
                        }
                        catch (Exception ex)
                        {

                        }


                        decimal ReceivableGrossAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReceivableGrossAmount") == null ? 0 : row.Field<decimal>("ReceivableGrossAmount"));
                        gv_Territory.FooterRow.Cells[17].Text = Math.Round(ReceivableGrossAmount).ToString("#,##0");
                        gv_Territory.FooterRow.BackColor = System.Drawing.Color.Bisque;
                        gv_Territory.FooterRow.Font.Bold = true;
                        gv_Territory.FooterRow.HorizontalAlign = HorizontalAlign.Right;

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

                string attachment = "attachment; filename=" + Type + "BusinessSummary_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
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


                string attachment = "attachment; filename=" + Type + "BusinessSummary_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
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


                string headerTable = @"<span  style='text-align:center'><h3>" + Type + " Business Summary Report  (Date Range : " + fromDateTextBox.Text + "- " + toDateTextBox.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

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
        Response.Redirect("RptBussinessSummary_Loading.aspx");
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