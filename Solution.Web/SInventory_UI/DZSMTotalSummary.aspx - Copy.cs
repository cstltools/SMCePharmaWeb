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

public partial class SInventory_UI_DZSMTotalSummary : System.Web.UI.Page
{
    TotalSummaryBLL aSummaryBll = new TotalSummaryBLL();
    TotalSummaryDAL _TotalSummaryDAL = new TotalSummaryDAL();
    static CommonDataLoad _dataLoad = new CommonDataLoad();
    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = ""; string areaId = "";
    string masArea = "";
    string strRole = "";

    protected void Page_Load(object sender, EventArgs e)
    {

        try
        {
            RoleTypeName = Session["RoleTypeName"].ToString();
            EmpInfoId = Session["EmpInfoId"].ToString();
            ToRoleTypeId = Session["RoleTypeId"].ToString();

        }
        catch { }
        if (!IsPostBack)
        {

            try
            {
                DateTime now = DateTime.Now;
                var startDate = new DateTime(now.Year, now.Month, 1);
                var endDate = startDate.AddMonths(1).AddDays(-1);
                fromDateTextBox.Text = startDate.ToString("dd MMMM, yyyy");
                toDateTextBox.Text = endDate.ToString("dd MMMM, yyyy");
            }
            catch
            {

            }

            //fromDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            //toDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");

            if (EmpInfoId != "" || EmpInfoId != null)
            {
                DataTable dtMarket = _dataLoad.GetHigharcyInfoByEmployeeId(EmpInfoId.ToString(), ToRoleTypeId.ToString());

                string FFID = "";

                switch (RoleTypeName)
                {

                    case "AM":

                        strRole = "AM";
                        for (int i = 0; i < dtMarket.Rows.Count; i++)
                        {
                            areaId = areaId + dtMarket.Rows[i]["AreaId"].ToString() + ',';
                        }

                        masArea = areaId.TrimEnd(',');



                        break;
                    case "DZSM":
                        strRole = "DZSM";

                        for (int i = 0; i < dtMarket.Rows.Count; i++)
                        {
                            areaId = areaId + dtMarket.Rows[i]["RegionId"].ToString() + ',';
                        }
                        masArea = areaId.TrimEnd(',');

                        break;
                    case "NSM":
                        strRole = "NSM";

                        for (int i = 0; i < dtMarket.Rows.Count; i++)
                        {
                            areaId = areaId + dtMarket.Rows[i]["GroupId"].ToString() + ',';
                        }
                        masArea = areaId.TrimEnd(',');


                        break;


                    default:

                        break;


                }
            }

            if (EmpInfoId != "" || EmpInfoId != null)
            {
                DataTable dtMarket = _dataLoad.GetHigharcyInfoByEmployeeId(EmpInfoId.ToString(), ToRoleTypeId.ToString());

                string FFID = "";
                switch (RoleTypeName)
                {

                    case "AM":
                        hfGroupID.Value = dtMarket.Rows[0]["GroupId"].ToString();
                        hfZone.Value = dtMarket.Rows[0]["RegionId"].ToString();
                        hfArea.Value = dtMarket.Rows[0]["AreaId"].ToString();
                        GroupSelect.Enabled = false;
                        ZoneSelect.Enabled = false;
                        //  AreaSelect.Enabled = false;
                        break;
                    case "DZSM":
                        hfGroupID.Value = dtMarket.Rows[0]["GroupId"].ToString();
                        hfZone.Value = dtMarket.Rows[0]["RegionId"].ToString();
                        GroupSelect.Enabled = false;
                        // ZoneSelect.Enabled = false;
                        break;
                    case "NSM":
                        hfGroupID.Value = dtMarket.Rows[0]["GroupId"].ToString();
                        GroupSelect.Enabled = false;
                        break;


                    default:

                        break;


                }
            }
            try
            {

                using (DataTable dt = _dataLoad.GetRSMInfoByEmployeeId(Session["EmpInfoId"].ToString()))
                {

                    if (dt.Rows.Count > 0)
                    {

                        hfGroupID.Value = dt.Rows[0]["GroupId"].ToString();
                        hfRegionId.Value = dt.Rows[0]["RegionId"].ToString();
                    }
                    else
                    {
                        GroupSelect.Enabled = true;
                        ZoneSelect.Enabled = true;
                    }
                }
            }
            catch (Exception)
            {
                
             //   throw;
            }
            DropDownlist();
        }
    }

    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadInfo();
    }
    public void DropDownlist()
    {
        try
        {
            using (DataTable dt = _dataLoad.GetGroupInfo_All())
            {
                GroupSelect.DataSource = dt;
                GroupSelect.DataValueField = "GroupId";
                GroupSelect.DataTextField = "GroupName";
                GroupSelect.DataBind();
                GroupSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                GroupSelect.SelectedIndex = 0;

                if (hfGroupID.Value!="")
                {
                    GroupSelect.SelectedValue = hfGroupID.Value;
                    GroupSelect_SelectedIndexChanged(null, null);
                    ZoneSelect.SelectedValue = hfRegionId.Value;

                    ZoneSelect_SelectedIndexChanged(null, null);
                }

            
            }
        }
        catch (Exception ex)
        {

        }
        //OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        //aOrderInfoBll.LoadDZSM(salesCenterDropDownList, Session["UserId"].ToString());

        //if (Session["LoginName"].ToString() == "21675")
        //{
        //    salesCenterDropDownList.SelectedIndex = 4;
        //    salesCenterDropDownList.Enabled = false;
        //}
        //if (Session["LoginName"].ToString() == "21371")
        //{
        //    salesCenterDropDownList.SelectedIndex = 1;
        //    salesCenterDropDownList.Enabled = false;
        //}
        //if (Session["LoginName"].ToString() == "21754")
        //{
        //    salesCenterDropDownList.SelectedIndex = 3;
        //    salesCenterDropDownList.Enabled = false;
        //}
        //if (Session["LoginName"].ToString() == "51544")
        //{
        //    salesCenterDropDownList.SelectedIndex =5;
        //    salesCenterDropDownList.Enabled = false;

        //}
        //if (Session["LoginName"].ToString() == "21370")
        //{
        //    salesCenterDropDownList.SelectedIndex = 2;
        //    salesCenterDropDownList.Enabled = false;
        //}
        //if (Session["LoginName"].ToString() == "51580")
        //{
        //    salesCenterDropDownList.SelectedIndex = 7;
        //    salesCenterDropDownList.Enabled = false;
        //}
        //if (Session["LoginName"].ToString() == "50745")
        //{
        //    salesCenterDropDownList.SelectedIndex = 9;
        //    salesCenterDropDownList.Enabled = false;
        //}
        //if (Session["LoginName"].ToString() == "51383")
        //{
        //    salesCenterDropDownList.SelectedIndex = 8;
        //    salesCenterDropDownList.Enabled = false;
        //}
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {
    
        try
        {
              LoadInfo();
        }
        catch (Exception ex)
        { }
    }
    protected void GroupSelect_SelectedIndexChanged(object sender, EventArgs e)
    {

        if (strRole == "DZSM")
        {
            try
            {

                if (masArea == "")
                {
                    using (DataTable dt = _dataLoad.GetZone_byGroupId_forDSM(areaId.ToString()))
                    {
                        ZoneSelect.DataSource = dt;
                        ZoneSelect.DataValueField = "RegionId";
                        ZoneSelect.DataTextField = "RegionName";
                        ZoneSelect.DataBind();
                        ZoneSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                        ZoneSelect.SelectedIndex = 0;
                        ZoneSelect.Enabled = false;
                    }
                }
                else
                {
                    using (DataTable dt = _dataLoad.GetZone_byGroupId_forDSM(masArea))
                    {
                        ZoneSelect.DataSource = dt;
                        ZoneSelect.DataValueField = "RegionId";
                        ZoneSelect.DataTextField = "RegionName";
                        ZoneSelect.DataBind();
                        ZoneSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                        ZoneSelect.SelectedIndex = 0;
                      

                    }
                }


            }
            catch (Exception ex)
            {

            }
        }
          


        AreaSelect.Items.Clear();
        TeritorySelect.Items.Clear();
        
    }

    protected void ZoneSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {


       ZoneSelect.SelectedValue=     hfRegionId.Value;

            using (DataTable dt = _dataLoad.GetZone_byGroupId_All(Convert.ToInt32(GroupSelect.SelectedValue)))
            {
                AreaSelect.DataSource = dt;
                AreaSelect.DataValueField = "AreaId";
                AreaSelect.DataTextField = "AreaName";
                AreaSelect.DataBind();
                AreaSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                AreaSelect.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }


        TeritorySelect.Items.Clear();
       
    }




    protected void AreaSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {

            using (DataTable dt = _dataLoad.GetTerritory_ByAreaId_All(Convert.ToInt32(AreaSelect.SelectedValue)))
            {
                TeritorySelect.DataSource = dt;
                TeritorySelect.DataValueField = "TerritoryId";
                TeritorySelect.DataTextField = "TerritoryName";
                TeritorySelect.DataBind();
                TeritorySelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                TeritorySelect.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }



        
    }


    private string Parm()
    {
        string param = "";



        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND gr.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}
       
        if (ZoneSelect.SelectedValue != "")
        {
            param = param +  ZoneSelect.SelectedValue   ;
          //  param = param + " AND RegionId='" + ZoneSelect.SelectedValue + "' ";

        }
        

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
        if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {
            DataTable aDataTable = new DataTable();

            aDataTable = _TotalSummaryDAL.DZSMwiseLoadSummaryparm(fromDateTextBox.Text, toDateTextBox.Text,Parm());
            if (aDataTable.Rows.Count > 0)
            {
                loadGridView.DataSource = aDataTable;
                loadGridView.DataBind();

                decimal total =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<int?>("NumberofProformaInvoice") == null
                                    ? 0
                                    : row.Field<int>("NumberofProformaInvoice"));
                loadGridView.FooterRow.Cells[1].Text = "Total";
                loadGridView.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
                loadGridView.FooterRow.Cells[2].Text = total.ToString();

                decimal total2 =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("SumofNetProformaAmount") == null
                                    ? 0
                                    : row.Field<decimal>("SumofNetProformaAmount"));

                loadGridView.FooterRow.Cells[3].Text = total2.ToString("N2");


                decimal total3 =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("ProTpVat") == null ? 0 : row.Field<decimal>("ProTpVat"));

                loadGridView.FooterRow.Cells[4].Text = total3.ToString("N2");


                decimal total4 =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<int?>("NumberofInvoiceSold") == null ? 0 : row.Field<int>("NumberofInvoiceSold"));

                loadGridView.FooterRow.Cells[5].Text = total4.ToString();

                decimal total5 =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("SumofNetSalesAmount") == null
                                    ? 0
                                    : row.Field<decimal>("SumofNetSalesAmount"));

                loadGridView.FooterRow.Cells[6].Text = total5.ToString("N2");


                decimal total6 =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("DelTpVat") == null ? 0 : row.Field<decimal>("DelTpVat"));

                loadGridView.FooterRow.Cells[7].Text = total6.ToString("N2");

                decimal total7 =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<int?>("NumberofReturnInvoice") == null
                                    ? 0
                                    : row.Field<int>("NumberofReturnInvoice"));

                loadGridView.FooterRow.Cells[8].Text = total7.ToString();

                decimal total8 =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("SumofNetReturnAmount") == null
                                    ? 0
                                    : row.Field<decimal>("SumofNetReturnAmount"));

                loadGridView.FooterRow.Cells[9].Text = total8.ToString("N2");

                decimal total9 =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));

                loadGridView.FooterRow.Cells[10].Text = total9.ToString("N2");


                decimal total10 =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<int?>("CustomerCoverPer") == null ? 0 : row.Field<int>("CustomerCoverPer"));

                loadGridView.FooterRow.Cells[11].Text = total10.ToString("N2");

                decimal total11 =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("SumofNetSalesAmountFixed") == null
                                    ? 0
                                    : row.Field<decimal>("SumofNetSalesAmountFixed"));

                loadGridView.FooterRow.Cells[12].Text = total11.ToString("N2");

                decimal total12 =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("SumofNetSalesAmountCamp") == null
                                    ? 0
                                    : row.Field<decimal>("SumofNetSalesAmountCamp"));

                loadGridView.FooterRow.Cells[13].Text = total12.ToString("N2");

                decimal total13 =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("FinalSales") == null ? 0 : row.Field<decimal>("FinalSales"));

                loadGridView.FooterRow.Cells[14].Text = total13.ToString("N2");


                decimal total15 =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("SumofNetSalesAmountFixed2") == null
                                    ? 0
                                    : row.Field<decimal>("SumofNetSalesAmountFixed2"));

                loadGridView.FooterRow.Cells[15].Text = total15.ToString("N2");

                decimal total16 =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("SumofNetSalesAmountCamp2") == null
                                    ? 0
                                    : row.Field<decimal>("SumofNetSalesAmountCamp2"));

                loadGridView.FooterRow.Cells[16].Text = total16.ToString("N2");

                decimal total17 =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("FinalSales2") == null ? 0 : row.Field<decimal>("FinalSales2"));

                loadGridView.FooterRow.Cells[17].Text = total17.ToString("N2");

                decimal total18 =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<int?>("CustomerCoverPerProforma") == null
                                    ? 0
                                    : row.Field<int>("CustomerCoverPerProforma"));

                loadGridView.FooterRow.Cells[18].Text = total18.ToString("N2");


                decimal total19 =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("BlueNetSell") == null ? 0 : row.Field<decimal>("BlueNetSell"));

                loadGridView.FooterRow.Cells[19].Text = total19.ToString("N2");

                decimal total20 =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("GreenNetSell") == null ? 0 : row.Field<decimal>("GreenNetSell"));

                loadGridView.FooterRow.Cells[20].Text = total20.ToString("N2");


                decimal total21 =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<decimal?>("DelBlueNetSell") == null ? 0 : row.Field<decimal>("DelBlueNetSell"));

                loadGridView.FooterRow.Cells[21].Text = total21.ToString("N2");

                decimal total22 =
                    aDataTable.AsEnumerable()
                        .Sum(
                            row =>
                                row.Field<decimal?>("DelGreenNetSell") == null ? 0 : row.Field<decimal>("DelGreenNetSell"));

                loadGridView.FooterRow.Cells[22].Text = total22.ToString("N2");

                decimal total23 =
                    aDataTable.AsEnumerable().Sum(row => row.Field<int?>("BlueCov") == null ? 0 : row.Field<int>("BlueCov"));

                loadGridView.FooterRow.Cells[23].Text = total23.ToString("N2");

                decimal total24 =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<int?>("greenCov") == null ? 0 : row.Field<int>("greenCov"));

                loadGridView.FooterRow.Cells[24].Text = total24.ToString("N2");


                decimal total25 =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<int?>("DelBlueCov") == null ? 0 : row.Field<int>("DelBlueCov"));

                loadGridView.FooterRow.Cells[25].Text = total25.ToString("N2");

                decimal total26 =
                    aDataTable.AsEnumerable()
                        .Sum(row => row.Field<int?>("DelgreenCov") == null ? 0 : row.Field<int>("DelgreenCov"));

                loadGridView.FooterRow.Cells[26].Text = total26.ToString("N2");
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
            showMessageBox("Please Select Mandatory Field!!");
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