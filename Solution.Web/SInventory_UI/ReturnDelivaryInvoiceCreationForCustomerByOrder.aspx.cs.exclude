using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;
using System.Drawing;

public partial class SInventory_UI_DelivaryInvoiceCreationForCustomerByOrderAuto : System.Web.UI.Page
{
    private RequisitionBLL aRequisitionBll = new RequisitionBLL();
    private ReturnInvoiceBLL aInvoiceBll = new ReturnInvoiceBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["InvoiceId"] != null)
            {
                LoadInvoice(Session["InvoiceId"].ToString());
                Session["InvoiceId"] = null;
            }
            payTypeDDL.SelectedIndex = 1;
            aInvoiceBll.PaymentTypeLoadBLL(payTypeDDL);

            Todate();
            //InitialGrid();
        }
    }

    public void Todate()
    {
        invDateTextBox.Text = Convert.ToDateTime(DateTime.Today.ToShortDateString()).ToString("dd-MMM-yyyy");
    }
    private bool Validation()
    {
        if (orderNoTextBox.Text == "")
        {
            showMessageBox("Please Input Order Number!!");
            return false;
        }
        if (orderDateTextBox.Text == "")
        {
            showMessageBox("Please Input Order Date!!");
            return false;
        }

        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text.Trim() == "" ||
                ((TextBox)gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text.Trim() == "" || ((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text.Trim() == "")
            {
                showMessageBox("Please Input Valid Data!!!");
                return false;
            }
        }
        //for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        //{
        //    if (((Label)gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text == "Reject" ||
        //        ((Label)gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text == "Parial")
        //    {
        //        if (
        //            ((DropDownList)gridLineItemGridView.Rows[i].Cells[17].FindControl("reasonReturnDropDownList"))
        //                .SelectedIndex == 0)
        //        {
        //            showMessageBox("Please Select Reason !!");
        //            return false;
        //        }
        //    }
        //}
        return true;
    }

    private void GetCustInfo(string custCode)
    {
        if (!string.IsNullOrEmpty(custCode))
        {
            custCodeTextBox.Text = custCode;
            DataTable aDataTable = new DataTable();
            aDataTable = aInvoiceBll.CustomerMaster(custCode);
            if (aDataTable.Rows.Count > 0)
            {
                hdComUnitId.Value = aDataTable.Rows[0]["ComUnitId"].ToString();
                hdCustomerMasterId.Value = aDataTable.Rows[0]["CustomerMasterId"].ToString();
                custNameTextBox.Text = aDataTable.Rows[0]["CustomerName"].ToString();
                custAddressTextBox.Text = aDataTable.Rows[0]["Address"].ToString();
                districtNameTextBox.Text = aDataTable.Rows[0]["DistrictName"].ToString();
                areaNameTextBox.Text = aDataTable.Rows[0]["AreaName"].ToString();
                comUnitNameTextBox.Text = aDataTable.Rows[0]["ComUnitCode"].ToString() + ":" +
                                          aDataTable.Rows[0]["ComUnitName"].ToString();
                miaCodeTextBox.Text = aDataTable.Rows[0]["MiaCode"].ToString();
                marketNameTextBox.Text = aDataTable.Rows[0]["MarketName"].ToString();
                miaNameTextBox.Text = aDataTable.Rows[0]["MiaName"].ToString();
                custCategoryTextBox.Text = aDataTable.Rows[0]["CategoryName"].ToString();
                hdMiaId.Value = aDataTable.Rows[0]["MiaId"].ToString();
            }
            else
            {
            }
        }
    }

    public void LoadInvoice(string invoiceId)
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        DataTable dtinvoice = aOrderInfoBll.LoadInvoiceReturn(invoiceId);
        if (dtinvoice.Rows.Count > 0)
        {
            GetCustInfo(dtinvoice.Rows[0]["CustomerCode"].ToString());
            orderNoTextBox.Text = dtinvoice.Rows[0]["OrderNo"].ToString();
            deliverypersonNameTextBox.Text = dtinvoice.Rows[0]["DeliveryPersonName"].ToString();
            deliverypersonMobileTextBox.Text = dtinvoice.Rows[0]["DeliveryPersonPhNo"].ToString();
            remarksTextBox.Text = dtinvoice.Rows[0]["Remarks"].ToString();
            invoiceNoHiddenField.Value = dtinvoice.Rows[0]["InvoiceNo"].ToString();
            //orderIdHiddenField.Value = dtinvoice.Rows[0]["OrderId"].ToString();
            orderDateTextBox.Text = Convert.ToDateTime(dtinvoice.Rows[0]["OrderDate"].ToString())
                .ToString("dd-MMM-yyyy");
            invoiceHiddenField.Value = invoiceId;
            gridLineItemGridView.DataSource = dtinvoice;
            gridLineItemGridView.DataBind();
           // DqtyCalculation();
            //TotalValueCalculation();
        }
        //for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        //{
        //    aInvoiceBll.ReturnReason(
        //        ((DropDownList) gridLineItemGridView.Rows[i].Cells[17].FindControl("reasonReturnDropDownList")));
        //}
    }
    public void LoadSubInvoice(string invoiceId)
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        DataTable dtinvoice = aOrderInfoBll.LoadSubInvoiceReturn(invoiceId);
        if (dtinvoice.Rows.Count > 0)
        {
            GetCustInfo(dtinvoice.Rows[0]["CustomerCode"].ToString());
            orderNoTextBox.Text = dtinvoice.Rows[0]["OrderNo"].ToString();
            deliverypersonNameTextBox.Text = dtinvoice.Rows[0]["DeliveryPersonName"].ToString();
            deliverypersonMobileTextBox.Text = dtinvoice.Rows[0]["DeliveryPersonPhNo"].ToString();
            remarksTextBox.Text = dtinvoice.Rows[0]["Remarks"].ToString();
            invoiceNoHiddenField.Value = dtinvoice.Rows[0]["InvoiceNo"].ToString();
            //orderIdHiddenField.Value = dtinvoice.Rows[0]["OrderId"].ToString();
            orderDateTextBox.Text = Convert.ToDateTime(dtinvoice.Rows[0]["OrderDate"].ToString())
                .ToString("dd-MMM-yyyy");
            invoiceHiddenField.Value = invoiceId;
            gridLineItemGridView.DataSource = dtinvoice;
            gridLineItemGridView.DataBind();
           // DqtyCalculation();
            //TotalValueCalculation();
        }
        //for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        //{
        //    aInvoiceBll.ReturnReason(
        //        ((DropDownList) gridLineItemGridView.Rows[i].Cells[17].FindControl("reasonReturnDropDownList")));
        //}
    }
   
    
  
    public void LoadAllDataByOrder(string orderId)
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        DataTable aTable = new DataTable();
        aTable = aOrderInfoBll.LoadOrderWithDetail(orderId);
        orderNoTextBox.Text = aTable.Rows[0]["OrderCode"].ToString();
        orderIdHiddenField.Value = aTable.Rows[0]["OrderId"].ToString();
        orderDateTextBox.Text = Convert.ToDateTime(aTable.Rows[0]["SubmissionDate"].ToString()).ToString("dd-MMM-yyyy");
        GetCustInfo(aTable.Rows[0]["CustomerCode"].ToString());
        for (int i = 0; i < aTable.Rows.Count; i++)
        {
            AddFunc();
            ((HiddenField) gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value =
                aTable.Rows[i]["OrderDetailId"].ToString();
            GetProduct(i, aTable.Rows[i]["ProductCode"].ToString());
            GetQty(Convert.ToDecimal(aTable.Rows[i]["Quantity"].ToString()), i);

        }
        decimal percentage = 0;

        DataTable dtOffer = new DataTable();
        dtOffer = aOrderInfoBll.LoadOffer(invoiceNoHiddenField.Value);
        // FixedCustomer and trade Policy
        if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Esomium20")
        {
          //  percentage = Convert.ToDecimal(0);
        }
        else
        {
            DataTable dtFixedCustomer = aOrderInfoBll.GetFixedCustomerfromInvoiceTable(invoiceHiddenField.Value);
            if (Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"]) == true)
            {
                DataTable dttradepolicy = aOrderInfoBll.GetTradeTerm(tpTptalTextBox.Text);
                if (dttradepolicy.Rows.Count > 0)
                {
                    percentage = Convert.ToDecimal(2);
                }
            }
            else
            {
                if (Convert.ToBoolean(dtOffer.Rows[0]["OldTradePolicy"]) == true)
                {
                    if (dtOffer.Rows[0]["ProductOffer"].ToString() != "True1")
                    {
                        if (dtOffer.Rows[0]["ProductOffer"].ToString() != "FlexidolParagesicTrue")
                        {
                            DataTable dttradepolicy = aOrderInfoBll.GetTradeTermOld(tpTptalTextBox.Text);
                            if (dttradepolicy.Rows.Count > 0)
                            {
                                percentage = Convert.ToDecimal(dttradepolicy.Rows[0]["DiscountPerc"].ToString());
                            }
                        }
                    }
                }
                else
                {
                    DataTable dttradepolicy = aOrderInfoBll.GetTradeTerm(tpTptalTextBox.Text);
                    if (dttradepolicy.Rows.Count > 0)
                    {
                        percentage = Convert.ToDecimal(dttradepolicy.Rows[0]["DiscountPerc"].ToString());
                    }
                }

            }
        }
                    
        decimal totaldiscount = 0;
        totaldiscount = (percentage*Convert.ToDecimal(tpTptalTextBox.Text))/100;
        disTotalTextBox.Text = totaldiscount.ToString();
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            DataTable dtproductvat =
                aOrderInfoBll.ProductVat(
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text);
            DataTable dtdiscount =
                aOrderInfoBll.ProductDiscount(
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text,
                    hdCustomerMasterId.Value, invTextBox.Text);
            decimal percamount = 0;
            if (dtdiscount.Rows.Count > 0)
            {
                percamount = Convert.ToDecimal(dtdiscount.Rows[0]["DiscountPercentage"].ToString());
            }
            decimal totalamount = 0;
            totalamount = Convert.ToDecimal(tpTptalTextBox.Text);
            decimal productamount = 0;
            productamount =
                Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
            decimal productperc = 0;
            productperc = (productamount*100)/totalamount;
            decimal mainper = 0;
            mainper = (percentage*productperc)/100;
            ((TextBox) gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text = percentage.ToString();
            ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                (Convert.ToDecimal(
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*
                 (percentage/100)).ToString("F");
            decimal vat = 0;
            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
            ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                (Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text)*
                 (percamount/100)).ToString();

            decimal withdiscount = 0;
            withdiscount =
                (Convert.ToDecimal(
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                 Convert.ToDecimal(
                     (((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                 Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
            decimal vatamount = 0;
            //vat paisa change 2 commentout//
           // vatamount = (withdiscount*vat)/100;
            TextBox tpVatTextBox = (TextBox) gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
          //  tpVatTextBox.Text = vatamount.ToString("F");
            //vat paisa change//
            TextBox npTextBox = (TextBox) gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
            npTextBox.Text = ((Convert.ToDecimal(
                ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                               Convert.ToDecimal(
                                   ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text
                                       .Trim()) -
                               Convert.ToDecimal(
                                   ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text)) +
                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();

            TotalValueCalculation();
        }
    }

    protected void custCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        string custCode = custCodeTextBox.Text.Trim();
        GetCustInfo(custCode);
    }

    private void InitialGrid()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("OrderDetailsId");
        aDataTable.Columns.Add("DCStoreId");
        aDataTable.Columns.Add("InvoiceDetailId");

        aDataTable.Columns.Add("StockQty");
        aDataTable.Columns.Add("UnitPrice");
        aDataTable.Columns.Add("UnitVAT");

        aDataTable.Columns.Add("Quantity");

        aDataTable.Columns.Add("TotalPrice");
        aDataTable.Columns.Add("VAT");

        aDataTable.Columns.Add("DiscountPercentage");
        aDataTable.Columns.Add("DiscountAmount");

        aDataTable.Columns.Add("NetPrice");
        aDataTable.Columns.Add("SpecialAmount");
        aDataTable.Columns.Add("BonusQty");
        aDataTable.Columns.Add("TotalQty");
        DataRow dataRow;

        dataRow = aDataTable.NewRow();

        dataRow["SL"] = "1";
        dataRow["ProductCode"] = "";
        dataRow["DCStoreId"] = "";
        dataRow["InvoiceDetailId"] = "";
        dataRow["ProductName"] = "";
        dataRow["OrderDetailsId"] = "";
        dataRow["StockQty"] = "";
        dataRow["UnitPrice"] = "";
        dataRow["UnitVAT"] = "";
        dataRow["Quantity"] = "";
        dataRow["TotalPrice"] = "";
        dataRow["VAT"] = "";
        dataRow["DiscountPercentage"] = "";
        dataRow["SpecialAmount"] = "";
        dataRow["DiscountAmount"] = "";
        dataRow["NetPrice"] = "";
        dataRow["BonusQty"] = "";
        dataRow["TotalQty"] = "";
        aDataTable.Rows.Add(dataRow);

        gridLineItemGridView.DataSource = null;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.DataSource = aDataTable;
        gridLineItemGridView.DataBind();

        gridLineItemGridView.Columns[4].Visible = false;
        gridLineItemGridView.Columns[5].Visible = false;

    }

    public void AddFunc()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");

        aDataTable.Columns.Add("StockQty");
        aDataTable.Columns.Add("UnitPrice");
        aDataTable.Columns.Add("UnitVAT");

        aDataTable.Columns.Add("Quantity");

        aDataTable.Columns.Add("TotalPrice");
        aDataTable.Columns.Add("VAT");

        aDataTable.Columns.Add("DiscountPercentage");
        aDataTable.Columns.Add("DiscountAmount");

        aDataTable.Columns.Add("NetPrice");

        aDataTable.Columns.Add("BonusQty");
        aDataTable.Columns.Add("TotalQty");
        aDataTable.Columns.Add("OrderDetailsId");
        DataRow dataRow;

        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                dataRow = aDataTable.NewRow();

                dataRow["SL"] = Convert.ToString(i + 1);
                dataRow["ProductCode"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text.Trim();
                dataRow["OrderDetailsId"] =
                    ((HiddenField) gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value
                        .Trim();
                dataRow["ProductName"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[2].FindControl("nameTextBox")).Text.Trim();
                dataRow["StockQty"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text.Trim();
                dataRow["UnitPrice"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox")).Text.Trim();
                dataRow["UnitVAT"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[5].FindControl("upVatTextBox")).Text.Trim();
                ;
                dataRow["Quantity"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[6].FindControl("qtyTextBox")).Text.Trim();
                dataRow["TotalPrice"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim();
                dataRow["VAT"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text.Trim();
                dataRow["DiscountPercentage"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text.Trim();
                dataRow["DiscountAmount"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text.Trim();
                dataRow["NetPrice"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text.Trim();
                dataRow["BonusQty"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim();
                dataRow["TotalQty"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text.Trim();
                aDataTable.Rows.Add(dataRow);
            }
        }

        int sl = aDataTable.Rows.Count;
        dataRow = aDataTable.NewRow();

        dataRow["SL"] = Convert.ToString(sl + 1);
        dataRow["ProductCode"] = "";
        dataRow["OrderDetailsId"] = "";
        dataRow["ProductName"] = "";
        dataRow["StockQty"] = "";
        dataRow["UnitPrice"] = "";
        dataRow["UnitVAT"] = "";
        dataRow["Quantity"] = "";
        dataRow["TotalPrice"] = "";
        dataRow["VAT"] = "";
        dataRow["DiscountPercentage"] = "";
        dataRow["DiscountAmount"] = "";
        dataRow["NetPrice"] = "";
        dataRow["BonusQty"] = "";
        dataRow["TotalQty"] = "";
        aDataTable.Rows.Add(dataRow);

        gridLineItemGridView.DataSource = null;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.DataSource = aDataTable;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.Columns[4].Visible = false;
        gridLineItemGridView.Columns[5].Visible = false;
    }

    protected void addImageButton_Click(object sender, ImageClickEventArgs e)
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("StockQty");
        aDataTable.Columns.Add("UnitPrice");
        aDataTable.Columns.Add("UnitVAT");
        aDataTable.Columns.Add("Quantity");
        aDataTable.Columns.Add("TotalPrice");
        aDataTable.Columns.Add("VAT");
        aDataTable.Columns.Add("DiscountPercentage");
        aDataTable.Columns.Add("DiscountAmount");
        aDataTable.Columns.Add("NetPrice");
        aDataTable.Columns.Add("BonusQty");
        aDataTable.Columns.Add("TotalQty");
        DataRow dataRow;

        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                dataRow = aDataTable.NewRow();

                dataRow["SL"] = Convert.ToString(i + 1);
                dataRow["ProductCode"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text.Trim();
                dataRow["ProductName"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[2].FindControl("nameTextBox")).Text.Trim();
                dataRow["StockQty"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text.Trim();
                dataRow["UnitPrice"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox")).Text.Trim();
                dataRow["UnitVAT"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[5].FindControl("upVatTextBox")).Text.Trim();
                ;
                dataRow["Quantity"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[6].FindControl("qtyTextBox")).Text.Trim();
                dataRow["TotalPrice"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim();
                dataRow["VAT"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text.Trim();
                dataRow["DiscountPercentage"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text.Trim();
                dataRow["DiscountAmount"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text.Trim();
                dataRow["NetPrice"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text.Trim();
                dataRow["BonusQty"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim();
                dataRow["TotalQty"] =
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text.Trim();
                aDataTable.Rows.Add(dataRow);
            }
        }

        int sl = aDataTable.Rows.Count;
        dataRow = aDataTable.NewRow();

        dataRow["SL"] = Convert.ToString(sl + 1);
        dataRow["ProductCode"] = "";
        dataRow["ProductName"] = "";
        dataRow["StockQty"] = "";
        dataRow["UnitPrice"] = "";
        dataRow["UnitVAT"] = "";
        dataRow["Quantity"] = "";
        dataRow["TotalPrice"] = "";
        dataRow["VAT"] = "";
        dataRow["DiscountPercentage"] = "";
        dataRow["DiscountAmount"] = "";
        dataRow["NetPrice"] = "";
        dataRow["BonusQty"] = "";
        dataRow["TotalQty"] = "";
        aDataTable.Rows.Add(dataRow);

        gridLineItemGridView.DataSource = null;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.DataSource = aDataTable;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.Columns[4].Visible = false;
        gridLineItemGridView.Columns[5].Visible = false;
    }

    protected void removeImageButton_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton productCodeTextBox = (ImageButton) sender;
        GridViewRow currentRow = (GridViewRow) productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");

        aDataTable.Columns.Add("StockQty");
        aDataTable.Columns.Add("UnitPrice");
        aDataTable.Columns.Add("UnitVAT");

        aDataTable.Columns.Add("Quantity");

        aDataTable.Columns.Add("TotalPrice");
        aDataTable.Columns.Add("VAT");

        aDataTable.Columns.Add("DiscountPercentage");
        aDataTable.Columns.Add("DiscountAmount");

        aDataTable.Columns.Add("NetPrice");

        aDataTable.Columns.Add("BonusQty");
        aDataTable.Columns.Add("TotalQty");
        DataRow dataRow;

        if (gridLineItemGridView.Rows.Count > 0)
        {
            int sl1 = 1;
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                if (i != rowindex)
                {
                    dataRow = aDataTable.NewRow();

                    dataRow["SL"] = Convert.ToString(sl1);
                    dataRow["ProductCode"] =
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text.Trim();
                    dataRow["ProductName"] =
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[2].FindControl("nameTextBox")).Text.Trim();
                    dataRow["StockQty"] =
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text.Trim();
                    dataRow["UnitPrice"] =
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox")).Text.Trim();
                    dataRow["UnitVAT"] =
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[5].FindControl("upVatTextBox")).Text.Trim();
                    ;
                    dataRow["Quantity"] =
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[6].FindControl("qtyTextBox")).Text.Trim();
                    dataRow["TotalPrice"] =
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim();
                    dataRow["VAT"] =
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text.Trim();
                    dataRow["DiscountPercentage"] =
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text.Trim();
                    dataRow["DiscountAmount"] =
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text.Trim();
                    dataRow["NetPrice"] =
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text.Trim();
                    dataRow["BonusQty"] =
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim();
                    dataRow["TotalQty"] =
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text.Trim();
                    aDataTable.Rows.Add(dataRow);
                    sl1 += 1;
                }
            }
        }

        gridLineItemGridView.DataSource = null;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.DataSource = aDataTable;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.Columns[4].Visible = false;
        gridLineItemGridView.Columns[5].Visible = false;
    }

    protected void codeTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox TextBox = (TextBox) sender;
        GridViewRow currentRow = (GridViewRow) TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        TextBox productCodeTextBox = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox");

        string productCode = productCodeTextBox.Text.Trim();
        GetProduct(rowindex, productCode);
    }

    private void GetProduct(int rowindex, string productCode)
    {
        DataTable aDataTable = new DataTable();
        if (!string.IsNullOrEmpty(productCode))
        {
            if (ProductCodeValidation(productCode, rowindex) == true)
            {


                aDataTable = aInvoiceBll.ProductInfo(hdComUnitId.Value, productCode);
                ((TextBox) gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox")).Text = productCode;
                if (aDataTable.Rows.Count > 0)
                {
                    TextBox nameTextBox =
                        (TextBox) gridLineItemGridView.Rows[rowindex].Cells[2].FindControl("nameTextBox");
                    nameTextBox.Text = aDataTable.Rows[0]["ProductName"].ToString();
                    TextBox currentStockTextBox =
                        (TextBox) gridLineItemGridView.Rows[rowindex].Cells[3].FindControl("currentStockTextBox");
                    currentStockTextBox.Text = aDataTable.Rows[0]["StockQty"].ToString();
                    TextBox unitPriceTextBox =
                        (TextBox) gridLineItemGridView.Rows[rowindex].Cells[4].FindControl("unitPriceTextBox");
                    unitPriceTextBox.Text = aDataTable.Rows[0]["UnitPrice"].ToString();
                    TextBox upVatTextBox =
                        (TextBox) gridLineItemGridView.Rows[rowindex].Cells[5].FindControl("upVatTextBox");
                    upVatTextBox.Text = aDataTable.Rows[0]["VAT"].ToString();
                }
                else
                {
                    ((TextBox) gridLineItemGridView.Rows[rowindex].Cells[2].FindControl("nameTextBox")).Text = "";
                    ((TextBox) gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox")).Text = "";
                    showMessageBox("No Any Stock or Product of " + productCode);
                }
            }
            else
            {
                ((TextBox) gridLineItemGridView.Rows[rowindex].Cells[2].FindControl("nameTextBox")).Text = "";
                ((TextBox) gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox")).Text = "";
                showMessageBox(productCode + " No: Product Already Inserted!!!");
            }
        }
    }

    private bool ProductCodeValidation(string productCode, int rowindex)
    {
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            if (rowindex != i)
            {
                if (((TextBox) gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text.Trim() ==
                    productCode.Trim())
                {
                    return false;
                }
            }
        }
        return true;
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    public void GetQty(decimal qty, int rowindex)
    {
        TextBox qtyTextBox1 = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[6].FindControl("qtyTextBox");
        qtyTextBox1.Text = qty.ToString();

        TextBox unitPriceTextBox =
            (TextBox) gridLineItemGridView.Rows[rowindex].Cells[4].FindControl("unitPriceTextBox");
        TextBox upVatTextBox = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[5].FindControl("upVatTextBox");

        TextBox tpTextBox = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[7].FindControl("tpTextBox");
        tpTextBox.Text = Convert.ToString(Convert.ToDecimal(unitPriceTextBox.Text.Trim())*qty);

        TextBox tpVatTextBox = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[8].FindControl("tpVatTextBox");
        tpVatTextBox.Text = Convert.ToString(Convert.ToDecimal(upVatTextBox.Text.Trim())*qty);

        TextBox codeTextBox = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox");

        decimal discountPer = 0;
        discountPer = aInvoiceBll.ProductDiscount(codeTextBox.Text.Trim(), qtyTextBox1.Text.Trim());

        TextBox dpTextBox = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[9].FindControl("dpTextBox");
        dpTextBox.Text = Convert.ToString(discountPer);
        TextBox dpAmtTextBox = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[10].FindControl("dpAmtTextBox");
        if (discountPer == 0)
        {
            dpAmtTextBox.Text = "0";
        }
        else
        {
            dpAmtTextBox.Text = Convert.ToString((Convert.ToDecimal(tpTextBox.Text.Trim())/100)*discountPer);
        }

        TextBox npTextBox = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[11].FindControl("npTextBox");
        npTextBox.Text =
            Convert.ToString((Convert.ToDecimal(tpTextBox.Text.Trim()) - Convert.ToDecimal(dpAmtTextBox.Text.Trim())) +
                             Convert.ToDecimal(tpVatTextBox.Text.Trim()));

        ((TextBox) gridLineItemGridView.Rows[rowindex].Cells[13].FindControl("tQtyTextBox")).Text =
            qtyTextBox1.Text.Trim();
        ((TextBox) gridLineItemGridView.Rows[rowindex].Cells[12].FindControl("bQtyTextBox")).Text = "0";
        TotalValueCalculation();
    }

    protected void qtyTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox qtyTextBox = (TextBox) sender;
        GridViewRow currentRow = (GridViewRow) qtyTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        decimal qty = 0;
        TextBox qtyTextBox1 = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[6].FindControl("qtyTextBox");
        qty = Convert.ToDecimal(qtyTextBox1.Text.Trim());

        TextBox unitPriceTextBox =
            (TextBox) gridLineItemGridView.Rows[rowindex].Cells[4].FindControl("unitPriceTextBox");
        TextBox upVatTextBox = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[5].FindControl("upVatTextBox");

        TextBox tpTextBox = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[7].FindControl("tpTextBox");
        tpTextBox.Text = Convert.ToString(Convert.ToDecimal(unitPriceTextBox.Text.Trim())*qty);

        TextBox tpVatTextBox = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[8].FindControl("tpVatTextBox");
        tpVatTextBox.Text = Convert.ToString(Convert.ToDecimal(upVatTextBox.Text.Trim())*qty);

        TextBox codeTextBox = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox");

        decimal discountPer = 0;
        discountPer = aInvoiceBll.ProductDiscount(codeTextBox.Text.Trim(), qtyTextBox1.Text.Trim());

        TextBox dpTextBox = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[9].FindControl("dpTextBox");
        dpTextBox.Text = Convert.ToString(discountPer);
        TextBox dpAmtTextBox = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[10].FindControl("dpAmtTextBox");
        if (discountPer == 0)
        {
            dpAmtTextBox.Text = "0";
        }
        else
        {
            dpAmtTextBox.Text = Convert.ToString((Convert.ToDecimal(tpTextBox.Text.Trim())/100)*discountPer);
        }

        TextBox npTextBox = (TextBox) gridLineItemGridView.Rows[rowindex].Cells[11].FindControl("npTextBox");
        npTextBox.Text =
            Convert.ToString((Convert.ToDecimal(tpTextBox.Text.Trim()) - Convert.ToDecimal(dpAmtTextBox.Text.Trim())) +
                             Convert.ToDecimal(tpVatTextBox.Text.Trim()));

        ((TextBox) gridLineItemGridView.Rows[rowindex].Cells[13].FindControl("tQtyTextBox")).Text =
            qtyTextBox1.Text.Trim();
        ((TextBox) gridLineItemGridView.Rows[rowindex].Cells[12].FindControl("bQtyTextBox")).Text = "0";
        TotalValueCalculation();
    }

    protected void bQtyTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox bQtyTextBox1 = (TextBox) sender;
        GridViewRow currentRow = (GridViewRow) bQtyTextBox1.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        ((TextBox) gridLineItemGridView.Rows[rowindex].Cells[13].FindControl("tQtyTextBox")).Text =
            Convert.ToString(
                Convert.ToDecimal(
                    ((TextBox) gridLineItemGridView.Rows[rowindex].Cells[12].FindControl("bQtyTextBox")).Text.Trim()) +
                Convert.ToDecimal(
                    ((TextBox) gridLineItemGridView.Rows[rowindex].Cells[13].FindControl("tQtyTextBox")).Text.Trim()));

    }

    public void SaveReturnAmount(int invid)
    {
        ReturnAmountDAO amountDao = new ReturnAmountDAO()
        {
            CustomerId = Convert.ToInt32(hdCustomerMasterId.Value),
            Amount = Convert.ToDecimal(grandTotalTextBox.Text),
            ReturnInvoiceId = invid,
            InvoiceId = Convert.ToInt32(invoiceHiddenField.Value)
        };
        bool status = aInvoiceBll.SaveDataForReturnAmount(amountDao);

    }
    protected void saveButton_Click(object sender, EventArgs e)
    {
        if (Validation() == true)
        {
            try
            {

                int invId = SaveInvoiceNew();
                SaveReturnAmount(invId);
                SaveInvoiceDetailNew(invId);
                Clear();
                showMessageBox("Return Invoice Generated Successfully");
            }
            catch (Exception exception)
            {
               // throw exception;
                showMessageBox("Some Networks Error blocked Your Transaction Please Contract Administrator!!");
            }
        }
      
    }
    private bool SaveInvoiceDetail(int invoiceId)
    {

        List<InvoiceDetail> aInvoiceDetailsList = new List<InvoiceDetail>();

        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                InvoiceDetail aInvoiceDetail = new InvoiceDetail();
                aInvoiceDetail.InvoiceDetailId =
                    Convert.ToInt32(gridLineItemGridView.DataKeys[i]["InvoiceDetailId"].ToString());
                aInvoiceDetail.ProductCode =
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
                string product = ((TextBox)gridLineItemGridView.Rows[i].Cells[2].FindControl("nameTextBox")).Text;
                string[] proNameAndPackSize = product.Split(':');
                aInvoiceDetail.ProductName = proNameAndPackSize[0];
                //aInvoiceDetail.PackSize = proNameAndPackSize[1];
                aInvoiceDetail.UnitPrice =
                    Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox")).Text);
                if (
                    ((DropDownList)gridLineItemGridView.Rows[i].Cells[17].FindControl("reasonReturnDropDownList"))
                        .SelectedIndex != 0)
                {
                    aInvoiceDetail.ReturnReason =
                        ((DropDownList)gridLineItemGridView.Rows[i].Cells[17].FindControl("reasonReturnDropDownList"))
                            .SelectedItem.Text;
                }
                else
                {
                    aInvoiceDetail.ReturnReason = "";
                }
                aInvoiceDetail.UnitVatAmount =
                    Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[5].FindControl("upVatTextBox")).Text);
                aInvoiceDetail.Quantity =
                    Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[6].FindControl("qtyTextBox")).Text);
                aInvoiceDetail.DiscountPercentage =
                    Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text);
                aInvoiceDetail.DiscountAmount =
                    Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text);
                aInvoiceDetail.BonusQuantity =
                    Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim());
                string id =
                    ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value;
                aInvoiceDetail.OrderDetailsId = Convert.ToInt32(id);
                aInvoiceDetail.InvoiceId = invoiceId;
                aInvoiceDetail.Quantity =
                    Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text);
                aInvoiceDetail.OrderDetailsId = aInvoiceDetail.OrderDetailsId;
                aInvoiceDetail.BonusQuantity =
                    Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim());
                ;
                aInvoiceDetail.TotalQuantity =
                    Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text) +
                    Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim());
                aInvoiceDetail.TotalPrice =
                    Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                aInvoiceDetail.TotalPriceVatAmount =
                    Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text.Trim());
                aInvoiceDetail.DiscountPercentage = aInvoiceDetail.DiscountPercentage;
                aInvoiceDetail.DiscountAmount = aInvoiceDetail.DiscountAmount;
                aInvoiceDetail.SpecialAmount =
                    Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text.Trim());
                aInvoiceDetail.NetAmount = (aInvoiceDetail.TotalPrice - aInvoiceDetail.DiscountAmount) +
                                           aInvoiceDetail.TotalPriceVatAmount;
                aInvoiceDetail.DeliveryStatus =
                    ((Label)gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text;

                DataTable dtdcinfo = aInvoiceBll.DCInfoWithDCId(gridLineItemGridView.DataKeys[i]["DCStoreId"].ToString());
                if (dtdcinfo.Rows.Count > 0)
                {
                    DCStockNew aDcStockNew = new DCStockNew();
                    {
                        aDcStockNew.DCStoreId = Convert.ToInt32(gridLineItemGridView.DataKeys[i]["DCStoreId"].ToString());
                        aDcStockNew.InvoiceDetailId =
                            Convert.ToInt32(gridLineItemGridView.DataKeys[i]["InvoiceDetailId"].ToString());
                        aDcStockNew.StorageLocation = dtdcinfo.Rows[0]["StorageLocation"].ToString();
                        aDcStockNew.ProductCode = dtdcinfo.Rows[0]["ProductCode"].ToString();
                        aDcStockNew.ProductName = dtdcinfo.Rows[0]["ProductName"].ToString();
                        aDcStockNew.PackSize = dtdcinfo.Rows[0]["PackSize"].ToString();
                        aDcStockNew.BatchNo = dtdcinfo.Rows[0]["BatchNo"].ToString();
                        aDcStockNew.TotalQuantity =
                            Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text) -
                            Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text);
                        aDcStockNew.ExpDate = Convert.ToDateTime(dtdcinfo.Rows[0]["ExpDate"].ToString());
                        aDcStockNew.ReceiveDate = Convert.ToDateTime(dtdcinfo.Rows[0]["ReceiveDate"].ToString());
                        aDcStockNew.ChalanNo = dtdcinfo.Rows[0]["ChalanNo"].ToString();
                        aDcStockNew.ChalanDate = Convert.ToDateTime(dtdcinfo.Rows[0]["ChalanDate"].ToString());
                        aDcStockNew.ComUnitId = Convert.ToInt32(dtdcinfo.Rows[0]["ComUnitId"].ToString());
                        aDcStockNew.StockQty =
                            Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text) -
                            Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text);
                        aDcStockNew.DamageQty = 0;
                        aDcStockNew.StockRcvDate = Convert.ToDateTime(dtdcinfo.Rows[0]["StockRcvDate"].ToString());
                        if (!string.IsNullOrEmpty(dtdcinfo.Rows[0]["ReqId"].ToString()))
                        {
                            aDcStockNew.ReqId = string.IsNullOrEmpty(dtdcinfo.Rows[0]["ReqId"].ToString()) ? 0 : Convert.ToInt32(dtdcinfo.Rows[0]["ReqId"].ToString());
                        }
                        if (!string.IsNullOrEmpty(dtdcinfo.Rows[0]["ReqChildId"].ToString()))
                        {
                            aDcStockNew.ReqChildId = Convert.ToInt32(dtdcinfo.Rows[0]["ReqChildId"].ToString());
                        }
                        if (!string.IsNullOrEmpty(dtdcinfo.Rows[0]["StockInTransfarId"].ToString()))
                        {
                            aDcStockNew.StockInTransfarId = Convert.ToInt32(dtdcinfo.Rows[0]["StockInTransfarId"].ToString());
                        }
                        if (!string.IsNullOrEmpty(dtdcinfo.Rows[0]["ChalanDetailsId"].ToString()))
                        {
                            aDcStockNew.ChalanDetailsId = Convert.ToInt32(dtdcinfo.Rows[0]["ChalanDetailsId"].ToString());
                        }
                    };
                    if (((Label)gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text == "Partial" ||
                        ((Label)gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text == "Reject")
                    {
                        //aInvoiceBll.SaveDCStoreFreeze(aDcStockNew);
                    }
                }


                aInvoiceBll.UpdateInvoiceDetail(aInvoiceDetail);
                aInvoiceDetailsList.Add(aInvoiceDetail);
            }


        }

        return true;
    }
    //private bool SaveInvoiceDetail(int invoiceId)
    //{

    //    List<InvoiceDetail> aInvoiceDetailsList = new List<InvoiceDetail>();

    //    if (gridLineItemGridView.Rows.Count > 0)
    //    {
    //        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
    //        {
    //            InvoiceDetail aInvoiceDetail = new InvoiceDetail();
    //            aInvoiceDetail.InvoiceDetailId =
    //                Convert.ToInt32(gridLineItemGridView.DataKeys[i]["InvoiceDetailId"].ToString());
    //            aInvoiceDetail.ProductCode =
    //                ((TextBox) gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
    //            string product = ((TextBox) gridLineItemGridView.Rows[i].Cells[2].FindControl("nameTextBox")).Text;
    //            string[] proNameAndPackSize = product.Split(':');
    //            aInvoiceDetail.ProductName = proNameAndPackSize[0];
    //            //aInvoiceDetail.PackSize = proNameAndPackSize[1];
    //            aInvoiceDetail.UnitPrice =
    //                Convert.ToDecimal(
    //                    ((TextBox) gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox")).Text);
    //            if (
    //                ((DropDownList) gridLineItemGridView.Rows[i].Cells[17].FindControl("reasonReturnDropDownList"))
    //                    .SelectedIndex != 0)
    //            {
    //                aInvoiceDetail.ReturnReason =
    //                    ((DropDownList) gridLineItemGridView.Rows[i].Cells[17].FindControl("reasonReturnDropDownList"))
    //                        .SelectedItem.Text;
    //            }
    //            else
    //            {
    //                aInvoiceDetail.ReturnReason = "";

    //            }

    //            aInvoiceDetail.UnitVatAmount =
    //                Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[5].FindControl("upVatTextBox")).Text);
    //            aInvoiceDetail.Quantity =
    //                Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[6].FindControl("qtyTextBox")).Text);
    //            aInvoiceDetail.DiscountPercentage =
    //                Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text);
    //            aInvoiceDetail.DiscountAmount =
    //                Convert.ToDecimal(
    //                    ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text);
    //            aInvoiceDetail.BonusQuantity =
    //                Convert.ToDecimal(
    //                    ((TextBox) gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim());
    //            string id =
    //                ((HiddenField) gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value;
    //            aInvoiceDetail.OrderDetailsId = Convert.ToInt32(id);
    //            aInvoiceDetail.InvoiceId = invoiceId;
    //            aInvoiceDetail.Quantity =
    //                Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text);
    //            aInvoiceDetail.OrderDetailsId = aInvoiceDetail.OrderDetailsId;
    //            aInvoiceDetail.BonusQuantity =
    //                Convert.ToDecimal(
    //                    ((TextBox) gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim());
    //            ;
    //            aInvoiceDetail.TotalQuantity =
    //                Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text) +
    //                Convert.ToDecimal(
    //                    ((TextBox) gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim());
    //            aInvoiceDetail.TotalPrice =
    //                Convert.ToDecimal(
    //                    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
    //            aInvoiceDetail.TotalPriceVatAmount =
    //                Convert.ToDecimal(
    //                    ((TextBox) gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text.Trim());
    //            aInvoiceDetail.DiscountPercentage = aInvoiceDetail.DiscountPercentage;
    //            aInvoiceDetail.DiscountAmount = aInvoiceDetail.DiscountAmount;
    //            aInvoiceDetail.SpecialAmount =
    //                Convert.ToDecimal(
    //                    ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text.Trim());
    //            aInvoiceDetail.NetAmount = (aInvoiceDetail.TotalPrice - aInvoiceDetail.DiscountAmount) +
    //                                       aInvoiceDetail.TotalPriceVatAmount;
    //            aInvoiceDetail.DeliveryStatus =
    //                ((Label) gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text;

    //            DataTable dtdcinfo = aInvoiceBll.DCInfoWithDCId(gridLineItemGridView.DataKeys[i]["DCStoreId"].ToString());
    //            if (dtdcinfo.Rows.Count > 0)
    //            {
    //                DCStockNew aDcStockNew = new DCStockNew()
    //                {
    //                    DCStoreId = Convert.ToInt32(gridLineItemGridView.DataKeys[i]["DCStoreId"].ToString()),
    //                    InvoiceDetailId =
    //                        Convert.ToInt32(gridLineItemGridView.DataKeys[i]["InvoiceDetailId"].ToString()),
    //                    StorageLocation = dtdcinfo.Rows[0]["StorageLocation"].ToString(),
    //                    ProductCode = dtdcinfo.Rows[0]["ProductCode"].ToString(),
    //                    ProductName = dtdcinfo.Rows[0]["ProductName"].ToString(),
    //                    PackSize = dtdcinfo.Rows[0]["PackSize"].ToString(),
    //                    BatchNo = dtdcinfo.Rows[0]["BatchNo"].ToString(),
    //                    TotalQuantity =
    //                        Convert.ToDecimal(
    //                            ((TextBox) gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text) -
    //                        Convert.ToDecimal(
    //                            ((TextBox) gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text),
    //                    ExpDate = Convert.ToDateTime(dtdcinfo.Rows[0]["ExpDate"].ToString()),
    //                    ReceiveDate = Convert.ToDateTime(dtdcinfo.Rows[0]["ReceiveDate"].ToString()),
    //                    ChalanNo = dtdcinfo.Rows[0]["ChalanNo"].ToString(),
    //                    ChalanDate = Convert.ToDateTime(dtdcinfo.Rows[0]["ChalanDate"].ToString()),
    //                    ComUnitId = Convert.ToInt32(dtdcinfo.Rows[0]["ComUnitId"].ToString()),
    //                    StockQty =
    //                        Convert.ToDecimal(
    //                            ((TextBox) gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text) -
    //                        Convert.ToDecimal(
    //                            ((TextBox) gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text),
    //                    DamageQty = 0,
    //                    StockRcvDate = Convert.ToDateTime(dtdcinfo.Rows[0]["StockRcvDate"].ToString()),
    //                    ReqId = Convert.ToInt32(dtdcinfo.Rows[0]["ReqId"].ToString()),
    //                    ReqChildId = Convert.ToInt32(dtdcinfo.Rows[0]["ReqChildId"].ToString()),
    //                    StockInTransfarId = Convert.ToInt32(dtdcinfo.Rows[0]["StockInTransfarId"].ToString()),

    //                };
    //                if (((Label) gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text == "Partial" ||
    //                    ((Label) gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text == "Reject")
    //                {
    //                    aInvoiceBll.SaveDCStoreFreeze(aDcStockNew);
    //                }
    //            }


    //            aInvoiceBll.UpdateInvoiceDetail(aInvoiceDetail);
    //            aInvoiceDetailsList.Add(aInvoiceDetail);
    //        }
    //    }

    //    return true;
    //}

    private int SaveInvoiceNew()
    {

        int invoiceId = 0;
        DataTable aDataTable = new DataTable();
        aDataTable = aInvoiceBll.CustomerMaster(custCodeTextBox.Text);
        string invoiceNo = string.Empty;
        string[] forComUCode = comUnitNameTextBox.Text.Split(':');
        string ComUnitCode = forComUCode[0];
        Invoice aInvoice = new Invoice();
        // {
        aInvoice.InvoiceDate = Convert.ToDateTime(invDateTextBox.Text.Trim());
        aInvoice.OrderNo = orderNoTextBox.Text.Trim();
        aInvoice.OrderDate = Convert.ToDateTime(orderDateTextBox.Text.Trim());
        aInvoice.CustomerMasterId = Convert.ToInt32(hdCustomerMasterId.Value);
        aInvoice.ComUnitId = Convert.ToInt32(hdComUnitId.Value);
        aInvoice.MiaId = Convert.ToInt32(hdMiaId.Value);
        aInvoice.PaymentTypeId = Convert.ToInt32(1);
        aInvoice.TpTotal = Convert.ToDecimal(tpTptalTextBox.Text.Trim());
        aInvoice.TpDiscount = Convert.ToDecimal(disTotalTextBox.Text.Trim());
        aInvoice.TpVat = Convert.ToDecimal(vatTotalTextBox.Text.Trim());
        aInvoice.TpGrandTotal = Convert.ToDecimal(grandTotalTextBox.Text.Trim());
        aInvoice.UserId = Convert.ToInt32(Session["UserId"].ToString());
        aInvoice.ComUnitCode = ComUnitCode;
        aInvoice.OrderId = Convert.ToInt32(orderIdHiddenField.Value);
        aInvoice.TotalSpecialAmount = Convert.ToDecimal(pdTextBox.Text);
        aInvoice.OldTradePolicy = false;
        ////// SMC Low Stock Method////////
        aInvoice.Remarks = remarksTextBox.Text;
        aInvoice.MIACode = aDataTable.Rows[0]["MIACode"].ToString();
        aInvoice.MIAName = aDataTable.Rows[0]["MIAName"].ToString();
        aInvoice.MarketCode = aDataTable.Rows[0]["MarketCode"].ToString();
        aInvoice.MarketName = aDataTable.Rows[0]["MarketName"].ToString();
        aInvoice.AreaCode = aDataTable.Rows[0]["AreaCode"].ToString();
        aInvoice.DisCode = aDataTable.Rows[0]["DistrictCode"].ToString();
        aInvoice.FEName = aDataTable.Rows[0]["FEName"].ToString();
        aInvoice.RegionCode = aDataTable.Rows[0]["RegionCode"].ToString();
        aInvoice.DZSMName = aDataTable.Rows[0]["DZSMName"].ToString();
        aInvoice.FixedCustomer = Convert.ToBoolean(aDataTable.Rows[0]["FixedCustomer"].ToString());
        aInvoice.Type = Convert.ToString(aDataTable.Rows[0]["Type"].ToString());

        aInvoice.DpNAme = deliverypersonNameTextBox.Text.Trim();
        aInvoice.DpMob = deliverypersonMobileTextBox.Text.Trim();
        aInvoice.createBy = Session["LoginName"].ToString();
        aInvoice.Createdate = DateTime.Now;
        {
            aInvoice.ProductOffer = "False";
        }

        ////////////////Product Multiple Offer End ///////////
        if (CheckBox1.Checked)
        {
            aInvoiceBll.SaveInvoice(aInvoice, out invoiceId, out invoiceNo,"0",invoiceHiddenField.Value);    
        }
        else
        {
            aInvoiceBll.SaveInvoice(aInvoice, out invoiceId, out invoiceNo,invoiceHiddenField.Value,"0");
        }

        invTextBox.Text = invoiceNo;

      

        return invoiceId;
    }


    private int SaveInvoice()
    {

        int invoiceId = 0;

        string invoiceNo = string.Empty;
        string[] forComUCode = comUnitNameTextBox.Text.Split(':');
        string ComUnitCode = forComUCode[0];
        Invoice aInvoice = new Invoice()
        {
            InvoiceId = Convert.ToInt32(invoiceHiddenField.Value),
            InvoiceDate = Convert.ToDateTime(invDateTextBox.Text.Trim()),
            OrderNo = orderNoTextBox.Text.Trim(),
            OrderDate = Convert.ToDateTime(orderDateTextBox.Text.Trim()),
            CustomerMasterId = Convert.ToInt32(hdCustomerMasterId.Value),
            ComUnitId = Convert.ToInt32(hdComUnitId.Value),
            MiaId = Convert.ToInt32(hdMiaId.Value),
            PaymentTypeId = Convert.ToInt32(0),
            TpTotal = Convert.ToDecimal(tpTptalTextBox.Text.Trim()),
            TpDiscount = Convert.ToDecimal(disTotalTextBox.Text.Trim()),
            TpVat = Convert.ToDecimal(vatTotalTextBox.Text.Trim()),
            TpGrandTotal = Convert.ToDecimal(grandTotalTextBox.Text.Trim()),
            UserId = Convert.ToInt32(Session["UserId"].ToString()),
            ComUnitCode = ComUnitCode,
            UpdateBy = Session["LoginName"].ToString(),
            //OrderId = Convert.ToInt32(orderIdHiddenField.Value),
            TotalSpecialAmount = Convert.ToDecimal(pdTextBox.Text),
            DelivaryInvoiceNo = "DEL-" + invoiceNoHiddenField.Value,

        };
        invTextBox.Text = aInvoice.DelivaryInvoiceNo;
        //aInvoiceBll.SaveInvoice(aInvoice,out invoiceId,out invoiceNo);
        int count = 0;
        int reject = 0;
        int i = 0;
        while (i < gridLineItemGridView.Rows.Count)
        {
            if (((Label) gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text == "Full")
            {
                count++;
            }
            if (((Label) gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text == "Reject")
            {
                reject++;
            }
            i++;

        }
        if (count == i)
        {
            aInvoice.DeliveryInvoiceStatus = "Full";
        }
        else
        {
            aInvoice.DeliveryInvoiceStatus = "Partial";
        }
        if (reject == i)
        {
            aInvoice.DeliveryInvoiceStatus = "Reject";
        }

        aInvoiceBll.UpdateInvoice(aInvoice, out invoiceNo);
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        //aOrderInfoBll.UpdateInvoiceStatus(orderIdHiddenField.Value);
        //invTextBox.Text = invoiceNo;

        return invoiceId;
    }
    private bool SaveInvoiceDetailNew(int invoiceId)
    {

        List<InvoiceDetail> aInvoiceDetailsList = new List<InvoiceDetail>();

        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                if (((CheckBox) gridLineItemGridView.Rows[i].FindControl("isreturnCheckBox")).Checked)
                {


                    OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
                    DataTable dtdiscount =
                        aOrderInfoBll.ProductDiscount(
                            ((TextBox) gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text,
                            hdCustomerMasterId.Value, invDateTextBox.Text);
                    DataTable dtinvoicedetail =
                        aInvoiceBll.LoadInvoicedetail(gridLineItemGridView.DataKeys[i][0].ToString());
                    InvoiceDetail aInvoiceDetail = new InvoiceDetail();
                    aInvoiceDetail.ProductCode =
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
                    string product = ((TextBox) gridLineItemGridView.Rows[i].Cells[2].FindControl("nameTextBox")).Text;
                    string[] proNameAndPackSize = product.Split(':');
                    aInvoiceDetail.ProductName = proNameAndPackSize[0];
                    aInvoiceDetail.ExpDate = Convert.ToDateTime(dtinvoicedetail.Rows[0]["ExpDate"].ToString());
                    aInvoiceDetail.ReceiveDate = Convert.ToDateTime(dtinvoicedetail.Rows[0]["ReceiveDate"].ToString());
                    //aInvoiceDetail.PackSize = proNameAndPackSize[1];
                    aInvoiceDetail.UnitPrice =
                        Convert.ToDecimal(
                            ((TextBox) gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox")).Text);
                    aInvoiceDetail.UnitVatAmount =
                        Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[5].FindControl("upVatTextBox"))
                            .Text);
                    aInvoiceDetail.Quantity =
                        Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[6].FindControl("qtyTextBox"))
                            .Text);
                    aInvoiceDetail.DiscountPercentage =
                        Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox"))
                            .Text);
                    aInvoiceDetail.DiscountAmount =
                        Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                            .Text);
                    aInvoiceDetail.BonusQuantity = Convert.ToDecimal(
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim());
                    aInvoiceDetail.TotalPrice =
                        Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text
                            .Trim());
                    aInvoiceDetail.TotalQuantity =
                        Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].FindControl("dQtyTextBox")).Text.Trim());
                    aInvoiceDetail.SpecialAmount = 0;
                    //Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text.Trim());
                    string id =
                        ((HiddenField) gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField"))
                        .Value;
                    aInvoiceDetail.OrderDetailsId = Convert.ToInt32(id);
                    aInvoiceDetail.InvoiceId = invoiceId;
                    aInvoiceDetail.TotalPriceVatAmount =
                        Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox"))
                            .Text);
                    TextBox npTextBox = (TextBox) gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                    aInvoiceDetail.NetAmount = Convert.ToDecimal(npTextBox.Text);
                    if (dtdiscount.Rows.Count > 0)
                    {
                        aInvoiceDetail.SpecialAmountPer =
                            Convert.ToDecimal(dtdiscount.Rows[0]["DiscountPercentage"].ToString());
                    }
                    else
                    {
                        aInvoiceDetail.SpecialAmountPer = 0;
                    }

                    decimal cstock = 0;
                    decimal tqty = 0;
                    tqty = Convert.ToDecimal(
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[14].FindControl("tQtyTextBox")).Text);
                    cstock = Convert.ToDecimal(
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text);
                    DataTable dtdata = aInvoiceBll.LoadProductQty(orderIdHiddenField.Value,
                        ((TextBox) gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text);
                    tqty = Convert.ToDecimal(dtdata.Rows[0][0].ToString());
                    /////SMC Low Order Method /////
                    //if (tqty>cstock)
                    //{
                    //    aInvoiceBll.UpdateOrder("Undelivered", aInvoiceDetail.OrderDetailsId.ToString());
                    //}
                    //else
                    //{
                    //    aInvoiceDetailsList.Add(aInvoiceDetail);    
                    //}
                    ///////////////////


                    //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "OAD04" && MaxiventFOC())
                    //{
                    //    aInvoiceDetail.Campaign = "Bonus Campaign";

                    //}
                    //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB08" && CiprodylFOC())
                    //{
                    //    aInvoiceDetail.Campaign = "Bonus Campaign";

                    //}
                    ////// Resectin FOC Offer Discount Start end//
                    //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AEL02" && Nervaid75mgCapsuleFOC())
                    //{
                    //    aInvoiceDetail.Campaign = "Bonus Campaign";
                    //}
                    //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "FGD02" && CefimaxFOC())
                    //{
                    //    aInvoiceDetail.Campaign = "Bonus Campaign";
                    //}

                    //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AID01" && FOC())
                    //{
                    //    aInvoiceDetail.Campaign = "Bonus Campaign";
                    //}

                    //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "OAD02" && EzeventFOC())
                    //{
                    //    aInvoiceDetail.Campaign = "Bonus Campaign";
                    //}

                    //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AID01" && FlexidolFOC())
                    //{
                    //    aInvoiceDetail.Campaign = "Bonus Campaign";
                    //}
                    //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD04" && CefimaxFOC())
                    //{
                    //    aInvoiceDetail.Campaign = "Bonus Campaign";
                    //}
                    //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD04" && ChkProductOfferPrazomax20mgcapsule())
                    //{
                    //    aInvoiceDetail.Campaign = "Sales Campaign";
                    //}

                    if (cstock == 0)
                    {
                        //aInvoiceBll.UpdateOrder("Undelivered", aInvoiceDetail.OrderDetailsId.ToString());
                    }
                    else
                    {
                        aInvoiceDetailsList.Add(aInvoiceDetail);
                    }

                    aInvoiceDetail.DCStoreId = Convert.ToInt32(dtinvoicedetail.Rows[0]["DCStoreId"].ToString());
                    aInvoiceDetail.PackSize = dtinvoicedetail.Rows[0]["PackSize"].ToString();
                    aInvoiceDetail.BatchNo = dtinvoicedetail.Rows[0]["BatchNo"].ToString();
                    aInvoiceDetail.ReturnDetailsId = Convert.ToInt32(gridLineItemGridView.DataKeys[i][0].ToString());
                    int detailid=aInvoiceBll.SaveReturnInvoice(aInvoiceDetail);
                    if (CheckBox1.Checked)
                    {
                        SaveSubDCStoreFreeze(detailid,i);   
                    }
                    else
                    {
                        
                        SaveDCStoreFreeze(detailid,i);
                    }
                    

                }
            }

            //aInvoiceBll.savere(aInvoiceDetailsList, hdComUnitId.Value);
        }

        return true;
    }
    public void SaveSubDCStoreFreeze(int detail,int i)
    {
        DataTable dtdcinfo =
                        aInvoiceBll.SuvDCInfoWithDCId2(gridLineItemGridView.DataKeys[i]["SubDCStoreId"].ToString());

        DCStockNew aDcStockNew = new DCStockNew();
        {
            aDcStockNew.DCStoreId = Convert.ToInt32(gridLineItemGridView.DataKeys[i]["SubDCStoreId"].ToString());
            aDcStockNew.InvoiceDetailId =
                Convert.ToInt32(gridLineItemGridView.DataKeys[i]["InvoiceDetailId"].ToString());
            aDcStockNew.StorageLocation = dtdcinfo.Rows[0]["StorageLocation"].ToString();
            aDcStockNew.ProductCode = dtdcinfo.Rows[0]["ProductCode"].ToString();
            aDcStockNew.ProductName = dtdcinfo.Rows[0]["ProductName"].ToString();
            aDcStockNew.PackSize = dtdcinfo.Rows[0]["PackSize"].ToString();
            aDcStockNew.BatchNo = dtdcinfo.Rows[0]["BatchNo"].ToString();
            aDcStockNew.TotalQuantity =
                Convert.ToDecimal(
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text);
            aDcStockNew.ExpDate = Convert.ToDateTime(dtdcinfo.Rows[0]["ExpDate"].ToString());
            aDcStockNew.ReceiveDate = Convert.ToDateTime(dtdcinfo.Rows[0]["ReceiveDate"].ToString());
            aDcStockNew.ChalanNo = dtdcinfo.Rows[0]["ChalanNo"].ToString();
            aDcStockNew.ChalanDate = Convert.ToDateTime(dtdcinfo.Rows[0]["ChalanDate"].ToString());
            aDcStockNew.ComUnitId = Convert.ToInt32(dtdcinfo.Rows[0]["SubDepotId"].ToString());
            aDcStockNew.StockQty =
                Convert.ToDecimal(
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[15].FindControl("dQtyTextBox")).Text);
            aDcStockNew.DamageQty = 0;
            aDcStockNew.StockRcvDate = Convert.ToDateTime(dtdcinfo.Rows[0]["StockRcvDate"].ToString());
            aDcStockNew.ReqId = Convert.ToInt32(0);
            aDcStockNew.ReqChildId = Convert.ToInt32(0);
            aDcStockNew.StockInTransfarId = Convert.ToInt32(0);

        };
        //if (((Label) gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text =="Partial")
        {
            aInvoiceBll.SaveSubDCStoreFreeze(aDcStockNew, detail.ToString());
        }
    }

    public void SaveDCStoreFreeze(int detail,int i)
    {
        DataTable dtdcinfo =
                        aInvoiceBll.DCInfoWithDCId(gridLineItemGridView.DataKeys[i]["DCStoreId"].ToString());

        DCStockNew aDcStockNew = new DCStockNew();
        {
            aDcStockNew.DCStoreId = Convert.ToInt32(gridLineItemGridView.DataKeys[i]["DCStoreId"].ToString());
            aDcStockNew.InvoiceDetailId =
                Convert.ToInt32(gridLineItemGridView.DataKeys[i]["InvoiceDetailId"].ToString());
            aDcStockNew.StorageLocation = dtdcinfo.Rows[0]["StorageLocation"].ToString();
            aDcStockNew.ProductCode = dtdcinfo.Rows[0]["ProductCode"].ToString();
            aDcStockNew.ProductName = dtdcinfo.Rows[0]["ProductName"].ToString();
            aDcStockNew.PackSize = dtdcinfo.Rows[0]["PackSize"].ToString();
            aDcStockNew.BatchNo = dtdcinfo.Rows[0]["BatchNo"].ToString();
            aDcStockNew.TotalQuantity =
                Convert.ToDecimal(
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text);
            aDcStockNew.ExpDate = Convert.ToDateTime(dtdcinfo.Rows[0]["ExpDate"].ToString());
            aDcStockNew.ReceiveDate = Convert.ToDateTime(dtdcinfo.Rows[0]["ReceiveDate"].ToString());
            aDcStockNew.ChalanNo = dtdcinfo.Rows[0]["ChalanNo"].ToString();
            aDcStockNew.ChalanDate = Convert.ToDateTime(dtdcinfo.Rows[0]["ChalanDate"].ToString());
            aDcStockNew.ComUnitId = Convert.ToInt32(dtdcinfo.Rows[0]["ComUnitId"].ToString());
            aDcStockNew.StockQty =
                Convert.ToDecimal(
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[15].FindControl("dQtyTextBox")).Text);
            ;
            aDcStockNew.DamageQty = 0;
            aDcStockNew.StockRcvDate = Convert.ToDateTime(dtdcinfo.Rows[0]["StockRcvDate"].ToString());
            //
            aDcStockNew.ReqId = Convert.ToInt32(0);
            aDcStockNew.ReqChildId = Convert.ToInt32(0);
            aDcStockNew.StockInTransfarId = Convert.ToInt32(0);
            //
        };
        //if (((Label) gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text =="Partial")
        {
            aInvoiceBll.SaveDCStoreFreeze(aDcStockNew, detail.ToString());
        }
    }
    private void Clear()
    {
        tpTptalTextBox.Text = "";
        vatTotalTextBox.Text = "";
        disTotalTextBox.Text = "";
        grandTotalTextBox.Text = "";
        hdComUnitId.Value = "";
        hdCustomerMasterId.Value = "";
        custNameTextBox.Text = "";
        custAddressTextBox.Text = "";
        districtNameTextBox.Text = "";
        areaNameTextBox.Text = "";
        comUnitNameTextBox.Text = "";
        miaCodeTextBox.Text = "";
        marketNameTextBox.Text = "";
        miaNameTextBox.Text = "";
        custCategoryTextBox.Text = "";
        hdMiaId.Value = "";
        custCodeTextBox.Text = "";
        orderNoTextBox.Text = "";
        invoiceNoHiddenField.Value = "";
        gridLineItemGridView.DataSource = null;
        gridLineItemGridView.DataBind();
        //InitialGrid();
    }

    private void TotalValueCalculation()
    {
        decimal tpTotal = 0;
        decimal vatTotal = 0;
        decimal disTotal = 0;
        decimal gTotal = 0;
        decimal sptotatl = 0;
        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                if (((CheckBox) gridLineItemGridView.Rows[i].FindControl("isreturnCheckBox")).Checked)
                {
                    if (Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[5].FindControl("tpTextBox")).Text.Trim()) > 0)
                    {
                        decimal delqty = 0;
                        delqty = string.IsNullOrEmpty(
                            ((TextBox) gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text)
                            ? 0
                            : Convert.ToDecimal(
                                ((TextBox) gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text);
                        TextBox unitPriceTextBox =
                            (TextBox) gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox");

                        ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text =
                            (Convert.ToDecimal(unitPriceTextBox.Text) * delqty).ToString();

                        tpTotal += (((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text !=
                                    "")
                            ? Convert.ToDecimal(
                                ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text)
                            : 0;
                        vatTotal +=
                            (((TextBox) gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text != "")
                                ? Convert.ToDecimal(
                                    ((TextBox) gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text)
                                : 0;
                        disTotal +=
                            (((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text != "")
                                ? Convert.ToDecimal(
                                    ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)
                                : 0;
                        gTotal += (((TextBox) gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text !=
                                   "")
                            ? Convert.ToDecimal(
                                ((TextBox) gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text)
                            : 0;
                        sptotatl += (((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text !=
                                     "")
                            ? Convert.ToDecimal(
                                ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text)
                            : 0;
                    }
                    else
                    {


                    }
                }
            }
        }


        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {

                if (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) == 0)
                {
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text = "0";
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text = "0";
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("npTextBox")).Text = "0";
                }
            }
        }





        tpTptalTextBox.Text = tpTotal.ToString();
        vatTotalTextBox.Text = vatTotal.ToString();
        disTotalTextBox.Text = disTotal.ToString();
        grandTotalTextBox.Text = gTotal.ToString();
        pdTextBox.Text = sptotatl.ToString();
    }

    ///////////////////////////////////////////////////////////////////////////////
    protected void printButton_Click(object sender, EventArgs e)
    {
        string url = "../SInventory_RPTVIEW/ReturnInvoiceReportViewer.aspx?InvNo=" +
                     Server.UrlEncode(invTextBox.Text.Trim());
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" +
                         url +
                         "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof (string), "OPEN_WINDOW", fullURL, true);
    }

    /////////////////////////////////////////////////////////////////////////////////
    protected void custNameTextBox_TextChanged(object sender, EventArgs e)
    {

        string custName = custNameTextBox.Text.Trim();
        if (!string.IsNullOrEmpty(custName))
        {
            if (custName.Contains(':'))
            {

                string[] custInfo = custName.Split(':');
                custCodeTextBox.Text = custInfo[0];
                string custCode = custCodeTextBox.Text.Trim();
                GetCustInfo(custCode);
            }
        }
    }

    protected void nameTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox TextBox = (TextBox) sender;
        GridViewRow currentRow = (GridViewRow) TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        string product = ((TextBox) gridLineItemGridView.Rows[rowindex].Cells[2].FindControl("nameTextBox")).Text;

        if (!string.IsNullOrEmpty(product))
        {
            if (product.Contains(':'))
            {
                string[] proNameAndPackSize = product.Split(':');


                TextBox productCodeTextBox =
                    (TextBox) gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox");
                productCodeTextBox.Text = proNameAndPackSize[1];
                string productCode = productCodeTextBox.Text.Trim();
                GetProduct(rowindex, productCode);
            }

        }
    }

    public void DqtyCalculation()
    {
        try
        {

        
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            int rowindex = i;


            decimal mainqty = 0;
            decimal delqty = 0;
            delqty = string.IsNullOrEmpty(((TextBox)gridLineItemGridView.Rows[rowindex].Cells[14].FindControl("dQtyTextBox")).Text) ? 0 :
                Convert.ToDecimal(
                    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[14].FindControl("dQtyTextBox")).Text);
            mainqty = string.IsNullOrEmpty(((TextBox)gridLineItemGridView.Rows[rowindex].Cells[13].FindControl("tQtyTextBox")).Text) ? 0 :
                Convert.ToDecimal(
                    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[13].FindControl("tQtyTextBox")).Text);
            //if (delqty == mainqty)
            //{
            //    //((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).Text = "Full";
            //    //((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).ForeColor =
            //    //    Color.Green;
            //    //((DropDownList)gridLineItemGridView.Rows[rowindex].Cells[17].FindControl("reasonReturnDropDownList"))
            //    //    .Enabled = false;
            //}
            //else if (delqty < mainqty && delqty != 0)
            //{
            //    ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).Text = "Partial";
            //    ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).ForeColor =
            //        Color.Yellow;
            //    ((DropDownList)gridLineItemGridView.Rows[rowindex].Cells[17].FindControl("reasonReturnDropDownList"))
            //        .Enabled = true;
            //}
            //else if (delqty > mainqty)
            //{
            //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[14].FindControl("dQtyTextBox")).Text = "0";
            //    ((DropDownList)gridLineItemGridView.Rows[rowindex].Cells[17].FindControl("reasonReturnDropDownList"))
            //        .Enabled = false;
            //    ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).Text = "Reject";
            //    ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).ForeColor = Color.Red;
            //    ((DropDownList)gridLineItemGridView.Rows[rowindex].Cells[17].FindControl("reasonReturnDropDownList"))
            //        .Enabled = true;
            //}
            //else
            //{
            //    ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).Text = "Reject";
            //    ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).ForeColor = Color.Red;
            //    ((DropDownList)gridLineItemGridView.Rows[rowindex].Cells[17].FindControl("reasonReturnDropDownList"))
            //        .Enabled = true;
            //    //////Change////
            //    //if (delqty==0)
            //    //{
            //    //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("tpVatTextBox")).Text = "0";
            //    //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("dpTextBox")).Text = "0";
            //    //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("dpAmtTextBox")).Text = "0";
            //    //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("npTextBox")).Text = "0";
            //    //}
            //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[11].FindControl("tpVatTextBox")).Text = "0";
            //}
            if (delqty <= mainqty)
            {
                TextBox unitPriceTextBox =
                    (TextBox)gridLineItemGridView.Rows[rowindex].Cells[4].FindControl("unitPriceTextBox");
                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text =
                    (Convert.ToDecimal(unitPriceTextBox.Text) * delqty).ToString();
                OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
                TotalValueCalculation();
                decimal totalprice = Convert.ToDecimal(tpTptalTextBox.Text);

                string ProductCode1 = "";
                string ProductCode2 = "";
                string ProductCode3 = "";
                decimal Qty1 = 0;
                decimal Qty2 = 0;
                decimal Qty3 = 0;
                for (int j = 0; j < gridLineItemGridView.Rows.Count; j++)
                {
                    ProductCode1 = ((TextBox)gridLineItemGridView.Rows[j].Cells[1].FindControl("codeTextBox")).Text;
                    if (ProductCode1 == "ARD02")
                    {
                        Qty1 += string.IsNullOrEmpty(((TextBox)gridLineItemGridView.Rows[j].Cells[14].FindControl("dQtyTextBox")).Text) ? 0 :
                              Convert.ToDecimal(
                               ((TextBox)gridLineItemGridView.Rows[j].Cells[14].FindControl("dQtyTextBox")).Text);

                    }

                    ProductCode2 = ((TextBox)gridLineItemGridView.Rows[j].Cells[1].FindControl("codeTextBox")).Text;
                    if (ProductCode2 == "ARD01")
                    {
                        Qty2 += string.IsNullOrEmpty(((TextBox)gridLineItemGridView.Rows[j].Cells[14].FindControl("dQtyTextBox")).Text) ? 0 :
                           Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[j].Cells[14].FindControl("dQtyTextBox")).Text);
                    }


                    ProductCode3 = ((TextBox)gridLineItemGridView.Rows[j].Cells[1].FindControl("codeTextBox")).Text;
                    if (ProductCode2 == "FGD02")
                    {
                        Qty3 += string.IsNullOrEmpty(((TextBox)gridLineItemGridView.Rows[j].Cells[14].FindControl("dQtyTextBox")).Text) ? 0 :
                             Convert.ToDecimal(
                              ((TextBox)gridLineItemGridView.Rows[j].Cells[14].FindControl("dQtyTextBox")).Text);
                    }
                }



                decimal percentage = 0;

                DataTable dtOffer = new DataTable();
                dtOffer = aOrderInfoBll.LoadOffer(invoiceNoHiddenField.Value);

                try
                {
                    if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Esomium20" || dtOffer.Rows[0]["ProductOffer"].ToString() == "FOC" ||
                        dtOffer.Rows[0]["ProductOffer"].ToString() == "MFOC" || dtOffer.Rows[0]["ProductOffer"].ToString() == "MFOCEsomium20")
                    {
                        for (int K = 0; K < gridLineItemGridView.Rows.Count; K++)
                        {
                            if (ProductCode1 == "ARD02" && Qty1 >= 8)
                            {
                                totalprice -= Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[K].FindControl("tpTextBox")).Text);
                            }
                            if (ProductCode2 == "ARD01" && Qty2 >= 2)
                            {
                                totalprice -= Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[K].FindControl("tpTextBox")).Text);
                            }
                            if (ProductCode3 == "FGD02" && Qty3 >= 4)
                            {
                                totalprice -= Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[K].FindControl("tpTextBox")).Text);
                            }
                        }

                    }
                    else
                    {
                        totalprice = Convert.ToDecimal(tpTptalTextBox.Text);
                    }
                }
                catch (Exception e)
                {
                    totalprice = Convert.ToDecimal(tpTptalTextBox.Text);
                }
                

                // FixedCustomer and trade Policy
                // int TotalRecord = gridLineItemGridView.Rows.Count;


                DataTable dtinvoice = new DataTable();
                if (CheckBox1.Checked)
                {
                     dtinvoice = aOrderInfoBll.LoadSubInvoiceReturn(invoiceHiddenField.Value);
                }
                else
                {
                     dtinvoice = aOrderInfoBll.LoadInvoice(invoiceHiddenField.Value);
                }
                DataTable dtFixedCustomer =
                    aOrderInfoBll.GetFixedCustomerfromInvoiceTable(invoiceHiddenField.Value);
                if (Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"]) == true)
                {
                    //2
                    DataTable dttradepolicy = aOrderInfoBll.GetTradeTerm(totalprice.ToString());
                    if (dttradepolicy.Rows.Count > 0)
                    {
                        percentage = Convert.ToDecimal(0);
                    }
                }
                else
                {
                    if (Convert.ToBoolean(dtOffer.Rows[0]["OldTradePolicy"]) == true)
                    {
                        DataTable dttradepolicy = aOrderInfoBll.GetTradeTermOld(tpTptalTextBox.Text);
                        if (dttradepolicy.Rows.Count > 0)
                        {
                            percentage = Convert.ToDecimal(dttradepolicy.Rows[0]["DiscountPerc"].ToString());
                        }
                    }
                    else
                    {
                        //1
                        DataTable dttradepolicy = aOrderInfoBll.GetTradeTerm(totalprice.ToString());
                        if (dttradepolicy.Rows.Count > 0)
                        {
                            percentage = Convert.ToDecimal(dttradepolicy.Rows[0]["DiscountPerc"].ToString());
                        }
                    }

                }


                DataTable dtdiscount =
                    aOrderInfoBll.ProductDiscount(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text,
                        hdCustomerMasterId.Value, invDateTextBox.Text);
                decimal percamount = 0;
                if (dtdiscount.Rows.Count > 0)
                {
                    percamount = Convert.ToDecimal(dtdiscount.Rows[0]["DiscountPercentage"].ToString());
                }

                decimal totaldiscount = 0;
                totaldiscount = (percentage * Convert.ToDecimal(tpTptalTextBox.Text)) / 100;
                disTotalTextBox.Text = totaldiscount.ToString();

                DataTable dtproductvat =
                    aOrderInfoBll.ProductVat(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text);

                decimal totalamount = 0;
                totalamount = Convert.ToDecimal(tpTptalTextBox.Text);
                decimal productamount = 0;
                productamount =
                    Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                decimal productperc = 0;
                //productperc = (productamount*100)/totalamount;
                decimal mainper = 0;
                mainper = (percentage * productperc) / 100;

                // Offer Applied
                // FixedCustomer and trade Policy


                try
                {

                
                if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Esomium20")
                {
                    //if (((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox")).Text == "ARD02" && Qty1 >= 8)
                    //{
                    //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[9].FindControl("dpTextBox")).Text = 0.ToString();
                    //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[10].FindControl("dpAmtTextBox")).Text =
                    //       0.ToString("F");

                    //}
                    //else
                    //{
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text = percentage.ToString();
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                    //        (Convert.ToDecimal(
                    //            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                    //         (percentage / 100)).ToString("F");
                    //}
                }
                if (dtOffer.Rows[0]["ProductOffer"].ToString() == "FOC")
                {

                    //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD01" && Qty2 >= 2)
                    //{
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text = 0.ToString();
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                    //       0.ToString("F");
                    //    TextBox tpVatTextBox1 = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                    //    tpVatTextBox1.Text = 0.ToString("F");
                    //    //Vat percent change 2 commentout//
                    //    TextBox npTextBox1 = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                    //    npTextBox1.Text = 0.ToString();

                    //}
                    //else
                    //{
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text = percentage.ToString();
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                    //        (Convert.ToDecimal(
                    //            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                    //         (percentage / 100)).ToString("F");
                    //}
                }
                if (dtOffer.Rows[0]["ProductOffer"].ToString() == "MFOC")
                {

                    //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "FGD02" && Qty3 >= 4)
                    //{
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text = 0.ToString();
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                    //       0.ToString("F");
                    //    TextBox tpVatTextBox1 = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                    //    tpVatTextBox1.Text = 0.ToString("F");
                    //    //Vat percent change 2 commentout//
                    //    TextBox npTextBox1 = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                    //    npTextBox1.Text = 0.ToString();

                    //}
                    //else
                    //{
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text = percentage.ToString();
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                    //        (Convert.ToDecimal(
                    //            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                    //         (percentage / 100)).ToString("F");
                    //}
                }
                if (dtOffer.Rows[0]["ProductOffer"].ToString() == "MFOCEsomium20")
                {
                    //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD02" && Qty1 >= 8)
                    //{
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text = 0.ToString();
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                    //       0.ToString("F");

                    //}
                    //else
                    //{
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text = percentage.ToString();
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                    //        (Convert.ToDecimal(
                    //            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                    //         (percentage / 100)).ToString("F");
                    //}
                }
                if (dtOffer.Rows[0]["ProductOffer"].ToString() == "MFOCEsomium20")
                {
                    //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "FGD02" && Qty3 >= 4)
                    //{
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text = 0.ToString();
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                    //       0.ToString("F");
                    //    TextBox tpVatTextBox1 = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                    //    tpVatTextBox1.Text = 0.ToString("F");
                    //    //Vat percent change 2 commentout//
                    //    TextBox npTextBox1 = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                    //    npTextBox1.Text = 0.ToString();

                    //}
                    //else
                    //{
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text = percentage.ToString();
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                    //        (Convert.ToDecimal(
                    //            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                    //         (percentage / 100)).ToString("F");
                    //}

                }
                if (dtOffer.Rows[0]["ProductOffer"].ToString() == "False")
                {
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text = percentage.ToString();
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                        (Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                         (percentage / 100)).ToString("F");
                }








                if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Moticare10mgFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "FGD02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Cefimax200mgCapsuleFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB05")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }






                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "ActifastFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AID02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }



                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "SpadylFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "FGD01")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }









                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Flexidol")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AID01")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }

                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "CiprodylFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB08")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }


                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "ActifastFOCNew")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AID02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }


                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "EzepainFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AID05")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }


                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Moticare10mgActifastTablet10mg")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AID02"
                        || ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "FGD02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }


                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Ceframax200FOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB05"
                        )
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }

                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "PrazomaxFOCNewMotiFoc")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD05"
                        || ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "FGD02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }

                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "ActifastTablet10mg")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AID02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }

                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "CefimaxFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD05" ||
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB05")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "PrazomaxFOCNew")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD05" ||
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB05")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }



                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Prazomax40CeframaxFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD05"
                        || ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB05")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }

                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Moticare10mg")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "FGD02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }




                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "PrazomaxFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD04")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }










                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Ezevent10TabletFOC")
                {
                    if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Ezevent10TabletFOC")
                    {
                        if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "OAD02")
                        {
                            Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                            if (X > 0)
                            {
                                decimal vat = 0;
                                vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                    (Convert.ToDecimal(
                                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                     (percamount / 100)).ToString();

                                decimal withdiscount = 0;
                                withdiscount =
                                    (Convert.ToDecimal(
                                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                     Convert.ToDecimal(
                                         (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                     Convert.ToDecimal(
                                         ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                                decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                                //Vat percent change 2 commentout//
                                //vatamount = (Convert.ToDecimal(
                                //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                                TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                                tpVatTextBox.Text = vatamount.ToString("F");
                                //Vat percent change 2 commentout//
                                TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                                npTextBox.Text = ((Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                                   Convert.ToDecimal(
                                                       ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                           .Text
                                                           .Trim()) -
                                                   Convert.ToDecimal(
                                                       ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                           .Text)) +
                                                  Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                            }
                            else
                            {
                                TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                                tpVatTextBox.Text = 0.ToString("F");
                                //Vat percent change 2 commentout//
                                TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                                npTextBox.Text = 0.ToString();
                            }

                        }
                        else
                        {

                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "MoticareFOC")
                {
                    if (dtOffer.Rows[0]["ProductOffer"].ToString() == "MoticareFOC")
                    {
                        if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "FGD02")
                        {
                            Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                            if (X > 0)
                            {
                                decimal vat = 0;
                                vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                    (Convert.ToDecimal(
                                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                     (percamount / 100)).ToString();

                                decimal withdiscount = 0;
                                withdiscount =
                                    (Convert.ToDecimal(
                                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                     Convert.ToDecimal(
                                         (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                     Convert.ToDecimal(
                                         ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                                decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                                //Vat percent change 2 commentout//
                                //vatamount = (Convert.ToDecimal(
                                //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                                TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                                tpVatTextBox.Text = vatamount.ToString("F");
                                //Vat percent change 2 commentout//
                                TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                                npTextBox.Text = ((Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                                   Convert.ToDecimal(
                                                       ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                           .Text
                                                           .Trim()) -
                                                   Convert.ToDecimal(
                                                       ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                           .Text)) +
                                                  Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                            }
                            else
                            {
                                TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                                tpVatTextBox.Text = 0.ToString("F");
                                //Vat percent change 2 commentout//
                                TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                                npTextBox.Text = 0.ToString();
                            }

                        }
                        else
                        {

                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "ChkProductOfferPrazomax20mgcapsule")
                {
                    if (dtOffer.Rows[0]["ProductOffer"].ToString() == "ChkProductOfferPrazomax20mgcapsule")
                    {
                        if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD04")
                        {
                            Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                            if (X > 0)
                            {
                                decimal vat = 0;
                                vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                    (Convert.ToDecimal(
                                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                     (percamount / 100)).ToString();

                                decimal withdiscount = 0;
                                withdiscount =
                                    (Convert.ToDecimal(
                                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                     Convert.ToDecimal(
                                         (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                     Convert.ToDecimal(
                                         ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                                decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                                //Vat percent change 2 commentout//
                                //vatamount = (Convert.ToDecimal(
                                //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                                TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                                tpVatTextBox.Text = vatamount.ToString("F");
                                //Vat percent change 2 commentout//
                                TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                                npTextBox.Text = ((Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                                   Convert.ToDecimal(
                                                       ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                           .Text
                                                           .Trim()) -
                                                   Convert.ToDecimal(
                                                       ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                           .Text)) +
                                                  Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                            }
                            else
                            {
                                TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                                tpVatTextBox.Text = 0.ToString("F");
                                //Vat percent change 2 commentout//
                                TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                                npTextBox.Text = 0.ToString();
                            }

                        }
                        else
                        {

                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "CeframaxFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB05")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }


                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "NervaidFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AEL02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }

                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "CefimaxFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB05")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Prazomax40")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD05")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }

                #region 1Nov2019



                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "CiprodylFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB08")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "CiprodylFOCCapsuleEsomiumFOC")
                {
                    if ((((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB08") ||
                        (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AEL02"))
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }


                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "MaxiventFOCNervaid75mgCapsuleEsomiumFOC")
                {
                    if ((((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "OAD04") ||
                        (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AEL02"))
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "MaxiventFOCCiprodylFOCNervaid75mgCapsuleFOC")
                {
                    if ((((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "OAD04") ||
                        (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AEL02") ||
                        (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB08"))
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Nervaid75mgCapsuleFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AEL02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "MaxiventFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "OAD04")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }
                #endregion


                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "PlazomaxFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD04")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }




                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "CiprodylFOC2019")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB08")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }






                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "CiprodylFOC2019")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB08")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }





















                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "ParagasicFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANA02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }











                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Esomium20CapsuleFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "PlazomaxFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD04")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Nervaid75mgCapsuleFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AEL02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Ezevent10mgTabletFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "OAD02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }


                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "PlazomaxSalesCampaign")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD04")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }

                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Ezevent10mgTabletFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "OAD02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }

                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Ezevent10Tablet")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "OAD01")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "EzeventFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "OAD01")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "EsomiumFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }

                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Nervaid75mgCapsuleFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AEL02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }
                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "MFOC")
                {
                    if (dtOffer.Rows[0]["ProductOffer"].ToString() == "MFOC")
                    {
                        if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "FGD02")
                        {
                            Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                            if (X > 0)
                            {
                                decimal vat = 0;
                                vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                    (Convert.ToDecimal(
                                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                     (percamount / 100)).ToString();

                                decimal withdiscount = 0;
                                withdiscount =
                                    (Convert.ToDecimal(
                                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                     Convert.ToDecimal(
                                         (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                     Convert.ToDecimal(
                                         ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                                decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                                //Vat percent change 2 commentout//
                                //vatamount = (Convert.ToDecimal(
                                //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                                TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                                tpVatTextBox.Text = vatamount.ToString("F");
                                //Vat percent change 2 commentout//
                                TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                                npTextBox.Text = ((Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                                   Convert.ToDecimal(
                                                       ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                           .Text
                                                           .Trim()) -
                                                   Convert.ToDecimal(
                                                       ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                           .Text)) +
                                                  Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                            }
                            else
                            {
                                TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                                tpVatTextBox.Text = 0.ToString("F");
                                //Vat percent change 2 commentout//
                                TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                                npTextBox.Text = 0.ToString();
                            }

                        }
                        else
                        {

                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                    }
                }
















                else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "Nervaid75mgCapsuleEsomiumFOC")
                {
                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AEL02"
                        || ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ARD02")
                    {
                        Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        if (X > 0)
                        {
                            decimal vat = 0;
                            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                                 (percamount / 100)).ToString();

                            decimal withdiscount = 0;
                            withdiscount =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                 Convert.ToDecimal(
                                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                                 Convert.ToDecimal(
                                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                            //Vat percent change 2 commentout//
                            //vatamount = (Convert.ToDecimal(
                            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = vatamount.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = ((Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                       .Text
                                                       .Trim()) -
                                               Convert.ToDecimal(
                                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                       .Text)) +
                                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                        }
                        else
                        {
                            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                            tpVatTextBox.Text = 0.ToString("F");
                            //Vat percent change 2 commentout//
                            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                            npTextBox.Text = 0.ToString();
                        }

                    }
                    else
                    {

                        decimal vat = 0;
                        vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                             (percamount / 100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                             Convert.ToDecimal(
                                 ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                        //Vat percent change 2 commentout//
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        tpVatTextBox.Text = vatamount.ToString("F");
                        //Vat percent change 2 commentout//
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                        npTextBox.Text = ((Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text
                                                   .Trim()) -
                                           Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                                   .Text)) +
                                          Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                    }
                }




                //else if (dtOffer.Rows[0]["ProductOffer"].ToString() == "MFOCEsomium20")
                //{
                //    if (dtOffer.Rows[0]["ProductOffer"].ToString() == "MFOCEsomium20")
                //    {
                //        if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "FGD02")
                //        {
                //            Decimal X = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                //            if (X > 0)
                //            {
                //                decimal vat = 0;
                //                vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                //                ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                //                    (Convert.ToDecimal(
                //                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                //                     (percamount / 100)).ToString();

                //                decimal withdiscount = 0;
                //                withdiscount =
                //                    (Convert.ToDecimal(
                //                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                //                     Convert.ToDecimal(
                //                         (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                //                     Convert.ToDecimal(
                //                         ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                //                decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                //                //Vat percent change 2 commentout//
                //                //vatamount = (Convert.ToDecimal(
                //                //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                //                TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                //                tpVatTextBox.Text = vatamount.ToString("F");
                //                //Vat percent change 2 commentout//
                //                TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                //                npTextBox.Text = ((Convert.ToDecimal(
                //                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                //                                   Convert.ToDecimal(
                //                                       ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                //                                           .Text
                //                                           .Trim()) -
                //                                   Convert.ToDecimal(
                //                                       ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                //                                           .Text)) +
                //                                  Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                //            }
                //            else
                //            {
                //                TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                //                tpVatTextBox.Text = 0.ToString("F");
                //                //Vat percent change 2 commentout//
                //                TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                //                npTextBox.Text = 0.ToString();
                //            }

                //        }
                //        else
                //        {

                //            decimal vat = 0;
                //            vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                //            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                //                (Convert.ToDecimal(
                //                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                //                 (percamount / 100)).ToString();

                //            decimal withdiscount = 0;
                //            withdiscount =
                //                (Convert.ToDecimal(
                //                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                //                 Convert.ToDecimal(
                //                     (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                //                 Convert.ToDecimal(
                //                     ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                //            decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                //            //Vat percent change 2 commentout//
                //            //vatamount = (Convert.ToDecimal(
                //            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                //            TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                //            tpVatTextBox.Text = vatamount.ToString("F");
                //            //Vat percent change 2 commentout//
                //            TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                //            npTextBox.Text = ((Convert.ToDecimal(
                //                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                //                               Convert.ToDecimal(
                //                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                //                                       .Text
                //                                       .Trim()) -
                //                               Convert.ToDecimal(
                //                                   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                //                                       .Text)) +
                //                              Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                //        }
                //    }
                //}
                else
                {
                    decimal vat = 0;
                    vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                        (Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                         (percamount / 100)).ToString();

                    decimal withdiscount = 0;
                    withdiscount =
                        (Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                         Convert.ToDecimal(
                             (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) -
                         Convert.ToDecimal(
                             ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                    decimal vatamount = Convert.ToDecimal(dtproductvat.Rows[0]["VATAmountPerUnit"].ToString()) * delqty;

                    //Vat percent change 2 commentout//
                    //vatamount = (Convert.ToDecimal(
                    //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                    TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                    tpVatTextBox.Text = vatamount.ToString("F");
                    //Vat percent change 2 commentout//
                    TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                    npTextBox.Text = ((Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                       Convert.ToDecimal(
                                           ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                               .Text
                                               .Trim()) -
                                       Convert.ToDecimal(
                                           ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox"))
                                               .Text)) +
                                      Convert.ToDecimal(tpVatTextBox.Text)).ToString();
                }
                }
                catch (Exception e)
                {
                    
                }

                TotalValueCalculation();
            }
            else
            {
                showMessageBox("Cannot be greater then Total Quantity");
            }
        }
        }
        catch (Exception e)
        {

        }
    }

    public bool Calculation(int i)
    {
        decimal rqty = string.IsNullOrEmpty(((TextBox) gridLineItemGridView.Rows[i].FindControl("dQtyTextBox")).Text)
            ? 0
            : Convert.ToDecimal(
                ((TextBox) gridLineItemGridView.Rows[i].FindControl("dQtyTextBox")).Text);
        decimal prqty = string.IsNullOrEmpty(((TextBox) gridLineItemGridView.Rows[i].FindControl("prQtyTextBox")).Text)
            ? 0
            : Convert.ToDecimal(
                ((TextBox) gridLineItemGridView.Rows[i].FindControl("prQtyTextBox")).Text);
        decimal dqty = string.IsNullOrEmpty(((TextBox) gridLineItemGridView.Rows[i].FindControl("rQtyTextBox")).Text)
            ? 0
            : Convert.ToDecimal(
                ((TextBox) gridLineItemGridView.Rows[i].FindControl("rQtyTextBox")).Text);

        if (rqty+prqty>dqty)
        {
            showMessageBox("Quantity cannot be greater then delivery quantity");
            //return false;
            ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("dQtyTextBox")).Text = "0";

        }
        else
        {
        }

        return true;
    }
   
    protected void Button2_Click(object sender, EventArgs e)
    {
        if (CheckBox1.Checked )
        {
            DataTable dtdata = aInvoiceBll.LoadSubInvoicebyOrder(searchOrderNoTextBox.Text);
            if (dtdata.Rows.Count > 0)
            {
                orderIdHiddenField.Value = dtdata.Rows[0]["OrderId"].ToString();
                LoadSubInvoice(dtdata.Rows[0]["InvoiceId"].ToString());
            }
            else
            {
                showMessageBox("No Invoice Found!!");
            }
        }
        else
        {
            DataTable dtdata = aInvoiceBll.LoadInvoicebyOrder(searchOrderNoTextBox.Text);
            if (dtdata.Rows.Count > 0)
            {
                orderIdHiddenField.Value = dtdata.Rows[0]["OrderId"].ToString();
                LoadInvoice(dtdata.Rows[0]["InvoiceId"].ToString());
            }
            else
            {
                showMessageBox("No Invoice Found!!");
            }
        }
        TotalValueCalculation();


        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {

            ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("dQtyTextBox")).Text = "0";
        }



    }
    protected void dQtyTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox TextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        if (Calculation(rowindex))
        {
            DqtyCalculation();
        }
    }
    protected void isreturnCheckBox_OnCheckedChanged(object sender, EventArgs e)
    {
        TotalValueCalculation();
       // dQtyTextBox_TextChanged(textBox, e);

    }
}