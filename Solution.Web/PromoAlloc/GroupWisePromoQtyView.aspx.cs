using Library.DAL.MasterSetup_DAL;
using Library.DAL.PromoAllocDAL;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PromoAlloc_GroupWisePromoQtyView : System.Web.UI.Page
{


    public static GroupWisePromoQtyDAL aTargetDal = new GroupWisePromoQtyDAL();
    public static PromoMITagDAL aTargetDal2 = new PromoMITagDAL();
    private CommonDataLoad _dataLoad = new CommonDataLoad();
    private static SeedDataDAL _seedRepo = new SeedDataDAL();

    private static CustomerInfoDAL _DAL = new CustomerInfoDAL(); 
    protected void Page_Load(object sender, EventArgs e)
    {
       if (!IsPostBack)
        {
            LoadInitialInfo();

            btnSearch_Click(null, null);
        }
    }

    private void LoadInitialInfo()
    {

        try
        {
            using (DataTable dt = _dataLoad.GetMIOInfo_Rpt())
            {
                ddlMIO.DataSource = dt;
                ddlMIO.DataValueField = "ValueId";
                ddlMIO.DataTextField = "TextName";
                ddlMIO.DataBind();
                ddlMIO.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlMIO.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }

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
        DataTable aDataTable = aTargetDal.GetList(parm);
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
         
        //if (Session["RoleTypeId"].ToString()== "5")
        //{
        //    loadGridView.Columns[loadGridView.Columns.Count - 1].Visible = true;
        //}
        //else
        //{
        //    loadGridView.Columns[loadGridView.Columns.Count - 1].Visible = false;
        //}
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string unitPriceId = loadGridView.DataKeys[rowindex][0].ToString();
            TextBox txtQty = ((TextBox)loadGridView.Rows[rowindex].Cells[1].FindControl("txtQty"));

            LinkButton lbtUpDate = ((LinkButton)loadGridView.Rows[rowindex].Cells[1].FindControl("lbtUpDate"));

            txtQty.ReadOnly = false;
            lbtUpDate.Visible = true;
            //Response.Redirect("GroupWisePromoQtyEntry.aspx?MID=" + unitPriceId);
        }
        if (e.CommandName == "UpdateData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string unitPriceId = loadGridView.DataKeys[rowindex][0].ToString();
            TextBox txtQty = ((TextBox)loadGridView.Rows[rowindex].Cells[1].FindControl("txtQty"));
             
         
          int?  CountNo = string.IsNullOrEmpty(txtQty.Text) ? (int?)null : int.Parse(txtQty.Text);

         int   UpdateBy = Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString());
        DateTime    UpdateDate = DateTime.Now;
            ResultInfo Res = aTargetDal.Update___Info(unitPriceId, CountNo, UpdateBy, UpdateDate);
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','GroupWisePromoQtyView.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }

            //Response.Redirect("GroupWisePromoQtyEntry.aspx?MID=" + unitPriceId);
        }

    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadData(Parm());
    }

    private string Parm()
    {
        string param = "";

        if (ddlYear.SelectedValue != "")
        {
            param = param + " AND mas.Year='" + ddlYear.SelectedValue + "' ";
        }

        if (ddlmonth.SelectedValue != "")
        {
            param = param + " AND mas.Month='" + ddlmonth.SelectedItem.Text + "' ";
        }

        if (groupname.SelectedValue != "")
        {
            param = param + " AND mas.PromoGroupId='" + groupname.SelectedValue + "' ";
        }


        if (ddlMIO.SelectedValue != "")
        {
            param = param + " AND mas.EmpInfoId='" + ddlMIO.SelectedValue + "' ";
        }


        return param;
    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("GroupWisePromoQtyView.aspx");
    }
}