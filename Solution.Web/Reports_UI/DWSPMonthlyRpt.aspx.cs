using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Windows.Media;
using Library.DAL.DoctorModule_DAL;
using Library.DAL.DWSP_DAL;
using Library.DAL.MasterSetup_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;

public partial class Reports_UI_DWSPMonthlyRpt : System.Web.UI.Page
{
    static SeedDataDAL _seedRepo = new SeedDataDAL();
    static Setup2DAL _setupDAL = new Setup2DAL();
    static SetupDAL _setupDAL2 = new SetupDAL();
    private static CmnCrystaltoView _DAL = new CmnCrystaltoView();
    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = "";

    string areaId = "";
    string masArea = "";
    string strRole = "";
    static CommonDataLoad _dataLoad = new CommonDataLoad();
    private CommonDal aDal = new CommonDal();
    private DropDownList F_GroupSelect, F_ZoneSelect, F_AreaSelect, F_TeritorySelect, F_SubTeritory, F_MarketSelect;
    protected void Page_Load(object sender, EventArgs e)
    {

        try
        {
            RoleTypeName = Session["RoleTypeName"].ToString();
            EmpInfoId = Session["EmpInfoId"].ToString();
            ToRoleTypeId = Session["RoleTypeId"].ToString();

        }
        catch { }
        F_GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        F_ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        F_AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        F_TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        F_SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        F_MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;
        if (!IsPostBack)
        {
            
            LoadInitialInfo();

            
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
            using (DataTable dt = _seedRepo.GetApprovalStatusList())
            {
                ddlApprovalStatus.DataSource = dt;
                ddlApprovalStatus.DataValueField = "SoftwareUseId";
                ddlApprovalStatus.DataTextField = "WebShow";
                ddlApprovalStatus.DataBind();
                ddlApprovalStatus.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlApprovalStatus.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }



        try
        {
            using (DataTable dt = _dataLoad.GetEmployeeList_All())
            {
                EmployeeIdSelect.DataSource = dt;
                EmployeeIdSelect.DataValueField = "EmpInfoId";
                EmployeeIdSelect.DataTextField = "EmpName";
                EmployeeIdSelect.DataBind();
                EmployeeIdSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                EmployeeIdSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

       


    }
        private void LoadData()
    {

        Stopwatch stopwatch = new Stopwatch(); // Create a Stopwatch instance
        stopwatch.Start(); // Start measuring time


        loadGridView.DataSource = null;
        loadGridView.DataBind();
        DataTable aDataTable = new DataTable();

        string aPP = "";

        if(ddlApprovalStatus.SelectedValue=="")
        {
            aPP = "Select";
        }
        else
        {
            aPP =ddlApprovalStatus.SelectedValue;
        }


        

        if (RoleTypeName == "DZSM")
        {
            if (F_ZoneSelect.SelectedValue != "") { 
            aDataTable = _DAL.GetDWSPMonthlyList_Mew(Convert.ToInt32(ddlmonth.SelectedValue), ddlmonth.SelectedItem.Text, ddlYear.SelectedValue, aPP, F_ZoneSelect.SelectedValue, F_AreaSelect.SelectedValue, F_TeritorySelect.SelectedValue);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + " Please Select Zone!" + "','Faild');", true);
            }
        }
        else
        {
            aDataTable = _DAL.GetDWSPMonthlyList_Mew(Convert.ToInt32(ddlmonth.SelectedValue), ddlmonth.SelectedItem.Text, ddlYear.SelectedValue, aPP, F_ZoneSelect.SelectedValue, F_AreaSelect.SelectedValue, F_TeritorySelect.SelectedValue);
        }

         

        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();

        if (loadGridView.Rows.Count > 0)
{

            try
            {
                //decimal a1_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("1_Gen") == null ? 0 : row.Field<decimal>("1_Gen"));
                //decimal a1_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("1_Cam") == null ? 0 : row.Field<decimal>("1_Cam"));
                //decimal a1_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("1_FCB") == null ? 0 : row.Field<decimal>("1_FCB"));
                //decimal a1_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("1_Total") == null ? 0 : row.Field<decimal>("1_Total"));


                //decimal a2_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("2_Gen") == null ? 0 : row.Field<decimal>("2_Gen"));
                //decimal a2_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("2_Cam") == null ? 0 : row.Field<decimal>("2_Cam"));
                //decimal a2_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("2_FCB") == null ? 0 : row.Field<decimal>("2_FCB"));
                //decimal a2_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("2_Total") == null ? 0 : row.Field<decimal>("2_Total"));


                //decimal a3_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("3_Gen") == null ? 0 : row.Field<decimal>("3_Gen"));
                //decimal a3_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("3_Cam") == null ? 0 : row.Field<decimal>("3_Cam"));
                //decimal a3_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("3_FCB") == null ? 0 : row.Field<decimal>("3_FCB"));
                //decimal a3_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("3_Total") == null ? 0 : row.Field<decimal>("3_Total"));

                //decimal a4_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("4_Gen") == null ? 0 : row.Field<decimal>("4_Gen"));
                //decimal a4_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("4_Cam") == null ? 0 : row.Field<decimal>("4_Cam"));
                //decimal a4_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("4_FCB") == null ? 0 : row.Field<decimal>("4_FCB"));
                //decimal a4_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("4_Total") == null ? 0 : row.Field<decimal>("4_Total"));

                //decimal a5_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("5_Gen") == null ? 0 : row.Field<decimal>("5_Gen"));
                //decimal a5_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("5_Cam") == null ? 0 : row.Field<decimal>("5_Cam"));
                //decimal a5_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("5_FCB") == null ? 0 : row.Field<decimal>("5_FCB"));
                //decimal a5_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("5_Total") == null ? 0 : row.Field<decimal>("5_Total"));

                //decimal a6_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("6_Gen") == null ? 0 : row.Field<decimal>("6_Gen"));
                //decimal a6_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("6_Cam") == null ? 0 : row.Field<decimal>("6_Cam"));
                //decimal a6_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("6_FCB") == null ? 0 : row.Field<decimal>("6_FCB"));
                //decimal a6_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("6_Total") == null ? 0 : row.Field<decimal>("6_Total"));

                //decimal a7_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("7_Gen") == null ? 0 : row.Field<decimal>("7_Gen"));
                //decimal a7_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("7_Cam") == null ? 0 : row.Field<decimal>("7_Cam"));
                //decimal a7_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("7_FCB") == null ? 0 : row.Field<decimal>("7_FCB"));
                //decimal a7_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("7_Total") == null ? 0 : row.Field<decimal>("7_Total"));

                //decimal a8_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("8_Gen") == null ? 0 : row.Field<decimal>("8_Gen"));
                //decimal a8_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("8_Cam") == null ? 0 : row.Field<decimal>("8_Cam"));
                //decimal a8_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("8_FCB") == null ? 0 : row.Field<decimal>("8_FCB"));
                //decimal a8_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("8_Total") == null ? 0 : row.Field<decimal>("8_Total"));

                //decimal a9_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("9_Gen") == null ? 0 : row.Field<decimal>("9_Gen"));
                //decimal a9_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("9_Cam") == null ? 0 : row.Field<decimal>("9_Cam"));
                //decimal a9_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("9_FCB") == null ? 0 : row.Field<decimal>("9_FCB"));
                //decimal a9_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("9_Total") == null ? 0 : row.Field<decimal>("9_Total"));

                //decimal a10_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("10_Gen") == null ? 0 : row.Field<decimal>("10_Gen"));
                //decimal a10_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("10_Cam") == null ? 0 : row.Field<decimal>("10_Cam"));
                //decimal a10_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("10_FCB") == null ? 0 : row.Field<decimal>("10_FCB"));
                //decimal a10_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("10_Total") == null ? 0 : row.Field<decimal>("10_Total"));


                //decimal a11_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("11_Gen") == null ? 0 : row.Field<decimal>("11_Gen"));
                //decimal a11_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("11_Cam") == null ? 0 : row.Field<decimal>("11_Cam"));
                //decimal a11_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("11_FCB") == null ? 0 : row.Field<decimal>("11_FCB"));
                //decimal a11_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("11_Total") == null ? 0 : row.Field<decimal>("11_Total"));


                //decimal a12_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("12_Gen") == null ? 0 : row.Field<decimal>("12_Gen"));
                //decimal a12_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("12_Cam") == null ? 0 : row.Field<decimal>("12_Cam"));
                //decimal a12_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("12_FCB") == null ? 0 : row.Field<decimal>("12_FCB"));
                //decimal a12_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("12_Total") == null ? 0 : row.Field<decimal>("12_Total"));


                //decimal a13_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("13_Gen") == null ? 0 : row.Field<decimal>("13_Gen"));
                //decimal a13_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("13_Cam") == null ? 0 : row.Field<decimal>("13_Cam"));
                //decimal a13_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("13_FCB") == null ? 0 : row.Field<decimal>("13_FCB"));
                //decimal a13_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("13_Total") == null ? 0 : row.Field<decimal>("13_Total"));


                //decimal a14_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("14_Gen") == null ? 0 : row.Field<decimal>("14_Gen"));
                //decimal a14_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("14_Cam") == null ? 0 : row.Field<decimal>("14_Cam"));
                //decimal a14_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("14_FCB") == null ? 0 : row.Field<decimal>("14_FCB"));
                //decimal a14_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("14_Total") == null ? 0 : row.Field<decimal>("14_Total"));

                //decimal a15_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("15_Gen") == null ? 0 : row.Field<decimal>("15_Gen"));
                //decimal a15_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("15_Cam") == null ? 0 : row.Field<decimal>("15_Cam"));
                //decimal a15_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("15_FCB") == null ? 0 : row.Field<decimal>("15_FCB"));
                //decimal a15_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("15_Total") == null ? 0 : row.Field<decimal>("15_Total"));


                //decimal a16_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("16_Gen") == null ? 0 : row.Field<decimal>("16_Gen"));
                //decimal a16_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("16_Cam") == null ? 0 : row.Field<decimal>("16_Cam"));
                //decimal a16_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("16_FCB") == null ? 0 : row.Field<decimal>("16_FCB"));
                //decimal a16_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("16_Total") == null ? 0 : row.Field<decimal>("16_Total"));

                //decimal a17_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("17_Gen") == null ? 0 : row.Field<decimal>("17_Gen"));
                //decimal a17_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("17_Cam") == null ? 0 : row.Field<decimal>("17_Cam"));
                //decimal a17_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("17_FCB") == null ? 0 : row.Field<decimal>("17_FCB"));
                //decimal a17_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("17_Total") == null ? 0 : row.Field<decimal>("17_Total"));

                //decimal a18_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("18_Gen") == null ? 0 : row.Field<decimal>("18_Gen"));
                //decimal a18_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("18_Cam") == null ? 0 : row.Field<decimal>("18_Cam"));
                //decimal a18_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("18_FCB") == null ? 0 : row.Field<decimal>("18_FCB"));
                //decimal a18_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("18_Total") == null ? 0 : row.Field<decimal>("18_Total"));

                //decimal a19_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("19_Gen") == null ? 0 : row.Field<decimal>("19_Gen"));
                //decimal a19_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("19_Cam") == null ? 0 : row.Field<decimal>("19_Cam"));
                //decimal a19_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("19_FCB") == null ? 0 : row.Field<decimal>("19_FCB"));
                //decimal a19_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("19_Total") == null ? 0 : row.Field<decimal>("19_Total"));

                //decimal a20_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("20_Gen") == null ? 0 : row.Field<decimal>("20_Gen"));
                //decimal a20_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("20_Cam") == null ? 0 : row.Field<decimal>("20_Cam"));
                //decimal a20_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("20_FCB") == null ? 0 : row.Field<decimal>("20_FCB"));
                //decimal a20_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("20_Total") == null ? 0 : row.Field<decimal>("20_Total"));

                //decimal a21_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("21_Gen") == null ? 0 : row.Field<decimal>("21_Gen"));
                //decimal a21_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("21_Cam") == null ? 0 : row.Field<decimal>("21_Cam"));
                //decimal a21_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("21_FCB") == null ? 0 : row.Field<decimal>("21_FCB"));
                //decimal a21_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("21_Total") == null ? 0 : row.Field<decimal>("21_Total"));

                //decimal a22_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("22_Gen") == null ? 0 : row.Field<decimal>("22_Gen"));
                //decimal a22_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("22_Cam") == null ? 0 : row.Field<decimal>("22_Cam"));
                //decimal a22_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("22_FCB") == null ? 0 : row.Field<decimal>("22_FCB"));
                //decimal a22_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("22_Total") == null ? 0 : row.Field<decimal>("22_Total"));

                //decimal a23_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("23_Gen") == null ? 0 : row.Field<decimal>("23_Gen"));
                //decimal a23_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("23_Cam") == null ? 0 : row.Field<decimal>("23_Cam"));
                //decimal a23_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("23_FCB") == null ? 0 : row.Field<decimal>("23_FCB"));
                //decimal a23_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("23_Total") == null ? 0 : row.Field<decimal>("23_Total"));


                //decimal a24_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("24_Gen") == null ? 0 : row.Field<decimal>("24_Gen"));
                //decimal a24_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("24_Cam") == null ? 0 : row.Field<decimal>("24_Cam"));
                //decimal a24_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("24_FCB") == null ? 0 : row.Field<decimal>("24_FCB"));
                //decimal a24_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("24_Total") == null ? 0 : row.Field<decimal>("24_Total"));


                //decimal a25_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("25_Gen") == null ? 0 : row.Field<decimal>("25_Gen"));
                //decimal a25_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("25_Cam") == null ? 0 : row.Field<decimal>("25_Cam"));
                //decimal a25_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("25_FCB") == null ? 0 : row.Field<decimal>("25_FCB"));
                //decimal a25_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("25_Total") == null ? 0 : row.Field<decimal>("25_Total"));

                //decimal a26_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("26_Gen") == null ? 0 : row.Field<decimal>("26_Gen"));
                //decimal a26_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("26_Cam") == null ? 0 : row.Field<decimal>("26_Cam"));
                //decimal a26_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("26_FCB") == null ? 0 : row.Field<decimal>("26_FCB"));
                //decimal a26_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("26_Total") == null ? 0 : row.Field<decimal>("26_Total"));

                //decimal a27_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("27_Gen") == null ? 0 : row.Field<decimal>("27_Gen"));
                //decimal a27_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("27_Cam") == null ? 0 : row.Field<decimal>("27_Cam"));
                //decimal a27_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("27_FCB") == null ? 0 : row.Field<decimal>("27_FCB"));
                //decimal a27_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("27_Total") == null ? 0 : row.Field<decimal>("27_Total"));

                //decimal a28_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("28_Gen") == null ? 0 : row.Field<decimal>("28_Gen"));
                //decimal a28_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("28_Cam") == null ? 0 : row.Field<decimal>("28_Cam"));
                //decimal a28_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("28_FCB") == null ? 0 : row.Field<decimal>("28_FCB"));
                //decimal a28_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("28_Total") == null ? 0 : row.Field<decimal>("28_Total"));

                //decimal a29_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("29_Gen") == null ? 0 : row.Field<decimal>("29_Gen"));
                //decimal a29_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("29_Cam") == null ? 0 : row.Field<decimal>("29_Cam"));
                //decimal a29_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("29_FCB") == null ? 0 : row.Field<decimal>("29_FCB"));
                //decimal a29_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("29_Total") == null ? 0 : row.Field<decimal>("29_Total"));

                //decimal a30_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("30_Gen") == null ? 0 : row.Field<decimal>("30_Gen"));
                //decimal a30_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("30_Cam") == null ? 0 : row.Field<decimal>("30_Cam"));
                //decimal a30_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("30_FCB") == null ? 0 : row.Field<decimal>("30_FCB"));
                //decimal a30_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("30_Total") == null ? 0 : row.Field<decimal>("30_Total"));

                //decimal a31_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("31_Gen") == null ? 0 : row.Field<decimal>("31_Gen"));
                //decimal a31_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("31_Cam") == null ? 0 : row.Field<decimal>("31_Cam"));
                //decimal a31_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("31_FCB") == null ? 0 : row.Field<decimal>("31_FCB"));
                //decimal a31_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("31_Total") == null ? 0 : row.Field<decimal>("31_Total"));


                //decimal Total_Gen = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Total_Gen") == null ? 0 : row.Field<decimal>("Total_Gen"));
                //decimal Total_Cam = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Total_Cam") == null ? 0 : row.Field<decimal>("Total_Cam"));
                //decimal Total_FCB = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Total_FCB") == null ? 0 : row.Field<decimal>("Total_FCB"));
                //decimal Grand_Total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Grand_Total") == null ? 0 : row.Field<decimal>("Grand_Total"));


                //loadGridView.FooterRow.Cells[6].Text = "Total: ";

                //loadGridView.FooterRow.Cells[7].Text = a1_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[9].Text = a1_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[8].Text = a1_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[10].Text = a1_Total.ToString("N2");

                //loadGridView.FooterRow.Cells[11].Text = a2_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[13].Text = a2_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[12].Text = a2_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[14].Text = a2_Total.ToString("N2");

                //loadGridView.FooterRow.Cells[15].Text = a3_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[17].Text = a3_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[16].Text = a3_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[18].Text = a3_Total.ToString("N2");

                //loadGridView.FooterRow.Cells[19].Text = a4_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[21].Text = a4_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[20].Text = a4_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[22].Text = a4_Total.ToString("N2");

                //loadGridView.FooterRow.Cells[23].Text = a5_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[25].Text = a5_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[24].Text = a5_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[26].Text = a5_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[27].Text = a6_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[29].Text = a6_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[28].Text = a6_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[30].Text = a6_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[31].Text = a7_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[33].Text = a7_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[32].Text = a7_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[34].Text = a7_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[35].Text = a8_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[37].Text = a8_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[36].Text = a8_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[38].Text = a8_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[39].Text = a9_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[41].Text = a9_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[40].Text = a9_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[42].Text = a9_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[43].Text = a10_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[45].Text = a10_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[44].Text = a10_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[46].Text = a10_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[47].Text = a11_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[49].Text = a11_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[48].Text = a11_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[50].Text = a11_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[51].Text = a12_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[53].Text = a12_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[52].Text = a12_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[54].Text = a12_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[55].Text = a13_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[57].Text = a13_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[56].Text = a13_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[58].Text = a13_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[59].Text = a14_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[61].Text = a14_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[60].Text = a14_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[62].Text = a14_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[63].Text = a15_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[64].Text = a15_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[65].Text = a15_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[66].Text = a15_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[67].Text = a16_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[69].Text = a16_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[68].Text = a16_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[70].Text = a16_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[71].Text = a17_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[73].Text = a17_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[72].Text = a17_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[74].Text = a17_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[75].Text = a18_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[77].Text = a18_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[76].Text = a18_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[78].Text = a18_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[79].Text = a19_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[81].Text = a19_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[80].Text = a19_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[82].Text = a19_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[83].Text = a20_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[85].Text = a20_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[84].Text = a20_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[86].Text = a20_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[87].Text = a21_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[89].Text = a21_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[88].Text = a21_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[90].Text = a21_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[91].Text = a22_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[93].Text = a22_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[92].Text = a22_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[94].Text = a22_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[95].Text = a23_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[97].Text = a23_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[96].Text = a23_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[98].Text = a23_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[99].Text = a24_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[101].Text = a24_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[100].Text = a24_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[102].Text = a24_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[103].Text = a25_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[104].Text = a25_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[105].Text = a25_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[106].Text = a25_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[107].Text = a26_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[109].Text = a26_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[108].Text = a26_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[110].Text = a26_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[111].Text = a27_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[113].Text = a27_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[112].Text = a27_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[114].Text = a27_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[115].Text = a28_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[117].Text = a28_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[116].Text = a28_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[118].Text = a28_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[119].Text = a29_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[121].Text = a29_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[120].Text = a29_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[122].Text = a29_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[123].Text = a30_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[125].Text = a30_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[124].Text = a30_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[126].Text = a30_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[127].Text = a31_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[129].Text = a31_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[128].Text = a31_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[130].Text = a31_Total.ToString("N2");


                //loadGridView.FooterRow.Cells[131].Text = Total_Gen.ToString("N2");
                //loadGridView.FooterRow.Cells[132].Text = Total_Cam.ToString("N2");
                //loadGridView.FooterRow.Cells[133].Text = Total_FCB.ToString("N2");
                //loadGridView.FooterRow.Cells[134].Text = Grand_Total.ToString("N2");
           
                //loadGridView.FooterRow.BackColor = System.Drawing.Color.Beige;
                //loadGridView.FooterRow.Font.Bold =true ;


            }
            catch { }

        }
        stopwatch.Stop(); // Stop measuring time

        // Log or display the execution time
        TimeSpan elapsedTime = stopwatch.Elapsed;
        string executionTimeMessage = "Execution Time: {elapsedTime.TotalMilliseconds} ms";
        // You can log this message or display it as needed
        System.Diagnostics.Debug.WriteLine(executionTimeMessage); // Example: Write to Debug output
    }


    //protected void loadGridView_OnRowCreated(object sender, GridViewRowEventArgs e)
    //{
    //    if (e.Row.RowType == DataControlRowType.Header)
    //    {
    //        GridView HeaderGrid = (GridView)sender;
    //        GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);

    //        TableCell HeaderCell = new TableCell();

    //        HeaderCell = new TableCell();
    //        HeaderCell.Text = " ";
    //        HeaderCell.BackColor = Color.FromName("#F5F5F5");
    //        HeaderCell.BorderColor = Color.FromName("#F5F5F5");

    //        HeaderCell.ColumnSpan = 0;
    //        HeaderGridRow.Cells.Add(HeaderCell);

    //        //HeaderCell = new TableCell();
    //        //HeaderCell.Text = " ";
    //        //HeaderCell.BackColor = Color.FromName("#F5F5F5");
    //        //HeaderCell.BorderColor = Color.FromName("#F5F5F5");


    //        //HeaderCell.ColumnSpan = 1;

    //        //HeaderGridRow.Cells.Add(HeaderCell);



    //        HeaderCell = new TableCell();
    //        HeaderCell.Text = "Invoice";
    //        HeaderCell.ColumnSpan = 4;
    //        HeaderCell.BackColor = Color.DeepSkyBlue;
    //        HeaderGridRow.Cells.Add(HeaderCell);


    //        HeaderCell = new TableCell();
    //        HeaderCell.Text = "Return";
    //        HeaderCell.ColumnSpan = 3;
    //        HeaderCell.BackColor = Color.Red;
    //        HeaderGridRow.Cells.Add(HeaderCell);

    //        HeaderCell = new TableCell();
    //        HeaderCell.Text = "Sales";
    //        HeaderCell.BackColor = Color.GreenYellow;
    //        HeaderCell.ColumnSpan = 3;
    //        HeaderGridRow.Cells.Add(HeaderCell);



    //        HeaderCell = new TableCell();
    //        HeaderCell.Text = "Collection";
    //        HeaderCell.BackColor = Color.LightSeaGreen;
    //        HeaderCell.ColumnSpan = 3;
    //        HeaderGridRow.Cells.Add(HeaderCell);


    //        HeaderCell = new TableCell();
    //        HeaderCell.Text = "Receivable";
    //        HeaderCell.BackColor = Color.Yellow;
    //        HeaderCell.ColumnSpan = 3;
    //        HeaderGridRow.Cells.Add(HeaderCell);



    //        loadGridView.Controls[0].Controls.AddAt(0, HeaderGridRow);

    //    }
    //}
    public override void VerifyRenderingInServerForm(Control control)
    {
        // //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
    }

    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadData();
    }
    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        //    LoadData();

        Stopwatch stopwatch = new Stopwatch(); // Create a Stopwatch instance
        stopwatch.Start(); // Start measuring time

        if (loadGridView.Rows.Count > 0)
        {

            string attachment = "attachment; filename=DWSP_Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            loadGridView.AllowPaging = false;
            this.LoadData();


            //loadGridView.Columns[loadGridView.Columns.Count - 1].Visible =
            //            false;
            //loadGridView.Columns[loadGridView.Columns.Count - 2].Visible =
            //   false;
            //loadGridView.Columns[loadGridView.Columns.Count - 3].Visible =
            //   false;


            // Create a form to contain the grid  
            HtmlForm frm = new HtmlForm();
            loadGridView.Parent.Controls.Add(frm);
            //frm.Attributes["runat"] = "server";
            //frm.Controls.Add(loadGridView);
            //frm.RenderControl(htw);

            loadGridView.HeaderRow.Style.Add("background-color", "#E5EEF1");

            // Set background color of each cell of GridView1 header row
            foreach (TableCell tableCell in loadGridView.HeaderRow.Cells)
            {
                tableCell.Style["background-color"] = "#E5EEF1";
            }

            // Set background color of each cell of each data row of GridView1
        

            loadGridView.RenderControl(htw);


            string headerTable = @"<span  style='text-align:center'><h3>  DWSP Report   Month of " + ddlmonth.SelectedItem.Text + " "+  ddlYear.SelectedItem.Text + "  </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

            HttpContext.Current.Response.Write(headerTable);

            Response.Write(sw.ToString());
            Response.End();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }

        stopwatch.Stop(); // Stop measuring time

        // Log or display the execution time
        TimeSpan elapsedTime = stopwatch.Elapsed;
        string executionTimeMessage = "Execution Time: {elapsedTime.TotalMilliseconds} ms";
        // You can log this message or display it as needed
        System.Diagnostics.Debug.WriteLine(executionTimeMessage); // Example: Write to Debug output
    }
    
