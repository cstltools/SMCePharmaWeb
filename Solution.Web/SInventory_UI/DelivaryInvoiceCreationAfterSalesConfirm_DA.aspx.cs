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

public partial class SInventory_UI_DelivaryInvoiceCreationAfterSalesConfirm_DA : System.Web.UI.Page
{
    OrderInfoBLL_daaw aOrderInfoBll=new OrderInfoBLL_daaw();
    OrderInfoDAL_daaw aDal =new OrderInfoDAL_daaw();
    InvoiceBLL_daaw aInvoiceBll = new InvoiceBLL_daaw();
    private static SeedDataDAL_daaw _seedRepo = new SeedDataDAL_daaw();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownlist();
            salesCenterDropDownList_SelectedIndexChanged(sender, e);
            SessionChoose();
            if (Session["DelMarketId"] != null)
            {
                marketDropDownList.SelectedValue = Session["DelMarketId"].ToString();
                GridView();
                lblCount.Text = "Total Net Amount: 0";

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
        Response.Redirect("DelivaryInvoiceCreationAuto.aspx");

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

            try
            {
                using (DataTable dt = _seedRepo.GetRouteInfoforReturn(Convert.ToInt32(salesCenterDropDownList.SelectedValue)))
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


    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)orderGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)orderGridView.Rows[i].Cells[0].FindControl("chkSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;
        
           
        }
        decimal total = 0;
        total = NewMethod(total);
        lblCount.Text = "Total Net Amount: " + total.ToString();

    }
    protected void manufacDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
       
    }


    public void getRouteInfo()
    {
        try
        {
            aOrderInfoBll.LoadRouteforReturn(rootDropDownList, Convert.ToInt32(salesCenterDropDownList.SelectedValue));
        }
        catch
        {
            showMessageBox("Please select Filtering Criteria!");
        }
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
        GridViewRow currentRow = (GridViewRow)button.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        HiddenField hfDASalesReturnType = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfDASalesReturnType"));
        Label lblDASalesReturnType = ((Label)orderGridView.Rows[rowindex].FindControl("lblDASalesReturnType"));
        string statusVal = hfDASalesReturnType != null && !string.IsNullOrEmpty(hfDASalesReturnType.Value)
            ? hfDASalesReturnType.Value
            : (lblDASalesReturnType != null ? lblDASalesReturnType.Text : "");

        HiddenField hfInvoiceNo = ((HiddenField)orderGridView.Rows[rowindex].Cells[1].FindControl("hfInvoiceNo"));
        Label lblTpGrandTotal = ((Label)orderGridView.Rows[rowindex].Cells[1].FindControl("lblTpGrandTotal"));
        string invoiceId = orderGridView.DataKeys[rowindex]["InvoiceId"].ToString();
        Session["InvoiceId"] = invoiceId;
        HiddenField hfSalesReturnAppLogId = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfSalesReturnAppLogId"));
        string appLogId = hfSalesReturnAppLogId != null ? hfSalesReturnAppLogId.Value : string.Empty;
        if (string.IsNullOrEmpty(appLogId) && orderGridView.DataKeys[rowindex]["SalesReturnAppLogId"] != DBNull.Value)
        {
            appLogId = orderGridView.DataKeys[rowindex]["SalesReturnAppLogId"].ToString();
        }
        if (string.IsNullOrEmpty(appLogId))
        {
            appLogId = aInvoiceBll.GetSalesReturnAppLogIdByInvoiceId(Convert.ToInt32(invoiceId));
        }
        Session["SalesReturnAppLogId"] = appLogId;
        Response.Redirect("dadtlsPaymentPartial_DA.aspx?status=" + HttpUtility.UrlEncode(statusVal) + "&SalesReturnAppLogId=" + HttpUtility.UrlEncode(appLogId));
        //else if (statusDropDownList.SelectedItem.Text == "Full")
        //{
        //    int status = aInvoiceBll.SaveFullInvoice(hfInvoiceNo.Value,
        //        Session["LoginName"].ToString(), DateTime.Now.ToString("dd-MMM-yyyy"));
        //    if (autoPayment.Checked)
        //    {
        //        SavePayment(rowindex);
        //    }

        //    if (status == 1)
        //    {
        //        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Delivery Invoice Created Successsfully!" + "','Success');", true);

        //        lblCount.Text = "Total Net Amount: 0";
        //        GridView();

        //    }
        //}
        ////else if (statusDropDownList.SelectedItem.Text=="Full")
        ////{
        ////    int status = aInvoiceBll.SaveFullInvoice(orderGridView.Rows[rowindex].Cells[9].Text,
        ////        Session["LoginName"].ToString(), DateTime.Now.ToString("dd-MMM-yyyy"));
        ////     if (status==1)
        ////    {
        ////        showMessageBox("Delivery Invoice Save Successfully");
        ////        GridView();
        ////    }
        ////}
        //else 
        //{
        //    //if (((DropDownList) orderGridView.Rows[rowindex].FindControl("reasonReturnDropDownList")).SelectedIndex != 0)
        //    //{


        //        int status = aInvoiceBll.SaveRejectInvoice(hfInvoiceNo.Value,
        //            Session["LoginName"].ToString(), DateTime.Now.ToString("dd-MMM-yyyy"),
        //            ((DropDownList) orderGridView.Rows[rowindex].FindControl("reasonReturnDropDownList")).SelectedItem
        //                .Text);
        //        //if (status == 1)
        //        {
        //        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Delivery Invoice Rejected Successsfully!" + "','Success');", true); 
        //        lblCount.Text = "Total Net Amount: 0";
        //        GridView();

        //        //for (int i = 0; i < orderGridView.Rows.Count; i++)
        //        //{

        //        //    aInvoiceBll.ReturnReason(
        //        //        ((DropDownList)orderGridView.Rows[i].FindControl("reasonReturnDropDownList")));
        //        //}
        //    }
        //    //}
        //    //else
        //    //{
        //    //    showMessageBox("Please Choose Reason !!!");
        //    //}

        //}
        ////Session["OrderId"] = orderGridView.DataKeys[rowindex]["OrderId"].ToString();


    }
    protected void Button1_Click(object sender, EventArgs e)
    { 
        lblCount.Text = "Total Net Amount: 0" ;
        GridView();
       

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

        if (invoicenoTextBox.Text != string.Empty)
        {
            paaram += " AND tblInvoice.InvoiceNo like'%" + invoicenoTextBox.Text + "%' ";
        }

         //paaram += " and PaymentInvoiceNo is null  ";
        paaram += " order by tblInvoice.InvoiceNo Asc";

        return paaram;
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



        //if (string.IsNullOrEmpty(ddlTerritoryName.SelectedValue))
        //{

        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please input Territory!" + "','Faild');", true);
        //    ddlTerritoryName.Focus();
        //    return;
        //}
        DataTable aTable = new DataTable();
        //aTable = aOrderInfoBll.LoadOrderWithInvoice(salesCenterDropDownList.SelectedValue, rootDropDownList.SelectedValue,
        //    marketDropDownList.SelectedValue);
        aTable = aDal.LoadOrderWithInvoiceSP(GenerateParam() );
        orderGridView.DataSource = aTable;
        orderGridView.DataBind();
        for (int rowindex = 0; rowindex < orderGridView.Rows.Count; rowindex++)
        {
            LinkButton gotoinvoiceButton = ((LinkButton)orderGridView.Rows[rowindex].FindControl("gotoinvoiceButton"));
            if (gotoinvoiceButton != null)
            {
                gotoinvoiceButton.Visible = true;
            }
        }

        Session["DelMarketId"] = marketDropDownList.SelectedValue;
        //DataTable aTable = new DataTable();
        //aTable = aOrderInfoBll.LoadOrderWithInvoice(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
        //    marketDropDownList.SelectedValue);
        //orderGridView.DataSource = aTable;
        //orderGridView.DataBind();
        //Session["DelMarketId"] = marketDropDownList.SelectedValue;
    }
    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        orderGridView.PageIndex = e.NewPageIndex;
        this.GridView();
    }

    protected void rootDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
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
    }

    protected void btnFinalSubmit_Click(object sender, EventArgs e)
    {

        int status = 0;
        if (DataValidation())
        {
           
            for (int rowindex = 0; rowindex < orderGridView.Rows.Count; rowindex++)
            {
                HiddenField hfDASalesReturnType = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfDASalesReturnType"));
                Label lblDASalesReturnType = ((Label)orderGridView.Rows[rowindex].FindControl("lblDASalesReturnType"));
                string statusVal = hfDASalesReturnType != null && !string.IsNullOrEmpty(hfDASalesReturnType.Value)
                    ? hfDASalesReturnType.Value
                    : (lblDASalesReturnType != null ? lblDASalesReturnType.Text : "");
            
                CheckBox chkSelect = ((CheckBox)orderGridView.Rows[rowindex].FindControl("chkSelect"));
                HiddenField hfInvoiceNo = ((HiddenField)orderGridView.Rows[rowindex].Cells[1].FindControl("hfInvoiceNo"));
                Label lblTpGrandTotal = ((Label)orderGridView.Rows[rowindex].Cells[1].FindControl("lblTpGrandTotal"));
                if (chkSelect.Checked)
                {
                    if (statusVal.Equals("Full", StringComparison.OrdinalIgnoreCase))
                    {
                        status = aInvoiceBll.SavePaymentConformationFull(hfInvoiceNo.Value,
                      Session["LoginName"].ToString(), DateTime.Now.ToString("dd-MMM-yyyy"));
                    }

                    //status= aInvoiceBll.UP_LoadingSummaryInvoice_Complete(hfInvoiceNo.Value,
                    //   Session["LoginName"].ToString(), "Completed");
                        //if (autoPayment.Checked)
                        //{
                        //    if (status == 1)
                        //    {
                        //        SavePaymentMultiple(rowindex);
                        //    }
                        //}

                    }
                    else
                    {
                       /// ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please Select Full in Status!" + "','Faild');", true);

                    }
                }

            }


        if (status > 0)
        {
            lblCount.Text = "Total Net Amount: 0";

            // Update DIC Approval Status
            for (int rowindex = 0; rowindex < orderGridView.Rows.Count; rowindex++)
            {
                CheckBox chkSelect = ((CheckBox)orderGridView.Rows[rowindex].FindControl("chkSelect"));
                if (chkSelect.Checked)
                {
                    string invoiceIdStr = orderGridView.DataKeys[rowindex]["InvoiceId"].ToString();
                    HiddenField hfSalesReturnAppLogId = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfSalesReturnAppLogId"));
                    string appLogId = hfSalesReturnAppLogId != null ? hfSalesReturnAppLogId.Value : string.Empty;
                    if (string.IsNullOrEmpty(appLogId) && orderGridView.DataKeys[rowindex]["SalesReturnAppLogId"] != DBNull.Value)
                    {
                        appLogId = orderGridView.DataKeys[rowindex]["SalesReturnAppLogId"].ToString();
                    }
                    int invoiceId;
                    if (int.TryParse(invoiceIdStr, out invoiceId))
                    {
                        if (string.IsNullOrEmpty(appLogId))
                        {
                            appLogId = aInvoiceBll.GetSalesReturnAppLogIdByInvoiceId(invoiceId);
                        }

                        if (!string.IsNullOrEmpty(appLogId))
                        {
                            aInvoiceBll.UpdateDICApprovalStatus_SalesReturn(appLogId, "Approved", Session["LoginName"].ToString());
                        }
                    }
                }
            }

            GridView();
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Delivery Invoice Created Successsfully!" + "','Success');", true);

            
        }
        //}
    }

    protected void btnReject_Click(object sender, EventArgs e)
    {
        if (DataValidation())
        {
            bool isAnyRowSuccessful = false;
            
            for (int rowindex = 0; rowindex < orderGridView.Rows.Count; rowindex++)
            {
                CheckBox chkSelect = ((CheckBox)orderGridView.Rows[rowindex].FindControl("chkSelect"));
                
                if (chkSelect.Checked)
                {
                    string invoiceIdStr = orderGridView.DataKeys[rowindex]["InvoiceId"].ToString();
                    HiddenField hfSalesReturnAppLogId = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfSalesReturnAppLogId"));
                    string appLogId = hfSalesReturnAppLogId != null ? hfSalesReturnAppLogId.Value : string.Empty;
                    if (string.IsNullOrEmpty(appLogId) && orderGridView.DataKeys[rowindex]["SalesReturnAppLogId"] != DBNull.Value)
                    {
                        appLogId = orderGridView.DataKeys[rowindex]["SalesReturnAppLogId"].ToString();
                    }
                    int invoiceId;
                    if (int.TryParse(invoiceIdStr, out invoiceId))
                    {
                        if (aInvoiceBll.RejectInvoiceDASalesReturn(invoiceId, appLogId))
                        {
                            isAnyRowSuccessful = true;
                        }
                    }
                }
            }
            
            if (isAnyRowSuccessful)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "alert('Selected invoices have been rejected successfully.');", true);
                lblCount.Text = "Total Net Amount: 0";
                GridView();
            }
        }
    }

    private bool DataValidation()
    {

        if (orderGridView.Rows.Count == 0)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Data Can not be Empty!" + "','Faild');", true);


            return false;
        }

        Int32 count = 0;

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)orderGridView.Rows[i].Cells[0].FindControl("chkSelect");

            if (chkBoxRows.Checked)
            {
                count++;
            }

            if (count > 0)
            {
                break;
            }
        }

        if (count == 0)
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


        decimal total = 0;
        total = NewMethod( total);

       
        lblCount.Text = "Total Net Amount: " + total.ToString();

    }

    private decimal NewMethod( decimal total)
    {
        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            CheckBox chkBoxRows = (CheckBox)orderGridView.Rows[i].Cells[0].FindControl("chkSelect");
            HiddenField hfInvoiceNo = ((HiddenField)orderGridView.Rows[i].Cells[1].FindControl("hfInvoiceNo"));
            Label lblTpGrandTotal = ((Label)orderGridView.Rows[i].Cells[1].FindControl("lblTpGrandTotal"));
            if (chkBoxRows.Checked)
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



    protected void btnReturnSummaryNote_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        string invoiceId = btn.CommandArgument;
        GridViewRow currentRow = (GridViewRow)btn.NamingContainer;
        HiddenField hfDASalesReturnType = (HiddenField)orderGridView.Rows[currentRow.RowIndex].FindControl("hfDASalesReturnType");
        Label lblDASalesReturnType = (Label)orderGridView.Rows[currentRow.RowIndex].FindControl("lblDASalesReturnType");
        string mappedStatus = hfDASalesReturnType != null && !string.IsNullOrEmpty(hfDASalesReturnType.Value)
            ? hfDASalesReturnType.Value
            : (lblDASalesReturnType != null ? lblDASalesReturnType.Text : "Partial Dues");

        HiddenField hfSalesReturnAppLogId = (HiddenField)orderGridView.Rows[currentRow.RowIndex].FindControl("hfSalesReturnAppLogId");
        string appLogId = hfSalesReturnAppLogId != null ? hfSalesReturnAppLogId.Value : string.Empty;
        if (string.IsNullOrEmpty(appLogId) && orderGridView.DataKeys[currentRow.RowIndex]["SalesReturnAppLogId"] != DBNull.Value)
        {
            appLogId = orderGridView.DataKeys[currentRow.RowIndex]["SalesReturnAppLogId"].ToString();
        }

        hfReturnInvoiceId.Value = invoiceId;
        hfReturnStatus.Value = mappedStatus;

        try
        {
            InvoiceBLL_daaw aInvoiceBll = new InvoiceBLL_daaw();
            OrderInfoBLL_daaw aOrderInfoBll = new OrderInfoBLL_daaw();

            DataTable dtHeader = aInvoiceBll.LoadSalesReturnAppLogHeader(invoiceId, appLogId);
            if (dtHeader.Rows.Count > 0)
            {
                DataRow hdr = dtHeader.Rows[0];
                lblRtnCustomerName.Text = dtHeader.Columns.Contains("CustomerName") ? hdr["CustomerName"].ToString() : "";
                lblRtnCustomerCode.Text = dtHeader.Columns.Contains("CustomerCode") ? hdr["CustomerCode"].ToString() : "";
                lblRtnAddress.Text = dtHeader.Columns.Contains("Address") ? hdr["Address"].ToString() : "";
                lblRtnMarket.Text = dtHeader.Columns.Contains("MarketName") ? hdr["MarketName"].ToString() : "";
                lblRtnInvoiceNo.Text = dtHeader.Columns.Contains("InvoiceNo") ? hdr["InvoiceNo"].ToString() : "";
                lblRtnInvoiceDate.Text = dtHeader.Columns.Contains("InvoiceDate") && hdr["InvoiceDate"] != DBNull.Value
                    ? Convert.ToDateTime(hdr["InvoiceDate"]).ToString("dd-MMM-yyyy") : "";
                lblRtnDaName.Text = dtHeader.Columns.Contains("DA_SalesConfirmBy") ? hdr["DA_SalesConfirmBy"].ToString() : "";
                lblRtnConfirmDate.Text = dtHeader.Columns.Contains("DA_SalesConfirmDate") && hdr["DA_SalesConfirmDate"] != DBNull.Value
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

            lblReturnNoteType.Text = "[ Sales Return ]";

            // Load from tblSalesReturn_appLogDetail
            DataTable dtAppLogDetails = aInvoiceBll.LoadSalesReturnAppLogDetails(invoiceId, appLogId);

            if (dtAppLogDetails != null && dtAppLogDetails.Rows.Count > 0)
            {
                foreach (DataRow row in dtAppLogDetails.Rows)
                {
                    decimal totalQty = row["TotalQty"] != DBNull.Value ? Convert.ToDecimal(row["TotalQty"]) : 0;
                    decimal returnQty = row["ReturnQty"] != DBNull.Value ? Convert.ToDecimal(row["ReturnQty"]) : 0;
                    decimal unitPrice = row["UnitPrice"] != DBNull.Value ? Convert.ToDecimal(row["UnitPrice"]) : 0;
                    decimal returnAmount = row["ReturnAmount"] != DBNull.Value ? Convert.ToDecimal(row["ReturnAmount"]) : (returnQty * unitPrice);
                    string reasonStr = row.Table.Columns.Contains("Reason") && row["Reason"] != DBNull.Value ? row["Reason"].ToString().Trim() : string.Empty;
                    string reason = !string.IsNullOrEmpty(reasonStr) ? reasonStr : "Sales Return";

                    returnData.Rows.Add(
                        row["ProductCode"].ToString(),
                        row.Table.Columns.Contains("ProductName") ? row["ProductName"].ToString() : "",
                        totalQty.ToString("N0"),
                        returnQty.ToString("N0"),
                        unitPrice.ToString("N2"),
                        returnAmount.ToString("N2"),
                        reason
                    );
                }
            }
            else
            {
                // Fallback to tblInvoiceDetail
                DataTable dtInvoice = aOrderInfoBll.LoadInvoiceReturn(invoiceId);
                foreach (DataRow row in dtInvoice.Rows)
                {
                    string status = row.Table.Columns.Contains("DeliveryInvoiceStatus") ? row["DeliveryInvoiceStatus"].ToString() : "";
                    decimal totalQty = row["TotalQty"] != DBNull.Value ? Convert.ToDecimal(row["TotalQty"]) : 0;
                    decimal tQty = row.Table.Columns.Contains("TQty") && row["TQty"] != DBNull.Value ? Convert.ToDecimal(row["TQty"]) : 0;
                    decimal returnQty = tQty > 0 ? tQty : totalQty;
                    
                    decimal delivQty = row.Table.Columns.Contains("DeliveryQuantity") && row["DeliveryQuantity"] != DBNull.Value ? Convert.ToDecimal(row["DeliveryQuantity"]) : 0;
                    if (status == "Partial" && delivQty > 0)
                    {
                        returnQty = totalQty - delivQty;
                    }
                    if (status == "Partial" && returnQty <= 0) continue;

                    decimal unitPrice = row["UnitPrice"] != DBNull.Value ? Convert.ToDecimal(row["UnitPrice"]) : 0;
                    decimal delivNetAmt = row.Table.Columns.Contains("DeliveryNetAmount") && row["DeliveryNetAmount"] != DBNull.Value ? Convert.ToDecimal(row["DeliveryNetAmount"]) : 0;
                    decimal netAmt = row.Table.Columns.Contains("NetPrice") && row["NetPrice"] != DBNull.Value ? Convert.ToDecimal(row["NetPrice"]) : (returnQty * unitPrice);
                    decimal returnAmount = (status == "Partial" && delivNetAmt > 0) ? delivNetAmt : netAmt;

                    string reason = row.Table.Columns.Contains("ReturnReason") ? row["ReturnReason"].ToString() : "Sales Return";

                    returnData.Rows.Add(
                        row["ProductCode"].ToString(),
                        row.Table.Columns.Contains("ProductName") ? row["ProductName"].ToString() : "",
                        totalQty.ToString("N0"),
                        returnQty.ToString("N0"),
                        unitPrice.ToString("N2"),
                        returnAmount.ToString("N2"),
                        reason
                    );
                }
            }

            gvReturnSummary.DataSource = returnData;
            gvReturnSummary.DataBind();

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

    public string GetStatusBadgeCss(object statusObj)
    {
        string status = statusObj != null ? statusObj.ToString().Trim() : "";
        if (status.Equals("Full", StringComparison.OrdinalIgnoreCase))
        {
            return "badge bg-success badge-status badge-status-full";
        }
        else if (status.Equals("Partial", StringComparison.OrdinalIgnoreCase) || status.Equals("Partial Dues", StringComparison.OrdinalIgnoreCase))
        {
            return "badge bg-warning text-dark badge-status badge-status-partial";
        }
        else if (status.Equals("Reject", StringComparison.OrdinalIgnoreCase) || status.Equals("Canceled", StringComparison.OrdinalIgnoreCase))
        {
            return "badge bg-danger badge-status badge-status-reject";
        }
        return "badge bg-secondary badge-status badge-status-default";
    }
}