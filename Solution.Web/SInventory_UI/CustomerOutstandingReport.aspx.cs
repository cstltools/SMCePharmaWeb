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

public partial class SInventory_UI_CustomerOutstandingReport : System.Web.UI.Page
{
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    CustomerMasterBLL aCustomerMasterBll = new CustomerMasterBLL();
    private static CmnCrystaltoView _DAL = new CmnCrystaltoView();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //if (Session["UserType"].ToString() != "")
            //{
            //    if (Session["UserType"].ToString() == "Admin")
            //    {
            //        aCustomerMasterBll.LoadDcDropDownList(dcDropDownList);
            //    }
            //    else
            //    {
            //        string comUnit = Session["ComUnitId"].ToString();
            //        aCustomerMasterBll.LoadDcDropDownList(dcDropDownList, comUnit);
            //    }
            //}
            //else
            //{
            //    Response.Redirect("Login.aspx");
            //}
            if (!IsPostBack)
            {
                DropDownlist();
            }
        }
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("CustomerOutstandingReport.aspx");
    }
    protected void CheckBox1_CheckedChanged1(object sender, EventArgs e)
    {
        if (CheckBox1.Checked)
        {
            salesCenterDropDownList.Enabled = false;
            salesCenterDropDownList.SelectedValue = string.Empty;
        }
        if (CheckBox1.Checked == false)
        {
            salesCenterDropDownList.Enabled = true;
        }
    }
    public void DropDownlist()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        aOrderInfoBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());
        //salesCenterDropDownList.SelectedIndex = 1;
    }
    public void LoadDC()
    {
       // aRequisitionBll.DCLoad(dcDropDownList);
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {



        DataTable comUnitDetailDataTable = new DataTable();


        //comUnitDetailDataTable = _DAL.GetAllPaymentReportListDAL(Parm());


        //if (comUnitDetailDataTable.Rows.Count > 0)
        //{
        //    loadGridView.DataSource = comUnitDetailDataTable;
        //    loadGridView.DataBind();
        //}
        //else
        //{
        //    loadGridView.DataSource = null;
        //    loadGridView.DataBind();
        //}

        if (CheckBox1.Checked==false)
        {
            Session["PaymentReport"] = "";
            Session["PaymentReport"] = "SC";
            if (fromDateTextBox.Text != "" && todateTextBox.Text != "" && paymentTermsDropdown.SelectedValue != "" && salesCenterDropDownList.SelectedValue != "")
            {
                string fromDate = fromDateTextBox.Text;
                string toDate = todateTextBox.Text;
                string url = "../SInventory_RPTVIEW/CustomerPaymentViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&payment=" + paymentTermsDropdown.SelectedValue + "&salesCenter=" + salesCenterDropDownList.SelectedValue;
                string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
                ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
            }
            else
            {
                showMessageBox("Select Date Range and Sales Center Name!!");
            }
        }
        else
        {
            Session["PaymentReport"] = "";
            Session["PaymentReport"] = "NAT";
            if (fromDateTextBox.Text != "" && todateTextBox.Text != "" && paymentTermsDropdown.SelectedValue != "" && CheckBox1.Checked ==true)
            {
                string fromDate = fromDateTextBox.Text;
                string toDate = todateTextBox.Text;
                string url = "../SInventory_RPTVIEW/CustomerPaymentViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&payment=" + paymentTermsDropdown.SelectedValue + "&salesCenter=" + salesCenterDropDownList.SelectedValue;
                string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
                ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
            }
            else
            {
                showMessageBox("Select Date Range and National CheckBox!!");
            }
        }

    }
    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        aOrderInfoBll.LoadMarket(marketDropDownList, salesCenterDropDownList.SelectedValue);
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private string Parm()
    {

        string param = "";
        if (CheckBox1.Checked)
        {


        }
        else
        {
            if (salesCenterDropDownList.SelectedValue != "")
            {
                param = param + " AND  CU.ComUnitId='" + salesCenterDropDownList.SelectedValue + "' ";
            }
        }
        if (paymentTermsDropdown.SelectedValue != "")
        {
            param = param + " AND CU.ComUnitId='" + paymentTermsDropdown.SelectedValue + "' ";
        }
        if (fromDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,I.UpdateDate)  BETWEEN '" + fromDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (fromDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,I.UpdateDate)  BETWEEN '" + fromDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }

        return param;
    }




    protected void btnExport_Click(object sender, EventArgs e)
    {
        if (loadGridView.Rows.Count > 0)
        {






            Response.ClearContent();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", "All_Sales_Report_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls"));
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

            string headerTable = @"<span  style='text-align:center'><h3>  All Sales Report  </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";



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

    public override void VerifyRenderingInServerForm(System.Web.UI.Control control)
    {
        //confirms that an HtmlForm control is rendered for the
        //specified ASP.NET server control at run time.
    }
}