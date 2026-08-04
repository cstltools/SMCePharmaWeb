using Library.DAL.MasterSetup_DAL;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SInventory_UI_TargetExcelUploadEdit : System.Web.UI.Page
{

    private static BonusCampaignNewDAL _BonusCampaignNewDAL = new BonusCampaignNewDAL();
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    static CommonDataLoad _dataLoad = new CommonDataLoad();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            try
            {
                using (DataTable dt = _seedRepo.GetFiscalYearList())
                {
                    ddlFinancialYear.DataSource = dt;

                    ddlFinancialYear.DataValueField = "FinancialYearId";
                    ddlFinancialYear.DataTextField = "FinancialYearDesc";
                    ddlFinancialYear.DataBind();
                    ddlFinancialYear.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlFinancialYear.SelectedIndex = 1;
                }


            }
            catch (Exception ex) { }
            try
            {
                GetMonthList(ddlMonth);
                GetYearList(ddlYear);
            }

            catch (Exception ex) { }



            try
            {
                using (DataTable dt = _dataLoad.GetEmployeeList_All())
                {
                    ddlEmployeeName.DataSource = dt;
                    ddlEmployeeName.DataValueField = "EmpInfoId";
                    ddlEmployeeName.DataTextField = "EmpName";
                    ddlEmployeeName.DataBind();
                    ddlEmployeeName.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlEmployeeName.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }



            if (!string.IsNullOrEmpty(Request.QueryString["MID"]))
            {
            

                id_mastetID.Value = Request.QueryString["MID"];
                GetOneRecord(id_mastetID.Value);
            }

        }
    }
    private void GetOneRecord(string Id)
    {
        try
        {
            using (DataTable dt = _BonusCampaignNewDAL.GetTargetEditById(Id))
            {
                ddlFinancialYear.Text = dt.Rows[0]["FYId"].ToString();
                ddlYear.Text = dt.Rows[0]["YearValue"].ToString();
                ddlMonth.Text = dt.Rows[0]["MonthName"].ToString();
                ddlEmployeeName.Text = dt.Rows[0]["EmpId"].ToString();
                txtTargetValue.Text = dt.Rows[0]["Value"].ToString();
               


            }
        }
        catch (Exception ex)
        {

        }
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

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Validation())
        {
            TargetEditDAO aMaster = new TargetEditDAO();

            aMaster.SL = id_mastetID.Value == "" ? 0 : Convert.ToInt32(id_mastetID.Value);

          
            aMaster.FYId = ddlFinancialYear.SelectedIndex > 0 ? int.Parse(ddlFinancialYear.SelectedValue) : (int?)null;
            aMaster.YearValue = ddlYear.SelectedIndex > 0 ? int.Parse(ddlYear.SelectedValue) : (int?)null;
            aMaster.MonthName = ddlMonth.SelectedIndex > 0 ? int.Parse(ddlMonth.SelectedValue) : (int?)null;
            aMaster.EmpId = ddlEmployeeName.SelectedIndex > 0 ? int.Parse(ddlEmployeeName.SelectedValue) : (int?)null;

            aMaster.Value = string.IsNullOrEmpty(txtTargetValue.Text) ? (decimal?)null : decimal.Parse(txtTargetValue.Text); 

            ResultInfo Res = _BonusCampaignNewDAL.SaveTargetEdit(aMaster,  Session["LoginName"].ToString());
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','TargetExcelUploadList.aspx');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }
        }


    }


    public bool Validation()
    {



        ddlFinancialYear.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlYear.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlMonth.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlEmployeeName.CssClass = "form-select form-select-sm mb-3 mySelect2";


        txtTargetValue.CssClass = "form-control form-control-sm";
    


        if (ddlFinancialYear.Text == "")
        {
            ddlFinancialYear.ToolTip = "please fill out this field";
            ddlFinancialYear.CssClass = "form-control form-control-sm is-invalid";
            ddlFinancialYear.Focus();
            return false;
        }


        if (ddlYear.SelectedValue == "")
        {
            ddlYear.ToolTip = "please fill out this field";
            ddlYear.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlYear.Focus();
            return false;
        }


        if (ddlMonth.SelectedValue == "")
        {
            ddlMonth.ToolTip = "please fill out this field";
            ddlMonth.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlMonth.Focus();
            return false;
        }


        if (ddlEmployeeName.SelectedValue == "")
        {
            ddlEmployeeName.ToolTip = "please fill out this field";
            ddlEmployeeName.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlEmployeeName.Focus();
            return false;
        }


        if (txtTargetValue.Text == "")
        {
            txtTargetValue.ToolTip = "please fill out this field";
            txtTargetValue.CssClass = "form-control form-control-sm is-invalid";
            txtTargetValue.Focus();
            return false;
        }

        return true;
    }
    }