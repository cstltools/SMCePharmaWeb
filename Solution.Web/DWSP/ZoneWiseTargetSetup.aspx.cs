using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DataManager;
using Library.DAL.DWSP_DAL;
using Library.DAL.PromoAllocDAL;
using Library.DAO.DWSP_DAO;
using Library.DAO.PromoAlloc_DAO;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class DWSP_ZoneWiseTargetSetup : System.Web.UI.Page
{
    public static GroupWisePromoQtyDAL aTargetDal = new GroupWisePromoQtyDAL();
    public static PromoMITagDAL aTargetDal2 = new PromoMITagDAL();
    private CommonDataLoad _dataLoad = new CommonDataLoad();

    private NationalTargetSetupDal aSetupDal = new NationalTargetSetupDal();

    private ZoneWiseTargetSetupDal aTargetSetupDal = new ZoneWiseTargetSetupDal();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadInitialInfo();

            if (!string.IsNullOrEmpty(Request.QueryString["MID"]))
            {
                btnUpdate.Visible = true;

                id_mastetID.Value = Request.QueryString["MID"];
                //GetOneRecord(id_mastetID.Value);
            }
            else
            {
                btnSave.Visible = true;
            }
        }
    }

    private void LoadInitialInfo()
    {



        try
        {
            using (DataTable dt = aSetupDal.Get_Group_All())
            {
                groupname.DataSource = dt;
                groupname.DataValueField = "GroupId";
                groupname.DataTextField = "GroupName";
                groupname.DataBind();
                groupname.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                groupname.SelectedIndex = 0;
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
        try
        {
            GetMonthList(ddlmonth);
            GetYearList(ddlYear);
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

        lblNationalTargetAmount.CssClass = "form-control form-control-sm mb-3 clsDecimal";

        if (lblNationalTargetAmount.Text == "")
        {
            lblNationalTargetAmount.ToolTip = "please fill out this field";
            lblNationalTargetAmount.CssClass = "form-control form-control-sm mb-3 clsDecimal is-invalid";
            lblNationalTargetAmount.Focus();
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

            List<ZoneWiseTargetDao> MarketList = new List<ZoneWiseTargetDao>();

            for (int i = 0; i < gv_List.Rows.Count; i++)
            {
                HiddenField ZoneId = ((HiddenField)gv_List.Rows[i].FindControl("HFZoneId"));
                TextBox txtAmount = ((TextBox)gv_List.Rows[i].FindControl("txtAmount"));
                
                    ZoneWiseTargetDao _DAO = new ZoneWiseTargetDao();

                    _DAO.ZoneWTSetupId = 0;

                    _DAO.Year = string.IsNullOrEmpty(ddlYear.SelectedValue.Trim()) ? null : ddlYear.SelectedValue.Trim();

                    _DAO.Month = string.IsNullOrEmpty(ddlmonth.SelectedItem.Text.Trim()) ? null : ddlmonth.SelectedItem.Text.Trim();

                    _DAO.GroupId = string.IsNullOrEmpty(groupname.SelectedValue) ? (int?)null : int.Parse(groupname.SelectedValue);

                    _DAO.TargetAmount = string.IsNullOrEmpty(lblNationalTargetAmount.Text.Trim()) ? 0 : decimal.Parse(lblNationalTargetAmount.Text);

                    _DAO.RegionId = string.IsNullOrEmpty(ZoneId.Value) ? 0 : int.Parse(ZoneId.Value);

                    _DAO.Amount = string.IsNullOrEmpty(txtAmount.Text.Trim()) ? 0 : decimal.Parse(txtAmount.Text);

                    MarketList.Add(_DAO);
                    
            }

            ResultInfo Res = aTargetSetupDal.SaveZoneWiseTarget(MarketList, Session["UserId"].ToString());
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
        gv_List.DataSource = null;
        gv_List.DataBind();
        lblNationalTargetAmount.Text = "";
        if (groupname.SelectedValue != "")
        {
            DataTable ds = aTargetSetupDal.Get_ZoneActive_All_ByGroup(groupname.SelectedValue);
            gv_List.DataSource = ds;
            gv_List.DataBind();

            NewMethod();

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

    private void NewMethod()
    {
        DataTable dtTargetAmount = aTargetSetupDal.Get_NationalTargetAmount_All_ByGroup(ddlmonth.SelectedItem.Text, ddlYear.SelectedValue, groupname.SelectedValue);

        if (dtTargetAmount.Rows.Count > 0)
        {
            lblNationalTargetAmount.Text = dtTargetAmount.Rows[0]["Amount"].ToString();
        }
        else
        {
            lblNationalTargetAmount.Text = "";
        }
    }



    protected void txtAmount_OnTextChanged(object sender, EventArgs e)
    {

        if (lblNationalTargetAmount.Text != "")
        {
            decimal target = 0;
            target = decimal.Parse(lblNationalTargetAmount.Text);
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
                        gv_List.FooterRow.Cells[2].Text = "";
                    }

                }

            } 
        }
        else
        {
            showMessageBox("Please Select Target Amount");
            lblNationalTargetAmount.CssClass = "form-control form-control-sm mb-3 clsDecimal";

            if (lblNationalTargetAmount.Text == "")
            {
                lblNationalTargetAmount.ToolTip = "please fill out this field";
                lblNationalTargetAmount.CssClass = "form-control form-control-sm mb-3 clsDecimal is-invalid";
                lblNationalTargetAmount.Focus();
            }

            for (int k = 0; k < gv_List.Rows.Count; k++)
            {
                TextBox LTotal = (TextBox)gv_List.Rows[k].FindControl("txtAmount");
                LTotal.Text = "";
                gv_List.FooterRow.Cells[2].Text = "";

            }

        }

    }

    protected void ddlmonth_SelectedIndexChanged(object sender, EventArgs e)
    {
        NewMethod();
    }
}