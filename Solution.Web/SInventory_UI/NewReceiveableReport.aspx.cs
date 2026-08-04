using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.SInventory_DAL;

public partial class SInventory_UI_NewReceiveableReport : System.Web.UI.Page
{

    InvoiceDAL aInvoiceDal = new InvoiceDAL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            InvoiceDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            todateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            LoadDropDown();
        }
    }

    protected void fromDateTextBox_TextChanged(object sender, EventArgs e)
    {
        DateTime Fromd = Convert.ToDateTime("01-Apr-2022");
        DateTime inputDateTime = Convert.ToDateTime(InvoiceDateTextBox.Text);
        if (inputDateTime < Fromd)
        {
            InvoiceDateTextBox.Text = DateTime.Now.ToString("01 April, 2022");
        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        if (loadGridView.Rows.Count > 0)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Receivable_Report_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".csv");
            Response.Charset = "";
            Response.ContentType = "text/csv";
            Response.ContentEncoding = Encoding.Default;
            //To Export all pages.
            loadGridView.AllowPaging = false;
            this.LoadData();

            StringBuilder sb = new StringBuilder();
            foreach (TableCell cell in loadGridView.HeaderRow.Cells)
            {
                //Append data with separator.
                sb.Append(HttpUtility.HtmlDecode(cell.Text) + ',');
            }
            //Append new line character.
            sb.Append("\r\n");

            foreach (GridViewRow row in loadGridView.Rows)
            {
                foreach (TableCell cell in row.Cells)
                {
                    //Append data with separator.
                    if (cell.Text.Contains(","))
                    {
                        sb.Append(String.Format("\"{0}\",", cell.Text));
                    }
                    else
                    { sb.Append(HttpUtility.HtmlDecode(cell.Text) + ','); }
                }
                //Append new line character.
                sb.Append("\r\n");
            }

            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        }

        //if (loadGridView.Rows.Count > 0)
        //{
        //    string attachment = "attachment; filename= Receivable Report_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
        //    Response.ClearContent();
        //    Response.AddHeader("content-disposition", attachment);
        //    Response.ContentType = "application/ms-excel";
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter htw = new HtmlTextWriter(sw);

        //    loadGridView.AllowPaging = false;

        //    //loadGridView.Columns[loadGridView.Columns.Count - 1].Visible =
        //    //            false;
        //    //loadGridView.Columns[loadGridView.Columns.Count - 2].Visible =
        //    //   false;
        //    //loadGridView.Columns[loadGridView.Columns.Count - 3].Visible =
        //    //   false;


        //    // Create a form to contain the grid  
        //    HtmlForm frm = new HtmlForm();
        //    loadGridView.Parent.Controls.Add(frm);
        //    //frm.Attributes["runat"] = "server";
        //    //frm.Controls.Add(loadGridView);
        //    //frm.RenderControl(htw);

        //    loadGridView.HeaderRow.Style.Add("background-color", "#E5EEF1");

        //    // Set background color of each cell of GridView1 header row
        //    foreach (TableCell tableCell in loadGridView.HeaderRow.Cells)
        //    {
        //        tableCell.Style["background-color"] = "#E5EEF1";
        //    }

        //    // Set background color of each cell of each data row of GridView1
        //    foreach (GridViewRow gridViewRow in loadGridView.Rows)
        //    {
        //        gridViewRow.BackColor = System.Drawing.Color.White;

        //        foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
        //        {
        //            gridViewRowTableCell.Style["background-color"] = "#FFFFFF";

        //        }
        //    }

        //    loadGridView.RenderControl(htw);
        //    string headerTable = @"<span  style='text-align:center'><h3> Receivable Report List (Date Range : "+InvoiceDateTextBox.Text+ "- " + todateTextBox.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";



        //    HttpContext.Current.Response.Write(headerTable);

        //    string style = @"<style> .text { mso-number-format:\@; } </style> ";
        //    Response.Write(style);
        //    Response.Write(sw.ToString());
        //    Response.End();
        //}
        //else
        //{
        //    showMessageBox("No Data Found!!");
        //}


    }
    public override void VerifyRenderingInServerForm(System.Web.UI.Control control)
    {
        //confirms that an HtmlForm control is rendered for the
        //specified ASP.NET server control at run time.
    }
   
    public void LoadDropDown()
    {
        OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
       // aOtherStockActionBLL.DCLoad(dcDropDownList1);
        aOtherStockActionBLL.LoadSC(dcDropDownList1, Session["UserId"].ToString());
        dcDropDownList1.Items.Insert(0, new ListItem("Select One", ""));
        dcDropDownList1.SelectedIndex = 0;
    }

    private string Parm()
    {
        string param = "";

        
            if (dcDropDownList1.SelectedValue != "")
            {
                param = param + " AND CU.ComUnitId='" + dcDropDownList1.SelectedValue + "' ";
            }
       
      

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }


        

        return param;
    }
    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadData();
    }
    private void LoadData()
    {
        DataTable aDataTable = new DataTable();
         
            aDataTable = aInvoiceDal.GetNewReceiveableDAlWeb(dcDropDownList1.SelectedValue, InvoiceDateTextBox.Text, todateTextBox.Text);

        EnsureRequestedGridColumns(aDataTable);
        
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();


        if (aDataTable.Rows.Count > 0)
        {
            decimal ReturnAmount = aDataTable.AsEnumerable().Sum(row => GetDecimalValue(row, "ReturnAmount"));


            decimal CustomerPaymentAmount = aDataTable.AsEnumerable().Sum(row => GetDecimalValue(row, "CustomerPaymentAmount"));



            decimal ReceivableTotalAmnt = aDataTable.AsEnumerable().Sum(row => GetDecimalValue(row, "ReceivableTotalAmnt"));
            loadGridView.FooterRow.Font.Bold = true;

            int returnAmountColIndex = GetGridColumnIndexByDataField("ReturnAmount");
            int customerPaymentColIndex = GetGridColumnIndexByDataField("CustomerPaymentAmount");
            int receivableAmountColIndex = GetGridColumnIndexByDataField("ReceivableTotalAmnt");
            int labelColIndex = returnAmountColIndex > 0 ? returnAmountColIndex - 1 : -1;

            if (labelColIndex >= 0)
            {
                loadGridView.FooterRow.Cells[labelColIndex].Text = "Total: ";
            }

            if (returnAmountColIndex >= 0)
            {
                loadGridView.FooterRow.Cells[returnAmountColIndex].Text = ReturnAmount.ToString();
            }

            if (customerPaymentColIndex >= 0)
            {
                loadGridView.FooterRow.Cells[customerPaymentColIndex].Text = CustomerPaymentAmount.ToString();
            }

            if (receivableAmountColIndex >= 0)
            {
                loadGridView.FooterRow.Cells[receivableAmountColIndex].Text = ReceivableTotalAmnt.ToString();
            }
        }

    }

    private void EnsureRequestedGridColumns(DataTable dataTable)
    {
        if (dataTable == null)
        {
            return;
        }

        EnsureGridBoundFieldColumns(dataTable);

        EnsureStringColumn(dataTable, "OrderCreatedByEmpCodeName");
        EnsureStringColumn(dataTable, "OrderCreatedDateTime");
        EnsureStringColumn(dataTable, "RespectiveAMEmpCode");
        EnsureStringColumn(dataTable, "RespectiveDSMEmpCode");
        EnsureStringColumn(dataTable, "paymenttype");

        foreach (DataRow row in dataTable.Rows)
        {
            string existingOrderCreatedBy = GetStringValue(row, dataTable, "OrderCreatedByEmpCodeName");

            string orderCreatedByEmpCode = GetStringValue(row, dataTable,
                "OrderCreatedByEmpCode",
                "OrderCreateByEmpCode",
                "CreatedByEmpCode",
                "OrderByEmpCode",
                "OrderCreatedBy",
                "OrderCreateBy",
                "CreatedBy",
                "CreateBy",
                "UserId",
                "MainMIOCODE",
                "MIACode",
                "MiaCode");

            string orderCreatedByEmpName = GetStringValue(row, dataTable,
                "OrderCreatedByEmpName",
                "OrderCreateByEmpName",
                "CreatedByEmpName",
                "OrderByEmpName",
                "OrderCreatedByName",
                "OrderCreateByName",
                "CreatedByName",
                "CreateByName",
                "UserName",
                "EmpName",
                "EmployeeName",
                "MainMIONAME",
                "MIAName",
                "MiaName");

            string orderCreatedByDisplay = BuildEmpDisplay(orderCreatedByEmpCode, orderCreatedByEmpName);
            if (string.IsNullOrWhiteSpace(orderCreatedByDisplay))
            {
                orderCreatedByDisplay = existingOrderCreatedBy;
            }
            row["OrderCreatedByEmpCodeName"] = orderCreatedByDisplay;

            string orderCreatedDateTimeRaw = GetStringValue(row, dataTable,
                "OrderCreatedDateTime",
                "OrderCreateDateTime",
                "OrderCreatedDate",
                "CreateDate",
                "CreatedDate",
                "OrderDate");
            row["OrderCreatedDateTime"] = FormatDateTimeValue(orderCreatedDateTimeRaw);

            string amEmpCode = GetStringValue(row, dataTable,
                "RespectiveAMEmpCode",
                "AMEmpCode",
                "AMCode",
                "AreaCode",
                "RespectiveAMCode");
            if (string.IsNullOrWhiteSpace(amEmpCode))
            {
                amEmpCode = GetStringValue(row, dataTable, "RespectiveAMEmpCode");
            }
            row["RespectiveAMEmpCode"] = amEmpCode;

            string dsmEmpCode = GetStringValue(row, dataTable,
                "RespectiveDSMEmpCode",
                "DSMEmpCode",
                "DZSMCode",
                "ZSMCode",
                "RespectiveDSMCode",
                "RegionCode",
                "DisCode");
            if (string.IsNullOrWhiteSpace(dsmEmpCode))
            {
                dsmEmpCode = GetStringValue(row, dataTable, "RespectiveDSMEmpCode");
            }
            row["RespectiveDSMEmpCode"] = dsmEmpCode;

            row["paymenttype"] = GetStringValue(row, dataTable,
                "paymenttype",
                "PaymentType",
                "Payment_Type");
        }
    }

    private void EnsureGridBoundFieldColumns(DataTable dataTable)
    {
        foreach (DataControlField field in loadGridView.Columns)
        {
            BoundField boundField = field as BoundField;
            if (boundField == null || string.IsNullOrWhiteSpace(boundField.DataField))
            {
                continue;
            }

            EnsureStringColumn(dataTable, boundField.DataField);
        }
    }

    private void EnsureStringColumn(DataTable dataTable, string columnName)
    {
        if (!dataTable.Columns.Contains(columnName))
        {
            dataTable.Columns.Add(columnName, typeof(string));
        }
    }

    private string GetStringValue(DataRow row, DataTable dataTable, params string[] candidateColumnNames)
    {
        foreach (string columnName in candidateColumnNames)
        {
            if (!dataTable.Columns.Contains(columnName))
            {
                continue;
            }

            object rawValue = row[columnName];
            if (rawValue == null || rawValue == DBNull.Value)
            {
                continue;
            }

            string value = rawValue.ToString().Trim();
            if (value != string.Empty)
            {
                return value;
            }
        }

        return string.Empty;
    }

    private string BuildEmpDisplay(string empCode, string empName)
    {
        if (empCode != string.Empty && empName != string.Empty)
        {
            return empCode + " - " + empName;
        }

        if (empCode != string.Empty)
        {
            return empCode;
        }

        return empName;
    }

    private string FormatDateTimeValue(string rawValue)
    {
        if (rawValue == string.Empty)
        {
            return string.Empty;
        }

        DateTime parsedDateTime;
        if (DateTime.TryParse(rawValue, out parsedDateTime))
        {
            return parsedDateTime.ToString("dd MMM yyyy hh:mm tt");
        }

        if (DateTime.TryParseExact(
            rawValue,
            new[] { "dd/MM/yyyy", "MM/dd/yyyy", "dd-MMM-yyyy", "yyyy-MM-dd", "dd MMM yyyy" },
            CultureInfo.InvariantCulture,
            DateTimeStyles.None,
            out parsedDateTime))
        {
            return parsedDateTime.ToString("dd MMM yyyy hh:mm tt");
        }

        return rawValue;
    }

    private decimal GetDecimalValue(DataRow row, string columnName)
    {
        if (row == null || row.Table == null || !row.Table.Columns.Contains(columnName))
        {
            return 0m;
        }

        object rawValue = row[columnName];
        if (rawValue == null || rawValue == DBNull.Value)
        {
            return 0m;
        }

        decimal parsedValue;
        if (decimal.TryParse(rawValue.ToString(), out parsedValue))
        {
            return parsedValue;
        }

        return 0m;
    }

    private int GetGridColumnIndexByDataField(string dataField)
    {
        for (int i = 0; i < loadGridView.Columns.Count; i++)
        {
            BoundField boundField = loadGridView.Columns[i] as BoundField;
            if (boundField == null)
            {
                continue;
            }

            if (string.Equals(boundField.DataField, dataField, StringComparison.OrdinalIgnoreCase))
            {
                return i;
            }
        }

        return -1;
    }
    protected void SearchButton_Click(object sender, EventArgs e)
    {
        loadGridView.PageIndex = 0;
        LoadData();

        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "" && dcDropDownList1.SelectedValue != "")
        //{
        //    if (todateTextBox.Text == "")
        //    {
        //        InvoiceDateTextBox.Text = todateTextBox.Text;
        //    }

        //    Session["Excel"] = "";
        //    Session["Excel"] = "N";

        //    string fromDate = InvoiceDateTextBox.Text;
        //    string toDate = todateTextBox.Text;
        //    string districtId = dcDropDownList1.SelectedValue;

        //    string url = "../SInventory_RPTVIEW/InTransitReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&districtId=" + districtId;
        //    // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
        //if (CheckBox1.Checked && todateTextBox.Text != "" && InvoiceDateTextBox.Text != "")
        //{
        //    Session["Excel"] = "";
        //    Session["Excel"] = "N";

        //    int i = 1;
        //    string fromDate = InvoiceDateTextBox.Text;
        //    string toDate = todateTextBox.Text;
        //    string url = "../SInventory_RPTVIEW/InTransitReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&NationalReport=" + 1;
        //    // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}

    }
    protected void dcDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
   
    protected void excelButton_OnClick(object sender, EventArgs e)
    {
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "" && dcDropDownList1.SelectedValue != "")
        {
            if (todateTextBox.Text == "")
            {
                InvoiceDateTextBox.Text = todateTextBox.Text;
            }

            Session["Excel"] = "";
            Session["Excel"] = "Y";

            string fromDate = InvoiceDateTextBox.Text;
            string toDate = todateTextBox.Text;
            string districtId = dcDropDownList1.SelectedValue;

            string url = "../SInventory_RPTVIEW/InTransitReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&districtId=" + districtId;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
        if (  dcDropDownList1.SelectedValue == "" && todateTextBox.Text != "" && InvoiceDateTextBox.Text != "")
        {
            Session["Excel"] = "";
            Session["Excel"] = "Y";

            int i = 1;
            string fromDate = InvoiceDateTextBox.Text;
            string toDate = todateTextBox.Text;
            string url = "../SInventory_RPTVIEW/InTransitReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&NationalReport=" + 1;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("InTransitReport.aspx");
    }
}
