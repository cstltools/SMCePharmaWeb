using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DWSP_DAL;
using Library.DAO.DWSP_DAO;
using Library.DAO.PromoAlloc_DAO;
using SalesSolution.Web.Models;

public partial class DWSP_NationalTargetSetup : System.Web.UI.Page
{

    private NationalTargetSetupDal aSetupDal = new NationalTargetSetupDal();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadInitialInfo();

            if (!string.IsNullOrEmpty(Request.QueryString["MID"]))
            {
                btnUpdate.Visible = true;

                id_mastetID.Value = Request.QueryString["MID"];
               
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
            GetMonthList(ddlmonth);
            GetYearList(ddlYear);
        }
        catch (Exception ex)
        {

        }

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

    public bool Validation()
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

        txtAmount.CssClass = "form-control form-control-sm mb-3";

        if (txtAmount.Text.Trim() == "")
        {
            txtAmount.ToolTip = "please fill out this field";
            txtAmount.CssClass = "form-control form-control-sm mb-3 is-invalid";
            txtAmount.Focus();
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



    private NationalTargetDao DataPrepare()
    {
        NationalTargetDao aDao = new NationalTargetDao();

        if (id_mastetID.Value == "")
        {
            aDao.NatargetSpId = 0;
        }
        else
        {
            aDao.NatargetSpId = int.Parse(id_mastetID.Value);
        }

        aDao.Year = ddlYear.SelectedItem.Text.Trim();
        aDao.Month = ddlmonth.SelectedItem.Text.Trim();
        aDao.GroupId = int.Parse(groupname.SelectedValue);
        aDao.Amount = decimal.Parse(txtAmount.Text.Trim());

        return aDao;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Session["UserId"] != null)
        {
            if (Validation())
            {
                ResultInfo Res = aSetupDal.SaveNationalTargetSetup(DataPrepare(), Session["UserId"].ToString());
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
        else
        {
            
        }

    }


    protected void Unnamed_Click(object sender, EventArgs e)
    {

        Response.Redirect("NationalTargetSetup.aspx");

    }
}