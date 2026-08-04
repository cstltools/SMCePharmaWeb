using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_LoadingSummary_DA : System.Web.UI.Page
{

    private static SeedDataDAL_daaw _seedRepo = new SeedDataDAL_daaw();
    OrderInfoBLL_daaw aOrderInfoBll=new OrderInfoBLL_daaw();
    OrderInfoDAL_daaw aDal =new OrderInfoDAL_daaw();
    InvoiceBLL_daaw aInvoiceBll = new InvoiceBLL_daaw();
    ProformaOrInvoiceReturnBLL_daaw aInvoiceReturnBll = new ProformaOrInvoiceReturnBLL_daaw();

    private const string LoadingSummarySalesCenterSessionKey = "LoadingSummarySalesCenterId";
    private const string LoadingSummaryInvoiceDateSessionKey = "LoadingSummaryInvoiceDate";
    private const string LoadingSummaryRouteSessionKey = "LoadingSummaryRouteId";
    private const string LoadingSummaryTerritorySessionKey = "LoadingSummaryTerritoryId";

    private List<string> SelectedInvoiceIds
    {
        get
        {
            if (ViewState["SelectedInvoiceIds"] == null)
            {
                ViewState["SelectedInvoiceIds"] = new List<string>();
            }
            return (List<string>)ViewState["SelectedInvoiceIds"];
        }
        set
        {
            ViewState["SelectedInvoiceIds"] = value;
        }
    }

    private void BindSelectedGrid()
    {
        DataTable mainTable = Session["MainTable"] as DataTable;
        if (mainTable == null || SelectedInvoiceIds.Count == 0)
        {
            selectedGridView.DataSource = null;
            selectedGridView.DataBind();
            selectedGridContainer.Visible = false;
            
            SyncMainGridCheckboxes();
            decimal total = NewMethod(0);
            lblCount.Text = "Total Net Amount: " + total.ToString();
            return;
        }

        var selectedRows = mainTable.AsEnumerable()
            .Where(row => SelectedInvoiceIds.Contains(row["InvoiceId"].ToString()));

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

        decimal totalAmt = NewMethod(0);
        lblCount.Text = "Total Net Amount: " + totalAmt.ToString();
    }

    private void SyncMainGridCheckboxes()
    {
        List<string> selectedIds = SelectedInvoiceIds;
        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            GridViewRow row = orderGridView.Rows[i];
            HiddenField hfInvoiceId = (HiddenField)row.FindControl("hfInvoiceId");
            CheckBox chkSelect = (CheckBox)row.FindControl("chkSelect");

            if (hfInvoiceId != null && chkSelect != null)
            {
                if (IsPartialGridRow(row))
                {
                    chkSelect.Checked = false;
                    chkSelect.Enabled = false;
                }
                else if (selectedIds.Contains(hfInvoiceId.Value))
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
        LinkButton btn = (LinkButton)sender;
        string invoiceId = btn.CommandArgument;
        List<string> selectedIds = SelectedInvoiceIds;
        if (selectedIds.Contains(invoiceId))
        {
            selectedIds.Remove(invoiceId);
            SelectedInvoiceIds = selectedIds;
        }
        BindSelectedGrid();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

             DateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            DropDownlist();
            if (RestoreSearchCriteriaFromSession())
            {
                lblCount.Text = "Total Net Amount: 0";
                GridView();
            }
            //for (int i = 0; i < orderGridView.Rows.Count; i++)
            //{

            //    aInvoiceBll.ReturnReason(
            //        ((DropDownList)orderGridView.Rows[i].FindControl("reasonReturnDropDownList")));
            //}
        }
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {
        ClearSearchCriteriaSession();
        Response.Redirect("LoadingSummary_DA.aspx");

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
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private string GetSessionText(string key)
    {
        return Session[key] == null ? string.Empty : Session[key].ToString();
    }

    private bool TrySelectDropDownValue(DropDownList dropDownList, string value)
    {
        if (dropDownList == null || string.IsNullOrEmpty(value))
        {
            return false;
        }

        ListItem item = dropDownList.Items.FindByValue(value);
        if (item == null)
        {
            return false;
        }

        dropDownList.ClearSelection();
        item.Selected = true;
        return true;
    }

    private bool IsSearchCriteriaSelected()
    {
        return !string.IsNullOrEmpty(salesCenterDropDownList.SelectedValue);
    }

    private void SaveSearchCriteriaToSession()
    {
        Session[LoadingSummarySalesCenterSessionKey] = salesCenterDropDownList.SelectedValue;
        Session[LoadingSummaryInvoiceDateSessionKey] = DateTextBox.Text;
        Session[LoadingSummaryRouteSessionKey] = rootDropDownList.SelectedValue;
        Session[LoadingSummaryTerritorySessionKey] = ddlTerritoryName.SelectedValue;
    }

    private void ClearSearchCriteriaSession()
    {
        Session.Remove(LoadingSummarySalesCenterSessionKey);
        Session.Remove(LoadingSummaryInvoiceDateSessionKey);
        Session.Remove(LoadingSummaryRouteSessionKey);
        Session.Remove(LoadingSummaryTerritorySessionKey);
    }

    private bool RestoreSearchCriteriaFromSession()
    {
        string salesCenterId = GetSessionText(LoadingSummarySalesCenterSessionKey);
        string invoiceDate = GetSessionText(LoadingSummaryInvoiceDateSessionKey);
        string routeId = GetSessionText(LoadingSummaryRouteSessionKey);
        string territoryId = GetSessionText(LoadingSummaryTerritorySessionKey);

        if (string.IsNullOrEmpty(salesCenterId)
            || string.IsNullOrEmpty(invoiceDate)
            || string.IsNullOrEmpty(routeId)
            || string.IsNullOrEmpty(territoryId))
        {
            return false;
        }

        if (!TrySelectDropDownValue(salesCenterDropDownList, salesCenterId))
        {
            return false;
        }

        DateTextBox.Text = invoiceDate;
        getRouteInfo();

        if (!TrySelectDropDownValue(rootDropDownList, routeId))
        {
            return false;
        }

        LoadTerritoryByRoute();
        return TrySelectDropDownValue(ddlTerritoryName, territoryId) && IsSearchCriteriaSelected();
    }

    private static string GetSalesConfirmStatusValue(object statusObject)
    {
        return statusObject == null || statusObject == DBNull.Value
            ? string.Empty
            : statusObject.ToString().Trim();
    }

    private static string NormalizeStatusKey(string statusText)
    {
        return new string((statusText ?? string.Empty)
            .Where(char.IsLetterOrDigit)
            .Select(char.ToLowerInvariant)
            .ToArray());
    }

    private static string MapSalesConfirmStatusToLoadingSummaryStatus(string salesConfirmStatus)
    {
        string normalizedStatus = NormalizeStatusKey(salesConfirmStatus);

        if (string.IsNullOrEmpty(normalizedStatus))
        {
            return string.Empty;
        }

        if (normalizedStatus.Contains("partial"))
        {
            return "Partial Dues";
        }

        if (normalizedStatus.Contains("cancel") || normalizedStatus.Contains("reject"))
        {
            return "Rejection";
        }

        if (normalizedStatus.Contains("full") || normalizedStatus.Contains("salesconfirm") || normalizedStatus.Contains("confirm"))
        {
            return "Full Dues";
        }

        return string.Empty;
    }

    protected string GetSalesConfirmStatusText(object statusObject)
    {
        string salesConfirmStatus = GetSalesConfirmStatusValue(statusObject);

        switch (MapSalesConfirmStatusToLoadingSummaryStatus(salesConfirmStatus))
        {
            case "Full Dues":
                return "Full Confirm";
            case "Rejection":
                return "Canceled";
            case "Partial Dues":
                return "Partial";
            default:
                return string.IsNullOrEmpty(salesConfirmStatus) ? "Pending" : salesConfirmStatus;
        }
    }

    protected string GetSalesConfirmStatusBadgeCss(object statusObject)
    {
        switch (MapSalesConfirmStatusToLoadingSummaryStatus(GetSalesConfirmStatusValue(statusObject)))
        {
            case "Full Dues":
                return "sales-confirm-badge status-full";
            case "Rejection":
                return "sales-confirm-badge status-canceled";
            case "Partial Dues":
                return "sales-confirm-badge status-partial";
            default:
                return "sales-confirm-badge status-default";
        }
    }

    protected bool IsPartialSalesConfirm(object statusObject)
    {
        return MapSalesConfirmStatusToLoadingSummaryStatus(GetSalesConfirmStatusValue(statusObject)) == "Partial Dues";
    }

    protected bool IsCancelledOrPartial(object statusObject)
    {
        string mappedStatus = MapSalesConfirmStatusToLoadingSummaryStatus(GetSalesConfirmStatusValue(statusObject));
        return mappedStatus == "Rejection" || mappedStatus == "Partial Dues";
    }

    private bool IsPartialGridRow(GridViewRow row)
    {
        if (row == null)
        {
            return false;
        }

        HiddenField hfSalesConfirmStatus = row.FindControl("hfSalesConfirmStatus") as HiddenField;
        return hfSalesConfirmStatus != null && IsPartialSalesConfirm(hfSalesConfirmStatus.Value);
    }

    private void ApplyPartialSelectionState(GridViewRow row)
    {
        if (row == null)
        {
            return;
        }

        CheckBox chkSelect = row.FindControl("chkSelect") as CheckBox;
        if (chkSelect == null)
        {
            return;
        }

        if (IsPartialGridRow(row))
        {
            chkSelect.Checked = false;
            chkSelect.Enabled = false;
        }
    }

    private void ApplyPartialSelectionState()
    {
        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            ApplyPartialSelectionState(orderGridView.Rows[i]);
        }
    }

    protected string GetSalesConfirmDateText(object dateObject)
    {
        if (dateObject == null || dateObject == DBNull.Value)
        {
            return string.Empty;
        }

        DateTime salesConfirmDate;
        if (DateTime.TryParse(dateObject.ToString(), out salesConfirmDate))
        {
            return salesConfirmDate.ToString("dd-MMM-yyyy");
        }

        return dateObject.ToString();
    }

    public void DropDownlist()
    {
        try
        {

            aOrderInfoBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());
            aOrderInfoBll.LoadManufac(manufacDropDownList);
            //aOrderInfoBll.LoadDisRoute(rootDropDownList);
            manufacDropDownList.SelectedIndex = 1;
            salesCenterDropDownList.SelectedIndex = 1;
            salesCenterDropDownList_SelectedIndexChanged(null, null);
        }
        catch(Exception ex)
        {
              //  Response.Redirect("../Login.aspx");
           
        }
       

    }
    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {

            getRouteInfo();

       // aOrderInfoBll.LoadDeliveryDisRouteforInvoice(rootDropDownList, Convert.ToInt32(salesCenterDropDownList.SelectedValue));
        }
        catch (Exception ex)
        {

        }
//aOrderInfoBll.LoadMarketByInvoice(marketDropDownList,salesCenterDropDownList.SelectedValue);

//using (DataTable dt = aOrderInfoBll.LoadDistributionRoute(salesCenterDropDownList.SelectedValue))
//{

//    try
//    {
//        rootDropDownList.SelectedValue = dt.Rows[0]["RouteInformationMasterId"].ToString();
//    }
//    catch (Exception ex)
//    {

//    }
//}
orderGridView.DataSource = null;
        orderGridView.DataBind();
    }



    public void getRouteInfo()
    {
        try
        {
            string dateText = string.IsNullOrEmpty(DateTextBox.Text) ? "" : DateTextBox.Text;
            aOrderInfoBll.LoadDeliveryDisRouteforInvoice(rootDropDownList, Convert.ToInt32(salesCenterDropDownList.SelectedValue), dateText);
        }
        catch
        {
            showMessageBox("Please select Filtering Criteria!");
        }
    }

    private void LoadTerritoryByRoute()
    {
        RouteInformationDAL_daaw _DalRoute = new RouteInformationDAL_daaw();
        string dateText = string.IsNullOrEmpty(DateTextBox.Text) ? "" : DateTextBox.Text;
        using (DataTable dt = _DalRoute.GetDelTerritoryByRouteInformationDA_DDLId(rootDropDownList.SelectedValue, dateText))
        {
            ddlTerritoryName.DataSource = dt;
            ddlTerritoryName.DataValueField = "TerritoryId";
            ddlTerritoryName.DataTextField = "TerritoryName";
            ddlTerritoryName.DataBind();
            ddlTerritoryName.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", String.Empty));
            ddlTerritoryName.SelectedIndex = 0;
        }
    }
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)orderGridView.HeaderRow.FindControl("chkSelectAll");
        List<string> selectedIds = SelectedInvoiceIds;

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            GridViewRow row = orderGridView.Rows[i];
            var chkBoxRows = (CheckBox)row.FindControl("chkSelect");
            HiddenField hfInvoiceId = (HiddenField)row.FindControl("hfInvoiceId");

            if (chkBoxRows == null || hfInvoiceId == null)
            {
                continue;
            }

            if (IsPartialGridRow(row))
            {
                chkBoxRows.Checked = false;
                chkBoxRows.Enabled = false;
                continue;
            }

            if (chkBoxHeader.Checked)
            {
                chkBoxRows.Checked = true;
                chkBoxRows.Enabled = false;
                if (!selectedIds.Contains(hfInvoiceId.Value))
                {
                    selectedIds.Add(hfInvoiceId.Value);
                }
            }
            else
            {
                chkBoxRows.Checked = false;
                chkBoxRows.Enabled = true;
                if (selectedIds.Contains(hfInvoiceId.Value))
                {
                    selectedIds.Remove(hfInvoiceId.Value);
                }
            }
        }
        
        SelectedInvoiceIds = selectedIds;
        BindSelectedGrid();
    }

    protected void manufacDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
       
    }
    protected void marketDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //DataTable aTable = new DataTable();
        //aTable = aOrderInfoBll.LoadOrderWithInvoice(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
        //    marketDropDownList.SelectedValue);
        //orderGridView.DataSource = aTable;
        //orderGridView.DataBind();
    }

    public void SavePayment(int i)
    {
        CustPaymentBLL_daaw aCustPaymentBll = new CustPaymentBLL_daaw();
        //if (Validation())
        {

            HiddenField hfInvoiceNo = ((HiddenField)orderGridView.Rows[i].Cells[1].FindControl("hfInvoiceNo"));
            Label lblTpGrandTotal = ((Label)orderGridView.Rows[i].Cells[1].FindControl("lblTpGrandTotal"));
            CustomerMaster aCustomerMaster;
            CustPayment_daaw aCustPayment = new CustPayment_daaw();
            string custId = orderGridView.DataKeys[i]["CustomerMasterId"].ToString();
            aCustPayment.CustomerMasterId = Convert.ToInt32(custId);
            aCustPayment.MarketId = Convert.ToInt32(orderGridView.DataKeys[i]["MarketId"].ToString());
            aCustPayment.ComUnitId = Convert.ToInt32(orderGridView.DataKeys[i]["ComUnitId"].ToString());
            aCustPayment.PaymentDate = Convert.ToDateTime(DateTime.Today);
            aCustPayment.PaymentAmount = Convert.ToDecimal(lblTpGrandTotal.Text);
            aCustPayment.PayType = "Cash";
            //aCustPayment.RefNo = "";

            aCustPayment.CreateBy = Session["LoginName"].ToString();
            aCustPayment.CreateDate = DateTime.Now;


            List<CustPaymentDetail_daaw> aCustPaymentDetails = new List<CustPaymentDetail_daaw>();
            //for (int i = 0; i < orderGridView.Rows.Count; i++)
            {
                decimal totalamount = 0;
                totalamount = Convert.ToDecimal(lblTpGrandTotal.Text);
                aCustPaymentBll.UpdateInvoicePaymentAmount(totalamount.ToString(), "Full",
                        orderGridView.DataKeys[i][3].ToString());
                CustPaymentDetail_daaw aCustPaymentDetail = new CustPaymentDetail_daaw()
                {
                    InvoiceId = Convert.ToInt32(orderGridView.DataKeys[i]["InvoiceId"].ToString()),
                    PaymentAmount = Convert.ToDecimal(lblTpGrandTotal.Text),


                };
                aCustPaymentDetails.Add(aCustPaymentDetail);
            }
            if (aCustPaymentBll.SaveCustPayment(aCustPayment, aCustPaymentDetails))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Delivery Invoice Created Successsfully!" + "','Success');", true);
             //   showMessageBox("Data Saved Successfully !!!!!");
                //Clear();
            }
        }

    }
    public void SavePaymentMultiple(int i)
    {
        CustPaymentBLL_daaw aCustPaymentBll = new CustPaymentBLL_daaw();
        //if (Validation())
        {

            HiddenField hfInvoiceNo = ((HiddenField)orderGridView.Rows[i].Cells[1].FindControl("hfInvoiceNo"));
            Label lblTpGrandTotal = ((Label)orderGridView.Rows[i].Cells[1].FindControl("lblTpGrandTotal"));
            CustomerMaster aCustomerMaster;
            CustPayment_daaw aCustPayment = new CustPayment_daaw();
            string custId = orderGridView.DataKeys[i]["CustomerMasterId"].ToString();
            aCustPayment.CustomerMasterId = Convert.ToInt32(custId);
            aCustPayment.MarketId = Convert.ToInt32(orderGridView.DataKeys[i]["MarketId"].ToString());
            aCustPayment.ComUnitId = Convert.ToInt32(orderGridView.DataKeys[i]["ComUnitId"].ToString());
            aCustPayment.PaymentDate = Convert.ToDateTime(DateTime.Today);
            aCustPayment.PaymentAmount = Convert.ToDecimal(lblTpGrandTotal.Text);
            aCustPayment.PayType = "Cash";
            //aCustPayment.RefNo = "";

            aCustPayment.CreateBy = Session["LoginName"].ToString();
            aCustPayment.CreateDate = DateTime.Now;


            List<CustPaymentDetail_daaw> aCustPaymentDetails = new List<CustPaymentDetail_daaw>();
            //for (int i = 0; i < orderGridView.Rows.Count; i++)
            {
                decimal totalamount = 0;
                totalamount = Convert.ToDecimal(lblTpGrandTotal.Text);
                aCustPaymentBll.UpdateInvoicePaymentAmount(totalamount.ToString(), "Full",
                        orderGridView.DataKeys[i][3].ToString());
                CustPaymentDetail_daaw aCustPaymentDetail = new CustPaymentDetail_daaw()
                {
                    InvoiceId = Convert.ToInt32(orderGridView.DataKeys[i]["InvoiceId"].ToString()),
                    PaymentAmount = Convert.ToDecimal(lblTpGrandTotal.Text),


                };
                aCustPaymentDetails.Add(aCustPaymentDetail);
            }
            if (aCustPaymentBll.SaveCustPayment(aCustPayment, aCustPaymentDetails))
            {
               
            }
        }

    }

    protected void gotoinvoiceButton_Click(object sender, EventArgs e)
    {
        LinkButton button = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)button.NamingContainer;
        int rowindex = currentRow.RowIndex;
        HiddenField hfSalesConfirmStatus = (HiddenField)orderGridView.Rows[rowindex].FindControl("hfSalesConfirmStatus");
        string loadingSummaryStatus = MapSalesConfirmStatusToLoadingSummaryStatus(hfSalesConfirmStatus == null ? string.Empty : hfSalesConfirmStatus.Value);

        if (loadingSummaryStatus == "Partial Dues")
        {
            string invoiceId = orderGridView.DataKeys[rowindex]["InvoiceId"].ToString();
            Session["InvoiceId"] = invoiceId;
            Session["SalesConfirmationAppLogId"] = GetAppLogIdForInvoice(invoiceId);
            Response.Redirect("dadtlsDelivaryInvoiceDetailsCreation_DA.aspx");    
            //Response.Redirect("DelivaryInvoiceCreationForCustomerByOrderAuto.aspx");
        }
       
        
        

    }
    protected void Button1_Click(object sender, EventArgs e)
    {

        if(IsSearchCriteriaSelected())
        {

            SaveSearchCriteriaToSession();
            lblCount.Text = "Total Net Amount: 0";
            GridView();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please Select all Filtering Criteria!" + "','Faild');", true);
        }

        
       

        //for (int i = 0; i < orderGridView.Rows.Count; i++)
        //{

        //    aInvoiceBll.ReturnReason(
        //        ((DropDownList)orderGridView.Rows[i].FindControl("reasonReturnDropDownList")));
        //}
    }

    public string GenerateParam()
    {
        string paaram = " and dbo.tblOrder.ComUnitId='" + salesCenterDropDownList.SelectedValue + "' ";

        if (!string.IsNullOrEmpty(rootDropDownList.SelectedValue))
        {
            paaram += " AND tblOrder.DistributionRouteId='" + rootDropDownList.SelectedValue + "' ";
        }
        
        if (!string.IsNullOrEmpty(ddlTerritoryName.SelectedValue))
        {
            paaram += " and dbo.tblOrder.TerritoryId='" + ddlTerritoryName.SelectedValue + "' ";
        }

        if (!string.IsNullOrEmpty(DateTextBox.Text))
        {
            paaram += " AND convert(Date,tblInvoice.InvoiceDate)=convert(Date,'" + DateTextBox.Text + "') ";
        }

        paaram += " AND (DelivaryInvoiceNo IS NULL) and isnull(tblInvoice.DA_SalesConfirmStatus,'') IN ('Pending', 'Canceled','Partial') order by tblInvoice.InvoiceNo Asc";
        
        return paaram;
    }


    protected void chk_Common_OnCheckedChanged(object sender, EventArgs e)
    {

        
         
        ddlStatus.Enabled = false;
        ISCommonDate();
    }

    private void ISCommonDate()
    {
        try
        {



            if (chk_Common.Checked)
            {


                ddlStatus.Enabled = true;
                
               


                  

                    
                        for (int j = 0; j < orderGridView.Rows.Count; j++)
                        {
                            //DataTable dt = (DataTable)ViewState["EmpSetup"];
                            DropDownList statusDropDownList = ((DropDownList)orderGridView.Rows[j].Cells[5].FindControl("statusDropDownList"));

                    LinkButton gotoinvoiceButton = ((LinkButton)orderGridView.Rows[j].FindControl("gotoinvoiceButton"));



                    statusDropDownList.SelectedValue = ddlStatus.SelectedValue;
                    gotoinvoiceButton.Visible = false;

                    if (statusDropDownList.SelectedValue == "Partial Dues")
                    {
                        gotoinvoiceButton.Visible = true;

                    }


                }
                    



                


              

            }
            else
            {
                for (int j = 0; j < orderGridView.Rows.Count; j++)
                {
                    DropDownList statusDropDownList = ((DropDownList)orderGridView.Rows[j].Cells[5].FindControl("statusDropDownList"));




                    statusDropDownList.SelectedIndex = 0;
                }
            }


        }
        catch (Exception)
        {



        }
    }



    public void GridView()
    {
        orderGridView.DataSource = null;
        orderGridView.DataBind();
        if (string.IsNullOrEmpty(salesCenterDropDownList.SelectedValue))
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please input Sales Center!" + "','Faild');", true);

            salesCenterDropDownList.Focus();
            return;
        }

        DataTable aTable = new DataTable();
        aTable = aDal.LoadSummaryList(GenerateParam());
        Session["MainTable"] = aTable;
        orderGridView.DataSource = aTable;
        orderGridView.DataBind();
        ApplyPartialSelectionState();

        SelectedInvoiceIds.Clear();
        BindSelectedGrid();

        Session["DelMarketId"] = marketDropDownList.SelectedValue;
    }

    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        orderGridView.PageIndex = e.NewPageIndex;
        this.GridView();
    }

    protected void btnReturnSummaryNote_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        string invoiceId = btn.CommandArgument;
        GridViewRow currentRow = (GridViewRow)btn.NamingContainer;
        HiddenField hfSalesConfirmStatus = (HiddenField)orderGridView.Rows[currentRow.RowIndex].FindControl("hfSalesConfirmStatus");
        string mappedStatus = MapSalesConfirmStatusToLoadingSummaryStatus(
            hfSalesConfirmStatus != null ? hfSalesConfirmStatus.Value : string.Empty);

        hfReturnInvoiceId.Value = invoiceId;
        hfReturnStatus.Value = mappedStatus;

        try
        {
            dadtlsOrderInfoBLL aOrderInfoBll = new dadtlsOrderInfoBLL();

            // Load invoice header info
            DataTable dtInvoice = aOrderInfoBll.LoadInvoice(invoiceId);
            if (dtInvoice.Rows.Count > 0)
            {
                DataRow hdr = dtInvoice.Rows[0];
                lblRtnCustomerName.Text = hdr["CustomerName"].ToString();
                lblRtnCustomerCode.Text = hdr["CustomerCode"].ToString();
                lblRtnAddress.Text = hdr.Table.Columns.Contains("Address") ? hdr["Address"].ToString() : "";
                lblRtnMarket.Text = hdr.Table.Columns.Contains("MarketName") ? hdr["MarketName"].ToString() : "";
                lblRtnInvoiceNo.Text = hdr["InvoiceNo"].ToString();
                lblRtnInvoiceDate.Text = hdr["InvoiceDate"] != DBNull.Value
                    ? Convert.ToDateTime(hdr["InvoiceDate"]).ToString("dd-MMM-yyyy") : "";
                lblRtnDaName.Text = hdr.Table.Columns.Contains("DA_SalesConfirmBy") ? hdr["DA_SalesConfirmBy"].ToString() : "";
                lblRtnConfirmDate.Text = hdr.Table.Columns.Contains("DA_SalesConfirmDate") && hdr["DA_SalesConfirmDate"] != DBNull.Value
                    ? Convert.ToDateTime(hdr["DA_SalesConfirmDate"]).ToString("dd-MMM-yyyy") : "";
            }

            DataTable returnData = new DataTable();
            returnData.Columns.Add("ProductCode");
            returnData.Columns.Add("ProductName");
            returnData.Columns.Add("TotalQty");
            returnData.Columns.Add("ReturnQty");
            returnData.Columns.Add("UnitPrice");
            returnData.Columns.Add("ReturnAmount");
            returnData.Columns.Add("Reason");

            if (mappedStatus == "Rejection")
            {
                // Canceled: all items are returned (TotalQty = ReturnQty)
                lblReturnNoteType.Text = "[ Canceled / Rejection ]";
                foreach (DataRow row in dtInvoice.Rows)
                {
                    decimal totalQty = row["TotalQty"] != DBNull.Value ? Convert.ToDecimal(row["TotalQty"]) : 0;
                    decimal unitPrice = row["UnitPrice"] != DBNull.Value ? Convert.ToDecimal(row["UnitPrice"]) : 0;
                    string reason = row.Table.Columns.Contains("ReturnReason") ? row["ReturnReason"].ToString() : "Canceled";
                    returnData.Rows.Add(
                        row["ProductCode"].ToString(),
                        row.Table.Columns.Contains("ProductName") ? row["ProductName"].ToString() : "",
                        totalQty.ToString("N0"),
                        totalQty.ToString("N0"),
                        unitPrice.ToString("N2"),
                        (totalQty * unitPrice).ToString("N2"),
                        reason
                    );
                }
            }
            else if (mappedStatus == "Partial Dues")
            {
                // Partial: ReturnQty = TotalQty - DeliveredQty from tblSalesConfirmation_appLogDetail
                lblReturnNoteType.Text = "[ Partial Return ]";
                DataTable dtAppLog = aOrderInfoBll.LoadSalesConfirmationAppLogDetail(invoiceId);

                // Build lookup: InvoiceDetailId -> DeliveredQty, DeliveryReason
                Dictionary<string, DataRow> appLogDict = new Dictionary<string, DataRow>();
                foreach (DataRow logRow in dtAppLog.Rows)
                {
                    string detailId = logRow["InvoiceDetailId"].ToString();
                    if (!string.IsNullOrEmpty(detailId))
                        appLogDict[detailId] = logRow;
                }

                foreach (DataRow row in dtInvoice.Rows)
                {
                    string detailId = row.Table.Columns.Contains("InvoiceDetailId") ? row["InvoiceDetailId"].ToString() : "";
                    decimal totalQty = row["TotalQty"] != DBNull.Value ? Convert.ToDecimal(row["TotalQty"]) : 0;
                    decimal deliveredQty = 0;
                    string reason = "";

                    DataRow logRow;
                    if (!string.IsNullOrEmpty(detailId) && appLogDict.TryGetValue(detailId, out logRow))
                    {
                        deliveredQty = logRow["DeliveredQty"] != DBNull.Value ? Convert.ToDecimal(logRow["DeliveredQty"]) : 0;
                        reason = logRow.Table.Columns.Contains("DeliveryReason") ? logRow["DeliveryReason"].ToString() : "";
                    }

                    decimal returnQty = totalQty - deliveredQty;
                    if (returnQty <= 0) continue;

                    decimal unitPrice = row["UnitPrice"] != DBNull.Value ? Convert.ToDecimal(row["UnitPrice"]) : 0;
                    returnData.Rows.Add(
                        row["ProductCode"].ToString(),
                        row.Table.Columns.Contains("ProductName") ? row["ProductName"].ToString() : "",
                        totalQty.ToString("N0"),
                        returnQty.ToString("N0"),
                        unitPrice.ToString("N2"),
                        (returnQty * unitPrice).ToString("N2"),
                        reason
                    );
                }
            }

            gvReturnSummary.DataSource = returnData;
            gvReturnSummary.DataBind();

            // Total Return Amount
            decimal totalReturn = returnData.AsEnumerable()
                .Sum(r => {
                    decimal v = 0;
                    decimal.TryParse(r["ReturnAmount"].ToString(), System.Globalization.NumberStyles.Any,
                        System.Globalization.CultureInfo.InvariantCulture, out v);
                    return v;
                });
            lblRtnTotalAmount.Text = totalReturn.ToString("N2");
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "returnNoteErr",
                "faildalert('Error loading return summary: " + ex.Message.Replace("'", "") + "','Error');", true);
            return;
        }

        ScriptManager.RegisterStartupScript(this, GetType(), "showReturnModal",
            "showReturnSummaryModal();", true);
    }
    public void SessionChoose()
    {
        DataTable aTable = new DataTable();
        if (Session["DelMarketId"] != null)
        {
            aTable = aOrderInfoBll.LoadOrderWithInvoice(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
            Session["DelMarketId"].ToString());
            if (aTable.Rows.Count > 0)
            {
                marketDropDownList.SelectedValue = Session["DelMarketId"].ToString();
            }
            else
            {
                marketDropDownList.SelectedIndex = 0;
            }
        }

    }

    protected void statusDropDownList_OnTextChanged(object sender, EventArgs e)
    {
        DropDownList DropDownList = (DropDownList)sender;
        GridViewRow currentRow = (GridViewRow)DropDownList.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        DropDownList statusDropDownList = ((DropDownList)orderGridView.Rows[rowindex].FindControl("statusDropDownList"));
        DropDownList reasonReturnDropDownList = ((DropDownList)orderGridView.Rows[rowindex].FindControl("reasonReturnDropDownList"));
        HiddenField hfIsAdjustInvoice = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfIsAdjustInvoice"));

        if (hfIsAdjustInvoice.Value == "True")
        {
            statusDropDownList.SelectedIndex = 0;
        }

        else
        {

            if (statusDropDownList.SelectedValue == "Reject")
            {
                reasonReturnDropDownList.Visible = true;

            }
            else
            {
                reasonReturnDropDownList.Visible = false;
            }
        }

       

    }

    protected void btnFinalSubmit_Click(object sender, EventArgs e)
    {
        if (DataValidation())
        {
            bool isAnyRowProcessed = false;
            bool isAnyRowSuccessful = false;
            bool hasSelectedPartialRow = false;

            List<string> selectedIds = SelectedInvoiceIds;

            for (int rowindex = 0; rowindex < orderGridView.Rows.Count; rowindex++)
            {
                HiddenField hfInvoiceId = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfInvoiceId"));
                HiddenField hfInvoiceNo = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfInvoiceNo"));
                HiddenField hfSalesConfirmStatus = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfSalesConfirmStatus"));
                
                if (hfInvoiceId != null && selectedIds.Contains(hfInvoiceId.Value))
                {
                    string loadingSummaryStatus = MapSalesConfirmStatusToLoadingSummaryStatus(hfSalesConfirmStatus == null ? string.Empty : hfSalesConfirmStatus.Value);

                    if (loadingSummaryStatus == "Partial Dues")
                    {
                        hasSelectedPartialRow = true;
                        continue;
                    }

                    if (loadingSummaryStatus == "Full Dues")
                    {
                        int status = aInvoiceBll.SaveFullInvoice(hfInvoiceNo.Value,
                            Session["LoginName"].ToString(), DateTime.Now.ToString("dd-MMM-yyyy"));
                        status = aInvoiceBll.UP_LoadingSummaryInvoice(hfInvoiceId.Value,
                            Session["LoginName"].ToString(), loadingSummaryStatus);
                        isAnyRowProcessed = true;
                        isAnyRowSuccessful = isAnyRowSuccessful || status == 1;

                        // Update DIC Approval Status in tblSalesConfirmation_appLog
                        string appLogId = GetAppLogIdForInvoice(hfInvoiceId.Value);
                        if (!string.IsNullOrEmpty(appLogId))
                            aInvoiceBll.UpdateDICApprovalStatus(appLogId, "Approved", Session["LoginName"].ToString());
                    }

                    if (loadingSummaryStatus == "Rejection")
                    {
                        int status = aInvoiceBll.UP_LoadingSummaryInvoice(hfInvoiceId.Value,
                            Session["LoginName"].ToString(), loadingSummaryStatus);
                        isAnyRowProcessed = true;
                        isAnyRowSuccessful = isAnyRowSuccessful || status == 1;

                        // Update DIC Approval Status in tblSalesConfirmation_appLog
                        string appLogId = GetAppLogIdForInvoice(hfInvoiceId.Value);
                        if (!string.IsNullOrEmpty(appLogId))
                            aInvoiceBll.UpdateDICApprovalStatus(appLogId, "Rejected", Session["LoginName"].ToString());
                    }
                }
            }

            if (isAnyRowSuccessful)
            {
                lblCount.Text = "Total Net Amount: 0";

                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Delivery confirmation Created Successsfully!" + "','Success');", true);
                
                SelectedInvoiceIds.Clear();
                BindSelectedGrid();

                GridView();
            }
            else if (hasSelectedPartialRow && !isAnyRowProcessed)
            {

                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Partial confirmed invoices need to be submitted from Go to Partial." + "','Faild');", true);
            }
            else if (!isAnyRowProcessed)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Selected rows do not have a valid DA sales confirm status." + "','Faild');", true);
            }
        }
    }

    protected void btnReject_Click(object sender, EventArgs e)
    {
        if (DataValidation())
        {
            bool isAnyRowSuccessful = false;
            List<string> selectedIds = SelectedInvoiceIds;
            
            foreach (string invoiceIdStr in selectedIds)
            {
                int invoiceId;
                if (int.TryParse(invoiceIdStr, out invoiceId))
                {
                    if (aInvoiceBll.RejectInvoiceDASalesConfirmStatus(invoiceId))
                    {
                        isAnyRowSuccessful = true;

                        // Update DIC Approval Status in tblSalesConfirmation_appLog
                        string appLogId = GetAppLogIdForInvoice(invoiceIdStr);
                        if (!string.IsNullOrEmpty(appLogId))
                            aInvoiceBll.UpdateDICApprovalStatus(appLogId, "Rejected", Session["LoginName"].ToString());
                    }
                }
            }
            
            if (isAnyRowSuccessful)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "alert('Selected invoices have been rejected successfully.');", true);
                
                SelectedInvoiceIds.Clear();
                BindSelectedGrid();
                GridView();
            }
        }
    }

    /// <summary>
    /// Session["MainTable"] থেকে InvoiceId দিয়ে SalesConfirmationAppLogId খুঁজে দেয়।
    /// </summary>
    private string GetAppLogIdForInvoice(string invoiceId)
    {
        DataTable mainTable = Session["MainTable"] as DataTable;
        if (mainTable == null || string.IsNullOrEmpty(invoiceId))
            return string.Empty;

        if (!mainTable.Columns.Contains("SalesConfirmationAppLogId") ||
            !mainTable.Columns.Contains("InvoiceId"))
            return string.Empty;

        DataRow[] rows = mainTable.Select("InvoiceId = '" + invoiceId + "'");
        if (rows.Length > 0 && rows[0]["SalesConfirmationAppLogId"] != DBNull.Value)
            return rows[0]["SalesConfirmationAppLogId"].ToString();

        return string.Empty;
    }

    private bool DataValidation()
    {
        if (orderGridView.Rows.Count == 0)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Data Can not be Empty!" + "','Faild');", true);
            return false;
        }

        if (SelectedInvoiceIds.Count == 0)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please Select at least one Row!" + "','Faild');", true);
            return false;
        }
        return true;
    }


    protected void restbtn_Click(object sender, EventArgs e)
    {

    }
    protected void chkSelect_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox button = (CheckBox)sender;
        GridViewRow currentRow = (GridViewRow)button.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        HiddenField hfInvoiceId = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfInvoiceId"));

        if (IsPartialGridRow(orderGridView.Rows[rowindex]))
        {
            button.Checked = false;
            button.Enabled = false;
            return;
        }

        List<string> selectedIds = SelectedInvoiceIds;

        if (button.Checked)
        {
            if (hfInvoiceId != null && !selectedIds.Contains(hfInvoiceId.Value))
            {
                selectedIds.Add(hfInvoiceId.Value);
            }
        }
        else
        {
            if (hfInvoiceId != null && selectedIds.Contains(hfInvoiceId.Value))
            {
                selectedIds.Remove(hfInvoiceId.Value);
            }
        }

        SelectedInvoiceIds = selectedIds;
        BindSelectedGrid();
    }

    private decimal NewMethod(decimal total)
    {
        List<string> selectedIds = SelectedInvoiceIds;
        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            HiddenField hfInvoiceId = (HiddenField)orderGridView.Rows[i].FindControl("hfInvoiceId");
            Label lblTpGrandTotal = ((Label)orderGridView.Rows[i].FindControl("lblTpGrandTotal"));
            if (hfInvoiceId != null && selectedIds.Contains(hfInvoiceId.Value) && !IsPartialGridRow(orderGridView.Rows[i]))
            {
                decimal t = 0;
                try
                {
                    t = Convert.ToDecimal(lblTpGrandTotal.Text);
                }
                catch (Exception ex)
                {
                }

                total = total + t;
            }
        }

        return total;
    }


    protected void EmpCetegoryAddImageButton_Click(object sender, EventArgs e)
    {
        //Response.Redirect("http://13.76.141.111:58122/SInventory_UI/DelivaryInvoiceCreationAuto.aspx?UId=" + Session["UserId"].ToString() + "& UName ="+ Session["LoginName"].ToString());

        System.Web.UI.ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "openModal", "window.open('http://13.76.141.111:58122/SInventory_UI/DelivaryInvoiceCreationAuto.aspx?UId=" + Session["UserId"].ToString() + "&UName=" + Session["LoginName"].ToString() + "' ,'_blank');", true);

    }

    protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
    {
        ISCommonDate();
    }

    protected void DateTextBox_TextChanged(object sender, EventArgs e)
    {
        getRouteInfo(); 

    }

    protected void statusDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList DropDownList = (DropDownList)sender;
        GridViewRow currentRow = (GridViewRow)DropDownList.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        DropDownList statusDropDownList = ((DropDownList)orderGridView.Rows[rowindex].FindControl("statusDropDownList"));
        LinkButton gotoinvoiceButton = ((LinkButton)orderGridView.Rows[rowindex].FindControl("gotoinvoiceButton"));



        gotoinvoiceButton.Visible = false;
        if (statusDropDownList.SelectedValue == "Partial Dues")
        {
            gotoinvoiceButton.Visible = true; 
        }

    }

    protected void rootDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            LoadTerritoryByRoute();
        }
        catch (Exception ex) { }
    }
}
