using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_RptBussinessSummary_DCWise : System.Web.UI.Page
{
    TotalSummaryBLL aSummaryBll = new TotalSummaryBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            PopulateYearDropdown();
            PopulateMonthDropdown();
        }
    }

    private void PopulateYearDropdown()
    {
        ddlYear.Items.Clear();
        ddlYear.Items.Add(new ListItem("Select Year", ""));

        int currentYear = DateTime.Now.Year;
        for (int i = currentYear - 10; i <= currentYear + 5; i++)
        {
            ListItem item = new ListItem(i.ToString(), i.ToString());
            if (i == currentYear)
                item.Selected = true;

            ddlYear.Items.Add(item);
        }
    }

    private void PopulateMonthDropdown()
    {
        ddlMonth.Items.Clear();
        ddlMonth.Items.Add(new ListItem("Select Month", ""));

        string[] monthNames =
        {
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
        };

        int currentMonth = DateTime.Now.Month;
        for (int i = 0; i < 12; i++)
        {
            ListItem item = new ListItem(monthNames[i], (i + 1).ToString());
            if ((i + 1) == currentMonth)
                item.Selected = true;

            ddlMonth.Items.Add(item);
        }
    }

    protected void gv_DCWise_OnRowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView drv = (DataRowView)e.Row.DataItem;
            decimal gross = Math.Round(drv["JustSalesGrossAmt"] == DBNull.Value ? 0 : Convert.ToDecimal(drv["JustSalesGrossAmt"]), 2);
            decimal sap = Math.Round(drv["SAPsendAmount"] == DBNull.Value ? 0 : Convert.ToDecimal(drv["SAPsendAmount"]), 2);

            if (gross != sap)
            {
                e.Row.BackColor = Color.FromArgb(248, 215, 218);
            }
        }
    }

    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        LoadInfo();
    }

    private void LoadInfo()
    {
        gv_DCWise.DataSource = null;
        gv_DCWise.DataBind();

        if (ddlYear.SelectedValue == "" || ddlMonth.SelectedValue == "")
        {
            showMessageBox("Please Select Year and Month!!");
            return;
        }

        int year = Convert.ToInt32(ddlYear.SelectedValue);
        int month = Convert.ToInt32(ddlMonth.SelectedValue);

        DataTable aDataTable = aSummaryBll.LoadRptBussinessSummary_DCWiseDAL(year, month);

        if (aDataTable.Rows.Count > 0)
        {
            gv_DCWise.DataSource = aDataTable;
            gv_DCWise.DataBind();

            try
            {
                // FooterRow.Cells still has one cell per declared BoundField, including the
                // Visible="false" JustSalesAmtTP column (cell index 1) - it just isn't rendered.
                // So cells are 0=DC, 1=hidden TP, 2=Gross Amount, 3=SAP Send Amount.
                gv_DCWise.FooterRow.Cells[0].Text = "Total:";

                decimal justSalesGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesGrossAmt") ?? 0);
                gv_DCWise.FooterRow.Cells[2].Text = justSalesGrossAmt.ToString("N2");

                decimal sapSendAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SAPsendAmount") ?? 0);
                gv_DCWise.FooterRow.Cells[3].Text = sapSendAmount.ToString("N2");

                gv_DCWise.FooterRow.BackColor = Color.Bisque;
                gv_DCWise.FooterRow.Font.Bold = true;
                gv_DCWise.FooterRow.HorizontalAlign = HorizontalAlign.Right;
            }
            catch { }
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void Reset_Click(object sender, EventArgs e)
    {
        Response.Redirect("RptBussinessSummary_DCWise.aspx");
    }

    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        if (ddlYear.SelectedValue == "" || ddlMonth.SelectedValue == "")
        {
            showMessageBox("Please Select Year and Month!!");
            return;
        }

        try
        {
            LoadInfo();

            if (gv_DCWise.Rows.Count == 0)
            {
                showMessageBox("No Data Found!!");
                return;
            }

            string attachment = "attachment; filename=DCWise_NetSales_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            gv_DCWise.AllowPaging = false;

            HtmlForm frm = new HtmlForm();
            gv_DCWise.Parent.Controls.Add(frm);

            gv_DCWise.HeaderRow.Style.Add("background-color", "#E5EEF1");
            foreach (TableCell tableCell in gv_DCWise.HeaderRow.Cells)
            {
                tableCell.Style["background-color"] = "#E5EEF1";
            }

            foreach (GridViewRow gridViewRow in gv_DCWise.Rows)
            {
                gridViewRow.BackColor = Color.White;
                foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                {
                    gridViewRowTableCell.Style["background-color"] = "#FFFFFF";
                }
            }

            gv_DCWise.RenderControl(htw);

            string headerTable = @"<span style='text-align:center'><h3>DC Wise Net Sales Report (" + ddlMonth.SelectedItem.Text + " " + ddlYear.SelectedItem.Text + ")</h3></span> <span style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

            HttpContext.Current.Response.Write(headerTable);
            Response.Write(sw.ToString());
            Response.End();
        }
        catch
        {
            showMessageBox("No Data Found!!");
        }
    }

    public override void VerifyRenderingInServerForm(Control control)
    {
    }
}
