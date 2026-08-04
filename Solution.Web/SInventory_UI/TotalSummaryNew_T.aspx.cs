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
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_TotalSummaryNew_T : System.Web.UI.Page
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
        //ReportTypeWise();

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

                   rbReportTypeName.Items[1].Selected = true;
               
                ListItem item = rbReportTypeName.Items.FindByValue("1");
                //ListItem item2 = rbReportTypeName.Items.FindByValue("2");
                //ListItem item3 = rbReportTypeName.Items.FindByValue("3");
                //item3.Selected = true;

                rbReportTypeName_SelectedIndexChanged(null, null);
                // If the item is found, make it invisible
                if (item != null)
                {
                    item.Enabled = false;
                }
                //if (item2 != null)
                //{
                //    item2.Enabled = false;
                //}
            }

            if (RoleTypeName == "AM")
            {
                ListItem item = rbReportTypeName.Items.FindByValue("1");
                ListItem item2 = rbReportTypeName.Items.FindByValue("2");
                ListItem item3 = rbReportTypeName.Items.FindByValue("3");
                item3.Selected = true;

                rbReportTypeName_SelectedIndexChanged(null, null);
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
            //ReportTypeWise();

            //   ReportTypeWise();


        }
    }





    //private void ReportTypeWise()
    //{
    //    switch (ToRoleTypeId)
    //    {
    //        case "3":

    //            rbReportTypeName.Items.FindByValue("1").Attributes.Add("style", "display:none");
    //            rbReportTypeName.Items.FindByValue("1").Selected = false;
    //            break;
    //        case "2":
    //            rbReportTypeName.Items.FindByValue("1").Attributes.Add("style", "display:none");
    //            rbReportTypeName.Items.FindByValue("2").Attributes.Add("style", "display:none");

    //            rbReportTypeName.Items.FindByValue("1").Selected = false;
    //            rbReportTypeName.Items.FindByValue("2").Selected = false;
    //            break;
    //    }
    //}


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

            //HeaderCell = new TableCell();
            //HeaderCell.Text = "Sales";
            //HeaderCell.BackColor = Color.GreenYellow;
            //HeaderCell.ColumnSpan = 3;
            //HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Sales & Collection";
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

            //HeaderCell = new TableCell();
            //HeaderCell.Text = "Sales";
            //HeaderCell.BackColor = Color.GreenYellow;
            //HeaderCell.ColumnSpan = 3;
            //HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Sales & Collection";
            HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Receivable";
            HeaderCell.BackColor = Color.Yellow;
            HeaderCell.ColumnSpan = 3;
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
            HeaderCell.Text = "Sales & Collection";
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
            HeaderCell.Text = "Sales & Collection";
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
       // ReportTypeWise();
        LoadInfo();
    }


    protected void rbReportTypeName_SelectedIndexChanged(object sender, EventArgs e)
    {


     //   ReportTypeWise();

        gv_DistributionCenter.DataSource = null;
        gv_DistributionCenter.DataBind();

        gv_Zone.DataSource = null;
        gv_Zone.DataBind();

        gv_Area.DataSource = null;
        gv_Area.DataBind();

        gv_Territory.DataSource = null;
        gv_Territory.DataBind();


        divMrk.Visible = false;

        F_TeritorySelect.Items.Clear();
        F_TeritorySelect.Enabled = false;

        try
        {
      CommonDataLoad _dataLoad = new CommonDataLoad();


            using (DataTable dt = _dataLoad.GetTerritory_ByAreaId_All(Convert.ToInt32(F_AreaSelect.SelectedValue)))
            {
                F_TeritorySelect.DataSource = dt;
                F_TeritorySelect.DataValueField = "TerritoryId";
                F_TeritorySelect.DataTextField = "TerritoryName";
                F_TeritorySelect.DataBind();
                F_TeritorySelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                F_TeritorySelect.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
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

        //ReportTypeWise();
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

            string ZoneId = "";

            if (rbReportTypeName.Items[0].Selected)
            {
                Type = "SC";
            }
            else if (rbReportTypeName.Items[1].Selected)
            {
                Type = "Zone";

                if (RoleTypeName == "DZSM")
                {
                    ZoneId = F_ZoneSelect.SelectedValue;
                    rbReportTypeName.Items[1].Selected = true;
                }
            }

            else if (rbReportTypeName.Items[2].Selected)
            {

                Area= F_AreaSelect.SelectedValue;

                if (ToRoleTypeId == "3")
                {
                    ZoneId = F_ZoneSelect.SelectedValue;

                    if (rbAmount.Items[0].Selected)
                    {
                        Type = "AreaTranForDSM";
                    }
                    else
                    {
                        Type = "AreaNONTranForDSM";
                    }
                }
                else
                {
                    ZoneId = "";

                    if (rbAmount.Items[0].Selected)
                    {
                        Type = "AreaTran";
                    }
                    else
                    {
                        Type = "AreaNONTran";
                    }
                }

            }

            else if (rbReportTypeName.Items[3].Selected)
            {

                Terr = F_TeritorySelect.SelectedValue;
                Area = F_AreaSelect.SelectedValue;
                ZoneId = F_ZoneSelect.SelectedValue;
                if (rbAmount.Items[0].Selected)
                {
                    Type = "TerritoryTran";
                }
                else
                {
                    Type = "TerritoryNONTran";
                }

                //if (Terr == "")
                //{
                //    Type = "AreaTran";
                //    Area = F_AreaSelect.SelectedValue;
                //}
            }
            aDataTable = aSummaryBll.LoadSummaryProductcodewiseGyash__New(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()), Type, Area, Terr, ZoneId);
            if (RoleTypeName == "DZSM")
            {
                if (F_ZoneSelect.SelectedValue == "")
                {
                    aDataTable.Rows.Clear();
                }
            }

              
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

                        //decimal total8 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("salesTP") == null ? 0 : row.Field<decimal>("salesTP"));

                      //  gv_DistributionCenter.FooterRow.Cells[11].Text = Math.Round(total8).ToString("#,##0");

                        //decimal total9 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesVat") == null ? 0 : row.Field<decimal>("SalesVat"));

                       // gv_DistributionCenter.FooterRow.Cells[12].Text = Math.Round(total9).ToString("#,##0");

                        //decimal total10 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesTotal") == null ? 0 : row.Field<decimal>("SalesTotal"));

                      //  gv_DistributionCenter.FooterRow.Cells[13].Text = Math.Round(total10).ToString("#,##0");


                        decimal total11 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));

                        gv_DistributionCenter.FooterRow.Cells[11].Text = Math.Round(total11).ToString("#,##0");

                        decimal total12 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelTpVat") == null ? 0 : row.Field<decimal>("DelTpVat"));

                        gv_DistributionCenter.FooterRow.Cells[12].Text = Math.Round(total12).ToString("#,##0");

                        decimal total13 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetSalesAmt") == null ? 0 : row.Field<decimal>("NetSalesAmt"));

                        gv_DistributionCenter.FooterRow.Cells[13].Text = Math.Round(total13).ToString("#,##0");



                        decimal total14 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofRCVTP") == null ? 0 : row.Field<decimal>("SumofRCVTP"));

                        gv_DistributionCenter.FooterRow.Cells[14].Text = Math.Round(total14).ToString("#,##0");

                        decimal total15 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofRCVVat") == null ? 0 : row.Field<decimal>("SumofRCVVat"));

                        gv_DistributionCenter.FooterRow.Cells[15].Text = Math.Round(total15).ToString("#,##0");

                        decimal total16 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofRCVAmount") == null ? 0 : row.Field<decimal>("SumofRCVAmount"));

                        gv_DistributionCenter.FooterRow.Cells[16].Text = (Math.Round((total16)).ToString("#,##0"));

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
                        decimal total = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofProformaInvoice") == null ? 0 : row.Field<int>("NumberofProformaInvoice"));
                        gv_Zone.FooterRow.Cells[1].Text = "Total";
                        gv_Zone.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
                        gv_Zone.FooterRow.Cells[2].Text = Math.Round(total).ToString();

                        decimal total2 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetProformaAmount") == null ? 0 : row.Field<decimal>("SumofNetProformaAmount"));

                        gv_Zone.FooterRow.Cells[4].Text = Math.Round(total2).ToString("#,##0");


                        decimal total3 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ProTpVat") == null ? 0 : row.Field<decimal>("ProTpVat"));

                        gv_Zone.FooterRow.Cells[5].Text = Math.Round(total3).ToString("#,##0");


                        decimal total4 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetInvoiceAmt") == null ? 0 : row.Field<decimal>("NetInvoiceAmt"));

                        gv_Zone.FooterRow.Cells[6].Text = Math.Round(total4).ToString("#,##0");


                        decimal total5 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetReturnAmount") == null ? 0 : row.Field<decimal>("SumofNetReturnAmount"));

                        gv_Zone.FooterRow.Cells[8].Text = Math.Round(total5).ToString("#,##0");


                        decimal total6 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));

                        gv_Zone.FooterRow.Cells[9].Text = Math.Round(total6).ToString("#,##0");

                        decimal total7 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetReturnAmt") == null ? 0 : row.Field<decimal>("NetReturnAmt"));

                        gv_Zone.FooterRow.Cells[10].Text = Math.Round(total7).ToString("#,##0");

                        //decimal total8 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("salesTP") == null ? 0 : row.Field<decimal>("salesTP"));

                        //  gv_DistributionCenter.FooterRow.Cells[11].Text = Math.Round(total8).ToString("#,##0");

                        //decimal total9 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesVat") == null ? 0 : row.Field<decimal>("SalesVat"));

                        // gv_DistributionCenter.FooterRow.Cells[12].Text = Math.Round(total9).ToString("#,##0");

                        //decimal total10 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesTotal") == null ? 0 : row.Field<decimal>("SalesTotal"));

                        //  gv_DistributionCenter.FooterRow.Cells[13].Text = Math.Round(total10).ToString("#,##0");


                        decimal total11 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));

                        gv_Zone.FooterRow.Cells[12].Text = Math.Round(total11).ToString("#,##0");

                        decimal total12 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelTpVat") == null ? 0 : row.Field<decimal>("DelTpVat"));

                        gv_Zone.FooterRow.Cells[13].Text = Math.Round(total12).ToString("#,##0");

                        decimal total13 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetSalesAmt") == null ? 0 : row.Field<decimal>("NetSalesAmt"));

                        gv_Zone.FooterRow.Cells[14].Text = Math.Round(total13).ToString("#,##0");



                        decimal total14 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofRCVTP") == null ? 0 : row.Field<decimal>("SumofRCVTP"));

                        gv_Zone.FooterRow.Cells[16].Text = Math.Round(total14).ToString("#,##0");

                        decimal total15 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofRCVVat") == null ? 0 : row.Field<decimal>("SumofRCVVat"));

                        gv_Zone.FooterRow.Cells[17].Text = Math.Round(total15).ToString("#,##0");

                        decimal total16 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofRCVAmount") == null ? 0 : row.Field<decimal>("SumofRCVAmount"));

                        gv_Zone.FooterRow.Cells[18].Text = (Math.Round((total16)).ToString("#,##0"));

                        gv_Zone.FooterRow.BackColor = System.Drawing.Color.Beige;
                        gv_Zone.FooterRow.Font.Bold = true;
                    }
                    catch { }
            }


                if (Type == "AreaTran" || Type == "AreaNONTran" || Type == "AreaTranForDSM" || Type == "AreaNONTranForDSM")
                {

                    gv_Area.DataSource = aDataTable;
                    gv_Area.DataBind();

                    try
                    {
                        decimal NumberofProformaInvoice = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofProformaInvoice") == null ? 0 : row.Field<int>("NumberofProformaInvoice"));
                        gv_Area.FooterRow.Cells[2].Text = "Total";
                        gv_Area.FooterRow.Cells[2].HorizontalAlign = HorizontalAlign.Right;
                        gv_Area.FooterRow.Cells[3].Text = Math.Round(NumberofProformaInvoice).ToString();

                        decimal SumofNetProformaAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetProformaAmount") == null ? 0 : row.Field<decimal>("SumofNetProformaAmount"));

                        gv_Area.FooterRow.Cells[4].Text = Math.Round(SumofNetProformaAmount).ToString("#,##0");


                        decimal ProTpVat = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ProTpVat") == null ? 0 : row.Field<decimal>("ProTpVat"));

                        gv_Area.FooterRow.Cells[5].Text = Math.Round(ProTpVat).ToString("#,##0");


                        decimal NetInvoiceAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetInvoiceAmt") == null ? 0 : row.Field<decimal>("NetInvoiceAmt"));

                        gv_Area.FooterRow.Cells[6].Text = Math.Round(NetInvoiceAmt).ToString("#,##0");


                        decimal SumofNetReturnAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetReturnAmount") == null ? 0 : row.Field<decimal>("SumofNetReturnAmount"));

                        gv_Area.FooterRow.Cells[7].Text = Math.Round(SumofNetReturnAmount).ToString("#,##0");


                        decimal DelReTpVat = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));

                        gv_Area.FooterRow.Cells[8].Text = Math.Round(DelReTpVat).ToString("#,##0");

                        decimal NetReturnAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetReturnAmt") == null ? 0 : row.Field<decimal>("NetReturnAmt"));

                        gv_Area.FooterRow.Cells[9].Text = Math.Round(NetReturnAmt).ToString("#,##0");

                        decimal SumofNetSalesAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));

                        gv_Area.FooterRow.Cells[10].Text = Math.Round(SumofNetSalesAmount).ToString("#,##0");

                        decimal DelTpVat = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelTpVat") == null ? 0 : row.Field<decimal>("DelTpVat"));

                        gv_Area.FooterRow.Cells[11].Text = Math.Round(DelTpVat).ToString("#,##0");

                        decimal NetSalesAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetSalesAmt") == null ? 0 : row.Field<decimal>("NetSalesAmt"));

                        gv_Area.FooterRow.Cells[12].Text = Math.Round(NetSalesAmt).ToString("#,##0");


                        decimal SumofRCVTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofRCVTP") == null ? 0 : row.Field<decimal>("SumofRCVTP"));

                        gv_Area.FooterRow.Cells[13].Text = Math.Round(SumofRCVTP).ToString("#,##0");

                        decimal SumofRCVVat = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofRCVVat") == null ? 0 : row.Field<decimal>("SumofRCVVat"));

                        gv_Area.FooterRow.Cells[14].Text = Math.Round(SumofRCVVat).ToString("#,##0");

                        decimal SumofRCVAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofRCVAmount") == null ? 0 : row.Field<decimal>("SumofRCVAmount"));

                        gv_Area.FooterRow.Cells[15].Text = Math.Round(SumofRCVAmount).ToString("#,##0");


                    

                        gv_Area.FooterRow.BackColor = System.Drawing.Color.Beige;
                        gv_Area.FooterRow.Font.Bold = true;

                      

                   

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
                        decimal NumberofProformaInvoice = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofProformaInvoice") == null ? 0 : row.Field<int>("NumberofProformaInvoice"));
                        gv_Territory.FooterRow.Cells[3].Text = "Total";
                        gv_Territory.FooterRow.Cells[3].HorizontalAlign = HorizontalAlign.Right;
                        gv_Territory.FooterRow.Cells[4].Text = Math.Round(NumberofProformaInvoice).ToString();

                        decimal SumofNetProformaAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetProformaAmount") == null ? 0 : row.Field<decimal>("SumofNetProformaAmount"));

                        gv_Territory.FooterRow.Cells[5].Text = Math.Round(SumofNetProformaAmount).ToString("#,##0");


                        decimal ProTpVat = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ProTpVat") == null ? 0 : row.Field<decimal>("ProTpVat"));

                        gv_Territory.FooterRow.Cells[6].Text = Math.Round(ProTpVat).ToString("#,##0");


                        decimal NetInvoiceAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetInvoiceAmt") == null ? 0 : row.Field<decimal>("NetInvoiceAmt"));

                        gv_Territory.FooterRow.Cells[7].Text = Math.Round(NetInvoiceAmt).ToString("#,##0");


                        decimal SumofNetReturnAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetReturnAmount") == null ? 0 : row.Field<decimal>("SumofNetReturnAmount"));

                        gv_Territory.FooterRow.Cells[8].Text = Math.Round(SumofNetReturnAmount).ToString("#,##0");


                        decimal DelReTpVat = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));

                        gv_Territory.FooterRow.Cells[9].Text = Math.Round(DelReTpVat).ToString("#,##0");

                        decimal NetReturnAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetReturnAmt") == null ? 0 : row.Field<decimal>("NetReturnAmt"));

                        gv_Territory.FooterRow.Cells[10].Text = Math.Round(NetReturnAmt).ToString("#,##0");

                        decimal SumofNetSalesAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));

                        gv_Territory.FooterRow.Cells[11].Text = Math.Round(SumofNetSalesAmount).ToString("#,##0");

                        decimal DelTpVat = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelTpVat") == null ? 0 : row.Field<decimal>("DelTpVat"));

                        gv_Territory.FooterRow.Cells[12].Text = Math.Round(DelTpVat).ToString("#,##0");

                        decimal NetSalesAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetSalesAmt") == null ? 0 : row.Field<decimal>("NetSalesAmt"));

                        gv_Territory.FooterRow.Cells[13].Text = Math.Round(NetSalesAmt).ToString("#,##0");


                        decimal SumofRCVTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofRCVTP") == null ? 0 : row.Field<decimal>("SumofRCVTP"));

                        gv_Territory.FooterRow.Cells[14].Text = Math.Round(SumofRCVTP).ToString("#,##0");

                        decimal SumofRCVVat = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofRCVVat") == null ? 0 : row.Field<decimal>("SumofRCVVat"));

                        gv_Territory.FooterRow.Cells[15].Text = Math.Round(SumofRCVVat).ToString("#,##0");

                        decimal SumofRCVAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofRCVAmount") == null ? 0 : row.Field<decimal>("SumofRCVAmount"));

                        gv_Territory.FooterRow.Cells[16].Text = Math.Round(SumofRCVAmount).ToString("#,##0");




                        gv_Territory.FooterRow.BackColor = System.Drawing.Color.Beige;
                        gv_Territory.FooterRow.Font.Bold = true;





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