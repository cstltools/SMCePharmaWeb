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

public partial class DWSP_AMDayWiseDWSPSetup : System.Web.UI.Page
{

    private AreaWiseTargetSetupDal areaWise = new AreaWiseTargetSetupDal();
    private CommonDataLoad _dataLoad = new CommonDataLoad();


    private CommonDal aDal = new CommonDal();


    private string EmpId = "";
    private string UserId = "";
    string areaId = ""; 
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
                        if (DT.Rows[0]["RoleTypeId"].ToString() == "3")
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

        ddlTerritory.CssClass = "form-select form-select-sm mb-3 mySelect2";

        if (ddlTerritory.SelectedValue == "")
        {
            ddlTerritory.ToolTip = "please fill out this field";
            ddlTerritory.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlTerritory.Focus();
            return false;
        }

        amount.CssClass = "form-control form-control-sm mb-3 clsDecimal";

         

        if (gv_List.Rows.Count == 0)
        {
            showMessageBox("Table can not be Empty!");

            return false;
        }

        decimal total = 0;
        try
        {
            total =Convert.ToDecimal(lblAllTotal.Text);
        }
        catch
        {

        }

        if (total==0)
        {

            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Total Target  Can not be Empty!!" + "','Faild');", true);
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
                HiddenField HFDWSPDate = ((HiddenField)gv_List.Rows[i].FindControl("HFDWSPDate"));
                TextBox txtGeneralAmount = ((TextBox)gv_List.Rows[i].FindControl("txtGeneralAmount"));
                TextBox txtFCBAmount = ((TextBox)gv_List.Rows[i].FindControl("txtFCBAmount"));
                TextBox txtCampaignAmount = ((TextBox)gv_List.Rows[i].FindControl("txtCampaignAmount"));

                TerritoryTargetSetupDao _DAO = new TerritoryTargetSetupDao();



                _DAO.TerritoryId = ddlTerritory.SelectedIndex > 0 ? int.Parse(ddlTerritory.SelectedValue) : (int?)null;

                _DAO.EmpInfoId = Convert.ToInt32(Request.QueryString["EmpId"]);
                _DAO.DWSPDate = string.IsNullOrEmpty(HFDWSPDate.Value) ? (DateTime?)null : DateTime.Parse(HFDWSPDate.Value);

                _DAO.FCBAmount = string.IsNullOrEmpty(txtFCBAmount.Text.Trim()) ? 0 : decimal.Parse(txtFCBAmount.Text);
                _DAO.GeneralAmount = string.IsNullOrEmpty(txtGeneralAmount.Text.Trim()) ? 0 : decimal.Parse(txtGeneralAmount.Text);
                _DAO.CampaignAmount = string.IsNullOrEmpty(txtCampaignAmount.Text.Trim()) ? 0 : decimal.Parse(txtCampaignAmount.Text);

                MarketList.Add(_DAO);

            }

