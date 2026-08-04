using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SubDepot_BLL;

public partial class SubDepot_UI_SubDepotStockAdjustmentVoucherView : System.Web.UI.Page
{

    SubDepotStockAdjustmentsVoucherBll adjustmentsVoucherBll = new SubDepotStockAdjustmentsVoucherBll();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            SubDcStockOutView();
        }
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private void SubDcStockOutView()
    {
        DataTable dt = adjustmentsVoucherBll.SubDcStockOutBll();
        loadGridView.DataSource = dt;
        loadGridView.DataBind();
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string SubDcStockOutMasterId = loadGridView.DataKeys[rowindex][0].ToString();
            string status = loadGridView.DataKeys[rowindex][1].ToString();
            Session["Status"] = status;

            if (status == "Approved")
            {
                showMessageBox("Can not Delete Data!!!....");
            }
            else
            {
                if (adjustmentsVoucherBll.SubDcStockOutMasterDelete(SubDcStockOutMasterId))
                {
                    adjustmentsVoucherBll.SubDcStockOutDetailsDelete(SubDcStockOutMasterId);
                    showMessageBox("Data Delete successfully");
                    SubDcStockOutView();

                }
            }

        }

        if (e.CommandName == "ReportView")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            String Id = loadGridView.DataKeys[rowindex][0].ToString();
            Session["SubDcStockOutMasterId"] = Id;


            string url = "../SInventory_RPTVIEW/SubDepotStockOutReportViewer.aspx?SubDcStockOutMasterId=" + Id;
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);


        }

    }


    protected void DcStockOutAddImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("SubDepotStockAdjustmentVoucher.aspx");
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

    protected void EmpCetegoryAddImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("SubDepotStockAdjustmentVoucher.aspx");

    }
}