using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DWSP_DAL;
using Library.DAO.DWSP_DAO;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class DWSP_TerritoryWiseTargetSetupApps : System.Web.UI.Page
{ 
   
    private AreaWiseTargetSetupDal areaWise = new AreaWiseTargetSetupDal();
    private CommonDataLoad _dataLoad = new CommonDataLoad();


    private CommonDal aDal = new CommonDal();

    string areaId = "";

    private string EmpId = "";
    private string UserId = "";
    string RoleTypeName = "";
    string masArea = "";
    string strRole = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                GetMonthList(ddlmonth);
                GetYearList(ddlYear);
            }

            catch (Exception ex) { }
          
 

            if (!string.IsNullOrEmpty(Request.QueryString["EmpId"]))
            {
              

              EmpId = Request.QueryString["EmpId"];

              LoadInitialInfo();
               
            }
            else
            {
                btnSave.Visible = true;
            }
        }
    }

    private void LoadInitialInfo()
    {

        hfZoneId.Value = "";
        amount.Text = "";

        try
        {
            using (DataTable dt = aDal.Get_Group_All())
            {
                groupname.DataSource = dt;
                groupname.DataValueField = "GroupId";
                groupname.DataTextField = "GroupName";
                groupname.DataBind();
                groupname.Items.Insert(0, new ListItem("Please Select From List", String.Empty));

                try
                {

                    DataTable DT = aDal.Get_RoleTypeEmpId(EmpId);

                    if (DT.Rows.Count > 0)
                    {
                        if (DT.Rows[0]["RoleTypeId"].ToString() == "2")
                        {
                            UserId = DT.Rows[0]["UserId"].ToString();
                            
                            DataTable dtZone = aDal.Get_ZoneinfoByEmpId(EmpId);
                            if (dtZone.Rows.Count > 0)
                            {
                                hfZoneId.Value = dtZone.Rows[0]["RegionId"].ToString();
                                hfAreaId.Value = dtZone.Rows[0]["AreaId"].ToString();
                                groupname.SelectedValue = dtZone.Rows[0]["GroupId"].ToString();
                                groupname_SelectedIndexChanged(null, null);
                                groupname.Enabled = false;
                            }
                        }

                        if (DT.Rows[0]["RoleTypeId"].ToString() == "3" )
                        {
                            UserId = DT.Rows[0]["UserId"].ToString();

                            DataTable dtZone = aDal.Get_DZSMinfoByEmpId(Request.QueryString["EmpId"].ToString());
                            if (dtZone.Rows.Count > 0)
                            {
                                hfZoneId.Value = dtZone.Rows[0]["RegionId"].ToString();
                                groupname.SelectedValue = dtZone.Rows[0]["GroupId"].ToString();
                                groupname_SelectedIndexChanged(null, null);
                                groupname.Enabled = false;
                            }
                        }
                    }

                }
                catch (Exception ex)
                {
                    groupname.SelectedIndex = 0;
                }

            }


        }
        catch (Exception ex) { }

        try
        {
            //using (DataTable dt = aTargetDal2.LoadProduct())
            //{
            //    ddlProduct.DataSource = dt;
            //    ddlProduct.DataValueField = "ProductId";
            //    ddlProduct.DataTextField = "ProductName";
            //    ddlProduct.DataBind();
            //    ddlProduct.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
            //    ddlProduct.SelectedIndex = 0;
            //}


        }
        catch (Exception ex) { }




    }
    public void GetYearList(DropDownList ddl)
    {
        int i;

        for (i = 2015; i <= 2050; i++)
        {
            ddl.Items.Add(i.ToString());
            ddl.Items.FindByValue(System.DateTime.Now.Year.ToString());
        }
        string strYear = System.DateTime.Now.Year.ToString();

        ddl.SelectedValue = strYear;


    }
    public void GetMonthList(DropDownList ddl)
    {
        DateTime month = Convert.ToDateTime(DateTime.Now);
        for (int i = 0; i < 12; i++)
        {
            DateTime NextMont = month.AddMonths(i);
            ListItem list = new ListItem();
            list.Text = NextMont.ToString("MMMM");
            list.Value = NextMont.Month.ToString();
            ddl.Items.Add(list);
        }
        //ddl.Items.Insert(0, "Select Month");
        ddl.Items.FindByValue(DateTime.Now.Month.ToString()).Selected = true;
    }

    private bool Validation()
    {

        ddlYear.CssClass = "form-select form-select-sm mb-3 mySelect2";

        if (ddlYear.SelectedValue == "")
        {
            ddlYear.ToolTip = "please fill out this field";
            ddlYear.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlYear.Focus();
            return false;
        }

        ddlmonth.CssClass = "form-select form-select-sm mb-3 mySelect2";
        if (ddlmonth.SelectedValue == "")
        {
            ddlmonth.ToolTip = "please fill out this field";
            ddlmonth.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlmonth.Focus();
            return false;
        }

        groupname.CssClass = "form-select form-select-sm mb-3 mySelect2";

        if (groupname.SelectedValue == "")
        {
            groupname.ToolTip = "please fill out this field";
            groupname.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            groupname.Focus();
            return false;
        }

        amount.CssClass = "form-control form-control-sm mb-3 clsDecimal";

        if (amount.Text == "")
        {
            amount.ToolTip = "please fill out this field";
            amount.CssClass = "form-control form-control-sm mb-3 clsDecimal is-invalid";
            amount.Focus();
            return false;
        }

        if (gv_List.Rows.Count == 0)
        {
            showMessageBox("Table can not be Empty!");

            return false;
        }

        //Int32 count = 0;

        //for (int i = 0; i < gv_List.Rows.Count; i++)
        //{
        //    var chkBoxRows = (CheckBox)gv_List.Rows[i].FindControl("chkSelect");

        //    if (chkBoxRows.Checked)
        //    {
        //        count++;
        //    }

        //    if (count > 0)
        //    {
        //        break;
        //    }
        //}

        //if (count == 0)
        //{
        //    showMessageBox("Please Select at least one employee !!!");
        //    return false;
        //}

        for (int i = 0; i < gv_List.Rows.Count; i++)
        {

            TextBox txtQty = ((TextBox)gv_List.Rows[i].FindControl("txtAmount"));
            txtQty.CssClass = "form-control form-control-sm";

            if (txtQty.Text == "")
            {
                txtQty.ToolTip = "please fill out this field";
                txtQty.CssClass = "form-control form-control-sm is-invalid";
                txtQty.Focus();
                return false;
            }
        }

        return true;

    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }


    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (Validation())
        {

            List<TerritoryTargetSetupDao> MarketList = new List<TerritoryTargetSetupDao>();

            for (int i = 0; i < gv_List.Rows.Count; i++)
            {
                HiddenField HFTerritoryId = ((HiddenField)gv_List.Rows[i].FindControl("HFTerritoryId"));
                TextBox txtAmount = ((TextBox)gv_List.Rows[i].FindControl("txtAmount"));

                TerritoryTargetSetupDao _DAO = new TerritoryTargetSetupDao();

                _DAO.TerritoryWTSetupId = 0;

                _DAO.Year = string.IsNullOrEmpty(ddlYear.SelectedValue.Trim()) ? null : ddlYear.SelectedValue.Trim();

                _DAO.Month = string.IsNullOrEmpty(ddlmonth.SelectedItem.Text.Trim()) ? null : ddlmonth.SelectedItem.Text.Trim();

                _DAO.GroupId = string.IsNullOrEmpty(groupname.SelectedValue) ? (int?)null : int.Parse(groupname.SelectedValue);

                _DAO.RegionId = string.IsNullOrEmpty(ddlZone.SelectedValue) ? (int?)null : int.Parse(ddlZone.SelectedValue);
                _DAO.AreaId = string.IsNullOrEmpty(ddlArea.SelectedValue) ? (int?)null : int.Parse(ddlArea.SelectedValue);

                _DAO.TargetAmount = string.IsNullOrEmpty(amount.Text.Trim()) ? 0 : decimal.Parse(amount.Text);

                _DAO.TerritoryId = string.IsNullOrEmpty(HFTerritoryId.Value) ? 0 : int.Parse(HFTerritoryId.Value);

                _DAO.Amount = string.IsNullOrEmpty(txtAmount.Text.Trim()) ? 0 : decimal.Parse(txtAmount.Text);

                MarketList.Add(_DAO);

            }

            ResultInfo Res = areaWise.SaveTerritoryWiseTarget(MarketList, UserId);
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','TerritoryWiseTargetSetupApps.aspx?EmpId=" + Request.QueryString["EmpId"]+"');", true);

                
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);
            }
        }
    }


    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("../DWSP/TerritoryWiseTargetSetupApps.aspx?EmpId=" + Request.QueryString["EmpId"]);

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

    protected void groupname_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (groupname.SelectedValue != "")
        {
            try
            {

              
                    try
                    {
 DataTable DT = aDal.Get_RoleTypeEmpId(EmpId);

                    if (DT.Rows.Count > 0)
                    {
                        if (DT.Rows[0]["RoleTypeId"].ToString() == "2")
                        {
                            using (DataTable dt = aDal.Get_Forddl_ZoneActive_All_ByGroup(groupname.SelectedValue))
                            {
                                ddlZone.DataSource = dt;
                                ddlZone.DataValueField = "RegionId";
                                ddlZone.DataTextField = "RegionName";
                                ddlZone.DataBind();
                                ddlZone.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                            }
                            ddlZone.SelectedValue = hfZoneId.Value;

                            ddlZone_OnSelectedIndexChanged(null, null);
                            ddlZone.Enabled = false;
                        }


                            if (DT.Rows[0]["RoleTypeId"].ToString() == "3")
                            {
                                RoleTypeName = "DZSM";

                                if (!string.IsNullOrEmpty(Request.QueryString["EmpId"]))
                                {
                                    DataTable dtMarket = _dataLoad.GetHigharcyInfoByEmployeeId(Request.QueryString["EmpId"], "3");

                                    string FFID = "";

                                    switch (RoleTypeName)
                                    {


                                        case "DZSM":
                                            strRole = "DZSM";

                                            for (int i = 0; i < dtMarket.Rows.Count; i++)
                                            {
                                                areaId = areaId + dtMarket.Rows[i]["RegionId"].ToString() + ',';
                                            }
                                            masArea = areaId.TrimEnd(',');

                                            break;



                                        default:

                                            break;


                                    }
                                }

                                if (!string.IsNullOrEmpty(Request.QueryString["EmpId"]))
                                {
                                    DataTable dtMarket = _dataLoad.GetHigharcyInfoByEmployeeId(Request.QueryString["EmpId"], "3");
                                    RoleTypeName = "DZSM";

                                    string FFID = "";
                                    switch (RoleTypeName)
                                    {


                                        case "DZSM":
                                            groupname.SelectedValue = dtMarket.Rows[0]["GroupId"].ToString();
                                            hfZoneId.Value = dtMarket.Rows[0]["RegionId"].ToString();
                                            groupname.Enabled = false;
                                            // ZoneSelect.Enabled = false;
                                            break;



                                        default:

                                            break;


                                    }
                                }

                            if (strRole == "DZSM")
                            {
                                try
                                {

                                    if (masArea == "")
                                    {
                                        using (DataTable dtZone = _dataLoad.GetZone_byGroupId_forDSM(areaId.ToString()))
                                        {
                                            ddlZone.DataSource = dtZone;
                                            ddlZone.DataValueField = "RegionId";
                                            ddlZone.DataTextField = "RegionName";
                                            ddlZone.DataBind();
                                            ddlZone.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                                            ddlZone.SelectedIndex = 0;
                                        }
                                    }
                                    else
                                    {
                                        using (DataTable dtZone = _dataLoad.GetZone_byGroupId_forDSM(masArea))
                                        {
                                            ddlZone.DataSource = dtZone;
                                            ddlZone.DataValueField = "RegionId";
                                            ddlZone.DataTextField = "RegionName";
                                            ddlZone.DataBind();
                                            ddlZone.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                                            ddlZone.SelectedIndex = 0;
                                        }
                                    }


                                }
                                catch (Exception ex)
                                {

                                }

                            }
                            else
                            {

                                ddlZone.SelectedValue = hfZoneId.Value;

                                ddlZone_OnSelectedIndexChanged(null, null);
                                //  ddlZone.Enabled = false;
                            }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        ddlZone.SelectedIndex = 0;

                    }
              
            }
            catch (Exception ex)
            {

            }
        }


    }



    protected void txtAmount_OnTextChanged(object sender, EventArgs e)
    {

        if (amount.Text != "")
        {
            decimal target = 0;
            target = decimal.Parse(amount.Text);
            gv_List.FooterRow.Cells[1].Text = "Total";
            gv_List.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
            decimal temValue = 0;
            decimal value = 0;
            for (int k = 0; k < gv_List.Rows.Count; k++)
            {
                TextBox LTotal = (TextBox)gv_List.Rows[k].FindControl("txtAmount");

                if (LTotal.Text != "")
                {
                    value = decimal.Parse(LTotal.Text);
                    temValue += value;

                    if (temValue <= target)
                    {
                        gv_List.FooterRow.Cells[2].Text = temValue.ToString();
                        gv_List.FooterRow.Cells[2].Font.Bold = true;
                        gv_List.FooterRow.Cells[2].HorizontalAlign = HorizontalAlign.Right;
                        gv_List.FooterRow.BackColor = System.Drawing.Color.Beige;
                    }
                    else
                    {
                        showMessageBox("Amount must be equal with target amount");
                        LTotal.Text = "";
                    }

                }

            }
        }
        else
        {
            showMessageBox("Please Select Target Amount");
            amount.CssClass = "form-control form-control-sm mb-3 clsDecimal";

            if (amount.Text == "")
            {
                amount.ToolTip = "please fill out this field";
                amount.CssClass = "form-control form-control-sm mb-3 clsDecimal is-invalid";
                amount.Focus();
            }

            for (int k = 0; k < gv_List.Rows.Count; k++)
            {
                TextBox LTotal = (TextBox)gv_List.Rows[k].FindControl("txtAmount");
                LTotal.Text = "";
            }

        }

    }
    private ZoneWiseTargetSetupDal aTargetSetupDal = new ZoneWiseTargetSetupDal();

    private void NewMethod()
    {
        try
        {
            DataTable dtTargetAmount = aTargetSetupDal.Get_TerriTargetAmount_All_ByArea(ddlmonth.SelectedItem.Text, ddlYear.SelectedValue, ddlArea.SelectedValue);

            if (dtTargetAmount.Rows.Count > 0)
            {
                amount.Text = dtTargetAmount.Rows[0]["Amount"].ToString();
            }
            else
            {
                amount.Text = "";
            }
        }
        catch (Exception ex)
        {

        }
    }


    protected void ddlZone_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {

            DataTable dt = _dataLoad.GetArea_ByZoneId_Active(Convert.ToInt32(ddlZone.SelectedValue));
            {
                ddlArea.DataSource = dt;
                ddlArea.DataValueField = "AreaId";
                ddlArea.DataTextField = "AreaName";
                ddlArea.DataBind();
                ddlArea.Items.Insert(0, new ListItem("Please Select From List", String.Empty));

                try
                {
 DataTable DT = aDal.Get_RoleTypeEmpId(EmpId);

                    if (DT.Rows.Count > 0)
                    {
                        if (DT.Rows[0]["RoleTypeId"].ToString() == "2")
                        {

                            ddlArea.SelectedValue = hfAreaId.Value;

                            ddlArea_SelectedIndexChanged(null, null);
                            ddlArea.Enabled = false;
                        }

                        if (DT.Rows[0]["RoleTypeId"].ToString() == "3")
                        {

                            ddlArea.SelectedValue = hfAreaId.Value;

                            ddlArea_SelectedIndexChanged(null, null);
                            ddlArea.Enabled = false;
                        }
                    }
                }
                catch (Exception ex)
                {
                    ddlArea.SelectedIndex = 0;

                }
            }
        }
        catch (Exception ex)
        {

        }


    }

    protected void ddlYear_SelectedIndexChanged(object sender, EventArgs e)
    {
        NewMethod();
    }

    protected void groupname_SelectedIndexChanged1(object sender, EventArgs e)
    {
        NewMethod();

    }

    protected void ddlArea_SelectedIndexChanged(object sender, EventArgs e)
    {
        gv_List.DataSource = null;

        gv_List.DataBind();
        if (ddlZone.SelectedValue != "")
        {
           
            DataTable ds = new DataTable();

            ds = aDal.GetTeritory_ByAreaId_All(ddlArea.SelectedValue);


            NewMethod();
            gv_List.DataSource = ds;
            gv_List.DataBind();

            gv_List.FooterRow.Cells[1].Text = "Total";
            gv_List.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
            decimal temValue = 0;
            decimal value = 0;
            for (int k = 0; k < gv_List.Rows.Count; k++)
            {
                TextBox LTotal = (TextBox)gv_List.Rows[k].FindControl("txtAmount");

                if (LTotal.Text != "")
                {
                    value = decimal.Parse(LTotal.Text);
                    temValue += value;
                    gv_List.FooterRow.Cells[2].Text = temValue.ToString();
                    gv_List.FooterRow.Cells[2].Font.Bold = true;
                    gv_List.FooterRow.Cells[2].HorizontalAlign = HorizontalAlign.Right;
                    gv_List.FooterRow.BackColor = System.Drawing.Color.Beige;

                }

            }

        }

    }

    protected void ddlmonth_SelectedIndexChanged(object sender, EventArgs e)
    {
        NewMethod();

    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        Response.Redirect("../DWSP/AMDayWiseDWSPSetup.aspx?EmpId=" + Request.QueryString["EmpId"]);
    }
}