            ResultInfo Res = areaWise.Save_DWSPMaster(MarketList, UserId);
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','TerritoryWiseTargetSetupApps.aspx?EmpId=" + Request.QueryString["EmpId"] + "');", true);


            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);
            }
        }
    }


    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("../DWSP/AMDayWiseDWSPSetup.aspx?EmpId=" + Request.QueryString["EmpId"]);

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

        //if (amount.Text != "")
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
        //else
        //{
        //    showMessageBox("Please Select Target Amount");
        //    amount.CssClass = "form-control form-control-sm mb-3 clsDecimal";

        //    if (amount.Text == "")
        //    {
        //        amount.ToolTip = "please fill out this field";
        //        amount.CssClass = "form-control form-control-sm mb-3 clsDecimal is-invalid";
        //        amount.Focus();
        //    }

        //    for (int k = 0; k < gv_List.Rows.Count; k++)
        //    {
        //        TextBox LTotal = (TextBox)gv_List.Rows[k].FindControl("txtAmount");
        //        LTotal.Text = "";
        //    }

        //}

    }
    private ZoneWiseTargetSetupDal aTargetSetupDal = new ZoneWiseTargetSetupDal();

    private void NewMethod()
    {
        try
        {
            
               DataTable dtTargetAmount = aTargetSetupDal.Get_TerriTargetAmount_All_ByTeritoryId(ddlmonth.SelectedItem.Text, ddlYear.SelectedValue, ddlTerritory.SelectedValue);

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

            DataTable dt = new DataTable();

            dt = aDal.GetTeritory_ByAreaId_IsVaccant(ddlArea.SelectedValue);

            ddlTerritory.DataSource = dt;
            ddlTerritory.DataValueField = "TerritoryId";
            ddlTerritory.DataTextField = "TerritoryName";
            ddlTerritory.DataBind();
            ddlTerritory.Items.Insert(0, new ListItem("Please Select From List", String.Empty));

        }

    }

    protected void ddlmonth_SelectedIndexChanged(object sender, EventArgs e)
    {
        NewMethod();

    }

    protected void btnAdd_Click(object sender, EventArgs e)
    { 
        Response.Redirect("../DWSP/TerritoryWiseTargetSetupApps.aspx?EmpId=" + Request.QueryString["EmpId"]);
    }

    protected void ddlTerritory_SelectedIndexChanged(object sender, EventArgs e)
    {

        try
        {
            DataTable dtDateStarttoEnd = aTargetSetupDal.Get_FirstDate_LastDatebyYearMonth(ddlmonth.SelectedValue, ddlYear.SelectedValue);
            NewMethod();
            if (dtDateStarttoEnd.Rows.Count > 0)
            {
                string StartDate = dtDateStarttoEnd.Rows[0]["FirstDay"].ToString();
                string EndDate = dtDateStarttoEnd.Rows[0]["LastDay"].ToString();

                DataTable dtDate = aTargetSetupDal.GetDatewithinDateRange(StartDate, EndDate);

                gv_List.DataSource = dtDate;
                gv_List.DataBind();

                //for (int i = 0; i < gv_List.Rows.Count; i++)
                //{
                //    HiddenField HFDWSPDate = ((HiddenField)gv_List.Rows[i].FindControl("HFDWSPDate"));
                //    TextBox txtGeneralAmount = ((TextBox)gv_List.Rows[i].FindControl("txtGeneralAmount"));
                //    TextBox txtFCBAmount = ((TextBox)gv_List.Rows[i].FindControl("txtFCBAmount"));
                //    TextBox txtCampaignAmount = ((TextBox)gv_List.Rows[i].FindControl("txtCampaignAmount"));

                   
                //    if(Convert.ToDateTime( HFDWSPDate.Value)>Convert.ToDateTime(DateTime.Now))
                //    {
                       

                //    }
                //    else
                //    {
                //        txtFCBAmount.ReadOnly = true;
                //        txtGeneralAmount.ReadOnly = true;
                //        txtCampaignAmount.ReadOnly = true;
                //    }

                //}
            }
            }
        catch (Exception ex)
        {

        }

        NewMethod();

    }

    protected void txtGeneralAmount_TextChanged(object sender, EventArgs e)
    {
        calculation();
    }

    protected void txtFCBAmount_TextChanged(object sender, EventArgs e)
    {
        calculation();
    }

    protected void txtCampaignAmount_TextChanged(object sender, EventArgs e)
    {
        calculation();
    }

    private void calculation()
    {
        //if (amount.Text != "")
        {
            decimal target = 0;
            //target = decimal.Parse(amount.Text);
            
            decimal camptemValue = 0;
            decimal Genvalue = 0;
            decimal tempGenvalue = 0;
            decimal Campvalue = 0;
            decimal empCampvalue = 0;
            decimal fcbvalue = 0;
            decimal tempfcbvalue = 0;
            for (int k = 0; k < gv_List.Rows.Count; k++)
            {
                TextBox txtGeneralAmount = ((TextBox)gv_List.Rows[k].FindControl("txtGeneralAmount"));
                TextBox txtFCBAmount = ((TextBox)gv_List.Rows[k].FindControl("txtFCBAmount"));
                TextBox txtCampaignAmount = ((TextBox)gv_List.Rows[k].FindControl("txtCampaignAmount"));

                if (txtGeneralAmount.Text != "")
                {
                    Genvalue = decimal.Parse(txtGeneralAmount.Text);
                    tempGenvalue += Genvalue;




                }
                if (txtFCBAmount.Text != "")
                {
                    fcbvalue = decimal.Parse(txtFCBAmount.Text);
                  
                    tempfcbvalue += fcbvalue;



                }

                if (txtCampaignAmount.Text != "")
                {
                    Campvalue = decimal.Parse(txtCampaignAmount.Text);
                    empCampvalue += Campvalue;




                }

            }
            lblCampaign.Text = empCampvalue.ToString();
            lblFCBAmount.Text = tempfcbvalue.ToString();
            lblGeneral.Text = tempGenvalue.ToString();
            lblAllTotal.Text = (tempGenvalue + empCampvalue + tempfcbvalue).ToString();


        }
        //else
        //{
        //    showMessageBox("Please Select Target Amount");
        //    amount.CssClass = "form-control form-control-sm mb-3 clsDecimal";

        //    if (amount.Text == "")
        //    {
        //        amount.ToolTip = "please fill out this field";
        //        amount.CssClass = "form-control form-control-sm mb-3 clsDecimal is-invalid";
        //        amount.Focus();
        //    }

        //    for (int k = 0; k < gv_List.Rows.Count; k++)
        //    {
        //        TextBox txtGeneralAmount = (TextBox)gv_List.Rows[k].FindControl("txtGeneralAmount");
        //        TextBox txtFCBAmount = ((TextBox)gv_List.Rows[k].FindControl("txtFCBAmount"));
        //        TextBox txtCampaignAmount = ((TextBox)gv_List.Rows[k].FindControl("txtCampaignAmount"));

        //        txtGeneralAmount.Text = "";
        //        txtFCBAmount.Text = "";
        //        txtCampaignAmount.Text = "";
        //    }

        //}
    }
}