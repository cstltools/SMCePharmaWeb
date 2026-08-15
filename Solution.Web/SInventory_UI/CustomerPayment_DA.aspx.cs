using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.DataLayer;
using System;
using System.Activities.Expressions;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

public partial class SInventory_UI_CustomerPayment_DA : System.Web.UI.Page
{
    private const string SearchSalesCenterSessionKey = "CustomerPayment.SearchSalesCenter";
    private const string SearchRouteSessionKey = "CustomerPayment.SearchRoute";
    private const string SearchTerritorySessionKey = "CustomerPayment.SearchTerritory";
    private const string SearchDaNameSessionKey = "CustomerPayment.SearchDAName";

    private List<string> SelectedAppLogIds
    {
        get
        {
            if (ViewState["SelectedAppLogIds"] == null)
            {
                ViewState["SelectedAppLogIds"] = new List<string>();
            }
            return (List<string>)ViewState["SelectedAppLogIds"];
        }
        set
        {
            ViewState["SelectedAppLogIds"] = value;
        }
    }

    private void BindSelectedGrid()
    {
        DataTable mainTable = Session["MainTable"] as DataTable;
        EnsureReferenceNoColumn(mainTable);
        if (mainTable == null || SelectedAppLogIds.Count == 0)
        {
            selectedGridView.DataSource = null;
            selectedGridView.DataBind();
            selectedGridContainer.Visible = false;
            
            SyncMainGridCheckboxes();
            CalculateTotal();
            return;
        }

        var selectedRows = mainTable.AsEnumerable()
            .Where(row => SelectedAppLogIds.Contains(row["PaymentCollectionAppLogId"].ToString()));

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
        CalculateTotal();
    }

    private void EnsureReferenceNoColumn(DataTable table)
    {
        if (table != null && !table.Columns.Contains("ReferenceNo"))
        {
            table.Columns.Add("ReferenceNo", typeof(string));
        }
    }

    private void UpdateReferenceNoFromGrid()
    {
        DataTable mainTable = Session["MainTable"] as DataTable;
        EnsureReferenceNoColumn(mainTable);
        if (mainTable == null)
        {
            return;
        }

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            HiddenField hfPaymentCollectionAppLogId = (HiddenField)orderGridView.Rows[i].FindControl("hfPaymentCollectionAppLogId");
            TextBox referenceNoTextBox = (TextBox)orderGridView.Rows[i].FindControl("referenceNoTextBox");
            if (hfPaymentCollectionAppLogId == null || referenceNoTextBox == null)
            {
                continue;
            }

            DataRow row = mainTable.AsEnumerable()
                .FirstOrDefault(dataRow => dataRow["PaymentCollectionAppLogId"].ToString() == hfPaymentCollectionAppLogId.Value);
            if (row != null)
            {
                row["ReferenceNo"] = referenceNoTextBox.Text.Trim();
            }
        }

