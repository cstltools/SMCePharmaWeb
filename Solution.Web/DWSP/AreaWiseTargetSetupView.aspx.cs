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

public partial class DWSP_AreaWiseTargetSetupView : System.Web.UI.Page
{

    private AreaWiseTargetSetupDal areaWise = new AreaWiseTargetSetupDal();

    private CommonDataLoad _dataLoad = new CommonDataLoad();
    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = "";

    string areaId = "";
    string masArea = "";
    string strRole = "";

    private CommonDal aDal = new CommonDal();

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

            if (EmpInfoId != "" || EmpInfoId != null)
            {
                DataTable dtMarket = _dataLoad.GetHigharcyInfoByEmployeeId(EmpInfoId.ToString(), ToRoleTypeId.ToString());

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

            if (EmpInfoId != "" || EmpInfoId != null)
            {
                DataTable dtMarket = _dataLoad.GetHigharcyInfoByEmployeeId(EmpInfoId.ToString(), ToRoleTypeId.ToString());

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
            LoadInitialInfo();

           
        }
    }

    private void LoadInitialInfo()
    {


        try
        {
            GetMonthList(ddlmonth);
            GetYearList(ddlYear);
        }

        catch (Exception ex) { }
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
                    if (Session["RoleTypeId"].ToString() == "3")
                    {
                        DataTable dtZone = aDal.Get_DZSMinfoByEmpId(Session["EmpInfoId"].ToString());
                        if (dtZone.Rows.Count > 0)
                        {
                            hfZoneId.Value = dtZone.Rows[0]["RegionId"].ToString();
                            groupname.SelectedValue = dtZone.Rows[0]["GroupId"].ToString();
                            groupname_SelectedIndexChanged(null, null);
                            groupname.Enabled = false;
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

            List<AreaWiseTargetSetupDao> MarketList = new List<AreaWiseTargetSetupDao>();

            for (int i = 0; i < gv_List.Rows.Count; i++)
            {
                HiddenField AreaId = ((HiddenField)gv_List.Rows[i].FindControl("HFAreaId"));
                TextBox txtAmount = ((TextBox)gv_List.Rows[i].FindControl("txtAmount"));

                AreaWiseTargetSetupDao _DAO = new AreaWiseTargetSetupDao();

                _DAO.AreaWTSetupId = 0;

                _DAO.Year = string.IsNullOrEmpty(ddlYear.SelectedValue.Trim()) ? null : ddlYear.SelectedValue.Trim();

                _DAO.Month = string.IsNullOrEmpty(ddlmonth.SelectedItem.Text.Trim()) ? null : ddlmonth.SelectedItem.Text.Trim();

                _DAO.GroupId = string.IsNullOrEmpty(groupname.SelectedValue) ? (int?)null : int.Parse(groupname.SelectedValue);

                _DAO.RegionId = string.IsNullOrEmpty(ddlZone.SelectedValue) ? (int?)null : int.Parse(ddlZone.SelectedValue);

                _DAO.TargetAmount = string.IsNullOrEmpty(amount.Text.Trim()) ? 0 : decimal.Parse(amount.Text);

                _DAO.AreaId = string.IsNullOrEmpty(AreaId.Value) ? 0 : int.Parse(AreaId.Value);

                _DAO.Amount = string.IsNullOrEmpty(txtAmount.Text.Trim()) ? 0 : decimal.Parse(txtAmount.Text);

                MarketList.Add(_DAO);

            }

            ResultInfo Res = areaWise.SaveZoneWiseTarget(MarketList, Session["UserId"].ToString());
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','ZoneWiseTargetSetupView.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);
            }
        }
    }


    protected void Unnamed_Click(object sender, EventArgs e)
    {
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

                    using (DataTable dt = aDal.Get_Forddl_ZoneActive_All_ByGroup(groupname.SelectedValue))
                    {
                        ddlZone.DataSource = dt;
                        ddlZone.DataValueField = "RegionId";
                        ddlZone.DataTextField = "RegionName";
                        ddlZone.DataBind();
                        ddlZone.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                        try
                        {

                            if (Session["RoleTypeId"].ToString() == "3")
                            {

                                ddlZone.SelectedValue = hfZoneId.Value;

                                ddlZone.Enabled = false;
                                btnSearch_Click(null, null);
                            }
                        }
                        catch (Exception ex)
                        {
                            ddlZone.SelectedIndex = 0;

                        }
                    }
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
                       // LTotal.Text = "";
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
               // LTotal.Text = "";
            }

        }

    }


    protected void ddlZone_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        gv_List.DataSource = null;

        gv_List.DataBind();
        if (ddlZone.SelectedValue != "")
        {
            DataTable ds = aDal.GetArea_ByZoneId_All(ddlZone.SelectedValue);
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


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        gv_List.DataSource = null;
        gv_List.DataBind();

        if (Validation())
        {
            GET_DataList();
        }

    }

    private string Parm()
    {
        string param = "";

        if (ddlYear.SelectedValue != "")
        {
            param = param + " AND AWT.Year='" + ddlYear.SelectedValue + "' ";
        }

        if (ddlmonth.SelectedValue != "")
        {
            param = param + " AND AWT.Month='" + ddlmonth.SelectedItem.Text + "' ";
        }

        if (groupname.SelectedValue != "")
        {
            param = param + " AND AWT.GroupId='" + groupname.SelectedValue + "' ";
        }

        if (ddlZone.SelectedValue != "")
        {
            param = param + " AND AWT.RegionId='" + ddlZone.SelectedValue + "' ";
        }

        return param;
    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
        //Response.Redirect("~/PromoAlloc/GroupWisePromoQtyView.aspx");
    }


    private void GET_DataList()
    {
        DataTable aDataTable = areaWise.Get_SaveDataAll(Parm());

        if (aDataTable.Rows.Count > 0)
        {
            target.Visible = true;
            amount.Text = aDataTable.Rows[0]["TargetAmount"].ToString();
            gv_List.DataSource = aDataTable;
            gv_List.DataBind();

            gv_List.FooterRow.Cells[1].Text = "Total";
            gv_List.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
            decimal temValue = 0;
            decimal value = 0;
            for (int k = 0; k < gv_List.Rows.Count; k++)
            {
                TextBox LTotal = (TextBox)gv_List.Rows[k].FindControl("txtAmount");

                string Active = Convert.ToString(gv_List.DataKeys[k][1].ToString());

                LinkButton aButton = (LinkButton)gv_List.Rows[k].FindControl("btnEdit");

                if (Active == "True")
                {
                    aButton.Visible = false;
                }

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
        else
        {
            showMessageBox("Data Not Found");
        }

    }


    private bool UpDateValidation(int id)
    {

        int RowId = id;
        if (amount.Text != "")
        {
            decimal target = 0;
            target = decimal.Parse(amount.Text);
            decimal temValue = 0;
            decimal value = 0;
            for (int k = 0; k < gv_List.Rows.Count; k++)
            {
                TextBox LTotal = (TextBox)gv_List.Rows[k].FindControl("txtAmount");
                if (gv_List.Rows[k].RowIndex == RowId)
                {
                    TextBox txtAmount = (TextBox)gv_List.Rows[k].FindControl("txtAmount");

                    txtAmount.CssClass = "form-control form-control-sm mb-3";
                    if (txtAmount.Text == "")
                    {
                        showMessageBox("You Should Entered Amount");
                        txtAmount.ToolTip = "please fill out this field";
                        txtAmount.CssClass = "form-control form-control-sm mb-3 is-invalid";
                        txtAmount.Focus();
                        return false;
                    }
                }

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
                        // LTotal.Text = "";
                        return false;
                    }
                }
            }
        }

        return true;
    }

        protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            
            if (e.CommandName == "UpdateData")
            {
                if (Session["UserId"] != null)
                {
                    int rowindex = Convert.ToInt32(e.CommandArgument);

                    if(UpDateValidation(rowindex)){


                    int ID = Convert.ToInt32(gv_List.DataKeys[rowindex][0].ToString());

                    TextBox txtAmount = ((TextBox)gv_List.Rows[rowindex].FindControl("txtAmount"));

                    List<AreaWiseTargetSetupDao> alist = new List<AreaWiseTargetSetupDao>();
                    AreaWiseTargetSetupDao aTargetDao = new AreaWiseTargetSetupDao();
                    aTargetDao.Amount = string.IsNullOrEmpty(txtAmount.Text) ? 0 : decimal.Parse(txtAmount.Text);
                    aTargetDao.AreaWTSetupId = ID;
                    alist.Add(aTargetDao);

                    ResultInfo Res = areaWise.SaveZoneWiseTarget(alist, HttpContext.Current.Session["UserId"].ToString());
                    if (Res.isSuccess == true)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','AreaWiseTargetSetupView.aspx');", true);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

                    }
                }

            }

        }

    }
}