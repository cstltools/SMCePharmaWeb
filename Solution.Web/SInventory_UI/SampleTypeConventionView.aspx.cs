using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_SampleTypeConventionView : System.Web.UI.Page
{
  

    SampleTypeConventionBLL aConventionBll = new SampleTypeConventionBLL();


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DcStockOutgrid();
        }

    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    private void DcStockOutgrid()
    {
        DataTable dt = aConventionBll.DcStockOutBll();
        loadGridView.DataSource = dt;
        loadGridView.DataBind();
    }
    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string DcStockOutMasterId = loadGridView.DataKeys[rowindex][0].ToString();
         
                DataTable Dt = aConventionBll.LoadSampleStock(DcStockOutMasterId);

                GridView1.DataSource = Dt;
                GridView1.DataBind();

                List<SampleStockForDcDetails> aStockOutDetailsDaoList = new List<SampleStockForDcDetails>();

                for (int i = 0; i < GridView1.Rows.Count; i++)
                {
                    SampleStockForDcDetails aStockOutDetailsDao = new SampleStockForDcDetails();
                    aStockOutDetailsDao.DCStoreId = Convert.ToInt32(GridView1.Rows[i].Cells[0].Text);
                    aStockOutDetailsDao.SampleStock = Convert.ToInt32(GridView1.Rows[i].Cells[1].Text);
                    aStockOutDetailsDaoList.Add(aStockOutDetailsDao);
                }
                if (aConventionBll.StockIn(aStockOutDetailsDaoList))
                {
                    if (aConventionBll.DcStockOutDetailsDelete(DcStockOutMasterId))
                    {
                        aConventionBll.DcStockOutMasterDelete(DcStockOutMasterId); 
                        showMessageBox("Data Delete successfully");
                        DcStockOutgrid();

                    }
                }

      

        }

        if (e.CommandName == "ReportView")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            String Id = loadGridView.DataKeys[rowindex][0].ToString();
            Session["DcStockOutMasterId"] = Id;


            string url = "../SInventory_RPTVIEW/DcStockOutReportViewer.aspx?DcStockOutMasterId=" + Id;
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);

        }

    }
    private void PopUp(string Id)
    {
        string url = "CustomerMasterEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
    protected void CustMasterNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("CustMasterEntry.aspx");
    }
    protected void DcStockOutAddImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("SampleTypeConvertion.aspx");
    }
    protected void rptImageButton_Click(object sender, ImageClickEventArgs e)
    {
        string url = "../SInventory_RPTVIEW/CustomerMasterViewer.aspx";
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        DcStockOutgrid();
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
}