using Library.DAL.MasterSetup_DAL;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterSetup_UI_CustomerChangeProgramType : System.Web.UI.Page
{

    static CommonDataLoad _dataLoad = new CommonDataLoad();

    private static SeedDataDAL _seedRepo = new SeedDataDAL();

    private static CustomerInfoDAL _DAL = new CustomerInfoDAL();
    private DropDownList GroupSelect, ZoneSelect, AreaSelect, TeritorySelect, SubTeritory, MarketSelect;
    protected void Page_Load(object sender, EventArgs e)
    {
        GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;
        if (!IsPostBack)
        {
            frmDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            toDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");


            try
            {
                using (DataTable dt = _seedRepo.GetSMCTypeListParam(" and GRP.forCustomer=1"))
                {
                    ddlPharmaPlatform.DataSource = dt;
                    ddlPharmaPlatform.DataValueField = "SMCTypeId";
                    ddlPharmaPlatform.DataTextField = "SMCType";
                    ddlPharmaPlatform.DataBind();
                    ddlPharmaPlatform.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlPharmaPlatform.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }
            try
            {
                using (DataTable dt = _dataLoad.GetDivision_Active())
                {
                    DivisionSelect.DataSource = dt;
                    DivisionSelect.DataValueField = "DivisionId";
                    DivisionSelect.DataTextField = "DivisionName";
                    DivisionSelect.DataBind();
                    DivisionSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    DivisionSelect.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }
            try
            {
                using (DataTable dt = _seedRepo.GetProgramTypeListParam(" and GRP.IsCustomer=1"))
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
                    ddlApprovalStatus.DataSource = dt;
                    ddlApprovalStatus.DataValueField = "SoftwareUseId";
                    ddlApprovalStatus.DataTextField = "WebShow";
                    ddlApprovalStatus.DataBind();
                    ddlApprovalStatus.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlApprovalStatus.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }

            //try
            //{
            //    using (DataTable dt = _seedRepo.GetProgramTypeList())
            //    {
            //        ddlProgramType.DataSource = dt;
            //        ddlProgramType.DataValueField = "ProgramTypeId";
            //        ddlProgramType.DataTextField = "ProgramTypeName";
            //        ddlProgramType.DataBind();
            //        ddlProgramType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
            //        ddlProgramType.SelectedIndex = 0;
            //    }


            //}
            //catch (Exception ex) { }


          

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


         //   btnSearch_Click(null, null);
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
    protected void custNameTextBox_TextChanged(object sender, EventArgs e)
    {


        string empName = custNameTextBox.Text.Trim();
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
    private void LoadData(string parm)
    {
        DataTable aDataTable = _DAL.GetCustomerList(parm);
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
        lblCount.Text = "Total : " + aDataTable.Rows.Count.ToString();
        if (aDataTable.Rows.Count > 0)
        {

            DataTable dt = _seedRepo.GetProgramTypeListParam(" and GRP.IsCustomer=1");

                for (int i = 0; i < loadGridView.Rows.Count; i++)
            {

               DropDownList ddlProgramType_G = (DropDownList)loadGridView.Rows[i].Cells[0].FindControl("ddlProgramType_G");
                try
                {
                   
                        ddlProgramType_G.DataSource = dt;
                        ddlProgramType_G.DataValueField = "ProgramTypeId";
                        ddlProgramType_G.DataTextField = "ProgramTypeName";
                        ddlProgramType_G.DataBind();
                        ddlProgramType_G.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                        ddlProgramType_G.SelectedIndex = 0;

                        try
                        {
                            ddlProgramType_G.SelectedValue = aDataTable.Rows[i]["ProgramTypeId"].ToString();
                        }
                        catch (Exception ex) { }
                    


                }
                catch (Exception ex) { }
            }


        }
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            var datKey = loadGridView.DataKeys[0];
            if (datKey != null)
            {


                int rowindex = (Convert.ToInt32(e.CommandArgument));
                GridViewRow row = loadGridView.Rows[rowindex];

                
            }
        }


        if (e.CommandName == "UpdateData")
        {
            var datKey = loadGridView.DataKeys[0];
            if (datKey != null)
            {


                int rowindex = Convert.ToInt32(e.CommandArgument);

                HiddenField hfCustomerMasterId = ((HiddenField)loadGridView.Rows[rowindex].Cells[1].FindControl("hfCustomerMasterId"));

                TextBox txtProgramTypeCode = ((TextBox)loadGridView.Rows[rowindex].Cells[1].FindControl("txtProgramTypeCode"));
                DropDownList ddlProgramType_G = (DropDownList)loadGridView.Rows[rowindex].Cells[0].FindControl("ddlProgramType_G");

                if (ddlProgramType_G.SelectedValue != "")
                {
                    string ProgramTypeCode = string.IsNullOrEmpty(txtProgramTypeCode.Text) ? null : txtProgramTypeCode.Text;

                    int? ProgramTypeId = ddlProgramType_G.SelectedIndex > 0 ? int.Parse(ddlProgramType_G.SelectedValue) : (int?)null;


                    int UpdateBy = Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString());
                    DateTime UpdateDate = DateTime.Now;
                    ResultInfo Res = _DAL.Update__ProgramTypeInfo(hfCustomerMasterId.Value, ProgramTypeCode, ProgramTypeId, UpdateBy, UpdateDate);
                    if (Res.isSuccess == true)
                    {
                        //ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','CustomerChangeProgramType.aspx');", true);
                        //faildalert


                        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Operation successful!" + "','Faild');", true);

                        if (ddlProgramType.SelectedValue != "")
                        {
                            LoadData(Parm());
                        }
                        else
                        {


                            loadGridView.DataSource = null;
                            loadGridView.DataBind();
                        }
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

                    }
                }
                else
                {

                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please Select Program Type!" + "','Faild');", true);

                    ddlProgramType_G.Focus();
                }


                //Response.Redirect("GroupWisePromoQtyEntry.aspx?MID=" + unitPriceId);
            }
        }
    }
    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (ddlProgramType.SelectedValue != "")
        {
            LoadData(Parm());
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please Select Program Type!" + "','Faild');", true);

            loadGridView.DataSource = null;
            loadGridView.DataBind();
        }
    }


    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {

        if (loadGridView.Rows.Count > 0)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Customer_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".csv");
            Response.Charset = "";
            Response.ContentType = "text/csv";
            Response.ContentEncoding = Encoding.Default;
            //To Export all pages.
            gv_Export.AllowPaging = false;
         

            DataTable aDataTable = _DAL.GetCustomerList(Parm());
            gv_Export.DataSource = aDataTable;
            gv_Export.DataBind();

            StringBuilder sb = new StringBuilder();
            foreach (TableCell cell in gv_Export.HeaderRow.Cells)
            {
                //Append data with separator.
                sb.Append(HttpUtility.HtmlDecode(cell.Text) + ',');
            }
            //Append new line character.
            sb.Append("\r\n");

            foreach (GridViewRow row in gv_Export.Rows)
            {
                foreach (TableCell cell in row.Cells)
                {
                    if (cell.Text.Contains(","))
                    {
                        sb.Append(String.Format("\"{0}\",", cell.Text));
                    }
                    else
                    { sb.Append(HttpUtility.HtmlDecode(cell.Text) + ','); }
                    //Append data with separator.

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
    private string Parm()
    {
        string param = "";


        //if (ddlDistributionCenter.SelectedValue != "")
        //{
        //    param = param + " AND mas.ComUnitId='" + ddlDistributionCenter.SelectedValue + "' ";
        //}

        if (GroupSelect.SelectedValue != "")
        {
            param = param + " AND gr.GroupId='" + GroupSelect.SelectedValue + "' ";
        }

        if (ZoneSelect.SelectedValue != "")
        {
            param = param + " AND rg.RegionId='" + ZoneSelect.SelectedValue + "' ";
        }

        if (AreaSelect.SelectedValue != "")
        {
            param = param + " AND Ar.AreaId='" + AreaSelect.SelectedValue + "' ";
        }

        if (TeritorySelect.SelectedValue != "")
        {
            param = param + " AND Tr.TerritoryId='" + TeritorySelect.SelectedValue + "' ";
        }

        if (SubTeritory.SelectedValue != "")
        {
            param = param + " AND subTr.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        }

        if (MarketSelect.SelectedValue != "")
        {
            param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        }

        if (ddlProgramType.SelectedValue != "")
        {
            param = param + "   AND  mas.ProgramTypeId='" + ddlProgramType.SelectedValue + "' ";
        }
        if (ddlStatus.SelectedValue != "")
        {
            param = param + " AND mas.IsActive=" + ddlStatus.SelectedValue + " ";
        }

        if (ddlPharmaPlatform.SelectedValue != "")
        {
            param = param + " AND mas.SMCTypeId='" + ddlPharmaPlatform.SelectedValue + "' ";
        }


        if (hfCustomerId.Value != "")
        {
            param = param + " AND  mas.CustomerMasterId='" + hfCustomerId.Value + "' ";
        }
        if (ddlStationType.SelectedValue != "")
        {
            param = param + " AND mas.StationTypeId='" + ddlStationType.SelectedValue + "' ";
        }
        //if (ddlStationType.SelectedValue != "")
        //{
        //    param = param + " AND mas.StationTypeId='" + ddlStationType.SelectedValue + "' ";
        //}

        //if (ddlStationType.SelectedValue != "")
        //{
        //    param = param + " AND mas.StationTypeId='" + ddlStationType.SelectedValue + "' ";
        //}


        if (DivisionSelect.SelectedValue != "")
        {
            param = param + " AND div.DivisionId='" + DivisionSelect.SelectedValue + "' ";
        }
        if (DistrictSelect.SelectedValue != "")
        {
            param = param + " AND dis.DistrictId='" + DistrictSelect.SelectedValue + "' ";
        }

        if (ThanaSelect.SelectedValue != "")
        {
            param = param + " AND mr.ThanaId='" + ThanaSelect.SelectedValue + "' ";
        }
        //if (ddlApprovalStatus.SelectedValue != "")
        //{
        //    param = param + " AND mas.ActionStatus='" + ddlApprovalStatus.SelectedValue + "' ";
        //}

        //if ( frmDate.Text != "" && toDate.Text != "") {
        //    param = param + " AND CONVERT(date,mas.CreateDate)  BETWEEN '" + frmDate.Text+ "' AND '" + toDate.Text + "' ";
        //}
        //if (frmDate.Text != "" && toDate.Text == "") {
        //    param = param + " AND CONVERT(date,mas.CreateDate)  BETWEEN '" + frmDate.Text+ "' AND '" + DateTime.Now + "' ";
        //}

        //if (frmDate.Text != "" && toDate.Text == "") {
        //    param = param + " AND CONVERT(date,mas.CreateDate)  BETWEEN '" + frmDate.Text+ "' AND '" + DateTime.Now + "' ";
        //}

        return param;
    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("CustomerView.aspx");
    }

    protected void ddlStationType_SelectedIndexChanged(object sender, EventArgs e)
    {
        
    }

    protected void ddlProgramType_SelectedIndexChanged(object sender, EventArgs e)
    {
       
    }

    protected void DivisionSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        DistrictSelect.Items.Clear();
        ThanaSelect.Items.Clear();
        try
        {
            using (DataTable dt = _dataLoad.GetDistrict_ByDivision_Active(Convert.ToInt32(DivisionSelect.SelectedValue)))
            {
                DistrictSelect.DataSource = dt;
                DistrictSelect.DataValueField = "DistrictId";
                DistrictSelect.DataTextField = "DistrictName";
                DistrictSelect.DataBind();
                DistrictSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                DistrictSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

    }

    protected void DistrictSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        ThanaSelect.Items.Clear();
        try
        {
            using (DataTable dt = _dataLoad.GetThana_ByDistrict_Active(Convert.ToInt32(DistrictSelect.SelectedValue)))
            {
                ThanaSelect.DataSource = dt;
                ThanaSelect.DataValueField = "ThanaId";
                ThanaSelect.DataTextField = "ThanaName";
                ThanaSelect.DataBind();
                ThanaSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ThanaSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
    }

    protected void lblEditMode_Click(object sender, EventArgs e)
    {
        LinkButton ImageButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)ImageButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        HiddenField hfCustomerMasterId = ((HiddenField)loadGridView.Rows[rowindex].Cells[1].FindControl("hfCustomerMasterId"));

        TextBox txtProgramTypeCode = ((TextBox)loadGridView.Rows[rowindex].Cells[1].FindControl("txtProgramTypeCode"));
        DropDownList ddlProgramType_G = (DropDownList)loadGridView.Rows[rowindex].Cells[0].FindControl("ddlProgramType_G");

        LinkButton lbtUpDate = ((LinkButton)loadGridView.Rows[rowindex].Cells[1].FindControl("lbtUpDate"));

        txtProgramTypeCode.ReadOnly = false;
        lbtUpDate.Visible = true;
        ddlProgramType_G.Enabled = true;
    }

    protected void lbtUpDate_Click(object sender, EventArgs e)
    {

        LinkButton ImageButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)ImageButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        HiddenField hfCustomerMasterId = ((HiddenField)loadGridView.Rows[rowindex].Cells[1].FindControl("hfCustomerMasterId"));

        TextBox txtProgramTypeCode = ((TextBox)loadGridView.Rows[rowindex].Cells[1].FindControl("txtProgramTypeCode"));
        DropDownList ddlProgramType_G = (DropDownList)loadGridView.Rows[rowindex].Cells[0].FindControl("ddlProgramType_G");

        if (ddlProgramType_G.SelectedValue != "")
        {
            string ProgramTypeCode = string.IsNullOrEmpty(txtProgramTypeCode.Text) ? null : txtProgramTypeCode.Text;

            int? ProgramTypeId = ddlProgramType_G.SelectedIndex > 0 ? int.Parse(ddlProgramType_G.SelectedValue) : (int?)null;


            int UpdateBy = Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString());
            DateTime UpdateDate = DateTime.Now;
            ResultInfo Res = _DAL.Update__ProgramTypeInfo(hfCustomerMasterId.Value, ProgramTypeCode, ProgramTypeId, UpdateBy, UpdateDate);
            if (Res.isSuccess == true)
            {
                //ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','CustomerChangeProgramType.aspx');", true);
                //faildalert


                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Operation successful!" + "','Faild');", true);

                if (ddlProgramType.SelectedValue != "")
                {
                    LoadData(Parm());
                }
                else
                {


                    loadGridView.DataSource = null;
                    loadGridView.DataBind();
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }
        }
        else
        {

            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please Select Program Type!" + "','Faild');", true);

            ddlProgramType_G.Focus();
        }
    }
}