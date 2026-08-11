using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;
using System.Drawing;
using DocumentFormat.OpenXml.Bibliography;
using DocumentFormat.OpenXml.Office2010.Excel;
using Library.DAL.MasterSetup_DAL;

public partial class dadtlsSInventory_UI_DelivaryInvoiceDetailsCreation_DA : System.Web.UI.Page
{
    private dadtlsRequisitionBLL aRequisitionBll = new dadtlsRequisitionBLL();
    private dadtlsInvoiceBLL aInvoiceBll = new dadtlsInvoiceBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["InvoiceId"] != null)
            {
                LoadInvoice(Session["InvoiceId"].ToString());
                Session["InvoiceId"] = null;
            }

            if (Session["SalesConfirmationAppLogId"] != null)
            {
                hfSalesConfirmationAppLogId.Value = Session["SalesConfirmationAppLogId"].ToString();
                Session["SalesConfirmationAppLogId"] = null;
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

        if (ViewState["IsCalculatedDel"] == null || !(bool)ViewState["IsCalculatedDel"])
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Alert", "alert('Please click Calculate before saving.');", true);
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
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            if (((Label)gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text == "Reject" ||
                ((Label)gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text == "Partial" ||
                ((Label)gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text == "Parial")
            {
                if (
                    ((DropDownList)gridLineItemGridView.Rows[i].Cells[17].FindControl("reasonReturnDropDownList"))
                        .SelectedIndex == 0)
                {
                    showMessageBox("Please Select Reason !!");
                    return false;
                }
            }
        }
        return true;
    }

    private void GetCustInfo(string custCode)
    {
        if (!string.IsNullOrEmpty(custCode))
        {
            custCodeTextBox.Text = custCode;
            DataTable aDataTable = new DataTable();
            aDataTable = aInvoiceBll.CustomerMaster(orderNoTextBox.Text.Trim());
            if (aDataTable.Rows.Count > 0)
            {
                hdComUnitId.Value = aDataTable.Rows[0]["ComUnitId"].ToString();
                hdCustomerMasterId.Value = aDataTable.Rows[0]["CustomerMasterId"].ToString();
                custNameTextBox.Text = aDataTable.Rows[0]["CustomerName"].ToString();
                custAddressTextBox.Text = aDataTable.Rows[0]["Address"].ToString();
                districtNameTextBox.Text = aDataTable.Rows[0]["ASMEmpName"].ToString();
                areaNameTextBox.Text = aDataTable.Rows[0]["AreaName"].ToString();
                comUnitNameTextBox.Text = aDataTable.Rows[0]["ComUnitCode"].ToString() + ":" + aDataTable.Rows[0]["ComUnitName"].ToString();
                miaCodeTextBox.Text = aDataTable.Rows[0]["MIOEmpMastercode"].ToString();
                hdMiaId.Value = aDataTable.Rows[0]["MIOEmpInfoId"].ToString();
                marketNameTextBox.Text = aDataTable.Rows[0]["MarketName"].ToString();
                miaNameTextBox.Text = aDataTable.Rows[0]["MIOEmpName"].ToString();
                custCategoryTextBox.Text = aDataTable.Rows[0]["Type"].ToString();//Green/Blue/Pnk
                //hdMiaId.Value = aDataTable.Rows[0]["MiaId"].ToString();
                //cusTypeTextBox.Text = aDataTable.Rows[0]["CustomerType"].ToString();//FCB/Institue/Genral
            }
            else
            {
            }
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

        SetLockedDeliveryGridFields(gv);
    }

    private void SetLockedDeliveryGridFields(GridView gv)
    {
        foreach (GridViewRow row in gv.Rows)
        {
            TextBox codeTextBox = row.FindControl("codeTextBox") as TextBox;
            TextBox nameTextBox = row.FindControl("nameTextBox") as TextBox;
            TextBox dQtyTextBox = row.FindControl("dQtyTextBox") as TextBox;
            DropDownList reasonReturnDropDownList = row.FindControl("reasonReturnDropDownList") as DropDownList;

            if (codeTextBox != null)
            {
                codeTextBox.ReadOnly = true;
            }

            if (nameTextBox != null)
            {
                nameTextBox.ReadOnly = true;
            }

            if (dQtyTextBox != null)
            {
                dQtyTextBox.ReadOnly = true;
            }

            if (reasonReturnDropDownList != null)
            {
                reasonReturnDropDownList.Enabled = false;
            }
        }
    }
    protected void backLinkButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("LoadingSummary_DA.aspx");
    }
    public void LoadInvoice(string invoiceId)
    {
        dadtlsOrderInfoBLL aOrderInfoBll = new dadtlsOrderInfoBLL();
        DataTable dtinvoice = aOrderInfoBll.LoadInvoice(invoiceId);
        if (dtinvoice.Rows.Count > 0)
        {
            orderNoTextBox.Text = dtinvoice.Rows[0]["OrderNo"].ToString();
            GetCustInfo(dtinvoice.Rows[0]["CustomerCode"].ToString());
           
            deliverypersonNameTextBox.Text = dtinvoice.Rows[0]["DeliveryPersonName"].ToString();
            deliverypersonMobileTextBox.Text = dtinvoice.Rows[0]["DeliveryPersonPhNo"].ToString();
            remarksTextBox.Text = dtinvoice.Rows[0]["Remarks"].ToString();
            invoiceNoHiddenField.Value = dtinvoice.Rows[0]["InvoiceNo"].ToString();
           orderIdHiddenField.Value = dtinvoice.Rows[0]["OrderId"].ToString();
            orderDateTextBox.Text = Convert.ToDateTime(dtinvoice.Rows[0]["OrderDate"].ToString())
                .ToString("dd-MMM-yyyy");
            invoiceHiddenField.Value = invoiceId;
            gridLineItemGridView.DataSource = dtinvoice;
            gridLineItemGridView.DataBind();
            // DqtyCalculation();
            TotalValueCalculation();
        }
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            aInvoiceBll.ReturnReason(
                ((DropDownList) gridLineItemGridView.Rows[i].Cells[17].FindControl("reasonReturnDropDownList")));
        }

        ApplySalesConfirmationAppLogDetail(invoiceId);
        if (gridLineItemGridView.Rows.Count > 0)
        {
            DqtyCalculation();
            ViewState["IsCalculatedDel"] = true;
        }
    }

    private bool ApplySalesConfirmationAppLogDetail(string invoiceId)
    {
        DataTable appLogDetails = LoadSalesConfirmationAppLogDetail(invoiceId);
        if (appLogDetails.Rows.Count == 0)
        {
            return false;
        }

        Dictionary<string, DataRow> appLogRowsByDetailId = new Dictionary<string, DataRow>();
        foreach (DataRow appLogRow in appLogDetails.Rows)
        {
            string invoiceDetailId = appLogRow["InvoiceDetailId"].ToString().Trim();
            if (!string.IsNullOrEmpty(invoiceDetailId))
            {
                appLogRowsByDetailId[invoiceDetailId] = appLogRow;
            }
        }

        bool isAnyRowApplied = false;
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string invoiceDetailId = gridLineItemGridView.DataKeys[i]["InvoiceDetailId"].ToString().Trim();
            DataRow appLogRow;
            if (!appLogRowsByDetailId.TryGetValue(invoiceDetailId, out appLogRow))
            {
                continue;
            }

            TextBox dQtyTextBox = gridLineItemGridView.Rows[i].FindControl("dQtyTextBox") as TextBox;
            Label statusLabel = gridLineItemGridView.Rows[i].FindControl("statusLabel") as Label;
            DropDownList reasonReturnDropDownList = gridLineItemGridView.Rows[i].FindControl("reasonReturnDropDownList") as DropDownList;

            if (dQtyTextBox != null)
            {
                dQtyTextBox.Text = appLogRow["DeliveredQty"].ToString();
            }

            string deliveryStatus = NormalizeDeliveryStatus(appLogRow["DeliveryStatus"].ToString());
            ApplyDeliveryStatus(statusLabel, reasonReturnDropDownList, deliveryStatus);
            SelectReason(reasonReturnDropDownList, appLogRow["DeliveryReason"].ToString());
            isAnyRowApplied = true;
        }

        return isAnyRowApplied;
    }

    private DataTable LoadSalesConfirmationAppLogDetail(string invoiceId)
    {
        dadtlsOrderInfoBLL aOrderInfoBll = new dadtlsOrderInfoBLL();
        return aOrderInfoBll.LoadSalesConfirmationAppLogDetail(invoiceId);
    }

    private static string NormalizeDeliveryStatus(string deliveryStatus)
    {
        string status = (deliveryStatus ?? string.Empty).Trim();
        string normalizedStatus = new string(status.Where(char.IsLetterOrDigit).Select(char.ToLowerInvariant).ToArray());

        if (normalizedStatus.Contains("partial") || normalizedStatus.Contains("parial"))
        {
            return "Partial";
        }

        if (normalizedStatus.Contains("reject") || normalizedStatus.Contains("cancel"))
        {
            return "Reject";
        }

        if (normalizedStatus.Contains("full"))
        {
            return "Full";
        }

        return status;
    }

    private void ApplyDeliveryStatus(Label statusLabel, DropDownList reasonReturnDropDownList, string deliveryStatus)
    {
        if (statusLabel != null)
        {
            statusLabel.Text = deliveryStatus;

            if (deliveryStatus == "Full")
            {
                statusLabel.CssClass = "badge bg-success";
            }
            else if (deliveryStatus == "Partial")
            {
                statusLabel.CssClass = "badge bg-warning";
            }
            else if (deliveryStatus == "Reject")
            {
                statusLabel.CssClass = "badge bg-danger";
            }
        }

        if (reasonReturnDropDownList != null)
        {
            reasonReturnDropDownList.Enabled = deliveryStatus == "Partial" || deliveryStatus == "Reject";
        }
    }

    private void SelectReason(DropDownList reasonReturnDropDownList, string deliveryReason)
    {
        deliveryReason = (deliveryReason ?? string.Empty).Trim();
        if (reasonReturnDropDownList == null || string.IsNullOrEmpty(deliveryReason))
        {
            return;
        }

        System.Web.UI.WebControls.ListItem reasonItem = reasonReturnDropDownList.Items.FindByValue(deliveryReason)
            ?? reasonReturnDropDownList.Items.FindByText(deliveryReason);

        if (reasonItem == null)
        {
            return;
        }

        reasonReturnDropDownList.ClearSelection();
        reasonItem.Selected = true;
    }
   
    private bool ChkProductOffer()
    {
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
            int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
            if (ProductCode == "ARD01" && Qty >= 2)
            {
                return true;
            }
        }
        return false;
    }
    private bool ChkProductOfferModi()
    {
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
            int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
            if (ProductCode == "FGD02" && Qty >= 4)
            {
                return true;
            }
        }
        return false;
    }

    private bool ChkProductOfferEsomium20()
    {
        //  int TotalRecord = gridLineItemGridView.Rows.Count;&& TotalRecord == 1
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
            int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
            if (ProductCode == "ARD02" && Qty >= 8)
            {
                return true;
            }
        }
        return false;
    }
  
    public void LoadAllDataByOrder(string orderId)
    {
        dadtlsOrderInfoBLL aOrderInfoBll = new dadtlsOrderInfoBLL();
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
        string PaymentType = "";
        string SubmissionDate = "";
        int CustTypeId = 0;

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
                //DataTable dttradepolicy = aOrderInfoBll.GetTradeTerm(tpTptalTextBox.Text);
                //if (dttradepolicy.Rows.Count > 0)
                //{
                //    percentage = Convert.ToDecimal(2);
                //}
            }
            else
            {
                bool kkk = false;


                try
                {
                    kkk = Convert.ToBoolean(dtOffer.Rows[0]["OldTradePolicy"]);
                }
                catch
                {

                }
                if (kkk == true)
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
                    //DataTable dttradepolicy = aOrderInfoBll.GetTradeTerm(tpTptalTextBox.Text);
                    //if (dttradepolicy.Rows.Count > 0)
                    //{
                    //    percentage = Convert.ToDecimal(dttradepolicy.Rows[0]["DiscountPerc"].ToString());
                    //}

                    DataTable dttradepolicy = aOrderInfoBll.GetParcentFromOrderDetailsMasterID(orderIdHiddenField.Value);
                    if (dttradepolicy.Rows.Count > 0)
                    {
                        // percentage = Convert.ToDecimal(dttradepolicy.Rows[0]["DiscountPercent"].ToString());
                        PaymentType = (dttradepolicy.Rows[0]["PaymentType"].ToString());
                        CustTypeId = Convert.ToInt32(dttradepolicy.Rows[0]["CustTypeId"].ToString());
                        SubmissionDate = (dttradepolicy.Rows[0]["SubmissionDate"].ToString());
                    }
                    DataTable dttradepolicy22 = aOrderInfoBll.GetTradeTerm(tpTptalTextBox.Text, CustTypeId, PaymentType, SubmissionDate);
                    if (dttradepolicy22.Rows.Count > 0)
                    {
                        percentage = Convert.ToDecimal(dttradepolicy22.Rows[0]["DiscountPerc"].ToString());
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
            //((TextBox) gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text = percentage.ToString();
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

        if (gridLineItemGridView.Rows.Count > 0)
        {
            DqtyCalculation();
            ViewState["IsCalculatedDel"] = true;
        }
    }



    protected void lnkCalculate_Click(object sender, EventArgs e)
    {
       // CalculateQty();
        DqtyCalculation(); // call your existing function after updating

        ViewState["IsCalculatedDel"] = true;
    }

    private void CalculateQty()
    {

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
        aDataTable.Columns.Add("CampaignType");
        aDataTable.Columns.Add("CampaignName");
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
        aDataTable.Columns.Add("Campaign");
        aDataTable.Columns.Add("ISGiftProduct");
        aDataTable.Columns.Add("IsCampaignProduct");
        DataRow dataRow;

        dataRow = aDataTable.NewRow();

        dataRow["SL"] = "1";
        dataRow["ProductCode"] = "";
        dataRow["DCStoreId"] = "";
        dataRow["InvoiceDetailId"] = "";
        dataRow["ProductName"] = "";
        dataRow["OrderDetailsId"] = "";
        dataRow["CampaignType"] = "";
        dataRow["CampaignName"] = "";
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
        dataRow["Campaign"] = "";
        dataRow["ISGiftProduct"] = "";
        dataRow["IsCampaignProduct"] = "";
        aDataTable.Rows.Add(dataRow);

        gridLineItemGridView.DataSource = null;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.DataSource = aDataTable;
        gridLineItemGridView.DataBind();

        gridLineItemGridView.Columns[4].Visible = false;
        gridLineItemGridView.Columns[5].Visible = false;

    }

    private string GetGridLineItemDataKeyValue(int rowIndex, string keyName)
    {
        if (gridLineItemGridView.DataKeys == null || rowIndex >= gridLineItemGridView.DataKeys.Count)
        {
            return string.Empty;
        }

        DataKey dataKey = gridLineItemGridView.DataKeys[rowIndex];
        if (dataKey == null)
        {
            return string.Empty;
        }

        object value = dataKey[keyName];
        return value == null ? string.Empty : value.ToString().Trim();
    }

    public void AddFunc()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("OrderDetailsId");
        aDataTable.Columns.Add("CampaignType");
        aDataTable.Columns.Add("CampaignName");
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

        aDataTable.Columns.Add("BonusQty");
        aDataTable.Columns.Add("TotalQty");
        aDataTable.Columns.Add("Campaign");
        aDataTable.Columns.Add("ISGiftProduct");
        aDataTable.Columns.Add("IsCampaignProduct");
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
                    ((HiddenField) gridLineItemGridView.Rows[i].FindControl("orderdetailIdHiddenField")).Value
                        .Trim();
                dataRow["CampaignType"] =
                    ((HiddenField) gridLineItemGridView.Rows[i].FindControl("hfCampaignType")).Value.Trim();
                dataRow["CampaignName"] =
                    ((HiddenField) gridLineItemGridView.Rows[i].FindControl("hfCampaignName")).Value.Trim();
                dataRow["DCStoreId"] = GetGridLineItemDataKeyValue(i, "DCStoreId");
                dataRow["InvoiceDetailId"] = GetGridLineItemDataKeyValue(i, "InvoiceDetailId");
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
                dataRow["Campaign"] = GetGridLineItemDataKeyValue(i, "Campaign");
                dataRow["ISGiftProduct"] =
                    ((TextBox) gridLineItemGridView.Rows[i].FindControl("bQtyTextBox")).Text.Trim();
                dataRow["IsCampaignProduct"] =
                    ((TextBox) gridLineItemGridView.Rows[i].FindControl("sdTextBox")).Text.Trim();
                aDataTable.Rows.Add(dataRow);
            }
        }

        int sl = aDataTable.Rows.Count;
        dataRow = aDataTable.NewRow();

        dataRow["SL"] = Convert.ToString(sl + 1);
        dataRow["ProductCode"] = "";
        dataRow["OrderDetailsId"] = "";
        dataRow["CampaignType"] = "";
        dataRow["CampaignName"] = "";
        dataRow["DCStoreId"] = "";
        dataRow["InvoiceDetailId"] = "";
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
        dataRow["Campaign"] = "";
        dataRow["ISGiftProduct"] = "";
        dataRow["IsCampaignProduct"] = "";
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
        aDataTable.Columns.Add("OrderDetailsId");
        aDataTable.Columns.Add("CampaignType");
        aDataTable.Columns.Add("CampaignName");
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
        aDataTable.Columns.Add("BonusQty");
        aDataTable.Columns.Add("TotalQty");
        aDataTable.Columns.Add("Campaign");
        aDataTable.Columns.Add("ISGiftProduct");
        aDataTable.Columns.Add("IsCampaignProduct");
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
                    ((HiddenField) gridLineItemGridView.Rows[i].FindControl("orderdetailIdHiddenField")).Value.Trim();
                dataRow["CampaignType"] =
                    ((HiddenField) gridLineItemGridView.Rows[i].FindControl("hfCampaignType")).Value.Trim();
                dataRow["CampaignName"] =
                    ((HiddenField) gridLineItemGridView.Rows[i].FindControl("hfCampaignName")).Value.Trim();
                dataRow["DCStoreId"] = GetGridLineItemDataKeyValue(i, "DCStoreId");
                dataRow["InvoiceDetailId"] = GetGridLineItemDataKeyValue(i, "InvoiceDetailId");
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
                dataRow["Campaign"] = GetGridLineItemDataKeyValue(i, "Campaign");
                dataRow["ISGiftProduct"] =
                    ((TextBox) gridLineItemGridView.Rows[i].FindControl("bQtyTextBox")).Text.Trim();
                dataRow["IsCampaignProduct"] =
                    ((TextBox) gridLineItemGridView.Rows[i].FindControl("sdTextBox")).Text.Trim();
                aDataTable.Rows.Add(dataRow);
            }
        }

        int sl = aDataTable.Rows.Count;
        dataRow = aDataTable.NewRow();

        dataRow["SL"] = Convert.ToString(sl + 1);
        dataRow["ProductCode"] = "";
        dataRow["OrderDetailsId"] = "";
        dataRow["CampaignType"] = "";
        dataRow["CampaignName"] = "";
        dataRow["DCStoreId"] = "";
        dataRow["InvoiceDetailId"] = "";
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
        dataRow["Campaign"] = "";
        dataRow["ISGiftProduct"] = "";
        dataRow["IsCampaignProduct"] = "";
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
        aDataTable.Columns.Add("OrderDetailsId");
        aDataTable.Columns.Add("CampaignType");
        aDataTable.Columns.Add("CampaignName");
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

        aDataTable.Columns.Add("BonusQty");
        aDataTable.Columns.Add("TotalQty");
        aDataTable.Columns.Add("Campaign");
        aDataTable.Columns.Add("ISGiftProduct");
        aDataTable.Columns.Add("IsCampaignProduct");
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
                    dataRow["OrderDetailsId"] =
                        ((HiddenField) gridLineItemGridView.Rows[i].FindControl("orderdetailIdHiddenField")).Value.Trim();
                    dataRow["CampaignType"] =
                        ((HiddenField) gridLineItemGridView.Rows[i].FindControl("hfCampaignType")).Value.Trim();
                    dataRow["CampaignName"] =
                        ((HiddenField) gridLineItemGridView.Rows[i].FindControl("hfCampaignName")).Value.Trim();
                    dataRow["DCStoreId"] = GetGridLineItemDataKeyValue(i, "DCStoreId");
                    dataRow["InvoiceDetailId"] = GetGridLineItemDataKeyValue(i, "InvoiceDetailId");
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
                    dataRow["Campaign"] = GetGridLineItemDataKeyValue(i, "Campaign");
                    dataRow["ISGiftProduct"] =
                        ((TextBox) gridLineItemGridView.Rows[i].FindControl("bQtyTextBox")).Text.Trim();
                    dataRow["IsCampaignProduct"] =
                        ((TextBox) gridLineItemGridView.Rows[i].FindControl("sdTextBox")).Text.Trim();
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

    /// Acquires a session-scoped exclusive app lock so the duplicate-submit re-check and the
    /// writes that follow it run one at a time across ALL DA delivery-invoice submits, closing
    /// the same TOCTOU race handled for the other Invoice/Delivery/Payment submit flows: the
    /// pre-flight GetDelivaryInvoiceNoCheckById above can be beaten by a concurrent submit for the
    /// same invoice; this recheck cannot, because the app lock serializes it.
    private static void AcquireDaDeliveryInvoiceSubmitLock(SqlConnection connection, SqlTransaction transaction, string invoiceId)
    {
        using (SqlCommand cmd = new SqlCommand("sp_getapplock", connection, transaction))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Resource", "DaDeliveryInvoiceSubmit_Global");
            cmd.Parameters.AddWithValue("@LockMode", "Exclusive");
            cmd.Parameters.AddWithValue("@LockOwner", "Session");
            cmd.Parameters.AddWithValue("@LockTimeout", 15000);
            SqlParameter returnValue = new SqlParameter("@ReturnValue", SqlDbType.Int);
            returnValue.Direction = ParameterDirection.ReturnValue;
            cmd.Parameters.Add(returnValue);
            cmd.ExecuteNonQuery();
            int result = (int)returnValue.Value;
            if (result < 0)
            {
                throw new InvalidOperationException(
                    "Could not acquire the DA delivery invoice submit lock for InvoiceId=" + invoiceId +
                    " (sp_getapplock result=" + result + "). Another submit for this invoice may be in progress.");
            }
        }
    }

    /// Releases the session-owned lock taken by AcquireDaDeliveryInvoiceSubmitLock. Must only be
    /// called after the transaction that did the duplicate recheck has already been committed or
    /// rolled back (never before), so a concurrent submit waiting on this lock cannot start its own
    /// recheck until our commit/rollback is fully visible. No SqlTransaction is taken here on
    /// purpose: by the time this runs, the connection has no pending transaction left to attach to.
    private static void ReleaseDaDeliveryInvoiceSubmitLock(SqlConnection connection)
    {
        using (SqlCommand cmd = new SqlCommand("sp_releaseapplock", connection))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Resource", "DaDeliveryInvoiceSubmit_Global");
            cmd.Parameters.AddWithValue("@LockOwner", "Session");
            cmd.ExecuteNonQuery();
        }
    }

    protected void saveButton_Click(object sender, EventArgs e)
    {
        // Guard against double-click / duplicate async postbacks submitting the same
        // invoice twice before the first request has finished processing. Shared with
        // btnPartialReject_Click since both act on the same invoice.
        if (Session["IsDaDeliveryInvoiceSubmitting"] != null &&
            (bool)Session["IsDaDeliveryInvoiceSubmitting"] == true)
        {
            return;
        }

        Session["IsDaDeliveryInvoiceSubmitting"] = true;
        try
        {
            if (Validation() == true)
            {
                try
                {
                    dadtlsBonusCampaignNewDAL _BonusCampaignNewDAL = new dadtlsBonusCampaignNewDAL();
                    //DelivaryInvoiceNo
                    using (DataTable dt = _BonusCampaignNewDAL.GetDelivaryInvoiceNoCheckById(invoiceHiddenField.Value, "DelivaryInvoiceNo"))
                    {
                        if (dt.Rows.Count == 0)
                        {
                            string connectionString = ConfigurationManager.ConnectionStrings["SolutionConnectionStringSSIDB"].ConnectionString;

                            // Entire Submit sequence (invoice master, invoice details, DC stock
                            // deduction, DIC approval-status update) runs on a single connection/
                            // transaction so it commits or rolls back as one atomic unit: either
                            // every table is updated, or none is.
                            using (SqlConnection connection = new SqlConnection(connectionString))
                            {
                                connection.Open();
                                SqlTransaction transaction = connection.BeginTransaction(IsolationLevel.ReadCommitted);
                                bool committed = false;
                                try
                                {
                                    AcquireDaDeliveryInvoiceSubmitLock(connection, transaction, invoiceHiddenField.Value);

                                    // Re-check inside the lock+transaction: the pre-flight check above
                                    // can be beaten by a concurrent submit; this recheck cannot.
                                    DataTable existingDelivery = _BonusCampaignNewDAL.GetDelivaryInvoiceNoCheckById(
                                        invoiceHiddenField.Value, "DelivaryInvoiceNo", transaction);
                                    if (existingDelivery.Rows.Count > 0)
                                    {
                                        transaction.Rollback();
                                        // Lock is released only now, after the rollback is fully applied -
                                        // any submit waiting on this lock will see this invoice's true
                                        // (still-unprocessed) state, not a stale pre-rollback snapshot.
                                        ReleaseDaDeliveryInvoiceSubmitLock(connection);
                                        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);
                                        Clear();
                                        return;
                                    }

                                    int invId = SaveInvoice(transaction);

                                    //aInvoiceBll.UP_LoadingSummaryInvoice(invoiceHiddenField.Value,
                                    //                Session["LoginName"].ToString(), "Partial Dues");
                                    SaveInvoiceDetail(invId, transaction);

                                    if (!string.IsNullOrEmpty(hfSalesConfirmationAppLogId.Value))
                                    {
                                        aInvoiceBll.UpdateDICApprovalStatus(hfSalesConfirmationAppLogId.Value, "Approved", Session["LoginName"].ToString(), transaction);
                                    }

                                    transaction.Commit();
                                    committed = true;

                                    // Only release the lock AFTER the commit is durable. Releasing it
                                    // earlier (the previous bug) let a concurrent submit for the same
                                    // invoice acquire the lock and run its own duplicate recheck against
                                    // not-yet-committed data, so it could pass the check and re-apply the
                                    // additive StockQty=StockQty+qty stock return a second time.
                                    ReleaseDaDeliveryInvoiceSubmitLock(connection);

                                    //if(autopayment.Checked)
                                    //{
                                    //    SavePayment();
                                    //}
                                    Clear();
                                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Delivery confirmation Created Successsfully!" + "','Success');", true);
                                }
                                catch (Exception ex)
                                {
                                    if (!committed)
                                    {
                                        try { transaction.Rollback(); } catch { /* connection/transaction may already be dead; nothing left to roll back */ }
                                    }
                                    try { ReleaseDaDeliveryInvoiceSubmitLock(connection); } catch { /* connection may already be dead; closing it below releases the session-scoped lock anyway */ }
                                    System.Diagnostics.Trace.TraceError(
                                        "DA Delivery Invoice Submit failed for InvoiceId={0}: {1}", invoiceHiddenField.Value, ex);
                                    throw;
                                }
                            }
                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);
                            Clear();
                        }
                    }

                }
                catch (Exception exception)
                {
                   // throw exception;
                    showMessageBox("Some Networks Error blocked Your Transaction Please Contract Administrator!!");
                }
            }
        }
        finally
        {
            Session["IsDaDeliveryInvoiceSubmitting"] = false;
        }

    }

    protected void btnPartialReject_Click(object sender, EventArgs e)
    {
        // Guard against double-click / duplicate async postbacks — shared with saveButton_Click
        // since both act on the same invoice and must not run concurrently.
        if (Session["IsDaDeliveryInvoiceSubmitting"] != null &&
            (bool)Session["IsDaDeliveryInvoiceSubmitting"] == true)
        {
            return;
        }

        Session["IsDaDeliveryInvoiceSubmitting"] = true;
        try
        {
            if (!string.IsNullOrEmpty(invoiceHiddenField.Value))
            {
                int invoiceId;
                if (int.TryParse(invoiceHiddenField.Value, out invoiceId))
                {
                    InvoiceBLL_daaw invoiceBllDaaw = new InvoiceBLL_daaw();
                    if (invoiceBllDaaw.RejectInvoiceDASalesConfirmStatus(invoiceId))
                    {
                        if (!string.IsNullOrEmpty(hfSalesConfirmationAppLogId.Value))
                        {
                            aInvoiceBll.UpdateDICApprovalStatus(hfSalesConfirmationAppLogId.Value, "Rejected", Session["LoginName"].ToString());
                        }

                        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "alert('Invoice has been rejected successfully.');", true);
                        Clear();
                    }
                }
            }
        }
        catch (Exception exception)
        {
            showMessageBox("Error occurred while rejecting invoice!");
        }
        finally
        {
            Session["IsDaDeliveryInvoiceSubmitting"] = false;
        }
    }
    private bool SaveInvoiceDetail(int invoiceId, SqlTransaction transaction)
    {

        List<dadtlsInvoiceDetail> aInvoiceDetailsList = new List<dadtlsInvoiceDetail>();

        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                dadtlsInvoiceDetail aInvoiceDetail = new dadtlsInvoiceDetail();
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
                    Convert.ToDecimal(0);
                string id =
                    ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value;
                aInvoiceDetail.OrderDetailsId = Convert.ToInt32(id);
                aInvoiceDetail.InvoiceId = invoiceId;
                aInvoiceDetail.Quantity =
                    Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text);
                aInvoiceDetail.OrderDetailsId = aInvoiceDetail.OrderDetailsId;
                //aInvoiceDetail.BonusQuantity =
                //    Convert.ToDecimal(
                //        ((TextBox)gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim());
                ;
                aInvoiceDetail.TotalQuantity =
                    Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text);
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
                      0);
                aInvoiceDetail.NetAmount = (aInvoiceDetail.TotalPrice - aInvoiceDetail.DiscountAmount) +
                                           aInvoiceDetail.TotalPriceVatAmount;
                aInvoiceDetail.DeliveryStatus =
                    ((Label)gridLineItemGridView.Rows[i].Cells[15].FindControl("statusLabel")).Text;

                DataTable dtdcinfo = aInvoiceBll.DCInfoWithDCId(gridLineItemGridView.DataKeys[i]["DCStoreId"].ToString(), transaction);
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
                        decimal qty = Convert.ToDecimal(
                                          ((TextBox) gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox"))
                                          .Text) -
                                      Convert.ToDecimal(
                                          ((TextBox) gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox"))
                                          .Text);
                        //aInvoiceBll.SaveDCStoreFreeze(aDcStockNew);
                        aInvoiceBll.UpdateDCStock(qty, aDcStockNew.DCStoreId, transaction);
                    }
                }


                aInvoiceBll.UpdateInvoiceDetail(aInvoiceDetail, transaction);
                aInvoiceBll.PaymentUpdateInvoiceDetail(aInvoiceDetail, transaction);
                aInvoiceDetailsList.Add(aInvoiceDetail);
            }


        }

        return true;
    }
    //private bool SaveInvoiceDetail(int invoiceId)
    //{

    //    List<dadtlsInvoiceDetail> aInvoiceDetailsList = new List<dadtlsInvoiceDetail>();

    //    if (gridLineItemGridView.Rows.Count > 0)
    //    {
    //        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
    //        {
    //            dadtlsInvoiceDetail aInvoiceDetail = new dadtlsInvoiceDetail();
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

    private int SaveInvoice(SqlTransaction transaction)
    {

        int invoiceId = 0;

        string invoiceNo = string.Empty;
        string[] forComUCode = comUnitNameTextBox.Text.Split(':');
        string ComUnitCode = forComUCode[0];
        dadtlsInvoice aInvoice = new dadtlsInvoice();

        aInvoice.InvoiceId = Convert.ToInt32(invoiceHiddenField.Value);
        aInvoice.InvoiceDate = Convert.ToDateTime(invDateTextBox.Text.Trim());
        aInvoice.OrderNo = orderNoTextBox.Text.Trim();
        aInvoice.OrderDate = Convert.ToDateTime(orderDateTextBox.Text.Trim());
        aInvoice.CustomerMasterId = Convert.ToInt32(hdCustomerMasterId.Value);
      aInvoice.ComUnitId = Convert.ToInt32(hdComUnitId.Value);
        try
        {
            aInvoice.MiaId = Convert.ToInt32(hdMiaId.Value);
        }
        catch(Exception ex)
        {
            aInvoice.MiaId = 0;
        }
        aInvoice.PaymentTypeId = Convert.ToInt32(0);
        aInvoice.TpTotal = Convert.ToDecimal(tpTptalTextBox.Text.Trim());
        aInvoice.TpDiscount = Convert.ToDecimal(disTotalTextBox.Text.Trim());
        aInvoice.TpVat = Convert.ToDecimal(vatTotalTextBox.Text.Trim());
        aInvoice.TpGrandTotal = Convert.ToDecimal(grandTotalTextBox.Text.Trim());
        aInvoice.UserId = Convert.ToInt32(Session["UserId"].ToString());
        aInvoice.ComUnitCode = ComUnitCode;
        aInvoice.UpdateBy = Session["LoginName"].ToString();
        //OrderId = Convert.ToInt32(orderIdHiddenField.Value),
        aInvoice.TotalSpecialAmount = Convert.ToDecimal(pdTextBox.Text);
        aInvoice.DelivaryInvoiceNo =  invoiceNoHiddenField.Value;
        aInvoice.updatetime = DateTime.Now;
 
        invTextBox.Text = "DEL-" + aInvoice.DelivaryInvoiceNo;
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

        aInvoiceBll.UpdateInvoice(aInvoice, out invoiceNo, transaction);
        aInvoiceBll.PaymentUpdateInvoice(aInvoice, out invoiceNo, transaction);
        dadtlsOrderInfoBLL aOrderInfoBll = new dadtlsOrderInfoBLL();
        //aOrderInfoBll.UpdateInvoiceStatus(orderIdHiddenField.Value);
        //invTextBox.Text = invoiceNo;

        return invoiceId;
    }
    public void SavePayment()
    {
        dadtlsCustPaymentBLL aCustPaymentBll = new dadtlsCustPaymentBLL();
        //if (Validation())
        {
            CustomerMaster aCustomerMaster;
            dadtlsCustPayment aCustPayment = new dadtlsCustPayment();
            string custId = hdCustomerMasterId.Value;
            aCustPayment.CustomerMasterId = Convert.ToInt32(custId);
            aCustPayment.MarketId = Convert.ToInt32(0);
            aCustPayment.ComUnitId = Convert.ToInt32(hdComUnitId.Value);
            aCustPayment.PaymentDate = Convert.ToDateTime(DateTime.Today);
            aCustPayment.PaymentAmount = Convert.ToDecimal(grandTotalTextBox.Text);
            aCustPayment.PayType = "Cash";
            //aCustPayment.RefNo = "";

            aCustPayment.CreateBy = Session["LoginName"].ToString();
            aCustPayment.CreateDate = DateTime.Now;


            List<dadtlsCustPaymentDetail> aCustPaymentDetails = new List<dadtlsCustPaymentDetail>();
            //for (int i = 0; i < orderGridView.Rows.Count; i++)
            {
                decimal totalamount = 0;
                totalamount = Convert.ToDecimal(grandTotalTextBox.Text);
                aCustPaymentBll.UpdateInvoicePaymentAmount(totalamount.ToString(), "Full",
                        invoiceHiddenField.Value);
                dadtlsCustPaymentDetail aCustPaymentDetail = new dadtlsCustPaymentDetail()
                {
                    InvoiceId = Convert.ToInt32(invoiceHiddenField.Value),
                    PaymentAmount = Convert.ToDecimal(grandTotalTextBox.Text),


                };
                aCustPaymentDetails.Add(aCustPaymentDetail);
            }
            if (aCustPaymentBll.SaveCustPayment(aCustPayment, aCustPaymentDetails))
            {
                showMessageBox("Data Saved Successfully !!!!!");
                //Clear();
            }
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

        try
        {
            InitialGrid();
        }
        catch
        {

        }
    }

    private void TotalValueCalculation()
    {
        decimal tpTotal = 0;
        decimal vatTotal = 0;
        decimal disTotal = 0;
        decimal gTotal = 0;
        decimal sptotatl = 0;
        decimal campaignTP = 0;
        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                if (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) > 0)
                {

                    decimal delqty = 0;
                    delqty = string.IsNullOrEmpty(((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text) ? 0 :
                        Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox")).Text);
                    TextBox unitPriceTextBox =
                        (TextBox)gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox");

                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text =
                        (Convert.ToDecimal(unitPriceTextBox.Text) * delqty).ToString();

                    tpTotal += (((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text != "")
                        ? Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text)
                        : 0;
                   
                    disTotal += (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text != "")
                        ? Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)
                        : 0;
                    gTotal += (((TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text != "")
                        ? Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text)
                        : 0;
                    //sptotatl += (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text != "")
                    //    ? Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text)
                    //    : 0;
                    vatTotal += (((TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text != "")
                     ? Convert.ToDecimal(
                         ((TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text)
                     : 0;
                }


                if (
                    Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("dpAmtTextBox")).Text.Trim()) > 0)
                {


                    campaignTP += (((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text != "")
                      ? Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text)
                      : 0;
                  
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
        campaignTPTextBox1.Text = campaignTP.ToString();
    }

    ///////////////////////////////////////////////////////////////////////////////
    protected void printButton_Click(object sender, EventArgs e)
    {
        string url = "../SInventory_RPTVIEW/DelivaryInvoiceReturnViewer.aspx?InvNo=" +
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
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            int rowindex = i;
            HiddenField hfCampaignType = ((HiddenField)gridLineItemGridView.Rows[i].Cells[9].FindControl("hfCampaignType"));
            HiddenField hfCampaignName = ((HiddenField)gridLineItemGridView.Rows[i].Cells[9].FindControl("hfCampaignName"));


            int OrderDetailsId= Convert.ToInt32(gridLineItemGridView.DataKeys[i]["InvoiceDetailId"].ToString());

            decimal mainqty = 0;
            decimal delqty = 0;
            delqty = string.IsNullOrEmpty(((TextBox)gridLineItemGridView.Rows[rowindex].Cells[14].FindControl("dQtyTextBox")).Text) ? 0 :
                Convert.ToDecimal(
                    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[14].FindControl("dQtyTextBox")).Text);
            mainqty = string.IsNullOrEmpty(((TextBox)gridLineItemGridView.Rows[rowindex].Cells[13].FindControl("tQtyTextBox")).Text) ? 0 :
                Convert.ToDecimal(
                    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[13].FindControl("tQtyTextBox")).Text);
            if (delqty == mainqty)
            {
                ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).Text = "Full";
                ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).CssClass = "badge bg-success";
                ((DropDownList)gridLineItemGridView.Rows[rowindex].Cells[17].FindControl("reasonReturnDropDownList"))
                    .Enabled = false;
            }
            else if (delqty < mainqty && delqty != 0)
            {
                ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).Text = "Partial";
                ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).CssClass = "badge bg-warning";
                ((DropDownList)gridLineItemGridView.Rows[rowindex].Cells[17].FindControl("reasonReturnDropDownList"))
                    .Enabled = true;
            }
            else if (delqty > mainqty)
            {
                ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[14].FindControl("dQtyTextBox")).Text = "0";
                ((DropDownList)gridLineItemGridView.Rows[rowindex].Cells[17].FindControl("reasonReturnDropDownList"))
                    .Enabled = false;
                ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).Text = "Reject";
                ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).CssClass = "badge bg-danger";
                ((DropDownList)gridLineItemGridView.Rows[rowindex].Cells[17].FindControl("reasonReturnDropDownList"))
                    .Enabled = true;
            }
            else
            {
                ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).Text = "Reject";
                ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).CssClass = "badge bg-danger";
                ((DropDownList)gridLineItemGridView.Rows[rowindex].Cells[17].FindControl("reasonReturnDropDownList"))
                    .Enabled = true;
                //////Change////
                //if (delqty==0)
                //{
                //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("tpVatTextBox")).Text = "0";
                //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("dpTextBox")).Text = "0";
                //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("dpAmtTextBox")).Text = "0";
                //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("npTextBox")).Text = "0";
                //}
                ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[11].FindControl("tpVatTextBox")).Text = "0";
            }
            if (delqty <= mainqty)
            {
                TextBox unitPriceTextBox =
                    (TextBox)gridLineItemGridView.Rows[rowindex].Cells[4].FindControl("unitPriceTextBox");
                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text =
                    (Convert.ToDecimal(unitPriceTextBox.Text) * delqty).ToString();
                dadtlsOrderInfoBLL aOrderInfoBll = new dadtlsOrderInfoBLL();
                TotalValueCalculation();
                decimal totalprice = Convert.ToDecimal(campaignTPTextBox1.Text);

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
                string PaymentType = "";
                string SubmissionDate = "";
                int CustTypeId = 0;

                DataTable dtOffer = new DataTable();
                dtOffer = aOrderInfoBll.LoadOffer(invoiceNoHiddenField.Value);

                DataTable dtcAMPAIGN = new DataTable();
                dtcAMPAIGN = aOrderInfoBll.LoadCampaign(invoiceNoHiddenField.Value);

              


                DataTable dtinvoice = aOrderInfoBll.LoadInvoice(invoiceHiddenField.Value);

                DataTable dtFixedCustomer =
                    aOrderInfoBll.GetFixedCustomerfromInvoiceTable(invoiceHiddenField.Value);
                if (Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"]) == true)
                {
                    //2
                    //DataTable dttradepolicy = aOrderInfoBll.GetTradeTerm(totalprice.ToString());
                    //if (dttradepolicy.Rows.Count > 0)
                    //{
                    //    percentage = Convert.ToDecimal(0);
                    //}
                }
                else
                {
                    bool kkk = false;


                    try
                    {
                        kkk = Convert.ToBoolean(dtOffer.Rows[0]["OldTradePolicy"]);
                    }
                    catch
                    {

                    }
                    if (kkk == true)
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
                        //DataTable dttradepolicy = aOrderInfoBll.GetTradeTerm(totalprice.ToString());
                        //if (dttradepolicy.Rows.Count > 0)
                        //{
                        //    if (dtcAMPAIGN.Rows[0]["Campaign"].ToString() == "Bonus Campaign" ||
                        //        dtcAMPAIGN.Rows[0]["Campaign"].ToString() == "Sales Campaign")
                        //    {
                        //       // ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text = "0";
                        //     //   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpTextBox")).Text = "0";
                        //        // percentage = 0;
                        //        percentage = Convert.ToDecimal(dttradepolicy.Rows[0]["DiscountPerc"].ToString());
                        //    }
                        //    else if (hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Triforce 500]-Feb-24" || hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Triforce 1g IM]-Feb-24" || hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Triforce 1g IM]-Feb-24" || hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Triforce 500]-Feb-24"

                        //         || hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Aminobost]-Apr-24"
                        //          || hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Aminobost]-Apr-24"
                        //           || hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Triforce 1g IV]-Apr-24"
                        //            || hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Triforce 1g IV]-Apr-24" 
                        //            || hfCampaignName.Value.Trim() == "Special Rate [Triforce 1g IM]-Feb-24"

                        //            || hfCampaignName.Value.Trim() == "Special Rate [Triforce 1g IV]-Apr-24"
                        //              || hfCampaignName.Value.Trim() == "Special Rate [Aminobost]-Apr-24"
                        //              || hfCampaignName.Value.Trim() == "Special Rate [Triforce 1g IM]-Feb-24"
                        //              || hfCampaignName.Value.Trim() == "Special Rate [Triforce 500]-Feb-24"
                        //            )
                        //    {

                        //        DataTable CampDtls = aOrderInfoBll.LoadCampaignDtls(hfCampaignName.Value.Trim());
                        //        // ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text = "0";
                        //        //   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpTextBox")).Text = "0";
                        //        // percentage = 0;
                        //        percentage = Convert.ToDecimal(CampDtls.Rows[0]["DiscountPercentage"].ToString());
                        //    }

                        //    else
                        //    {
                        //        percentage = Convert.ToDecimal(dttradepolicy.Rows[0]["DiscountPerc"].ToString());
                        //    }
                        //}

                        DataTable dtEze = aOrderInfoBll.getEzeventCampaignCheck(OrderDetailsId.ToString());

                        DataTable dtESo = aOrderInfoBll.getEsomiumCampaignCheck(OrderDetailsId.ToString());
                        DataTable dtSeacoral = aOrderInfoBll.getEsomiumCampaignCheckSeacoral(OrderDetailsId.ToString());

                        if (dtEze != null && dtEze.Rows.Count > 0)
                        {
                            // ????? campaign match ???? item ???? => mainQty


                            // ????? delivered qty
                            delqty = Convert.ToDecimal(delqty); // delQty ????? ??????????

                            // ????? dtEze ???? DiscountPercentage ????
                            decimal discountPercentage = Convert.ToDecimal(dtEze.Rows[0]["DiscountPercentage"]);

                            // proportional calculation
                            percentage = discountPercentage;

                            percentage = Math.Round(percentage, 2);
                        }
                        else if (dtESo != null && dtESo.Rows.Count > 0)
                        {
                            // ????? campaign match ???? item ???? => mainQty


                            // ????? delivered qty
                            delqty = Convert.ToDecimal(delqty); // delQty ????? ??????????

                            // ????? dtEze ???? DiscountPercentage ????
                            decimal discountPercentage = Convert.ToDecimal(dtESo.Rows[0]["DiscountPercentage"]);

                            // proportional calculation
                            percentage = discountPercentage;

                            percentage = Math.Round(percentage, 2);
                        }
                        else if (dtSeacoral != null && dtSeacoral.Rows.Count > 0)
                        {
                            // ????? campaign match ???? item ???? => mainQty


                            // ????? delivered qty
                            delqty = Convert.ToDecimal(delqty); // delQty ????? ??????????

                            // ????? dtEze ???? DiscountPercentage ????
                            decimal discountPercentage = Convert.ToDecimal(dtSeacoral.Rows[0]["DiscountPercentage"]);

                            // proportional calculation
                            percentage = discountPercentage;

                            percentage = Math.Round(percentage, 2);
                        }

                        else
                        {



                            DataTable dttradepolicy = aOrderInfoBll.GetParcentFromOrderDetailsMasterID(orderIdHiddenField.Value);
                            if (dttradepolicy.Rows.Count > 0)
                            {
                                // percentage = Convert.ToDecimal(dttradepolicy.Rows[0]["DiscountPercent"].ToString());
                                PaymentType = (dttradepolicy.Rows[0]["PaymentType"].ToString());
                                CustTypeId = Convert.ToInt32(dttradepolicy.Rows[0]["CustTypeId"].ToString());
                                SubmissionDate = (dttradepolicy.Rows[0]["SubmissionDate"].ToString());
                            }

                            DataTable dttradepolicy22 = aOrderInfoBll.GetTradeTerm(tpTptalTextBox.Text, CustTypeId, PaymentType, SubmissionDate);
                            if (dttradepolicy22.Rows.Count > 0)
                            {
                                percentage = Convert.ToDecimal(dttradepolicy22.Rows[0]["DiscountPerc"].ToString());
                            }

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


                //DataTable dtproductvat =
                //    aOrderInfoBll.ProductVat(
                //        ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text);

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


                //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text == "True"

                //      && ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("bQtyTextBox")).Text == "True")
                //{

                //    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("npTextBox")).Text = 0.ToString();
                //    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("tpVatTextBox")).Text = 0.ToString();
                //    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("tpTextBox")).Text = 0.ToString();
                //    //(TextBox) gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox").te = 0;
                //}
                
                if (dtOffer.Rows[0]["ProductOffer"].ToString() == "False")
                {
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text = percentage.ToString();
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                        (Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                         (percentage / 100)).ToString("F");
                }

                if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text == "1")
                {

                    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                  0.ToString();
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                       0.ToString("F");
                }
                if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("bQtyTextBox")).Text == "True")
                {

                    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                  0.ToString();
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                       0.ToString("F");

                    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("tpTextBox")).Text =
              0.ToString();

                    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("tpVatTextBox")).Text =
              0.ToString();

                    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("npTextBox")).Text =
              0.ToString();
                }
                if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text != "1"
                    && ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("bQtyTextBox")).Text != "True")
                {
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                       percentage.ToString();
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                        (Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                         (percentage / 100)).ToString("F");
                }








                //else
                //{
                //    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                //       percentage.ToString();
                //    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                //        (Convert.ToDecimal(
                //            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                //         (percentage / 100)).ToString("F");
                //}



                //  if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text == "1")
                //  {

                //      ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                //    0.ToString();
                //      ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                //         0.ToString("F");
                //  }
                //  if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("bQtyTextBox")).Text == "True")
                //  {

                //      ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                //    0.ToString();
                //      ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                //         0.ToString("F");

                //      ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("tpTextBox")).Text =
                //0.ToString();

                //      ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("tpVatTextBox")).Text =
                //0.ToString();

                //      ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("npTextBox")).Text =
                //0.ToString();
                //  }
                //  if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text != "1"
                //      && ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("bQtyTextBox")).Text != "True")
                //  {
                //      ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                //         percentage.ToString();
                //      ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                //          (Convert.ToDecimal(
                //              ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                //           (percentage / 100)).ToString("F");
                //  }


                // else
                {
                    decimal vat = 0;

                    TextBox upVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("upVatTextBox");
                    vat = Convert.ToDecimal(upVatTextBox.Text);
                    //((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                    //    (Convert.ToDecimal(
                    //        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) *
                    //     (percamount / 100)).ToString();

                    decimal withdiscount = 0;
                    withdiscount =
                        (Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                         Convert.ToDecimal(
                             (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)) 
                        );
                    decimal vatamount = Convert.ToDecimal(upVatTextBox.Text) * delqty;

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
                                               .Trim())) +
                                      Convert.ToDecimal(tpVatTextBox.Text)).ToString();


                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text == "True"

                      && ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("bQtyTextBox")).Text == "True")
                    {

                        ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("npTextBox")).Text = 0.ToString();
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("tpVatTextBox")).Text = 0.ToString();
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("tpTextBox")).Text = 0.ToString();
                        //(TextBox) gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox").te = 0;
                    }
                }

                TotalValueCalculation();
            }
            else
            {
                showMessageBox("Cannot be greater then Total Quantity");
            }
        }
    }

    protected void dQtyTextBox_TextChanged(object sender, EventArgs e)
    {
        
            
            ViewState["IsCalculatedDel"] = false;

        //DqtyCalculation();
    }
}


