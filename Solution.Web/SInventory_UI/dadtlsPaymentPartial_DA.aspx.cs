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
using DocumentFormat.OpenXml.Spreadsheet;
using DocumentFormat.OpenXml.Bibliography;
using Library.DAL.MasterSetup_DAL;

public partial class dadtlsSInventory_UI_PaymentPartial_DA : System.Web.UI.Page
{
    private dadtlsRequisitionBLL aRequisitionBll = new dadtlsRequisitionBLL();
    private dadtlsInvoiceBLL aInvoiceBll = new dadtlsInvoiceBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string qsAppLogId = Request.QueryString["SalesReturnAppLogId"] ?? Request.QueryString["appLogId"];
            if (!string.IsNullOrEmpty(qsAppLogId))
            {
                hfSalesReturnAppLogId.Value = qsAppLogId;
            }
            else if (Session["SalesReturnAppLogId"] != null)
            {
                hfSalesReturnAppLogId.Value = Session["SalesReturnAppLogId"].ToString();
                Session["SalesReturnAppLogId"] = null;
            }

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



        if (ViewState["IsCalculatedDelReturn"] == null || !(bool)ViewState["IsCalculatedDelReturn"])
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
    }
    protected void backLinkButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("DelivaryInvoiceCreationAfterSalesConfirm_DA.aspx");
    }
    public void LoadInvoice(string invoiceId)
    {
        dadtlsOrderInfoBLL aOrderInfoBll = new dadtlsOrderInfoBLL();
        DataTable dtinvoice = aOrderInfoBll.LoadInvoicePartialPayment(invoiceId);
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
          //  DqtyCalculation();
            TotalValueCalculation();
        }
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            aInvoiceBll.ReturnReason(
                ((DropDownList) gridLineItemGridView.Rows[i].Cells[17].FindControl("reasonReturnDropDownList")));
        }

        DqtyCalculation();
        PopulateSalesReturnAppLogData();

        string qsStatus = Request.QueryString["status"] ?? Request.QueryString["Status"];
        if (!string.IsNullOrEmpty(qsStatus) && qsStatus.Equals("Full", StringComparison.OrdinalIgnoreCase))
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                TextBox dQtyTextBox = (TextBox)gridLineItemGridView.Rows[i].FindControl("dQtyTextBox");
                if (dQtyTextBox != null)
                {
                    dQtyTextBox.Text = "0";
                }
            }

            DqtyCalculation();

            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                TextBox dQtyTextBox = (TextBox)gridLineItemGridView.Rows[i].FindControl("dQtyTextBox");
                Label statusLabel = (Label)gridLineItemGridView.Rows[i].FindControl("statusLabel");
                DropDownList reasonReturnDropDownList = (DropDownList)gridLineItemGridView.Rows[i].FindControl("reasonReturnDropDownList");

                if (dQtyTextBox != null)
                {
                    dQtyTextBox.ReadOnly = true;
                }

                if (statusLabel != null)
                {
                    statusLabel.Text = "Reject";
                    statusLabel.CssClass = "badge bg-danger";
                }

                if (reasonReturnDropDownList != null)
                {
                    reasonReturnDropDownList.ClearSelection();
                    // status=Full means the whole DC was rejected outright, not partially
                    // returned per line item, so there's no per-row ReasonCode from
                    // tblSalesReturn_appLogDetail to read here — default to
                    // ReturndReasonId=3 ("Wrong Order") for this flow.
                    ListItem wrongOrderItem = reasonReturnDropDownList.Items.FindByValue("3");
                    if (wrongOrderItem == null)
                    {
                        wrongOrderItem = reasonReturnDropDownList.Items.FindByText("Wrong Order");
                    }
                    if (wrongOrderItem != null)
                    {
                        wrongOrderItem.Selected = true;
                    }
                    reasonReturnDropDownList.Enabled = false;
                }
            }
        }
        else
        {
            DqtyCalculation();
        }

        lnkCalculate_Click(null, null);
        lnkCalculate.Visible = false;
    }

    private void PopulateSalesReturnAppLogData()
    {
        try
        {
            string appLogId = hfSalesReturnAppLogId.Value;
            string invoiceId = invoiceHiddenField.Value;

            InvoiceBLL_daaw aInvBllDaaw = new InvoiceBLL_daaw();
            DataTable dtAppLogDetails = aInvBllDaaw.LoadSalesReturnAppLogDetails(invoiceId, appLogId);

            // If the SalesReturnAppLogId we were handed (querystring/Session) is missing, stale,
            // or simply doesn't match this invoice's actual log, LoadSalesReturnAppLogDetails
            // returns 0 rows and the Reason dropdowns silently stay unselected below. Fall back
            // to the invoice's latest real SalesReturnAppLogId and retry once before giving up.
            if ((dtAppLogDetails == null || dtAppLogDetails.Rows.Count == 0) && !string.IsNullOrEmpty(invoiceId))
            {
                int invoiceIdInt;
                if (int.TryParse(invoiceId, out invoiceIdInt))
                {
                    string latestAppLogId = aInvBllDaaw.GetSalesReturnAppLogIdByInvoiceId(invoiceIdInt);
                    if (!string.IsNullOrEmpty(latestAppLogId) && latestAppLogId != appLogId)
                    {
                        appLogId = latestAppLogId;
                        hfSalesReturnAppLogId.Value = appLogId;
                        dtAppLogDetails = aInvBllDaaw.LoadSalesReturnAppLogDetails(invoiceId, appLogId);
                    }
                }
            }

            if (dtAppLogDetails != null && dtAppLogDetails.Rows.Count > 0)
            {
                Dictionary<string, DataRow> appLogMapByInvDetailId = new Dictionary<string, DataRow>();
                Dictionary<string, DataRow> appLogMapByProdCode = new Dictionary<string, DataRow>();

                foreach (DataRow dr in dtAppLogDetails.Rows)
                {
                    string invDetailId = dr.Table.Columns.Contains("InvoiceDetailId") && dr["InvoiceDetailId"] != DBNull.Value ? dr["InvoiceDetailId"].ToString().Trim() : "";
                    if (!string.IsNullOrEmpty(invDetailId) && !appLogMapByInvDetailId.ContainsKey(invDetailId))
                    {
                        appLogMapByInvDetailId[invDetailId] = dr;
                    }

                    string prodCode = dr.Table.Columns.Contains("ProductCode") && dr["ProductCode"] != DBNull.Value ? dr["ProductCode"].ToString().Trim() : "";
                    if (!string.IsNullOrEmpty(prodCode) && !appLogMapByProdCode.ContainsKey(prodCode))
                    {
                        appLogMapByProdCode[prodCode] = dr;
                    }
                }

                for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
                {
                    string invDetailId = "";
                    try
                    {
                        if (gridLineItemGridView.DataKeys[i] != null && gridLineItemGridView.DataKeys[i]["InvoiceDetailId"] != null)
                        {
                            invDetailId = gridLineItemGridView.DataKeys[i]["InvoiceDetailId"].ToString().Trim();
                        }
                    }
                    catch { }

                    TextBox codeTextBox = (TextBox)gridLineItemGridView.Rows[i].FindControl("codeTextBox");
                    string prodCode = codeTextBox != null ? codeTextBox.Text.Trim() : "";

                    DataRow logRow = null;
                    if (!string.IsNullOrEmpty(invDetailId) && appLogMapByInvDetailId.ContainsKey(invDetailId))
                    {
                        logRow = appLogMapByInvDetailId[invDetailId];
                    }
                    else if (!string.IsNullOrEmpty(prodCode) && appLogMapByProdCode.ContainsKey(prodCode))
                    {
                        logRow = appLogMapByProdCode[prodCode];
                    }

                    if (logRow != null)
                    {
                        TextBox tQtyTextBox = (TextBox)gridLineItemGridView.Rows[i].FindControl("tQtyTextBox");
                        TextBox dQtyTextBox = (TextBox)gridLineItemGridView.Rows[i].FindControl("dQtyTextBox");
                        Label statusLabel = (Label)gridLineItemGridView.Rows[i].FindControl("statusLabel");
                        DropDownList reasonReturnDropDownList = (DropDownList)gridLineItemGridView.Rows[i].FindControl("reasonReturnDropDownList");

                        decimal totalQty = 0;
                        if (tQtyTextBox != null && !string.IsNullOrEmpty(tQtyTextBox.Text))
                        {
                            decimal.TryParse(tQtyTextBox.Text, out totalQty);
                        }

                        // tblSalesReturn_appLogDetail.ReturnQty holds the CONFIRMED/DELIVERED
                        // quantity (it matches ReturnStatus 1:1 — e.g. ReturnQty=OrderedQty when
                        // ReturnStatus='Full', ReturnQty=0 when ReturnStatus='Reject'), not the
                        // quantity rejected/returned. Use it directly instead of subtracting it
                        // from totalQty, which previously inverted every row's Full/Reject state.
                        decimal returnQty = logRow["ReturnQty"] != DBNull.Value ? Convert.ToDecimal(logRow["ReturnQty"]) : 0;
                        decimal deliveredQty = returnQty;
                        if (deliveredQty < 0) deliveredQty = 0;
                        if (deliveredQty > totalQty) deliveredQty = totalQty;

                        if (dQtyTextBox != null)
                        {
                            dQtyTextBox.Text = deliveredQty.ToString("0.##");
                            dQtyTextBox.ReadOnly = true;
                        }

                        if (statusLabel != null)
                        {
                            if (deliveredQty <= 0)
                            {
                                statusLabel.Text = "Reject";
                                statusLabel.CssClass = "badge bg-danger";
                            }
                            else if (deliveredQty >= totalQty)
                            {
                                statusLabel.Text = "Full";
                                statusLabel.CssClass = "badge bg-success";
                            }
                            else
                            {
                                statusLabel.Text = "Partial";
                                statusLabel.CssClass = "badge bg-warning";
                            }
                        }

                        if (reasonReturnDropDownList != null)
                        {
                            reasonReturnDropDownList.ClearSelection();
                            reasonReturnDropDownList.Enabled = false;

                            // Fully delivered/accepted rows never have a return reason — skip the
                            // lookup entirely so the "Reason" column's SQL fallback text (e.g. the
                            // generic 'Sales Return' the CASE expression emits when ReasonCode/Label
                            // are both null) can't get fuzzy-matched into a stray selection here.
                            if (deliveredQty > 0 && deliveredQty >= totalQty)
                            {
                                continue;
                            }

                            string rCode = logRow.Table.Columns.Contains("ReasonCode") && logRow["ReasonCode"] != DBNull.Value ? logRow["ReasonCode"].ToString().Trim() : "";
                            string rLabel = logRow.Table.Columns.Contains("ReasonLabel") && logRow["ReasonLabel"] != DBNull.Value ? logRow["ReasonLabel"].ToString().Trim() : "";
                            string rText = logRow.Table.Columns.Contains("Reason") && logRow["Reason"] != DBNull.Value ? logRow["Reason"].ToString().Trim() : "";

                            ListItem item = !string.IsNullOrEmpty(rCode) ? reasonReturnDropDownList.Items.FindByValue(rCode) : null;
                            if (item == null && !string.IsNullOrEmpty(rLabel))
                            {
                                item = reasonReturnDropDownList.Items.FindByText(rLabel);
                            }
                            if (item == null && !string.IsNullOrEmpty(rCode))
                            {
                                item = reasonReturnDropDownList.Items.FindByText(rCode);
                            }
                            if (item == null && !string.IsNullOrEmpty(rText))
                            {
                                item = reasonReturnDropDownList.Items.FindByText(rText);
                            }

                            if (item == null)
                            {
                                string targetStr = (!string.IsNullOrEmpty(rLabel) ? rLabel : (!string.IsNullOrEmpty(rText) ? rText : rCode)).ToLower();
                                if (!string.IsNullOrEmpty(targetStr))
                                {
                                    foreach (ListItem li in reasonReturnDropDownList.Items)
                                    {
                                        if (li.Text.ToLower().Trim() == targetStr || li.Value.ToLower().Trim() == targetStr || li.Text.ToLower().Contains(targetStr))
                                        {
                                            item = li;
                                            break;
                                        }
                                    }
                                }
                            }

                            if (item != null)
                            {
                                item.Selected = true;
                            }
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            // Don't fail page load over a Reason-lookup problem, but keep the error visible
            // instead of silently discarding it (this used to hide real bugs here).
            System.Diagnostics.Trace.TraceError(
                "PopulateSalesReturnAppLogData failed for InvoiceId={0}, SalesReturnAppLogId={1}: {2}",
                invoiceHiddenField.Value, hfSalesReturnAppLogId.Value, ex);
        }
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
    }

    protected void custCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        string custCode = custCodeTextBox.Text.Trim();
        GetCustInfo(custCode);
    }

    private void InitialGrid()
    {
        try
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
            aDataTable.Columns.Add("Campaign");
            aDataTable.Columns.Add("ISGiftProduct");
            aDataTable.Columns.Add("IsCampaignProduct");
            aDataTable.Columns.Add("DelTotalQty");
            aDataTable.Columns.Add("CampaignType");
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
            dataRow["Campaign"] = "";
            dataRow["ISGiftProduct"] = "";
            dataRow["IsCampaignProduct"] = "";
            dataRow["DelTotalQty"] = "";
            dataRow["CampaignType"] = "";
            aDataTable.Rows.Add(dataRow);

            gridLineItemGridView.DataSource = null;
            gridLineItemGridView.DataBind();
            gridLineItemGridView.DataSource = aDataTable;
            gridLineItemGridView.DataBind();

            gridLineItemGridView.Columns[4].Visible = false;
            gridLineItemGridView.Columns[5].Visible = false;
        }
        catch
        {

        }

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

    /// Acquires a session-scoped exclusive app lock so the duplicate-submit re-check and the
    /// writes that follow it run one at a time across ALL DA partial-payment submits, closing the
    /// same TOCTOU race handled for the other Invoice/Delivery/Payment submit flows: the
    /// pre-flight GetDelivaryInvoiceNoCheckById above can be beaten by a concurrent submit for the
    /// same invoice; this recheck cannot, because the app lock serializes it.
    private static void AcquireDaPaymentPartialSubmitLock(SqlConnection connection, SqlTransaction transaction, string invoiceId)
    {
        using (SqlCommand cmd = new SqlCommand("sp_getapplock", connection, transaction))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Resource", "DaPaymentPartialSubmit_Global");
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
                    "Could not acquire the DA payment partial submit lock for InvoiceId=" + invoiceId +
                    " (sp_getapplock result=" + result + "). Another submit for this invoice may be in progress.");
            }
        }
    }

    /// Releases the session-owned lock taken by AcquireDaPaymentPartialSubmitLock once the submit
    /// finishes (success or failure) so other submits are not blocked behind it.
    private static void ReleaseDaPaymentPartialSubmitLock(SqlConnection connection, SqlTransaction transaction)
    {
        using (SqlCommand cmd = new SqlCommand("sp_releaseapplock", connection, transaction))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Resource", "DaPaymentPartialSubmit_Global");
            cmd.Parameters.AddWithValue("@LockOwner", "Session");
            cmd.ExecuteNonQuery();
        }
    }

    protected void saveButton_Click(object sender, EventArgs e)
    {
        // Guard against double-click / duplicate async postbacks. Shared with
        // btnPartialReject_Click since both act on the same invoice.
        if (Session["IsDaPaymentPartialSubmitting"] != null &&
            (bool)Session["IsDaPaymentPartialSubmitting"] == true)
        {
            return;
        }

        Session["IsDaPaymentPartialSubmitting"] = true;
        try
        {
            if (Validation() == true)
            {
                try
                {

                    dadtlsBonusCampaignNewDAL _BonusCampaignNewDAL = new dadtlsBonusCampaignNewDAL();
                    //DelivaryInvoiceNo
                    using (DataTable dt = _BonusCampaignNewDAL.GetDelivaryInvoiceNoCheckById(invoiceHiddenField.Value, "PaymentInvoiceNoChk"))
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
                                    AcquireDaPaymentPartialSubmitLock(connection, transaction, invoiceHiddenField.Value);

                                    // Re-check inside the lock+transaction: the pre-flight check above
                                    // can be beaten by a concurrent submit; this recheck cannot.
                                    DataTable existingPayment = _BonusCampaignNewDAL.GetDelivaryInvoiceNoCheckById(
                                        invoiceHiddenField.Value, "PaymentInvoiceNoChk", transaction);
                                    if (existingPayment.Rows.Count > 0)
                                    {
                                        transaction.Rollback();
                                        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);
                                        Clear();
                                        return;
                                    }

                                    int invId = SaveInvoice(transaction);

                                    // Update DIC Approval Status
                                    if (!string.IsNullOrEmpty(hfSalesReturnAppLogId.Value))
                                    {
                                        InvoiceBLL_daaw aInvBllDaaw = new InvoiceBLL_daaw();
                                        aInvBllDaaw.UpdateDICApprovalStatus_SalesReturn(hfSalesReturnAppLogId.Value, "Approved", Session["LoginName"].ToString(), transaction);
                                    }

                                    SaveInvoiceDetail(invId, transaction);

                                    ReleaseDaPaymentPartialSubmitLock(connection, transaction);

                                    transaction.Commit();
                                    committed = true;

                                    Clear();

                                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Approved Successfully!" + "','Success');", true);
                                }
                                catch (Exception ex)
                                {
                                    if (!committed)
                                    {
                                        try { transaction.Rollback(); } catch { /* connection/transaction may already be dead; nothing left to roll back */ }
                                    }
                                    System.Diagnostics.Trace.TraceError(
                                        "DA Payment Partial Submit failed for InvoiceId={0}: {1}", invoiceHiddenField.Value, ex);
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
                }
            }
        }
        finally
        {
            Session["IsDaPaymentPartialSubmitting"] = false;
        }

    }

    protected void btnPartialReject_Click(object sender, EventArgs e)
    {
        // Guard against double-click / duplicate async postbacks — shared with saveButton_Click
        // since both act on the same invoice and must not run concurrently.
        if (Session["IsDaPaymentPartialSubmitting"] != null &&
            (bool)Session["IsDaPaymentPartialSubmitting"] == true)
        {
            return;
        }

        Session["IsDaPaymentPartialSubmitting"] = true;
        try
        {
            InvoiceBLL_daaw aInvBllDaaw = new InvoiceBLL_daaw();
            int invoiceId;
            if (int.TryParse(invoiceHiddenField.Value, out invoiceId))
            {
                if (aInvBllDaaw.RejectInvoiceDASalesReturn(invoiceId, hfSalesReturnAppLogId.Value))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "alert('Invoice rejected successfully.'); window.location='DelivaryInvoiceCreationAfterSalesConfirm_DA.aspx';", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('Failed to reject invoice.','Failed');", true);
                }
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('Error: " + ex.Message.Replace("'", "") + "','Failed');", true);
        }
        finally
        {
            Session["IsDaPaymentPartialSubmitting"] = false;
        }
    }

    private bool SaveInvoiceDetail(int invoiceId, SqlTransaction transaction)
    {

        List<dadtlsInvoiceDetail> aInvoiceDetailsList = new List<dadtlsInvoiceDetail>();
        // Prevents the same physical batch (DCStoreId) from being credited more than once
        // in a single submit when two grid rows resolve to the same DCStoreId — UpdateDCStock
        // is an additive UPDATE (StockQty = StockQty + qty), so a repeat call double-counts.
        HashSet<int> updatedDCStoreIds = new HashSet<int>();

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
                                          ((HiddenField) gridLineItemGridView.Rows[i].Cells[13].FindControl("hfDelTotalQty"))
                                          .Value) -
                                      Convert.ToDecimal(
                                          ((TextBox) gridLineItemGridView.Rows[i].Cells[14].FindControl("dQtyTextBox"))
                                          .Text);
                        //aInvoiceBll.SaveDCStoreFreeze(aDcStockNew);
                        if (updatedDCStoreIds.Add(aDcStockNew.DCStoreId))
                        {
                            aInvoiceBll.UpdateDCStock(qty, aDcStockNew.DCStoreId, transaction);
                        }
                    }
                }


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
 
        invTextBox.Text = "RTN-" + aInvoice.DelivaryInvoiceNo;
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


    protected void lnkCalculate_Click(object sender, EventArgs e)
    {
        // CalculateQty();
        DqtyCalculation();  // call your existing function after updating

        ViewState["IsCalculatedDelReturn"] = true;
        lnkCalculate.Visible = false;
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
            HiddenField hfCampaignName = ((HiddenField)gridLineItemGridView.Rows[i].Cells[9].FindControl("hfCampaignName"));
            HiddenField hfCampaignType = ((HiddenField)gridLineItemGridView.Rows[i].Cells[9].FindControl("hfCampaignType"));
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
                    .Enabled = false;
            }
            else if (delqty > mainqty)
            {
                ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[14].FindControl("dQtyTextBox")).Text = "0";
                ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).Text = "Reject";
                ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).CssClass = "badge bg-danger";
                ((DropDownList)gridLineItemGridView.Rows[rowindex].Cells[17].FindControl("reasonReturnDropDownList"))
                    .Enabled = false;
            }
            else
            {
                ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).Text = "Reject";
                ((Label)gridLineItemGridView.Rows[rowindex].Cells[15].FindControl("statusLabel")).CssClass = "badge bg-danger";
                ((DropDownList)gridLineItemGridView.Rows[rowindex].Cells[17].FindControl("reasonReturnDropDownList"))
                    .Enabled = false;
            }    //////Change////
                //if (delqty==0)
                //{
                //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("tpVatTextBox")).Text = "0";
                //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("dpTextBox")).Text = "0";
                //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("dpAmtTextBox")).Text = "0";
                //    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("npTextBox")).Text = "0";
                //}
                ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[11].FindControl("tpVatTextBox")).Text = "0";

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

                    bool ggg = false;
                    try
                    {
                        ggg = Convert.ToBoolean(dtOffer.Rows[0]["OldTradePolicy"]);
                    }
                    catch
                    {

                    }
                    if (ggg == true)
                    {
                        DataTable dttradepolicy = aOrderInfoBll.GetTradeTermOld(tpTptalTextBox.Text);
                        if (dttradepolicy.Rows.Count > 0)
                        {
                            percentage = Convert.ToDecimal(dttradepolicy.Rows[0]["DiscountPerc"].ToString());
                        }
                    }
                    else
                    {

                        int OrderDetailsId = Convert.ToInt32(gridLineItemGridView.DataKeys[i]["InvoiceDetailId"].ToString());

                        DataTable dtEze = aOrderInfoBll.getEzeventCampaignCheck(OrderDetailsId.ToString());
                        DataTable dtESo = aOrderInfoBll.getEsomiumCampaignCheck(OrderDetailsId.ToString());



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
                        //        //percentage = Convert.ToDecimal(dttradepolicy.Rows[0]["DiscountPerc"].ToString());
                        //    }

                        //    //else if (hfCampaignName.Value.Trim() == "Special Rate [Aminobost]-Apr-24" || hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Triforce 500]-Feb-24" || hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Triforce 1g IM]-Feb-24" || hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Triforce 1g IM]-Feb-24" || hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Triforce 500]-Feb-24"

                        //    //       || hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Aminobost]-Apr-24"
                        //    //        || hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Aminobost]-Apr-24"
                        //    //         || hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Triforce 1g IV]-Apr-24"
                        //    //          || hfCampaignName.Value.Trim() == "Bonus Campaign | Special Rate [Triforce 1g IV]-Apr-24"
                        //    //          || hfCampaignName.Value.Trim() == "Special Rate [Triforce 1g IM]-Feb-24"
                        //    //          || hfCampaignName.Value.Trim() == "Special Rate [Triforce 1g IV]-Apr-24"
                        //    //          || hfCampaignName.Value.Trim() == "Special Rate [Aminobost]-Apr-24"
                        //    //          || hfCampaignName.Value.Trim() == "Special Rate [Triforce 1g IM]-Feb-24"
                        //    //          || hfCampaignName.Value.Trim() == "Special Rate [Triforce 500]-Feb-24"
                        //    //          )




                        //    //{

                        //    //    DataTable CampDtls = aOrderInfoBll.LoadCampaignDtls(hfCampaignName.Value.Trim());
                        //    //    // ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text = "0";
                        //    //    //   ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpTextBox")).Text = "0";
                        //    //    // percentage = 0;
                        //    //    percentage = Convert.ToDecimal(CampDtls.Rows[0]["DiscountPercentage"].ToString());
                        //    //}

                        //    else
                        //    {
                        //        percentage = Convert.ToDecimal(dttradepolicy.Rows[0]["DiscountPerc"].ToString());
                        //    }
                        //}
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
        TextBox dQtyTextBox = (TextBox)sender;
        GridViewRow row = (GridViewRow)dQtyTextBox.NamingContainer;
        HiddenField hfDelTotalQty = (HiddenField)row.FindControl("hfDelTotalQty");
        TextBox dQty  = (TextBox)row.FindControl("dQtyTextBox");

        int DelTotalQty = 0;
        try
        {
            DelTotalQty = Convert.ToInt32(hfDelTotalQty.Value);
        }
        catch
        {

        }
        int mainqty = 0;
        try
        {
            mainqty = Convert.ToInt32(dQty.Text);
        }
        catch
        {

        }

        if (DelTotalQty <= mainqty)
        {
            showMessageBox("Cannot be greater then Sales confirmation Quantity");
            dQty.Text = DelTotalQty.ToString();
        }

       
    }
}

