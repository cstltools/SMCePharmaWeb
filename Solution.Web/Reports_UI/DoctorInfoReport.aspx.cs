using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Library.DAL.DoctorInfo_DAL;
using Library.DAL.DoctorModule_DAL;
using Library.DAL.MasterSetup_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;

public partial class Reports_UI_DoctorInfoReport : System.Web.UI.Page
{

    private DropDownList F_GroupSelect, F_ZoneSelect, F_AreaSelect, F_TeritorySelect, F_SubTeritory, F_MarketSelect;

    private Panel divZone, divArea, divTerritory;

    static SeedDataDAL _seedRepo = new SeedDataDAL();
    static Setup2DAL _setupDAL = new Setup2DAL();
    static SetupDAL _setupDAL2 = new SetupDAL();
    private static CmnCrystaltoView _DAL = new CmnCrystaltoView();
    static CommonDataLoad _dataLoad = new CommonDataLoad();


    private DoctorInfoReportDal aReportDal = new DoctorInfoReportDal();

    protected void Page_Load(object sender, EventArgs e)
    {

        divZone = (Panel)IVMarketStructure.FindControl("divZone") as Panel;
        divArea = (Panel)IVMarketStructure.FindControl("divArea") as Panel;
        divTerritory = (Panel)IVMarketStructure.FindControl("divTerritory") as Panel;


        F_GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        F_ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        F_AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        F_TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        F_SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        F_MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;
        if (!IsPostBack)
        {
            try
            {
                DateTime now = DateTime.Now;
                var startDate = new DateTime(now.Year, now.Month, 1);
                var endDate = startDate.AddMonths(1).AddDays(-1);
                txtFromDate.Text = startDate.ToString("dd MMMM, yyyy");
                txtTodate.Text = endDate.ToString("dd MMMM, yyyy");

                try
                {

                    using (DataTable dt = aReportDal.GetLastProessDate(""))
                {
                    lblInfo.Text = dt.Rows[0]["LastProcessDate"].ToString();
                }
                }
                catch
                {

                }
            }
            catch
            {

            }
            LoadInitialInfo();

            //  LoadData();
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
          //  GetMonthList("");
           // GetYearList("");
        }

        catch (Exception ex) { }

        try
        {
            using (DataTable dt = _dataLoad.GetEmployeeList_Active())
            {
                //EmployeeIdSelect.DataSource = dt;
                //EmployeeIdSelect.DataValueField = "EmpInfoId";
                //EmployeeIdSelect.DataTextField = "EmpName";
                //EmployeeIdSelect.DataBind();
                //EmployeeIdSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                //EmployeeIdSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }




    }
    private void LoadData()
    {
        string Type = "";
      
      //  data.InnerHtml = "";
        loadGridView.DataSource = null;
        loadGridView.DataBind();

        if (rbReportTypeName.Items[0].Selected)
        {
            DataTable aDataTable = _DAL.GetDoctorWiseDayList(Type, "", "");
            loadGridView.DataSource = aDataTable;
            loadGridView.DataBind();
        }



        if (rbReportTypeName.Items[1].Selected)
        {

           // DataTable dtDate = _DAL.GetDatefromMonthYear(Type, "", "");


           // string mainDate = "";
           // foreach (DataRow row in dtDate.Rows)
           // {
           //     mainDate = mainDate + row["mainDate"].ToString() + ',';
           // }
           // string mainDate_ = mainDate.TrimEnd(',');
           // DataTable aDataTable = _DAL.GetRXDoctorBrandWiseList(mainDate_, "", "");
           // string html = "<table id='tblTable' style='height:200px;' class='table table-bordered text-center thead-dark table-hover table-striped tableFixHead' >";
           // html = html + "<thead> " + "<tr>";
           // for (int i = 0; i < aDataTable.Columns.Count; i++)
           // {

           //     html = html + "<th>" + aDataTable.Columns[i].ColumnName + "</th>";
           // }

           // html = html + "<th>" + "Total" + "</th>";

           // html = html + "</tr></thead>";

           // html = html + "<tbody>";

           // for (int i = 0; i < aDataTable.Rows.Count; i++)
           // {
           //     html = html + "<tr>";
           //     int Total = 0;
           //     for (int j = 0; j < aDataTable.Columns.Count; j++)
           //     {

           //         try
           //         {
           //             Total = Total + Convert.ToInt32(aDataTable.Rows[i][j].ToString());
           //         }
           //         catch { }

           //         html = html + "<td>" + aDataTable.Rows[i][j].ToString() + "</td>";
           //     }
           //     html = html + "<td>" + Total + "</td>";
           //     html = html + "</tr>";
           // }


           // html = html + "</tbody>";



           // html = html + "</table>";
           //// data.InnerHtml = html;
        }

        if (rbReportTypeName.Items[2].Selected)
        {

           // DataTable dtDate = _DAL.GetDatefromMonthYear(Type, "", "");


           // string mainDate = "";
           // foreach (DataRow row in dtDate.Rows)
           // {
           //     mainDate = mainDate + row["mainDate"].ToString() + ',';
           // }
           // string mainDate_ = mainDate.TrimEnd(',');
           // DataTable aDataTable = _DAL.GetRXDoctorProductWiseList(mainDate_, "", "");
           // string html = "<table id='tblTable' style='height:200px;' class='table table-bordered text-center thead-dark table-hover table-striped tableFixHead' >";
           // html = html + "<thead> " + "<tr>";
           // for (int i = 0; i < aDataTable.Columns.Count; i++)
           // {

           //     html = html + "<th>" + aDataTable.Columns[i].ColumnName + "</th>";
           // }

           // html = html + "<th>" + "Total" + "</th>";

           // html = html + "</tr></thead>";

           // html = html + "<tbody>";

           // for (int i = 0; i < aDataTable.Rows.Count; i++)
           // {
           //     html = html + "<tr>";
           //     int Total = 0;
           //     for (int j = 0; j < aDataTable.Columns.Count; j++)
           //     {

           //         try
           //         {
           //             Total = Total + Convert.ToInt32(aDataTable.Rows[i][j].ToString());
           //         }
           //         catch { }

           //         html = html + "<td>" + aDataTable.Rows[i][j].ToString() + "</td>";
           //     }
           //     html = html + "<td>" + Total + "</td>";
           //     html = html + "</tr>";
           // }


           // html = html + "</tbody>";



           // html = html + "</table>";
           //// data.InnerHtml = html;
        }


        if (rbReportTypeName.Items[3].Selected)
        {

            //DataTable dtDate = _DAL.GetDatefromMonthYear(Type, "", "");


            //string mainDate = "";
            //foreach (DataRow row in dtDate.Rows)
            //{
            //    mainDate = mainDate + row["mainDate"].ToString() + ',';
            //}
            //string mainDate_ = mainDate.TrimEnd(',');
            //DataTable aDataTable = _DAL.GetRXUserWiseList(mainDate_, "", "");
            //string html = "<table id='tblTable' style='height:200px;' class='table table-bordered text-center thead-dark table-hover table-striped tableFixHead' >";
            //html = html + " <thead><tr> ";

            ////+"<tr>" +
            ////             "<th colspan='5' colspan='8'  style='background-color: #F5F5F5!important;border:None!important'>  </th>" +
            ////             "<th colspan='3'  style='color: white;background-color: #4DDEC1!important'> Input </th>" +
            ////             "<th colspan='3'  style='color: white;background-color: #64ADFF!important'> Output </th>" +
            ////             "</tr><tr>";
            //for (int i = 0; i < aDataTable.Columns.Count; i++)
            //{

            //    html = html + "<th>" + aDataTable.Columns[i].ColumnName + "</th>";
            //}

            //html = html + "<th>" + "Total" + "</th>";

            //html = html + "</tr></thead>";

            //html = html + "<tbody>";

            //for (int i = 0; i < aDataTable.Rows.Count; i++)
            //{
            //    html = html + "<tr>";
            //    int Total = 0;
            //    for (int j = 0; j < aDataTable.Columns.Count; j++)
            //    {

            //        try
            //        {


            //            Total = Total + Convert.ToInt32(aDataTable.Rows[i][j].ToString());



            //        }
            //        catch { }

            //        html = html + "<td>" + aDataTable.Rows[i][j].ToString() + "</td>";
            //    }
            //    html = html + "<td>" + Total + "</td>";
            //    html = html + "</tr>";
            //}


            //html = html + "</tbody>";



            //html = html + "</table>";
            ////data.InnerHtml = html;
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
        if (rbReportTypeName.SelectedValue != "")
        {
            if (rbReportTypeName.SelectedValue=="2")
            {
                Get_Doctor_Information_Details();
            }
            else
            {
                if (rdoAnotherReport.SelectedValue == "Provider")
                {
                    Get_Doctor_Information();
                }

                if (rdoAnotherReport.SelectedValue == "MIO")
                {
                    Get_Doctor_Information_MIO_Wise();
                }

                if (rdoAnotherReport.SelectedValue == "Zone")
                {
                    Get_Doctor_Information_Zone_Wise();
                }


                if (rdoAnotherReport.SelectedValue == "Area")
                {
                    Get_Doctor_Information_Area_Wise();
                }


                if (rdoAnotherReport.SelectedValue == "Doctor")
                {
                    Get_Doctor_Information_DOC_Wise();
                }
            }

        }
        else
        {
            showMessageBox("Please Report Type!");
        }

    }


    protected void OnPageIndexChanging(object sender, GridViewPageEventArgs e)
    {

    }

    protected void loadGridView_OnRowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            GridView HeaderGrid = (GridView)sender;
            GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);

            TableCell HeaderCell = new TableCell();

            HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");

            HeaderCell.ColumnSpan = 5;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Assign";
            HeaderCell.ColumnSpan = 5;
            //HeaderCell.BackColor = Color.DeepSkyBlue;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Visited";
            HeaderCell.ColumnSpan = 5;
          //  HeaderCell.BackColor = Color.Red;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Repeat";
            //HeaderCell.BackColor = Color.GreenYellow;
            HeaderCell.ColumnSpan = 5;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Prescription";
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 5;
            HeaderGridRow.Cells.Add(HeaderCell);


            loadGridView.Controls[0].Controls.AddAt(0, HeaderGridRow);

        }
    }






