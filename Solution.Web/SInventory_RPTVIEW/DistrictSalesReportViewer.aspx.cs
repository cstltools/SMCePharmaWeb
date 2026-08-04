using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using Library.BLL.SInventory_BLL;
using Library.CrystalReports.SInventory_RPT;

public partial class SInventory_RPTVIEW_DistrictSalesReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    DistrictSalesReportBLL aDistrictSalesReportBll = new DistrictSalesReportBLL();
    protected void Page_Init(object sender, EventArgs e)
    {

        string districtId = Request.QueryString["districtId"];
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];

        DateTime FromDate = Convert.ToDateTime(fromDate);
        DateTime ToDate = Convert.ToDateTime(toDate);

        DataTable districtDetailDataTable = aDistrictSalesReportBll.DistrictReportDetailDataBLL(districtId, FromDate, ToDate).Copy();

        if (districtDetailDataTable.Rows.Count > 0)
        {
            DataTable districtMainDataTable =
                aDistrictSalesReportBll.DistrictReportMainDataBLL(districtId, FromDate, ToDate).Copy();


            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            DataSet Ds = new DataSet();

            districtMainDataTable.TableName = "districtMainDataTable";
            districtDetailDataTable.TableName = "districtDetailDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(districtMainDataTable);
            Ds.Tables.Add(districtDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);

            rptDistrictWiseSales aDistrictWiseSales=new rptDistrictWiseSales();

            aDistrictWiseSales.SetDataSource(Ds);
            crvDistrictSalesRpt.ReportSource = aDistrictWiseSales;
        }
        else
        {
            MessageLabel.Text = "No Data Found!!";
        }
    }
    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }

    protected void crvDistrictSalesRpt_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvDistrictSalesRpt.Dispose();
    }
    protected void crvDistrictSalesRpt_Unload(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvDistrictSalesRpt.Dispose();
    }
}