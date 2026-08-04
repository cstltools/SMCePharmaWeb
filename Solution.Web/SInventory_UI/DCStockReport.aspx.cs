using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;

public partial class SInventory_UI_DCStockReport : System.Web.UI.Page
{
    DCStockReportBLL aDcStockReportBll=new DCStockReportBLL();
    private static CmnCrystaltoView _DAL = new CmnCrystaltoView();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //if (Session["UserType"].ToString() != "")
            //{
            //    if (Session["UserType"].ToString() == "Admin")
            //    {
                    aDcStockReportBll.LoadCompanyUnit(dcDropDownList1);
            //    }
            //    else
            //    {
            //        string userId = Session["UserId"].ToString();
            //        aDcStockReportBll.LoadCompanyUnit(dcDropDownList1, userId);
            //    }
            //}
            //else
            //{
            //    Response.Redirect("Login.aspx");
            //}

            //if (Session["CentralWareHouse"] != null && Session["CentralWareHouse"].ToString()=="True")
            //{
            //    centalWHCheckBox.Enabled = true;
            //    nationalCheckBox.Enabled = true;
            //}
        }
    }



    protected void centalWHCheckBox_CheckedChanged(object sender, EventArgs e)
    {
        if (centalWHCheckBox.Checked == true)
        {
            DIVCH.Visible = true;
            DIVDC.Visible = false;
            //whDropDownList.SelectedValue = "";
            RequisitionBLL aRequisitionBll = new RequisitionBLL();
            aRequisitionBll.WareHouseLoad(whDropDownList);

        }
        if (centalWHCheckBox.Checked == false)
        {
            DIVCH.Visible = false;
            DIVDC.Visible = true;
            dcDropDownList1.SelectedValue = "";
        }
    }
    protected void whDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("DCStockReport.aspx");
    }
    protected void dcDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        if (nationalCheckBox.Checked == true)
        {
            Session["DC"] = "";
            Session["DC"] = 1;

            Session["ReportView"] = "";
            Session["ReportView"] = 0;

            string ComUnitId = dcDropDownList1.SelectedValue;

            string url = "../SInventory_RPTVIEW/DCStockReportViewer.aspx?comUnitId=" + ComUnitId;
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
        if (centalWHCheckBox.Checked == false && nationalCheckBox.Checked == false && dcDropDownList1.SelectedValue != "")
        {
            //dc rpt
            Session["DC"] = 1;
            Session["ReportView"] = "";
            Session["ReportView"] = 0;
            string ComUnitId = dcDropDownList1.SelectedValue;

            string url = "../SInventory_RPTVIEW/DCStockReportViewer.aspx?comUnitId=" + ComUnitId;
                string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
                ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
        if (whDropDownList.SelectedValue != "" && centalWHCheckBox.Checked == true)
        {
            //wh rpt
            Session["DC"] = "";
            Session["DC"] = 0;

            Session["ReportView"] = "";
            Session["ReportView"] = 0;

            string ComUnitId = dcDropDownList1.SelectedValue;

            string url = "../SInventory_RPTVIEW/DCStockReportViewer.aspx?comUnitId=" + ComUnitId;
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void nationalCheckBox_CheckedChanged(object sender, EventArgs e)
    {

        if (nationalCheckBox.Checked)
        {
            dcDropDownList1.Enabled = false;
            centalWHCheckBox.Enabled = false;
            Session["DC"] = "0";
            dcDropDownList1.SelectedValue = string.Empty;
            
        }
        if (nationalCheckBox.Checked == false)
        {
            dcDropDownList1.Enabled = true;
            centalWHCheckBox.Enabled = true;
        }
    }

    protected void reportButton_OnClick(object sender, EventArgs e)
    {
   

        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable= _DAL.GetDCReportListDAL(dcDropDownList1.SelectedValue);
        

        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            loadGridView.DataSource = comUnitDetailDataTable;
            loadGridView.DataBind();
        }
        else
        {
            loadGridView.DataSource = null;
            loadGridView.DataBind();
        }
        //if (nationalCheckBox.Checked == true)
        //{
        //    Session["DC"] = "";
        //    Session["DC"] = 1;

        //    Session["ReportView"] = "";
        //    Session["ReportView"] = 1;
        //    string ComUnitId = dcDropDownList1.SelectedValue;

        //    string url = "../SInventory_RPTVIEW/DCStockReportViewer.aspx?comUnitId=" + ComUnitId;
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
        //if (centalWHCheckBox.Checked == false && nationalCheckBox.Checked == false && dcDropDownList1.SelectedValue != "")
        //{
        //    //dc rpt
        //    Session["DC"] = "";
        //    Session["DC"] = 1;

        //    Session["ReportView"] = "";
        //    Session["ReportView"] = 1;

        //    string ComUnitId = dcDropDownList1.SelectedValue;

        //    string url = "../SInventory_RPTVIEW/DCStockReportViewer.aspx?comUnitId=" + ComUnitId;
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
        //if (whDropDownList.SelectedValue != "" && centalWHCheckBox.Checked == true)
        //{
        //    //wh rpt
        //    Session["DC"] = "";
        //    Session["DC"] = 0;

        //    Session["ReportView"] = "";
        //    Session["ReportView"] = 1;

        //    string ComUnitId = dcDropDownList1.SelectedValue;

        //    string url = "../SInventory_RPTVIEW/DCStockReportViewer.aspx?comUnitId=" + ComUnitId;
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
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
    protected void btnExport_Click(object sender, EventArgs e)
    {
        if (loadGridView.Rows.Count > 0)
        {






            Response.ClearContent();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", "Stock_Report_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls"));
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);
            loadGridView.AllowPaging = false;
            //Change the Header Row back to white color
            loadGridView.HeaderRow.Style.Add("background-color", "#FFFFFF");
            //Applying stlye to gridview header cells
            for (int i = 0; i < loadGridView.HeaderRow.Cells.Count; i++)
            {
                loadGridView.HeaderRow.Cells[i].Style.Add("background-color", "#8BA8E0");
            }
            int j = 1;
            //This loop is used to apply stlye to cells based on particular row
            foreach (GridViewRow gvrow in loadGridView.Rows)
            {
                gvrow.BackColor = Color.White;
                if (j <= loadGridView.Rows.Count)
                {
                    if (j % 2 != 0)
                    {
                        for (int k = 0; k < gvrow.Cells.Count; k++)
                        {
                            gvrow.Cells[k].Style.Add("background-color", "#EFF3FB");
                        }
                    }
                }
                j++;
            }

            string headerTable = @"<span  style='text-align:center'><h3>  Stock Report  </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

          

            HttpContext.Current.Response.Write(headerTable);
        
            loadGridView.RenderControl(htw);
            Response.Write(sw.ToString());
            Response.End();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
    }

    public override void VerifyRenderingInServerForm(System.Web.UI.Control control)
    {
        //confirms that an HtmlForm control is rendered for the
        //specified ASP.NET server control at run time.
    }
    private string Parm()
    {
        string param = "";
        if (nationalCheckBox.Checked)
        {

        }
        else
        {
            if (dcDropDownList1.SelectedValue != "")
            {
                param = param + " AND DCS.ComUnitId='" + dcDropDownList1.SelectedValue + "' ";
            }
        }
        
         
        return param;
    }
}