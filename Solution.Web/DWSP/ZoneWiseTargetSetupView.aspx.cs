using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DWSP_DAL;
using Library.DAL.PromoAllocDAL;
using Library.DAO.DWSP_DAO;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class DWSP_ZoneWiseTargetSetupView : System.Web.UI.Page
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

                _DAO.TargetAmount = string.IsNullOrEmpty(amount.Text.Trim()) ? 0 : decimal.Parse(amount.Text);

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
        //gv_List.DataSource = null;
        //gv_List.DataBind();
        //if (groupname.SelectedValue != "")
        //{
        //    DataTable ds = aTargetSetupDal.Get_ZoneActive_All_ByGroup(groupname.SelectedValue);
        //    gv_List.DataSource = ds;
        //    gv_List.DataBind();


        //    gv_List.FooterRow.Cells[1].Text = "Total";
        //    gv_List.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
        //    decimal temValue = 0;
        //    decimal value = 0;
        //    for (int k = 0; k < gv_List.Rows.Count; k++)
        //    {
        //        TextBox LTotal = (TextBox)gv_List.Rows[k].FindControl("txtAmount");

        //        if (LTotal.Text != "")
        //        {
        //            value = decimal.Parse(LTotal.Text);
        //            temValue += value;
        //            gv_List.FooterRow.Cells[2].Text = temValue.ToString();
        //            gv_List.FooterRow.Cells[2].Font.Bold = true;
        //            gv_List.FooterRow.Cells[2].HorizontalAlign = HorizontalAlign.Right;
        //            gv_List.FooterRow.BackColor = System.Drawing.Color.Beige;

        //        }

        //    }

        //}
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
                      //  LTotal.Text = "";
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



    protected void btnSearch_Click(object sender, EventArgs e)
    {

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
            param = param + " AND ZWT.Year='" + ddlYear.SelectedValue + "' ";
        }

        if (ddlmonth.SelectedValue != "")
        {
            param = param + " AND ZWT.Month='" + ddlmonth.SelectedItem.Text + "' ";
        }

        if (groupname.SelectedValue != "")
        {
            param = param + " AND ZWT.GroupId='" + groupname.SelectedValue + "' ";
        }

        return param;
    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/PromoAlloc/GroupWisePromoQtyView.aspx");
    }


    private void GET_DataList()
    {
        gv_List.DataSource = null;
        gv_List.DataBind();

        DataTable aDataTable = aTargetSetupDal.Get_SaveDataAll(Parm());

        Target.Visible = true;
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

            if (Active =="True")
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
                TextBox LTotal = (TextBox) gv_List.Rows[k].FindControl("txtAmount");
                if (gv_List.Rows[k].RowIndex == RowId)
                {

                    TextBox txtQty = ((TextBox) gv_List.Rows[k].FindControl("txtAmount"));
                    txtQty.CssClass = "form-control form-control-sm mb-3";
                    if (txtQty.Text.Trim() == "")
                    {

                        //   showMessageBox("You Should Entered Amount");

                        txtQty.ToolTip = "please fill out this field";
                        txtQty.CssClass = "form-control form-control-sm mb-3 is-invalid";
                        txtQty.Focus();

                        return false;
                    }

                }

                if (LTotal.Text != "")
                {
                    value = decimal.Parse(LTotal.Text);
                    temValue += value;

                    if (temValue <= target)
                    {

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
        //if (e.CommandName == "EditData")
        //{
        //    int rowindex = Convert.ToInt32(e.CommandArgument);
        //    string unitPriceId = loadGridView.DataKeys[rowindex][0].ToString();
        //    TextBox txtQty = ((TextBox)loadGridView.Rows[rowindex].Cells[1].FindControl("txtQty"));

        //    LinkButton lbtUpDate = ((LinkButton)loadGridView.Rows[rowindex].Cells[1].FindControl("lbtUpDate"));

        //    txtQty.ReadOnly = false;
        //    lbtUpDate.Visible = true;
        //    //Response.Redirect("GroupWisePromoQtyEntry.aspx?MID=" + unitPriceId);
        //}
        if (e.CommandName == "UpdateData")
        {
            if (Session["UserId"] != null)
            {

                int rowindex = Convert.ToInt32(e.CommandArgument);

                if (UpDateValidation(rowindex))
                {

                    int ID = Convert.ToInt32(gv_List.DataKeys[rowindex][0].ToString());

                    TextBox txtAmount = ((TextBox)gv_List.Rows[rowindex].FindControl("txtAmount"));

                    List<ZoneWiseTargetDao> alList = new List<ZoneWiseTargetDao>();

                    ZoneWiseTargetDao aTargetDao = new ZoneWiseTargetDao();
                    aTargetDao.Amount = string.IsNullOrEmpty(txtAmount.Text) ? 0 : decimal.Parse(txtAmount.Text);
                    aTargetDao.ZoneWTSetupId = ID;
                    alList.Add(aTargetDao);

                    ResultInfo Res = aTargetSetupDal.SaveZoneWiseTarget(alList, HttpContext.Current.Session["UserId"].ToString());
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

        }

    }
}