        for (int i = 0; i < selectedGridView.Rows.Count; i++)
        {
            TextBox referenceNoTextBoxSelected = (TextBox)selectedGridView.Rows[i].FindControl("referenceNoTextBoxSelected");
            if (referenceNoTextBoxSelected == null)
            {
                continue;
            }

            if (selectedGridView.DataKeys[i] != null && selectedGridView.DataKeys[i]["PaymentCollectionAppLogId"] != null)
            {
                string appLogId = selectedGridView.DataKeys[i]["PaymentCollectionAppLogId"].ToString();
                DataRow row = mainTable.AsEnumerable()
                    .FirstOrDefault(dataRow => dataRow["PaymentCollectionAppLogId"].ToString() == appLogId);
                if (row != null)
                {
                    row["ReferenceNo"] = referenceNoTextBoxSelected.Text.Trim();
                }
            }
        }
    }

    private void SyncMainGridCheckboxes()
    {
        List<string> selectedIds = SelectedAppLogIds;
        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            GridViewRow row = orderGridView.Rows[i];
            HiddenField hfPaymentCollectionAppLogId = (HiddenField)row.FindControl("hfPaymentCollectionAppLogId");
            CheckBox chkSelect = (CheckBox)row.FindControl("chkSelect");

            if (hfPaymentCollectionAppLogId != null && chkSelect != null)
            {
                if (selectedIds.Contains(hfPaymentCollectionAppLogId.Value))
                {
                    chkSelect.Checked = true;
                    chkSelect.Enabled = false;
                }
                else
                {
                    chkSelect.Checked = false;
                    chkSelect.Enabled = true;
                }
            }
        }
    }

    protected void btnRemove_Click(object sender, EventArgs e)
    {
        UpdateReferenceNoFromGrid();
        LinkButton btn = (LinkButton)sender;
        string appLogId = btn.CommandArgument;
        List<string> selectedIds = SelectedAppLogIds;
        if (selectedIds.Contains(appLogId))
        {
            selectedIds.Remove(appLogId);
            SelectedAppLogIds = selectedIds;
        }
        BindSelectedGrid();
    }

    OrderInfoDAL_daaw aDal = new OrderInfoDAL_daaw();
    private CustPaymentBLL_daaw aCustPaymentBll = new CustPaymentBLL_daaw();
    OrderInfoBLL_daaw aOrderInfoBll = new OrderInfoBLL_daaw();
    private static SeedDataDAL_daaw _seedRepo = new SeedDataDAL_daaw();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownList();
            RestoreSearchFiltersAndAutoSearch();
        }
    }

    public void Clear()
    {
        //orderGridView.DataSource = null;
        //orderGridView.DataBind();

        //salesCenterDropDownList.SelectedIndex = 0;
        marketDropDownList.SelectedValue = "";
        //customerDropDownList.SelectedIndex = 0;
      //  paymentDtTextBox.Text = string.Empty;
 
        refDtTextBox.Text = string.Empty;
        refNameTextBox.Text = string.Empty;
        payTypeDDL.SelectedIndex = 1;
        //customerTextBox.Text = string.Empty;


        

    }

    public void DropDownList()
    {
        try
        {
            aCustPaymentBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());

           
                salesCenterDropDownList.SelectedIndex = 1;
             
            aCustPaymentBll.PaymentTypeLoadBLL(payTypeDDL);

            payTypeDDL.SelectedIndex = 1;
            salesCenterDropDownList_SelectedIndexChanged(null, null);

        }
        catch(Exception ex)
        {

        }

    }

    private void RestoreSearchFiltersAndAutoSearch()
    {
        string salesCenterId = GetStoredSearchFilterValue(SearchSalesCenterSessionKey);
        if (!TrySetSelectedValue(salesCenterDropDownList, salesCenterId))
        {
            return;
        }

        salesCenterDropDownList_SelectedIndexChanged(null, null);

        string routeId = GetStoredSearchFilterValue(SearchRouteSessionKey);
        if (!string.IsNullOrWhiteSpace(routeId) && !TrySetSelectedValue(rootDropDownList, routeId))
        {
            ClearStoredSearchFilters();
            return;
        }

        if (!string.IsNullOrWhiteSpace(routeId))
        {
            rootDropDownList_SelectedIndexChanged(null, null);
        }

        string territoryId = GetStoredSearchFilterValue(SearchTerritorySessionKey);
        if (!string.IsNullOrWhiteSpace(territoryId) && !TrySetSelectedValue(ddlTerritoryName, territoryId))
        {
            ClearStoredSearchFilters();
            return;
        }

        string daNameId = GetStoredSearchFilterValue(SearchDaNameSessionKey);
        TrySetSelectedValue(ddlDAName, daNameId);

        LoadGridView();
    }

    private static bool TrySetSelectedValue(DropDownList dropDownList, string value)
    {
        if (dropDownList == null || string.IsNullOrWhiteSpace(value))
        {
            return false;
        }

        ListItem item = dropDownList.Items.FindByValue(value.Trim());
        if (item == null)
        {
            return false;
        }

        dropDownList.ClearSelection();
        item.Selected = true;
        return true;
    }

    private string GetStoredSearchFilterValue(string sessionKey)
    {
        object sessionValue = Session[sessionKey];
        return sessionValue == null ? string.Empty : sessionValue.ToString().Trim();
    }

    private void StoreSearchFilters()
    {
        Session[SearchSalesCenterSessionKey] = salesCenterDropDownList.SelectedValue;
        Session[SearchRouteSessionKey] = rootDropDownList.SelectedValue;
        Session[SearchTerritorySessionKey] = ddlTerritoryName.SelectedValue;
        Session[SearchDaNameSessionKey] = ddlDAName.SelectedValue;
    }

    private void ClearStoredSearchFilters()
    {
        Session.Remove(SearchSalesCenterSessionKey);
        Session.Remove(SearchRouteSessionKey);
        Session.Remove(SearchTerritorySessionKey);
        Session.Remove(SearchDaNameSessionKey);
    }

    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            ddlDAName.Items.Clear();
            try
            {
                using (DataTable dt = _seedRepo.GetRouteInfoforCustPayment(Convert.ToInt32(salesCenterDropDownList.SelectedValue)))
                {
                    rootDropDownList.DataSource = dt;

                    rootDropDownList.DataValueField = "DistributionRouteId";
                    rootDropDownList.DataTextField = "DistributionRouteName";
                    rootDropDownList.DataBind();
                    rootDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    rootDropDownList.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }

            // aOrderInfoBll.LoadDeliveryDisRouteforInvoice(rootDropDownList, Convert.ToInt32(salesCenterDropDownList.SelectedValue));
        }
        catch (Exception ex)
        {

        }
    }
 
    

    protected void customerDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
      
    }

    protected void marketDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        aCustPaymentBll.LoadCustomerMaster(customerDropDownList, marketDropDownList.SelectedValue);
        orderGridView.DataSource = null;
        orderGridView.DataBind();
        SelectedAppLogIds = new List<string>();
        BindSelectedGrid();
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        UpdateReferenceNoFromGrid();
        CheckBox ChkBoxHeader = (CheckBox) orderGridView.HeaderRow.FindControl("chkSelectAll");
        List<string> selectedIds = SelectedAppLogIds;

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            GridViewRow row = orderGridView.Rows[i];
            CheckBox ChkBoxRows = (CheckBox) row.FindControl("chkSelect");
            HiddenField hfPaymentCollectionAppLogId = (HiddenField) row.FindControl("hfPaymentCollectionAppLogId");

            if (ChkBoxRows == null || hfPaymentCollectionAppLogId == null)
            {
                continue;
            }

            if (ChkBoxHeader.Checked)
            {
                ChkBoxRows.Checked = true;
                ChkBoxRows.Enabled = false;
                if (!selectedIds.Contains(hfPaymentCollectionAppLogId.Value))
                {
                    selectedIds.Add(hfPaymentCollectionAppLogId.Value);
                }
            }
            else
            {
                ChkBoxRows.Checked = false;
                ChkBoxRows.Enabled = true;
                if (selectedIds.Contains(hfPaymentCollectionAppLogId.Value))
                {
                    selectedIds.Remove(hfPaymentCollectionAppLogId.Value);
                }
            }
        }

        SelectedAppLogIds = selectedIds;
        BindSelectedGrid();
    }

    public bool Validation()
    {
        List<string> selectedIds = SelectedAppLogIds;
        if (selectedIds.Count == 0)
        {
            showMessageBox("Please Select Invoice from List!!");
            return false;
        }

        DataTable mainTable = Session["MainTable"] as DataTable;
        if (mainTable != null)
        {
            foreach (string id in selectedIds)
            {
                DataRow row = mainTable.AsEnumerable().FirstOrDefault(r => r["PaymentCollectionAppLogId"].ToString() == id);
                if (row != null && row.Table.Columns.Contains("BankName"))
                {
                    string bankName = row["BankName"] != DBNull.Value ? row["BankName"].ToString() : "";
                    if (bankName.Trim().Equals("Cash", StringComparison.OrdinalIgnoreCase))
                    {
                        showMessageBox("Cash payments cannot be approved!");
                        return false;
                    }
                }
            }
        }

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            HiddenField hfPaymentCollectionAppLogId = (HiddenField)orderGridView.Rows[i].FindControl("hfPaymentCollectionAppLogId");
            if (hfPaymentCollectionAppLogId != null && selectedIds.Contains(hfPaymentCollectionAppLogId.Value))
            {
                Label payAmountLabel = (Label)orderGridView.Rows[i].FindControl("payAmountLabel");
                if (payAmountLabel == null || string.IsNullOrEmpty(payAmountLabel.Text))
                {
                    showMessageBox("Please fill out Pay Amount !!");
                    return false;
                }
            }
        }

        if (payTypeDDL.SelectedValue == "")
        {
            showMessageBox("Please Select Payment Type!!");
            return false;
        }

        return true;
    }

    private int? GetNullableInt(string value)
    {
        int parsedValue;
        return int.TryParse(value, out parsedValue) ? (int?)parsedValue : null;
    }

    List<string> custPayIdList = new List<string>();

    protected void saveButton_Click(object sender, EventArgs e)
    {
        UpdateReferenceNoFromGrid();
        if (Validation())
        {
            CustomerMaster aCustomerMaster;
            bool save = false;
            List<string> selectedIds = SelectedAppLogIds;

            for (int i = 0; i < orderGridView.Rows.Count; i++)
            {
                HiddenField hfInvoiceId = (HiddenField) orderGridView.Rows[i].FindControl("hfInvoiceId");
                CheckBox chkAdjust = (CheckBox)orderGridView.Rows[i].FindControl("chkAdjust");
                Label payAmountLabel = (Label) orderGridView.Rows[i].FindControl("payAmountLabel");
                HiddenField hfCustomerMasterId = (HiddenField) orderGridView.Rows[i].FindControl("hfCustomerMasterId");

                HiddenField hfMarketId = (HiddenField)orderGridView.Rows[i].FindControl("hfMarketId");
                HiddenField hfTP_Pay = (HiddenField)orderGridView.Rows[i].FindControl("hfTP_Pay");
                HiddenField hfVat_Pay = (HiddenField)orderGridView.Rows[i].FindControl("hfVat_Pay");
                HiddenField hfBankId = (HiddenField)orderGridView.Rows[i].FindControl("hfBankId");
                DropDownList ddlCollectionBy = (DropDownList)orderGridView.Rows[i].FindControl("ddlCollectionBy");
                TextBox referenceNoTextBox = (TextBox)orderGridView.Rows[i].FindControl("referenceNoTextBox");

                HiddenField hfDistributionRouteId = (HiddenField)orderGridView.Rows[i].FindControl("hfDistributionRouteId");
                HiddenField hfPaymentCollectionAppLogId = (HiddenField)orderGridView.Rows[i].FindControl("hfPaymentCollectionAppLogId");
                decimal prevamount = 0;
                decimal TotalDelivery = 0;
                Label lbl_PrvAmount = (Label)orderGridView.Rows[i].FindControl("lblPaymentAmount");
                Label lblTotalDelivery = (Label)orderGridView.Rows[i].FindControl("lblTotalDelivery");
                if (lbl_PrvAmount.Text != "")
                {
                     prevamount = Convert.ToDecimal(lbl_PrvAmount.Text);
                }
                
                if (lblTotalDelivery.Text != "")
                {
                    TotalDelivery = Convert.ToDecimal(lblTotalDelivery.Text);
                }

                if (hfPaymentCollectionAppLogId != null && selectedIds.Contains(hfPaymentCollectionAppLogId.Value))
                {
                    List<CustPaymentDetail_daaw> aCustPaymentDetails = new List<CustPaymentDetail_daaw>();

                    CustPayment_daaw aCustPayment = new CustPayment_daaw();

                    aCustPayment.CustomerMasterId = Convert.ToInt32(hfCustomerMasterId.Value);
                    aCustPayment.MarketId = Convert.ToInt32(hfMarketId.Value);
                    aCustPayment.DistributionRouteId = Convert.ToInt32(hfDistributionRouteId.Value);
                    aCustPayment.ComUnitId = Convert.ToInt32(salesCenterDropDownList.SelectedValue);
                  
                    aCustPayment.PaymentDate = Convert.ToDateTime(Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy"));
                    aCustPayment.PaymentAmount = Convert.ToDecimal(payAmountLabel.Text);
                    aCustPayment.PayType = payTypeDDL.SelectedItem.Text;
                    aCustPayment.RefNo = refNameTextBox.Text;

                    if (refDtTextBox.Text != "")
                    {
                        aCustPayment.RefDate = Convert.ToDateTime(refDtTextBox.Text);
                    }

                    DataTable aTable = aDal.CheckInvoiceCustpayment(aCustPayment.PaymentAmount, Convert.ToInt32(orderGridView.DataKeys[i][0].ToString()));

                    if (aTable.Rows.Count == 0)
                    {
                        string ptStatus = "";
                        aCustPayment.CreateBy = Session["LoginName"].ToString();
                        aCustPayment.CreateDate = DateTime.Now;

                        decimal _TP_Pay=0;
                        decimal _Vat_Pay = 0;

                        if ((Convert.ToDecimal(payAmountLabel.Text) + prevamount) ==
                            TotalDelivery)
                        {
                            ptStatus = "Full";
                            decimal totalamount = 0;
                            totalamount = (Convert.ToDecimal(payAmountLabel.Text) + prevamount);
                            decimal PaymentAmount = Convert.ToDecimal(payAmountLabel.Text);
                        }
                        else
                        {
                            ptStatus = "Partial";
                            decimal totalamount = 0;
                            totalamount = (Convert.ToDecimal(payAmountLabel.Text) + prevamount);
                            decimal PaymentAmount = Convert.ToDecimal(payAmountLabel.Text);
                        }
                        int? finalDANameId = null;
                        if (orderGridView.DataKeys[i] != null && orderGridView.DataKeys[i]["DAId"] != null && !string.IsNullOrEmpty(orderGridView.DataKeys[i]["DAId"].ToString()))
                        {
                            finalDANameId = Convert.ToInt32(orderGridView.DataKeys[i]["DAId"]);
                        }

                        CustPaymentDetail_daaw aCustPaymentDetail = new CustPaymentDetail_daaw()
                        {
                            InvoiceId = Convert.ToInt32(orderGridView.DataKeys[i]["InvoiceId"].ToString()),
                            PaymentAmount = Convert.ToDecimal(payAmountLabel.Text),
                            TPAmount = _TP_Pay,
                            VATAmount = _Vat_Pay,
                            IsAdjust = chkAdjust.Checked ? Convert.ToBoolean(1) : Convert.ToBoolean(0),
                            DANameId = finalDANameId,
                            DAId = finalDANameId,
                            BankId = GetNullableInt(hfBankId == null ? string.Empty : hfBankId.Value),
                            FromDACollection = true,
                            PaymentStatus = ptStatus,
                            PaymentBy = Session["LoginName"].ToString(),
                            CollectionBy = "DIC",
                            ReferenceNo = referenceNoTextBox == null ? string.Empty : referenceNoTextBox.Text.Trim(),
                            PaymentCollectionAppLogId = GetNullableInt(hfPaymentCollectionAppLogId == null ? string.Empty : hfPaymentCollectionAppLogId.Value)
                        };

                        aCustPaymentDetails.Add(aCustPaymentDetail);
                        save = true;
                    }
                    else
                    {
                        save = false;
                    }

                    if (save)
                    { 
                        if (aCustPaymentBll.SaveCustPaymentWithRollback(aCustPayment, aCustPaymentDetails))
                        {
                            custPayIdList.Add(aCustPayment.CustPayId.ToString());
                        }
                    }
                }
            }

            if (save)
            {
                hfCustPayId.Value = string.Join(",", custPayIdList);
                Session["InvoiceIds"] = Parm();
                
                SelectedAppLogIds.Clear();
                BindSelectedGrid();

                ScriptManager.RegisterStartupScript(this, GetType(), "ShowModal", "$('#moneyModal').modal('show');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);
            }
        }
    }

    protected void rejectButton_Click(object sender, EventArgs e)
    {
        List<string> selectedIds = SelectedAppLogIds;
        if (selectedIds.Count == 0)
        {
            showMessageBox("Please Select Invoice from List!!");
            return;
        }

        DataTable mainTable = Session["MainTable"] as DataTable;
        if (mainTable == null)
        {
            return;
        }

        bool hasRejected = false;
        foreach (string appLogIdStr in selectedIds)
        {
            DataRow row = mainTable.AsEnumerable()
                .FirstOrDefault(dataRow => dataRow["PaymentCollectionAppLogId"].ToString() == appLogIdStr);
            
            int invoiceId = 0;
            if (row != null && mainTable.Columns.Contains("InvoiceId") && row["InvoiceId"] != DBNull.Value)
            {
                int.TryParse(row["InvoiceId"].ToString(), out invoiceId);
            }
            
            int appLogId;
            if (int.TryParse(appLogIdStr, out appLogId) && invoiceId > 0)
            {
                if (aCustPaymentBll.RejectInvoiceDAPaymentCollection(invoiceId, appLogId))
                {
                    hasRejected = true;
                }
            }
        }

        if (hasRejected)
        {
            SelectedAppLogIds.Clear();
            BindSelectedGrid();
            LoadGridView();
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "alert('Selected invoices have been rejected successfully.');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('Failed to reject selected invoices.', 'Faild');", true);
        }
    }

    protected void btnMoneyReceiptPrint_Click(object sender, EventArgs e)
    {
          MoneyRecitPrint(); // Print Receipt
                             // Refresh grid
          LoadGridView();
        //ScriptManager.RegisterStartupScript(this, GetType(), "RedirectPage", "setTimeout(function(){ window.location.href = window.location.href; }, 1000);", true);
        
        //ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('Operation successful!', 'Success');", true);
    }

    protected void btnSavePayment_Click(object sender, EventArgs e)
    {
        LoadGridView();    // Just save/refreh
       
    }

    public void CalculateTotal()
    {
        decimal prevamount = 0;
        List<string> selectedIds = SelectedAppLogIds;

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            HiddenField hfPaymentCollectionAppLogId = (HiddenField)orderGridView.Rows[i].FindControl("hfPaymentCollectionAppLogId");
            Label payAmountLabel = (Label)orderGridView.Rows[i].FindControl("payAmountLabel");

            if (hfPaymentCollectionAppLogId != null && selectedIds.Contains(hfPaymentCollectionAppLogId.Value))
            {
                if (payAmountLabel != null && payAmountLabel.Text.Trim() != "")
                {
                    if (payAmountLabel.Text != "0")
                    {
                        prevamount = prevamount + Convert.ToDecimal(payAmountLabel.Text.Trim());
                    }
                }
            }
        }

        lblCount.Text = "Total Pay Amount : " + prevamount.ToString(CultureInfo.InvariantCulture);
    }

    protected void chkAdjust_OnCheckedChanged(object sender, EventArgs e)
    {
        UpdateReferenceNoFromGrid();
        CheckBox isAdjust = (CheckBox)sender;
        GridViewRow currentRow = (GridViewRow)isAdjust.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        Label payAmountLabel = (Label)orderGridView.Rows[rowindex].FindControl("payAmountLabel");
        Label lblDue = (Label)orderGridView.Rows[rowindex].FindControl("lblDue");

        if (isAdjust.Checked)
        {
            payAmountLabel.Text = lblDue == null ? string.Empty : lblDue.Text.Trim();
        }
        else
        {
            payAmountLabel.Text = "";
        }
    }

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        ClearStoredSearchFilters();
        Response.Redirect("CustomerPayment.aspx");
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
       lblCount.Text = "Total Pay Amount: 0";
        LoadGridView();

    }


    private string Parm()
    {

        string param = "";

        if (salesCenterDropDownList.SelectedValue != "")
        {
            param = param + " AND INV.ComUnitId='" + salesCenterDropDownList.SelectedValue + "' ";
        }


        if (rootDropDownList.SelectedValue != "")
        {
            param = param + " and ord.DistributionRouteId='" + rootDropDownList.SelectedValue + "' ";
        }
        param = param + " and custPay.CustPayId in (" + hfCustPayId.Value + ") ";

        


            param = param + " AND CONVERT(date,custPay.custPaymentDate)  = '" + DateTime.Now.ToString("dd-MMM-yyyy") + "'";
        

        return param;
    }
    private string GenerateParameter()
    {
        StringBuilder param = new StringBuilder(" AND INV.InvoiceId IN (");
        bool found = false;
        List<string> selectedIds = SelectedAppLogIds;

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            var hfPaymentCollectionAppLogId = (HiddenField)orderGridView.Rows[i].FindControl("hfPaymentCollectionAppLogId");
            var hfInvoiceId = (HiddenField)orderGridView.Rows[i].FindControl("hfInvoiceId");

            if (hfPaymentCollectionAppLogId != null && selectedIds.Contains(hfPaymentCollectionAppLogId.Value))
            {
                if (salesCenterDropDownList.SelectedValue != "")
                {
                    if (found) param.Append(",");
                    param.Append(Convert.ToInt32(hfInvoiceId.Value));
                    found = true;
                }
            }
        }

        param.Append(")");

        if (!found) return Parm();

        return param.ToString() + Parm();
    }

    private void MoneyRecitPrint()
    {
        Session["InvoiceIds"] = "";
        string invoiceIds = GenerateParameter();
        if (string.IsNullOrEmpty(invoiceIds))
        {
            // Validation Message show code (optional)
            // ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('Please select at least one invoice.','Faild');", true);
            return;
        }

        Session["InvoiceIds"] = invoiceIds;
       // LoadGridView();

        // First hide the modal (if open)
       
        string url = "../SInventory_RPTVIEW/MoneyReceiptViewerForAfterPayment.aspx";
        string fullURL = "$('#moneyModal').modal('hide'); $('.modal-backdrop').remove(); $('body').removeClass('modal-open'); var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" +
                         url +
                         "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top='+Mtop+', left='+Mleft );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }


    private void LoadGridView()
    {
        orderGridView.DataSource = null;
        orderGridView.DataBind();
        if (string.IsNullOrEmpty(salesCenterDropDownList.SelectedValue))
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please input Sales Center!" + "','Faild');", true);

            salesCenterDropDownList.Focus();
            return;
        }
        //if (string.IsNullOrEmpty(ddlDAName.SelectedValue))
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please input Sales Asistance!" + "','Faild');", true);

        //    ddlDAName.Focus();v
        //    return;
        //}

        StoreSearchFilters();
        lblCount.Text = "Total Pay Amount: 0";
        DataTable aTable = aDal.LoadDAPaymentInvSP(GenerateParam());
        EnsureReferenceNoColumn(aTable);
        Session["MainTable"] = aTable;
        SelectedAppLogIds = new List<string>();

        orderGridView.DataSource = aTable;
        orderGridView.DataBind();
        CollectionByChange();
        BindSelectedGrid();
    }
    public string GenerateParam()
    {
        string paaram = "";

        if (!string.IsNullOrEmpty(ddlTerritoryName.SelectedValue))
        {
            paaram = "  and  ord.TerritoryId='" + ddlTerritoryName.SelectedValue + @"' ";
        }

        paaram = paaram + "  and   ord.ComUnitId='" + salesCenterDropDownList.SelectedValue + "' ";

        if (!string.IsNullOrEmpty(rootDropDownList.SelectedValue))
        {
            paaram = paaram + " AND ord.DistributionRouteId='" + rootDropDownList.SelectedValue + "' ";
        }

        if (!string.IsNullOrEmpty(ddlDAName.SelectedValue))
        {
            paaram = paaram + " AND PLOG.DaId='" + ddlDAName.SelectedValue + "' ";
        }

        //paaram = paaram + " and  isnull(INV.DA_PaymentCollection,'')   IN ('Pending', 'Canceled','Partial') ";

        return paaram;
    }
    protected void Unnamed_Click(object sender, EventArgs e)
    {

    }

    protected void chkSelect_CheckedChanged(object sender, EventArgs e)
    {
        UpdateReferenceNoFromGrid();
        CheckBox button = (CheckBox)sender;
        GridViewRow currentRow = (GridViewRow)button.Parent.Parent;
        int rowindex = currentRow.RowIndex;
        HiddenField hfPaymentCollectionAppLogId = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfPaymentCollectionAppLogId"));

        List<string> selectedIds = SelectedAppLogIds;

        if (button.Checked)
        {
            if (hfPaymentCollectionAppLogId != null && !selectedIds.Contains(hfPaymentCollectionAppLogId.Value))
            {
                selectedIds.Add(hfPaymentCollectionAppLogId.Value);
            }
        }
        else
        {
            if (hfPaymentCollectionAppLogId != null && selectedIds.Contains(hfPaymentCollectionAppLogId.Value))
            {
                selectedIds.Remove(hfPaymentCollectionAppLogId.Value);
            }
        }

        SelectedAppLogIds = selectedIds;
        BindSelectedGrid();
    }

    protected void rootDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlDAName.Items.Clear();
        try
        {
                  RouteInformationDAL_daaw _DalRoute = new RouteInformationDAL_daaw();
            using (DataTable dt = _DalRoute.GeteRouteInformationDA_DDLId(rootDropDownList.SelectedValue))
            {
                ddlDAName.DataSource = dt;
                ddlDAName.DataValueField = "DANameId";
                ddlDAName.DataTextField = "DAName";
                ddlDAName.DataBind();
                ddlDAName.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlDAName.SelectedIndex = 0;
            }
        }
        catch (Exception ex) { }


        try
        {
            RouteInformationDAL_daaw _DalRoute = new RouteInformationDAL_daaw();
            using (DataTable dt = _DalRoute.GetforPaymentTerritoryByRouteInformationDA_DDLId(rootDropDownList.SelectedValue))
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
        //try
        //{
        //          RouteInformationDAL_daaw _DalRoute = new RouteInformationDAL_daaw();
        //    using (DataTable dt = _DalRoute.GeteRouteInformationDA_DDLId(rootDropDownList.SelectedValue))
        //    {
        //        ddlDAName.DataSource = dt;
        //        ddlDAName.DataValueField = "DANameId";
        //        ddlDAName.DataTextField = "DAName";
        //        ddlDAName.DataBind();
        //        ddlDAName.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
        //        ddlDAName.SelectedIndex = 0;
        //    }
        //}
        //catch (Exception ex) { }
    }

    protected void ddlDAName_SelectedIndexChanged(object sender, EventArgs e)
    {
        CollectionByChange();
    }

    private void CollectionByChange()
    {
        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            DropDownList ddlCollectionBy = (DropDownList)orderGridView.Rows[i].FindControl("ddlCollectionBy");
            if (ddlCollectionBy == null)
            {
                continue;
            }

            if (ddlDAName.SelectedItem != null && ddlDAName.SelectedItem.Text == "MIO")
            {
                ddlCollectionBy.SelectedValue = "MIO";
            }
            else
            {
                ddlCollectionBy.SelectedValue = "DIC";
            }

        }
        }
    public override void VerifyRenderingInServerForm(Control control)
    {
        /* Confirms that an HtmlForm control is rendered for the specified ASP.NET server control at run time. */
    }

    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        if (orderGridView.Rows.Count > 0)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=DueInvoiceList_" + DateTime.Now.ToString("ddMMyyyy") + ".xls");
            Response.Charset = "";
            Response.ContentType = "application/vnd.ms-excel";
            using (StringWriter sw = new StringWriter())
            {
                HtmlTextWriter hw = new HtmlTextWriter(sw);
                
                // Hide checkbox column to prevent issues in excel
                orderGridView.Columns[0].Visible = false;

                orderGridView.RenderControl(hw);
                
                // Restore checkbox column
                orderGridView.Columns[0].Visible = true;

                string style = @"<style> .textmode { mso-number-format:\@; } </style>";
                Response.Write(style);
                Response.Output.Write(sw.ToString());
                Response.Flush();
                Response.End();
            }
        }
    }
}
