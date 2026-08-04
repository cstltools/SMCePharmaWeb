using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using Library.BLL.SInventory_BLL;
using Library.CrystalReports.SInventory_RPT;

public partial class SInventory_RPTVIEW_DeliveryReturnReportViewer : System.Web.UI.Page
{
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    CompanySalesReportBLL aCompanySalesReportBll = new CompanySalesReportBLL();
    ReportDocument rptdoc = new ReportDocument();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    protected void Page_Init(object sender, EventArgs e)
    {

        int rpt = Convert.ToInt32(Session["DeliveryReturnRpt"]); 

        int NationalReport = Convert.ToInt32(Request.QueryString["NationalReport"]);
        string districtId = Request.QueryString["districtId"];
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];

        if (NationalReport != 1 && rpt == 0)
        {
            DateTime FromDate = Convert.ToDateTime(fromDate);
            DateTime ToDate = Convert.ToDateTime(toDate);

            DataTable mainDataTable =
                aCompanySalesReportBll.DeliveryReturnReportDAl(districtId, FromDate, ToDate).Copy();
            DataSet Ds = new DataSet();
            mainDataTable.TableName = "deliveryDataTable";
            Ds.Tables.Add(mainDataTable);
            rptdoc.Load(ReportPath("crpDeliveryReturnReport.rpt"));
            rptdoc.SetDataSource(Ds);
            //crvSalesRpt.ReportSource = rptdoc;
            //crvSalesRpt.DataBind();
            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
               "DeliveryReturn_Report");
        }
        else
        {
            DateTime FromDate = Convert.ToDateTime(fromDate);
            DateTime ToDate = Convert.ToDateTime(toDate);

            DataTable mainDataTable =
                aCompanySalesReportBll.DeliveryReturnReportDAl(FromDate, ToDate).Copy();
            DataSet Ds = new DataSet();
            mainDataTable.TableName = "deliveryDataTable";
            Ds.Tables.Add(mainDataTable);
            rptdoc.Load(ReportPath("crpDeliveryReturnReport.rpt"));
            rptdoc.SetDataSource(Ds);
            //crvSalesRpt.ReportSource = rptdoc;
            //crvSalesRpt.DataBind();
            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
               "DeliveryReturn_Report");
        }


        //View Report

        if (NationalReport != 1 && rpt == 1)
        {
            DateTime FromDate = Convert.ToDateTime(fromDate);
            DateTime ToDate = Convert.ToDateTime(toDate);

            DataTable mainDataTable =
                aCompanySalesReportBll.DeliveryReturnReportDAl(districtId, FromDate, ToDate).Copy();
            DataSet Ds = new DataSet();
            mainDataTable.TableName = "deliveryDataTable";
            Ds.Tables.Add(mainDataTable);
            rptdoc.Load(ReportPath("crpDeliveryReturnReport.rpt"));
            rptdoc.SetDataSource(Ds);
            crvSalesRpt.ReportSource = rptdoc;
            crvSalesRpt.DataBind();
            //rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
            //   "DeliveryReturn_Report");
        }
        else
        {
            DateTime FromDate = Convert.ToDateTime(fromDate);
            DateTime ToDate = Convert.ToDateTime(toDate);

            DataTable mainDataTable =
                aCompanySalesReportBll.DeliveryReturnReportDAl(FromDate, ToDate).Copy();
            DataSet Ds = new DataSet();
            mainDataTable.TableName = "deliveryDataTable";
            Ds.Tables.Add(mainDataTable);
            rptdoc.Load(ReportPath("crpDeliveryReturnReport.rpt"));
            rptdoc.SetDataSource(Ds);
            crvSalesRpt.ReportSource = rptdoc;
            crvSalesRpt.DataBind();

            //rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
            //   "DeliveryReturn_Report");
        }
    }

    private string ReportPath(string rptName)
    {
        return Convert.ToString(Server.MapPath("~\\Reports\\CrystalReports\\" + rptName));
    }
    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
   // protected void crViewer_Unload(object sender, EventArgs e)
    //{
    //    if (this.rptdoc != null)
    //    {
    //        rptdoc.Close();
    //        rptdoc.Dispose();
    //        crvSalesRpt.Dispose();
    //    }
    //}
    //protected void crViewer_Disposed(object sender, EventArgs e)
    //{
    //    if (this.rptdoc != null)
    //    {
    //        rptdoc.Close();
    //        rptdoc.Dispose();
    //        crvSalesRpt.Dispose();
    //    }
    //}
    protected void crvSalesRpt_Unload(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvSalesRpt.Dispose();
        }
       
    }
    protected void crvSalesRpt_Disposed(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvSalesRpt.Dispose();
        }
      
    }
}