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

public partial class SInventory_UI_DelivaryInvoiceCreationAfterSalesConfirm : System.Web.UI.Page
{
    OrderInfoBLL aOrderInfoBll=new OrderInfoBLL();
    OrderInfoDAL aDal =new OrderInfoDAL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
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
        CustPaymentBLL aCustPaymentBll = new CustPaymentBLL();
        //if (Validation())
        {

            HiddenField hfInvoiceNo = ((HiddenField)orderGridView.Rows[i].Cells[1].FindControl("hfInvoiceNo"));
            Label lblTpGrandTotal = ((Label)orderGridView.Rows[i].Cells[1].FindControl("lblTpGrandTotal"));
            CustomerMaster aCustomerMaster;
            CustPayment aCustPayment = new CustPayment();
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


            List<CustPaymentDetail> aCustPaymentDetails = new List<CustPaymentDetail>();
            //for (int i = 0; i < orderGridView.Rows.Count; i++)
            {
                decimal totalamount = 0;
                totalamount = Convert.ToDecimal(lblTpGrandTotal.Text);
                aCustPaymentBll.UpdateInvoicePaymentAmount(totalamount.ToString(), "Full",
                        orderGridView.DataKeys[i][3].ToString());
                CustPaymentDetail aCustPaymentDetail = new CustPaymentDetail()
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
        CustPaymentBLL aCustPaymentBll = new CustPaymentBLL();
        //if (Validation())
        {

            HiddenField hfInvoiceNo = ((HiddenField)orderGridView.Rows[i].Cells[1].FindControl("hfInvoiceNo"));
            Label lblTpGrandTotal = ((Label)orderGridView.Rows[i].Cells[1].FindControl("lblTpGrandTotal"));
            CustomerMaster aCustomerMaster;
            CustPayment aCustPayment = new CustPayment();
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


            List<CustPaymentDetail> aCustPaymentDetails = new List<CustPaymentDetail>();
            //for (int i = 0; i < orderGridView.Rows.Count; i++)
            {
                decimal totalamount = 0;
                totalamount = Convert.ToDecimal(lblTpGrandTotal.Text);
                aCustPaymentBll.UpdateInvoicePaymentAmount(totalamount.ToString(), "Full",
                        orderGridView.DataKeys[i][3].ToString());
                CustPaymentDetail aCustPaymentDetail = new CustPaymentDetail()
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
        DropDownList statusDropDownList = ((DropDownList)orderGridView.Rows[rowindex].FindControl("statusDropDownList"));
        

        HiddenField hfInvoiceNo = ((HiddenField)orderGridView.Rows[rowindex].Cells[1].FindControl("hfInvoiceNo"));
        Label lblTpGrandTotal = ((Label)orderGridView.Rows[rowindex].Cells[1].FindControl("lblTpGrandTotal"));
        if (statusDropDownList.SelectedValue== "Partial Dues")
        {
            Session["InvoiceId"] = orderGridView.DataKeys[rowindex]["InvoiceId"].ToString();
    Response.Redirect("PaymentPartial.aspx");
            //System.Web.UI.ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "openModal", "window.open('PaymentPartial.aspx" + "' ,'_blank');", true);

        }
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
        string paaram = "";
        //if (invoicenoTextBox.Text != string.Empty)
        //{
        //    paaram = "  and dbo.tblOrder.ComUnitId='" + salesCenterDropDownList.SelectedValue + "' AND tblOrder.DistributionRouteId='" +
        //             rootDropDownList.SelectedValue + "' AND tblInvoice.InvoiceNo like'%" + invoicenoTextBox.Text +
        //             "%' AND ( DelivaryInvoiceNo IS NULL OR DelivaryInvoiceNo='' )      order by tblInvoice.InvoiceNo Asc";
        //}
        //else
        //{
        //    paaram = " and dbo.tblOrder.ComUnitId='" + salesCenterDropDownList.SelectedValue + "' AND tblOrder.DistributionRouteId='" +
        //             rootDropDownList.SelectedValue + "'  AND ( DelivaryInvoiceNo IS NULL OR DelivaryInvoiceNo='' )     order by tblInvoice.InvoiceNo Asc";
        //}



        if (invoicenoTextBox.Text != string.Empty)
        {
            paaram = "  and dbo.tblOrder.ComUnitId='" + salesCenterDropDownList.SelectedValue + "' AND tblOrder.DistributionRouteId='" +
                     rootDropDownList.SelectedValue + "' AND tblInvoice.InvoiceNo like'%" + invoicenoTextBox.Text +
                     "%'      and  PaymentInvoiceNo  is  null ";
        }
        else
        {
            paaram = "  and   dbo.tblOrder.ComUnitId='" + salesCenterDropDownList.SelectedValue + "' AND tblOrder.DistributionRouteId='" +
                     rootDropDownList.SelectedValue + "'      and  PaymentInvoiceNo  is  null "   ;
        }
        ///and  dbo.tblOrder.TerritoryId=" + ddlTerritoryName.SelectedValue 
        //if (salesCenterDropDownList.SelectedValue != "7" && salesCenterDropDownList.SelectedValue != "8" && salesCenterDropDownList.SelectedValue != "4" && salesCenterDropDownList.SelectedValue != "6" && salesCenterDropDownList.SelectedValue != "9")
        //{
        //    paaram = paaram + " and (CONVERT(date,tblInvoice.InvoiceDate))> (CONVERT(date,'01-Jul-2024'))";
        //}
        paaram = paaram + "  order by tblInvoice.InvoiceNo Asc";

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

        if (string.IsNullOrEmpty(rootDropDownList.SelectedValue))
        {

            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please input Route!" + "','Faild');", true);
            rootDropDownList.Focus();
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
            DropDownList statusDropDownList = ((DropDownList)orderGridView.Rows[rowindex].FindControl("statusDropDownList"));
            LinkButton gotoinvoiceButton = ((LinkButton)orderGridView.Rows[rowindex].FindControl("gotoinvoiceButton"));
            HiddenField hfIsAdjustInvoice = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfIsAdjustInvoice"));

            if (hfIsAdjustInvoice.Value == "True")
            {
                statusDropDownList.SelectedIndex = 0;
                statusDropDownList.Enabled = false;
            }

            statusDropDownList.SelectedValue = aTable.Rows[rowindex]["LoadingSummaryStatus"].ToString();

            if (statusDropDownList.SelectedValue == "Partial Dues")
            {
                gotoinvoiceButton.Visible = true;
            }
            else
            {
                gotoinvoiceButton.Visible = false;
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
            RouteInformationDAL _DalRoute = new RouteInformationDAL();
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
        DropDownList DropDownList = (DropDownList)sender;
        GridViewRow currentRow = (GridViewRow)DropDownList.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        LinkButton gotoinvoiceButton = ((LinkButton)orderGridView.Rows[rowindex].FindControl("gotoinvoiceButton"));
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
        gotoinvoiceButton.Visible = false;
        if (statusDropDownList.SelectedValue == "Partial Dues")
        {
            gotoinvoiceButton.Visible = true;
        }
       

    }

    protected void btnFinalSubmit_Click(object sender, EventArgs e)
    {

        int status = 0;
        if (DataValidation())
        {
           
            for (int rowindex = 0; rowindex < orderGridView.Rows.Count; rowindex++)
            {
                DropDownList statusDropDownList = ((DropDownList)orderGridView.Rows[rowindex].FindControl("statusDropDownList"));
            
                CheckBox chkSelect = ((CheckBox)orderGridView.Rows[rowindex].FindControl("chkSelect"));
                HiddenField hfInvoiceNo = ((HiddenField)orderGridView.Rows[rowindex].Cells[1].FindControl("hfInvoiceNo"));
                Label lblTpGrandTotal = ((Label)orderGridView.Rows[rowindex].Cells[1].FindControl("lblTpGrandTotal"));
                if (chkSelect.Checked)
                {
                    if (statusDropDownList.SelectedValue == "Full")
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
            GridView();
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Delivery Invoice Created Successsfully!" + "','Success');", true);

            
        }
        //}
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
}