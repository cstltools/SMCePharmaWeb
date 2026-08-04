using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.PromoAllocDAL;
using Library.DAL.TargetDAL;
using Library.DAO.PromoAlloc_DAO;
using Library.DAO.Target_DAO;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class PromoAlloc_GroupWisePromoQtyEntry : System.Web.UI.Page
{
    public static GroupWisePromoQtyDAL aTargetDal = new GroupWisePromoQtyDAL();
    public static PromoMITagDAL aTargetDal2 = new PromoMITagDAL();
    private CommonDataLoad _dataLoad = new CommonDataLoad();
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

    [WebMethod(EnableSession = true)]
    public static string LoadStockQty(string id)
    {
        DataTable ds = aTargetDal.LoadCentralWearhouse(id);
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }
    private void LoadInitialInfo()
    {



        try
        {
            using (DataTable dt = aTargetDal2.LoadGroup())
            {
                groupname.DataSource = dt;
                groupname.DataValueField = "PromoGroupId";
                groupname.DataTextField = "PromoGroupName";
                groupname.DataBind();
                groupname.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                groupname.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

        try
        {
            using (DataTable dt = aTargetDal2.LoadProduct())
            {
                ddlProduct.DataSource = dt;
                ddlProduct.DataValueField = "ProductId";
                ddlProduct.DataTextField = "ProductName";
                ddlProduct.DataBind();
                ddlProduct.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlProduct.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
        try
        {
            GetMonthList(ddlmonth);
            GetYearList(ddlYear);
        }

        catch (Exception ex) { }


        //for (int i = 2013; i <= 2020; i++)
        //{
        //    ddlYear.Items.Add(i.ToString());
        //}
        //ddlYear.Items.FindByValue(System.DateTime.Now.Year.ToString()).Selected = true;  //set current year as selected

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


    [WebMethod(EnableSession = true)]
    public static ResultInfo SaveGroupWiseQty(GroupWisePromoQtyDAO aTargetDao)
    {
        ResultInfo aInformation = new ResultInfo();

        string day = "01";
        string month = aTargetDao.Month.ToString();
        string year = aTargetDao.Year.ToString();
        string date = day + "-" + month + "-" + year;
        DateTime maindate = Convert.ToDateTime(date);
        aTargetDao.Date = maindate;
        
        bool status = false;
        if (aTargetDao.GWPromoQtyId > 0)
        {
            aInformation.isSuccess =  aTargetDal.UpdateGroupWiseQty(aTargetDao);
        }
        else
        {
            aInformation.isSuccess = aTargetDal.SaveGroupWiseQty(aTargetDao);
        }

        return aInformation;

    }

    [WebMethod(EnableSession = true)]
    public static string LoadGroupWiseQtyById(string id)
    {
        DataTable ds = aTargetDal.LoadGroupWiseQtyById(id);
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }

    public bool Validation()
    {


        groupname.CssClass = "form-select form-select-sm mb-3 mySelect2";

        if (groupname.SelectedValue == "")
        {
            groupname.ToolTip = "please fill out this field";
            groupname.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            groupname.Focus();
            return false;
        }

        if (gv_List.Rows.Count == 0)
        {
            showMessageBox("Table can not be Empty!");

            return false;
        }


        Int32 count = 0;
        decimal qty = 0;
        for (int i = 0; i < gv_List.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)gv_List.Rows[i].Cells[0].FindControl("chkSelect");
            var qtytext = (TextBox)gv_List.Rows[i].Cells[0].FindControl("txtQty");

            if (chkBoxRows.Checked)
            {
                qty += string.IsNullOrEmpty(qtytext.Text) ? 0 : Convert.ToDecimal(qtytext.Text);
                count++;
            }

            if (count > 0)
            {
                break;
            }
        }

        if (count == 0)
        {
            showMessageBox("Please Select at least one employee !!!");
            return false;
        }

        if (Convert.ToDecimal(stockTextBox.Text)<qty)
        {
            showMessageBox("Assigned stock is greater then main stock  !!!");
            return false;
        }

        for (int i = 0; i < gv_List.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)gv_List.Rows[i].Cells[0].FindControl("chkSelect");
            TextBox txtQty = ((TextBox)gv_List.Rows[i].Cells[1].FindControl("txtQty"));
            txtQty.CssClass = "form-control form-control-sm";

            if (chkBoxRows.Checked)
            {
                if (txtQty.Text == "")
                {
                    txtQty.ToolTip = "please fill out this field";
                    txtQty.CssClass = "form-control form-control-sm is-invalid";
                    txtQty.Focus();
                    return false;
                }


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

            List<GroupWisePromoQtyDAO> MarketList = new List<GroupWisePromoQtyDAO>();


            for (int i = 0; i < gv_List.Rows.Count; i++)
            {
                HiddenField hfMIOId = ((HiddenField)gv_List.Rows[i].Cells[1].FindControl("hfMIOId"));
                HiddenField hfEmpInfoId = ((HiddenField)gv_List.Rows[i].Cells[1].FindControl("hfEmpInfoId"));
                HiddenField hfTerritoryId = ((HiddenField)gv_List.Rows[i].Cells[1].FindControl("hfTerritoryId"));
                TextBox txtQty = ((TextBox)gv_List.Rows[i].Cells[1].FindControl("txtQty"));
                CheckBox chkSelect = ((CheckBox)gv_List.Rows[i].Cells[1].FindControl("chkSelect"));

                if (chkSelect.Checked)
                {
                    GroupWisePromoQtyDAO _DAO = new GroupWisePromoQtyDAO();

                    _DAO.MIOId = string.IsNullOrEmpty(hfMIOId.Value) ? (int?)null : int.Parse(hfMIOId.Value);

                    _DAO.EmpInfoId = string.IsNullOrEmpty(hfEmpInfoId.Value) ? (int?)null : int.Parse(hfEmpInfoId.Value);

                    _DAO.TerritoryId = string.IsNullOrEmpty(hfTerritoryId.Value) ? (int?)null : int.Parse(hfTerritoryId.Value);

                    _DAO.ProductId = ddlProduct.SelectedIndex > 0 ? int.Parse(ddlProduct.SelectedValue) : (int?)null;

                    _DAO.PromoGroupId = groupname.SelectedIndex > 0 ? int.Parse(groupname.SelectedValue) : (int?)null;

                    _DAO.Month = ddlmonth.SelectedItem.Text  ;
                    _DAO.Year = ddlYear.SelectedIndex > 0 ? int.Parse(ddlYear.SelectedValue) : (int?)null;
                    _DAO.Qty = string.IsNullOrEmpty(txtQty.Text) ? (decimal?)null : Decimal.Parse(txtQty.Text);



                    MarketList.Add(_DAO);
                }



            }
           



            ResultInfo Res = aTargetDal.SaveDetail( MarketList, Session["UserId"].ToString());
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','GroupWisePromoQtyView.aspx');", true);

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
        if (groupname.SelectedValue != "")
        {
            DataTable ds = aTargetDal2.LoadMIOByGroupId(groupname.SelectedValue);

            gv_List.DataSource = ds;
            gv_List.DataBind();
        }
    }

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)gv_List.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < gv_List.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)gv_List.Rows[i].Cells[0].FindControl("chkSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;
            CheckCustInOrder(i);

        }
    }
    protected void chkSelect_CheckedChanged(object sender, EventArgs e)
    {

        int rowIndex = ((GridViewRow)(((CheckBox)sender).Parent.Parent)).RowIndex;
        try
        {
            CheckCustInOrder(rowIndex);

        }
        catch (Exception ex)
        {

        }
    }

    private void CheckCustInOrder(int rowIndex)
    {

        try
        {

            CheckBox chkSelect = (CheckBox)gv_List.Rows[rowIndex].Cells[1].FindControl("chkSelect");
            HiddenField hfEmpInfoId = (HiddenField)gv_List.Rows[rowIndex].Cells[1].FindControl("hfEmpInfoId");

            if (chkSelect.Checked)
            {
                //DataTable dt = _dataLoad.GetMIOTagValidationCheck(groupname.SelectedValue, hfEmpInfoId.Value);

                //if (dt.Rows.Count == 0)
                //{

                //}
                //else
                //{
                //    chkSelect.Checked = false;
                //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Declared in Promo Group!" + "','Faild');", true);

                //}
            }




        }
        catch (Exception ex)
        {

        }
    }

    protected void amount_TextChanged(object sender, EventArgs e)
    {
        NewMethod();
    }

    private void NewMethod()
    {
        if (chkQty.Checked) {
            for (int i = 0; i < gv_List.Rows.Count; i++)
            {
                var txtQty = (TextBox)gv_List.Rows[i].Cells[0].FindControl("txtQty");
                txtQty.Text = amount.Text;

            }
        }
        else
        {
            for (int i = 0; i < gv_List.Rows.Count; i++)
            {
                var txtQty = (TextBox)gv_List.Rows[i].Cells[0].FindControl("txtQty");
                txtQty.Text = "";

            }
        }
        
    }

    protected void chkQty_CheckedChanged(object sender, EventArgs e)
    {
        NewMethod();

    }

    protected void ddlProduct_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        GroupWisePromoQtyDAL aDal=new GroupWisePromoQtyDAL();
        DataTable dtdata = aDal.LoadCentralWearhouse(ddlProduct.SelectedValue);
        if (dtdata.Rows.Count>0)
        {
            stockTextBox.Text = dtdata.Rows[0]["Qty"].ToString();
        }
    }
}