using Library.DAL.ChartDAL;
using Library.DAO.MasterSetup_DAO;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Dashboard_UI_AdminDashboard : System.Web.UI.Page
{

    static ChartDAL aChartDal = new ChartDAL();
    private CommonDataLoad _CmnLoad = new CommonDataLoad();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                 UserPersmissionValidation();
            }
            catch { Response.Redirect("../Dashboard_UI/DashboardOne.aspx"); }
        }
    }
    public void UserPersmissionValidation()
    {

        try
        {
            if (Session["UserRoleID"].ToString() != "2")
            {
                try
                {
                    string filepath = Path.GetDirectoryName(Request.Path);
                    filepath = filepath.TrimStart('\\');
                    string text = Path.GetExtension(Request.Path);
                    filepath = "../" + filepath + "/" + Path.GetFileName(Request.Path);
                    DataTable dtuserpermission = _CmnLoad.GetPermissionForUserRole(filepath);
                    if (dtuserpermission.Rows.Count > 0)
                    {
                        if (Session["UserRoleID"].ToString() != "2")
                        {
                            //btnEntry.Visible = Convert.ToBoolean(dtuserpermission.Rows[0]["RAdd"].ToString());
                            //loadGridView.Columns[loadGridView.Columns.Count - 1].Visible =
                            //    Convert.ToBoolean(dtuserpermission.Rows[0]["REdit"].ToString());


                        }
                    }
                    else
                    {
                        Response.Redirect("../Dashboard_UI/DashboardOne.aspx");
                    }
                }
                catch (Exception ex)
                {
                    Response.Redirect("../Dashboard_UI/DashboardOne.aspx");
                }
            }
        }
        catch (Exception ex)
        {
            Response.Redirect("../Login.aspx");
        }
    }

    //public static string GetSalesChartData()
    //{
    //    DataTable dtdata=new DataTable();
    //    dtdata.Columns.Add("Criteria");
    //    dtdata.Columns.Add("Oct21");
    //    dtdata.Columns.Add("Oct21(upto28th)");
    //    dtdata.Columns.Add("Nov21(upto28th)");
    //    dtdata.Columns.Add("Total");

    //    DataRow dataRow = null;

    //    dataRow = dtdata.NewRow();
    //    dataRow["Criteria"] = "Campaign Sales";
    //    dataRow["Oct21"] = "1.15";
    //    dataRow["Oct21(upto28th)"] = "1.12";
    //    dataRow["Nov21(upto28th)"] = "1.32";
    //    dataRow["Total"] = "2.47";
    //    dtdata.Rows.Add(dataRow);

    //    dataRow = dtdata.NewRow();
    //    dataRow["Criteria"] = "General Sales";
    //    dataRow["Oct21"] = "0.72";
    //    dataRow["Oct21(upto28th)"] = "0.65";
    //    dataRow["Nov21(upto28th)"] = "1.24";
    //    dataRow["Total"] = "1.96";
    //    dtdata.Rows.Add(dataRow);


    //    dataRow = dtdata.NewRow();
    //    dataRow["Criteria"] = "FCB Sales";
    //    dataRow["Oct21"] = "1.08";
    //    dataRow["Oct21(upto28th)"] = "1";
    //    dataRow["Nov21(upto28th)"] = "1.42";
    //    dataRow["Total"] = "2.5";
    //    dtdata.Rows.Add(dataRow);


    //    dataRow = dtdata.NewRow();
    //    dataRow["Criteria"] = "Institution";
    //    dataRow["Oct21"] = "0.5";
    //    dataRow["Oct21(upto28th)"] = "0.5";
    //    dataRow["Nov21(upto28th)"] = "0.02";
    //    dataRow["Total"] = "0.52";
    //    dtdata.Rows.Add(dataRow);

    //    dataRow = dtdata.NewRow();
    //    dataRow["Criteria"] = "Total Sales";
    //    dataRow["Oct21"] = "1.37";
    //    dataRow["Oct21(upto28th)"] = "1.25";
    //    dataRow["Nov21(upto28th)"] = "1.26";
    //    dataRow["Total"] = "2.63";
    //    dtdata.Rows.Add(dataRow);

    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dtdata);
    //    return JSONresult;

    //}


    [WebMethod]
    public static string Get_DeptoWiseOrder(string param)
    {
   
        DataTable dt = aChartDal.GetDeptoWiseOrderDAL(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return  JSONresult;
    }

    [WebMethod]
    public static string Get_DeptoWiseInvoice(string param)
    {

        DataTable dt = aChartDal.Get_DeptoWiseInvoiceDAL(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }


    [WebMethod]
    public static string Get_TopBarChartOrder(string param)
    {

        DataTable dt = aChartDal.Get_TopBarChartOrderDAL();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }


    [WebMethod]
    public static string Get_TopBarChartDeliveryAmount(string param)
    {

        DataTable dt = aChartDal.Get_TopBarChartDeliveryAmountDAL();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }


    [WebMethod]
    public static string Get_TopBarChartRejectionAmount(string param)
    {

        DataTable dt = aChartDal.Get_TopBarChartRejectionAmountDAL();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }


    [WebMethod]
    public static string Get_TopBarChartDCR(string param)
    {

        DataTable dt = aChartDal.Get_TopBarChartDCRDAL();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]
    public static string Get_TopBarChartTotalRX(string param)
    {

        DataTable dt = aChartDal.Get_TopBarChartTotalRXDAL();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]
    public static string Get_TopBarChartTotalAttandence(string param)
    {

        DataTable dt = aChartDal.Get_TopBarChartTotalAttandenceDAL();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]
    public static string Get_TopBarChartCustomerCoverage(string param)
    {

        DataTable dt = aChartDal.Get_TopBarChartCustomerCoverageDAL();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]
    public static string Get_TopBarChartTotalLeave(string param)
    {

        DataTable dt = aChartDal.Get_TopBarChartTotalLeaveDAL();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]
    public static string Get_TopBarChartOrderCount(string param)
    {

        DataTable dt = aChartDal.Get_TopBarChartOrderCountDAL();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]
    public static string Get_TopBarChartTotalInvoice(string param)
    {

        DataTable dt = aChartDal.Get_TopBarChartTotalInvoiceDAL();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]
    public static TotalInfoDAO GetTotalInfoByCurrentDate(int id)
    {


      


        return aChartDal.GetTotalInfoByCurrentDateDAL(id);
    }


    [WebMethod]
    public static string GetBrandWiseOrderReport(string fromdt, string todt, string param)
    {

       
        DataTable dt = aChartDal.GetBrandWiseOrderReportDAL(fromdt, todt, param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]
    public static string GetBrandWiseOrderReportDayWise(string fromdt, string todt, string param, string Brand)
    {

        
            DataTable dt = aChartDal.GetBrandWiseOrderReportDayWiseDAL(fromdt, todt, param,  Brand);
        

        
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]
    public static string GetAttandenceMonthlyReport(string fromdt, string todt, string param)
    {


        DataTable dt = aChartDal.GetAttandenceMonthlyReportDAL(fromdt, todt, param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }


    [WebMethod]
    public static string GetGMPRXReportChartDataDayWise(string fromdt, string todt, string param)
    {


        DataTable dt = aChartDal.GetGMPRXReportChartDataDayWiseDAL(fromdt, todt, param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }


    [WebMethod]
    public static string GetGMPVisitReportChartDataDayWise(string fromdt, string todt, string param)
    {


        DataTable dt = aChartDal.GetGMPVisitReportChartDataDayWiseDAL(fromdt, todt, param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
 
    [WebMethod]
    public static string GetSalesChartData(string fromdt, string todt, string param, string SSMonthNew, string SSYearNew)
    {
        string FirstMont = "";
        string LastMont = "";

        int myCount = 0;

        if (SSMonthNew.Contains(','))
        {
            string[] MonthSplt = SSMonthNew.Split(',');

            int count = MonthSplt.Length;
            myCount = count;

            FirstMont = MonthSplt[0].Trim();

                
                    LastMont = MonthSplt[count - 1].Trim();
                

           

        }

        else
        {
            myCount = 1;

            FirstMont = SSMonthNew;
            LastMont = SSMonthNew;
        }

        DateTime fromdate = new DateTime(Convert.ToInt32(SSYearNew), Convert.ToInt32(FirstMont), Convert.ToInt32(DateTime.Now.Day));
        DateTime todate = new DateTime(Convert.ToInt32(SSYearNew), Convert.ToInt32(LastMont), Convert.ToInt32(DateTime.Now.Day));
      
        DateTime tempdt = fromdate;
        DataTable dtdata = new DataTable();
        dtdata.Columns.Add("Criteria");
        while (tempdt.Month <= todate.Month  && tempdt.Year <= todate.Year)
        {
            if (CheckExist(tempdt.Month, SSMonthNew))
            {
                try
                {
                    dtdata.Columns.Add(tempdt.ToString("MMM-yyyy"));
                }
                catch
                {

                }
            }
            try
            {
                

                    tempdt = tempdt.AddMonths(1);
               
            }
            catch
            {

            }
        }
        dtdata.Columns.Add("Total");


        tempdt = fromdate;
        int i = 0;
        while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
        {
            if (CheckExist(tempdt.Month, SSMonthNew))
            {

                DataTable dtperdata = aChartDal.GetPerMonthAmount(tempdt.Month.ToString(), tempdt.Year.ToString(), param, fromdt, todt);



                DataRow dataRow = null;

                if (i == 0)
                {


                    foreach (DataRow dtperdataRow in dtperdata.Rows)
                    {
                        dataRow = dtdata.NewRow();
                        dataRow["Criteria"] = dtperdataRow["Criteria"].ToString();
                        dataRow[tempdt.ToString("MMM-yyyy")] = dtperdataRow["Amount"].ToString();
                        dtdata.Rows.Add(dataRow);

                    }
                }
                else
                {
                    int j = 0;
                    foreach (DataRow dtperdataRow in dtperdata.Rows)
                    {
                        string colname = tempdt.ToString("MMM-yyyy");

                        try
                        {
                            dtdata.Rows[j][colname] = dtperdataRow["Amount"].ToString();
                        }
                        catch
                        {
                            dataRow = dtdata.NewRow();
                            dataRow["Criteria"] = dtperdataRow["Criteria"].ToString();
                            dataRow[tempdt.ToString("MMM-yyyy")] = dtperdataRow["Amount"].ToString();
                            dtdata.Rows.Add(dataRow);
                        }
                        
                        j++;
                    }
                }
                

            }
            tempdt = tempdt.AddMonths(1);
            i++;
        }


        foreach (DataRow dtdataRow in dtdata.Rows)
        {
            tempdt = fromdate;
            decimal total = 0;
            while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
            {
                if (CheckExist(tempdt.Month, SSMonthNew))
                {
                    try
                    {
                        total += Convert.ToDecimal(dtdataRow[tempdt.ToString("MMM-yyyy")].ToString());
                    }
                    catch
                    {

                    }

                }
                tempdt = tempdt.AddMonths(1);
            }

            dtdataRow["Total"] = total/ myCount;
        }


        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dtdata);
        return JSONresult;

    }

    [WebMethod]
    public static string GetSalesRetrunChartData(string fromdt, string todt, string param)
    {
        DateTime fromdate = Convert.ToDateTime(fromdt);
        DateTime todate = Convert.ToDateTime(todt);
        DateTime tempdt = fromdate;
        DataTable dtdata = new DataTable();
        dtdata.Columns.Add("Criteria");
        while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
        {
            dtdata.Columns.Add(tempdt.ToString("MMM-yyyy"));
            tempdt = tempdt.AddMonths(1);
        }
        dtdata.Columns.Add("Total");


        tempdt = fromdate;
        int i = 0;
        while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
        {
           
                DataTable dtperdata = aChartDal.GetSalesRetrunChartData(tempdt.Month, tempdt.Year, param);



            DataRow dataRow = null;

            if (i == 0)
            {


                foreach (DataRow dtperdataRow in dtperdata.Rows)
                {
                    dataRow = dtdata.NewRow();
                    dataRow["Criteria"] = dtperdataRow["Criteria"].ToString();
                    dataRow[tempdt.ToString("MMM-yyyy")] = dtperdataRow["Amount"].ToString();
                    dtdata.Rows.Add(dataRow);

                }
            }
            else
            {
                int j = 0;
                foreach (DataRow dtperdataRow in dtperdata.Rows)
                {
                    string colname = tempdt.ToString("MMM-yyyy");


                    dtdata.Rows[j][colname] = dtperdataRow["Amount"].ToString();
                    j++;
                }
            }
           
            tempdt = tempdt.AddMonths(1);
            i++;
        }


        foreach (DataRow dtdataRow in dtdata.Rows)
        {
            tempdt = fromdate;
            decimal total = 0;
            while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
            {

                try
                {
                    total += Convert.ToDecimal(dtdataRow[tempdt.ToString("MMM-yyyy")].ToString());
                }
                catch
                {

                }
                tempdt = tempdt.AddMonths(1);
            }

            dtdataRow["Total"] = total;
        }


        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dtdata);
        return JSONresult;

    }

    public static bool CheckExist(int currentmonth,string choosenmonth)
    {
        string[] MonthSplt = choosenmonth.Split(',');
        foreach(string month in MonthSplt)
        {
            int monthnum = Convert.ToInt32(month);
            if(monthnum==currentmonth)
            {
                return true;
            }

        }


        return false;

    }

    [WebMethod]
    public static string GetOrderChartData(string fromdt, string todt, string param, string SSMonthNew, string SSYearNew)
    {


        string FirstMont = "";
        string LastMont = "";
        int myCount = 0;

        if (SSMonthNew.Contains(','))
        {
            string[] MonthSplt = SSMonthNew.Split(',');

            int count = MonthSplt.Length;
            myCount = count;
            FirstMont = MonthSplt[0].Trim();


            LastMont = MonthSplt[count - 1].Trim();




        }

        else
        {
            myCount = 1;
            FirstMont = SSMonthNew;
            LastMont = SSMonthNew;
        }

        DateTime fromdate = new DateTime(Convert.ToInt32(SSYearNew), Convert.ToInt32(FirstMont), Convert.ToInt32(DateTime.Now.Day));
        DateTime todate = new DateTime(Convert.ToInt32(SSYearNew), Convert.ToInt32(LastMont), Convert.ToInt32(DateTime.Now.Day));

        DateTime tempdt = fromdate;
        DataTable dtdata = new DataTable();
        dtdata.Columns.Add("Criteria");
        while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
        {
            if (CheckExist(tempdt.Month, SSMonthNew))
            {
                try
                {
                    dtdata.Columns.Add(tempdt.ToString("MMM-yyyy"));
                }
                catch
                {

                }
            }
            try
            {
                tempdt = tempdt.AddMonths(1);
            }
            catch
            {

            }
        }
        dtdata.Columns.Add("Total");


        tempdt = fromdate;
        int i = 0;
        while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
        {
            if (CheckExist(tempdt.Month, SSMonthNew))
            {

                DataTable dtperdata = aChartDal.GetOrderChartDataDAL(tempdt.Month.ToString(), tempdt.Year.ToString(), param, todt);



                DataRow dataRow = null;

                if (i == 0)
                {


                    foreach (DataRow dtperdataRow in dtperdata.Rows)
                    {
                        dataRow = dtdata.NewRow();
                        dataRow["Criteria"] = dtperdataRow["Criteria"].ToString();
                        dataRow[tempdt.ToString("MMM-yyyy")] = dtperdataRow["Amount"].ToString();
                        dtdata.Rows.Add(dataRow);

                    }
                }
                else
                {
                    int j = 0;
                    foreach (DataRow dtperdataRow in dtperdata.Rows)
                    {
                        string colname = tempdt.ToString("MMM-yyyy");

                        try
                        {
                            dtdata.Rows[j][colname] = dtperdataRow["Amount"].ToString();
                        }
                        catch
                        {
                            dataRow = dtdata.NewRow();
                            dataRow["Criteria"] = dtperdataRow["Criteria"].ToString();
                            dataRow[tempdt.ToString("MMM-yyyy")] = dtperdataRow["Amount"].ToString();
                            dtdata.Rows.Add(dataRow);
                        }

                        j++;
                    }
                }


            }
            tempdt = tempdt.AddMonths(1);
            i++;
        }


        foreach (DataRow dtdataRow in dtdata.Rows)
        {
            tempdt = fromdate;
            decimal total = 0;
            while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
            {
                if (CheckExist(tempdt.Month, SSMonthNew))
                {
                    try
                    {
                        total += Convert.ToDecimal(dtdataRow[tempdt.ToString("MMM-yyyy")].ToString());
                    }
                    catch
                    {

                    }

                }
                tempdt = tempdt.AddMonths(1);
            }

            dtdataRow["Total"] = total/ myCount;
        }


        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dtdata);
        return JSONresult;

      

    }



    [WebMethod]
    public static string GetCustomerReportChartData(string fromdt, string todt, string param, string SSMonthNew, string SSYearNew)
    {

        string FirstMont = "";
        string LastMont = "";


        if (SSMonthNew.Contains(','))
        {
            string[] MonthSplt = SSMonthNew.Split(',');

            int count = MonthSplt.Length;

            FirstMont = MonthSplt[0].Trim();


            LastMont = MonthSplt[count - 1].Trim();




        }

        else
        {
            FirstMont = SSMonthNew;
            LastMont = SSMonthNew;
        }

        DateTime fromdate = new DateTime(Convert.ToInt32(SSYearNew), Convert.ToInt32(FirstMont), Convert.ToInt32(DateTime.Now.Day));
        DateTime todate = new DateTime(Convert.ToInt32(SSYearNew), Convert.ToInt32(LastMont), Convert.ToInt32(DateTime.Now.Day));

        DateTime tempdt = fromdate;
        DataTable dtdata = new DataTable();
        dtdata.Columns.Add("Criteria");
        while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
        {
            if (CheckExist(tempdt.Month, SSMonthNew))
            {

                try
                {
                    dtdata.Columns.Add(tempdt.ToString("MMM-yyyy"));
                }
                catch
                {

                }
            }
            try
            {
                tempdt = tempdt.AddMonths(1);
            }
            catch
            {

            }
        }
        dtdata.Columns.Add("Total");


        tempdt = fromdate;
        int i = 0;
        while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
        {
            if (CheckExist(tempdt.Month, SSMonthNew))
            {

                DataTable dtperdata = aChartDal.GetCustomerReportChartDataDAL(tempdt.Month.ToString(), tempdt.Year.ToString(), param, fromdt, todt);



                DataRow dataRow = null;

                if (i == 0)
                {


                    foreach (DataRow dtperdataRow in dtperdata.Rows)
                    {
                        dataRow = dtdata.NewRow();
                        dataRow["Criteria"] = dtperdataRow["Criteria"].ToString();
                        dataRow[tempdt.ToString("MMM-yyyy")] = dtperdataRow["Amount"].ToString();
                        dtdata.Rows.Add(dataRow);

                    }
                }
                else
                {
                    int j = 0;
                    foreach (DataRow dtperdataRow in dtperdata.Rows)
                    {
                        string colname = tempdt.ToString("MMM-yyyy");

                        try
                        {
                            dtdata.Rows[j][colname] = dtperdataRow["Amount"].ToString();
                        }
                        catch
                        {
                            dataRow = dtdata.NewRow();
                            dataRow["Criteria"] = dtperdataRow["Criteria"].ToString();
                            dataRow[tempdt.ToString("MMM-yyyy")] = dtperdataRow["Amount"].ToString();
                            dtdata.Rows.Add(dataRow);
                        }

                        j++;
                    }
                }


            }
            tempdt = tempdt.AddMonths(1);
            i++;
        }


        foreach (DataRow dtdataRow in dtdata.Rows)
        {
            tempdt = fromdate;
            decimal total = 0;
            while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
            {
                if (CheckExist(tempdt.Month, SSMonthNew))
                {
                    try
                    {
                        total += Convert.ToDecimal(dtdataRow[tempdt.ToString("MMM-yyyy")].ToString());
                    }
                    catch
                    {

                    }

                }
                tempdt = tempdt.AddMonths(1);
            }

            dtdataRow["Total"] = total;
        }


        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dtdata);
        return JSONresult;

 

    }



    [WebMethod]
    public static string GetGMPVisitReportChartData(string fromdt, string todt, string param)
    {
        DateTime fromdate = Convert.ToDateTime(fromdt);
        DateTime todate = Convert.ToDateTime(todt);
        DateTime tempdt = fromdate;
        DataTable dtdata = new DataTable();
        dtdata.Columns.Add("Criteria");
        while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
        {
            dtdata.Columns.Add(tempdt.ToString("MMM-yyyy"));
            tempdt = tempdt.AddMonths(1);
        }
        dtdata.Columns.Add("Total");


        tempdt = fromdate;
        int i = 0;
        while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
        {
            DataTable dtperdata = aChartDal.GetGMPVisitReportChartDataDAL(fromdt,  todt, param);



            DataRow dataRow = null;

            if (i == 0)
            {


                foreach (DataRow dtperdataRow in dtperdata.Rows)
                {
                    dataRow = dtdata.NewRow();
                    dataRow["Criteria"] = dtperdataRow["Criteria"].ToString();
                    dataRow[tempdt.ToString("MMM-yyyy")] = dtperdataRow["Amount"].ToString();
                    dtdata.Rows.Add(dataRow);

                }
            }
            else
            {
                int j = 0;
                foreach (DataRow dtperdataRow in dtperdata.Rows)
                {
                    string colname = tempdt.ToString("MMM-yyyy");


                    dtdata.Rows[j][colname] = dtperdataRow["Amount"].ToString();
                    j++;
                }
            }

            tempdt = tempdt.AddMonths(1);
            i++;
        }


        foreach (DataRow dtdataRow in dtdata.Rows)
        {
            tempdt = fromdate;
            decimal total = 0;
            while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
            {

                try
                {
                    total += Convert.ToDecimal(dtdataRow[tempdt.ToString("MMM-yyyy")].ToString());
                }
                catch
                {

                }
                tempdt = tempdt.AddMonths(1);
            }

            dtdataRow["Total"] = total;
        }


        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dtdata);
        return JSONresult;

    }



    [WebMethod]
    public static string GetNONGMPVisitReportChartData(string fromdt, string todt)
    {
        DateTime fromdate = Convert.ToDateTime(fromdt);
        DateTime todate = Convert.ToDateTime(todt);
        DateTime tempdt = fromdate;
        DataTable dtdata = new DataTable();
        dtdata.Columns.Add("Criteria");
        while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
        {
            dtdata.Columns.Add(tempdt.ToString("MMM-yyyy"));
            tempdt = tempdt.AddMonths(1);
        }
        dtdata.Columns.Add("Total");


        tempdt = fromdate;
        int i = 0;
        while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
        {
            DataTable dtperdata = aChartDal.GetNONGMPVisitReportChartDataDAL(tempdt.Month, tempdt.Year);



            DataRow dataRow = null;

            if (i == 0)
            {


                foreach (DataRow dtperdataRow in dtperdata.Rows)
                {
                    dataRow = dtdata.NewRow();
                    dataRow["Criteria"] = dtperdataRow["Criteria"].ToString();
                    dataRow[tempdt.ToString("MMM-yyyy")] = dtperdataRow["Amount"].ToString();
                    dtdata.Rows.Add(dataRow);

                }
            }
            else
            {
                int j = 0;
                foreach (DataRow dtperdataRow in dtperdata.Rows)
                {
                    string colname = tempdt.ToString("MMM-yyyy");


                    dtdata.Rows[j][colname] = dtperdataRow["Amount"].ToString();
                    j++;
                }
            }

            tempdt = tempdt.AddMonths(1);
            i++;
        }


        foreach (DataRow dtdataRow in dtdata.Rows)
        {
            tempdt = fromdate;
            decimal total = 0;
            while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
            {

                try
                {
                    total += Convert.ToDecimal(dtdataRow[tempdt.ToString("MMM-yyyy")].ToString());
                }
                catch
                {

                }
                tempdt = tempdt.AddMonths(1);
            }

            dtdataRow["Total"] = total;
        }


        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dtdata);
        return JSONresult;

    }



    [WebMethod]
    public static string GetGMPRXReportChartData(string fromdt, string todt, string param)
    {
        DateTime fromdate = Convert.ToDateTime(fromdt);
        DateTime todate = Convert.ToDateTime(todt);
        DateTime tempdt = fromdate;
        DataTable dtdata = new DataTable();
        dtdata.Columns.Add("Criteria");
        while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
        {
            dtdata.Columns.Add(tempdt.ToString("MMM-yyyy"));
            tempdt = tempdt.AddMonths(1);
        }
        dtdata.Columns.Add("Total");


        tempdt = fromdate;
        int i = 0;
        while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
        {
            DataTable dtperdata = aChartDal.GetGMPRXReportChartDataDAL(fromdt, todt, param);



            DataRow dataRow = null;

            if (i == 0)
            {


                foreach (DataRow dtperdataRow in dtperdata.Rows)
                {
                    dataRow = dtdata.NewRow();
                    dataRow["Criteria"] = dtperdataRow["Criteria"].ToString();
                    dataRow[tempdt.ToString("MMM-yyyy")] = dtperdataRow["Amount"].ToString();
                    dtdata.Rows.Add(dataRow);

                }
            }
            else
            {
                int j = 0;
                foreach (DataRow dtperdataRow in dtperdata.Rows)
                {
                    string colname = tempdt.ToString("MMM-yyyy");


                    dtdata.Rows[j][colname] = dtperdataRow["Amount"].ToString();
                    j++;
                }
            }

            tempdt = tempdt.AddMonths(1);
            i++;
        }


        foreach (DataRow dtdataRow in dtdata.Rows)
        {
            tempdt = fromdate;
            decimal total = 0;
            while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
            {

                try
                {
                    total += Convert.ToDecimal(dtdataRow[tempdt.ToString("MMM-yyyy")].ToString());
                }
                catch
                {

                }
                tempdt = tempdt.AddMonths(1);
            }

            dtdataRow["Total"] = total;
        }


        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dtdata);
        return JSONresult;

    }


    //[WebMethod]
    //public static string GetGMPRXReportChartDataDayWise(string fromdt, string todt, string param)
    //{
    //    DateTime fromdate = Convert.ToDateTime(fromdt);
    //    DateTime todate = Convert.ToDateTime(todt);
    //    DateTime tempdt = fromdate;
    //    DataTable dtdata = new DataTable();
    //    dtdata.Columns.Add("Criteria");
    //    while (tempdt.Month <= todate.Month)
    //    {
    //        dtdata.Columns.Add(tempdt.ToString("MMM-yyyy"));
    //        tempdt = tempdt.AddMonths(1);
    //    }
    //    dtdata.Columns.Add("Total");


    //    tempdt = fromdate;
    //    int i = 0;
    //    while (tempdt.Month <= todate.Month)
    //    {
    //        DataTable dtperdata = aChartDal.GetGMPRXReportChartDataDayWiseDAL(fromdt, todt, param);



    //        DataRow dataRow = null;

    //        if (i == 0)
    //        {


    //            foreach (DataRow dtperdataRow in dtperdata.Rows)
    //            {
    //                dataRow = dtdata.NewRow();
    //                dataRow["Criteria"] = dtperdataRow["Criteria"].ToString();
    //                dataRow[tempdt.ToString("MMM-yyyy")] = dtperdataRow["Amount"].ToString();
    //                dtdata.Rows.Add(dataRow);

    //            }
    //        }
    //        else
    //        {
    //            int j = 0;
    //            foreach (DataRow dtperdataRow in dtperdata.Rows)
    //            {
    //                string colname = tempdt.ToString("MMM-yyyy");


    //                dtdata.Rows[j][colname] = dtperdataRow["Amount"].ToString();
    //                j++;
    //            }
    //        }

    //        tempdt = tempdt.AddMonths(1);
    //        i++;
    //    }


    //    foreach (DataRow dtdataRow in dtdata.Rows)
    //    {
    //        tempdt = fromdate;
    //        decimal total = 0;
    //        while (tempdt.Month <= todate.Month)
    //        {

    //            total += Convert.ToDecimal(dtdataRow[tempdt.ToString("MMM-yyyy")].ToString());
    //            tempdt = tempdt.AddMonths(1);
    //        }

    //        dtdataRow["Total"] = total;
    //    }


    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dtdata);
    //    return JSONresult;

    //}

    [WebMethod]
    public static string GetNONGMPRXReportChartData(string fromdt, string todt)
    {
        DateTime fromdate = Convert.ToDateTime(fromdt);
        DateTime todate = Convert.ToDateTime(todt);
        DateTime tempdt = fromdate;
        DataTable dtdata = new DataTable();
        dtdata.Columns.Add("Criteria");
        while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
        {
            dtdata.Columns.Add(tempdt.ToString("MMM-yyyy"));
            tempdt = tempdt.AddMonths(1);
        }
        dtdata.Columns.Add("Total");


        tempdt = fromdate;
        int i = 0;
        while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
        {
            DataTable dtperdata = aChartDal.GetNONGMPRXReportChartDataDAL(tempdt.Month, tempdt.Year);



            DataRow dataRow = null;

            if (i == 0)
            {


                foreach (DataRow dtperdataRow in dtperdata.Rows)
                {
                    dataRow = dtdata.NewRow();
                    dataRow["Criteria"] = dtperdataRow["Criteria"].ToString();
                    dataRow[tempdt.ToString("MMM-yyyy")] = dtperdataRow["Amount"].ToString();
                    dtdata.Rows.Add(dataRow);

                }
            }
            else
            {
                int j = 0;
                foreach (DataRow dtperdataRow in dtperdata.Rows)
                {
                    string colname = tempdt.ToString("MMM-yyyy");


                    dtdata.Rows[j][colname] = dtperdataRow["Amount"].ToString();
                    j++;
                }
            }

            tempdt = tempdt.AddMonths(1);
            i++;
        }


        foreach (DataRow dtdataRow in dtdata.Rows)
        {
            tempdt = fromdate;
            decimal total = 0;
            while (tempdt.Month <= todate.Month && tempdt.Year <= todate.Year)
            {

                try
                {
                    total += Convert.ToDecimal(dtdataRow[tempdt.ToString("MMM-yyyy")].ToString());
                }
                catch
                {

                }
                tempdt = tempdt.AddMonths(1);
            }

            dtdataRow["Total"] = total;
        }


        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dtdata);
        return JSONresult;

    }

    [WebMethod]
    public static string GetExpanseClaimMonthlyChartData(string fromdt, string todt, string param)
    {

        DataTable dt = aChartDal.GetExpanseClaimMonthlyChartDataDAL(fromdt, todt, param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }


    [WebMethod]
    public static string GetExpanseClaimMonthlyChartDataDayWise(string fromdt, string todt, string param)
    {

        DataTable dt = aChartDal.GetExpanseClaimMonthlyChartDataDayWiseDAL(fromdt, todt, param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }


    //[WebMethod]
    //public static string GetExpanseClaimMonthlyChartData(string fromdt, string todt, string param)
    //{
    //    DateTime fromdate = Convert.ToDateTime(fromdt);
    //    DateTime todate = Convert.ToDateTime(todt);
    //    DateTime tempdt = fromdate;
    //    DataTable dtdata = new DataTable();
    //    dtdata.Columns.Add("Criteria");
    //    while (tempdt.Month <= todate.Month)
    //    {
    //        dtdata.Columns.Add(tempdt.ToString("MMM-yyyy"));
    //        tempdt = tempdt.AddMonths(1);
    //    }
    //    dtdata.Columns.Add("Total");


    //    tempdt = fromdate;
    //    int i = 0;
    //    while (tempdt.Month <= todate.Month)
    //    {
    //        DataTable dtperdata = aChartDal.GetExpanseClaimMonthlyChartDataDAL(tempdt.Month, tempdt.Year, param);



    //        DataRow dataRow = null;

    //        if (i == 0)
    //        {


    //            foreach (DataRow dtperdataRow in dtperdata.Rows)
    //            {
    //                dataRow = dtdata.NewRow();
    //                dataRow["Criteria"] = dtperdataRow["Criteria"].ToString();
    //                dataRow[tempdt.ToString("MMM-yyyy")] = dtperdataRow["Amount"].ToString();
    //                dtdata.Rows.Add(dataRow);

    //            }
    //        }
    //        else
    //        {
    //            int j = 0;
    //            foreach (DataRow dtperdataRow in dtperdata.Rows)
    //            {
    //                string colname = tempdt.ToString("MMM-yyyy");


    //                dtdata.Rows[j][colname] = dtperdataRow["Amount"].ToString();
    //                j++;
    //            }
    //        }

    //        tempdt = tempdt.AddMonths(1);
    //        i++;
    //    }


    //    foreach (DataRow dtdataRow in dtdata.Rows)
    //    {
    //        tempdt = fromdate;
    //        decimal total = 0;
    //        while (tempdt.Month <= todate.Month)
    //        {

    //            total += Convert.ToDecimal(dtdataRow[tempdt.ToString("MMM-yyyy")].ToString());
    //            tempdt = tempdt.AddMonths(1);
    //        }

    //        dtdataRow["Total"] = total;
    //    }


    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dtdata);
    //    return JSONresult;

    //}

}