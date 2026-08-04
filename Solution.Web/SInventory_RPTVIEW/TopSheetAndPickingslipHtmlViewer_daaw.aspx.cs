using System;
using System.Data;
using System.Text;
using System.Linq;
using Library.BLL.SInventory_BLL;

public partial class SInventory_RPTVIEW_TopSheetAndPickingslipHtmlViewer_daaw : System.Web.UI.Page
{
    InvoiceBLL_daaw aInvoiceBll = new InvoiceBLL_daaw();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string batchNo = Request.QueryString["BatchNo"];
            if (!string.IsNullOrEmpty(batchNo))
            {
                litBatchNo.Text = batchNo;
                litBatchNoJs.Text = batchNo;
                litPrintDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                litDeliveryMan.Text = ""; 

                LoadReport(batchNo);
            }
        }
    }

    private void LoadReport(string batchNo)
    {
        DataTable dtTopSheet = aInvoiceBll.GetTopSheetByBatchNo_daaw(batchNo);
        litTopSheetContent.Text = GenerateTopSheetHtml(dtTopSheet);

        DataTable dtPickingSlip = aInvoiceBll.GetMarketwisePickingslipByBatchNo_daaw(batchNo);
        litPickingSlipContent.Text = GeneratePickingSlipHtml(dtPickingSlip);
    }

    private string GenerateTopSheetHtml(DataTable dt)
    {
        if (dt == null || dt.Rows.Count == 0) return "<p>No data found for Topsheet.</p>";

        if (dt.Columns.Contains("SalesAsistant"))
        {
            string salesAssistantName = dt.Rows[0]["SalesAsistant"].ToString();
            if (!string.IsNullOrEmpty(salesAssistantName))
            {
                litDeliveryMan.Text = salesAssistantName;
            }
        }

        StringBuilder sb = new StringBuilder();
        var groupedRows = dt.AsEnumerable().GroupBy(r => r.Field<string>("MarketName"));

        foreach (var group in groupedRows)
        {
            sb.AppendFormat("<div style='font-weight: bold; font-size: 13px; margin: 15px 0 5px 0;'>{0}</div>", group.Key);
            sb.Append("<table>");
            sb.Append("<thead><tr>");
            sb.Append("<th>SL</th>");
            sb.Append("<th>Code</th>");
            sb.Append("<th>Customer Name</th>");
            sb.Append("<th>CustomerType</th>");
            sb.Append("<th>Address</th>");
            sb.Append("<th>Cell No</th>");
            sb.Append("<th>Invoice Number</th>");
            sb.Append("<th>Invoice Date</th>");
            sb.Append("<th>Amount</th>");
            sb.Append("<th>Remarks</th>");
            sb.Append("</tr></thead><tbody>");

            int sl = 1;
            decimal grandTotal = 0;

            foreach (DataRow row in group)
            {
                string code = dt.Columns.Contains("CustomerCode") ? row["CustomerCode"].ToString() : "";
                string custName = dt.Columns.Contains("CustomerName") ? row["CustomerName"].ToString() : "";
                string custType = dt.Columns.Contains("CustomerType") ? row["CustomerType"].ToString() : "";
                string address = dt.Columns.Contains("Address") ? row["Address"].ToString() : "";
                string cellNo = dt.Columns.Contains("CellNo") ? row["CellNo"].ToString() : "";
                string invoiceNo = dt.Columns.Contains("InvoiceNo") ? row["InvoiceNo"].ToString() : "";
                string invoiceDate = "";
                if (dt.Columns.Contains("InvoiceDate") && row["InvoiceDate"] != DBNull.Value)
                {
                    invoiceDate = Convert.ToDateTime(row["InvoiceDate"]).ToString("dd-MMM-yyyy");
                }
                
                decimal amount = 0;
                if (dt.Columns.Contains("TpGrandTotal") && row["TpGrandTotal"] != DBNull.Value)
                {
                    amount = Convert.ToDecimal(row["TpGrandTotal"]);
                }
                grandTotal += amount;
                
                string remarks = dt.Columns.Contains("Remarks") ? row["Remarks"].ToString() : "";

                sb.Append("<tr>");
                sb.AppendFormat("<td>{0}</td>", sl++);
                sb.AppendFormat("<td>{0}</td>", code);
                sb.AppendFormat("<td class='text-left'>{0}</td>", custName);
                sb.AppendFormat("<td>{0}</td>", custType);
                sb.AppendFormat("<td class='text-left'>{0}</td>", address);
                sb.AppendFormat("<td>{0}</td>", cellNo);
                sb.AppendFormat("<td>{0}</td>", invoiceNo);
                sb.AppendFormat("<td>{0}</td>", invoiceDate);
                sb.AppendFormat("<td class='text-right'>{0:N2}</td>", amount);
                sb.AppendFormat("<td>{0}</td>", remarks);
                sb.Append("</tr>");
            }

            sb.Append("</tbody>");
            sb.Append("<tfoot><tr>");
            sb.Append("<td colspan='8' class='text-right' style='font-weight: bold; border-right: none;'>Grand Total &gt;&gt;</td>");
            sb.AppendFormat("<td class='text-right' style='font-weight: bold; border-left: none;'>{0:N2}</td>", grandTotal);
            sb.Append("<td></td>");
            sb.Append("</tr></tfoot>");
            sb.Append("</table>");
        }

        return sb.ToString();
    }

    private string GeneratePickingSlipHtml(DataTable dt)
    {
        if (dt == null || dt.Rows.Count == 0) return "<p>No data found for Store Picking.</p>";

        StringBuilder sb = new StringBuilder();
        var groupedRows = dt.AsEnumerable().GroupBy(r => r.Field<string>("MarketName"));

        foreach (var group in groupedRows)
        {
            sb.AppendFormat("<div style='font-weight: bold; font-size: 13px; margin: 20px 0 5px 0;'>{0}</div>", group.Key);
            sb.Append("<table>");
            sb.Append("<thead><tr>");
            sb.Append("<th>SL</th>");
            sb.Append("<th>Product Code</th>");
            sb.Append("<th class='text-left'>Product Name</th>");
            sb.Append("<th>BatchNo</th>");
            sb.Append("<th>Pack Size</th>");
            sb.Append("<th>Quantity</th>");
            sb.Append("</tr></thead><tbody>");

            int sl = 1;
            foreach (DataRow row in group)
            {
                string prodCode = dt.Columns.Contains("ProductCode") ? row["ProductCode"].ToString() : "";
                string prodName = dt.Columns.Contains("ProductName") ? row["ProductName"].ToString() : "";
                string batch = dt.Columns.Contains("BatchNo") ? row["BatchNo"].ToString() : "";
                string packSize = dt.Columns.Contains("PackSize") ? row["PackSize"].ToString() : "";
                string quantity = dt.Columns.Contains("Quantity") ? row["Quantity"].ToString() : "0";

                sb.Append("<tr>");
                sb.AppendFormat("<td>{0}</td>", sl++);
                sb.AppendFormat("<td>{0}</td>", prodCode);
                sb.AppendFormat("<td class='text-left'>{0}</td>", prodName);
                sb.AppendFormat("<td>{0}</td>", batch);
                sb.AppendFormat("<td>{0}</td>", packSize);
                sb.AppendFormat("<td>{0}</td>", quantity);
                sb.Append("</tr>");
            }
            sb.Append("</tbody></table>");
        }

        return sb.ToString();
    }
}