    protected void loadGridView_OnRowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            GridView HeaderGrid = (GridView)sender;
            GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);

            TableCell HeaderCell = new TableCell();

            

            HeaderCell = new TableCell();
            HeaderCell.Text = "";
            HeaderCell.ColumnSpan = 7;

            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "1";
            HeaderCell.ColumnSpan = 4;
             

            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "2";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "3";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "4";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "5";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "6";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "7";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "8";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "9";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "10";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "11";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "12";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "13";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "14";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "15";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "16";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "17";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "18";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "19";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "20";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "21";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "22";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "23";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "24";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "25";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "26";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "27";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "28";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "29";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "30";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "31";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Grand Total";
            HeaderCell.ColumnSpan = 4;
            HeaderGridRow.Cells.Add(HeaderCell);





            loadGridView.Controls[0].Controls.AddAt(0, HeaderGridRow);

        }
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadData();
    }
   
    private string param()
    {
         

        var param = "  ";

        //if (FromDate.Text != "" &&  ToDate.Text != "") {
        //    param = param + " AND CONVERT(date,mas.EntryDate)  BETWEEN '" + FromDate.Text + "' AND '" + ToDate.Text + "' ";
        //}
        //if ( FromDate.Text != "" && ToDate.Text == "") {
        //    param = param + " AND CONVERT(date,mas.EntryDate)  BETWEEN '" + FromDate.Text + "' AND '" + DateTime.Now.ToString("dd-MMM-yyyy") + "' ";
        //}

      

        if (EmployeeIdSelect.SelectedValue != "" ) {

            param = param + " AND mas.EmpInfoId='" + EmployeeIdSelect.SelectedValue + "'";

        }


        return param;
    }

    [WebMethod]
    public static string GetMileageClaimList(string param)
    {
        DataTable dt = _setupDAL.GetMileageClaimList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;

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

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        //if (e.CommandName == "EditData")
        //{
        //    int rowindex = Convert.ToInt32(e.CommandArgument);
        //    string unitPriceId = loadGridView.DataKeys[rowindex][0].ToString();

        //    Response.Redirect("../DoctorModule_UI/MileageClaim.aspx?id=" + unitPriceId);
        //}

    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
         Response.Redirect("EmpMonthlyExpenseRpt.aspx");
    }

    protected void rbType_SelectedIndexChanged(object sender, EventArgs e)
    {
        //loadGridView.DataSource = null;
        //loadGridView.DataBind();
    }

    protected void rbReportTypeName_SelectedIndexChanged(object sender, EventArgs e)
    {
         
    }

    protected void ddlArea_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}