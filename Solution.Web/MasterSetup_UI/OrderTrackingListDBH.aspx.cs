using Library.DAL.MasterSetup_DAL;
using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class MasterSetup_UI_OrderTrackingListDBH : System.Web.UI.Page
{

    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = "";

    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    static CommonDataLoad _dataLoad = new CommonDataLoad();

    private static OrderTrackingDAL _DAL = new OrderTrackingDAL();
    private DropDownList GroupSelect, ZoneSelect, AreaSelect, TeritorySelect, SubTeritory, MarketSelect, ddlNSM, ddlDZSM, ddlAM, ddlMIO;
    protected void Page_Load(object sender, EventArgs e)
    {
        GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;
        ddlNSM = (DropDownList)IVMarketStructure.FindControl("ddlNSM") as DropDownList;
        ddlDZSM = (DropDownList)IVMarketStructure.FindControl("ddlDZSM") as DropDownList;
        ddlAM = (DropDownList)IVMarketStructure.FindControl("ddlAM") as DropDownList;
        ddlMIO = (DropDownList)IVMarketStructure.FindControl("ddlMIO") as DropDownList;


        try
        {
            RoleTypeName = Session["RoleTypeName"].ToString();
            EmpInfoId = Session["EmpInfoId"].ToString();
            ToRoleTypeId = Session["RoleTypeId"].ToString();
        }
        catch (Exception ex)
        {
        }

        if (!IsPostBack)
        {


            frmDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            toDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            try
            {
                using (DataTable dt = _seedRepo.GetChemistTypeListALL())
                {
                    ddlChemisType.DataSource = dt;
                    ddlChemisType.DataValueField = "CustomerTypeId";
                    ddlChemisType.DataTextField = "CustomerType";
                    ddlChemisType.DataBind();
                    ddlChemisType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlChemisType.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }


            try
            {
                using (DataTable dt = _seedRepo.GetCampaignNameListALLFromOrder())
                {
                    ddlCampaign.DataSource = dt;
                    ddlCampaign.DataValueField = "CampaignName";
                    ddlCampaign.DataTextField = "CampaignName";
                    ddlCampaign.DataBind();
                    ddlCampaign.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlCampaign.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }

            try
            {
                using (DataTable dt = _seedRepo.GetProgramTypeListAll())
                {
                    ddlProgramType.DataSource = dt;
                    ddlProgramType.DataValueField = "ProgramTypeId";
                    ddlProgramType.DataTextField = "ProgramTypeName";
                    ddlProgramType.DataBind();
                    ddlProgramType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlProgramType.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }
            try
            {
                using (DataTable dt = _seedRepo.GetApprovalStatusList())
                {
                    ApprovalStatusSelect.DataSource = dt;
                    ApprovalStatusSelect.DataValueField = "SoftwareUseId";
                    ApprovalStatusSelect.DataTextField = "WebShow";
                    ApprovalStatusSelect.DataBind();
                    ApprovalStatusSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ApprovalStatusSelect.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }
            try
            {
                using (DataTable dt = _seedRepo.GetDistributionCenterDataTableList())
                {
                    ddlDistributionCenter.DataSource = dt;
                    ddlDistributionCenter.DataValueField = "ComUnitId";
                    ddlDistributionCenter.DataTextField = "ComUnitName";
                    ddlDistributionCenter.DataBind();
                    ddlDistributionCenter.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlDistributionCenter.SelectedIndex = 0;

                    if (Session["RoleTypeName"].ToString() == "DIC")
                    {
                        ddlDistributionCenter.SelectedValue = Session["DICCompanyUnitId"].ToString();
                        ddlDistributionCenter.Enabled = false;
                    }
                }


            }
            catch (Exception ex) { }




            btnSearch_Click(null, null);
        }
    }
    protected void custNameTextBox_TextChanged(object sender, EventArgs e)
    {


        string empName = custNameTextBox.Text.Trim();
        if (empName != "")
        {
            if (empName.Contains(':'))
            {
                string[] emp = empName.Split('|');

                hfCustomerId.Value = emp[1].Trim();
                custNameTextBox.Text = emp[0].Trim();



            }
            else
            {

                custNameTextBox.Text = "";
                hfCustomerId.Value = "";
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Input Correct Data !" + "','Faild');", true);
            }
        }
        else
        {
            hfCustomerId.Value = "";
            custNameTextBox.Text = "";
        }

    }
    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadData(Parm());
    }
    protected void gv_DocumentUpload_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;

        if ((gv.ShowHeader == true && gv.Rows.Count > 0)
            || (gv.ShowHeaderWhenEmpty == true))
        {
            //Force GridView to use <thead> instead of <tbody> - 11/03/2013 - MCR.
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
    protected void EmpCetegoryAddImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("CustomerEntry.aspx");
    }

    private void LoadData(string parm)
    {
        DataTable aDataTable = _DAL.GetOrderTrackingDBH(parm);
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();

        lblOrderCount.Text = "0";
        lblOrderAmount.Text = "0";
        //lblVAT.Text = "0";
        //lblDiscount.Text = "0";
        //lblAllTotal.Text = "0";

        if (loadGridView.Rows.Count > 0)
        {
            try
            {

                lblOrderCount.Text = aDataTable.Rows.Count.ToString();
                //loadGridView.FooterRow.Cells[4].Text = "Total: ";
             
                //loadGridView.FooterRow.Cells[4].Font.Bold = true;
                //loadGridView.FooterRow.Cells[5].Font.Bold = true;
                //loadGridView.FooterRow.Cells[6].Font.Bold = true;
                //loadGridView.FooterRow.Cells[7].Font.Bold = true;
                //loadGridView.FooterRow.Cells[8].Font.Bold = true;
                //loadGridView.FooterRow.Cells[4].HorizontalAlign = HorizontalAlign.Right;
                // orderGridView.FooterRow.Cells[2].Text = total.ToString();

                decimal GrossValue = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossValue") == null ? 0 : row.Field<decimal>("GrossValue"));


                //decimal TotalVat = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalVat") == null ? 0 : row.Field<decimal>("TotalVat"));


                //decimal TotalDiscount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalDiscount") == null ? 0 : row.Field<decimal>("TotalDiscount"));


                //decimal TotalNetPayable = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalNetPayable") == null ? 0 : row.Field<decimal>("TotalNetPayable"));

                lblOrderAmount.Text = GrossValue.ToString();
           //  lblVAT.Text = TotalVat.ToString();
           //     lblDiscount.Text = TotalDiscount.ToString();
           //lblAllTotal.Text = TotalNetPayable.ToString();
            }
            catch (Exception)
            {

                //  throw;
            }
        }
      
    }


    protected void btnExport_Click(object sender, EventArgs e)
    {


        if (loadGridView.Rows.Count > 0)
        {


       




                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=Order_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".csv");
                Response.Charset = "";
                Response.ContentType = "text/csv";
                Response.ContentEncoding = Encoding.Default;
            //To Export all pages.
            loadGridView.AllowPaging = false;
            LoadData(Parm());

            StringBuilder sb = new StringBuilder();
                foreach (TableCell cell in loadGridView.HeaderRow.Cells)
                {
                    //Append data with separator.
                    sb.Append(HttpUtility.HtmlDecode(cell.Text) + ',');
                }


                //Append new line character.
                sb.Append("\r\n");




                foreach (GridViewRow row in loadGridView.Rows)
                {
                    foreach (TableCell cell in row.Cells)
                    {
                        //Append data with separator.
                        if (cell.Text.Contains(","))
                        {
                            sb.Append(String.Format("\"{0}\",", cell.Text));
                        }
                        else
                        { sb.Append(HttpUtility.HtmlDecode(cell.Text) + ','); }
                    }
                    //Append new line character.
                    sb.Append("\r\n");
                }

                Response.Output.Write(sb.ToString());
                Response.Flush();
                Response.End();


            
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        }


    }
    public override void VerifyRenderingInServerForm(System.Web.UI.Control control)
    {
        //confirms that an HtmlForm control is rendered for the
        //specified ASP.NET server control at run time.
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            var datKey = loadGridView.DataKeys[0];
            if (datKey != null)
            {
                string MId = e.CommandArgument.ToString();

                System.Web.UI.ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "openModal",
                    "window.open('../SInventory_UI/OrderStatus.aspx?MID=" + MId + "' ,'_blank');", true);
            }
        }
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadData(Parm());
    }

    private string Parm()
    {
        string param = "";

        //param = param + " AND mas.IsInvoice=1";


        if (ddlDistributionCenter.SelectedValue != "")
        {
            param = param + " AND mas.ComUnitId='" + ddlDistributionCenter.SelectedValue + "' ";
        }

        string Role = "";
        DataTable dtMarket = _dataLoad.GetEmpMarketStructure_Active(EmpInfoId);


        string FFID = "";
        switch (RoleTypeName)
        {



            case "MIO":
                FFID = dtMarket.Rows[0]["EmpTerrId"].ToString();

                param = param + " AND mas.TerritoryId='" + FFID + "' ";


                break;

            case "AM":
                FFID = dtMarket.Rows[0]["EmpAreaId"].ToString();
                param = param + " AND mas.AreaId='" + FFID + "' ";


                break;
            case "DZSM":
                FFID = dtMarket.Rows[0]["EmpRegionId"].ToString();

                param = param + " AND mas.RegionId='" + FFID + "' ";
                break;



            default:

                Role = "";
                break;
        }

       



        if (ddlNSM.SelectedValue != "")
        {
            param = param + " AND mas.NSMId='" + ddlNSM.SelectedValue + "' ";
        }


        if (ddlDZSM.SelectedValue != "")
        {
            param = param + " AND mas.RSMId='" + ddlDZSM.SelectedValue + "' ";
        }


        if (ddlAM.SelectedValue != "")
        {
            param = param + " AND mas.ASMId='" + ddlAM.SelectedValue + "' ";
        }

        if (ddlMIO.SelectedValue != "")
        {
            param = param + " AND mas.MIOId='" + ddlMIO.SelectedValue + "' ";
        }


        if (ddlProgramType.SelectedValue != "")
        {
            param = param + " AND mas.ProgramTypeId='" + ddlProgramType.SelectedValue + "' ";
        }


        if (ddlChemisType.SelectedValue != "")
        {
            param = param + " AND mas.CustTypeId='" + ddlChemisType.SelectedValue + "' ";
        }

        if (hfCustomerId.Value != "")
        {
            param = param + " AND mas.CustomerMasterId='" + hfCustomerId.Value + "' ";
        }

        if (ApprovalStatusSelect.SelectedValue != "")
        {
            param = param + " AND mas.ActionStatus='" + ApprovalStatusSelect.SelectedValue + "' ";
        }

        if ( frmDate.Text != "" && toDate.Text != "") {
            param = param + " AND CONVERT(date,mas.SubmissionDate)  BETWEEN '" + frmDate.Text+ "' AND '" + toDate.Text + "' ";
        }
        if (frmDate.Text != "" && toDate.Text == "") {
            param = param + " AND CONVERT(date,mas.SubmissionDate)  BETWEEN '" + frmDate.Text+ "' AND '" + DateTime.Now + "' ";
        }

        if (frmDate.Text != "" && toDate.Text == "") {
            param = param + " AND CONVERT(date,mas.SubmissionDate)  BETWEEN '" + frmDate.Text+ "' AND '" + DateTime.Now + "' ";
        }


        if (chkYes.Checked == true)
        {
            param = param + " AND mas.IsInvoice=1 ";
        }

        if (chkNo.Checked == true)
        {
            param = param + " AND mas.IsInvoice=0 ";
        }


        if (ddlCampaign.SelectedValue != "")
            {
                param = param + "  and OrderId in  (select OrderId from tblOrderDetail ORDRD   with (nolock) where replace(ORDRD.CampaignName,'''',' ') ='" + ddlCampaign.SelectedValue + "') ";

            }
       


         



        return param;
    }


    private string ParmDtls()
    {
        string param = "";


        //param = param + " AND mas.IsInvoice=0";

        if (ddlDistributionCenter.SelectedValue != "")
        {
            param = param + " AND mas.ComUnitId='" + ddlDistributionCenter.SelectedValue + "' ";
        }

        if (GroupSelect.SelectedValue != "")
        {
            param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        }

        if (ZoneSelect.SelectedValue != "")
        {
            param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        }

        if (AreaSelect.SelectedValue != "")
        {
            param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        }

        if (TeritorySelect.SelectedValue != "")
        {
            param = param + " AND mas.TerritoryId='" + TeritorySelect.SelectedValue + "' ";
        }

        if (SubTeritory.SelectedValue != "")
        {
            param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        }

        if (MarketSelect.SelectedValue != "")
        {
            param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        }



        if (ddlNSM.SelectedValue != "")
        {
            param = param + " AND mas.NSMId='" + ddlNSM.SelectedValue + "' ";
        }


        if (ddlDZSM.SelectedValue != "")
        {
            param = param + " AND mas.RSMId='" + ddlDZSM.SelectedValue + "' ";
        }


        if (ddlAM.SelectedValue != "")
        {
            param = param + " AND mas.ASMId='" + ddlAM.SelectedValue + "' ";
        }

        if (ddlMIO.SelectedValue != "")
        {
            param = param + " AND mas.MIOId='" + ddlMIO.SelectedValue + "' ";
        }


        if (ddlProgramType.SelectedValue != "")
        {
            param = param + " AND mas.ProgramTypeId='" + ddlProgramType.SelectedValue + "' ";
        }


        if (ddlChemisType.SelectedValue != "")
        {
            param = param + " AND mas.CustTypeId='" + ddlChemisType.SelectedValue + "' ";
        }

        if (hfCustomerId.Value != "")
        {
            param = param + " AND mas.CustomerMasterId='" + hfCustomerId.Value + "' ";
        }

        if (ApprovalStatusSelect.SelectedValue != "")
        {
            param = param + " AND mas.ActionStatus='" + ApprovalStatusSelect.SelectedValue + "' ";
        }

        if (frmDate.Text != "" && toDate.Text != "")
        {
            param = param + " AND CONVERT(date,mas.SubmissionDate)  BETWEEN '" + frmDate.Text + "' AND '" + toDate.Text + "' ";
        }
        if (frmDate.Text != "" && toDate.Text == "")
        {
            param = param + " AND CONVERT(date,mas.SubmissionDate)  BETWEEN '" + frmDate.Text + "' AND '" + DateTime.Now + "' ";
        }

        if (frmDate.Text != "" && toDate.Text == "")
        {
            param = param + " AND CONVERT(date,mas.SubmissionDate)  BETWEEN '" + frmDate.Text + "' AND '" + DateTime.Now + "' ";
        }


        if (chkIsActive.Checked)
        {

            if (ddlCampaign.SelectedValue != "")
            {
                param = param + " AND  replace(ORDRD.CampaignName,'''',' ')= '" + ddlCampaign.SelectedValue + "' ";

            }

        }
        //else
        //{
        //    if (ddlCampaign.SelectedValue != "")
        //    {
        //        param = param + "  and OrderId in  (select OrderId from tblOrderDetail ORDRD   with (nolock) where ORDRD.CampaignName ='" + ddlCampaign.SelectedValue + "') ";

        //    }
        //}


        string Role = "";
        DataTable dtMarket = _dataLoad.GetEmpMarketStructure_Active(EmpInfoId);

        string FFID = "";
        switch (RoleTypeName)
        {



            case "MIO":
                FFID = dtMarket.Rows[0]["MIOEmpId"].ToString();
                param = param + " AND View_Webapi_EmployeeFieldForceInfo.MIOEmpId=" + FFID;
                Role = "AM";

                break;

            case "AM":
                FFID = dtMarket.Rows[0]["ASMEMPId"].ToString();
                param = param + " AND View_Webapi_EmployeeFieldForceInfo.ASMEMPId=" + FFID;
                Role = "AM";

                break;
            case "DZSM":
                FFID = dtMarket.Rows[0]["RSMEMPId"].ToString();
                param = param + " AND  View_Webapi_EmployeeFieldForceInfo.RSMEMPId=" + FFID;
                Role = "DZSM";
                break;
            case "NSM":
                FFID = dtMarket.Rows[0]["NSMEMPId"].ToString();
                param = param + " AND  View_Webapi_EmployeeFieldForceInfo.NSMEMPId=" + FFID;
                Role = "NSM";
                break;


            default:

                Role = "";
                break;
        }



        return param;
    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("OrderTrackingList.aspx");
    }
}