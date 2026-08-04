using System;
using System.Activities.Expressions;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_CustomerPayment : System.Web.UI.Page
{
    OrderInfoDAL aDal = new OrderInfoDAL();
    private CustPaymentBLL aCustPaymentBll = new CustPaymentBLL();
    OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownList();
            
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
        CheckBox ChkBoxHeader = (CheckBox) orderGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox) orderGridView.Rows[i].Cells[0].FindControl("chkSelect");
            if (ChkBoxHeader.Checked == true)
            {
                ChkBoxRows.Checked = true;
                PayAmountChange(i);
            }
            else
            {
                ChkBoxRows.Checked = false;
            }
        }

        CalculateTotal();
    }

    public bool Validation()
    {
        int CK = 0;
        for (int j = 0; j < orderGridView.Rows.Count; j++)
        {
            CheckBox cbReject = (CheckBox)orderGridView.Rows[j].FindControl("chkSelect");
            if (cbReject.Checked)
            {
                CK = CK + 1;
            }
        }
        if (CK == 0)
        {
            showMessageBox("Please Select Invoice from List!!");
            return false;
        }
        int count = 0;
        if (orderGridView.Rows.Count > 0)
        {
            for (int i = 0; i < orderGridView.Rows.Count; i++)
            {

                if (((CheckBox)orderGridView.Rows[i].Cells[1].FindControl("chkSelect")).Checked)
                {
                    if (((TextBox)orderGridView.Rows[i].FindControl("payAmountTextBox")).Text == "")
                    {
                        showMessageBox("Please fill out Pay Amount !!");
                        return false;
                    }
                    count++;
                }
            }
        }

        

        decimal totalamount = 0;
        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
             CheckBox cbReject = (CheckBox)orderGridView.Rows[i].FindControl("chkSelect");
            if (cbReject.Checked)
            {
                TextBox payAmountTextBox = (TextBox) orderGridView.Rows[i].Cells[7].FindControl("payAmountTextBox");
                totalamount += Convert.ToDecimal((payAmountTextBox.Text));
            }

        }
        //if (totalamount != Convert.ToDecimal((paymentAmountTextBox.Text)))
        //{
        //    showMessageBox("Total Invoice Payment Amount Must Be Equel To Payment Amount");
        //    return false;
        //}
        if (payTypeDDL.SelectedValue == "")
        {
            showMessageBox("Please Select Payment Type!!");
            return false;
        }
           if (ddlDAName.SelectedValue == "")
        {
            showMessageBox("Please Select DA Name!!");
            ddlDAName.Focus();
            return false;
        }
         
        
       
        return true;
    }

    protected void saveButton_Click(object sender, EventArgs e)
    {
        if (Validation())
        {
            CustomerMaster aCustomerMaster;

            bool save = false;

            List<CustPaymentDetail> aCustPaymentDetails = new List<CustPaymentDetail>();

            for (int i = 0; i < orderGridView.Rows.Count; i++)
            {
                CheckBox ChkBoxRows = (CheckBox) orderGridView.Rows[i].Cells[0].FindControl("chkSelect");
                CheckBox chkAdjust = (CheckBox)orderGridView.Rows[i].Cells[0].FindControl("chkAdjust");
                TextBox payAmountTextBox = (TextBox) orderGridView.Rows[i].Cells[7].FindControl("payAmountTextBox");
                HiddenField hfCustomerMasterId = (HiddenField) orderGridView.Rows[i].Cells[7].FindControl("hfCustomerMasterId");

                HiddenField hfMarketId = (HiddenField)orderGridView.Rows[i].Cells[7].FindControl("hfMarketId");
                HiddenField hfTP_Pay = (HiddenField)orderGridView.Rows[i].Cells[7].FindControl("hfTP_Pay");
                HiddenField hfVat_Pay = (HiddenField)orderGridView.Rows[i].Cells[7].FindControl("hfVat_Pay");
                DropDownList ddlCollectionBy = (DropDownList)orderGridView.Rows[i].Cells[7].FindControl("ddlCollectionBy");

                 


                HiddenField hfDistributionRouteId = (HiddenField)orderGridView.Rows[i].Cells[7].FindControl("hfDistributionRouteId");
                decimal prevamount = 0;
                decimal TotalDelivery = 0;
                Label lbl_PrvAmount = (Label)orderGridView.Rows[i].Cells[7].FindControl("lblPaymentAmount");
                Label lblTotalDelivery = (Label)orderGridView.Rows[i].Cells[7].FindControl("lblTotalDelivery");
                if (lbl_PrvAmount.Text != "")
                {
                     prevamount = Convert.ToDecimal(lbl_PrvAmount.Text);
                }
                
                
                if (lblTotalDelivery.Text != "")
                {
                    TotalDelivery = Convert.ToDecimal(lblTotalDelivery.Text);
                }

                if (ChkBoxRows.Checked)
                {



                    CustPayment aCustPayment = new CustPayment();

                    aCustPayment.CustomerMasterId = Convert.ToInt32(hfCustomerMasterId.Value);
                    aCustPayment.MarketId = Convert.ToInt32(hfMarketId.Value);
                    aCustPayment.DistributionRouteId = Convert.ToInt32(hfDistributionRouteId.Value);
                    aCustPayment.ComUnitId = Convert.ToInt32(salesCenterDropDownList.SelectedValue);
                 
                    aCustPayment.PaymentDate = Convert.ToDateTime(Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy"));
                    aCustPayment.PaymentAmount = Convert.ToDecimal(payAmountTextBox.Text);
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
                        _TP_Pay = Convert.ToDecimal(hfTP_Pay.Value);
                        _Vat_Pay = Convert.ToDecimal(hfVat_Pay.Value);

                        if ((Convert.ToDecimal(payAmountTextBox.Text) + prevamount) ==
                            TotalDelivery)
                        {
                            ptStatus = "Full";
                            decimal totalamount = 0;
                            totalamount = (Convert.ToDecimal(payAmountTextBox.Text) + prevamount);

                            decimal PaymentAmount = Convert.ToDecimal(payAmountTextBox.Text);
                         
                            save = aCustPaymentBll.UpdateInvoiceFinalPayment(Convert.ToInt32(orderGridView.DataKeys[i][0].ToString()), PaymentAmount, ptStatus, Session["LoginName"].ToString());
                            //aCustPaymentBll.UpdateInvoicePaymentAmount(totalamount.ToString(), "Full",
                            //    orderGridView.DataKeys[i][0].ToString());
                        }
                        else
                        {
                            ptStatus = "Partial";
                            decimal totalamount = 0;
                            totalamount = (Convert.ToDecimal(payAmountTextBox.Text) + prevamount);
                            decimal PaymentAmount = Convert.ToDecimal(payAmountTextBox.Text);
                            save = aCustPaymentBll.UpdateInvoiceFinalPayment(Convert.ToInt32(orderGridView.DataKeys[i][0].ToString()), PaymentAmount, ptStatus, Session["LoginName"].ToString());
                        }
                        CustPaymentDetail aCustPaymentDetail = new CustPaymentDetail()
                        {
                            InvoiceId = Convert.ToInt32(orderGridView.DataKeys[i]["InvoiceId"].ToString()),
                            PaymentAmount = Convert.ToDecimal(payAmountTextBox.Text),
                            TPAmount = _TP_Pay,
                            VATAmount = _Vat_Pay,
                            IsAdjust = chkAdjust.Checked ? Convert.ToBoolean(1) : Convert.ToBoolean(0),
                              DANameId = Convert.ToInt32(ddlDAName.SelectedValue),
                            CollectionBy =ddlCollectionBy.SelectedItem.Text
                        };

                        aCustPaymentDetails.Add(aCustPaymentDetail);

                    }
                    else
                    {
                        save = false;
                    }

                    if (save)
                    { 
                    if (aCustPaymentBll.SaveCustPayment(aCustPayment, aCustPaymentDetails))
                    {

                        
                        //foreach (var aDetail in aCustPaymentDetails)
                        //{
                        //    if (aDetail.IsAdjust)
                        //    {
                        //        aCustPaymentBll.UpdateAdjustment(aDetail.InvoiceId);
                        //    }
                        //}

                    }

                    }
                }
            }

            if (save)
            {
                LoadGridView();
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Operation successful!" + "','Success');", true);
               

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);
            }


        }
    }
    protected void payAmountTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox qtyTextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)qtyTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        PayAmountChange(rowindex);

        CalculateTotal();

    }

    private void PayAmountChange(int rowindex)
    {
        decimal prevamount = 0;
        TextBox payAmountTextBox = (TextBox)orderGridView.Rows[rowindex].Cells[7].FindControl("payAmountTextBox");
        Label lbl_PrvAmount = (Label)orderGridView.Rows[rowindex].Cells[7].FindControl("lblPaymentAmount");
        Label lblTotalDelivery = (Label)orderGridView.Rows[rowindex].Cells[7].FindControl("lblTotalDelivery");
        Label lblDue = (Label)orderGridView.Rows[rowindex].Cells[7].FindControl("lblDue");

        decimal mainamount = string.IsNullOrEmpty(payAmountTextBox.Text) ? 0 : Convert.ToDecimal(payAmountTextBox.Text);
        decimal delamount = 0;
        decimal Dueamount = 0;


        HiddenField hfInvoiceId = (HiddenField)orderGridView.Rows[rowindex].Cells[7].FindControl("hfInvoiceId");
        HiddenField hfTP_Pay = (HiddenField)orderGridView.Rows[rowindex].Cells[7].FindControl("hfTP_Pay");
        HiddenField hfVat_Pay = (HiddenField)orderGridView.Rows[rowindex].Cells[7].FindControl("hfVat_Pay");


        DataTable aTable = aDal.LoadPaymentInvSPTPVATAmt(hfInvoiceId.Value, mainamount);

        if (aTable.Rows.Count > 0)
        {
            decimal _tpFinal = 0;
            decimal _VatFinal = 0;
            decimal _tpPay = Convert.ToDecimal(aTable.Rows[0]["TP_Pay"].ToString());
            decimal _vatPay = Convert.ToDecimal(aTable.Rows[0]["Vat_Pay"].ToString());

            if (_vatPay > 0)
            {
                _VatFinal = _vatPay - mainamount;

                if (_VatFinal > 0)
                {
                    _VatFinal = mainamount;
                    _tpFinal = 0;
                }
                else
                {
                    _VatFinal = _vatPay;
                    _tpFinal = mainamount - _vatPay;
                }

            }

            if (_vatPay == 0)
            {
                if (_tpPay > 0)
                {
                    _tpFinal = mainamount;
                    _VatFinal = 0;
                }
                else
                {
                    _VatFinal = 0;
                    _tpFinal = mainamount - _vatPay;
                }
            }

            hfTP_Pay.Value = _tpFinal.ToString();
            hfVat_Pay.Value = _VatFinal.ToString();
        }



        prevamount = Convert.ToDecimal(lbl_PrvAmount.Text);
        delamount = Convert.ToDecimal(lblTotalDelivery.Text);
        Dueamount = Convert.ToDecimal(lblDue.Text);



        if ((mainamount + prevamount) > delamount)
        {
            payAmountTextBox.Text = "0";
            payAmountTextBox.Focus();
            showMessageBox("Cannot Be Greater then Invoice Quantity ");

        }
    }

    public void CalculateTotal()
    {
        decimal prevamount = 0;

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            CheckBox chkBoxRows = (CheckBox)orderGridView.Rows[i].Cells[0].FindControl("chkSelect");
            TextBox payAmountTextBox = (TextBox)orderGridView.Rows[i].Cells[7].FindControl("payAmountTextBox");

            if (chkBoxRows.Checked)
            {
                if (payAmountTextBox.Text.Trim() != "")
                {
                    if (payAmountTextBox.Text != "0")
                    {
                        prevamount = prevamount + Convert.ToDecimal(payAmountTextBox.Text.Trim());
                    }
                }
            }
        }

        lblCount.Text = "Total Pay Amount : " + prevamount.ToString(CultureInfo.InvariantCulture);
    }

    protected void chkAdjust_OnCheckedChanged(object sender, EventArgs e)
    {
        CheckBox isAdjust = (CheckBox)sender;
        GridViewRow currentRow = (GridViewRow)isAdjust.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        TextBox payAmountTextBox = (TextBox)orderGridView.Rows[rowindex].Cells[7].FindControl("payAmountTextBox");

        if (isAdjust.Checked)
        {
            payAmountTextBox.Text = orderGridView.Rows[rowindex].Cells[10].Text.Trim();
        }
        else
        {
            payAmountTextBox.Text = "";
        }
    }

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("CustomerPayment.aspx");
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
       lblCount.Text = "Total Pay Amount: 0";
        LoadGridView();

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

        lblCount.Text = "Total Pay Amount: 0";
        DataTable aTable = aDal.LoadPaymentInvSP(GenerateParam());

        orderGridView.DataSource = aTable;
        orderGridView.DataBind();
        CollectionByChange();
    }
    public string GenerateParam()
    {
        string paaram = "";
        


      
            paaram = "  and  ord.TerritoryId='" + ddlTerritoryName.SelectedValue + @"'  and   ord.ComUnitId='" + salesCenterDropDownList.SelectedValue + "' AND ord.DistributionRouteId='" +
                     rootDropDownList.SelectedValue + "'"   ;
      

        return paaram;
    }
    protected void Unnamed_Click(object sender, EventArgs e)
    {

    }

    protected void chkSelect_CheckedChanged(object sender, EventArgs e)
    {

        CheckBox qtyTextBox = (CheckBox)sender;
        GridViewRow currentRow = (GridViewRow)qtyTextBox.Parent.Parent;
        
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        PayAmountChange(rowindex);
        CalculateTotal();
    }

    protected void rootDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlDAName.Items.Clear();
        try
        {
                  RouteInformationDAL _DalRoute = new RouteInformationDAL();
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
            RouteInformationDAL _DalRoute = new RouteInformationDAL();
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
        //          RouteInformationDAL _DalRoute = new RouteInformationDAL();
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
            DropDownList ddlCollectionBy = (DropDownList)orderGridView.Rows[i].Cells[0].FindControl("ddlCollectionBy");
            if (ddlDAName.SelectedItem.Text == "MIO")
            {
                ddlCollectionBy.SelectedValue = "MIO";
            }
            else
            {
                ddlCollectionBy.SelectedValue = "DIC";
            }

        }
    }
}