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
using Library.DAL.SInventory_DAL;

public partial class SInventory_RPTVIEW_DcToWHChalanReportViewer : System.Web.UI.Page
{
   
    SCtoWHTransferDal aTransferDal = new SCtoWHTransferDal();
    ReportDocument rptdoc = new ReportDocument();
    protected void Page_Init(object sender, EventArgs e)
    {
        string chalanNo = Request.QueryString["chalanno"];

        DataTable comDetailDataTable = aTransferDal.ChalanReport(chalanNo).Copy();

            if (comDetailDataTable.Rows.Count > 0)
            {

                DataSet Ds = new DataSet();

                comDetailDataTable.TableName = "DCToWhDataTable";
                Ds.Tables.Add(comDetailDataTable);

                rptdoc.Load(ReportPath("crpDCToWhChalan.rpt"));
                rptdoc.SetDataSource(Ds);
                crvComSalesRpt.ReportSource = rptdoc;
                crvComSalesRpt.DataBind();

              
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
   
    protected void crvComSalesRpt_Unload(object sender, EventArgs e)
    {
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvComSalesRpt.Dispose();
        }
    }
    protected void crvComSalesRpt_Disposed(object sender, EventArgs e)
    {
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvComSalesRpt.Dispose();
        }
    }
}