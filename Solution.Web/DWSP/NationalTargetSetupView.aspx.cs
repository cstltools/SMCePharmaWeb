using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DWSP_DAL;
using Library.DAL.MasterSetup_DAL;
using Library.DAL.PromoAllocDAL;
using Library.DAO.DWSP_DAO;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class DWSP_NationalTargetSetupView : System.Web.UI.Page
{

    private NationalTargetSetupDal aSetupDal = new NationalTargetSetupDal();

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
        Response.Redirect("~/PromoAlloc/CustomerEntry.aspx");
    }

    private void GET_DataList()
    {
        DataTable aDataTable = aSetupDal.Get_GroupTarget_All(Parm());
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            bool Active =  Convert.ToBoolean(loadGridView.DataKeys[i][1].ToString());

            LinkButton aButton = (LinkButton)loadGridView.Rows[i].FindControl("LinkButton1");

            if (!Active)
            {
                aButton.Visible = false;
            }
        }

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

                int ID = Convert.ToInt32(loadGridView.DataKeys[rowindex][0].ToString());

                TextBox txtAmount = ((TextBox)loadGridView.Rows[rowindex].FindControl("txtAmount"));

                NationalTargetDao aTargetDao = new NationalTargetDao();

                aTargetDao.Amount = string.IsNullOrEmpty(txtAmount.Text) ? 0 : decimal.Parse(txtAmount.Text);

                aTargetDao.NatargetSpId = ID;

                ResultInfo Res = aSetupDal.SaveNationalTargetSetup(aTargetDao, HttpContext.Current.Session["UserId"].ToString());
                if (Res.isSuccess == true)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','NationalTargetSetupView.aspx');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

                }
            }

        }

    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        
        GET_DataList();
    }

    private string Parm()
    {
        string param = "";

        if (ddlYear.SelectedValue != "")
        {
            param = param + " AND NTG.Year='" + ddlYear.SelectedValue + "' ";
        }

        if (ddlmonth.SelectedValue != "")
        {
            param = param + " AND NTG.Month='" + ddlmonth.SelectedItem.Text + "' ";
        }

        if (groupname.SelectedValue != "")
        {
            param = param + " AND NTG.GroupId='" + groupname.SelectedValue + "' ";
        }

        return param;
    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/PromoAlloc/GroupWisePromoQtyView.aspx");
    }
}