    private void Get_Doctor_Information()
    {
        DataTable aTable = aReportDal.Get_Dactor_Information_Report(txtFromDate.Text, txtTodate.Text, "");
        MIOWISE.Visible = false;
        PPOVIDERWISE.Visible = true;
        Details.Visible = false;
        DocWise.Visible = false;

        loadGridView.DataSource = null;

        loadGridView.DataSource = aTable;
        loadGridView.DataBind();

    }


    private void Get_Doctor_Information_MIO_Wise()
    {
        string Zone = null;
        string Area = null;
        string Teritory = null;
        if (F_ZoneSelect.SelectedValue != "")
        {
            Zone = F_ZoneSelect.SelectedValue;
        }
        if (F_AreaSelect.SelectedValue != "")
        {
            Area = F_AreaSelect.SelectedValue;
        }

        if (F_TeritorySelect.SelectedValue != "")
        {
            Teritory = F_TeritorySelect.SelectedValue;
        }

        DataTable aTable = aReportDal.Get_Dactor_Information_MIO_Wise( txtFromDate.Text, txtTodate.Text, Zone, Area, Teritory, "");

        MIOWISE.Visible = true;
        PPOVIDERWISE.Visible = false;
        Details.Visible = false;
        DocWise.Visible = false;

        GridView1.DataSource = null;

        GridView1.DataSource = aTable;
        GridView1.DataBind();

        if (GridView1.Rows.Count > 0)
        {
            try
            {
                int AssignDocCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("AssignDocCount") == null ? 0 : row.Field<int>("AssignDocCount"));



                int DCRDocCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("DCRDocCount") == null ? 0 : row.Field<int>("DCRDocCount"));

                int DCPTotalCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("DCPTotalCount") == null ? 0 : row.Field<int>("DCPTotalCount"));

