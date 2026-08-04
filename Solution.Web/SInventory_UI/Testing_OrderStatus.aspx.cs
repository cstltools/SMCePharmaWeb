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

public partial class SInventory_UI_Testing_OrderStatus : System.Web.UI.Page
{
    OrderStatusBll aOrderStatusBll = new OrderStatusBll();
 
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Clear();
        }
    }


    protected void searchButton_OnClick(object sender, EventArgs e)
    {
        if (orderNoTextBox.Text != "")
        {
            DataTable aTable = aOrderStatusBll.LoadOrderStatusInfoTesting(orderNoTextBox.Text.Trim());

            if (aTable.Rows.Count > 0)
            {
                salesCenterCodeTextBox.Text = aTable.Rows[0].Field<String>("SalesCentre");
                salesCenterNameTextBox.Text = aTable.Rows[0].Field<String>("SalesCentreName");
                mioCodeTextBox.Text = aTable.Rows[0].Field<String>("MIOCode");
                mioNameTextBox.Text = aTable.Rows[0].Field<String>("MIOName");
                customerCodeTextBox.Text = aTable.Rows[0].Field<String>("CustomerID");
                CustomerNameTextBox.Text = aTable.Rows[0].Field<String>("CustomerName");
                grossValueTextBox.Text = aTable.Rows[0].Field<Decimal>("GrossValue").ToString(CultureInfo.InvariantCulture);
                submissionDateTextBox.Text = aTable.Rows[0].Field<DateTime>("SubmissionDate").ToString("dd-MM-yy");

                loadGridView.DataSource = aTable;
                loadGridView.DataBind();

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

    private void DeliveryInvoiceOperation(string orderNo)
    {
        deliveryInvoiceMsgLabel.Text = "";
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
            proformaMessageLabel.Text = "No Proforma Invoice found!!!";
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