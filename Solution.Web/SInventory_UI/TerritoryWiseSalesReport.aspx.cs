using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ClosedXML;
using CrystalDecisions.Shared;
using Library.BLL.SInventory_BLL;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using SalesSolution.Web.DataLayer;
using Library.DAL.SInventory_DAL;
using Library.DAL.DoctorInfo_DAL;

public partial class SInventory_UI_TerritoryWiseSalesReport : System.Web.UI.Page
{
    private DoctorInfoReportDal aReportDal = new DoctorInfoReportDal();

    TotalSummaryBLL aSummaryBll = new TotalSummaryBLL();
    TotalSummaryDAL _TotalSummaryDAL = new TotalSummaryDAL();
    static CommonDataLoad _dataLoad = new CommonDataLoad();
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
             



            try
            {
                DateTime now = DateTime.Now;
                var startDate = new DateTime(now.Year, now.Month, 1);
                var endDate = startDate.AddMonths(1).AddDays(-1);
                fromDateTextBox.Text = startDate.ToString("dd MMMM, yyyy");
                toDateTextBox.Text = endDate.ToString("dd MMMM, yyyy");


                try
                {

                    using (DataTable dt = aReportDal.GetTerritoryWiseLastProessDate(""))
                    {
                        lblInfo.Text = dt.Rows[0]["LastProcessDate"].ToString();
                        lblNextDate.Text = dt.Rows[0]["NextProcessDate"].ToString();
                    }
                }
                catch
                {

                }
            }
            catch
            {

            }

        }

        
    }

    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadInfo();
    }
  protected void viewRptButton_Click(object sender, EventArgs e)
    {
    
        try
        {
            if(Validatea())
            {
                LoadInfo();
            }
            else
            {
                loadGridView.DataSource = null;
                loadGridView.DataBind();
            }
        }
        catch (Exception ex)
        { }
    }

    private bool Validatea()
    {

        bool cc = true;
        if (RoleTypeName == "AM")
        {
            if (F_AreaSelect.SelectedValue == "")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + " Please Select Area!" + "','Faild');", true); return cc=false;
            }


        }

        if (RoleTypeName == "DZSM")
        {
            if (F_ZoneSelect.SelectedValue == "")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + " Please Select Zone!" + "','Faild');", true);
                cc = false;
            }


        }

        return cc;
    }

    private string Parm()
    {
        string param = "";



        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND gr.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}
       
        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param +  ZoneSelect.SelectedValue   ;
        //  //  param = param + " AND RegionId='" + ZoneSelect.SelectedValue + "' ";

        //}
        

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND Ar.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}

        //if (TeritorySelect.SelectedValue != "")
        //{
        //    param = param + " AND Tr.TerritoryId='" + TeritorySelect.SelectedValue + "' ";
        //}

       
     
        
        

        return param;
    }
    private void LoadInfo()
    {

        try
        {

            using (DataTable dt = aReportDal.GetTerritoryWiseLastProessDate(""))
            {
                lblInfo.Text = dt.Rows[0]["LastProcessDate"].ToString();
                lblNextDate.Text = dt.Rows[0]["NextProcessDate"].ToString();
            }
        }
        catch
        {

        }
        loadGridView.DataSource = null;
        loadGridView.DataBind();
        if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {
            DataTable aDataTable = new DataTable();

            string Zone = "";

            if (F_ZoneSelect.SelectedValue != "")
            {
                Zone = F_ZoneSelect.SelectedValue;
            }


            string Area = "";

            if (F_AreaSelect.SelectedValue != "")
            {
                Area = F_AreaSelect.SelectedValue;
            }


            string Teritory = "";

            if (F_AreaSelect.SelectedValue != "")
            {
                Teritory = F_TeritorySelect.SelectedValue;
            }


          


                aDataTable = _TotalSummaryDAL.DZSMwiseLoadSummaryparm_vvvv(fromDateTextBox.Text, toDateTextBox.Text, Zone, Area, Teritory);
            if (aDataTable.Rows.Count > 0)
            {
                loadGridView.DataSource = aDataTable;
                loadGridView.DataBind();
                loadGridView.FooterRow.Font.Bold = true;
                loadGridView.FooterRow.BackColor = Color.Wheat;
                decimal NumberofProformaInvoice =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<int?>("NumberofProformaInvoice") == null
                                    ? 0
                                    : row.Field<int>("NumberofProformaInvoice"));
                loadGridView.FooterRow.Cells[1].Text = "Total";
                loadGridView.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
                loadGridView.FooterRow.Cells[2].Text = NumberofProformaInvoice.ToString();

                decimal SumofNetProformaAmount =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("SumofNetProformaAmount") == null
                                    ? 0
                                    : row.Field<decimal>("SumofNetProformaAmount"));

                loadGridView.FooterRow.Cells[3].Text = SumofNetProformaAmount.ToString("N2");


                decimal ProTpVat =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("ProTpVat") == null ? 0 : row.Field<decimal>("ProTpVat"));

                loadGridView.FooterRow.Cells[4].Text = ProTpVat.ToString("N2");


                decimal NumberofInvoiceSold =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<int?>("NumberofInvoiceSold") == null ? 0 : row.Field<int>("NumberofInvoiceSold"));

                loadGridView.FooterRow.Cells[5].Text = NumberofInvoiceSold.ToString();

                decimal SumofNetSalesAmount =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("SumofNetSalesAmount") == null
                                    ? 0
                                    : row.Field<decimal>("SumofNetSalesAmount"));

                loadGridView.FooterRow.Cells[6].Text = SumofNetSalesAmount.ToString("N2");


                decimal DelTpVat =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("DelTpVat") == null ? 0 : row.Field<decimal>("DelTpVat"));

                loadGridView.FooterRow.Cells[7].Text = DelTpVat.ToString("N2");

                decimal NumberofReturnInvoice =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<int?>("NumberofReturnInvoice") == null
                                    ? 0
                                    : row.Field<int>("NumberofReturnInvoice"));

                loadGridView.FooterRow.Cells[8].Text = NumberofReturnInvoice.ToString();

                decimal SumofNetReturnAmount =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("SumofNetReturnAmount") == null
                                    ? 0
                                    : row.Field<decimal>("SumofNetReturnAmount"));

                loadGridView.FooterRow.Cells[9].Text = SumofNetReturnAmount.ToString("N2");

                decimal DelReTpVat =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));

                loadGridView.FooterRow.Cells[10].Text = DelReTpVat.ToString("N2");


                decimal CustomerCoverPer =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<int?>("CustomerCoverPer") == null ? 0 : row.Field<int>("CustomerCoverPer"));

                loadGridView.FooterRow.Cells[11].Text = CustomerCoverPer.ToString("N2");

                decimal SumofNetSalesAmountFixed =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("SumofNetSalesAmountFixed") == null
                                    ? 0
                                    : row.Field<decimal>("SumofNetSalesAmountFixed"));

                loadGridView.FooterRow.Cells[12].Text = SumofNetSalesAmountFixed.ToString("N2");

                decimal SumofNetSalesAmountFixedNCOD =
                 aDataTable.AsEnumerable()
                     .Sum(
                         row =>
                             row.Field<decimal?>("SumofNetSalesAmountFixedNCOD") == null
                                 ? 0
                                 : row.Field<decimal>("SumofNetSalesAmountFixedNCOD"));


                loadGridView.FooterRow.Cells[13].Text = SumofNetSalesAmountFixedNCOD.ToString("N2");

                decimal SumofNetSalesAmountCamp =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("SumofNetSalesAmountCamp") == null
                                    ? 0
                                    : row.Field<decimal>("SumofNetSalesAmountCamp"));

                loadGridView.FooterRow.Cells[14].Text = SumofNetSalesAmountCamp.ToString("N2");

                decimal FinalSales =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("FinalSales") == null ? 0 : row.Field<decimal>("FinalSales"));

                loadGridView.FooterRow.Cells[15].Text = FinalSales.ToString("N2");


                decimal NCODProforma =
                 aDataTable.AsEnumerable()
                     .Sum(row => row.Field<decimal?>("NCODProforma") == null ? 0 : row.Field<decimal>("NCODProforma"));

                loadGridView.FooterRow.Cells[16].Text = NCODProforma.ToString("N2");


                decimal SumofNetSalesAmountFixed2 =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("SumofNetSalesAmountFixed2") == null
                                    ? 0
                                    : row.Field<decimal>("SumofNetSalesAmountFixed2"));

                loadGridView.FooterRow.Cells[17].Text = SumofNetSalesAmountFixed2.ToString("N2");

                decimal SumofNetSalesAmountCamp2 =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("SumofNetSalesAmountCamp2") == null
                                    ? 0
                                    : row.Field<decimal>("SumofNetSalesAmountCamp2"));

                loadGridView.FooterRow.Cells[18].Text = SumofNetSalesAmountCamp2.ToString("N2");

                decimal FinalSales2 =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("FinalSales2") == null ? 0 : row.Field<decimal>("FinalSales2"));

                loadGridView.FooterRow.Cells[19].Text = FinalSales2.ToString("N2");

                decimal CustomerCoverPerProforma =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<int?>("CustomerCoverPerProforma") == null
                                    ? 0
                                    : row.Field<int>("CustomerCoverPerProforma"));

                loadGridView.FooterRow.Cells[20].Text = CustomerCoverPerProforma.ToString("N2");


                decimal BlueNetSell =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("BlueNetSell") == null ? 0 : row.Field<decimal>("BlueNetSell"));

                loadGridView.FooterRow.Cells[21].Text = BlueNetSell.ToString("N2");

                decimal GreenNetSell =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("GreenNetSell") == null ? 0 : row.Field<decimal>("GreenNetSell"));

                loadGridView.FooterRow.Cells[22].Text = GreenNetSell.ToString("N2");


                decimal DelBlueNetSell =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("DelBlueNetSell") == null ? 0 : row.Field<decimal>("DelBlueNetSell"));

                loadGridView.FooterRow.Cells[23].Text = DelBlueNetSell.ToString("N2");

                decimal DelGreenNetSell =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("DelGreenNetSell") == null ? 0 : row.Field<decimal>("DelGreenNetSell"));

                loadGridView.FooterRow.Cells[24].Text = DelGreenNetSell.ToString("N2");

                decimal BlueCov =
                    aDataTable.AsEnumerable().Sum(row => row.Field<int?>("BlueCov") == null ? 0 : row.Field<int>("BlueCov"));

                loadGridView.FooterRow.Cells[25].Text = BlueCov.ToString("N2");

                decimal greenCov =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<int?>("greenCov") == null ? 0 : row.Field<int>("greenCov"));

                loadGridView.FooterRow.Cells[26].Text = greenCov.ToString("N2");


                decimal DelBlueCov =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<int?>("DelBlueCov") == null ? 0 : row.Field<int>("DelBlueCov"));

                loadGridView.FooterRow.Cells[27].Text = DelBlueCov.ToString("N2");

                decimal DelgreenCov =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<int?>("DelgreenCov") == null ? 0 : row.Field<int>("DelgreenCov"));

                loadGridView.FooterRow.Cells[28].Text = DelgreenCov.ToString("N2");


                decimal ActualProforma =
                   aDataTable.AsEnumerable()
                       .Sum(row => row.Field<decimal?>("ActualProforma") == null ? 0 : row.Field<decimal>("ActualProforma"));

                loadGridView.FooterRow.Cells[29].Text = ActualProforma.ToString("N2");



                decimal CustCollectionGross =
          aDataTable.AsEnumerable()
              .Sum(row => row.Field<decimal?>("CustCollectionGross") == null ? 0 : row.Field<decimal>("CustCollectionGross"));

                loadGridView.FooterRow.Cells[30].Text = CustCollectionGross.ToString("N2");

                decimal CollectionAmtTP =