                int RepatCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("RepatCount") == null ? 0 : row.Field<int>("RepatCount"));

                int NORXCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("NORXCount") == null ? 0 : row.Field<int>("NORXCount"));


                int RXCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("RXCount") == null ? 0 : row.Field<int>("RXCount"));



                int _1WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekDCP") == null ? 0 : row.Field<int>("1WeekDCP"));

                int _1WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekV") == null ? 0 : row.Field<int>("1WeekV"));
                int _1WeekR = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekR") == null ? 0 : row.Field<int>("1WeekR"));
                int _1WeekNP = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekNP") == null ? 0 : row.Field<int>("1WeekNP"));
                int _1WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekP") == null ? 0 : row.Field<int>("1WeekP"));



                int _2WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekDCP") == null ? 0 : row.Field<int>("2WeekDCP"));

                int _2WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekV") == null ? 0 : row.Field<int>("2WeekV"));
                int _2WeekR = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekR") == null ? 0 : row.Field<int>("2WeekR"));
                int _2WeekNP = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekNP") == null ? 0 : row.Field<int>("2WeekNP"));

                int _2WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekP") == null ? 0 : row.Field<int>("2WeekP"));

                int _3WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekDCP") == null ? 0 : row.Field<int>("3WeekDCP"));
                int _3WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekV") == null ? 0 : row.Field<int>("3WeekV"));
                int _3WeekR = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekR") == null ? 0 : row.Field<int>("3WeekR"));
                int _3WeekNP = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekNP") == null ? 0 : row.Field<int>("3WeekNP"));
                int _3WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekP") == null ? 0 : row.Field<int>("3WeekP"));


                int _4WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekV") == null ? 0 : row.Field<int>("4WeekV"));
                int _4WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekDCP") == null ? 0 : row.Field<int>("4WeekDCP"));

                int _4WeekR = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekR") == null ? 0 : row.Field<int>("4WeekR"));
                int _4WeekNP = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekNP") == null ? 0 : row.Field<int>("4WeekNP"));
                int _4WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekP") == null ? 0 : row.Field<int>("4WeekP"));






                GridView1.FooterRow.Cells[4].Text = "Total: ";

                GridView1.FooterRow.Cells[5].Text = AssignDocCount.ToString("");
                GridView1.FooterRow.Cells[6].Text = DCRDocCount.ToString("");
                GridView1.FooterRow.Cells[7].Text = DCPTotalCount.ToString("");
                GridView1.FooterRow.Cells[8].Text = RepatCount.ToString("");
                GridView1.FooterRow.Cells[9].Text = NORXCount.ToString("");

                GridView1.FooterRow.Cells[10].Text = RXCount.ToString("");

                GridView1.FooterRow.Cells[11].Text = _1WeekV.ToString("");

                GridView1.FooterRow.Cells[12].Text = _1WeekDCP.ToString("");
                GridView1.FooterRow.Cells[13].Text = _1WeekR.ToString("");
                GridView1.FooterRow.Cells[14].Text = _1WeekNP.ToString("");
                GridView1.FooterRow.Cells[15].Text = _1WeekP.ToString("");


                GridView1.FooterRow.Cells[16].Text = _2WeekV.ToString("");
                GridView1.FooterRow.Cells[17].Text = _2WeekDCP.ToString("");

                GridView1.FooterRow.Cells[18].Text = _2WeekR.ToString("");
                GridView1.FooterRow.Cells[19].Text = _2WeekNP.ToString("");
                GridView1.FooterRow.Cells[20].Text = _2WeekP.ToString("");


                GridView1.FooterRow.Cells[21].Text = _3WeekV.ToString("");
                GridView1.FooterRow.Cells[22].Text = _3WeekDCP.ToString("");
                GridView1.FooterRow.Cells[23].Text = _3WeekR.ToString("");
                GridView1.FooterRow.Cells[24].Text = _3WeekNP.ToString("");
                GridView1.FooterRow.Cells[25].Text = _3WeekP.ToString("");


                GridView1.FooterRow.Cells[26].Text = _4WeekV.ToString("");
                GridView1.FooterRow.Cells[27].Text = _4WeekDCP.ToString("");

                GridView1.FooterRow.Cells[28].Text = _4WeekR.ToString("");
                GridView1.FooterRow.Cells[29].Text = _4WeekNP.ToString("");
                GridView1.FooterRow.Cells[30].Text = _4WeekP.ToString("");




                GridView1.FooterRow.BackColor = System.Drawing.Color.Beige;
                GridView1.FooterRow.Font.Bold = true;
            }
            catch { }

        }



    }


    private void Get_Doctor_Information_Zone_Wise()
    {
        string Zone = null;
        //string Area = null;
        //string Teritory = null;
        if (F_ZoneSelect.SelectedValue != "")
        {
            Zone = F_ZoneSelect.SelectedValue;
        }
        //if (F_AreaSelect.SelectedValue != "")
        //{
        //    Area = F_AreaSelect.SelectedValue;
        //}

        //if (F_TeritorySelect.SelectedValue != "")
        //{
        //    Teritory = F_TeritorySelect.SelectedValue;
        //}

        DataTable aTable = aReportDal.Get_Dactor_Information_Zone_Wise(txtFromDate.Text, txtTodate.Text, Zone, "");

        MIOWISE.Visible = true;
        PPOVIDERWISE.Visible = false;
        Details.Visible = false;
        DocWise.Visible = false;

        GridView1.DataSource = null;

        gv_Zone.DataSource = aTable;
        gv_Zone.DataBind();

        if (gv_Zone.Rows.Count > 0)
        {
            try
            {
                int  AssignDocCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("AssignDocCount") == null ? 0 : row.Field<int>("AssignDocCount"));


                int DCRDocCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("DCRDocCount") == null ? 0 : row.Field<int>("DCRDocCount"));

                int DCRTotalCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("DCRTotalCount") == null ? 0 : row.Field<int>("DCRTotalCount"));

                int DCPTotalCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("DCPTotalCount") == null ? 0 : row.Field<int>("DCPTotalCount"));

                int RepatCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("RepatCount") == null ? 0 : row.Field<int>("RepatCount"));

                int NORXCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("NORXCount") == null ? 0 : row.Field<int>("NORXCount"));


                int RXCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("RXCount") == null ? 0 : row.Field<int>("RXCount"));



               

                int _1WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekV") == null ? 0 : row.Field<int>("1WeekV"));

                int _1WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekDCP") == null ? 0 : row.Field<int>("1WeekDCP"));


                int _1WeekR = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekR") == null ? 0 : row.Field<int>("1WeekR"));
                int _1WeekNP = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekNP") == null ? 0 : row.Field<int>("1WeekNP"));
                int _1WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekP") == null ? 0 : row.Field<int>("1WeekP"));


                int _2WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekV") == null ? 0 : row.Field<int>("2WeekV"));

                int _2WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekDCP") == null ? 0 : row.Field<int>("2WeekDCP"));
                int _2WeekR = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekR") == null ? 0 : row.Field<int>("2WeekR"));
                int _2WeekNP = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekNP") == null ? 0 : row.Field<int>("2WeekNP"));

                int _2WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekP") == null ? 0 : row.Field<int>("2WeekP"));


                int _3WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekV") == null ? 0 : row.Field<int>("3WeekV"));

                int _3WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekDCP") == null ? 0 : row.Field<int>("3WeekDCP"));

                int _3WeekR = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekR") == null ? 0 : row.Field<int>("3WeekR"));
                int _3WeekNP = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekNP") == null ? 0 : row.Field<int>("3WeekNP"));
                int _3WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekP") == null ? 0 : row.Field<int>("3WeekP"));


                int _4WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekV") == null ? 0 : row.Field<int>("4WeekV"));

                int _4WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekDCP") == null ? 0 : row.Field<int>("4WeekDCP"));

                int _4WeekR = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekR") == null ? 0 : row.Field<int>("4WeekR"));
                int _4WeekNP = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekNP") == null ? 0 : row.Field<int>("4WeekNP"));
                int _4WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekP") == null ? 0 : row.Field<int>("4WeekP"));





                gv_Zone.FooterRow.Cells[1].Text = "Total: ";

                gv_Zone.FooterRow.Cells[2].Text = AssignDocCount.ToString("");
                gv_Zone.FooterRow.Cells[3].Text = DCRDocCount.ToString("");

                gv_Zone.FooterRow.Cells[4].Text = DCPTotalCount.ToString("");

                gv_Zone.FooterRow.Cells[5].Text = DCRTotalCount.ToString("");
                gv_Zone.FooterRow.Cells[6].Text = RepatCount.ToString("");
                gv_Zone.FooterRow.Cells[7].Text = NORXCount.ToString("");

                gv_Zone.FooterRow.Cells[8].Text = RXCount.ToString("");

                gv_Zone.FooterRow.Cells[9].Text = _1WeekV.ToString("");
                gv_Zone.FooterRow.Cells[10].Text = _1WeekDCP.ToString("");
                gv_Zone.FooterRow.Cells[11].Text = _1WeekR.ToString("");
                gv_Zone.FooterRow.Cells[12].Text = _1WeekNP.ToString("");
                gv_Zone.FooterRow.Cells[13].Text = _1WeekP.ToString("");


                gv_Zone.FooterRow.Cells[14].Text = _2WeekV.ToString("");
                gv_Zone.FooterRow.Cells[15].Text = _2WeekDCP.ToString("");

                gv_Zone.FooterRow.Cells[16].Text = _2WeekR.ToString("");
                gv_Zone.FooterRow.Cells[17].Text = _2WeekNP.ToString("");
                gv_Zone.FooterRow.Cells[18].Text = _2WeekP.ToString("");


                gv_Zone.FooterRow.Cells[19].Text = _3WeekV.ToString("");
                gv_Zone.FooterRow.Cells[20].Text = _3WeekDCP.ToString("");

                gv_Zone.FooterRow.Cells[21].Text = _3WeekR.ToString("");
                gv_Zone.FooterRow.Cells[22].Text = _3WeekNP.ToString("");
                gv_Zone.FooterRow.Cells[23].Text = _3WeekP.ToString("");


                gv_Zone.FooterRow.Cells[24].Text = _4WeekV.ToString("");
                gv_Zone.FooterRow.Cells[25].Text = _4WeekDCP.ToString("");

                gv_Zone.FooterRow.Cells[26].Text = _4WeekR.ToString("");
                gv_Zone.FooterRow.Cells[27].Text = _4WeekNP.ToString("");
                gv_Zone.FooterRow.Cells[28].Text = _4WeekP.ToString("");




                gv_Zone.FooterRow.BackColor = System.Drawing.Color.Beige;
                gv_Zone.FooterRow.Font.Bold = true;
            }
            catch { }

            }
    }





    private void Get_Doctor_Information_Area_Wise()
    {
        string Zone = null;
      string Area = null;
        //string Teritory = null;
        if (F_ZoneSelect.SelectedValue != "")
        {
            Zone = F_ZoneSelect.SelectedValue;
        }
        if (F_AreaSelect.SelectedValue != "")
        {
            Area = F_AreaSelect.SelectedValue;
        }

        //if (F_TeritorySelect.SelectedValue != "")
        //{
        //    Teritory = F_TeritorySelect.SelectedValue;
        //}

        DataTable aTable = aReportDal.Get_Dactor_Information_Area_Wise(txtFromDate.Text, txtTodate.Text, Zone, Area, "");

        MIOWISE.Visible = true;
        PPOVIDERWISE.Visible = false;
        Details.Visible = false;
        DocWise.Visible = false;

        GridView1.DataSource = null;

        gv_Area.DataSource = aTable;
        gv_Area.DataBind();

        if (gv_Area.Rows.Count > 0)
        {
            try
            {
                int AssignDocCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("AssignDocCount") == null ? 0 : row.Field<int>("AssignDocCount"));


                int DCRDocCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("DCRDocCount") == null ? 0 : row.Field<int>("DCRDocCount"));

                int DCRTotalCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("DCRTotalCount") == null ? 0 : row.Field<int>("DCRTotalCount"));

                int DCPTotalCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("DCPTotalCount") == null ? 0 : row.Field<int>("DCPTotalCount"));

                int RepatCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("RepatCount") == null ? 0 : row.Field<int>("RepatCount"));

                int NORXCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("NORXCount") == null ? 0 : row.Field<int>("NORXCount"));


                int RXCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("RXCount") == null ? 0 : row.Field<int>("RXCount"));





                int _1WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekV") == null ? 0 : row.Field<int>("1WeekV"));

                int _1WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekDCP") == null ? 0 : row.Field<int>("1WeekDCP"));


                int _1WeekR = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekR") == null ? 0 : row.Field<int>("1WeekR"));
                int _1WeekNP = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekNP") == null ? 0 : row.Field<int>("1WeekNP"));
                int _1WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekP") == null ? 0 : row.Field<int>("1WeekP"));


                int _2WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekV") == null ? 0 : row.Field<int>("2WeekV"));

                int _2WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekDCP") == null ? 0 : row.Field<int>("2WeekDCP"));
                int _2WeekR = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekR") == null ? 0 : row.Field<int>("2WeekR"));
                int _2WeekNP = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekNP") == null ? 0 : row.Field<int>("2WeekNP"));

                int _2WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekP") == null ? 0 : row.Field<int>("2WeekP"));


                int _3WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekV") == null ? 0 : row.Field<int>("3WeekV"));

                int _3WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekDCP") == null ? 0 : row.Field<int>("3WeekDCP"));

                int _3WeekR = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekR") == null ? 0 : row.Field<int>("3WeekR"));
                int _3WeekNP = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekNP") == null ? 0 : row.Field<int>("3WeekNP"));
                int _3WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekP") == null ? 0 : row.Field<int>("3WeekP"));


                int _4WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekV") == null ? 0 : row.Field<int>("4WeekV"));

                int _4WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekDCP") == null ? 0 : row.Field<int>("4WeekDCP"));

                int _4WeekR = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekR") == null ? 0 : row.Field<int>("4WeekR"));
                int _4WeekNP = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekNP") == null ? 0 : row.Field<int>("4WeekNP"));
                int _4WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekP") == null ? 0 : row.Field<int>("4WeekP"));









                gv_Area.FooterRow.Cells[2].Text = "Total: ";

                gv_Area.FooterRow.Cells[3].Text = AssignDocCount.ToString("");
                gv_Area.FooterRow.Cells[4].Text = DCRDocCount.ToString("");
                gv_Area.FooterRow.Cells[5].Text = DCPTotalCount.ToString("");
                gv_Area.FooterRow.Cells[6].Text = DCRTotalCount.ToString("");
                gv_Area.FooterRow.Cells[7].Text = RepatCount.ToString("");
                gv_Area.FooterRow.Cells[8].Text = NORXCount.ToString("");

                gv_Area.FooterRow.Cells[9].Text = RXCount.ToString("");

                gv_Area.FooterRow.Cells[10].Text = _1WeekV.ToString("");
                gv_Area.FooterRow.Cells[11].Text = _1WeekDCP.ToString("");
                gv_Area.FooterRow.Cells[12].Text = _1WeekR.ToString("");
                gv_Area.FooterRow.Cells[13].Text = _1WeekNP.ToString("");
                gv_Area.FooterRow.Cells[14].Text = _1WeekP.ToString("");


                gv_Area.FooterRow.Cells[15].Text = _2WeekV.ToString("");
                gv_Area.FooterRow.Cells[16].Text = _2WeekDCP.ToString("");
                gv_Area.FooterRow.Cells[17].Text = _2WeekR.ToString("");
                gv_Area.FooterRow.Cells[18].Text = _2WeekNP.ToString("");
                gv_Area.FooterRow.Cells[19].Text = _2WeekP.ToString("");


                gv_Area.FooterRow.Cells[20].Text = _3WeekV.ToString("");
                gv_Area.FooterRow.Cells[21].Text = _3WeekDCP.ToString("");
                gv_Area.FooterRow.Cells[22].Text = _3WeekR.ToString("");
                gv_Area.FooterRow.Cells[23].Text = _3WeekNP.ToString("");
                gv_Area.FooterRow.Cells[24].Text = _3WeekP.ToString("");


                gv_Area.FooterRow.Cells[25].Text = _4WeekV.ToString("");
                gv_Area.FooterRow.Cells[26].Text = _4WeekDCP.ToString("");
                gv_Area.FooterRow.Cells[27].Text = _4WeekR.ToString("");
                gv_Area.FooterRow.Cells[28].Text = _4WeekNP.ToString("");
                gv_Area.FooterRow.Cells[29].Text = _4WeekP.ToString("");




                gv_Area.FooterRow.BackColor = System.Drawing.Color.Beige;
                gv_Area.FooterRow.Font.Bold = true;
            }
            catch { }

        }


    }


    private void Get_Doctor_Information_DOC_Wise()
    {

        string Zone = null;
        string Area = null;
        string Teritory = null;
        if (F_ZoneSelect.SelectedValue != "")
        {
            Zone = F_ZoneSelect.SelectedValue;
        }
        if (F_AreaSelect.SelectedValue != "")
        {
            Area = F_AreaSelect.SelectedValue;
        }

        if (F_TeritorySelect.SelectedValue != "")
        {
            Teritory = F_TeritorySelect.SelectedValue;
        }

        DataTable aTable = aReportDal.Get_Dactor_Information_Doc_Wise(txtFromDate.Text, txtTodate.Text, Zone, Area, Teritory, "");

        MIOWISE.Visible = false;
        PPOVIDERWISE.Visible = false;
        Details.Visible = false;
        DocWise.Visible = true;

        GridView2.DataSource = null;
        GridView2.DataSource = aTable;
        GridView2.DataBind();

        if (GridView2.Rows.Count > 0)
        {
            try
            {
                int DCPTotalCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("DCPTotalCount") == null ? 0 : row.Field<int>("DCPTotalCount"));
                int DCRDocCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("DCRDocCount") == null ? 0 : row.Field<int>("DCRDocCount"));

                int RXCount = aTable.AsEnumerable().Sum(row => row.Field<int?>("RXCount") == null ? 0 : row.Field<int>("RXCount"));

                 
                 


                int _1WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekDCP") == null ? 0 : row.Field<int>("1WeekDCP"));
                int _1WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekV") == null ? 0 : row.Field<int>("1WeekV"));
                int _1WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("1WeekP") == null ? 0 : row.Field<int>("1WeekP"));


                int _2WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekDCP") == null ? 0 : row.Field<int>("2WeekDCP"));
                int _2WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekV") == null ? 0 : row.Field<int>("2WeekV"));
                int _2WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("2WeekP") == null ? 0 : row.Field<int>("2WeekP"));
                int _3WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekDCP") == null ? 0 : row.Field<int>("3WeekDCP"));
                int _3WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekV") == null ? 0 : row.Field<int>("3WeekV"));
                int _3WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("3WeekP") == null ? 0 : row.Field<int>("3WeekP"));
                int _4WeekV = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekV") == null ? 0 : row.Field<int>("4WeekV"));
                int _4WeekDCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekDCP") == null ? 0 : row.Field<int>("4WeekDCP"));
                int _4WeekP = aTable.AsEnumerable().Sum(row => row.Field<int?>("4WeekP") == null ? 0 : row.Field<int>("4WeekP"));

              



                GridView2.FooterRow.Cells[9].Text = "Total: ";
                  
                GridView2.FooterRow.Cells[10].Text = DCPTotalCount.ToString("");
                GridView2.FooterRow.Cells[11].Text = DCRDocCount.ToString(""); 
                GridView2.FooterRow.Cells[12].Text = RXCount.ToString("");


                GridView2.FooterRow.Cells[13].Text = _1WeekDCP.ToString("");
                GridView2.FooterRow.Cells[14].Text = _1WeekV.ToString("");
                GridView2.FooterRow.Cells[15].Text = _1WeekP.ToString("");
                
                GridView2.FooterRow.Cells[16].Text = _2WeekDCP.ToString("");
                GridView2.FooterRow.Cells[17].Text = _2WeekV.ToString(""); 
                GridView2.FooterRow.Cells[18].Text = _2WeekP.ToString("");
                
                GridView2.FooterRow.Cells[19].Text = _3WeekDCP.ToString(""); 
                GridView2.FooterRow.Cells[20].Text = _3WeekV.ToString(""); 
                GridView2.FooterRow.Cells[21].Text = _3WeekP.ToString("");


                GridView2.FooterRow.Cells[22].Text = _4WeekDCP.ToString("");
                GridView2.FooterRow.Cells[23].Text = _4WeekV.ToString("");
                GridView2.FooterRow.Cells[24].Text = _4WeekP.ToString("");
                 



                GridView2.FooterRow.BackColor = System.Drawing.Color.Beige;
                GridView2.FooterRow.Font.Bold = true;
            }
            catch { }

        }



    }


    private void Get_Doctor_Information_Details()
    {

        string Zone = null;
        string Area = null;
        string Teritory = null;
        if (F_ZoneSelect.SelectedValue != "")
        {
            Zone = F_ZoneSelect.SelectedValue;
        }
        if (F_AreaSelect.SelectedValue != "")
        {
            Area = F_AreaSelect.SelectedValue;
        }

        if (F_TeritorySelect.SelectedValue != "")
        {
            Teritory = F_TeritorySelect.SelectedValue;
        }
        DataTable aTable = aReportDal.Get_Dactor_Information_Details(txtFromDate.Text, txtTodate.Text, Zone, Area, Teritory, "");


        if (aTable.Rows.Count > 0)
        {
            MIOWISE.Visible = false;
            PPOVIDERWISE.Visible = false;
            Details.Visible = true;
            DocWise.Visible = false;

            GridView3.DataSource = null;

            GridView3.DataSource = aTable;
            GridView3.DataBind();

            
                try
                {
                    



                    int _1_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("1_DCP") == null ? 0 : row.Field<int>("1_DCP"));
                    int _1_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("1_DCR") == null ? 0 : row.Field<int>("1_DCR"));
                    int _1_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("1_RX") == null ? 0 : row.Field<int>("1_RX"));

                    int _2_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("2_DCP") == null ? 0 : row.Field<int>("2_DCP"));
                    int _2_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("2_DCR") == null ? 0 : row.Field<int>("2_DCR"));
                    int _2_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("2_RX") == null ? 0 : row.Field<int>("2_RX"));



                    int _3_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("3_DCP") == null ? 0 : row.Field<int>("3_DCP"));
                    int _3_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("3_DCR") == null ? 0 : row.Field<int>("3_DCR"));
                    int _3_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("3_RX") == null ? 0 : row.Field<int>("3_RX"));


                    int _4_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("4_DCP") == null ? 0 : row.Field<int>("4_DCP"));
                    int _4_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("4_DCR") == null ? 0 : row.Field<int>("4_DCR"));
                    int _4_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("4_RX") == null ? 0 : row.Field<int>("4_RX"));


                    int _5_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("5_DCP") == null ? 0 : row.Field<int>("5_DCP"));
                    int _5_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("5_DCR") == null ? 0 : row.Field<int>("5_DCR"));
                    int _5_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("5_RX") == null ? 0 : row.Field<int>("5_RX"));


                    int _6_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("6_DCP") == null ? 0 : row.Field<int>("6_DCP"));
                    int _6_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("6_DCR") == null ? 0 : row.Field<int>("6_DCR"));
                    int _6_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("6_RX") == null ? 0 : row.Field<int>("6_RX"));


                    int _7_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("7_DCP") == null ? 0 : row.Field<int>("7_DCP"));
                    int _7_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("7_DCR") == null ? 0 : row.Field<int>("7_DCR"));
                    int _7_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("7_RX") == null ? 0 : row.Field<int>("7_RX"));


                    int _8_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("8_DCP") == null ? 0 : row.Field<int>("8_DCP"));
                    int _8_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("8_DCR") == null ? 0 : row.Field<int>("8_DCR"));
                    int _8_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("8_RX") == null ? 0 : row.Field<int>("8_RX"));


                    int _9_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("9_DCP") == null ? 0 : row.Field<int>("9_DCP"));
                    int _9_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("9_DCR") == null ? 0 : row.Field<int>("9_DCR"));
                    int _9_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("9_RX") == null ? 0 : row.Field<int>("9_RX"));


                    int _10_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("10_DCP") == null ? 0 : row.Field<int>("10_DCP"));
                    int _10_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("10_DCR") == null ? 0 : row.Field<int>("10_DCR"));
                    int _10_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("10_RX") == null ? 0 : row.Field<int>("10_RX"));


                    int _11_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("11_DCP") == null ? 0 : row.Field<int>("11_DCP"));
                    int _11_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("11_DCR") == null ? 0 : row.Field<int>("11_DCR"));
                    int _11_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("11_RX") == null ? 0 : row.Field<int>("11_RX"));


                    int _12_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("12_DCP") == null ? 0 : row.Field<int>("12_DCP"));
                    int _12_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("12_DCR") == null ? 0 : row.Field<int>("12_DCR"));
                    int _12_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("12_RX") == null ? 0 : row.Field<int>("12_RX"));


                    int _13_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("13_DCP") == null ? 0 : row.Field<int>("13_DCP"));
                    int _13_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("13_DCR") == null ? 0 : row.Field<int>("13_DCR"));
                    int _13_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("13_RX") == null ? 0 : row.Field<int>("13_RX"));


                    int _14_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("14_DCP") == null ? 0 : row.Field<int>("14_DCP"));
                    int _14_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("14_DCR") == null ? 0 : row.Field<int>("14_DCR"));
                    int _14_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("14_RX") == null ? 0 : row.Field<int>("14_RX"));


                    int _15_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("15_DCP") == null ? 0 : row.Field<int>("15_DCP"));
                    int _15_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("15_DCR") == null ? 0 : row.Field<int>("15_DCR"));
                    int _15_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("15_RX") == null ? 0 : row.Field<int>("15_RX"));


                    int _16_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("16_DCP") == null ? 0 : row.Field<int>("16_DCP"));
                    int _16_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("16_DCR") == null ? 0 : row.Field<int>("16_DCR"));
                    int _16_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("16_RX") == null ? 0 : row.Field<int>("16_RX"));


                    int _17_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("17_DCP") == null ? 0 : row.Field<int>("17_DCP"));
                    int _17_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("17_DCR") == null ? 0 : row.Field<int>("17_DCR"));
                    int _17_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("17_RX") == null ? 0 : row.Field<int>("17_RX"));


                    int _18_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("18_DCP") == null ? 0 : row.Field<int>("18_DCP"));
                    int _18_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("18_DCR") == null ? 0 : row.Field<int>("18_DCR"));
                    int _18_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("18_RX") == null ? 0 : row.Field<int>("18_RX"));


                    int _19_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("19_DCP") == null ? 0 : row.Field<int>("19_DCP"));
                    int _19_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("19_DCR") == null ? 0 : row.Field<int>("19_DCR"));
                    int _19_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("19_RX") == null ? 0 : row.Field<int>("19_RX"));


                    int _20_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("20_DCP") == null ? 0 : row.Field<int>("20_DCP"));
                    int _20_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("20_DCR") == null ? 0 : row.Field<int>("20_DCR"));
                    int _20_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("20_RX") == null ? 0 : row.Field<int>("20_RX"));


                    int _21_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("21_DCP") == null ? 0 : row.Field<int>("21_DCP"));
                    int _21_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("21_DCR") == null ? 0 : row.Field<int>("21_DCR"));
                    int _21_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("21_RX") == null ? 0 : row.Field<int>("21_RX"));


                    int _22_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("22_DCP") == null ? 0 : row.Field<int>("22_DCP"));
                    int _22_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("22_DCR") == null ? 0 : row.Field<int>("22_DCR"));
                    int _22_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("22_RX") == null ? 0 : row.Field<int>("22_RX"));


                    int _23_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("23_DCP") == null ? 0 : row.Field<int>("23_DCP"));
                    int _23_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("23_DCR") == null ? 0 : row.Field<int>("23_DCR"));
                    int _23_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("23_RX") == null ? 0 : row.Field<int>("23_RX"));


                    int _24_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("24_DCP") == null ? 0 : row.Field<int>("24_DCP"));
                    int _24_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("24_DCR") == null ? 0 : row.Field<int>("24_DCR"));
                    int _24_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("24_RX") == null ? 0 : row.Field<int>("24_RX"));


                    int _25_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("25_DCP") == null ? 0 : row.Field<int>("25_DCP"));
                    int _25_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("25_DCR") == null ? 0 : row.Field<int>("25_DCR"));
                    int _25_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("25_RX") == null ? 0 : row.Field<int>("25_RX"));


                    int _26_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("26_DCP") == null ? 0 : row.Field<int>("26_DCP"));
                    int _26_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("26_DCR") == null ? 0 : row.Field<int>("26_DCR"));
                    int _26_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("26_RX") == null ? 0 : row.Field<int>("26_RX"));


                    int _27_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("27_DCP") == null ? 0 : row.Field<int>("27_DCP"));
                    int _27_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("27_DCR") == null ? 0 : row.Field<int>("27_DCR"));
                    int _27_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("27_RX") == null ? 0 : row.Field<int>("27_RX"));


                    int _28_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("28_DCP") == null ? 0 : row.Field<int>("28_DCP"));
                    int _28_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("28_DCR") == null ? 0 : row.Field<int>("28_DCR"));
                    int _28_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("28_RX") == null ? 0 : row.Field<int>("28_RX"));


                    int _29_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("29_DCP") == null ? 0 : row.Field<int>("29_DCP"));
                    int _29_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("29_DCR") == null ? 0 : row.Field<int>("29_DCR"));
                    int _29_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("29_RX") == null ? 0 : row.Field<int>("29_RX"));


                    int _30_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("30_DCP") == null ? 0 : row.Field<int>("30_DCP"));
                    int _30_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("30_DCR") == null ? 0 : row.Field<int>("30_DCR"));
                    int _30_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("30_RX") == null ? 0 : row.Field<int>("30_RX"));


                    int _31_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("31_DCP") == null ? 0 : row.Field<int>("31_DCP"));
                    int _31_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("31_DCR") == null ? 0 : row.Field<int>("31_DCR"));
                    int _31_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("31_RX") == null ? 0 : row.Field<int>("31_RX"));


                int to_DCP = aTable.AsEnumerable().Sum(row => row.Field<int?>("to_DCP") == null ? 0 : row.Field<int>("to_DCP"));
                int to_DCR = aTable.AsEnumerable().Sum(row => row.Field<int?>("to_DCR") == null ? 0 : row.Field<int>("to_DCR"));
                int to_RX = aTable.AsEnumerable().Sum(row => row.Field<int?>("to_RX") == null ? 0 : row.Field<int>("to_RX"));



                GridView3.FooterRow.Cells[9].Text = "Total: ";

                    GridView3.FooterRow.Cells[10].Text = _1_DCP.ToString("");
                   GridView3.FooterRow.Cells[11].Text = _1_DCR.ToString("");
                   GridView3.FooterRow.Cells[12].Text = _1_RX.ToString("");
                 

                GridView3.FooterRow.Cells[13].Text = _2_DCP.ToString("");
                GridView3.FooterRow.Cells[14].Text = _2_DCR.ToString("");
                GridView3.FooterRow.Cells[15].Text = _2_RX.ToString("");


                GridView3.FooterRow.Cells[16].Text = _3_DCP.ToString("");
                GridView3.FooterRow.Cells[17].Text = _3_DCR.ToString("");
                GridView3.FooterRow.Cells[18].Text = _3_RX.ToString("");



                GridView3.FooterRow.Cells[19].Text = _4_DCP.ToString("");
                GridView3.FooterRow.Cells[20].Text = _4_DCR.ToString("");
                GridView3.FooterRow.Cells[21].Text = _4_RX.ToString("");



                GridView3.FooterRow.Cells[22].Text = _5_DCP.ToString("");
                GridView3.FooterRow.Cells[23].Text = _5_DCR.ToString("");
                GridView3.FooterRow.Cells[24].Text = _5_RX.ToString("");



                GridView3.FooterRow.Cells[25].Text = _6_DCP.ToString("");
                GridView3.FooterRow.Cells[26].Text = _6_DCR.ToString("");
                GridView3.FooterRow.Cells[27].Text = _6_RX.ToString("");


                GridView3.FooterRow.Cells[28].Text = _7_DCP.ToString("");
                GridView3.FooterRow.Cells[29].Text = _7_DCR.ToString("");
                GridView3.FooterRow.Cells[30].Text = _7_RX.ToString("");


                GridView3.FooterRow.Cells[31].Text = _8_DCP.ToString("");
                GridView3.FooterRow.Cells[32].Text = _8_DCR.ToString("");
                GridView3.FooterRow.Cells[33].Text = _8_RX.ToString("");

                GridView3.FooterRow.Cells[34].Text = _9_DCP.ToString("");
                GridView3.FooterRow.Cells[35].Text = _9_DCR.ToString("");
                GridView3.FooterRow.Cells[36].Text = _9_RX.ToString("");


                GridView3.FooterRow.Cells[37].Text = _10_DCP.ToString("");
                GridView3.FooterRow.Cells[38].Text = _10_DCR.ToString("");
                GridView3.FooterRow.Cells[39].Text = _10_RX.ToString("");


                GridView3.FooterRow.Cells[40].Text = _11_DCP.ToString("");
                GridView3.FooterRow.Cells[41].Text = _11_DCR.ToString("");
                GridView3.FooterRow.Cells[42].Text = _11_RX.ToString("");

                GridView3.FooterRow.Cells[43].Text = _12_DCP.ToString("");
                GridView3.FooterRow.Cells[44].Text = _12_DCR.ToString("");
                GridView3.FooterRow.Cells[45].Text = _12_RX.ToString("");

                GridView3.FooterRow.Cells[46].Text = _13_DCP.ToString("");
                GridView3.FooterRow.Cells[47].Text = _13_DCR.ToString("");
                GridView3.FooterRow.Cells[48].Text = _13_RX.ToString("");

                GridView3.FooterRow.Cells[49].Text = _14_DCP.ToString("");
                GridView3.FooterRow.Cells[50].Text = _14_DCR.ToString("");
                GridView3.FooterRow.Cells[51].Text = _14_RX.ToString("");



                GridView3.FooterRow.Cells[52].Text = _15_DCP.ToString("");
                GridView3.FooterRow.Cells[53].Text = _15_DCR.ToString("");
                GridView3.FooterRow.Cells[54].Text = _15_RX.ToString("");

                GridView3.FooterRow.Cells[55].Text = _16_DCP.ToString("");
                GridView3.FooterRow.Cells[56].Text = _16_DCR.ToString("");
                GridView3.FooterRow.Cells[57].Text = _16_RX.ToString("");

                GridView3.FooterRow.Cells[58].Text = _17_DCP.ToString("");
                GridView3.FooterRow.Cells[59].Text = _17_DCR.ToString("");
                GridView3.FooterRow.Cells[60].Text = _17_RX.ToString("");

                GridView3.FooterRow.Cells[61].Text = _18_DCP.ToString("");
                GridView3.FooterRow.Cells[62].Text = _18_DCR.ToString("");
                GridView3.FooterRow.Cells[63].Text = _18_RX.ToString("");

                GridView3.FooterRow.Cells[64].Text = _19_DCP.ToString("");
                GridView3.FooterRow.Cells[65].Text = _19_DCR.ToString("");
                GridView3.FooterRow.Cells[66].Text = _19_RX.ToString("");

                GridView3.FooterRow.Cells[67].Text = _20_DCP.ToString("");
                GridView3.FooterRow.Cells[68].Text = _20_DCR.ToString("");
                GridView3.FooterRow.Cells[69].Text = _20_RX.ToString("");

                GridView3.FooterRow.Cells[70].Text = _21_DCP.ToString("");
                GridView3.FooterRow.Cells[71].Text = _21_DCR.ToString("");
                GridView3.FooterRow.Cells[72].Text = _21_RX.ToString("");

                GridView3.FooterRow.Cells[73].Text = _22_DCP.ToString("");
                GridView3.FooterRow.Cells[74].Text = _22_DCR.ToString("");
                GridView3.FooterRow.Cells[75].Text = _22_RX.ToString("");

                GridView3.FooterRow.Cells[76].Text = _23_DCP.ToString("");
                GridView3.FooterRow.Cells[77].Text = _23_DCR.ToString("");
                GridView3.FooterRow.Cells[78].Text = _23_RX.ToString("");

                GridView3.FooterRow.Cells[79].Text = _24_DCP.ToString("");
                GridView3.FooterRow.Cells[80].Text = _24_DCR.ToString("");
                GridView3.FooterRow.Cells[81].Text = _24_RX.ToString("");

                GridView3.FooterRow.Cells[82].Text = _25_DCP.ToString("");
                GridView3.FooterRow.Cells[83].Text = _25_DCR.ToString("");
                GridView3.FooterRow.Cells[84].Text = _25_RX.ToString("");

                GridView3.FooterRow.Cells[85].Text = _26_DCP.ToString("");
                GridView3.FooterRow.Cells[86].Text = _26_DCR.ToString("");
                GridView3.FooterRow.Cells[87].Text = _26_RX.ToString("");

                GridView3.FooterRow.Cells[88].Text = _27_DCP.ToString("");
                GridView3.FooterRow.Cells[89].Text = _27_DCR.ToString("");
                GridView3.FooterRow.Cells[90].Text = _27_RX.ToString("");

                GridView3.FooterRow.Cells[91].Text = _28_DCP.ToString("");
                GridView3.FooterRow.Cells[92].Text = _28_DCR.ToString("");
                GridView3.FooterRow.Cells[93].Text = _28_RX.ToString("");

                GridView3.FooterRow.Cells[94].Text = _29_DCP.ToString("");
                GridView3.FooterRow.Cells[95].Text = _29_DCR.ToString("");
                GridView3.FooterRow.Cells[96].Text = _29_RX.ToString("");


                GridView3.FooterRow.Cells[97].Text = _30_DCP.ToString("");
                GridView3.FooterRow.Cells[98].Text = _30_DCR.ToString("");
                GridView3.FooterRow.Cells[99].Text = _30_RX.ToString("");

                GridView3.FooterRow.Cells[100].Text = _31_DCP.ToString("");
                GridView3.FooterRow.Cells[101].Text = _31_DCR.ToString("");
                GridView3.FooterRow.Cells[102].Text = _31_RX.ToString("");


                GridView3.FooterRow.Cells[103].Text = to_DCP.ToString("");
                GridView3.FooterRow.Cells[104].Text = to_DCR.ToString("");
                GridView3.FooterRow.Cells[105].Text = to_RX.ToString("");

                GridView3.FooterRow.BackColor = System.Drawing.Color.Beige;
                    GridView3.FooterRow.Font.Bold = true;
                }
                catch { }

            }





        



    }

    private string GenerateParam()
    {

        string param = "";

        


        return param;
    }






    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        try
        {
            string Type = "";
            if (rbReportTypeName.Items[1].Selected)
            {

                if (F_ZoneSelect.SelectedValue != "")
                {

                    if (chkDownload.Checked)
                    {
                        Type = "Details SMC Family Doctor Report";

                        string attachment = "attachment; filename=" + Type + " " + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
                        Response.ClearContent();
                        Response.AddHeader("content-disposition", attachment);
                        Response.ContentType = "application/ms-excel";
                        StringWriter sw = new StringWriter();
                        HtmlTextWriter htw = new HtmlTextWriter(sw);




                        Get_Doctor_Information_Details();

                        // Create a form to contain the grid  
                        HtmlForm frm = new HtmlForm();
                        GridView3.Parent.Controls.Add(frm);
                        //frm.Attributes["runat"] = "server";
                        //frm.Controls.Add(gv_DistributionCenter);
                        //frm.RenderControl(htw);






                        GridView3.RenderControl(htw);


                        string headerTable = @"<span  style='text-align:center'><h3>" + Type + "    (Date Range : " + txtFromDate.Text + "- " + txtTodate.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

                        HttpContext.Current.Response.Write(headerTable);

                        Response.Write(sw.ToString());
                        Response.End();

                        GridView3.DataSource = null;
                        GridView3.DataBind();

                    }
                    else
                    {
                        Type = "Details SMC Family Doctor Report";

                        string attachment = "attachment; filename=" + Type + " " + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
                        Response.ClearContent();
                        Response.AddHeader("content-disposition", attachment);
                        Response.ContentType = "application/ms-excel";
                        StringWriter sw = new StringWriter();
                        HtmlTextWriter htw = new HtmlTextWriter(sw);




                        //    Get_Doctor_Information_Details();

                        // Create a form to contain the grid  
                        HtmlForm frm = new HtmlForm();
                        GridView3.Parent.Controls.Add(frm);
                        //frm.Attributes["runat"] = "server";
                        //frm.Controls.Add(gv_DistributionCenter);
                        //frm.RenderControl(htw);






                        GridView3.RenderControl(htw);


                        string headerTable = @"<span  style='text-align:center'><h3>" + Type + "    (Date Range : " + txtFromDate.Text + "- " + txtTodate.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

                        HttpContext.Current.Response.Write(headerTable);

                        Response.Write(sw.ToString());
                        Response.End();



                    }
                }

                else
                {
                    showMessageBox("Please Select Zone!!");

                }
            }
            else
            {
                if(rdoAnotherReport.SelectedValue == "Zone") { 
                Type = " Zone Wise SMC Family Doctor Report";

                string attachment = "attachment; filename=" + Type + " " + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
                Response.ClearContent();
                Response.AddHeader("content-disposition", attachment);
                Response.ContentType = "application/ms-excel";
                StringWriter sw = new StringWriter();
                HtmlTextWriter htw = new HtmlTextWriter(sw);




                //    Get_Doctor_Information_Details();

                // Create a form to contain the grid  
                HtmlForm frm = new HtmlForm();
                gv_Zone.Parent.Controls.Add(frm);
                    //frm.Attributes["runat"] = "server";
                    //frm.Controls.Add(gv_DistributionCenter);
                    //frm.RenderControl(htw);






                    gv_Zone.RenderControl(htw);


                string headerTable = @"<span  style='text-align:center'><h3>" + Type + "    (Date Range : " + txtFromDate.Text + "- " + txtTodate.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

                HttpContext.Current.Response.Write(headerTable);

                Response.Write(sw.ToString());
                Response.End();

                }


                if (rdoAnotherReport.SelectedValue == "Area")
                {
                    Type = " Area Wise SMC Family Doctor Report";

                    string attachment = "attachment; filename=" + Type + " " + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
                    Response.ClearContent();
                    Response.AddHeader("content-disposition", attachment);
                    Response.ContentType = "application/ms-excel";
                    StringWriter sw = new StringWriter();
                    HtmlTextWriter htw = new HtmlTextWriter(sw);




                    //    Get_Doctor_Information_Details();

                    // Create a form to contain the grid  
                    HtmlForm frm = new HtmlForm();
                    gv_Area.Parent.Controls.Add(frm);
                    //frm.Attributes["runat"] = "server";
                    //frm.Controls.Add(gv_DistributionCenter);
                    //frm.RenderControl(htw);






                    gv_Area.RenderControl(htw);


                    string headerTable = @"<span  style='text-align:center'><h3>" + Type + "    (Date Range : " + txtFromDate.Text + "- " + txtTodate.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

                    HttpContext.Current.Response.Write(headerTable);

                    Response.Write(sw.ToString());
                    Response.End();

                }


                if (rdoAnotherReport.SelectedValue == "MIO")
                {
                    Type = " MIO Wise SMC Family Doctor Report";

                    string attachment = "attachment; filename=" + Type + " " + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
                    Response.ClearContent();
                    Response.AddHeader("content-disposition", attachment);
                    Response.ContentType = "application/ms-excel";
                    StringWriter sw = new StringWriter();
                    HtmlTextWriter htw = new HtmlTextWriter(sw);




                    //    Get_Doctor_Information_Details();

                    // Create a form to contain the grid  
                    HtmlForm frm = new HtmlForm();
                    GridView1.Parent.Controls.Add(frm);
                    //frm.Attributes["runat"] = "server";
                    //frm.Controls.Add(gv_DistributionCenter);
                    //frm.RenderControl(htw);






                    GridView1.RenderControl(htw);


                    string headerTable = @"<span  style='text-align:center'><h3>" + Type + "    (Date Range : " + txtFromDate.Text + "- " + txtTodate.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

                    HttpContext.Current.Response.Write(headerTable);

                    Response.Write(sw.ToString());
                    Response.End();

                }


                 if (rdoAnotherReport.SelectedValue == "Doctor")
                {
                    Type = "Doctor Wise SMC Family Doctor Report";

                    string attachment = "attachment; filename=" + Type + " " + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
                    Response.ClearContent();
                    Response.AddHeader("content-disposition", attachment);
                    Response.ContentType = "application/ms-excel";
                    StringWriter sw = new StringWriter();
                    HtmlTextWriter htw = new HtmlTextWriter(sw);




                    //    Get_Doctor_Information_Details();

                    // Create a form to contain the grid  
                    HtmlForm frm = new HtmlForm();
                    GridView2.Parent.Controls.Add(frm);
                    //frm.Attributes["runat"] = "server";
                    //frm.Controls.Add(gv_DistributionCenter);
                    //frm.RenderControl(htw);






                    GridView2.RenderControl(htw);


                    string headerTable = @"<span  style='text-align:center'><h3>" + Type + "    (Date Range : " + txtFromDate.Text + "- " + txtTodate.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

                    HttpContext.Current.Response.Write(headerTable);

                    Response.Write(sw.ToString());
                    Response.End();

                }

            }


        }
        catch
        {
            showMessageBox("No Data Found!!");
        }
        //if (loadGridView.Rows.Count > 0)
        //{
        //    string Type = "";
        //    if (rbType.Items[0].Selected)
        //    {
        //        Type = "DCR";
        //    }
        //    else
        //    {
        //        Type = "RX";
        //    }

        //    string attachment = "attachment; filename="+ Type + "_Doctor_Wise_" + DateTime.Now.ToLongDateString()+".xls";
        //    Response.ClearContent();
        //    Response.AddHeader("content-disposition", attachment);
        //    Response.ContentType = "application/ms-excel";
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter htw = new HtmlTextWriter(sw);

        //    loadGridView.AllowPaging = false;



        //    //loadGridView.Columns[loadGridView.Columns.Count - 1].Visible =
        //    //            false;
        //    //loadGridView.Columns[loadGridView.Columns.Count - 2].Visible =
        //    //   false;
        //    //loadGridView.Columns[loadGridView.Columns.Count - 3].Visible =
        //    //   false;


        //    // Create a form to contain the grid  
        //    HtmlForm frm = new HtmlForm();
        //    loadGridView.Parent.Controls.Add(frm);
        //    //frm.Attributes["runat"] = "server";
        //    //frm.Controls.Add(loadGridView);
        //    //frm.RenderControl(htw);

        //    loadGridView.HeaderRow.Style.Add("background-color", "#E5EEF1");

        //    // Set background color of each cell of GridView1 header row
        //    foreach (TableCell tableCell in loadGridView.HeaderRow.Cells)
        //    {
        //        tableCell.Style["background-color"] = "#E5EEF1";
        //    }

        //    // Set background color of each cell of each data row of GridView1
        //    foreach (GridViewRow gridViewRow in loadGridView.Rows)
        //    {
        //        gridViewRow.BackColor = System.Drawing.Color.White;

        //        foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
        //        {
        //            gridViewRowTableCell.Style["background-color"] = "#FFFFFF";

        //        }
        //    }

        //    loadGridView.RenderControl(htw);
        //    string headerTable = @"<span  style='text-align:left'><h3> "+ Type + " Doctor Wise List of Month: " + ddlmonth.SelectedItem.Text +
        //                         ", Year: "+ddlYear.SelectedValue+"</h3>  ";



        //    HttpContext.Current.Response.Write(headerTable);

        //    string style = @"<style> .text { mso-number-format:\@; } </style> ";
        //    Response.Write(style);
        //    Response.Write(sw.ToString());
        //    Response.End();
        //}
        //else
        //{
        //    showMessageBox("No Data Found!!");
        //}
    }

    public override void VerifyRenderingInServerForm(Control control)
    {
        //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
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
        Response.Redirect("DoctorInfoReport.aspx");
    }

    protected void rbType_SelectedIndexChanged(object sender, EventArgs e)
    {
        //loadGridView.DataSource = null;
        //loadGridView.DataBind();
    }

    protected void rbReportTypeName_SelectedIndexChanged(object sender, EventArgs e)
    {
        //loadGridView.DataSource = null;
        //loadGridView.DataBind();
        //data.InnerHtml = "";

        chkDownload.Checked = false;
        F_ZoneSelect.SelectedValue=null;
        F_AreaSelect.Items.Clear();
        F_TeritorySelect.Items.Clear();

        loadGridView.DataSource = null;
        loadGridView.DataBind();

        GridView1.DataSource = null;
        GridView1.DataBind();

        GridView2.DataSource = null;
        GridView2.DataBind();

        GridView3.DataSource = null;
        GridView3.DataBind();

        gv_Zone.DataSource = null;
        gv_Zone.DataBind();
        MarketSt.Visible = false;
        divCChk.Visible = false;


        if (rbReportTypeName.SelectedValue == "1")
        {
            OtherReport.Visible = true;
        }
        else
        {
            divCChk.Visible = true;

            MarketSt.Visible = true;

            OtherReport.Visible = false;

            divZone.Visible = true;
            divArea.Visible = true;
            divTerritory.Visible = true;
        }
    }

    protected void rdoAnotherReport_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        divCChk.Visible = false;
        chkDownload.Checked = false;
        F_ZoneSelect.SelectedValue = null;
        F_AreaSelect.Items.Clear();
        F_TeritorySelect.Items.Clear();


        loadGridView.DataSource = null;
        loadGridView.DataBind();

        GridView1.DataSource = null;
        GridView1.DataBind();

        GridView2.DataSource = null;
        GridView2.DataBind();

        GridView3.DataSource = null;
        GridView3.DataBind();

        gv_Zone.DataSource = null;
        gv_Zone.DataBind();


        gv_Area.DataSource = null;
        gv_Area.DataBind();

        divZone.Visible = false;
        divArea.Visible = false;
        divTerritory.Visible = false;

        if (rdoAnotherReport.SelectedValue == "MIO"  || rdoAnotherReport.SelectedValue == "Zone" || rdoAnotherReport.SelectedValue == "Area" || rdoAnotherReport.SelectedValue == "Doctor")
        {
            MarketSt.Visible = true;

            if(rdoAnotherReport.SelectedValue == "Zone")
            {
                divZone.Visible = true;
            }

            if (rdoAnotherReport.SelectedValue == "Area")
            {
                divZone.Visible = true;
                divArea.Visible = true;
            }


            if (rdoAnotherReport.SelectedValue == "MIO")
            {
                divZone.Visible = true;
                divArea.Visible = true;
                divTerritory.Visible = true;

            }

            if (rdoAnotherReport.SelectedValue == "Doctor")
            {
                divZone.Visible = true;
                divArea.Visible = true;
                divTerritory.Visible = true;

            }

        }
        else
        {
            divZone.Visible = true;
            divArea.Visible = true;
            divTerritory.Visible = true;

        }
    }

    protected void GridView1_OnRowCreated(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.Header)
        {
            GridView HeaderGrid = (GridView)sender;
            GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);
            TableCell HeaderCell = new TableCell();
            HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");
            HeaderCell.ColumnSpan = 5;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Total Doctor";
            HeaderCell.ColumnSpan = 6;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.DeepSkyBlue;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 1";
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderCell.ColumnSpan = 5;
            //  HeaderCell.BackColor = Color.Red;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 2";
            //HeaderCell.BackColor = Color.GreenYellow;
            HeaderCell.ColumnSpan = 5;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 3";
            HeaderCell.Font.Bold = true;
            HeaderCell.ColumnSpan = 5;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 4";
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;

            HeaderCell.ColumnSpan = 5;
            HeaderGridRow.Cells.Add(HeaderCell);


            GridView1.Controls[0].Controls.AddAt(0, HeaderGridRow);

            
        }
        
    }



    protected void gv_Zone_OnRowCreated(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.Header)
        {
            GridView HeaderGrid = (GridView)sender;
            GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);
            TableCell HeaderCell = new TableCell();
            HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");
            HeaderCell.ColumnSpan = 2;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Total Doctor";
            HeaderCell.ColumnSpan =7;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.DeepSkyBlue;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 1";
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderCell.ColumnSpan = 5;
            //  HeaderCell.BackColor = Color.Red;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 2";
            //HeaderCell.BackColor = Color.GreenYellow;
            HeaderCell.ColumnSpan = 5;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 3";
            HeaderCell.Font.Bold = true;
            HeaderCell.ColumnSpan = 5;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 4";
             HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;

            HeaderCell.ColumnSpan = 5;
            HeaderGridRow.Cells.Add(HeaderCell);


            gv_Zone.Controls[0].Controls.AddAt(0, HeaderGridRow);

        }

    }



    protected void gv_Area_OnRowCreated(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.Header)
        {
            GridView HeaderGrid = (GridView)sender;
            GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);
            TableCell HeaderCell = new TableCell();
            HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");
            HeaderCell.ColumnSpan = 3;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Total Doctor";
            HeaderCell.ColumnSpan = 7;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.DeepSkyBlue;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 1";
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderCell.ColumnSpan = 5;
            //  HeaderCell.BackColor = Color.Red;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 2";
            //HeaderCell.BackColor = Color.GreenYellow;
            HeaderCell.ColumnSpan = 5;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 3";
            HeaderCell.Font.Bold = true;
            HeaderCell.ColumnSpan = 5;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 4";
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;

            HeaderCell.ColumnSpan = 5;
            HeaderGridRow.Cells.Add(HeaderCell);


            gv_Area.Controls[0].Controls.AddAt(0, HeaderGridRow);

        }

    }

    protected void GridView2_OnRowCreated(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.Header)
        {
            GridView HeaderGrid = (GridView)sender;
            GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);
            TableCell HeaderCell = new TableCell();
            HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");
            HeaderCell.ColumnSpan = 13;
            HeaderGridRow.Cells.Add(HeaderCell);

    
            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 1";
            HeaderCell.ColumnSpan = 3;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //  HeaderCell.BackColor = Color.Red;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 2";
            //HeaderCell.BackColor = Color.GreenYellow;
            HeaderCell.ColumnSpan = 3;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 3";
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Week 4";
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);


            GridView2.Controls[0].Controls.AddAt(0, HeaderGridRow);

        }
    }

    protected void GridView3_OnRowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            GridView HeaderGrid = (GridView)sender;
            GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);
            TableCell HeaderCell = new TableCell();
            HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");
            HeaderCell.ColumnSpan = 10;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = " 1 ";
            HeaderCell.ColumnSpan = 3;
            //  HeaderCell.BackColor = Color.Red;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = " 2 ";
            //HeaderCell.BackColor = Color.GreenYellow;
            HeaderCell.ColumnSpan = 3;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = " 3 ";
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = " 4 ";
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);




            HeaderCell = new TableCell();
            HeaderCell.Text = " 5 ";
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 6 ";
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 7 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 8 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 9 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 10 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 11 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 12 ";
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 13 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 14 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 15 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 16 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 17 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 18 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 19 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 20 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);




            HeaderCell = new TableCell();
            HeaderCell.Text = " 21 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 22 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 23 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 24 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 25 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 26 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 27 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 28 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = " 29 "; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 30 ";
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = " 31 ";
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            HeaderGridRow.Cells.Add(HeaderCell);






            HeaderCell = new TableCell();
            HeaderCell.Text = "Total"; HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.Font.Bold = true;
            //HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);

            GridView3.Controls[0].Controls.AddAt(0, HeaderGridRow);

        }
    }
}