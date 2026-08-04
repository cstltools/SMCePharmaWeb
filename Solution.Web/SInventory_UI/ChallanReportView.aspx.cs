using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ChallanReportView : System.Web.UI.Page
{
    DataTable aTable = new DataTable();
    ChallanReportViewBLL aRequisitionBll = new ChallanReportViewBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
            aOrderInfoBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());
            salesCenterDropDownList.SelectedIndex = 1;
        }
    }

    public void ClearGrid()
    {
        reportListGridView.DataSource = null;
        reportListGridView.DataBind();

        summaryGridView.DataSource = null;
        summaryGridView.DataBind();

        detailsGridView.DataSource = null;
        detailsGridView.DataBind();
    }
    protected void searchButton_Click(object sender, EventArgs e)
    {
        ClearGrid();
        if (salesCenterDropDownList.SelectedValue != "")
        {
            aTable = aRequisitionBll.ChallanReportDAL2(Convert.ToDateTime(dateTextBox.Text.Trim()), Convert.ToDateTime(TextBox1.Text.Trim()), salesCenterDropDownList.SelectedValue);
            if (aTable.Rows.Count>0)
            {
                reportListGridView.DataSource = null;
                reportListGridView.DataBind();
                reportListGridView.DataSource = aTable;
                reportListGridView.DataBind();
            }
            else
            {

                reportListGridView.DataSource = null;
                reportListGridView.DataBind();
                showMessageBox("No Data Found!");
            }

            
        }
        else
        {
            aTable = aRequisitionBll.ChallanReportDAL2(Convert.ToDateTime(dateTextBox.Text.Trim()), Convert.ToDateTime(TextBox1.Text.Trim()));
            if (aTable.Rows.Count > 0)
            {
                reportListGridView.DataSource = null;
                reportListGridView.DataBind();
                reportListGridView.DataSource = aTable;
                reportListGridView.DataBind();
            }
            else
            {

                reportListGridView.DataSource = null;
                reportListGridView.DataBind();
                showMessageBox("No Data Found!");
            }

        }
    }
    protected void summaryButton_Click(object sender, EventArgs e)
    {
        SummaryGrid();
    }

    private void SummaryGrid()
    {
        ClearGrid();
        if (salesCenterDropDownList.SelectedValue != "")
        {
            aTable = aRequisitionBll.ChallanSummaryReportDAL2(Convert.ToDateTime(dateTextBox.Text.Trim()),
                Convert.ToDateTime(TextBox1.Text.Trim()), salesCenterDropDownList.SelectedValue);
            if (aTable.Rows.Count > 0)
            {
                summaryGridView.DataSource = null;
                summaryGridView.DataBind();
                summaryGridView.DataSource = aTable;
                summaryGridView.DataBind();
            }
            else
            {
                summaryGridView.DataSource = null;
                summaryGridView.DataBind();
                showMessageBox("No Data Found!");
            }
        }
        else
        {
            aTable = aRequisitionBll.ChallanSummaryReportDAL2(Convert.ToDateTime(dateTextBox.Text.Trim()),
                Convert.ToDateTime(TextBox1.Text.Trim()));
            if (aTable.Rows.Count > 0)
            {
                summaryGridView.DataSource = null;
                summaryGridView.DataBind();
                summaryGridView.DataSource = aTable;
                summaryGridView.DataBind();
            }
            else
            {
                summaryGridView.DataSource = null;
                summaryGridView.DataBind();
                showMessageBox("No Data Found!");
            }
        }
    }

    protected void detailsButton_Click(object sender, EventArgs e)
    {
        DetailsGrid();
    }

    private void DetailsGrid()
    {
        ClearGrid();
        if (salesCenterDropDownList.SelectedValue != "")
        {
            aTable = aRequisitionBll.ChallanDetailReportDAL2(Convert.ToDateTime(dateTextBox.Text.Trim()),
                Convert.ToDateTime(TextBox1.Text.Trim()), salesCenterDropDownList.SelectedValue);
            if (aTable.Rows.Count > 0)
            {
                detailsGridView.DataSource = null;
                detailsGridView.DataBind();
                detailsGridView.DataSource = aTable;
                detailsGridView.DataBind();
            }
            else
            {
                detailsGridView.DataSource = null;
                detailsGridView.DataBind();
                showMessageBox("No Data Found!");
            }
        }
        else
        {
            aTable = aRequisitionBll.ChallanDetailReportDAL2(Convert.ToDateTime(dateTextBox.Text.Trim()),
                Convert.ToDateTime(TextBox1.Text.Trim()));
            if (aTable.Rows.Count > 0)
            {
                detailsGridView.DataSource = null;
                detailsGridView.DataBind();
                detailsGridView.DataSource = aTable;
                detailsGridView.DataBind();
            }
            else
            {
                detailsGridView.DataSource = null;
                reportListGridView.DataBind();
                showMessageBox("No Data Found!");
            }
        }
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void printButton_Click(object sender, EventArgs e)
    {
        int iRowIndex = (((Button)sender).Parent.Parent as GridViewRow).RowIndex;
        string reqId = reportListGridView.DataKeys[iRowIndex][0].ToString();

       //// Requesition companyUnit = new Requesition();
       //// ChallanReportViewBLL _companyUnitBll = new ChallanReportViewBLL();
       //// companyUnit = _companyUnitBll.CheckAlreadyDone(reqId);

       //// string check = "";
       ////check = companyUnit.tra.ToString();

       //// if (check==true)
       //// {
       ////     showMessageBox("Can Not Edited");
       //// }
       //// else
       //// {
            string url = "../SInventory_RPTVIEW/ChallanReportViewer.aspx?reqId=" + reqId;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        ////}
       
    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        if (CheckBox1.Checked)
        {
            salesCenterDropDownList.SelectedValue = "";
            salesCenterDropDownList.Enabled = false;
        }
        else
        {
            salesCenterDropDownList.Enabled = true;
        }
    }
    public override void VerifyRenderingInServerForm(Control control)
    {
        // //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
    }
    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        if (detailsGridView.Rows.Count > 0)
        {
            string attachment = "attachment; filename=ChallanReport.xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            detailsGridView.AllowPaging = false;



            //loadGridView.Columns[loadGridView.Columns.Count - 1].Visible =
            //            false;
            //loadGridView.Columns[loadGridView.Columns.Count - 2].Visible =
            //   false;
            //loadGridView.Columns[loadGridView.Columns.Count - 3].Visible =
            //   false;

            this.DetailsGrid();

            // Create a form to contain the grid  
            HtmlForm frm = new HtmlForm();
            detailsGridView.Parent.Controls.Add(frm);
            //frm.Attributes["runat"] = "server";
            //frm.Controls.Add(loadGridView);
            //frm.RenderControl(htw);

            detailsGridView.HeaderRow.Style.Add("background-color", "#E5EEF1");

            // Set background color of each cell of GridView1 header row
            foreach (TableCell tableCell in detailsGridView.HeaderRow.Cells)
            {
                tableCell.Style["background-color"] = "#E5EEF1";
            }

            // Set background color of each cell of each data row of GridView1
            foreach (GridViewRow gridViewRow in detailsGridView.Rows)
            {
                gridViewRow.BackColor = System.Drawing.Color.White;

                foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                {
                    gridViewRowTableCell.Style["background-color"] = "#FFFFFF";

                }
            }


            detailsGridView.RenderControl(htw);
            string headerTable = @"<span  style='text-align:left'><h4>From Date : " + dateTextBox.Text + "</h4> <h4> To Date : " + TextBox1.Text + "</h4>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("dd/MMMM/yyyy") + "</h4></span>";

            string SubTi = @"<span   style='text-align:center'>
   <h3>Challan Report	</h3>

</span>";

            HttpContext.Current.Response.Write(headerTable);
            HttpContext.Current.Response.Write(SubTi);
            Response.Write(sw.ToString());
            Response.End();
        }
        else if (summaryGridView.Rows.Count > 0)
        {
            string attachment = "attachment; filename=ChallanReport.xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            summaryGridView.AllowPaging = false;



            //loadGridView.Columns[loadGridView.Columns.Count - 1].Visible =
            //            false;
            //loadGridView.Columns[loadGridView.Columns.Count - 2].Visible =
            //   false;
            //loadGridView.Columns[loadGridView.Columns.Count - 3].Visible =
            //   false;

            this.SummaryGrid();

            // Create a form to contain the grid  
            HtmlForm frm = new HtmlForm();
            summaryGridView.Parent.Controls.Add(frm);
            //frm.Attributes["runat"] = "server";
            //frm.Controls.Add(loadGridView);
            //frm.RenderControl(htw);

            summaryGridView.HeaderRow.Style.Add("background-color", "#E5EEF1");

            // Set background color of each cell of GridView1 header row
            foreach (TableCell tableCell in summaryGridView.HeaderRow.Cells)
            {
                tableCell.Style["background-color"] = "#E5EEF1";
            }

            // Set background color of each cell of each data row of GridView1
            foreach (GridViewRow gridViewRow in summaryGridView.Rows)
            {
                gridViewRow.BackColor = System.Drawing.Color.White;

                foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                {
                    gridViewRowTableCell.Style["background-color"] = "#FFFFFF";

                }
            }


            summaryGridView.RenderControl(htw);
            string headerTable = @"<span  style='text-align:left'><h4>From Date : " + dateTextBox.Text + "</h4> <h4> To Date : " + TextBox1.Text + "</h4>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("dd/MMMM/yyyy") + "</h4></span>";

            string SubTi = @"<span   style='text-align:center'>
  <h2>SMC Enterprise Limited	</h2>  
<h3>SMC Tower, 33 Banani C/A, Dhaka- 1213	</h3>   
<h4>Central BIN:000049992- 0101	</h4>
<h5>Issueing Office: CWH/Factory</h5>
</span>";

            HttpContext.Current.Response.Write(headerTable);
            HttpContext.Current.Response.Write(SubTi);
            Response.Write(sw.ToString());
            Response.End();
        }

        else
        {
            showMessageBox("No Data Found!!");
        }
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string companyInfoId = reportListGridView.DataKeys[rowindex][0].ToString();
            PopUp(companyInfoId);
        }
    }

    private void PopUp(string Id)
    {
        string url = "ChallanVIewEditNew.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void btnReload_Click(object sender, EventArgs e)
    {
        searchButton_Click(null, null);
    }
}