aDataTable.AsEnumerable()
   .Sum(row => row.Field<decimal?>("CollectionAmtTP") == null ? 0 : row.Field<decimal>("CollectionAmtTP"));

                loadGridView.FooterRow.Cells[31].Text = CollectionAmtTP.ToString("N2");


                decimal CollectionVat =
     aDataTable.AsEnumerable()
         .Sum(row => row.Field<decimal?>("CollectionVat") == null ? 0 : row.Field<decimal>("CollectionVat"));

                loadGridView.FooterRow.Cells[32].Text = CollectionVat.ToString("N2");

                decimal TotalOutStanding =
          aDataTable.AsEnumerable()
              .Sum(row => row.Field<decimal?>("TotalOutStanding") == null ? 0 : row.Field<decimal>("TotalOutStanding"));
 

                loadGridView.FooterRow.Cells[33].Text = TotalOutStanding.ToString("N2");

 



          





            }

            else
            {

                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!!  Data is Procecing...." + "','Faild');", true);
               
                loadGridView.DataSource = null;
                loadGridView.DataBind();
            }
        }
        else
        {
  
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please Select Mandatory Field!!" + "','Faild');", true);
            loadGridView.DataSource = null;
            loadGridView.DataBind();
        }
      
    }


    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    public override void VerifyRenderingInServerForm(Control control)
    {
        //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
    }  
    protected void excelButton1_Click(object sender, EventArgs e)
    {
        if (salesCenterDropDownList.SelectedValue!="")
        {
            if (loadGridView.Rows.Count > 0)
            {
                string attachment = "attachment; filename=BusinessSummary.xls";
                Response.ClearContent();
                Response.AddHeader("content-disposition", attachment);
                Response.ContentType = "application/ms-excel";
                StringWriter sw = new StringWriter();
                HtmlTextWriter htw = new HtmlTextWriter(sw);

                loadGridView.AllowPaging = false;


                DataTable aDataTable = new DataTable();

                aDataTable = aSummaryBll.DZSMwiseLoadSummaryBLL(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()), salesCenterDropDownList.SelectedValue);
                if (aDataTable.Rows.Count > 0)
                {
                    loadGridView.DataSource = aDataTable;
                    loadGridView.DataBind();
                }

                HtmlForm frm = new HtmlForm();
                loadGridView.Parent.Controls.Add(frm);

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
                Response.Write(sw.ToString());
                Response.End();
            }
            else
            {
                showMessageBox("No Data Found!!");
            }
        }
        else
        {
             if (loadGridView.Rows.Count > 0)
        {
            string attachment = "attachment; filename=BusinessSummary.xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            loadGridView.AllowPaging = false;

          
            DataTable aDataTable = new DataTable();

                    aDataTable = aSummaryBll.DZSMwiseLoadSummaryBLL(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()));
                    if (aDataTable.Rows.Count > 0)
                    {
                        loadGridView.DataSource = aDataTable;
                        loadGridView.DataBind();
                    }

            HtmlForm frm = new HtmlForm();
            loadGridView.Parent.Controls.Add(frm);

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
            Response.Write(sw.ToString());
            Response.End();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
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

    protected void OnClick(object sender, EventArgs e)
    {
         Response.Redirect("DZSMTotalSummary.aspx");
    }
}