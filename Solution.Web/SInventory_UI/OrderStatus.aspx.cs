using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_OrderStatus : System.Web.UI.Page
{
    OrderStatusBll aOrderStatusBll = new OrderStatusBll();
 
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Clear();

            if (!string.IsNullOrEmpty(Request.QueryString["MID"]))
            {
                orderNoTextBox.Text = Request.QueryString["MID"];
               
            searchButton_OnClick(null, null);
            }
        }
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {

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

    protected void searchButton_OnClick(object sender, EventArgs e)
    {
        if (orderNoTextBox.Text != "")
        {
            DataTable aTable = aOrderStatusBll.LoadOrderStatusInfo(orderNoTextBox.Text.Trim());

            if (aTable.Rows.Count > 0)
            {
                salesCenterCodeTextBox.Text = aTable.Rows[0].Field<String>("ComUnitCode");
                salesCenterNameTextBox.Text = aTable.Rows[0].Field<String>("ComUnitName");
                mioCodeTextBox.Text = aTable.Rows[0].Field<String>("MIOCode");
                mioNameTextBox.Text = aTable.Rows[0].Field<String>("MIOName");
                customerCodeTextBox.Text = aTable.Rows[0].Field<String>("CustomerCode");
                CustomerNameTextBox.Text = aTable.Rows[0].Field<String>("CustomerName");
                grossValueTextBox.Text = aTable.Rows[0].Field<Decimal>("GrossValue").ToString(CultureInfo.InvariantCulture);

                string ddd = "";
                try
                {
                    ddd= aTable.Rows[0].Field<DateTime>("ServerDateTime").ToString("");
                }
                catch(Exception ex)
                {

                }
                submissionDateTextBox.Text = ddd + " : " + aTable.Rows[0].Field<String>("OrderSenderName"); 

                loadGridView.DataSource = aTable;
                loadGridView.DataBind();

                //total
                decimal total = aTable.AsEnumerable().Sum(row => row.Field<decimal?>("Quantity") == null ? 0 : row.Field<decimal>("Quantity"));
                loadGridView.FooterRow.Cells[2].Text = "Total";
                loadGridView.FooterRow.Cells[2].HorizontalAlign = HorizontalAlign.Right;
                loadGridView.FooterRow.Font.Bold =true;
                loadGridView.FooterRow.Cells[3].Text = Math.Round(total).ToString();

                decimal total2 = aTable.AsEnumerable().Sum(row => row.Field<decimal?>("TradePrice") == null ? 0 : row.Field<decimal>("TradePrice"));
                loadGridView.FooterRow.Cells[4].Text = (total2).ToString("");


                decimal total3 = aTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalTradePrice") == null ? 0 : row.Field<decimal>("TotalTradePrice"));
                loadGridView.FooterRow.Cells[5].Text = (total3).ToString("");


                decimal total4 = aTable.AsEnumerable().Sum(row => row.Field<decimal?>("UnitVatAmount") == null ? 0 : row.Field<decimal>("UnitVatAmount"));
                loadGridView.FooterRow.Cells[6].Text = (total4).ToString("");


                decimal total5 = aTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalVatAmount") == null ? 0 : row.Field<decimal>("TotalVatAmount"));
                loadGridView.FooterRow.Cells[7].Text = (total5).ToString("");



                decimal total6 = aTable.AsEnumerable().Sum(row => row.Field<decimal?>("DiscountAmount") == null ? 0 : row.Field<decimal>("DiscountAmount"));
                loadGridView.FooterRow.Cells[9].Text = (total6).ToString("");


                decimal total7 = aTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetAmount") == null ? 0 : row.Field<decimal>("NetAmount"));
                loadGridView.FooterRow.Cells[10].Text = (total7).ToString("");

                //total end

                ProformaInvoiceOperation(orderNoTextBox.Text.Trim());        
            }
            else
            {
                Clear();
                ShowMessageBox("No Data found!!!");
            }           
        }

        else
        {
            Clear();
            ShowMessageBox("Please Search by Order Number !!!");
        }
    }

    private void PaymentStatusOperation(string orderNo)
    {
        paymentMsgLabel.Text = "";

        DataTable aTable = aOrderStatusBll.CheckPaymentStatus(orderNo);

        if (aTable.Rows.Count > 0)
        {
            paymentAmountLabel.Text = aTable.Rows[0].Field<Decimal>("PaymentAmount").ToString(CultureInfo.InvariantCulture); ;
            paymentStatusLabel.Text = aTable.Rows[0].Field<String>("PaymentStatus");
        }
        else
        {
            paymentMsgLabel.Text = "No Payment Information found !!!";
            PaymentStatusOperationClear();
        }
    }

    private void PaymentStatusOperationClear()
    {
        paymentAmountLabel.Text = "";
        paymentStatusLabel.Text = "";
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
    }

        //protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        //{
        //    if (e.Row.RowType == DataControlRowType.Footer)
        //    {
        //        Label lbl = (Label)e.Row.FindControl("lblTotal");
        //        lbl.Text = grdTotal.ToString("c");
        //    }
        //}
        private void DeliveryInvoiceOperation(string orderNo)
    {
        deliveryInvoiceMsgLabel.Text = "";
        deliveryInvoiceMsgLabel.CssClass = "";
        DataTable aTable = aOrderStatusBll.CheckDeliveryInvoiceExistOrNot(orderNo);

        if (aTable.Rows.Count > 0)
        {
            DataTable invoiceInfo = aOrderStatusBll.LoadDeliveryInvoiceInfo(orderNo);

            if (invoiceInfo.Rows.Count > 0)
            {
                deliveryInvoiceNumberLabel.Text = invoiceInfo.Rows[0].Field<String>("DelivaryInvoiceNo");
                deliveryTPTotalLabel.Text = invoiceInfo.Rows[0].Field<Decimal>("DeliveryTpTotal").ToString(CultureInfo.InvariantCulture);
                deliveryTPDiscountLabel.Text = invoiceInfo.Rows[0].Field<Decimal>("DeliveryTpDiscount").ToString(CultureInfo.InvariantCulture);
                deliveryTPVATLabel.Text = invoiceInfo.Rows[0].Field<Decimal>("DeliveryTpVat").ToString(CultureInfo.InvariantCulture);
                deliveryTPGrandTotalLabel.Text = invoiceInfo.Rows[0].Field<Decimal>("DeliveryTpGrandTotal").ToString(CultureInfo.InvariantCulture);
                deliveryStatusLabel.Text = invoiceInfo.Rows[0].Field<String>("DeliveryInvoiceStatus");

                deliveryGridView.DataSource = invoiceInfo;
                deliveryGridView.DataBind();

                PaymentStatusOperation(orderNoTextBox.Text.Trim());
            }
        }

        else
        {
            deliveryInvoiceMsgLabel.Text = "No Delivery Invoice found !!!";
            deliveryInvoiceMsgLabel.CssClass = " alert alert-warning";

            DeliveryInvoiceOperationClear();
            PaymentStatusOperation(orderNoTextBox.Text.Trim());

        }
    }

    private void DeliveryInvoiceOperationClear()
    {
        deliveryInvoiceNumberLabel.Text = "";
        deliveryTPTotalLabel.Text = "";
        deliveryTPDiscountLabel.Text = "";
        deliveryTPVATLabel.Text = "";
        deliveryTPGrandTotalLabel.Text = "";
        deliveryStatusLabel.Text = "";

        deliveryGridView.DataSource = null;
        deliveryGridView.DataBind();
    }

    private void ProformaInvoiceOperation(string orderNo)
    {
        proformaMessageLabel.Text  = "";
        proformaMessageLabel.CssClass = "";
    DataTable aTable = aOrderStatusBll.CheckInvoiceExistOrNot(orderNo);

        if (aTable.Rows.Count > 0)
        {
            DataTable invoiceInfo = aOrderStatusBll.LoadProformaInvoiceInfo(orderNo);

            if (invoiceInfo.Rows.Count > 0)
            {
                invoiceNumberLabel.Text = invoiceInfo.Rows[0].Field<String>("InvoiceNo");
                invoiceDateLabel.Text = invoiceInfo.Rows[0].Field<DateTime>("InvoiceDate").ToString("dd-MM-yy");

                tpTotalLabel.Text = invoiceInfo.Rows[0].Field<Decimal>("TpTotal").ToString(CultureInfo.InvariantCulture);
                tpDiscountLabel.Text = invoiceInfo.Rows[0].Field<Decimal>("TpDiscount").ToString(CultureInfo.InvariantCulture);
                tpVatLabel.Text = invoiceInfo.Rows[0].Field<Decimal>("TpVat").ToString(CultureInfo.InvariantCulture);
                tpGrandTotalLabel.Text = invoiceInfo.Rows[0].Field<Decimal>("TpGrandTotal").ToString(CultureInfo.InvariantCulture);


                proformaGridView.DataSource = invoiceInfo;
                proformaGridView.DataBind();

                DeliveryInvoiceOperation(orderNoTextBox.Text.Trim());
                
            }
            
        }

        else
        {
            proformaMessageLabel.Text = "No Invoice Information found!!!";
            proformaMessageLabel.CssClass = " alert alert-warning";
          ProformaInvoiceOperationClear();
        }
    }

    private void ProformaInvoiceOperationClear()
    {
        invoiceNumberLabel.Text = "";
        invoiceDateLabel.Text = "";
        tpTotalLabel.Text = "";
        tpDiscountLabel.Text = "";
        tpVatLabel.Text = "";
        tpGrandTotalLabel.Text = "";

        proformaGridView.DataSource = null;
        proformaGridView.DataBind();
    }

    private void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private void Clear()
    {
        orderNoTextBox.Text = "";
        
        //Order Info
        salesCenterCodeTextBox.Text = "";
        salesCenterNameTextBox.Text = "";
        mioCodeTextBox.Text = "";
        mioNameTextBox.Text = "";
        customerCodeTextBox.Text = "";
        CustomerNameTextBox.Text = "";
        grossValueTextBox.Text = "";
        submissionDateTextBox.Text = "";

        loadGridView.DataSource = null;
        loadGridView.DataBind();

        //Delivery Info

        deliveryInvoiceNumberLabel.Text = "";
        deliveryTPTotalLabel.Text = "";
        deliveryTPDiscountLabel.Text = "";
        deliveryTPVATLabel.Text = "";
        deliveryTPGrandTotalLabel.Text = "";
        deliveryStatusLabel.Text = "";

        deliveryGridView.DataSource = null;
        deliveryGridView.DataBind();

        //Invoice Info

        invoiceNumberLabel.Text = "";
        invoiceDateLabel.Text = "";
        tpTotalLabel.Text = "";
        tpDiscountLabel.Text = "";
        tpVatLabel.Text = "";
        tpGrandTotalLabel.Text = "";

        proformaGridView.DataSource = null;
        proformaGridView.DataBind();

        //Payment Status

        paymentAmountLabel.Text = "";
        paymentStatusLabel.Text = "";
    }
}