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

public partial class SInventory_UI_TotalSummaryNew_PT : System.Web.UI.Page
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
            HeaderCell.Text = "Sales & Collection";
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

                aDataTable = aSummaryBll.LoadBusinessSummaryProductwise(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()));
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


                    decimal total6 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("RetQty") == null ? 0 : row.Field<decimal>("RetQty"));
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

                    loadGridView.FooterRow.BackColor = System.Drawing.Color.Beige;
                    loadGridView.FooterRow.Font.Bold = true;
                
            }
                else
                {
                    showMessageBox("No Data Found!!");
                    loadGridView.DataSource = null;
                    loadGridView.DataBind();
                }
            }

            // zoneDropDownList wise Report
            else if (fromDateTextBox.Text != "" && toDateTextBox.Text != "" && zoneDropDownList.SelectedValue != ""
              && salesCenterDropDownList.SelectedValue == "" && territoryDropDownList.SelectedValue == "")
            {
                DataTable aDataTable = new DataTable();

                aDataTable = aSummaryBll.LoadSummaryzonewiseBLL(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()),
                    Convert.ToString(zoneDropDownList.SelectedValue));
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


                    decimal total6 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("RetQty") == null ? 0 : row.Field<decimal>("RetQty"));
                    loadGridView.FooterRow.Cells[6].Text = (total6).ToString("#,##0");

                    decimal total7 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetReturnAmount") == null ? 0 : row.Field<decimal>("SumofNetReturnAmount"));
                    loadGridView.FooterRow.Cells[7].Text = (total7).ToString("#,##0");

                    decimal total8 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));
                    loadGridView.FooterRow.Cells[8].Text = (total8).ToString("#,##0");

                    decimal total9 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossRetuen") == null ? 0 : row.Field<decimal>("GrossRetuen"));
                    loadGridView.FooterRow.Cells[9].Text = (total9).ToString("#,##0");

                    decimal total10 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NumberofInvoiceSold") == null ? 0 : row.Field<decimal>("NumberofInvoiceSold"));
                    loadGridView.FooterRow.Cells[10].Text = (total10).ToString("#,##0");


                    decimal total11 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("bouns") == null ? 0 : row.Field<decimal>("bouns"));
                    loadGridView.FooterRow.Cells[11].Text = (total11).ToString("#,##0");

                    decimal total12 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));
                    loadGridView.FooterRow.Cells[12].Text = (total12).ToString("#,##0");

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
            else if (fromDateTextBox.Text != "" && toDateTextBox.Text != "" && zoneDropDownList.SelectedValue != ""
             && salesCenterDropDownList.SelectedValue != "" && territoryDropDownList.SelectedValue == "")
            {
                DataTable aDataTable = new DataTable();

                aDataTable = aSummaryBll.LoadSummaryzoneBranchwiseBLL(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()),
                    Convert.ToString(zoneDropDownList.SelectedValue), salesCenterDropDownList.SelectedValue);
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


                    decimal total6 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("RetQty") == null ? 0 : row.Field<decimal>("RetQty"));
                    loadGridView.FooterRow.Cells[6].Text = (total6).ToString("#,##0");

                    decimal total7 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetReturnAmount") == null ? 0 : row.Field<decimal>("SumofNetReturnAmount"));
                    loadGridView.FooterRow.Cells[7].Text = (total7).ToString("#,##0");

                    decimal total8 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));
                    loadGridView.FooterRow.Cells[8].Text = (total8).ToString("#,##0");

                    decimal total9 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossRetuen") == null ? 0 : row.Field<decimal>("GrossRetuen"));
                    loadGridView.FooterRow.Cells[9].Text = (total9).ToString("#,##0");

                    decimal total10 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NumberofInvoiceSold") == null ? 0 : row.Field<decimal>("NumberofInvoiceSold"));
                    loadGridView.FooterRow.Cells[10].Text = (total10).ToString("#,##0");


                    decimal total11 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("bouns") == null ? 0 : row.Field<decimal>("bouns"));
                    loadGridView.FooterRow.Cells[11].Text = (total11).ToString("#,##0");

                    decimal total12 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));
                    loadGridView.FooterRow.Cells[12].Text = (total12).ToString("#,##0");

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
            else if (fromDateTextBox.Text != "" && toDateTextBox.Text != "" && zoneDropDownList.SelectedValue == ""
             && salesCenterDropDownList.SelectedValue != "" && territoryDropDownList.SelectedValue == "")
            {
                DataTable aDataTable = new DataTable();

                aDataTable = aSummaryBll.LoadSummaryzoneBranchTerritorywiseBLL(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()),
                    salesCenterDropDownList.SelectedValue);
                if (aDataTable.Rows.Count > 0)
                {
                    loadGridView.DataSource = aDataTable;
                    loadGridView.DataBind();
                    //decimal total = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofProformaInvoice") == null ? 0 : row.Field<int>("NumberofProformaInvoice"));
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


                    decimal total6 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("RetQty") == null ? 0 : row.Field<decimal>("RetQty"));
                    loadGridView.FooterRow.Cells[6].Text = (total6).ToString("#,##0");

                    decimal total7 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetReturnAmount") == null ? 0 : row.Field<decimal>("SumofNetReturnAmount"));
                    loadGridView.FooterRow.Cells[7].Text = (total7).ToString("#,##0");

                    decimal total8 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));
                    loadGridView.FooterRow.Cells[8].Text = (total8).ToString("#,##0");

                    decimal total9 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossRetuen") == null ? 0 : row.Field<decimal>("GrossRetuen"));
                    loadGridView.FooterRow.Cells[9].Text = (total9).ToString("#,##0");

                    decimal total10 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NumberofInvoiceSold") == null ? 0 : row.Field<decimal>("NumberofInvoiceSold"));
                    loadGridView.FooterRow.Cells[10].Text = (total10).ToString("#,##0");


                    decimal total11 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("bouns") == null ? 0 : row.Field<decimal>("bouns"));
                    loadGridView.FooterRow.Cells[11].Text = (total11).ToString("#,##0");

                    decimal total12 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));
                    loadGridView.FooterRow.Cells[12].Text = (total12).ToString("#,##0");

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
            string attachment = "attachment; filename=Product wise Business Summary_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
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


            string headerTable = @"<span  style='text-align:center'><h3> Product wise Business Summary(Date Range : " + fromDateTextBox.Text + "- " + toDateTextBox.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

            HttpContext.Current.Response.Write(headerTable);

            Response.Write(sw.ToString());
            Response.End();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
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