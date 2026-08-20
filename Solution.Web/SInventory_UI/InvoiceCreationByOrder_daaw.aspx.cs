using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.InternalCls;
using Library.DAL.MasterSetup_DAL;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_InvoiceCreationByOrder_daaw : System.Web.UI.Page
{
    private const string SearchModeRouteWise = "RouteWise";
    private const string SearchModeTerritoryWise = "TerritoryWise";

    private List<string> SelectedOrderIds
    {
        get
        {
            if (ViewState["SelectedOrderIds"] == null)
            {
                ViewState["SelectedOrderIds"] = new List<string>();
            }
            return (List<string>)ViewState["SelectedOrderIds"];
        }
        set
        {
            ViewState["SelectedOrderIds"] = value;
        }
    }

    private void BindSelectedGrid()
    {
        DataTable mainTable = Session["MainTable"] as DataTable;
        if (mainTable == null || SelectedOrderIds.Count == 0)
        {
            selectedGridView.DataSource = null;
            selectedGridView.DataBind();
            selectedGridContainer.Visible = false;
            
            SyncMainGridCheckboxes();
            return;
        }

        var selectedRows = mainTable.AsEnumerable()
            .Where(row => SelectedOrderIds.Contains(row["OrderId"].ToString()));

        if (selectedRows.Any())
        {
            DataTable selectedDt = selectedRows.CopyToDataTable();
            selectedGridView.DataSource = selectedDt;
            selectedGridView.DataBind();
            selectedGridContainer.Visible = true;

            if (selectedGridView.Rows.Count > 0)
            {
                selectedGridView.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }
        else
        {
            selectedGridView.DataSource = null;
            selectedGridView.DataBind();
            selectedGridContainer.Visible = false;
        }

        SyncMainGridCheckboxes();
    }

    private void SyncMainGridCheckboxes()
    {
        List<string> selectedIds = SelectedOrderIds;
        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            GridViewRow row = orderGridView.Rows[i];
            CheckBox chkSelect = (CheckBox)row.FindControl("chkSelect");
            Button gotoinvoiceButton = (Button)row.FindControl("gotoinvoiceButton");
            bool isDisabledByRule = gotoinvoiceButton != null && !gotoinvoiceButton.Enabled;

            string orderId = orderGridView.DataKeys[i]["OrderId"].ToString();

            if (chkSelect != null)
            {
                if (selectedIds.Contains(orderId))
                {
                    chkSelect.Checked = true;
                    chkSelect.Enabled = false;
                }
                else
                {
                    chkSelect.Checked = false;
                    chkSelect.Enabled = !isDisabledByRule;
                }
            }
        }
    }

    protected void btnRemove_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        string orderId = btn.CommandArgument;
        List<string> selectedIds = SelectedOrderIds;
        if (selectedIds.Contains(orderId))
        {
            selectedIds.Remove(orderId);
            SelectedOrderIds = selectedIds;
        }
        BindSelectedGrid();
    }

    protected void chkSelect_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox button = (CheckBox)sender;
        GridViewRow currentRow = (GridViewRow)button.Parent.Parent;
        int rowindex = currentRow.RowIndex;
        string orderId = orderGridView.DataKeys[rowindex]["OrderId"].ToString();

        List<string> selectedIds = SelectedOrderIds;

        if (button.Checked)
        {
            if (!selectedIds.Contains(orderId))
            {
                selectedIds.Add(orderId);
            }
        }
        else
        {
            if (selectedIds.Contains(orderId))
            {
                selectedIds.Remove(orderId);
            }
        }

        SelectedOrderIds = selectedIds;
        BindSelectedGrid();
    }
    OrderInfoBLL_daaw aOrderInfoBll=new OrderInfoBLL_daaw();
    InvoiceBLL_daaw aInvoiceBll = new InvoiceBLL_daaw();
    private OrderPaymentApprovalService _paymentApprovalService = new OrderPaymentApprovalService();
    static CommonDataLoad_daaw _dataLoad = new CommonDataLoad_daaw();
    private static BonusCampaignNewDAL_daaw _BonusCampaignNewDAL = new BonusCampaignNewDAL_daaw();

    private decimal _selectedGrossTotal = 0;
    private decimal _orderGrossTotal = 0;

    protected void selectedGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            decimal val = 0;
            object grossVal = DataBinder.Eval(e.Row.DataItem, "GrossValue");
            decimal.TryParse(grossVal != null ? grossVal.ToString() : "0", out val);
            _selectedGrossTotal += val;
        }
        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            Label lbl = (Label)e.Row.FindControl("lblSelectedGrossTotal");
            if (lbl != null) lbl.Text = "Total: " + _selectedGrossTotal.ToString("N2");
        }
    }

    protected void orderGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            decimal val = 0;
            object grossVal = DataBinder.Eval(e.Row.DataItem, "GrossValue");
            decimal.TryParse(grossVal != null ? grossVal.ToString() : "0", out val);
            _orderGrossTotal += val;

            System.Data.DataRowView drv = (System.Data.DataRowView)e.Row.DataItem;
            if (drv != null)
            {
                bool isMaxExceeded = false;
                bool isCreditExceeded = false;

                if (drv.DataView.Table.Columns.Contains("IsMaxOutstandingExceeded") && drv["IsMaxOutstandingExceeded"] != DBNull.Value)
                {
                    string maxExceededVal = Convert.ToString(drv["IsMaxOutstandingExceeded"]).ToLower();
                    isMaxExceeded = (maxExceededVal == "1" || maxExceededVal == "true");
                }

                if (drv.DataView.Table.Columns.Contains("IsCreditPeriodExceeded") && drv["IsCreditPeriodExceeded"] != DBNull.Value)
                {
                    string creditExceededVal = Convert.ToString(drv["IsCreditPeriodExceeded"]).ToLower();
                    isCreditExceeded = (creditExceededVal == "1" || creditExceededVal == "true");
                }

                // Order Payment Approval: -1 (or a missing column) means no live approval
                // request exists for this order. Rejected/cancelled requests are deactivated
                // by the proc, so they also surface as -1 and the order can be re-submitted.
                int approvalStatus = OrderPaymentApprovalStatus.NoRequest;
                if (drv.DataView.Table.Columns.Contains("PaymentApprovalStatus") && drv["PaymentApprovalStatus"] != DBNull.Value)
                {
                    Int32.TryParse(Convert.ToString(drv["PaymentApprovalStatus"]), out approvalStatus);
                }

                if ((isMaxExceeded || isCreditExceeded) && approvalStatus != OrderPaymentApprovalStatus.FullyApproved)
                {
                    System.Web.UI.WebControls.CheckBox chkSelect = (System.Web.UI.WebControls.CheckBox)e.Row.FindControl("chkSelect");
                    System.Web.UI.WebControls.Button gotoinvoiceButton = (System.Web.UI.WebControls.Button)e.Row.FindControl("gotoinvoiceButton");
                    System.Web.UI.WebControls.Button btnGoForApproval = (System.Web.UI.WebControls.Button)e.Row.FindControl("btnGoForApproval");
                    System.Web.UI.WebControls.Label lblApprovalStatus = (System.Web.UI.WebControls.Label)e.Row.FindControl("lblApprovalStatus");
                    System.Web.UI.WebControls.Label lblWarning = (System.Web.UI.WebControls.Label)e.Row.FindControl("lblWarning");

                    if (chkSelect != null) chkSelect.Enabled = false;
                    if (gotoinvoiceButton != null)
                    {
                        // Kept Enabled=false as well as hidden: SyncMainGridCheckboxes() derives
                        // the checkbox state from gotoinvoiceButton.Enabled.
                        gotoinvoiceButton.Enabled = false;
                        gotoinvoiceButton.Visible = false;
                        gotoinvoiceButton.CssClass += " disabled";
                    }

                    if (approvalStatus == OrderPaymentApprovalStatus.NoRequest)
                    {
                        if (btnGoForApproval != null) btnGoForApproval.Visible = true;

                        if (lblWarning != null)
                        {
                            lblWarning.Text = isMaxExceeded
                                ? "Customer already has maximum 2 outstanding invoices."
                                : "Credit period exceeded.";
                        }
                    }
                    else if (lblApprovalStatus != null)
                    {
                        lblApprovalStatus.Visible = true;
                        lblApprovalStatus.Text = OrderPaymentApprovalStatus.GetName(approvalStatus);
                    }
                }
            }
        }
        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            Label lbl = (Label)e.Row.FindControl("lblOrderGrossTotal");
            if (lbl != null) lbl.Text = "Total: " + _orderGrossTotal.ToString("N2");
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                invoiceCreationModeRadioButtonList.SelectedValue = SearchModeRouteWise;
                ApplyInvoiceCreationMode();
                DropDownlist();

                // Set when InvoiceCreationForCustomerByOrder.aspx bounced a blocked order back.
                if (Session["PaymentApprovalBlockReason"] != null)
                {
                    ShowFailedAlert(Session["PaymentApprovalBlockReason"].ToString());
                    Session["PaymentApprovalBlockReason"] = null;
                }
            }
        }
        catch(Exception ex)
        {

        }
    }



    protected void lbDue_Click(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        HiddenField hfCustomerMasterId = (HiddenField)gvRow.FindControl("hfCustomerMasterId");
        HiddenField hfTerritoryId = (HiddenField)gvRow.FindControl("hfTerritoryId");
        if (hfCustomerMasterId == null) return;

        InvoiceDAL_daaw aInvoiceDal = new InvoiceDAL_daaw();
        DataTable dtReceiveable = aInvoiceDal.GetNewReceiveableDAl("  AND mas.[CustomerMasterId]=" + hfCustomerMasterId.Value, null, null).Copy();
        if (dtReceiveable.Rows.Count > 0)
        {
            decimal returnAmount = 0;
            decimal paidAmount = 0;
            decimal dueAmount = 0;

            foreach (DataRow row in dtReceiveable.Rows)
            {
                decimal tempReturn = 0;
                decimal tempPaid = 0;
                decimal tempDue = 0;

                decimal.TryParse(Convert.ToString(row["ReturnAmount"]), out tempReturn);
                decimal.TryParse(Convert.ToString(row["CustomerPaymentAmount"]), out tempPaid);
                decimal.TryParse(Convert.ToString(row["ReceivableTotalAmnt"]), out tempDue);

                returnAmount += tempReturn;
                paidAmount += tempPaid;
                dueAmount += tempDue;
            }

            // Bind data
            gv_Invoice.DataSource = dtReceiveable;
            gv_Invoice.DataBind();

            // Show totals in footer
            if (gv_Invoice.FooterRow != null)
            {
                (gv_Invoice.FooterRow.FindControl("lblTotalInvoice") as Label).Text = returnAmount.ToString("N2");
                (gv_Invoice.FooterRow.FindControl("lblTotalPaid") as Label).Text = paidAmount.ToString("N2");
                (gv_Invoice.FooterRow.FindControl("lblTotalDue") as Label).Text = dueAmount.ToString("N2");
            }
        }
        else
        {
            gv_Invoice.DataSource = null;
            gv_Invoice.DataBind();
        }

        if (hfTerritoryId != null && !string.IsNullOrEmpty(hfTerritoryId.Value))
        {
            DataTable dtTerritoryWise = aInvoiceDal.GetNewReceiveableDAl("  AND mas.[TerritoryId]=" + hfTerritoryId.Value, null, null).Copy();
            
            if (dtTerritoryWise.Rows.Count > 0)
            {
                decimal tempReturn = 0;
                decimal tempPaid = 0;
                decimal tempDue = 0;

                foreach (DataRow row in dtTerritoryWise.Rows)
                {
                    decimal ret = 0, pad = 0, due = 0;
                    decimal.TryParse(Convert.ToString(row["ReturnAmount"]), out ret);
                    decimal.TryParse(Convert.ToString(row["CustomerPaymentAmount"]), out pad);
                    decimal.TryParse(Convert.ToString(row["ReceivableTotalAmnt"]), out due);
                    
                    tempReturn += ret;
                    tempPaid += pad;
                    tempDue += due;
                }
                
                string cTypeCol = dtTerritoryWise.Columns.Contains("CustomerType") ? "CustomerType" : (dtTerritoryWise.Columns.Contains("NewType") ? "NewType" : (dtTerritoryWise.Columns.Contains("Type") ? "Type" : null));
                
                DataView dv = dtTerritoryWise.DefaultView;
                try {
                    if (cTypeCol != null && dtTerritoryWise.Columns.Contains("CustomerName")) {
                        dv.Sort = cTypeCol + " ASC, CustomerName ASC";
                    } else if (dtTerritoryWise.Columns.Contains("CustomerName")) {
                        dv.Sort = "CustomerName ASC";
                    }
                } catch { }
                
                gv_CustomerTypeWise.DataSource = dv;
                gv_CustomerTypeWise.DataBind();

                if (gv_CustomerTypeWise.FooterRow != null)
                {
                    (gv_CustomerTypeWise.FooterRow.FindControl("lblTotalInvoice_CT") as Label).Text = tempReturn.ToString("N2");
                    (gv_CustomerTypeWise.FooterRow.FindControl("lblTotalPaid_CT") as Label).Text = tempPaid.ToString("N2");
                    (gv_CustomerTypeWise.FooterRow.FindControl("lblTotalDue_CT") as Label).Text = tempDue.ToString("N2");
                }
            }
            else
            {
                gv_CustomerTypeWise.DataSource = null;
                gv_CustomerTypeWise.DataBind();
            }
        }
        else
        {
            gv_CustomerTypeWise.DataSource = null;
            gv_CustomerTypeWise.DataBind();
        }

        mpe_1.Show(); 
    }
    protected void btnCloseModal_Click(object sender, EventArgs e)
    {
        mpe_1.Hide();
    }

    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        Response.Clear();
        Response.Buffer = true;
        Response.AddHeader("content-disposition", "attachment;filename=CustomerDuesStatus.xls");
        Response.Charset = "";
        Response.ContentType = "application/vnd.ms-excel";

        using (System.IO.StringWriter sw = new System.IO.StringWriter())
        {
            HtmlTextWriter hw = new HtmlTextWriter(sw);

            if (gv_Invoice.Rows.Count > 0)
            {
                sw.Write("<h3>Customer Previous Dues Status</h3>");
                gv_Invoice.RenderControl(hw);
                sw.Write("<br/>");
            }
            if (gv_CustomerTypeWise.Rows.Count > 0)
            {
                sw.Write("<h3>Territory & Customer Type Wise Status</h3>");
                gv_CustomerTypeWise.RenderControl(hw);
            }

            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();
        }
    }

    public override void VerifyRenderingInServerForm(Control control)
    {
        // Required for exporting GridView to Excel
    }

  
    public string GenerateParameter()
    {
        string pram = @" WHERE IV.InvoiceNo IN (SELECT InvoiceNo FROM dbo.tblInvoiceBatch
        LEFT JOIN dbo.tblInvoice ON tblInvoice.InvoiceId = tblInvoiceBatch.InvoiceId
        WHERE BatchNo = '" + batchno.Text + "')";

        ProformaOrInvoiceReturnBLL_daaw aIn = new ProformaOrInvoiceReturnBLL_daaw();
        DataTable dtInvo = aOrderInfoBll.GetInvoNOGetByBatchNo(pram);

        if (dtInvo.Rows.Count > 0)
        {
            for (int i = 0; i < dtInvo.Rows.Count; i++)
            {
                if (dtInvo.Rows[i]["InvoiceId"].ToString() != "")
                {
                    DataTable dtMarket = _dataLoad.Check_anomalyInvoiceDetails(dtInvo.Rows[i]["InvoiceId"].ToString(), dtInvo.Rows[i]["OrderId"].ToString().ToString());

                    if (dtMarket.Rows.Count > 0)
                    {
                        aIn.DeleteProforma(dtInvo.Rows[i]["InvoiceNo"].ToString().Trim());


                    }
                }

            }
        }
                return pram;
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        if (String.IsNullOrWhiteSpace(batchno.Text))
        {
            ShowFailedAlert("Please input Batch No!");
            return;
        }

        string pram = "";
        pram = GenerateParameter();

        Session["paydetailId"] = "";
        Session["paydetailId"] = pram;


        string url = "../SInventory_RPTVIEW/ProformaReportPrintViewer.aspx";
        string fullURL = "var width=950,height=700;var Mleft=(screen.width-width)/2;var Mtop=(screen.height-height)/2;window.open('" + ResolveClientUrl(url) + "','_blank','height='+height+',width='+width+',status=yes,toolbar=no,addressbar=no,scrollbars=yes,menubar=no,location=no,resizable=yes,top='+Mtop+',left='+Mleft);";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void btnTopsheetAndPickingslip_Click(object sender, EventArgs e)
    {
        if (String.IsNullOrWhiteSpace(batchno.Text))
        {
            ShowFailedAlert("Please input Batch No!");
            return;
        }

        string url = "../SInventory_RPTVIEW/TopSheetAndPickingslipHtmlViewer_daaw.aspx?BatchNo=" + Server.UrlEncode(batchno.Text.Trim());
        string fullURL = "var width=950,height=700;var Mleft=(screen.width-width)/2;var Mtop=(screen.height-height)/2;window.open('" + ResolveClientUrl(url) + "','_blank','height='+height+',width='+width+',status=yes,toolbar=no,addressbar=no,scrollbars=yes,menubar=no,location=no,resizable=yes,top='+Mtop+',left='+Mleft);";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW_TOPSHEET", fullURL, true);
    }
    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private void ShowSuccessAlert(string message)
    {
        RegisterClientAlert("ShowSuccesalert", message, "Success");
    }

    private void ShowFailedAlert(string message)
    {
        RegisterClientAlert("faildalert", message, "Faild");
    }

    private void RegisterClientAlert(string functionName, string message, string type)
    {
        string safeMessage = HttpUtility.JavaScriptStringEncode(message);
        string safeType = HttpUtility.JavaScriptStringEncode(type);
        string script = String.Format(
            "if (typeof {0} === 'function') {{ {0}('{1}','{2}'); }} else {{ alert('{1}'); }}",
            functionName,
            safeMessage,
            safeType);

        ScriptManager.RegisterStartupScript(UpdatePanel2, UpdatePanel2.GetType(), "Popup" + Guid.NewGuid().ToString("N"), script, true);
    }

    private bool IsRouteWiseMode()
    {
        return invoiceCreationModeRadioButtonList.SelectedValue == SearchModeRouteWise;
    }

    private DropDownList GetSelectedDANameDropDown()
    {
        return IsRouteWiseMode() ? ddlSalesAssistantName : ddlDAName;
    }

    private string GetSelectedDANameId()
    {
        DropDownList selectedDANameDropDown = GetSelectedDANameDropDown();
        return selectedDANameDropDown == null ? String.Empty : selectedDANameDropDown.SelectedValue;
    }

    private string GetBatchPrefix()
    {
        if (IsRouteWiseMode())
        {
            return String.IsNullOrEmpty(ddlSalesAssistantName.SelectedValue)
                ? "RW"
                : "RW" + ddlSalesAssistantName.SelectedValue;
        }

        return rootDropDownList.SelectedValue;
    }

    private void ClearOrderGrid()
    {
        orderGridView.DataSource = null;
        orderGridView.DataBind();
        SelectedOrderIds = new List<string>();
        BindSelectedGrid();
    }

    private void ApplyInvoiceCreationMode()
    {
        bool routeWise = IsRouteWiseMode();

        routeDateRow.Visible = routeWise;
        salesAssistantRow.Visible = routeWise;
        replacementSalesAssistantRow.Visible = routeWise;
        routeRow.Visible = !routeWise;
        territoryRow.Visible = !routeWise;
        daNameRow.Visible = !routeWise;

        if (routeWise && String.IsNullOrWhiteSpace(routeDateTextBox.Text))
        {
            routeDateTextBox.Text = DateTime.Today.ToString("d MMMM, yyyy");
        }

        invoiceCreationModeRow.Visible = true;
    }

    private static bool TryParseDate(string value, out DateTime dateValue)
    {
        string[] formats = new string[]
        {
            "dd-MMM-yyyy",
            "d-MMM-yyyy",
            "dd MMM, yyyy",
            "d MMM, yyyy",
            "dd MMMM, yyyy",
            "d MMMM, yyyy",
            "dd MMM yyyy",
            "d MMM yyyy",
            "M/d/yyyy",
            "MM/dd/yyyy",
            "yyyy-MM-dd"
        };

        if (DateTime.TryParseExact(value, formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out dateValue))
        {
            return true;
        }

        return DateTime.TryParse(value, out dateValue);
    }

    private bool DataValidation()
    {
        List<string> selectedIds = SelectedOrderIds;
        if (selectedIds.Count == 0)
        {
            ShowMessageBox("Please Select at least one row !!!");
            return false;
        }

        string firstRouteId = null;

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            string orderId = orderGridView.DataKeys[i]["OrderId"].ToString();
            if (selectedIds.Contains(orderId))
            {
                HiddenField hfDistributionRouteId = ((HiddenField)orderGridView.Rows[i].FindControl("hfDistributionRouteId"));
                if (hfDistributionRouteId != null)
                {
                    if (firstRouteId == null)
                    {
                        firstRouteId = hfDistributionRouteId.Value;
                    }
                    else if (firstRouteId != hfDistributionRouteId.Value)
                    {
                        ShowMessageBox("Selected orders must have the same Distribution Route  to generate an invoice!");
                        return false;
                    }
                }

                // Bulk invoice generation runs off ViewState-held selections, so this is the
                // one place every selected order must pass the credit / approval gate before
                // invoiceButton_Click can turn any of them into an invoice.
                int gateOrderId;
                if (Int32.TryParse(orderId, out gateOrderId))
                {
                    InvoiceCreationGate gate = _paymentApprovalService.CanCreateInvoice(gateOrderId);
                    if (!gate.CanCreate)
                    {
                        ShowFailedAlert("Order " + orderId + ": " + gate.Reason);
                        return false;
                    }
                }

                HiddenField hfCustomerMasterId = ((HiddenField)orderGridView.Rows[i].FindControl("hfCustomerMasterId"));
                if (hfCustomerMasterId != null)
                {
                    DataTable dtCheckCustInv = _BonusCampaignNewDAL.checkTodaysAlreadyInviceGenerate(hfCustomerMasterId.Value);

                    if (dtCheckCustInv.Rows.Count > 0)
                    {
                        ShowFailedAlert("This invoice has already been created for this customer today. Please wait until tomorrow to create a new invoice.");
                        return false;
                    }
                }
            }
        }

        DropDownList selectedDANameDropDown = GetSelectedDANameDropDown();
        if (selectedDANameDropDown == null || selectedDANameDropDown.SelectedValue == "")
        {
            ShowMessageBox(IsRouteWiseMode() ? "Please Select Sales Assistant Name!!" : "Please Select DA Name!!");
            if (selectedDANameDropDown != null)
            {
                selectedDANameDropDown.Focus();
            }
            return false;
        }

        return true;
    }
        protected void invoiceButton_Click(object sender, EventArgs e)
    {
        if (DataValidation())
        {
            try
            {
                string batchn = "";
                string selectedDANameId = GetSelectedDANameId();
                batchn = (aOrderInfoBll.LoadInvoiceBatchId().Rows[0][0].ToString());
                batchn = GetBatchPrefix() + "-" + batchn;
                List<string> selectedIds = SelectedOrderIds;

                int? replacementSaId = null;
                if (IsRouteWiseMode())
                {
                    int parsedReplacementSaId;
                    if (Int32.TryParse(ddlReplacementSalesAssistant.SelectedValue, out parsedReplacementSaId))
                    {
                        replacementSaId = parsedReplacementSaId;
                    }
                }

                bool anySucceeded = false;
                bool anyFailed = false;

                for (int i = 0; i < orderGridView.Rows.Count; i++)
                {
                    string orderIdStr = orderGridView.DataKeys[i]["OrderId"].ToString();
                    if (selectedIds.Contains(orderIdStr))
                    {
                        Int32 orderId = Convert.ToInt32(orderIdStr);
                        bool invoiceCreated = aOrderInfoBll.GenerateInvoiceByOrderId(orderId, Convert.ToInt32(Session["UserId"].ToString()), batchn, selectedDANameId, replacementSaId);

                        if (invoiceCreated)
                        {
                            anySucceeded = true;

                            ProformaOrInvoiceReturnBLL_daaw aIn = new ProformaOrInvoiceReturnBLL_daaw();
                            DataTable dtInvo = aOrderInfoBll.GetInvoNOGetByInvoID(orderId.ToString());

                            if (dtInvo.Rows.Count > 0 && dtInvo.Rows[0]["InvoiceId"].ToString() != "")
                            {
                                DataTable dtMarket = _dataLoad.Check_anomalyInvoiceDetails(dtInvo.Rows[0]["InvoiceId"].ToString(), orderId.ToString());
                                if (dtMarket.Rows.Count > 0)
                                {
                                    aIn.DeleteProforma(dtInvo.Rows[0]["InvoiceNo"].ToString().Trim());
                                }
                            }
                        }
                        else
                        {
                            anyFailed = true;
                        }
                    }
                    batchno.Text = batchn.ToString();
                }

                SelectedOrderIds = new List<string>();
                BindSelectedGrid();

                if (!IsRouteWiseMode() && Session["MarketId"] != null)
                {
                    marketDropDownList.SelectedValue = Session["MarketId"].ToString();
                    GridView();
                }
                else if (IsRouteWiseMode())
                {
                    GridView();
                }

                if (anySucceeded && !anyFailed)
                {
                    ShowSuccessAlert("Invoice Generated Successfully!");
                }
                else if (anySucceeded && anyFailed)
                {
                    ShowFailedAlert("Some order(s) could not be invoiced due to insufficient stock. The remaining order(s) were invoiced successfully.");
                }
                else
                {
                    ShowFailedAlert("Invoice could not be generated - insufficient stock for the selected order(s).");
                }
            }
            catch (Exception ex)
            {
                ShowFailedAlert("Error: " + ex.Message);
            }
        }
    }
    private bool ValiMethodAfterSave(string OrderId)
    {

        bool chk = true;
        OrderInfoBLL_daaw aOrderInfoBll = new OrderInfoBLL_daaw();
         
        int cont = 0;
        DataTable dtOrder = aOrderInfoBll.LoadDetalIdByMasCheck(OrderId);

        for (int i = 0; i < dtOrder.Rows.Count; i++)
        {
            int OrderDtlsId = 0;
            try
            {
                OrderDtlsId = Convert.ToInt32(dtOrder.Rows[i]["OrderDetailsId"].ToString());
            }
            catch
            {
                chk = false;
                break;
            }
            DataTable aTable = aOrderInfoBll.LoadInvoiceWithDetailIDCheck(OrderId, OrderDtlsId);

            if (aTable.Rows.Count == 0)
            {

                chk = false;
                break;

            }
        }

        //if (cont == 0)
        //{
        //    chk = false;
        //}

        return chk;
    }
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox)orderGridView.HeaderRow.FindControl("chkSelectAll");
        List<string> selectedIds = SelectedOrderIds;

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            GridViewRow row = orderGridView.Rows[i];
            CheckBox ChkBoxRows = (CheckBox)row.FindControl("chkSelect");
            Button gotoinvoiceButton = (Button)row.FindControl("gotoinvoiceButton");
            string orderId = orderGridView.DataKeys[i]["OrderId"].ToString();

            if (ChkBoxRows == null)
            {
                continue;
            }

            bool isDisabledByRule = gotoinvoiceButton != null && !gotoinvoiceButton.Enabled;

            if (ChkBoxHeader.Checked)
            {
                if (isDisabledByRule) continue;

                ChkBoxRows.Checked = true;
                ChkBoxRows.Enabled = false;
                if (!selectedIds.Contains(orderId))
                {
                    selectedIds.Add(orderId);
                }
            }
            else
            {
                ChkBoxRows.Checked = false;
                ChkBoxRows.Enabled = !isDisabledByRule;
                if (selectedIds.Contains(orderId))
                {
                    selectedIds.Remove(orderId);
                }
            }
        }

        SelectedOrderIds = selectedIds;
        BindSelectedGrid();
    }

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("InvoiceCreationByOrder.aspx");
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

    protected void rootDropDownList_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            Session["RouteId"] = rootDropDownList.SelectedValue;


            ddlDAName.Items.Clear();
            ddlTerritoryName.Items.Clear();
            try
            {
                RouteInformationDAL_daaw _DalRoute = new RouteInformationDAL_daaw();
                using (DataTable dt = _DalRoute.GeteRouteInformationDA_DDLId(rootDropDownList.SelectedValue))
                {
                    ddlDAName.DataSource = dt;
                    ddlDAName.DataValueField = "DANameId";
                    ddlDAName.DataTextField = "DAName";
                    ddlDAName.DataBind();
                    ddlDAName.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", String.Empty));
                    ddlDAName.SelectedIndex = 0;
                }
            }
            catch (Exception ex) { }
            try
            {
                RouteInformationDAL_daaw _DalRoute = new RouteInformationDAL_daaw();
                using (DataTable dt = _DalRoute.GetTerritoryByRouteInformationDA_DDLId(rootDropDownList.SelectedValue))
                {
                    ddlTerritoryName.DataSource = dt;
                    ddlTerritoryName.DataValueField = "TerritoryId";
                    ddlTerritoryName.DataTextField = "TerritoryName";
                    ddlTerritoryName.DataBind();
                    ddlTerritoryName.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", String.Empty));
                    ddlTerritoryName.SelectedIndex = 0;
                }
            }
            catch (Exception ex) { }
  
        }
        catch(Exception ex)
        {

        }


    }

    private void LoadSalesAssistantNameList()
    {
        BindSalesAssistantDropDown(ddlSalesAssistantName);

        replacementSalesAssistantRow.Visible = IsRouteWiseMode();
        BindReplacementSalesAssistantDropDown();
    }

    private void BindSalesAssistantDropDown(DropDownList ddl)
    {
        ddl.Items.Clear();

        int dcId;
        DateTime routeDate;
        if (!Int32.TryParse(salesCenterDropDownList.SelectedValue, out dcId) ||
            !TryParseDate(routeDateTextBox.Text.Trim(), out routeDate))
        {
            ddl.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
            return;
        }

        try
        {
            using (DataTable dt = aOrderInfoBll.GetInvoiceCreationRouteWiseSalesAssistantList(dcId, routeDate))
            {
                ddl.DataSource = dt;
                ddl.DataValueField = "DAId";
                ddl.DataTextField = "DAName";
                ddl.DataBind();
                ddl.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddl.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {
            ddl.Items.Clear();
            ddl.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
        }
    }

    private void BindReplacementSalesAssistantDropDown()
    {
        ddlReplacementSalesAssistant.Items.Clear();

        int dcId;
        if (!Int32.TryParse(salesCenterDropDownList.SelectedValue, out dcId))
        {
            ddlReplacementSalesAssistant.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
            return;
        }

        try
        {
            using (DataTable dt = aOrderInfoBll.GetInvoiceCreationRouteWiseSalesAssistantListForSick(dcId))
            {
                ddlReplacementSalesAssistant.DataSource = dt;
                ddlReplacementSalesAssistant.DataValueField = "DAId";
                ddlReplacementSalesAssistant.DataTextField = "DAName";
                ddlReplacementSalesAssistant.DataBind();
                ddlReplacementSalesAssistant.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlReplacementSalesAssistant.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {
            ddlReplacementSalesAssistant.Items.Clear();
            ddlReplacementSalesAssistant.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
        }
    }



    protected void invoiceCreationModeRadioButtonList_SelectedIndexChanged(object sender, EventArgs e)
    {
        ApplyInvoiceCreationMode();
        if (IsRouteWiseMode())
        {
            LoadSalesAssistantNameList();
        }
        else
        {
            int salesCenterId;
            if (Int32.TryParse(salesCenterDropDownList.SelectedValue, out salesCenterId))
            {
                aOrderInfoBll.LoadDisRouteforInvoice(rootDropDownList, salesCenterId);
            }
        }
        ClearOrderGrid();
    }

    protected void routeDateTextBox_TextChanged(object sender, EventArgs e)
    {
        ApplyInvoiceCreationMode();
        LoadSalesAssistantNameList();
        ClearOrderGrid();
    }

    public void DropDownlist()
    {
        try
        {
            if (String.IsNullOrEmpty(invoiceCreationModeRadioButtonList.SelectedValue))
            {
                invoiceCreationModeRadioButtonList.SelectedValue = SearchModeRouteWise;
            }

            if (String.IsNullOrEmpty(routeDateTextBox.Text))
            {
                routeDateTextBox.Text = DateTime.Today.ToString("d MMMM, yyyy");
            }

            aOrderInfoBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());
            aOrderInfoBll.LoadManufac(manufacDropDownList);
            // aOrderInfoBll.LoadDisRoute(rootDropDownList);
            if (manufacDropDownList.Items.Count > 1)
            {
                manufacDropDownList.SelectedIndex = 1;
            }
            if (salesCenterDropDownList.Items.Count > 1)
            {
                salesCenterDropDownList.SelectedIndex = 1;
            }

            ApplyInvoiceCreationMode();
            salesCenterDropDownList_SelectedIndexChanged(null, null);

            try
            {
                if (!IsRouteWiseMode() && Session["RouteId"] != null)
                {
                    rootDropDownList.SelectedValue= Session["RouteId"].ToString();

                    ddlDAName.Items.Clear();
                    ddlTerritoryName.Items.Clear();
                    try
                    {
                        RouteInformationDAL_daaw _DalRoute = new RouteInformationDAL_daaw();
                        using (DataTable dt = _DalRoute.GeteRouteInformationDA_DDLId(rootDropDownList.SelectedValue))
                        {
                            ddlDAName.DataSource = dt;
                            ddlDAName.DataValueField = "DANameId";
                            ddlDAName.DataTextField = "DAName";
                            ddlDAName.DataBind();
                            ddlDAName.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", String.Empty));
                            ddlDAName.SelectedIndex = 0;
                        }
                    }
                    catch (Exception ex) { }


                    try
                    {
                        RouteInformationDAL_daaw _DalRoute = new RouteInformationDAL_daaw();
                        using (DataTable dt = _DalRoute.GetTerritoryByRouteInformationDA_DDLId(rootDropDownList.SelectedValue))
                        {
                            ddlTerritoryName.DataSource = dt;
                            ddlTerritoryName.DataValueField = "TerritoryId";
                            ddlTerritoryName.DataTextField = "TerritoryName";
                            ddlTerritoryName.DataBind();
                            ddlTerritoryName.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", String.Empty));
                            ddlTerritoryName.SelectedIndex = 0;
                        }

                        if (Session["STerritoryId"] != null)
                        {
                            ddlTerritoryName.SelectedValue = Session["STerritoryId"].ToString();
                        }
                    }
                    catch (Exception ex) { }

                    GridView();
                }
            }
            catch (Exception ex)
            {

            }
        }
        catch(Exception ex)
        {

        }
    }
    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        ApplyInvoiceCreationMode();

        int salesCenterId;
        if (IsRouteWiseMode())
        {
            LoadSalesAssistantNameList();
        }
        else if (Int32.TryParse(salesCenterDropDownList.SelectedValue, out salesCenterId))
        {
            aOrderInfoBll.LoadDisRouteforInvoice(rootDropDownList, salesCenterId);
        }
        else
        {
            rootDropDownList.Items.Clear();
            rootDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
        }
        //// aOrderInfoBll.LoadMarketOrderWise(marketDropDownList,salesCenterDropDownList.SelectedValue);
        // using (DataTable dt = aOrderInfoBll.LoadDistributionRoute(salesCenterDropDownList.SelectedValue))
        // {

        //     try
        //     {
        //         rootDropDownList.SelectedValue = dt.Rows[0]["RouteInformationMasterId"].ToString();
        //     }
        //     catch(Exception ex)
        //     {

        //     }
        // }

        ClearOrderGrid();
    }
    protected void manufacDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        
    }
    protected void marketDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //DataTable aTable = new DataTable();
        //aTable = aOrderInfoBll.LoadOrderForOrderCreation(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
        //    marketDropDownList.SelectedValue);
        //orderGridView.DataSource = aTable;
        //orderGridView.DataBind();
    }
    protected void gotoinvoiceButton_Click(object sender, EventArgs e)
    {
        Button button = (Button)sender;
        GridViewRow currentRow = (GridViewRow)button.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        string selectedRouteId = rootDropDownList.SelectedValue;

        if (IsRouteWiseMode())
        {
            HiddenField hfDistributionRouteId = currentRow.FindControl("hfDistributionRouteId") as HiddenField;
            selectedRouteId = hfDistributionRouteId == null ? String.Empty : hfDistributionRouteId.Value;
        }

        //if (String.IsNullOrEmpty(selectedRouteId))
        //{
        //    ShowMessageBox("Please Select Route!!");
        //    rootDropDownList.Focus();
        //    return  ;
        //}


        //string OrdId = orderGridView.DataKeys[rowindex]["OrderId"].ToString();
        // DataTable dt = _BonusCampaignNewDAL.GetOrderDtlCamCheckIdCheckEzevent(OrdId);

        //if (dt.Rows.Count > 0)
        //{
        //    ShowMessageBox("Go To Invoice  not possible, For Flat Rate generate auto Invoice. It will be available after 2PM!!!");
        //}
        //else
        {
            string orderIdValue = orderGridView.DataKeys[rowindex]["OrderId"].ToString();

            // Re-check server-side. The row's button state is a hint for the user; this is
            // the control. A replayed or hand-built postback lands here too.
            int checkedOrderId;
            if (!Int32.TryParse(orderIdValue, out checkedOrderId))
            {
                ShowFailedAlert("Invalid order.");
                return;
            }

            InvoiceCreationGate gate = _paymentApprovalService.CanCreateInvoice(checkedOrderId);
            if (!gate.CanCreate)
            {
                ShowFailedAlert(gate.Reason);
                return;
            }

            Session["OrderId"] = orderIdValue;
            Session["RootNameId"] = selectedRouteId;
            Response.Redirect("InvoiceCreationForCustomerByOrder.aspx");
        }



    }

    /// <summary>
    /// "Go for Approval" - raises the AM -> DZSM -> NSM payment approval request for a
    /// credit-blocked order. Every rule (order really is blocked, no duplicate live
    /// request, approver chain complete) is enforced by sp_OrderPaymentApproval_Request.
    /// </summary>
    protected void btnGoForApproval_Click(object sender, EventArgs e)
    {
        Button button = (Button)sender;
        GridViewRow currentRow = (GridViewRow)button.Parent.Parent;

        int orderId;
        if (!Int32.TryParse(orderGridView.DataKeys[currentRow.RowIndex]["OrderId"].ToString(), out orderId))
        {
            ShowFailedAlert("Invalid order.");
            return;
        }

        int userId;
        if (Session["UserId"] == null || !Int32.TryParse(Session["UserId"].ToString(), out userId))
        {
            Response.Redirect("../Login.aspx");
            return;
        }

        int newApprovalId;
        string result = _paymentApprovalService.Request(orderId, userId, null, out newApprovalId);

        if (result == OrderPaymentApprovalService.Success)
        {
            ShowSuccessAlert("Sent for approval. Pending AM Approval.");
            GridView();
        }
        else
        {
            ShowFailedAlert(result);
        }
    }
    protected void GeneratetoinvoiceButton_Click(object sender, EventArgs e)
    {
        //Button button = (Button)sender;
        //GridViewRow currentRow = (GridViewRow)button.Parent.Parent;
        //int rowindex = 0;
        //rowindex = currentRow.RowIndex;

        //Session["OrderId"] = orderGridView.DataKeys[rowindex]["OrderId"].ToString();
        //Response.Redirect("InvoiceCreationForCustomerByOrder.aspx");

    }

    public void SessionChoose()
    {
        try
        {
            DataTable aTable = new DataTable();
            if (Session["MarketId"] != null)
            {
                //aTable = aOrderInfoBll.LoadOrderForOrderCreation(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
                //Session["MarketId"].ToString());
                //if (aTable.Rows.Count > 0)
                //{
                //    marketDropDownList.SelectedValue = Session["MarketId"].ToString();
                //}
                //else
                //{
                //    marketDropDownList.SelectedIndex = 0;
                //}
            }
        }
        catch(Exception ex)
        {

        }
        
    }

    private static string GetDataRowValue(DataRow row, string columnName)
    {
        if (row == null || !row.Table.Columns.Contains(columnName) || row[columnName] == DBNull.Value)
        {
            return String.Empty;
        }

        return row[columnName].ToString();
    }

    protected string GetEvalString(object dataItem, string fieldName)
    {
        try
        {
            object value = DataBinder.Eval(dataItem, fieldName);
            return value == null || value == DBNull.Value ? String.Empty : value.ToString();
        }
        catch
        {
            return String.Empty;
        }
    }

    private DataTable LoadRouteWiseOrderList(int salesCenterId, DateTime routeDate, int daId)
    {
        DataTable resultTable = null;
        HashSet<string> loadedOrderIds = new HashSet<string>();

        using (DataTable routeTerritoryTable = aOrderInfoBll.GetInvoiceCreationRouteWiseRouteTerritoryList(salesCenterId, routeDate, daId))
        {
            foreach (DataRow routeTerritoryRow in routeTerritoryTable.Rows)
            {
                string routeId = GetDataRowValue(routeTerritoryRow, "RouteInformationMasterId");
                string territoryId = GetDataRowValue(routeTerritoryRow, "TerritoryId");

                if (String.IsNullOrEmpty(routeId) || String.IsNullOrEmpty(territoryId))
                {
                    continue;
                }

                using (DataTable routeOrders = aOrderInfoBll.LoadOrderForOrderCreation(
                    salesCenterId.ToString(),
                    routeId,
                    marketDropDownList.SelectedValue,
                    territoryId))
                {
                    if (!routeOrders.Columns.Contains("DistributionRouteId"))
                    {
                        routeOrders.Columns.Add("DistributionRouteId", typeof(string));
                    }

                    if (resultTable == null)
                    {
                        resultTable = routeOrders.Clone();
                    }
                    else if (!resultTable.Columns.Contains("DistributionRouteId"))
                    {
                        resultTable.Columns.Add("DistributionRouteId", typeof(string));
                    }

                    foreach (DataRow orderRow in routeOrders.Rows)
                    {
                        if (String.IsNullOrEmpty(GetDataRowValue(orderRow, "DistributionRouteId")))
                        {
                            int routeIdValue;
                            orderRow["DistributionRouteId"] = Int32.TryParse(routeId, out routeIdValue)
                                && routeOrders.Columns["DistributionRouteId"].DataType == typeof(int)
                                    ? (object)routeIdValue
                                    : routeId;
                        }

                        string orderId = GetDataRowValue(orderRow, "OrderId");
                        if (String.IsNullOrEmpty(orderId) || loadedOrderIds.Add(orderId))
                        {
                            resultTable.ImportRow(orderRow);
                        }
                    }
                }
            }
        }

        return resultTable ?? new DataTable();
    }

    private void BindOrderGrid(DataTable aTable)
    {
        Session["MainTable"] = aTable;
        SelectedOrderIds = new List<string>();

        orderGridView.DataSource = aTable;
        orderGridView.DataBind();

        try
        {
            if (aTable == null || !aTable.Columns.Contains("GrossValue") || orderGridView.FooterRow == null)
            {
                BindSelectedGrid();
                return;
            }

            decimal total2 = 0;
            foreach (DataRow row in aTable.Rows)
            {
                decimal grossValue;
                if (Decimal.TryParse(row["GrossValue"].ToString(), out grossValue))
                {
                    total2 += grossValue;
                }
            }

            // orderGridView.FooterRow.Cells[7].Text = "<b>Total</b>";
            // orderGridView.FooterRow.Cells[8].Text = "<b>" + total2.ToString("N2") + "</b>";
            // orderGridView.FooterRow.Cells[9].HorizontalAlign = HorizontalAlign.Right;
        }
        catch (Exception)
        {
            // Handle footer summary only.
        }
        BindSelectedGrid();
    }

    public void GridView()
    {
        ClearOrderGrid();
        try
        {
            ApplyInvoiceCreationMode();

            // Validation checks
            int salesCenterId;
            if (!Int32.TryParse(salesCenterDropDownList.SelectedValue, out salesCenterId))
            { 
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please input Sales Center!" + "','Faild');", true);

                salesCenterDropDownList.Focus();
                return;
            }

            if (IsRouteWiseMode())
            {
                DateTime routeDate;
                if (!TryParseDate(routeDateTextBox.Text.Trim(), out routeDate))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please input Route Date!" + "','Faild');", true);
                    routeDateTextBox.Focus();
                    return;
                }
                int SalesAssistantId;
                if (!Int32.TryParse(ddlSalesAssistantName.SelectedValue, out SalesAssistantId))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please Sales Assistant Name!" + "','Faild');", true);

                    rootDropDownList.Focus();
                    return;
                }

                using (DataTable routeWiseTable = aOrderInfoBll.LoadOrderListForOrderRouteDayWise(salesCenterId, routeDate, SalesAssistantId))
                {
                    BindOrderGrid(routeWiseTable);
                }

                Session["RouteDate"] = routeDate.ToString("dd-MMM-yyyy");
                Session["RouteWiseSalesAssistantId"] = ddlSalesAssistantName.SelectedValue;
                return;
            }

            if (string.IsNullOrEmpty(rootDropDownList.SelectedValue))
            { 

                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please input Route!" + "','Faild');", true);
                rootDropDownList.Focus();
                return;
            }

            

            if (string.IsNullOrEmpty(ddlTerritoryName.SelectedValue))
            {

                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please input Territory!" + "','Faild');", true); 
                ddlTerritoryName.Focus();
                return;
            }

            // Load data
            DataTable aTable = aOrderInfoBll.LoadOrderForOrderCreation(
                salesCenterDropDownList.SelectedValue,
                rootDropDownList.SelectedValue,
                marketDropDownList.SelectedValue,
                ddlTerritoryName.SelectedValue
            );

            if (aTable != null && !aTable.Columns.Contains("DistributionRoute_Ord"))
            {
                aTable.Columns.Add("DistributionRoute_Ord", typeof(string));
            }

            BindOrderGrid(aTable);

            Session["MarketId"] = rootDropDownList.SelectedValue;
            Session["STerritoryId"] = ddlTerritoryName.SelectedValue;
        }
        catch (Exception)
        {
            // Handle outer exception if needed
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        GridView();
    }
}
