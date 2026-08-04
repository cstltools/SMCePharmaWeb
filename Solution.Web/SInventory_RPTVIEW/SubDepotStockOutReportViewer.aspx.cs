using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using Library.BLL.SInventory_BLL;
using Library.BLL.SubDepot_BLL;

public partial class SInventory_RPTVIEW_DcStockOutReportViewer : System.Web.UI.Page
{

    ReportDocument rptdoc = new ReportDocument();
    SubDepotStockAdjustmentsVoucherBll aStockOutBll = new SubDepotStockAdjustmentsVoucherBll();
    protected void Page_Init(object sender, EventArgs e)
    {

        string SubDcStockOutMasterId = Request.QueryString["SubDcStockOutMasterId"];

        var dt = new DataTable();
        //string parameter = Session["PRAM"].ToString();

        dt = null;
        dt = aStockOutBll.SubDcStockOutReportViewBll(SubDcStockOutMasterId).Copy();

        var ds = new DataSet();

        if (dt.Rows.Count > 0)
        {
            dt.TableName ="DcStockOutDT";
            ds.Tables.Add(dt);
            rptdoc.Load(ReportPath("crpSubDepotStockOut.rpt"));
            rptdoc.SetDataSource(ds);
            crvDCStockOutRpt.ReportSource = rptdoc;
            crvDCStockOutRpt.DataBind();
        }
        else
        {
            MessageLabel.Text = "No Data Found!!";
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

    protected void crvDcStockOutRpt_Unload(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvDCStockOutRpt.Dispose();
    }
    protected void crvDcStockOutRpt_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvDCStockOutRpt.Dispose();
    }
}