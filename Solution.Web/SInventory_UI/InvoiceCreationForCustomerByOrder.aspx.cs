using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_InvoiceCreationForCustomer : System.Web.UI.Page
{
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    static CommonDataLoad _dataLoad = new CommonDataLoad();
    OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["OrderId"] != null)
            {
                 
                orderHiddenField.Value = Session["OrderId"].ToString();


                ddlDAName.Items.Clear();
                try
                {
                    RouteInformationDAL _DalRoute = new RouteInformationDAL();
                    using (DataTable dt = _DalRoute.GeteRouteInformationDA_DDLId(Session["RootNameId"].ToString()))
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

                LoadAllDataByOrder(orderHiddenField.Value.ToString());
                CustomerCreditAmount();
             

                DataTable dtwar = aInvoiceBll.GetWarning(hdCustomerMasterId.Value, custCodeTextBox.Text);
                if (dtwar.Rows.Count > 0)
                {
                    string a = dtwar.Rows[0]["Details"].ToString();
                    warningLabel.Text = "This customer has Dues(time  more than 30 days)"+ a;
                }
                else
                {
                    warningLabel.Text = "";
                }
                AdjustmentAmount();

                //shuvo
                for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
                {
                    TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                    TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                    decimal tpTextBox = 0;
                    try
                    {
                        tpTextBox = Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                    }
                    catch
                    {

                    }
                    decimal dpAmtTextBox = 0;
                    try
                    {

                        dpAmtTextBox = Convert.ToDecimal(
                                           ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                               .Text.Trim());

                    }
                    catch
                    {

                    }

                    decimal amTextBox = 0;
                    try
                    {

                        amTextBox = Convert.ToDecimal(
                                           ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("amTextBox"))
                                               .Text.Trim());

                    }
                    catch
                    {

                    }

                    decimal tpVat = 0;
                    try
                    {

                        tpVat = Convert.ToDecimal(tpVatTextBox.Text);

                    }
                    catch
                    {

                    }

                    decimal rS = (tpTextBox - (dpAmtTextBox + amTextBox)) + tpVat;
                    npTextBox.Text = rS.ToString();
                }
                TotalValueCalculation();
            }
            aInvoiceBll.PaymentTypeLoadBLL(payTypeDDL);
            payTypeDDL.SelectedIndex = 1;
            Todate();

            Session["OrderId"] = null;
            Session["RootNameId"] = null;
        }
    }

    public void AdjustmentAmount()
    {
        // Invoice-level adjustment (customer's available credit, crAmountTextBox) is allocated
        // sequentially in grid row order: each row absorbs MIN(its own pre-adjustment Net Amount,
        // whatever adjustment is still remaining), so a row can never be pushed below zero and the
        // same rupee of credit is never applied to more than one row. Previously this divided the
        // full amount evenly across every row regardless of that row's own value, which drove
        // NetAmount negative on any row smaller than the per-row share.
        //
        // At this point in Page_Load, npTextBox still holds the pre-adjustment Net Amount for every
        // row (LoadAllDataByOrder computed it with amTextBox empty/zero, and the post-adjustment
        // recompute loop that subtracts amTextBox from it hasn't run yet), so it's read here as
        // NetAmountBeforeAdjustment.
        decimal remainingAdjustment = string.IsNullOrEmpty(crAmountTextBox.Text) ? 0 : Convert.ToDecimal(crAmountTextBox.Text);

        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            TextBox rowAmTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("amTextBox");

            if (gridLineItemGridView.Rows[i].BackColor == Color.Red)
            {
                rowAmTextBox.Text = "0";
                continue;
            }

            decimal netBeforeAdjustment = 0;
            try
            {
                netBeforeAdjustment = Convert.ToDecimal(
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text.Trim());
            }
            catch
            {
            }
            if (netBeforeAdjustment < 0)
            {
                netBeforeAdjustment = 0;
            }

            decimal rowAdjustment = remainingAdjustment > 0 ? Math.Min(netBeforeAdjustment, remainingAdjustment) : 0;

            rowAmTextBox.Text = rowAdjustment.ToString("F");
            remainingAdjustment -= rowAdjustment;
        }
    }

    private void CustomerCreditAmount()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        DataTable custTable = new DataTable();
        custTable = aOrderInfoBll.GetCustomerCredit(hdCustomerMasterId.Value);
        crAmountTextBox.Text = custTable.Rows[0]["Amount"].ToString();
        rcvAmountTextBox.Text =
      ((string.IsNullOrEmpty(grandTotalTextBox.Text) ? 0 : Convert.ToDecimal(grandTotalTextBox.Text))
      - (string.IsNullOrEmpty(crAmountTextBox.Text) ? 0 : Convert.ToDecimal(crAmountTextBox.Text)))
      .ToString();
        //(Convert.ToDecimal(grandTotalTextBox.Text) - Convert.ToDecimal(crAmountTextBox.Text)).ToString(); ddd
    }
    protected void backLinkButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("InvoiceCreationByOrder.aspx");
    }

    public void Todate()
    {
        invDateTextBox.Text = Convert.ToDateTime(DateTime.Today.ToShortDateString()).ToString("dd-MMM-yyyy");
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
    private bool Validation()
    {
        //if (warningLabel.Text == "This customer has Dues(time  more than 30 days)")
        //{
        //    showMessageBox("This customer has Dues(time  more than 30 days)!!");
        //    return false;
        //}
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

        if (payTypeDDL.Text == "")
        {
            showMessageBox("Please Input Payment Type!!");
            return false;
        }
        if (Convert.ToDecimal(rcvAmountTextBox.Text) < 0)
        {
            showMessageBox("Invalid Receivable Amount!!");
            return false;
        }
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text.Trim() == "" || ((TextBox)gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text.Trim() == "")
            {
                showMessageBox("Please Remove Blank Row!!");
                return false;
            }
        }

        if (ddlDAName.SelectedValue == "")
        {
            showMessageBox("Please Select DA Name!!");
            ddlDAName.Focus();
            return false;
        }
        return true;
    }

    private void GetCustInfo(string custCode, string   OrderNO)
    {
        if (!string.IsNullOrEmpty(custCode))
        {
            custCodeTextBox.Text = custCode;
            DataTable aDataTable = new DataTable();
            aDataTable = aInvoiceBll.CustomerMaster( OrderNO);
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
                cusTypeTextBox.Text = aDataTable.Rows[0]["CustomerType"].ToString();//FCB/Institue/Genral
            }
            else
            {

            }
        }
    }

    public bool OrderExists(string orderId)
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        DataTable aTable = new DataTable();
        aTable = aOrderInfoBll.LoadOrderExistsBll(orderId);
        if (aTable.Rows.Count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    private bool Moticare()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();

        DataTable aTable = new DataTable();
        aTable = aOrderInfoBll.LoadOrderWithDetail(orderHiddenField.Value);
        DataTable dtFixedCustomer = aOrderInfoBll.GetFixedCustomer(aTable.Rows[0]["CustomerCode"].ToString());
        if (Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"]) == true)
        {
            return false;
        }
        else
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
                int Qty =
                    Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
                if (ProductCode == "FGDsa02" && Qty >= 4)
                {
                    return true;
                }
            }
        }
        return false;
    }
    private bool Nervaid75mgCapsuleFOC()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();

        DataTable aTable = new DataTable();
        aTable = aOrderInfoBll.LoadOrderWithDetail(orderHiddenField.Value);
        DataTable dtFixedCustomer = aOrderInfoBll.GetFixedCustomer(aTable.Rows[0]["CustomerCode"].ToString());
        if (Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"]) == true)
        {
            return false;
        }
        else
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
                int Qty =
                    Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
                if (ProductCode == "AELss02" && Qty >= 3)
                {
                    return true;
                }
            }
        }
        return false;
    }
    private bool FlexidolFOC()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();

        DataTable aTable = new DataTable();
        aTable = aOrderInfoBll.LoadOrderWithDetail(orderHiddenField.Value);
        DataTable dtFixedCustomer = aOrderInfoBll.GetFixedCustomer(aTable.Rows[0]["CustomerCode"].ToString());
        if (Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"]) == true)
        {
            return false;
        }
        else
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
                int Qty =
                    Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
                if (ProductCode == "AIssD01" && Qty >= 422222)
                {
                    return true;
                }
            }
        }
        return false;
    }
    private bool Ezepain()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();

        DataTable aTable = new DataTable();
        aTable = aOrderInfoBll.LoadOrderWithDetail(orderHiddenField.Value);
        DataTable dtFixedCustomer = aOrderInfoBll.GetFixedCustomer(aTable.Rows[0]["CustomerCode"].ToString());
        if (Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"]) == true)
        {
            return false;
        }
        else
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
                int Qty =
                    Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
                if (ProductCode == "AIDs04" && Qty >= 5)
                {
                    return true;
                }
            }
        }
        return false;
    }
    private bool MaxiventFOC()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();

        DataTable aTable = new DataTable();
        aTable = aOrderInfoBll.LoadOrderWithDetail(orderHiddenField.Value);
        DataTable dtFixedCustomer = aOrderInfoBll.GetFixedCustomer(aTable.Rows[0]["CustomerCode"].ToString());
        if (Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"]) == true)
        {
            return false;
        }
        else
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
                int Qty =
                    Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
                if (ProductCode == "sOAD04" && Qty >= 2)
                {
                    return true;
                }
            }
        }
        return false;
    }
    private bool SeacoralDTablet()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();

        DataTable aTable = new DataTable();
        aTable = aOrderInfoBll.LoadOrderWithDetail(orderHiddenField.Value);
        DataTable dtFixedCustomer = aOrderInfoBll.GetFixedCustomer(aTable.Rows[0]["CustomerCode"].ToString());
        if (Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"]) == true)
        {
            return false;
        }
        else
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
                int Qty =
                    Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
                if (ProductCode == "MNSs03" && Qty >= 5)
                {
                    return true;
                }
            }
        }
        return false;
    }
    //private bool ChkProductOffer()
    //{
    //    for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
    //    {
    //        string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
    //        int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
    //        if (ProductCode == "AID01" && Qty >= 2)
    //        {
    //            return true;
    //        }
    //    }
    //    return false;
    //}
    private bool CefimaxFOC()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();

        DataTable aTable = new DataTable();
        aTable = aOrderInfoBll.LoadOrderWithDetail(orderHiddenField.Value);
        DataTable dtFixedCustomer = aOrderInfoBll.GetFixedCustomer(aTable.Rows[0]["CustomerCode"].ToString());
        if (Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"]) == true)
        {
            return false;
        }
        else
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
                int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
                if (ProductCode == "ANB0s85" && Qty >= 9898884)
                {
                    return true;
                }
            }
        }

        return false;
    }
    private bool CiprodylFOC()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();

        DataTable aTable = new DataTable();
        aTable = aOrderInfoBll.LoadOrderWithDetail(orderHiddenField.Value);
        DataTable dtFixedCustomer = aOrderInfoBll.GetFixedCustomer(aTable.Rows[0]["CustomerCode"].ToString());
        if (Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"]) == true)
        {
            return false;
        }
        else
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
                int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
                if (ProductCode == "ANBs098" && Qty >= 989894)
                {
                    return true;
                }
            }
        }

        return false;
    }
    public void LoadAllDataByOrder(string orderId)
    {
        if (OrderExists(orderHiddenField.Value) == false)
        {
            OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
            DataTable aTable = new DataTable();
            aTable = aOrderInfoBll.LoadOrderWithDetail(orderId);
            orderNoTextBox.Text = aTable.Rows[0]["OrderCode"].ToString();
            orderIdHiddenField.Value = aTable.Rows[0]["OrderId"].ToString();
            orderDateTextBox.Text = Convert.ToDateTime(aTable.Rows[0]["SubmissionDate"].ToString()).ToString("dd-MMM-yyyy");
            GetCustInfo(aTable.Rows[0]["CustomerCode"].ToString(), orderNoTextBox.Text.Trim());
            int numberOfRecords = aTable.Rows.Count;

            // Batch-load per-product data for every distinct product on this order in a
            // handful of round trips instead of one query per line item (was the dominant
            // cost of this page's load time for multi-line orders).
            List<string> orderProductCodes = aTable.AsEnumerable()
                .Select(r => r.Field<string>("ProductCode"))
                .Where(pc => !string.IsNullOrEmpty(pc))
                .Distinct()
                .ToList();
            DataTable productInfoBatch = aInvoiceBll.ProductInfoBatch(hdComUnitId.Value, orderProductCodes);

            for (int i = 0; i < aTable.Rows.Count; i++)
            {
                AddFunc();
                ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value =
                    aTable.Rows[i]["OrderDetailId"].ToString();
                GetProduct(i, aTable.Rows[i]["ProductCode"].ToString(), productInfoBatch);
                /////SMC Low Stock Method /////
                decimal cstock = 0;
                cstock = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text);
                if (cstock < Convert.ToDecimal(aTable.Rows[i]["Quantity"].ToString()))
                {
                    GetQty(cstock, i);
                   // GetQty(Convert.ToDecimal(aTable.Rows[i]["Quantity"].ToString()), i);
                }
                ///////////////////
                else
                {
                    GetQty(Convert.ToDecimal(aTable.Rows[i]["Quantity"].ToString()), i);
                }

                //if (((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text == "0")
                //{
                    ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                       // "true";
                    aTable.Rows[i]["IsCampaignProduct"].ToString();


                ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("bQtyTextBox")).Text =
                   aTable.Rows[i]["ISGiftProduct"].ToString();
                ((HiddenField)gridLineItemGridView.Rows[i].Cells[10].FindControl("CampaignTypeHiddenField")).Value =
                  aTable.Rows[i]["CampaignName"].ToString();

            }

         //   else
            {
                decimal totalprice = Convert.ToDecimal(tpTptalTextBox.Text);

                {
                    for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
                    {
                        //string ProductCode1 =
                        //    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;

                        if ((((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text == "1"))
                        {
                            totalprice -=
                                Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                        }
                        if (
                            aTable.Rows[i]["CampaignName"].ToString() == "Bonus Campaign | Special Rate [Triforce 500]-Feb-24 ")
                        {
                            totalprice -=
                                Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                        }
                        if (
                              aTable.Rows[i]["CampaignName"].ToString() == "Bonus Campaign | Special Rate [Triforce 1g IM]-Feb-24 ")
                        {
                            totalprice -=
                                Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                        }



                        
                        if (
                              aTable.Rows[i]["CampaignName"].ToString() == "Special Rate [Triforce 1g IM]-Feb-24 ")
                        {
                            totalprice -=
                                Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                        }




                        if (
                          aTable.Rows[i]["CampaignName"].ToString() == "Bonus Campaign | Special Rate [Triforce 1g IM]-Feb-24 ")
                        {
                            totalprice -=
                                Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                        }
                        if (
                              aTable.Rows[i]["CampaignName"].ToString() == "Bonus Campaign | Special Rate [Triforce 500]-Feb-24")
                        {
                            totalprice -=
                                Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                        } 
                     ///----------------------------
                        
                        
                        if (
                              aTable.Rows[i]["CampaignName"].ToString().Trim() == "Bonus Campaign | Special Rate [Aminobost]-Apr-24")
                        {
                            totalprice -=
                                Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                        }   if (
                              aTable.Rows[i]["CampaignName"].ToString().Trim() == "Bonus Campaign | Special Rate [Aminobost]-Apr-24")
                        {
                            totalprice -=
                                Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                        }   if (
                              aTable.Rows[i]["CampaignName"].ToString().Trim() == "Bonus Campaign | Special Rate [Triforce 1g IV]-Apr-24")
                        {
                            totalprice -=
                                Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                        }   if (
                              aTable.Rows[i]["CampaignName"].ToString().Trim() == "Bonus Campaign | Special Rate [Triforce 1g IV]-Apr-24")
                        {
                            totalprice -=
                                Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                        }  if (
                              aTable.Rows[i]["CampaignName"].ToString().Trim() == "Special Rate [Triforce 1g IV]-Apr-24")
                        {
                            totalprice -=
                                Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                        }  if (
                              aTable.Rows[i]["CampaignName"].ToString().Trim() == "Special Rate [Aminobost]-Apr-24")
                        {
                            totalprice -=
                                Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                        }  if (
                              aTable.Rows[i]["CampaignName"].ToString().Trim() == "Special Rate [Triforce 1g IM]-Feb-24")
                        {
                            totalprice -=
                                Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                        }  if (
                              aTable.Rows[i]["CampaignName"].ToString().Trim() == "Special Rate [Triforce 500]-Feb-24")
                        {
                            totalprice -=
                                Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                        }
                    }
                }
                decimal percentage = 0;
                string PaymentType = "";
                string SubmissionDate = "";
                int CustTypeId = 0;


                // Frinds Hospital Start
                if (custCategoryTextBox.Text == "INSTITUTION"  ||  custCategoryTextBox.Text == "RCP")
                {
                    DataTable dttradepolicy = aOrderInfoBll.GetParcentFromOrderDetails(((HiddenField)gridLineItemGridView.Rows[0].Cells[1].FindControl("orderdetailIdHiddenField")).Value);
                    if (dttradepolicy.Rows.Count > 0)
                    {
                        percentage = Convert.ToDecimal(dttradepolicy.Rows[0]["DiscountPercent"].ToString());
                        PaymentType =  (dttradepolicy.Rows[0]["PaymentType"].ToString());
                        CustTypeId =  Convert.ToInt32(dttradepolicy.Rows[0]["CustTypeId"].ToString());
                        SubmissionDate =  (dttradepolicy.Rows[0]["SubmissionDate"].ToString());
                    }
                }


                else
                {

                    DataTable dttOrdr = aOrderInfoBll.GetParcentFromOrderDetails(((HiddenField)gridLineItemGridView.Rows[0].Cells[1].FindControl("orderdetailIdHiddenField")).Value);
                    if (dttOrdr.Rows.Count > 0)
                    {
                        percentage = Convert.ToDecimal(dttOrdr.Rows[0]["DiscountPercent"].ToString());
                        PaymentType = (dttOrdr.Rows[0]["PaymentType"].ToString());
                        CustTypeId = Convert.ToInt32(dttOrdr.Rows[0]["CustTypeId"].ToString());
                        SubmissionDate = (dttOrdr.Rows[0]["SubmissionDate"].ToString());
                    }
                    DataTable dtFixedCustomer = aOrderInfoBll.GetFixedCustomer(orderHiddenField.Value);
                    if (custCategoryTextBox.Text == "FCB FY-23-24")
                    {
                        //2
                        DataTable dttradepolicy = aOrderInfoBll.GetTradeTerm(totalprice.ToString(), CustTypeId, PaymentType, SubmissionDate);
                        if (dttradepolicy.Rows.Count > 0)
                        {
                            percentage = 0;

                        }
                    }
                    else
                    {
                        //1
                        DataTable dttradepolicy = aOrderInfoBll.GetTradeTerm(totalprice.ToString(), CustTypeId, PaymentType, SubmissionDate);
                        if (dttradepolicy.Rows.Count > 0)
                        {
                            //if (  ((HiddenField)gridLineItemGridView.Rows[i].Cells[10].FindControl("CampaignTypeHiddenField")).Value ="")
                            //{
                                
                            //}
                            //else
                            {
                                percentage = Convert.ToDecimal(dttradepolicy.Rows[0]["DiscountPerc"].ToString());
                                
                            }
                        }
                    }
                }
                // Frinds Hospital end

             

                // Campaing 

                decimal totaldiscount = 0;
                //  totaldiscount = (percentage * Convert.ToDecimal(tpTptalTextBox.Text)) / 100;
                disTotalTextBox.Text = totaldiscount.ToString();

                // Batch-load, once for the whole order, the two per-product datasets the loop
                // below used to re-query per line item (LoadProductQty, ProductDiscount).
                DataTable productQtyBatch = aInvoiceBll.LoadProductQtyBatch(orderIdHiddenField.Value);
                Dictionary<string, decimal> qtyByProductCode = new Dictionary<string, decimal>(StringComparer.OrdinalIgnoreCase);
                foreach (DataRow qtyRow in productQtyBatch.Rows)
                {
                    string qtyRowProductCode = qtyRow["ProductCode"] == DBNull.Value ? null : qtyRow["ProductCode"].ToString();
                    if (string.IsNullOrEmpty(qtyRowProductCode))
                    {
                        continue;
                    }
                    qtyByProductCode[qtyRowProductCode] = qtyRow["Qty"] == DBNull.Value ? 0 : Convert.ToDecimal(qtyRow["Qty"]);
                }
                DataTable productDiscountBatch = aOrderInfoBll.ProductDiscountBatch(orderProductCodes, hdCustomerMasterId.Value, invDateTextBox.Text);

                for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
                {
                    // ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text = ((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("IsCampaignProduct")).Text;
                    decimal cstock = 0;
                    decimal tqty = 0;
                    tqty = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("tQtyTextBox")).Text);
                    cstock =
                        Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text);
                    string rowProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
                    decimal batchedQty;
                    if (qtyByProductCode.TryGetValue(rowProductCode, out batchedQty))
                    {
                        tqty = batchedQty;
                    }
                    else
                    {
                        // Batch result didn't include this product for any reason — fall back to
                        // the original single-row call so behavior can never differ from before.
                        DataTable dtdata = aInvoiceBll.LoadProductQty(orderIdHiddenField.Value, rowProductCode);
                        tqty = Convert.ToDecimal(dtdata.Rows[0][0].ToString());
                    }
                    if (cstock < tqty)
                    {
                        gridLineItemGridView.Rows[i].BackColor = Color.Red;
                        /////////SMC Low Order Method//////////
                        //if (cstock != 0)
                        {
                            // showMessageBox("Stock Not Avaialable");
                            // saveButton.Visible = false;
                            GetQty(cstock, i);
                        }
                        ///////////////////////
                    }
                    //////// SMC Low Stock Method////////
                    //else
                    /////////////////
                    {
                        // ProductVat() result (dtproductvat) was fetched here but never consumed
                        // (its only use, line ~1030, is commented out) — removed as dead work,
                        // saves one DB round trip per order line with zero behavior change.
                        DataRow[] discountMatches = productDiscountBatch.Select(
                            "ProductCode = '" + rowProductCode.Replace("'", "''") + "'");
                        DataTable dtdiscount = productDiscountBatch.Clone();
                        foreach (DataRow matchRow in discountMatches)
                        {
                            dtdiscount.ImportRow(matchRow);
                        }
                        decimal percamount = 0;
                        if (dtdiscount.Rows.Count > 0)
                        {
                            percamount = Convert.ToDecimal(dtdiscount.Rows[0]["DiscountPercentage"].ToString());
                        }
                        decimal totalamount = 0;
                        totalamount = Convert.ToDecimal(tpTptalTextBox.Text);
                        decimal productamount = 0;
                        productamount =
                            Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        decimal productperc = 0;
                        //productperc = (productamount*100)/totalamount;
                        decimal mainper = 0;
                        //  mainper = (percentage * productperc) / 100;


                        // Frinds Hospital Start
                       // if (aTable.Rows[0]["CustomerCode"].ToString() == "158964" || aTable.Rows[0]["CustomerCode"].ToString() == "158399")
                        if (Convert.ToBoolean(aTable.Rows[0]["IsSpDis"]) == true)
                        {
                            DataTable aTable2 = new DataTable();
                            aTable2 = aOrderInfoBll.LoadOrderWithDetailFrindsHospital(orderId, ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value);
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text = Convert.ToDecimal(aTable2.Rows[0]["DiscountAmount"].ToString()).ToString(); 
                        }
                        

                        else
                        {
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
                        }

                        if (aTable.Rows[i]["CampaignName"].ToString() == "Bonus Campaign | Special Rate [Triforce 500]-Feb-24")
                        {

                            ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                                    aTable.Rows[i]["DiscountPercent"].ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                                 (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text) / 100)).ToString("F");
                        }
                        if (aTable.Rows[i]["CampaignName"].ToString() == "Bonus Campaign | Special Rate [Triforce 500]-Feb-24 ")
                        {

                            ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                                    aTable.Rows[i]["DiscountPercent"].ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                                 (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text) / 100)).ToString("F");
                        }
                        if (aTable.Rows[i]["CampaignName"].ToString() == "Bonus Campaign | Special Rate [Triforce 1g IM]-Feb-24 ")
                        {

                            ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                                    aTable.Rows[i]["DiscountPercent"].ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                                 (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text) / 100)).ToString("F");
                        }
                        if (aTable.Rows[i]["CampaignName"].ToString() == "Special Rate [Triforce 1g IM]-Feb-24 ")
                        {

                            ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                                    aTable.Rows[i]["DiscountPercent"].ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                                 (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text) / 100)).ToString("F");
                        }
                        if (aTable.Rows[i]["CampaignName"].ToString() == "Bonus Campaign | Special Rate [Triforce 1g IM]-Feb-24 ")
                        {

                            ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                                    aTable.Rows[i]["DiscountPercent"].ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                                 (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text) / 100)).ToString("F");
                        }


                        ///---------------------------------
                        ///



                        if (aTable.Rows[i]["CampaignName"].ToString().Trim() == "Bonus Campaign | Special Rate [Triforce 1g IM]-Feb-24")
                        {

                            ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                                    aTable.Rows[i]["DiscountPercent"].ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                                 (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text) / 100)).ToString("F");
                        }

                        if (aTable.Rows[i]["CampaignName"].ToString().Trim() == "Special Rate [Aminobost]-Apr-24")
                        {

                            ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                                    aTable.Rows[i]["DiscountPercent"].ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                                 (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text) / 100)).ToString("F");
                        }if (aTable.Rows[i]["CampaignName"].ToString().Trim() == "Bonus Campaign | Special Rate [Aminobost]-Apr-24")
                        {

                            ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                                    aTable.Rows[i]["DiscountPercent"].ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                                 (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text) / 100)).ToString("F");
                        }
                            if (aTable.Rows[i]["CampaignName"].ToString().Trim() == "Bonus Campaign | Special Rate [Triforce 1g IV]-Apr-24")
                        {

                            ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                                    aTable.Rows[i]["DiscountPercent"].ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                                 (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text) / 100)).ToString("F");
                        }
                              if (aTable.Rows[i]["CampaignName"].ToString().Trim() == "Bonus Campaign | Special Rate [Triforce 1g IV]-Apr-24")
                        {

                            ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                                    aTable.Rows[i]["DiscountPercent"].ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                                 (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text) / 100)).ToString("F");
                        }
                                     if (aTable.Rows[i]["CampaignName"].ToString().Trim() == "Special Rate [Triforce 1g IV]-Apr-24")
                        {

                            ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                                    aTable.Rows[i]["DiscountPercent"].ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                                 (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text) / 100)).ToString("F");
                        }
                                        if (aTable.Rows[i]["CampaignName"].ToString().Trim() == "Special Rate [Aminobost]-Apr-24")
                        {

                            ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                                    aTable.Rows[i]["DiscountPercent"].ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                                 (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text) / 100)).ToString("F");
                        }
       if (aTable.Rows[i]["CampaignName"].ToString().Trim() == "Special Rate [Triforce 1g IM]-Feb-24")
                        {

                            ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                                    aTable.Rows[i]["DiscountPercent"].ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                                 (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text) / 100)).ToString("F");
                        }
          if (aTable.Rows[i]["CampaignName"].ToString().Trim() == "Special Rate [Triforce 500]-Feb-24")
                        {

                            ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                                    aTable.Rows[i]["DiscountPercent"].ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                                (Convert.ToDecimal(
                                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                                 (Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text) / 100)).ToString("F");
                        }
          if (aTable.Rows[i]["CampaignName"].ToString().Trim() == "Ezevent Flat Rate Campaign | Dec-25"  ||  aTable.Rows[i]["CampaignName"].ToString().Trim() == "Esomium 20 Flat Rate Campaign | Mar-26" || aTable.Rows[i]["CampaignName"].ToString().Trim() == "Seacoral D Flat Rate Campaign | Apr-26")
                        {

                            // tpTextBox = মূল দাম (Total Price)
                            // dpAmtTextBox = ডিসকাউন্ট এমাউন্ট
                            // dpTextBox = ডিসকাউন্ট পারসেন্টেজ

                            var tpTxt = (TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("tpTextBox");
                            var dpAmtTxt = (TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpAmtTextBox");
                            var dpTxt = (TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox");

                            decimal tp = 0m, dpAmt = 0m;

                            decimal.TryParse(tpTxt.Text.Trim(), out tp);
                            decimal.TryParse(aTable.Rows[i]["DiscountAmount"].ToString().Trim(), out dpAmt);

                            decimal dpPercent = 0m;
                            if (tp > 0)
                            {
                                dpPercent = (dpAmt / tp) * 100m;
                            }

                            // tpTextBox = মূল দাম
                            tpTxt.Text = tp.ToString("0.00");

                            // dpAmtTextBox = ডিসকাউন্ট
                            dpAmtTxt.Text = dpAmt.ToString("0.00");

                            // dpTextBox = ডিসকাউন্ট শতাংশ
                            dpTxt.Text = dpPercent.ToString("0.00");

                        }

                        ////---------------------
                        // Frinds Hospital End

                        // Resectin FOC Offer Discount End//

                        //////////Modified Version/////////////
                        //decimal vat = 0;
                        //vat = Convert.ToDecimal(dtproductvat.Rows[0]["VATPercentage"].ToString());
                        //((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                        //    (Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text)*
                        //     (percamount/100)).ToString();

                        decimal withdiscount = 0;
                        withdiscount =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                             Convert.ToDecimal(
                                 (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)));
                        //-
                        // Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text));
                        decimal vatamount = 0;
                        //vatamount = (Convert.ToDecimal(
                        //    ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim())*vat)/100;
                        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox");
                        //tpVatTextBox.Text = vatamount.ToString("F");
                        //((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                        //    (Convert.ToDecimal(((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text)*
                        //     (percamount/100)).ToString();

                        //amTextBox
                        //ddddddddddddd
                        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");


                        

                        //AdjustmentAmount();

                        decimal tpTextBox = 0;
                        try
                        {
                            tpTextBox = Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim());
                        }
                        catch
                        {

                        }
                        decimal dpAmtTextBox = 0;
                        try
                        {

                            dpAmtTextBox = Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                                   .Text.Trim());

                        }
                        catch
                        {

                        }

                        decimal amTextBox = 0;
                        try
                        {

                            amTextBox = Convert.ToDecimal(
                                               ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("amTextBox"))
                                                   .Text.Trim());

                        }
                        catch
                        {

                        }

                        decimal tpVat = 0;
                        try
                        {

                            tpVat = Convert.ToDecimal(tpVatTextBox.Text);

                        }
                        catch
                        {

                        }

                       decimal rS = (tpTextBox - (dpAmtTextBox + amTextBox)) + tpVat;
                        npTextBox.Text = rS.ToString();

                        if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text == "True"

                            && ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("bQtyTextBox")).Text == "True")
                        {

                            ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("npTextBox")).Text = 0.ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("tpVatTextBox")).Text = 0.ToString();
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("tpTextBox")).Text = 0.ToString();
                            //(TextBox) gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox").te = 0;
                        }

                        TotalValueCalculation();
                    }
                }
                GetDiscounttotalValue();
            }
            if (gridLineItemGridView.Rows.Count == aTable.Rows.Count)
            {
                
            }
            else
            {
                Response.Redirect("InvoiceCreationByOrder.aspx");

            }
        }
        else
        {
            showMessageBox("Order Information already Exists !!");
        }
    }

    private void GetOrderDetailValue(string orderId)
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        DataTable aTable = new DataTable();
        aTable = aOrderInfoBll.LoadOrderWithDetail(orderId);

        for (int i = 0; i < aTable.Rows.Count; i++)
        {
            ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value =
                aTable.Rows[i]["OrderDetailId"].ToString();
        }
    }

    private void GetDiscounttotalValue()
    {
        decimal disTotal = 0;
        decimal tqty = 0;

        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            tqty = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("tQtyTextBox")).Text);

            //if (((TextBox) gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB08" && tqty >= 3)
            //{
            //    disTotal = 0;
            //    //(((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text != "") ? Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text) : 0;
            //}
            //else
            {
                disTotal += (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text != "")
                    ? Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)
                    : 0;
            }
        }
        disTotalTextBox.Text = disTotal.ToString();
    }

    //FOC Bonus Qty Start//
    private bool B()
    {
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
            int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
            if (ProductCode == "AID01" && Qty >= 4)
            {

                return true;
            }
        }
        return false;
    }
    private bool B2()
    {
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
            int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
            if (ProductCode == "AEL02" && Qty >= 3)
            {

                return true;
            }
        }
        return false;
    }
    private bool B4()
    {
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
            int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
            if (ProductCode == "AID04" && Qty >= 5)
            {

                return true;
            }
        }
        return false;
    }
    private bool B3()
    {
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
            int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
            if (ProductCode == "OAD04" && Qty >= 2)
            {

                return true;
            }
        }
        return false;
    }
    private bool B5()
    {
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
            int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);
            if (ProductCode == "MNS03" && Qty >= 5)
            {

                return true;
            }
        }
        return false;
    }
    private bool B6()
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
    //FOC Bonus Qty End//

    protected void custCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        string custCode = custCodeTextBox.Text.Trim();
        GetCustInfo(custCode,orderNoTextBox.Text.Trim());
    }

    private void InitialGrid()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("OrderDetailsId");
        aDataTable.Columns.Add("StockQty");
        aDataTable.Columns.Add("SpecialAmount");
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
        aDataTable.Columns.Add("ISGiftProduct");
        aDataTable.Columns.Add("IsCampaignProduct");
        aDataTable.Columns.Add("CampaignType");
        DataRow dataRow;

        dataRow = aDataTable.NewRow();

        dataRow["SL"] = "1";
        dataRow["ProductCode"] = "";
        dataRow["ProductName"] = "";
        dataRow["SpecialAmount"] = "";
        dataRow["OrderDetailsId"] = "";
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
        dataRow["ISGiftProduct"] = "";
        dataRow["IsCampaignProduct"] = "";
        dataRow["CampaignType"] = "";
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
        aDataTable.Columns.Add("SpecialAmount");
       
        aDataTable.Columns.Add("BonusQty");
        aDataTable.Columns.Add("TotalQty");
        aDataTable.Columns.Add("OrderDetailsId");
        aDataTable.Columns.Add("ISGiftProduct");
        aDataTable.Columns.Add("IsCampaignProduct");
        aDataTable.Columns.Add("CampaignType");
        
        DataRow dataRow;

        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                dataRow = aDataTable.NewRow();

                dataRow["SL"] = Convert.ToString(i + 1);
                dataRow["ProductCode"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text.Trim();
                dataRow["OrderDetailsId"] = ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value.Trim();
                dataRow["IsCampaignProduct"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text.Trim();
                dataRow["ProductName"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[2].FindControl("nameTextBox")).Text.Trim();
                dataRow["StockQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text.Trim();
                dataRow["UnitPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox")).Text.Trim();
                dataRow["UnitVAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[5].FindControl("upVatTextBox")).Text.Trim(); ;
                dataRow["Quantity"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[6].FindControl("qtyTextBox")).Text.Trim();
                dataRow["TotalPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim();
                dataRow["VAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text.Trim();
                dataRow["DiscountPercentage"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text.Trim();
                dataRow["DiscountAmount"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text.Trim();
                dataRow["NetPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text.Trim();
               // dataRow["BonusQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim();
                dataRow["TotalQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text.Trim();
                dataRow["ISGiftProduct"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim();

                dataRow["CampaignType"] = ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("CampaignTypeHiddenField")).Value.Trim();
                    //((TextBox)gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text.Trim();
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
        dataRow["SpecialAmount"] = "";
        dataRow["NetPrice"] = "";
        dataRow["BonusQty"] = "";
        dataRow["TotalQty"] = "";
        dataRow["ISGiftProduct"] = "";
        dataRow["IsCampaignProduct"] = "";
        dataRow["CampaignType"] = "";
        aDataTable.Rows.Add(dataRow);

        gridLineItemGridView.DataSource = null;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.DataSource = aDataTable;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.Columns[4].Visible = false;
        gridLineItemGridView.Columns[5].Visible = false;
    }
    protected void addImageButton_Click6(object sender, ImageClickEventArgs e)
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
        aDataTable.Columns.Add("SpecialAmount");

        DataRow dataRow;

        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                dataRow = aDataTable.NewRow();

                dataRow["SL"] = Convert.ToString(i + 1);
                dataRow["ProductCode"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text.Trim();
                dataRow["ProductName"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[2].FindControl("nameTextBox")).Text.Trim();
                dataRow["StockQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text.Trim();
                dataRow["UnitPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox")).Text.Trim();
                dataRow["UnitVAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[5].FindControl("upVatTextBox")).Text.Trim(); ;
                dataRow["Quantity"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[6].FindControl("qtyTextBox")).Text.Trim();
                dataRow["TotalPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim();
                dataRow["VAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text.Trim();
                dataRow["DiscountPercentage"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text.Trim();
                dataRow["DiscountAmount"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text.Trim();
                dataRow["NetPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text.Trim();
                dataRow["BonusQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim();
                dataRow["TotalQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text.Trim();
                dataRow["OrderDetailsId"] = ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value;
                aDataTable.Rows.Add(dataRow);
            }
        }

        decimal cs = 0;
        DataTable aDataTable2 = new DataTable();
        aDataTable2 = aInvoiceBll.ProductInfo(hdComUnitId.Value, "FGD02");

        if (aDataTable2.Rows.Count > 0)
        {
            cs = Convert.ToDecimal(aDataTable2.Rows[0]["StockQty"].ToString());
        }


        int sl = aDataTable.Rows.Count;
        dataRow = aDataTable.NewRow();

        dataRow["SL"] = Convert.ToString(sl + 1);
        dataRow["ProductCode"] = "FGD02";
        dataRow["ProductName"] = "Moticare 10mg:FGD02 ";
        dataRow["StockQty"] = cs;
        dataRow["UnitPrice"] = "0";
        dataRow["UnitVAT"] = "0";
        dataRow["Quantity"] = Qty6();
        dataRow["TotalPrice"] = "0";
        dataRow["VAT"] = "0";
        dataRow["DiscountPercentage"] = "0";
        dataRow["DiscountAmount"] = "0";
        dataRow["NetPrice"] = "0";
        dataRow["BonusQty"] = "0";
        dataRow["TotalQty"] = Qty6();
        dataRow["OrderDetailsId"] = "0";
        dataRow["SpecialAmount"] = "0";

        aDataTable.Rows.Add(dataRow);

        gridLineItemGridView.DataSource = null;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.DataSource = aDataTable;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.Columns[4].Visible = false;
        gridLineItemGridView.Columns[5].Visible = false;
    }
    protected void addImageButton_Click5(object sender, ImageClickEventArgs e)
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
        aDataTable.Columns.Add("SpecialAmount");

        DataRow dataRow;

        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                dataRow = aDataTable.NewRow();

                dataRow["SL"] = Convert.ToString(i + 1);
                dataRow["ProductCode"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text.Trim();
                dataRow["ProductName"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[2].FindControl("nameTextBox")).Text.Trim();
                dataRow["StockQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text.Trim();
                dataRow["UnitPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox")).Text.Trim();
                dataRow["UnitVAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[5].FindControl("upVatTextBox")).Text.Trim(); ;
                dataRow["Quantity"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[6].FindControl("qtyTextBox")).Text.Trim();
                dataRow["TotalPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim();
                dataRow["VAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text.Trim();
                dataRow["DiscountPercentage"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text.Trim();
                dataRow["DiscountAmount"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text.Trim();
                dataRow["NetPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text.Trim();
                dataRow["BonusQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim();
                dataRow["TotalQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text.Trim();
                dataRow["OrderDetailsId"] = ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value;
                aDataTable.Rows.Add(dataRow);
            }
        }

        decimal cs = 0;
        DataTable aDataTable2 = new DataTable();
        aDataTable2 = aInvoiceBll.ProductInfo(hdComUnitId.Value, "MNS03");

        if (aDataTable2.Rows.Count > 0)
        {
            cs = Convert.ToDecimal(aDataTable2.Rows[0]["StockQty"].ToString());
        }


        int sl = aDataTable.Rows.Count;
        dataRow = aDataTable.NewRow();

        dataRow["SL"] = Convert.ToString(sl + 1);
        dataRow["ProductCode"] = "MNS03";
        dataRow["ProductName"] = "Seacoral D Tablet:6 X 10s ";
        dataRow["StockQty"] = cs;
        dataRow["UnitPrice"] = "0";
        dataRow["UnitVAT"] = "0";
        dataRow["Quantity"] = Qty5();
        dataRow["TotalPrice"] = "0";
        dataRow["VAT"] = "0";
        dataRow["DiscountPercentage"] = "0";
        dataRow["DiscountAmount"] = "0";
        dataRow["NetPrice"] = "0";
        dataRow["BonusQty"] = "0";
        dataRow["TotalQty"] = Qty5();
        dataRow["OrderDetailsId"] = "0";
        dataRow["SpecialAmount"] = "0";

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
        aDataTable.Columns.Add("OrderDetailsId");
        aDataTable.Columns.Add("SpecialAmount");

        DataRow dataRow;

        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                dataRow = aDataTable.NewRow();

                dataRow["SL"] = Convert.ToString(i + 1);
                dataRow["ProductCode"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text.Trim();
                dataRow["ProductName"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[2].FindControl("nameTextBox")).Text.Trim();
                dataRow["StockQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text.Trim();
                dataRow["UnitPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox")).Text.Trim();
                dataRow["UnitVAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[5].FindControl("upVatTextBox")).Text.Trim(); ;
                dataRow["Quantity"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[6].FindControl("qtyTextBox")).Text.Trim();
                dataRow["TotalPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim();
                dataRow["VAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text.Trim();
                dataRow["DiscountPercentage"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text.Trim();
                dataRow["DiscountAmount"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text.Trim();
                dataRow["NetPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text.Trim();
                dataRow["BonusQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim();
                dataRow["TotalQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text.Trim();
                dataRow["OrderDetailsId"] = ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value;
                aDataTable.Rows.Add(dataRow);
            }
        }

        decimal cs = 0;
        DataTable aDataTable2 = new DataTable();
        aDataTable2 = aInvoiceBll.ProductInfo(hdComUnitId.Value, "AID01");

        if (aDataTable2.Rows.Count > 0)
        {
            cs = Convert.ToDecimal(aDataTable2.Rows[0]["StockQty"].ToString());
        }


        int sl = aDataTable.Rows.Count;
        dataRow = aDataTable.NewRow();

        dataRow["SL"] = Convert.ToString(sl + 1);
        dataRow["ProductCode"] = "AID01";
        dataRow["ProductName"] = "Flexidol Tablet~100mg :10 X 10s ";
        dataRow["StockQty"] = cs;
        dataRow["UnitPrice"] = "0";
        dataRow["UnitVAT"] = "0";
        dataRow["Quantity"] = Qty();
        dataRow["TotalPrice"] = "0";
        dataRow["VAT"] = "0";
        dataRow["DiscountPercentage"] = "0";
        dataRow["DiscountAmount"] = "0";
        dataRow["NetPrice"] = "0";
        dataRow["BonusQty"] = "0";
        dataRow["TotalQty"] = Qty();
        dataRow["OrderDetailsId"] = "0";
        dataRow["SpecialAmount"] = "0";

        aDataTable.Rows.Add(dataRow);

        gridLineItemGridView.DataSource = null;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.DataSource = aDataTable;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.Columns[4].Visible = false;
        gridLineItemGridView.Columns[5].Visible = false;
    }
    protected void addImageButton_Click2(object sender, ImageClickEventArgs e)
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
        aDataTable.Columns.Add("SpecialAmount");

        DataRow dataRow;

        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                dataRow = aDataTable.NewRow();

                dataRow["SL"] = Convert.ToString(i + 1);
                dataRow["ProductCode"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text.Trim();
                dataRow["ProductName"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[2].FindControl("nameTextBox")).Text.Trim();
                dataRow["StockQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text.Trim();
                dataRow["UnitPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox")).Text.Trim();
                dataRow["UnitVAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[5].FindControl("upVatTextBox")).Text.Trim(); ;
                dataRow["Quantity"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[6].FindControl("qtyTextBox")).Text.Trim();
                dataRow["TotalPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim();
                dataRow["VAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text.Trim();
                dataRow["DiscountPercentage"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text.Trim();
                dataRow["DiscountAmount"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text.Trim();
                dataRow["NetPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text.Trim();
                dataRow["BonusQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim();
                dataRow["TotalQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text.Trim();
                dataRow["OrderDetailsId"] = ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value;
                aDataTable.Rows.Add(dataRow);
            }
        }

        decimal cs = 0;
        DataTable aDataTable2 = new DataTable();
        aDataTable2 = aInvoiceBll.ProductInfo(hdComUnitId.Value, "AEL02");

        if (aDataTable2.Rows.Count > 0)
        {
            cs = Convert.ToDecimal(aDataTable2.Rows[0]["StockQty"].ToString());
        }


        int sl = aDataTable.Rows.Count;
        dataRow = aDataTable.NewRow();

        dataRow["SL"] = Convert.ToString(sl + 1);
        dataRow["ProductCode"] = "AEL02";
        dataRow["ProductName"] = "Nervaid 75mg Capsule:6 X 10s ";
        dataRow["StockQty"] = cs;
        dataRow["UnitPrice"] = "0";
        dataRow["UnitVAT"] = "0";
        dataRow["Quantity"] = Qty2();
        dataRow["TotalPrice"] = "0";
        dataRow["VAT"] = "0";
        dataRow["DiscountPercentage"] = "0";
        dataRow["DiscountAmount"] = "0";
        dataRow["NetPrice"] = "0";
        dataRow["BonusQty"] = "0";
        dataRow["TotalQty"] = Qty2();
        dataRow["OrderDetailsId"] = "0";
        dataRow["SpecialAmount"] = "0";

        aDataTable.Rows.Add(dataRow);

        gridLineItemGridView.DataSource = null;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.DataSource = aDataTable;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.Columns[4].Visible = false;
        gridLineItemGridView.Columns[5].Visible = false;
    }
    protected void addImageButton_Click3(object sender, ImageClickEventArgs e)
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
        aDataTable.Columns.Add("SpecialAmount");

        DataRow dataRow;

        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                dataRow = aDataTable.NewRow();

                dataRow["SL"] = Convert.ToString(i + 1);
                dataRow["ProductCode"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text.Trim();
                dataRow["ProductName"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[2].FindControl("nameTextBox")).Text.Trim();
                dataRow["StockQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text.Trim();
                dataRow["UnitPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox")).Text.Trim();
                dataRow["UnitVAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[5].FindControl("upVatTextBox")).Text.Trim(); ;
                dataRow["Quantity"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[6].FindControl("qtyTextBox")).Text.Trim();
                dataRow["TotalPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim();
                dataRow["VAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text.Trim();
                dataRow["DiscountPercentage"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text.Trim();
                dataRow["DiscountAmount"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text.Trim();
                dataRow["NetPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text.Trim();
                dataRow["BonusQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim();
                dataRow["TotalQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text.Trim();
                dataRow["OrderDetailsId"] = ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value;
                aDataTable.Rows.Add(dataRow);
            }
        }

        decimal cs = 0;
        DataTable aDataTable2 = new DataTable();
        aDataTable2 = aInvoiceBll.ProductInfo(hdComUnitId.Value, "OAD04");

        if (aDataTable2.Rows.Count > 0)
        {
            cs = Convert.ToDecimal(aDataTable2.Rows[0]["StockQty"].ToString());
        }


        int sl = aDataTable.Rows.Count;
        dataRow = aDataTable.NewRow();

        dataRow["SL"] = Convert.ToString(sl + 1);
        dataRow["ProductCode"] = "OAD04";
        dataRow["ProductName"] = "Maxivent 400 mg Tablet:3 X 10s ";
        dataRow["StockQty"] = cs;
        dataRow["UnitPrice"] = "0";
        dataRow["UnitVAT"] = "0";
        dataRow["Quantity"] = Qty3();
        dataRow["TotalPrice"] = "0";
        dataRow["VAT"] = "0";
        dataRow["DiscountPercentage"] = "0";
        dataRow["DiscountAmount"] = "0";
        dataRow["NetPrice"] = "0";
        dataRow["BonusQty"] = "0";
        dataRow["TotalQty"] = Qty3();
        dataRow["OrderDetailsId"] = "0";
        dataRow["SpecialAmount"] = "0";

        aDataTable.Rows.Add(dataRow);

        gridLineItemGridView.DataSource = null;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.DataSource = aDataTable;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.Columns[4].Visible = false;
        gridLineItemGridView.Columns[5].Visible = false;
    }
    protected void addImageButton_Click4(object sender, ImageClickEventArgs e)
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
        aDataTable.Columns.Add("SpecialAmount");

        DataRow dataRow;

        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                dataRow = aDataTable.NewRow();

                dataRow["SL"] = Convert.ToString(i + 1);
                dataRow["ProductCode"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text.Trim();
                dataRow["ProductName"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[2].FindControl("nameTextBox")).Text.Trim();
                dataRow["StockQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text.Trim();
                dataRow["UnitPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox")).Text.Trim();
                dataRow["UnitVAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[5].FindControl("upVatTextBox")).Text.Trim(); ;
                dataRow["Quantity"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[6].FindControl("qtyTextBox")).Text.Trim();
                dataRow["TotalPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim();
                dataRow["VAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text.Trim();
                dataRow["DiscountPercentage"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text.Trim();
                dataRow["DiscountAmount"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text.Trim();
                dataRow["NetPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text.Trim();
                dataRow["BonusQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim();
                dataRow["TotalQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text.Trim();
                dataRow["OrderDetailsId"] = ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value;
                aDataTable.Rows.Add(dataRow);
            }
        }

        decimal cs = 0;
        DataTable aDataTable2 = new DataTable();
        aDataTable2 = aInvoiceBll.ProductInfo(hdComUnitId.Value, "AID04");

        if (aDataTable2.Rows.Count > 0)
        {
            cs = Convert.ToDecimal(aDataTable2.Rows[0]["StockQty"].ToString());
        }


        int sl = aDataTable.Rows.Count;
        dataRow = aDataTable.NewRow();

        dataRow["SL"] = Convert.ToString(sl + 1);
        dataRow["ProductCode"] = "AID04";
        dataRow["ProductName"] = "Ezepain 90 mg Tablet :3 X 10s ";
        dataRow["StockQty"] = cs;
        dataRow["UnitPrice"] = "0";
        dataRow["UnitVAT"] = "0";
        dataRow["Quantity"] = Qty4();
        dataRow["TotalPrice"] = "0";
        dataRow["VAT"] = "0";
        dataRow["DiscountPercentage"] = "0";
        dataRow["DiscountAmount"] = "0";
        dataRow["NetPrice"] = "0";
        dataRow["BonusQty"] = "0";
        dataRow["TotalQty"] = Qty4();
        dataRow["OrderDetailsId"] = "0";
        dataRow["SpecialAmount"] = "0";

        aDataTable.Rows.Add(dataRow);

        gridLineItemGridView.DataSource = null;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.DataSource = aDataTable;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.Columns[4].Visible = false;
        gridLineItemGridView.Columns[5].Visible = false;
    }

    private int Qty()
    {
        int Bqty = 0;

        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
            int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);

            DataTable aDataTableBQty = new DataTable();
            if (ProductCode == "AID01")
            {
                aDataTableBQty = aInvoiceBll.ProductFocBonusQtyBLL(Convert.ToDateTime(DateTime.Today.ToShortDateString()).ToString("dd-MMM-yyyy"), ProductCode, Qty);
                if (aDataTableBQty.Rows.Count > 0)
                {
                    return Bqty = Convert.ToInt16(aDataTableBQty.Rows[0]["BonusQty"]);
                }
            }
        }
        return 0;
    }
    private int Qty5()
    {
        int Bqty = 0;

        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
            int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);

            DataTable aDataTableBQty = new DataTable();
            if (ProductCode == "MNS03")
            {
                aDataTableBQty = aInvoiceBll.ProductFocBonusQtyBLL(Convert.ToDateTime(DateTime.Today.ToShortDateString()).ToString("dd-MMM-yyyy"), ProductCode, Qty);
                if (aDataTableBQty.Rows.Count > 0)
                {
                    return Bqty = Convert.ToInt16(aDataTableBQty.Rows[0]["BonusQty"]);
                }
            }
        }
        return 0;
    }
    private int Qty6()
    {
        int Bqty = 0;

        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
            int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);

            DataTable aDataTableBQty = new DataTable();
            if (ProductCode == "FGD02")
            {
                aDataTableBQty = aInvoiceBll.ProductFocBonusQtyBLL(Convert.ToDateTime(DateTime.Today.ToShortDateString()).ToString("dd-MMM-yyyy"), ProductCode, Qty);
                if (aDataTableBQty.Rows.Count > 0)
                {
                    return Bqty = Convert.ToInt16(aDataTableBQty.Rows[0]["BonusQty"]);
                }
            }
        }
        return 0;
    }
    private int Qty4()
    {
        int Bqty = 0;

        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
            int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);

            DataTable aDataTableBQty = new DataTable();
            if (ProductCode == "AID04")
            {
                aDataTableBQty = aInvoiceBll.ProductFocBonusQtyBLL(Convert.ToDateTime(DateTime.Today.ToShortDateString()).ToString("dd-MMM-yyyy"), ProductCode, Qty);
                if (aDataTableBQty.Rows.Count > 0)
                {
                    return Bqty = Convert.ToInt16(aDataTableBQty.Rows[0]["BonusQty"]);
                }
            }
        }
        return 0;
    }
    private int Qty2()
    {
        int Bqty = 0;

        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
            int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);

            DataTable aDataTableBQty = new DataTable();
            if (ProductCode == "AEL02")
            {
                aDataTableBQty = aInvoiceBll.ProductFocBonusQtyBLL(Convert.ToDateTime(DateTime.Today.ToShortDateString()).ToString("dd-MMM-yyyy"), ProductCode, Qty);
                if (aDataTableBQty.Rows.Count > 0)
                {
                    return Bqty = Convert.ToInt16(aDataTableBQty.Rows[0]["BonusQty"]);
                }
            }
        }
        return 0;
    }
    private int Qty3()
    {
        int Bqty = 0;

        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string ProductCode = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
            int Qty = Convert.ToInt32(((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("qtyTextBox")).Text);

            DataTable aDataTableBQty = new DataTable();
            if (ProductCode == "OAD04")
            {
                aDataTableBQty = aInvoiceBll.ProductFocBonusQtyBLL(Convert.ToDateTime(DateTime.Today.ToShortDateString()).ToString("dd-MMM-yyyy"), ProductCode, Qty);
                if (aDataTableBQty.Rows.Count > 0)
                {
                    return Bqty = Convert.ToInt16(aDataTableBQty.Rows[0]["BonusQty"]);
                }
            }
        }
        return 0;
    }
    protected void removeImageButton_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton productCodeTextBox = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
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
                    dataRow["ProductCode"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text.Trim();
                    dataRow["ProductName"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[2].FindControl("nameTextBox")).Text.Trim();
                    dataRow["StockQty"] =
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text.Trim();
                    dataRow["UnitPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox")).Text.Trim();
                    dataRow["UnitVAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[5].FindControl("upVatTextBox")).Text.Trim(); ;
                    dataRow["Quantity"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[6].FindControl("qtyTextBox")).Text.Trim();
                    dataRow["TotalPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim();
                    dataRow["VAT"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text.Trim();
                    dataRow["DiscountPercentage"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text.Trim();
                    dataRow["DiscountAmount"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text.Trim();
                    dataRow["NetPrice"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text.Trim();
                    dataRow["BonusQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim();
                    dataRow["TotalQty"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[13].FindControl("tQtyTextBox")).Text.Trim();
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
        TextBox TextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        TextBox productCodeTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox");

        string productCode = productCodeTextBox.Text.Trim();
        GetProduct(rowindex, productCode);
    }

    private void GetProduct(int rowindex, string productCode)
    {
        if (string.IsNullOrEmpty(productCode))
        {
            return;
        }

        if (ProductCodeValidation(productCode, rowindex) != true)
        {
            ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[2].FindControl("nameTextBox")).Text = "";
            ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox")).Text = "";
            showMessageBox(productCode + " No: Product Already Inserted!!!");
            return;
        }

        DataTable aDataTable = aInvoiceBll.ProductInfo(hdComUnitId.Value, productCode);
        ApplyProductInfoToRow(rowindex, productCode, aDataTable);
    }

    /// Same as GetProduct(rowindex, productCode) but looks the product up in a batch-loaded
    /// DataTable (one query for the whole order, see LoadAllDataByOrder) instead of issuing a
    /// fresh DB call per grid row. Falls back to the original single-row DB call if the batch
    /// result doesn't contain the product for any reason, so output can never differ from before.
    private void GetProduct(int rowindex, string productCode, DataTable batchProductInfo)
    {
        if (string.IsNullOrEmpty(productCode))
        {
            return;
        }

        if (ProductCodeValidation(productCode, rowindex) != true)
        {
            ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[2].FindControl("nameTextBox")).Text = "";
            ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox")).Text = "";
            showMessageBox(productCode + " No: Product Already Inserted!!!");
            return;
        }

        DataRow[] matches = batchProductInfo == null
            ? new DataRow[0]
            : batchProductInfo.Select("ProductCode = '" + productCode.Replace("'", "''") + "'");

        DataTable aDataTable;
        if (matches.Length > 0)
        {
            aDataTable = matches[0].Table.Clone();
            aDataTable.ImportRow(matches[0]);
        }
        else
        {
            aDataTable = aInvoiceBll.ProductInfo(hdComUnitId.Value, productCode);
        }

        ApplyProductInfoToRow(rowindex, productCode, aDataTable);
    }

    private void ApplyProductInfoToRow(int rowindex, string productCode, DataTable aDataTable)
    {
        ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox")).Text = productCode;
        if (aDataTable.Rows.Count > 0)
        {
            TextBox nameTextBox =
                (TextBox)gridLineItemGridView.Rows[rowindex].Cells[2].FindControl("nameTextBox");
            nameTextBox.Text = aDataTable.Rows[0]["ProductName"].ToString();
            TextBox currentStockTextBox =
                (TextBox)gridLineItemGridView.Rows[rowindex].Cells[3].FindControl("currentStockTextBox");
            currentStockTextBox.Text = aDataTable.Rows[0]["StockQty"].ToString();
            TextBox unitPriceTextBox =
                (TextBox)gridLineItemGridView.Rows[rowindex].Cells[4].FindControl("unitPriceTextBox");
            unitPriceTextBox.Text = aDataTable.Rows[0]["UnitPrice"].ToString();
            TextBox upVatTextBox =
                (TextBox)gridLineItemGridView.Rows[rowindex].Cells[5].FindControl("upVatTextBox");
            upVatTextBox.Text = aDataTable.Rows[0]["VAT"].ToString();
        }
        else
        {
            ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[2].FindControl("nameTextBox")).Text = "";
            ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox")).Text = "";
            showMessageBox("No Any Stock or Product of " + productCode);
        }
    }

    private bool ProductCodeValidation(string productCode, int rowindex)
    {

        //for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        //{
        //    if (rowindex!=i)
        //    {
        //        if (((TextBox) gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text.Trim() ==
        //            productCode.Trim())
        //        {
        //            return false;
        //        }
        //    }
        //}

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

        TextBox qtyTextBox1 = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[6].FindControl("qtyTextBox");
        qtyTextBox1.Text = qty.ToString();

        TextBox unitPriceTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[4].FindControl("unitPriceTextBox");
        TextBox upVatTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[5].FindControl("upVatTextBox");

        TextBox tpTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[7].FindControl("tpTextBox");
        tpTextBox.Text = Convert.ToString(Convert.ToDecimal(unitPriceTextBox.Text.Trim()) * qty);

        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[8].FindControl("tpVatTextBox");
        tpVatTextBox.Text = Convert.ToString(Convert.ToDecimal(upVatTextBox.Text.Trim()) * qty);

        TextBox codeTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox");

        decimal discountPer = 0;
        //discountPer = aInvoiceBll.ProductDiscount(codeTextBox.Text.Trim(), qtyTextBox1.Text.Trim());

        TextBox dpTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[9].FindControl("dpTextBox");
        dpTextBox.Text = Convert.ToString(discountPer);
        TextBox dpAmtTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[10].FindControl("dpAmtTextBox");
        if (discountPer == 0)
        {
            dpAmtTextBox.Text = "0";
        }
        else
        {
            dpAmtTextBox.Text = Convert.ToString((Convert.ToDecimal(tpTextBox.Text.Trim()) / 100) * discountPer);
        }

        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[11].FindControl("npTextBox");
        npTextBox.Text = Convert.ToString((Convert.ToDecimal(tpTextBox.Text.Trim()) - Convert.ToDecimal(dpAmtTextBox.Text.Trim())) + Convert.ToDecimal(tpVatTextBox.Text.Trim()));

        ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[13].FindControl("tQtyTextBox")).Text = qtyTextBox1.Text.Trim();
        ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[12].FindControl("bQtyTextBox")).Text = "0";

        TotalValueCalculation();
    }
    protected void qtyTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox qtyTextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)qtyTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        decimal qty = 0;
        TextBox qtyTextBox1 = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[6].FindControl("qtyTextBox");
        qty = Convert.ToDecimal(qtyTextBox1.Text.Trim());

        TextBox unitPriceTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[4].FindControl("unitPriceTextBox");
        TextBox upVatTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[5].FindControl("upVatTextBox");

        TextBox tpTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[7].FindControl("tpTextBox");
        tpTextBox.Text = Convert.ToString(Convert.ToDecimal(unitPriceTextBox.Text.Trim()) * qty);

        TextBox tpVatTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[8].FindControl("tpVatTextBox");
        tpVatTextBox.Text = Convert.ToString(Convert.ToDecimal(upVatTextBox.Text.Trim()) * qty);

        TextBox codeTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox");

        decimal discountPer = 0;
        discountPer = aInvoiceBll.ProductDiscount(codeTextBox.Text.Trim(), qtyTextBox1.Text.Trim());

        TextBox dpTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[9].FindControl("dpTextBox");
        dpTextBox.Text = Convert.ToString(discountPer);
        TextBox dpAmtTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[10].FindControl("dpAmtTextBox");
        if (discountPer == 0)
        {
            dpAmtTextBox.Text = "0";
        }
        else
        {
            dpAmtTextBox.Text = Convert.ToString((Convert.ToDecimal(tpTextBox.Text.Trim()) / 100) * discountPer);
        }

        TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[11].FindControl("npTextBox");
        npTextBox.Text = Convert.ToString((Convert.ToDecimal(tpTextBox.Text.Trim()) - Convert.ToDecimal(dpAmtTextBox.Text.Trim())) + Convert.ToDecimal(tpVatTextBox.Text.Trim()));

        ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[13].FindControl("tQtyTextBox")).Text = qtyTextBox1.Text.Trim();
        ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[12].FindControl("bQtyTextBox")).Text = "0";
        TotalValueCalculation();
    }
    protected void bQtyTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox bQtyTextBox1 = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)bQtyTextBox1.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[13].FindControl("tQtyTextBox")).Text =
            Convert.ToString(
                Convert.ToDecimal(
                    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[12].FindControl("bQtyTextBox")).Text.Trim()) +
                Convert.ToDecimal(
                    ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[13].FindControl("tQtyTextBox")).Text.Trim()));

    }
    public void SaveReturnAmount(int invid, SqlTransaction transaction)
    {
        ReturnAmountDAO amountDao = new ReturnAmountDAO()
        {
            CustomerId = Convert.ToInt32(hdCustomerMasterId.Value),
            Amount = Convert.ToDecimal(crAmountTextBox.Text)*(-1),
          //  ReturnInvoiceId = invid,
            InvoiceId = Convert.ToInt32(invid)
        };
        bool status = aInvoiceBll.SaveDataForReturnAmount(amountDao, transaction);

    }

    /// Acquires a session-scoped exclusive app lock so ID generation runs one at a time
    /// across ALL orders. This is required because tblInvoice.InvoiceId / tblInvoiceDetail.InvoiceDetailId
    /// are generated via "SELECT MAX(col)+1" (ClsPrimaryKeyFind), which has no row-level locking of its
    /// own: two concurrent Submits for different orders could otherwise compute the same next ID and
    /// collide, and two concurrent Submits for the SAME order could both pass the
    /// "invoice not yet created" check before either commits.
    /// Session-owned (not Transaction-owned) so it can be released via ReleaseOrderSubmitLock as soon as
    /// the invoice/detail rows are inserted, instead of being held for the whole save (return amount,
    /// status update, etc.) which was serializing every submit in the system behind one another.
    /// If the request fails before an explicit release, disposing the connection ends the session and
    /// the lock is dropped automatically, so no cleanup path is lost.
    private static void AcquireOrderSubmitLock(SqlConnection connection, SqlTransaction transaction, string orderId)
    {
        using (SqlCommand cmd = new SqlCommand("sp_getapplock", connection, transaction))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Resource", "InvoiceSubmit_Global");
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
                    "Could not acquire the invoice submit lock for OrderId=" + orderId +
                    " (sp_getapplock result=" + result + "). Another submit for this order may be in progress.");
            }
        }
    }

    /// Releases the session-owned lock taken by AcquireOrderSubmitLock as soon as the InvoiceId/
    /// InvoiceDetailId rows are safely inserted (and thus protected by their own row locks until this
    /// transaction commits or rolls back), so the rest of the save no longer blocks other submits.
    private static void ReleaseOrderSubmitLock(SqlConnection connection, SqlTransaction transaction)
    {
        using (SqlCommand cmd = new SqlCommand("sp_releaseapplock", connection, transaction))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Resource", "InvoiceSubmit_Global");
            cmd.Parameters.AddWithValue("@LockOwner", "Session");
            cmd.ExecuteNonQuery();
        }
    }

    protected void saveButton_Click(object sender, EventArgs e)
    {
        // Guard against double-click / duplicate async postbacks submitting the same
        // invoice twice before the first request has finished processing.
        if (Session["IsInvoiceSubmitting"] != null && (bool)Session["IsInvoiceSubmitting"] == true)
        {
            return;
        }

        Session["IsInvoiceSubmitting"] = true;
        try
        {
            saveButton_Click_Internal();
        }
        finally
        {
            Session["IsInvoiceSubmitting"] = false;
        }
    }

    private void saveButton_Click_Internal()
    {
        if (ValiMethod() != true)
        {
            Response.Redirect("InvoiceCreationByOrder.aspx");
            return;
        }

        if (Validation() != true)
        {
            return;
        }

        if (OrderExists(orderHiddenField.Value) == true)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Invoice already Generated !!" + "','Faild');", true);
            return;
        }

        string connectionString = ConfigurationManager.ConnectionStrings["SolutionConnectionStringSSIDB"].ConnectionString;

        // The entire Submit sequence (invoice master, invoice batch, invoice details, stock
        // deduction, return-amount, order invoice-flag) runs on a single connection/transaction
        // so it commits or rolls back as one atomic unit: either every table is updated, or none is.
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            connection.Open();
            SqlTransaction transaction = connection.BeginTransaction(IsolationLevel.ReadCommitted);
            bool committed = false;
            try
            {
                AcquireOrderSubmitLock(connection, transaction, orderHiddenField.Value);

                // Re-check inside the lock+transaction: the pre-flight OrderExists() above can be
                // beaten by a concurrent submit; this recheck cannot, because the app lock serializes it.
                DataTable existingInvoice = aOrderInfoBll.LoadOrderExistsBll(orderHiddenField.Value, transaction);
                if (existingInvoice.Rows.Count > 0)
                {
                    transaction.Rollback();
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Invoice already Generated !!" + "','Faild');", true);
                    return;
                }

                int invId = SaveInvoice(transaction);
                bool dtl = false;
                if (invId > 0)
                {
                    // invId is the InvoiceId just inserted into tblInvoice within this same,
                    // still-open transaction. The previous code re-queried tblInvoice by OrderId on a
                    // separate auto-commit connection here; against the row we just inserted (and have
                    // not committed yet) that read would block waiting on our own transaction's lock,
                    // deadlocking the request against itself. invId already is that value, so reuse it.
                    int invoicePK = invId;

                    dtl = SaveInvoiceDetail(invoicePK, transaction);

                    // Invoice/detail rows are inserted now, so their own row locks (held until this
                    // transaction commits or rolls back) already prevent any concurrent Submit from
                    // reusing the same MAX(col)+1 id. The app lock's job is done — release it here so
                    // other submits aren't blocked behind the remaining, slower, non-PK-generating work.
                    ReleaseOrderSubmitLock(connection, transaction);

                    if (dtl == true)
                    {
                        SaveReturnAmount(invoicePK, transaction);
                        aOrderInfoBll.UpdateInvoiceStatus(orderIdHiddenField.Value, transaction);
                    }
                }
                else
                {
                    ReleaseOrderSubmitLock(connection, transaction);
                }

                if (invId <= 0 || dtl != true)
                {
                    transaction.Rollback();
                    Clear();
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please generate Invoice again!" + "','Faild');", true);
                    return;
                }

                transaction.Commit();
                committed = true;

                // Post-commit, read-only bookkeeping — does not affect the atomicity of the write above.
                DataTable dtInvo = aOrderInfoBll.GetInvoNOGetByInvoID(orderIdHiddenField.Value.ToString());
                if (dtInvo.Rows.Count > 0 && dtInvo.Rows[0]["InvoiceId"].ToString() != "")
                {
                    _dataLoad.Check_anomalyInvoiceDetails(dtInvo.Rows[0]["InvoiceId"].ToString(), orderIdHiddenField.Value.ToString());
                }

                Clear();
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Invoice Created Successsfully!" + "','Success');", true);
            }
            catch (Exception ex)
            {
                if (!committed)
                {
                    try { transaction.Rollback(); } catch { /* connection/transaction may already be dead; nothing left to roll back */ }
                }
                System.Diagnostics.Trace.TraceError(
                    "Invoice Submit failed for OrderId={0}: {1}", orderIdHiddenField.Value, ex);
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please generate Invoice again!" + "','Faild');", true);
            }
        }
    }

    private bool ValiMethod()
    {

        bool chk = true;
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        string OrderId = orderHiddenField.Value.ToString();
        int cont = 0;
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            string OrderDtlsId =
                    ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value;
            DataTable   aTable = aOrderInfoBll.LoadOrderWithDetailIDCheck(OrderId, OrderDtlsId);

            if(aTable.Rows.Count==0)
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


    private bool ValiMethodAfterSave()
    {

        bool chk = true;
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        string OrderId = orderHiddenField.Value.ToString();
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
    private bool SaveInvoiceDetail(int invoiceId, SqlTransaction transaction)
    {

        List<InvoiceDetail> aInvoiceDetailsList = new List<InvoiceDetail>();

        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
                DataTable dtdiscount =
                aOrderInfoBll.ProductDiscount(
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text,
                    hdCustomerMasterId.Value, invDateTextBox.Text);

                InvoiceDetail aInvoiceDetail = new InvoiceDetail();
                aInvoiceDetail.ProductCode =
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;
                string product = ((TextBox)gridLineItemGridView.Rows[i].Cells[2].FindControl("nameTextBox")).Text;
                string[] proNameAndPackSize = product.Split(':');
                aInvoiceDetail.ProductName = proNameAndPackSize[0];
                aInvoiceDetail.PackSize = proNameAndPackSize[1];
                aInvoiceDetail.UnitPrice = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[4].FindControl("unitPriceTextBox")).Text);
                aInvoiceDetail.UnitVatAmount = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[5].FindControl("upVatTextBox")).Text);
                aInvoiceDetail.Quantity = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[6].FindControl("qtyTextBox")).Text);
                aInvoiceDetail.DiscountPercentage = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text);
                aInvoiceDetail.DiscountAmount = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text);
                aInvoiceDetail.BonusQuantity = Convert.ToDecimal((0));
                aInvoiceDetail.SpecialAmount = 0;
                aInvoiceDetail.IsgiftProduct = (gridLineItemGridView.DataKeys[i][0].ToString());
                //Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text.Trim());
                string id =
                    ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value;
                aInvoiceDetail.OrderDetailsId = Convert.ToInt32(id);
                aInvoiceDetail.InvoiceId = invoiceId;
                aInvoiceDetail.TotalPriceVatAmount =
                    Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text);
                TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                aInvoiceDetail.NetAmount = Convert.ToDecimal(npTextBox.Text);
                if (dtdiscount.Rows.Count > 0)
                {
                    aInvoiceDetail.SpecialAmountPer = Convert.ToDecimal(dtdiscount.Rows[0]["DiscountPercentage"].ToString());
                }
                else
                {
                    aInvoiceDetail.SpecialAmountPer = 0;
                }
                try
                {
                    aInvoiceDetail.AdjustmentAmount = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("amTextBox")).Text);
                }
                catch(Exception ex)
                {
                    aInvoiceDetail.AdjustmentAmount = 0;
                }
                decimal cstock = 0;
                decimal tqty = 0;
                tqty = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("tQtyTextBox")).Text);
                cstock = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text);
                DataTable dtdata = aInvoiceBll.LoadProductQty(orderIdHiddenField.Value,
                ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text);
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


                aInvoiceDetail.CampaignType = ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("CampaignTypeHiddenField")).Value.Trim();

                try
                {
                    aInvoiceDetail.IsCampaignProductforInv =
                  Convert.ToBoolean(((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text.Trim());
                }
                catch (Exception)
                {
                    aInvoiceDetail.IsCampaignProductforInv = false;
                }


                try
                {
                    aInvoiceDetail.ISGiftProductforInv =
                   Convert.ToBoolean(((TextBox)gridLineItemGridView.Rows[i].Cells[12].FindControl("bQtyTextBox")).Text.Trim());
                }
                catch (Exception)
                {

                    aInvoiceDetail.ISGiftProductforInv = false;
                }

                if (cstock == 0)
                {
                    aInvoiceBll.UpdateOrder("Undelivered", aInvoiceDetail.OrderDetailsId.ToString(), transaction);
                }
                else
                {
                    aInvoiceDetailsList.Add(aInvoiceDetail);
                }
            }

            aInvoiceBll.SaveInvoiceDetails(aInvoiceDetailsList, hdComUnitId.Value, transaction);
        }

        return true;
    }

    private int SaveInvoice(SqlTransaction transaction)
    {

        int invoiceId = 0;
        DataTable aDataTable = new DataTable();
        aDataTable = aInvoiceBll.CustomerMaster(orderNoTextBox.Text.Trim());

        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        DataTable dtFixedCustomer = aOrderInfoBll.GetFixedCustomer(orderHiddenField.Value);



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
        try
        {
            aInvoice.MiaId = Convert.ToInt32(hdMiaId.Value);
        }
        catch (Exception ex) {
            aInvoice.MiaId = 0;
        }
        aInvoice.PaymentTypeId = Convert.ToInt32(payTypeDDL.SelectedValue);
        aInvoice.TpTotal = Convert.ToDecimal(tpTptalTextBox.Text.Trim());
        aInvoice.TpDiscount = Convert.ToDecimal(disTotalTextBox.Text.Trim());
        aInvoice.TpVat = Convert.ToDecimal(vatTotalTextBox.Text.Trim());
        aInvoice.TpGrandTotal = Convert.ToDecimal(grandTotalTextBox.Text.Trim());
        aInvoice.UserId = Convert.ToInt32(Session["UserId"].ToString());
        aInvoice.ComUnitCode = ComUnitCode;
        aInvoice.OrderId = Convert.ToInt32(orderIdHiddenField.Value);
        aInvoice.Inv_DANameId = Convert.ToInt32(ddlDAName.SelectedValue);
        aInvoice.TotalSpecialAmount = Convert.ToDecimal(pdTextBox.Text);


        aInvoice.cusType = cusTypeTextBox.Text;

        aInvoice.OldTradePolicy = false;
        ////// SMC Low Stock Method////////
        aInvoice.Remarks = remarksTextBox.Text;
        aInvoice.MIACode = aDataTable.Rows[0]["MIOEmpMastercode"].ToString();
        aInvoice.MIAName = aDataTable.Rows[0]["MIOEmpName"].ToString();
        aInvoice.MarketCode = aDataTable.Rows[0]["MarketCode"].ToString();
        aInvoice.MarketName = aDataTable.Rows[0]["MarketName"].ToString();
        aInvoice.AreaCode = aDataTable.Rows[0]["AreaCode"].ToString();
        aInvoice.DisCode = aDataTable.Rows[0]["ASMEmpMasterCode"].ToString();
        aInvoice.FEName = aDataTable.Rows[0]["ASMEmpName"].ToString();
        aInvoice.RegionCode = aDataTable.Rows[0]["RegionCode"].ToString();
        aInvoice.DZSMName = aDataTable.Rows[0]["RSMEmpName"].ToString();
        aInvoice.FixedCustomer = Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"].ToString());
        aInvoice.Type = Convert.ToString(aDataTable.Rows[0]["Type"].ToString());
        aInvoice.DpNAme = deliverypersonNameTextBox.Text.Trim();
        aInvoice.DpMob = deliverypersonMobileTextBox.Text.Trim();
        aInvoice.ProductOffer = "False";

        aInvoice.Createdate = DateTime.Now;
        aInvoice.AdjustAmount = Convert.ToDecimal(crAmountTextBox.Text);
        aInvoice.ReceivableAmount = Convert.ToDecimal(rcvAmountTextBox.Text);
        if (Convert.ToDecimal(crAmountTextBox.Text) > 0)
        {
            aInvoice.IsAdjustInvoice = true;
            aInvoice.AdjustInvoiceNo_ReturnInvoiceNo = adjustInvoiceNoTextBox.Text.Trim();
        }
        else
        {
            aInvoice.IsAdjustInvoice = false;
            
        }
        ////////////////Product Multiple Offer End ///////////

        aInvoiceBll.SaveInvoice(aInvoice, out invoiceId, out invoiceNo, transaction);

        invTextBox.Text = invoiceNo;

        return invoiceId;
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
        pdTextBox.Text = "";
        orderHiddenField.Value = "";
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
        if (gridLineItemGridView.Rows.Count > 0)
        {

            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                decimal cstock = 0;
                decimal tqty = 0;
                tqty = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("tQtyTextBox")).Text);
                cstock = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text);
                DataTable dtdata = aInvoiceBll.LoadProductQty(orderIdHiddenField.Value,
                ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text);
                /////SMC Low Stock Method/////
                //tqty = Convert.ToDecimal(dtdata.Rows[0][0].ToString());
                /////////////
                if (cstock >= tqty)
                {
                    tpTotal += (((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text != "") ? Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text) : 0;
                    vatTotal += (((TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text != "") ? Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[8].FindControl("tpVatTextBox")).Text) : 0;
                    //Offer Applied
                    //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "ANB08" && tqty >= 3)
                    //{
                    //    disTotal = 0;
                    //    //(((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text != "") ? Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text) : 0;

                    //}
                    //else
                    {
                        disTotal += (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text != "") ? Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text) : 0;

                    }

                    gTotal += (((TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text != "") ? Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox")).Text) : 0;
                  //  sptotatl += (((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text != "") ? Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text) : 0;
                }
            }
        }

        tpTptalTextBox.Text = tpTotal.ToString();
        vatTotalTextBox.Text = vatTotal.ToString();
        disTotalTextBox.Text = disTotal.ToString();
        grandTotalTextBox.Text = gTotal.ToString();
        pdTextBox.Text = sptotatl.ToString();

    }

    protected void printButton_Click(object sender, EventArgs e)
    {
        try
        {
            if (invTextBox.Text == "")
            {
                string text6 = "Please Enter Invoice NO!";
                ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                invTextBox.CssClass = "form-control form-control-sm is-invalid";
                invTextBox.Focus();
            }
            else
            {

                ProformaOrInvoiceReturnBLL aIn = new ProformaOrInvoiceReturnBLL();
                DataTable dtInvo = aOrderInfoBll.GetInvoNOGetByInvoNo(invTextBox.Text.Trim());

                if (dtInvo.Rows[0]["InvoiceId"].ToString() != "")
                {
                    DataTable dtMarket = _dataLoad.Check_anomalyInvoiceDetails(dtInvo.Rows[0]["InvoiceId"].ToString(), dtInvo.Rows[0]["OrderId"].ToString().ToString());

                    if (dtMarket.Rows.Count > 0)
                    {
                        aIn.DeleteProforma(dtInvo.Rows[0]["InvoiceNo"].ToString().Trim());
                        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please generate Invoice again!" + "','Faild');", true);
                    }

                    else
                    {
                        string url = "../SInventory_RPTVIEW/InvoiceReportViewer.aspx?InvNo=" + Server.UrlEncode(invTextBox.Text.Trim());
                        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
                        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
                        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
                    }

                }




            }

        }
        catch
        {

        }
    }
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
                GetCustInfo(custCode,orderNoTextBox.Text.Trim());
            }
        }
    }
    protected void nameTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox TextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        string product = ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[2].FindControl("nameTextBox")).Text;

        if (!string.IsNullOrEmpty(product))
        {
            if (product.Contains(':'))
            {
                string[] proNameAndPackSize = product.Split(':');


                TextBox productCodeTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox");
                productCodeTextBox.Text = proNameAndPackSize[1];
                string productCode = productCodeTextBox.Text.Trim();
                GetProduct(rowindex, productCode);
            }

        }


    }
}