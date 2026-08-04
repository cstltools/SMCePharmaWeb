using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using Library.BLL;
using Library.BLL.SInventory_BLL;
using Library.CrystalReports.SInventory_RPT;

public partial class SInventory_RPTVIEW_WHStockInReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    DCStockReportBLL aDcStockReportBll = new DCStockReportBLL();
    WHStockInReportBll aStockInReportBll = new WHStockInReportBll();

    protected void Page_Init(object sender, EventArgs e)
    {
        string reqId = Request.QueryString["reqId"];

        string rptType = Convert.ToString(Session["ReportType"]);
        int excel = Convert.ToInt32(Session["Excel"]);

        DataTable companyInfoDataTable = aStockInReportBll.CompanyInfoBLL().Copy();

        if (rptType == "STD")
        {
            DataTable mainDataTable = aStockInReportBll.LoadWarehouseStockInMasterData(reqId).Copy();
            DataTable detailDataTable = aStockInReportBll.LoadWarehouseStockInDetailData(reqId).Copy();
            
            DataSet Ds = new DataSet();

            mainDataTable.TableName = "mainDataTable";
            detailDataTable.TableName = "detailDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(mainDataTable);
            Ds.Tables.Add(detailDataTable);
            Ds.Tables.Add(companyInfoDataTable);

            rptdoc.Load(ReportPath("crpWHStockIn.rpt"));
            rptdoc.SetDataSource(Ds);

            if (excel == 0)
            {
                crvWHStockInReport.ReportSource = rptdoc;
                crvWHStockInReport.DataBind();
            }

            else
            {
                rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,"Stock Detail Report");
            }  
        }

        else if (rptType == "CSR")
        {
            DataTable comUnitDetailDataTable = new DataTable();
            string Pcode = Session["ProductCode"].ToString();
            if (Pcode!="")
            {
                comUnitDetailDataTable = aDcStockReportBll.WHReportDetailDataDAL(Pcode).Copy();
            }
            else
            {
                comUnitDetailDataTable = aDcStockReportBll.WHReportDetailDataDAL().Copy();
            }

            if (comUnitDetailDataTable.Rows.Count > 0)
            {
                DataSet Ds = new DataSet();

                comUnitDetailDataTable.TableName = "comUnitDetailDataTable";
                companyInfoDataTable.TableName = "companyInfoDataTable";

                Ds.Tables.Add(comUnitDetailDataTable);
                Ds.Tables.Add(companyInfoDataTable);

                

                if (excel == 0)
                {

                    rptdoc.Load(ReportPath("rptWHDCStock.rpt"));
                    rptdoc.SetDataSource(Ds);

                    crvWHStockInReport.ReportSource = rptdoc;
                    crvWHStockInReport.DataBind();
                }
                else
                {

                    rptdoc.Load(ReportPath("rptWHDCStockExcel.rpt"));
                    rptdoc.SetDataSource(Ds);

                    rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                    "WHStock_Report");
                }
            }

        }
    }
    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
    private string ReportPath(string rptName)
    {
        return Convert.ToString(Server.MapPath("~\\Reports\\CrystalReports\\" + rptName));
    }

    protected void crvWHStockInReport_Unload(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvWHStockInReport.Dispose();
    }

    protected void crvWHStockInReport_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvWHStockInReport.Dispose();
    }
}