using CrystalDecisions.Shared;
using DocumentFormat.OpenXml.Office.CustomXsn;
using Library.BLL.SInventory_BLL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class SInventory_UI_TotalSummaryNew : System.Web.UI.Page
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
        //if (!IsPostBack)
        //{

        //    fromDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
        //    toDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
        //    DropDownlist();
        //}

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


    protected void rbReportTypeName_SelectedIndexChanged(object sender, EventArgs e)
    {
        loadGridView.DataSource = null;
        loadGridView.DataBind();

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

        if (rbReportTypeName.Items[2].Selected == true)
        {
            divMrk.Visible = true;
        }
        if (rbReportTypeName.Items[3].Selected == true)
        {
            F_TeritorySelect.Enabled = true;

            divMrk.Visible = true;
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

            HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");


            HeaderCell.ColumnSpan = 1;

            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Invoice";
            HeaderCell.ColumnSpan = 4;
            HeaderCell.BackColor = Color.DeepSkyBlue;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Return";
            HeaderCell.ColumnSpan = 4;
            HeaderCell.BackColor = Color.Red;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Sales";
            HeaderCell.BackColor = Color.GreenYellow;
            HeaderCell.ColumnSpan = 6;
            HeaderGridRow.Cells.Add(HeaderCell);



            //HeaderCell = new TableCell();
            //HeaderCell.Text = "Collection";
            //HeaderCell.BackColor = Color.LightSeaGreen;
            //HeaderCell.ColumnSpan = 3;
            //HeaderGridRow.Cells.Add(HeaderCell);


            //HeaderCell = new TableCell();
            //HeaderCell.Text = "Outstanding";
            //HeaderCell.BackColor = Color.Yellow;
            //HeaderCell.ColumnSpan = 3;
            //HeaderGridRow.Cells.Add(HeaderCell);



            loadGridView.Controls[0].Controls.AddAt(0, HeaderGridRow);

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
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
     
    //    aOrderInfoBll.LoadZone(zoneDropDownList, Session["UserId"].ToString());

        aOrderInfoBll.LoadSCZoneWise(salesCenterDropDownList);

       // salesCenterDropDownList.SelectedIndex = 1;
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        LoadInfo();
    }  
    //private string GenerateParameter()
    //{
    //    string parameter = " WHERE ";

    //    if (custcodenameTextBox.Text != "")
    //    {
    //        parameter = parameter + "CustomerCode = '" + custcodenameTextBox.Text.Trim() + "' AND ";
    //    }

    //    if (districtNameDropDownList.SelectedValue != "")
    //    {
    //        parameter = parameter + "DistrictCode = '" + districtNameDropDownList.SelectedValue.Trim() + "' AND ";
    //    }

    //    if (areaNameDropDownList.SelectedValue != "")
    //    {
    //        parameter = parameter + "AreaCode = '" + areaNameDropDownList.SelectedValue.Trim() + "' AND ";
    //    }

    //    if (miaNameDropDownList.SelectedValue != "")
    //    {
    //        parameter = parameter + "MIACode = '" + miaNameDropDownList.SelectedValue.Trim() + "' AND ";
    //    }

    //    if (marketNameDropDownList.SelectedValue != "")
    //    {
    //        parameter = parameter + "MarketCode = '" + marketNameDropDownList.SelectedValue.Trim() + "' AND ";
    //    }

    //    if (regionNameDropDownList.SelectedValue != "")
    //    {
    //        parameter = parameter + "RegionCode = '" + regionNameDropDownList.SelectedValue.Trim() + "' AND ";
    //    }
    //    //if (yearDropDownList.SelectedValue != "")
    //    //{
    //    //    parameter = parameter + "cast(datepart(yyyy,tblInvoice.UpdateDate) as varchar)  = '" + yearDropDownList.SelectedValue.Trim() + "' AND ";
    //    //}
    //    //if (monthDropDownList.SelectedValue != "")
    //    //{
    //    //    parameter = parameter + "DATENAME(mm, tblInvoice.UpdateDate) = '" + monthDropDownList.SelectedValue.Trim() + "' AND ";
    //    //}

    //    parameter = parameter.Remove(parameter.Length - 5);


    //    return parameter;
    //}
    private void LoadInfo()
    {
        try
        {
            // Only Datetime Load
            if (fromDateTextBox.Text != "" && toDateTextBox.Text != "" && zoneDropDownList.SelectedValue == ""
                && salesCenterDropDownList.SelectedValue == "" && territoryDropDownList.SelectedValue == "")
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


                     
                        Type = "Area";
                     
                }

                else if (rbReportTypeName.Items[3].Selected)
                {
                    ZonId = F_ZoneSelect.SelectedValue;
                    Area = F_AreaSelect.SelectedValue;
                    Terr = F_TeritorySelect.SelectedValue;
                    
                        Type = "Territory";
                     
                } 

                aDataTable = aSummaryBll.LoadSummaryProductcodewise(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()), Type, ZonId, Area, Terr);
                if (aDataTable.Rows.Count > 0)
                {
                    loadGridView.DataSource = aDataTable;
                    loadGridView.DataBind();


                    //decimal total = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofProformaInvoice") == null ? 0 : row.Field<int>("NumberofProformaInvoice"));
                    loadGridView.FooterRow.Cells[1].Text = "Total";
                    loadGridView.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
                    //  loadGridView.FooterRow.Cells[2].Text = Math.Round(total).ToString();



                    decimal total2 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NumberofProformaInvoice") == null ? 0 : row.Field<decimal>("NumberofProformaInvoice"));
                    loadGridView.FooterRow.Cells[2].Text = (total2).ToString("#,##0");


                    decimal total3 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetProformaAmount") == null ? 0 : row.Field<decimal>("SumofNetProformaAmount"));
                    loadGridView.FooterRow.Cells[3].Text = (total3).ToString("");


                    decimal total4 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ProTpVat") == null ? 0 : row.Field<decimal>("ProTpVat"));
                    loadGridView.FooterRow.Cells[4].Text = (total4).ToString("#,##0");


                    decimal total5 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossProforma") == null ? 0 : row.Field<decimal>("GrossProforma"));
                    loadGridView.FooterRow.Cells[5].Text = (total5).ToString("#,##0");


                    Int32 total6 = aDataTable.AsEnumerable().Sum(row => row.Field<Int32?>("RetQty") == null ? 0 : row.Field<Int32>("RetQty"));
                    loadGridView.FooterRow.Cells[6].Text = (total6).ToString("#,##0");

                    decimal total7 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetReturnAmount") == null ? 0 : row.Field<decimal>("SumofNetReturnAmount"));
                    loadGridView.FooterRow.Cells[7].Text =(total7).ToString("#,##0");

                    decimal total8 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));
                    loadGridView.FooterRow.Cells[8].Text = (total8).ToString("#,##0");

                    decimal total9 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossRetuen") == null ? 0 : row.Field<decimal>("GrossRetuen"));
                    loadGridView.FooterRow.Cells[9].Text = (total9).ToString("#,##0");

                    decimal total10 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NumberofInvoiceSold") == null ? 0 : row.Field<decimal>("NumberofInvoiceSold"));
                    loadGridView.FooterRow.Cells[10].Text = (total10).ToString("#,##0");


                    decimal total11 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("bouns") == null ? 0 : row.Field<decimal>("bouns"));
                    loadGridView.FooterRow.Cells[11].Text =(total11).ToString("#,##0");

                    decimal total12 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));
                    loadGridView.FooterRow.Cells[12].Text =(total12).ToString("#,##0");

                    decimal total13 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelTpVat") == null ? 0 : row.Field<decimal>("DelTpVat"));
                    loadGridView.FooterRow.Cells[13].Text = (total13).ToString("#,##0");

                    decimal total14 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossSales") == null ? 0 : row.Field<decimal>("GrossSales"));
                    loadGridView.FooterRow.Cells[14].Text = (total14).ToString("#,##0");

                    decimal total15 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalDiscountAmount") == null ? 0 : row.Field<decimal>("TotalDiscountAmount"));
                    loadGridView.FooterRow.Cells[15].Text = (total15).ToString("#,##0");

                    //decimal total16 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmountCollection") == null ? 0 : row.Field<decimal>("SumofNetSalesAmountCollection"));
                    //loadGridView.FooterRow.Cells[16].Text = (((total16)).ToString("#,##0"));



                    ////

                    //decimal total17 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelTpVatCollection") == null ? 0 : row.Field<decimal>("DelTpVatCollection"));
                    //loadGridView.FooterRow.Cells[17].Text = (total17).ToString("#,##0");

                    //decimal total18 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossSalesCollection") == null ? 0 : row.Field<decimal>("GrossSalesCollection"));
                    //loadGridView.FooterRow.Cells[18].Text = (total18).ToString("#,##0");

                    //decimal total19 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossSalesCollection") == null ? 0 : row.Field<decimal>("GrossSalesCollection"));
                    //loadGridView.FooterRow.Cells[19].Text = (((total19)).ToString("#,##0"));
                }
                else
                {
                    showMessageBox("No Data Found!!");
                    loadGridView.DataSource = null;
                    loadGridView.DataBind();
                }
            }

            //// zoneDropDownList wise Report
            //else if (fromDateTextBox.Text != "" && toDateTextBox.Text != "" && zoneDropDownList.SelectedValue != ""
            //  && salesCenterDropDownList.SelectedValue == "" && territoryDropDownList.SelectedValue == "")
            //{
            //    DataTable aDataTable = new DataTable();

            //    aDataTable = aSummaryBll.LoadSummaryzonewiseBLL(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()),
            //        Convert.ToString(zoneDropDownList.SelectedValue));
            //    if (aDataTable.Rows.Count > 0)
            //    {
            //        loadGridView.DataSource = aDataTable;
            //        loadGridView.DataBind();
            //        //   decimal total = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofProformaInvoice") == null ? 0 : row.Field<int>("NumberofProformaInvoice"));
            //        //   loadGridView.FooterRow.Cells[1].Text = "Total";
            //        //   loadGridView.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
            //        ////   loadGridView.FooterRow.Cells[2].Text = Math.Round(total).ToString();
            //        //   decimal total2 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetProformaAmount") == null ? 0 : row.Field<decimal>("SumofNetProformaAmount"));
            //        //   loadGridView.FooterRow.Cells[4].Text = Math.Round(total2).ToString("#,##0");
            //        //   decimal total3 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ProTpVat") == null ? 0 : row.Field<decimal>("ProTpVat"));

            //        //   loadGridView.FooterRow.Cells[5].Text = Math.Round(total3).ToString("#,##0");


            //        //   decimal total4 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetInvoiceAmt") == null ? 0 : row.Field<decimal>("NetInvoiceAmt"));

            //        //   loadGridView.FooterRow.Cells[6].Text = Math.Round(total4).ToString("#,##0");


            //        //   decimal total5 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetReturnAmount") == null ? 0 : row.Field<decimal>("SumofNetReturnAmount"));

            //        //   loadGridView.FooterRow.Cells[8].Text = Math.Round(total5).ToString("#,##0");


            //        //   decimal total6 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));

            //        //   loadGridView.FooterRow.Cells[9].Text = Math.Round(total6).ToString("#,##0");

            //        //   decimal total7 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetReturnAmt") == null ? 0 : row.Field<decimal>("NetReturnAmt"));

            //        //   loadGridView.FooterRow.Cells[10].Text = Math.Round(total7).ToString("#,##0");

            //        //   decimal total8 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("salesTP") == null ? 0 : row.Field<decimal>("salesTP"));

            //        //   loadGridView.FooterRow.Cells[11].Text = Math.Round(total8).ToString("#,##0");

            //        //   decimal total9 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesVat") == null ? 0 : row.Field<decimal>("SalesVat"));

            //        //   loadGridView.FooterRow.Cells[12].Text = Math.Round(total9).ToString("#,##0");

            //        //   decimal total10 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesTotal") == null ? 0 : row.Field<decimal>("SalesTotal"));

            //        //   loadGridView.FooterRow.Cells[13].Text = Math.Round(total10).ToString("#,##0");


            //        //   decimal total11 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));

            //        //   loadGridView.FooterRow.Cells[15].Text = Math.Round(total11).ToString("#,##0");

            //        //   decimal total12 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelTpVat") == null ? 0 : row.Field<decimal>("DelTpVat"));

            //        //   loadGridView.FooterRow.Cells[16].Text = Math.Round(total12).ToString("#,##0");

            //        //   decimal total13 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetSalesAmt") == null ? 0 : row.Field<decimal>("NetSalesAmt"));

            //        //   loadGridView.FooterRow.Cells[17].Text = Math.Round(total13).ToString("#,##0");

            //        //   decimal total14 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding1") == null ? 0 : row.Field<decimal>("Outstanding1"));

            //        //   loadGridView.FooterRow.Cells[19].Text = Math.Round(total14).ToString("#,##0");

            //        //   decimal total15 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding2") == null ? 0 : row.Field<decimal>("Outstanding2"));

            //        //   loadGridView.FooterRow.Cells[20].Text = Math.Round(total15).ToString("#,##0");

            //        //   decimal total16 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding3") == null ? 0 : row.Field<decimal>("Outstanding3"));

            //        //   loadGridView.FooterRow.Cells[21].Text = (Math.Round((total16)).ToString("#,##0"));
            //    }
            //    else
            //    {
            //        showMessageBox("No Data Found!!");
            //        loadGridView.DataSource = null;
            //        loadGridView.DataBind();
            //    }
            //}
            //else if (fromDateTextBox.Text != "" && toDateTextBox.Text != "" && zoneDropDownList.SelectedValue != ""
            // && salesCenterDropDownList.SelectedValue != "" && territoryDropDownList.SelectedValue == "")
            //{
            //    DataTable aDataTable = new DataTable();

            //    aDataTable = aSummaryBll.LoadSummaryzoneBranchwiseBLL(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()),
            //        Convert.ToString(zoneDropDownList.SelectedValue), salesCenterDropDownList.SelectedValue);
            //    if (aDataTable.Rows.Count > 0)
            //    {
            //        loadGridView.DataSource = aDataTable;
            //        loadGridView.DataBind();
            //        //decimal total = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofProformaInvoice") == null ? 0 : row.Field<int>("NumberofProformaInvoice"));
            //        //loadGridView.FooterRow.Cells[1].Text = "Total";
            //        //loadGridView.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
            //        ////   loadGridView.FooterRow.Cells[2].Text = Math.Round(total).ToString();
            //        //decimal total2 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetProformaAmount") == null ? 0 : row.Field<decimal>("SumofNetProformaAmount"));
            //        //loadGridView.FooterRow.Cells[4].Text = Math.Round(total2).ToString("#,##0");
            //        //decimal total3 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ProTpVat") == null ? 0 : row.Field<decimal>("ProTpVat"));

            //        //loadGridView.FooterRow.Cells[5].Text = Math.Round(total3).ToString("#,##0");


            //        //decimal total4 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetInvoiceAmt") == null ? 0 : row.Field<decimal>("NetInvoiceAmt"));

            //        //loadGridView.FooterRow.Cells[6].Text = Math.Round(total4).ToString("#,##0");


            //        //decimal total5 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetReturnAmount") == null ? 0 : row.Field<decimal>("SumofNetReturnAmount"));

            //        //loadGridView.FooterRow.Cells[8].Text = Math.Round(total5).ToString("#,##0");


            //        //decimal total6 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));

            //        //loadGridView.FooterRow.Cells[9].Text = Math.Round(total6).ToString("#,##0");

            //        //decimal total7 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetReturnAmt") == null ? 0 : row.Field<decimal>("NetReturnAmt"));

            //        //loadGridView.FooterRow.Cells[10].Text = Math.Round(total7).ToString("#,##0");

            //        //decimal total8 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("salesTP") == null ? 0 : row.Field<decimal>("salesTP"));

            //        //loadGridView.FooterRow.Cells[11].Text = Math.Round(total8).ToString("#,##0");

            //        //decimal total9 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesVat") == null ? 0 : row.Field<decimal>("SalesVat"));

            //        //loadGridView.FooterRow.Cells[12].Text = Math.Round(total9).ToString("#,##0");

            //        //decimal total10 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesTotal") == null ? 0 : row.Field<decimal>("SalesTotal"));

            //        //loadGridView.FooterRow.Cells[13].Text = Math.Round(total10).ToString("#,##0");


            //        //decimal total11 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));

            //        //loadGridView.FooterRow.Cells[15].Text = Math.Round(total11).ToString("#,##0");

            //        //decimal total12 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelTpVat") == null ? 0 : row.Field<decimal>("DelTpVat"));

            //        //loadGridView.FooterRow.Cells[16].Text = Math.Round(total12).ToString("#,##0");

            //        //decimal total13 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetSalesAmt") == null ? 0 : row.Field<decimal>("NetSalesAmt"));

            //        //loadGridView.FooterRow.Cells[17].Text = Math.Round(total13).ToString("#,##0");

            //        //decimal total14 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding1") == null ? 0 : row.Field<decimal>("Outstanding1"));

            //        //loadGridView.FooterRow.Cells[19].Text = Math.Round(total14).ToString("#,##0");

            //        //decimal total15 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding2") == null ? 0 : row.Field<decimal>("Outstanding2"));

            //        //loadGridView.FooterRow.Cells[20].Text = Math.Round(total15).ToString("#,##0");

            //        //decimal total16 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding3") == null ? 0 : row.Field<decimal>("Outstanding3"));

            //        //loadGridView.FooterRow.Cells[21].Text = (Math.Round((total16)).ToString("#,##0"));
            //    }
            //    else
            //    {
            //        showMessageBox("No Data Found!!");
            //        loadGridView.DataSource = null;
            //        loadGridView.DataBind();
            //    }
            //}
            //else if (fromDateTextBox.Text != "" && toDateTextBox.Text != "" && zoneDropDownList.SelectedValue == ""
            // && salesCenterDropDownList.SelectedValue != "" && territoryDropDownList.SelectedValue == "")
            //{
            //    DataTable aDataTable = new DataTable();

            //    aDataTable = aSummaryBll.LoadSummaryzoneBranchTerritorywiseBLL(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()),
            //        salesCenterDropDownList.SelectedValue);
            //    if (aDataTable.Rows.Count > 0)
            //    {
            //        loadGridView.DataSource = aDataTable;
            //        loadGridView.DataBind();
            //        //decimal total = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofProformaInvoice") == null ? 0 : row.Field<int>("NumberofProformaInvoice"));
            //        loadGridView.FooterRow.Cells[1].Text = "Total";
            //        loadGridView.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
            //        //  loadGridView.FooterRow.Cells[2].Text = Math.Round(total).ToString();



            //        decimal total2 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NumberofProformaInvoice") == null ? 0 : row.Field<decimal>("NumberofProformaInvoice"));
            //        loadGridView.FooterRow.Cells[2].Text = (total2).ToString("#,##0");


            //        decimal total3 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetProformaAmount") == null ? 0 : row.Field<decimal>("SumofNetProformaAmount"));
            //        loadGridView.FooterRow.Cells[3].Text = (total3).ToString("");


            //        decimal total4 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ProTpVat") == null ? 0 : row.Field<decimal>("ProTpVat"));
            //        loadGridView.FooterRow.Cells[4].Text = (total4).ToString("#,##0");


            //        decimal total5 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossProforma") == null ? 0 : row.Field<decimal>("GrossProforma"));
            //        loadGridView.FooterRow.Cells[5].Text = (total5).ToString("#,##0");


            //        decimal total6 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("RetQty") == null ? 0 : row.Field<decimal>("RetQty"));
            //        loadGridView.FooterRow.Cells[6].Text = (total6).ToString("#,##0");

            //        decimal total7 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetReturnAmount") == null ? 0 : row.Field<decimal>("SumofNetReturnAmount"));
            //        loadGridView.FooterRow.Cells[7].Text = (total7).ToString("#,##0");

            //        decimal total8 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));
            //        loadGridView.FooterRow.Cells[8].Text = (total8).ToString("#,##0");

            //        decimal total9 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossRetuen") == null ? 0 : row.Field<decimal>("GrossRetuen"));
            //        loadGridView.FooterRow.Cells[9].Text = (total9).ToString("#,##0");

            //        decimal total10 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NumberofInvoiceSold") == null ? 0 : row.Field<decimal>("NumberofInvoiceSold"));
            //        loadGridView.FooterRow.Cells[10].Text = (total10).ToString("#,##0");


            //        decimal total11 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("bouns") == null ? 0 : row.Field<decimal>("bouns"));
            //        loadGridView.FooterRow.Cells[11].Text = (total11).ToString("#,##0");

            //        decimal total12 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));
            //        loadGridView.FooterRow.Cells[12].Text = (total12).ToString("#,##0");

            //        decimal total13 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelTpVat") == null ? 0 : row.Field<decimal>("DelTpVat"));
            //        loadGridView.FooterRow.Cells[13].Text = (total13).ToString("#,##0");

            //        decimal total14 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossSales") == null ? 0 : row.Field<decimal>("GrossSales"));
            //        loadGridView.FooterRow.Cells[14].Text = (total14).ToString("#,##0");

            //        decimal total15 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalDiscountAmount") == null ? 0 : row.Field<decimal>("TotalDiscountAmount"));
            //        loadGridView.FooterRow.Cells[15].Text = (total15).ToString("#,##0");

            //        decimal total16 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmountCollection") == null ? 0 : row.Field<decimal>("SumofNetSalesAmountCollection"));
            //        loadGridView.FooterRow.Cells[16].Text = (((total16)).ToString("#,##0"));



            //        //

            //        decimal total17 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelTpVatCollection") == null ? 0 : row.Field<decimal>("DelTpVatCollection"));
            //        loadGridView.FooterRow.Cells[17].Text = (total17).ToString("#,##0");

            //        decimal total18 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossSalesCollection") == null ? 0 : row.Field<decimal>("GrossSalesCollection"));
            //        loadGridView.FooterRow.Cells[18].Text = (total18).ToString("#,##0");

            //        //decimal total19 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossSalesCollection") == null ? 0 : row.Field<decimal>("GrossSalesCollection"));
            //        //loadGridView.FooterRow.Cells[19].Text = (((total19)).ToString("#,##0"));
            //    }
            //    else
            //    {
            //        showMessageBox("No Data Found!!");
            //        loadGridView.DataSource = null;
            //        loadGridView.DataBind();
            //    }
            //}
            else
            {
                showMessageBox("Please Select Date Range!!");
            }
        }
        catch (Exception)
        {
            showMessageBox("Somthing went wrong");
            //throw;
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
        if (loadGridView.Rows.Count > 0)
        {

            string level = GetReportScopeLevel();
            string rptName = "";
            if (level == "1")
                rptName = "Distribution Center";
            else if (level == "2")
            {
                rptName = "Zone";

            }
            else if (level == "3")
            {

                rptName = "Area";
            }
            else if (level == "4")
            {


                rptName = "Territory";
            }
            string attachment = "attachment; filename=Product wise BS_"+rptName + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_ss_tt") + ".xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            loadGridView.AllowPaging = false;



            //loadGridView.Columns[loadGridView.Columns.Count - 1].Visible =
            //            false;
            //loadGridView.Columns[loadGridView.Columns.Count - 2].Visible =
            //   false;
            //loadGridView.Columns[loadGridView.Columns.Count - 3].Visible =
            //   false;

            this.LoadInfo();

            // Create a form to contain the grid  
            HtmlForm frm = new HtmlForm();
            loadGridView.Parent.Controls.Add(frm);
            //frm.Attributes["runat"] = "server";
            //frm.Controls.Add(loadGridView);
            //frm.RenderControl(htw);

            loadGridView.HeaderRow.Style.Add("background-color", "#E5EEF1");

            // Set background color of each cell of GridView1 header row
            foreach (TableCell tableCell in loadGridView.HeaderRow.Cells)
            {
                tableCell.Style["background-color"] = "#E5EEF1";
            }

            // Set background color of each cell of each data row of GridView1
            foreach (GridViewRow gridViewRow in loadGridView.Rows)
            {
                gridViewRow.BackColor = System.Drawing.Color.White;

                foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                {
                    gridViewRowTableCell.Style["background-color"] = "#FFFFFF";

                }
            }


            loadGridView.RenderControl(htw);
            
             
            string headerTable = @"<span  style='text-align:center'><h4> Product wise Business Summary ("+ rptName + ") </h4>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

            string subtitle = BuildSubtitle(fromDateTextBox.Text, toDateTextBox.Text);

            // গ্রিডের ওপর একটি কাস্টম হেডার/সাব-টাইটেল লিখে দিই
            int colSpan = loadGridView.Columns.Count > 0 ? loadGridView.Columns.Count : 1;
            htw.Write(@"
<table border='0' cellpadding='4' cellspacing='0' style='font-family:Segoe UI, Arial; font-size:16px;'>
  
  <tr>
    <td colspan='{colSpan}' style='font-weight:bold;font-size:16px; padding-bottom:6px;'>{subtitle}</td>
  </tr>
</table>
");

            HttpContext.Current.Response.Write(headerTable);
            HttpContext.Current.Response.Write(subtitle);

            Response.Write(sw.ToString());
            Response.End();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
    }

   

    public string BuildSubtitle(string fromDate, string toDate)
    {
        string group = SelText(F_GroupSelect);
        string period = "Period: " + fromDate   + " to " + toDate;

        string level = GetReportScopeLevel();
        string scope = string.Empty;
        string result = string.Empty;
        if (level == "1")
            scope = "Distribution Center";
        else if (level == "2")
        {
            scope = "Zone";
            if (!string.IsNullOrWhiteSpace(group)) result = "Group: " + group;
        }
        else if (level == "3")
        {
            if (!string.IsNullOrWhiteSpace(group)) result = "Group: " + group;
            scope = "Area: " + SelText(F_AreaSelect) + "  |  Zone: " + SelText(F_ZoneSelect);
        }
        else if (level == "4")
        {

            if (!string.IsNullOrWhiteSpace(group)) result = "Group: " + group;
            scope = "Territory: " + SelText(F_TeritorySelect) + "  |  Area: " + SelText(F_AreaSelect);
        }

       
        
        if (!string.IsNullOrWhiteSpace(scope)) result = string.IsNullOrEmpty(result) ? scope : result + "  |  " + scope;
        result = string.IsNullOrEmpty(result) ? period : result + "  |  " + period;

        return result;
    }

    private string BuildScopeForFile()
    {
        string level = GetReportScopeLevel();
        string txt = string.Empty;
        if (level == "1") txt = SelText(salesCenterDropDownList);
        else if (level == "2") txt = SelText(F_ZoneSelect);
        else if (level == "3") txt = SelText(F_AreaSelect);
        else if (level == "4") txt = SelText(F_TeritorySelect);
        string scopePart = string.IsNullOrWhiteSpace(txt) ? level : (level + "_" + txt);
        return Regex.Replace(scopePart, @"[^\w\-]+", "_").Trim('_'); // safe filename
    }

    private string GetReportScopeLevel()
    {
        return (rbReportTypeName != null && !string.IsNullOrEmpty(rbReportTypeName.SelectedValue))
                ? rbReportTypeName.SelectedValue.Trim()
                : "1";
    }
    private string SelText(DropDownList ddl)
    {
        if (ddl == null || ddl.SelectedItem == null) return string.Empty;
        string t = ddl.SelectedItem.Text != null ? ddl.SelectedItem.Text.Trim() : string.Empty;
        return t.ToLower().Contains("please select") ? string.Empty : t;
    }
    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        aOrderInfoBll.LoadTerritory(territoryDropDownList, salesCenterDropDownList.SelectedValue);
    }
    protected void zoneDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        aOrderInfoBll.LoadSCZoneWise(salesCenterDropDownList, zoneDropDownList.SelectedValue);
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("TotalSummaryNew.aspx");
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