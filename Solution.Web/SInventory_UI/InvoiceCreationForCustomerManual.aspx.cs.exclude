using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_InvoiceCreationForCustomer : System.Web.UI.Page
{
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["OrderId"] != null)
            {
                orderHiddenField.Value = Session["OrderId"].ToString();
                LoadAllDataByOrder(Session["OrderId"].ToString());
                CustomerCreditAmount();
                Session["OrderId"] = null;
            }
            aInvoiceBll.PaymentTypeLoadBLL(payTypeDDL);
            payTypeDDL.SelectedIndex = 1;
            Todate();
        }
    }

    private void CustomerCreditAmount()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        DataTable custTable = new DataTable();
        custTable = aOrderInfoBll.GetCustomerCredit(hdCustomerMasterId.Value);
        crAmountTextBox.Text = custTable.Rows[0]["Amount"].ToString();
        rcvAmountTextBox.Text = ((string.IsNullOrEmpty(grandTotalTextBox.Text) ? 0 : Convert.ToDecimal((grandTotalTextBox.Text))) - (string.IsNullOrEmpty(crAmountTextBox.Text) ? 0 : Convert.ToDecimal((crAmountTextBox.Text)))).ToString();
        //(Convert.ToDecimal(grandTotalTextBox.Text) - Convert.ToDecimal(crAmountTextBox.Text)).ToString(); ddd
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
        return true;
    }

    private void GetCustInfo(string custCode)
    {
        if (!string.IsNullOrEmpty(custCode))
        {
            custCodeTextBox.Text = custCode;
            DataTable aDataTable = new DataTable();
            aDataTable = aInvoiceBll.CustomerMaster( orderNoTextBox.Text.Trim());
            if (aDataTable.Rows.Count > 0)
            {
                hdComUnitId.Value = aDataTable.Rows[0]["ComUnitId"].ToString();
                hdCustomerMasterId.Value = aDataTable.Rows[0]["CustomerMasterId"].ToString();
                custNameTextBox.Text = aDataTable.Rows[0]["CustomerName"].ToString();
                custAddressTextBox.Text = aDataTable.Rows[0]["Address"].ToString();
                districtNameTextBox.Text = aDataTable.Rows[0]["DistrictName"].ToString();
                areaNameTextBox.Text = aDataTable.Rows[0]["AreaName"].ToString();
                comUnitNameTextBox.Text = aDataTable.Rows[0]["ComUnitCode"].ToString() + ":" + aDataTable.Rows[0]["ComUnitName"].ToString();
                miaCodeTextBox.Text = aDataTable.Rows[0]["MiaCode"].ToString();
                hdMiaId.Value = aDataTable.Rows[0]["MiaId"].ToString();
                marketNameTextBox.Text = aDataTable.Rows[0]["MarketName"].ToString();
                miaNameTextBox.Text = aDataTable.Rows[0]["MiaName"].ToString();
                custCategoryTextBox.Text = aDataTable.Rows[0]["Type"].ToString();
                hdMiaId.Value = aDataTable.Rows[0]["MiaId"].ToString();
            }
            else
            {

            }
        }
    }

    public bool OrderExists(string orderId)
    {
        //OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        //DataTable aTable = new DataTable();
        //aTable = aOrderInfoBll.LoadOrderExistsBll(orderId);
        //if (aTable.Rows.Count > 0)
        //{
        //    return true;
        //}
        //else
        //{
        //    return false;
        //}
        return false;
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
            GetCustInfo(aTable.Rows[0]["CustomerCode"].ToString());
          

            for (int i = 0; i < aTable.Rows.Count; i++)
            {
                AddFunc();
                ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value =
                    aTable.Rows[i]["OrderDetailId"].ToString();
                GetProduct(i, aTable.Rows[i]["ProductCode"].ToString());
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
                ((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                    aTable.Rows[i]["IsCampaignProduct"].ToString();
                ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("bQtyTextBox")).Text =
                   aTable.Rows[i]["ISGiftProduct"].ToString();
                //   ((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("IsCampaignProduct")).Text;

                //try
                //{
                //    ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("dpTextBox")).Text =
                //  Convert.ToDecimal(aTable.Rows[i]["DiscountPercent"]).ToString();
                //}
                //catch (Exception)
                //{

                //    ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("dpTextBox")).Text = "0";
                //}

                //try
                //{
                //    ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("dpAmtTextBox")).Text =
                //                 Convert.ToDecimal(aTable.Rows[i]["DiscountAmount"]).ToString();
                //}
                //catch (Exception)
                //{

                //    ((TextBox) gridLineItemGridView.Rows[i].Cells[3].FindControl("dpAmtTextBox")).Text = "0";
                //}


                //((TextBox) gridLineItemGridView.Rows[i].Cells[3].FindControl("npTextBox")).Text =
                //    Convert.ToDecimal(aTable.Rows[i]["NetAmount"]).ToString();
                //((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("tpVatTextBox")).Text =
                //    Convert.ToDecimal(aTable.Rows[i]["TotalVatAmount"]).ToString();


            }
            decimal totalprice = Convert.ToDecimal(tpTptalTextBox.Text);

            


          //  if (Actifast() == true)
            {
                for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
                {
                    //string ProductCode1 =
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;

                    if ((((TextBox) gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text == "True"))
                    {
                        totalprice -=
                            Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                    }
                }
            }


            //   Campaing 2
            decimal percentage = 0;

            DataTable dtFixedCustomer = aOrderInfoBll.GetFixedCustomer(aTable.Rows[0]["CustomerCode"].ToString());
            if (Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"]) == true)
            {
                //2
                DataTable dttradepolicy = aOrderInfoBll.GetTradeTerm(totalprice.ToString());
                if (dttradepolicy.Rows.Count > 0)
                {
                    percentage = 0;
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




            // Campaing 

            decimal totaldiscount = 0;
          //  totaldiscount = (percentage * Convert.ToDecimal(tpTptalTextBox.Text)) / 100;
            disTotalTextBox.Text = totaldiscount.ToString();
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
               // ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text = ((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("IsCampaignProduct")).Text;
                decimal cstock = 0;
                decimal tqty = 0;
                tqty = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("tQtyTextBox")).Text);
                cstock =
                    Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text);
                DataTable dtdata = aInvoiceBll.LoadProductQty(orderIdHiddenField.Value,
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text);
                tqty = Convert.ToDecimal(dtdata.Rows[0][0].ToString());
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
                    DataTable dtproductvat =
                        aOrderInfoBll.ProductVat(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text);
                    DataTable dtdiscount =
                       aOrderInfoBll.ProductDiscount(
                           ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text,
                           hdCustomerMasterId.Value, invDateTextBox.Text);
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

                    if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text == "True")
                    {

                        ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                      0.ToString();
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                           0.ToString("F");
                    }
                 
                  
                    else
                    {
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                           percentage.ToString();
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                            (Convert.ToDecimal(
                                ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                             (percentage / 100)).ToString("F");
                    }
                   
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
                            ((TextBox) gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                         Convert.ToDecimal(
                             (((TextBox) gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text)));
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

                    TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                    npTextBox.Text = ((Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                       Convert.ToDecimal(
                                           ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                               .Text.Trim()) ) +
                                      Convert.ToDecimal(tpVatTextBox.Text)).ToString();


                    if (((TextBox) gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text == "True"

                        && ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("bQtyTextBox")).Text == "True")
                    {

                        ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("npTextBox")).Text = 0.ToString();
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("tpVatTextBox")).Text = 0.ToString();
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("tpTextBox")).Text = 0.ToString();
                        //(TextBox) gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox").te = 0;
                    }
                    //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text == "False"

                    //   && ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("bQtyTextBox")).Text == "True")
                    //{

                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("npTextBox")).Text = 0.ToString();
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("tpVatTextBox")).Text = 0.ToString();
                    //    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("tpTextBox")).Text = 0.ToString();
                    //    //(TextBox) gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox").te = 0;
                    //}

                    TotalValueCalculation();
                }
            }


            {
             //   OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();

               // DataTable aTable = new DataTable();
                //aTable = aOrderInfoBll.LoadOrderWithDetail(orderHiddenField.Value);
               // DataTable dtFixedCustomer = aOrderInfoBll.GetFixedCustomer(aTable.Rows[0]["CustomerCode"].ToString());
                //if (Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"]) == true)
                //{

                //}
                //else
                //{
                    //FOC Applied Start//
                    //if (B() == true)//Flazidol
                    //{
                    //    addImageButton_Click(this, null);
                    //}
                    //if (B2() == true)//Nervaid
                    //{
                    //    addImageButton_Click2(this, null);
                    //}
                    //if (B3() == true)// Maxivant
                    //{
                    //    addImageButton_Click3(this, null);
                    //}
                    //if (B4() == true)//ezepain
                    //{
                    //    addImageButton_Click4(this, null);
                    //}
                    //if (B5() == true)//sp
                    //{
                    //    addImageButton_Click5(this, null);
                    //}
                    //if (B6() == true)//Moticare Tablet~10mg
                    //{
                    //    addImageButton_Click6(this, null);
                    //}
               // } 
            }
        
            //FOC Applied End//

            // GetOrderDetailValue(orderId);
            GetDiscounttotalValue();
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
        GetCustInfo(custCode);
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
        aDataTable.Columns.Add("IsCampaignProduct");
        aDataTable.Columns.Add("BonusQty");
        aDataTable.Columns.Add("TotalQty");
        aDataTable.Columns.Add("OrderDetailsId");
        aDataTable.Columns.Add("ISGiftProduct"); 
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
        aDataTable.Columns.Add("ISGiftProduct");
        aDataTable.Columns.Add("IsCampaignProduct");

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
                dataRow["ISGiftProduct"] = ((TextBox)gridLineItemGridView.Rows[i].FindControl("bQtyTextBox")).Text.Trim();
                dataRow["IsCampaignProduct"] = ((TextBox)gridLineItemGridView.Rows[i].FindControl("sdTextBox")).Text.Trim();
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
        aDataTable.Columns.Add("OrderDetailsId");
        aDataTable.Columns.Add("SpecialAmount");
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
                    dataRow["ISGiftProduct"] = ((TextBox)gridLineItemGridView.Rows[i].FindControl("bQtyTextBox")).Text.Trim();
                    dataRow["IsCampaignProduct"] = ((TextBox)gridLineItemGridView.Rows[i].FindControl("sdTextBox")).Text.Trim();
                    dataRow["OrderDetailsId"] = ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value;
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
        DataTable aDataTable = new DataTable();
        if (!string.IsNullOrEmpty(productCode))
        {
            if (ProductCodeValidation(productCode, rowindex) == true)
            {
                aDataTable = aInvoiceBll.ProductInfo(hdComUnitId.Value, productCode);
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
            else
            {
                ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[2].FindControl("nameTextBox")).Text = "";
                ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("codeTextBox")).Text = "";
                showMessageBox(productCode + " No: Product Already Inserted!!!");
            }
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
        CustomerCreditAmount();
    }
    protected void bQtyTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox bQtyTextBox1 = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)bQtyTextBox1.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        try
        {
            ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[13].FindControl("tQtyTextBox")).Text =
                Convert.ToString(
                    Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[12].FindControl("bQtyTextBox")).Text.Trim()) +
                    Convert.ToDecimal(
                        ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[13].FindControl("tQtyTextBox")).Text.Trim()));
        }
        catch (Exception )
        {
            
        }
        

    }
    public void SaveReturnAmount(int invid)
    {
        ReturnAmountDAO amountDao = new ReturnAmountDAO()
        {
            CustomerId = Convert.ToInt32(hdCustomerMasterId.Value),
            Amount = Convert.ToDecimal(crAmountTextBox.Text)*(-1),
          //  ReturnInvoiceId = invid,
            InvoiceId = Convert.ToInt32(invid)
        };
        bool status = aInvoiceBll.SaveDataForReturnAmount(amountDao);

    }

    public void SetPrevdata()
    {
        DataTable dtinvoice = aInvoiceBll.LoadInvoiceDetailData(invIdHiddenField.Value);
        for (int i = 0; i < dtinvoice.Rows.Count; i++)
        {
            aInvoiceBll.UpdateDCStore(dtinvoice.Rows[i]["DCStoreId"].ToString(), Convert.ToDecimal(dtinvoice.Rows[i]["TotalQuantity"].ToString()));
            aInvoiceBll.DeleteInvoice(dtinvoice.Rows[i]["InvoiceId"].ToString(), dtinvoice.Rows[i]["InvoiceDetailId"].ToString());
        }
    }
    protected void saveButton_Click(object sender, EventArgs e)
    {
        if (Validation() == true)
        {
            if (OrderExists(orderHiddenField.Value) == false)
            {
                {
                    try
                    {
                        

                        SetPrevdata();
                        int invId = SaveInvoice();
                        if (invId > 0)
                        {
                            bool dtl = SaveInvoiceDetail(invId);
                            if (dtl == true)
                            {
                                SaveReturnAmount(invId);
                                OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
                                aOrderInfoBll.UpdateInvoiceStatus(orderIdHiddenField.Value);
                                Clear();
                                showMessageBox("Proforma Invoice Created Successsfully!!");
                            }
                            else
                            {
                                aInvoiceBll.DeleteInvoice(orderIdHiddenField.Value);
                                Clear();
                                showMessageBox("Internet  error code 1231!! please generate Invoice again");

                            }
                        }
                    }
                    catch (Exception)
                    {
                         aInvoiceBll.DeleteInvoice(orderIdHiddenField.Value);
                        Clear();
                        showMessageBox("Internet error code 1231!!  please generate Invoice again");
                    }
                }
            }
            else
            {
                showMessageBox("Invoice already Generated !!");
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
                decimal cstock = 0;
                decimal tqty = 0;
                tqty = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("tQtyTextBox")).Text);
                cstock = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text);
                DataTable dtdata = aInvoiceBll.LoadProductQty(orderIdHiddenField.Value,
                ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text);
                //tqty = Convert.ToDecimal(dtdata.Rows[0][0].ToString());
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


                if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "OAD04" && MaxiventFOC())
                {
                    aInvoiceDetail.Campaign = "Bonus Campaign";

                }
             
                //// Resectin FOC Offer Discount Start end//
                if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AEL02" && Nervaid75mgCapsuleFOC())
                {
                    aInvoiceDetail.Campaign = "Bonus Campaign";
                }



                if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "FGD02" && Moticare())
                {
                    aInvoiceDetail.Campaign = "Bonus Campaign";
                }

                if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "MNS03" && SeacoralDTablet())
                {
                    aInvoiceDetail.Campaign = "Bonus Campaign";
                }

                if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text == "AID04" && Ezepain())
                {
                    aInvoiceDetail.Campaign = "Bonus Campaign";
                }



                if (cstock == 0)
                {
                    aInvoiceBll.UpdateOrder("Undelivered", aInvoiceDetail.OrderDetailsId.ToString());
                }
                else
                {
                    aInvoiceDetailsList.Add(aInvoiceDetail);
                }
            }

            aInvoiceBll.SaveInvoiceDetails(aInvoiceDetailsList, hdComUnitId.Value);
        }

        return true;
    }

    private int SaveInvoice()
    {

        int invoiceId = 0;
        DataTable aDataTable = new DataTable();
        aDataTable = aInvoiceBll.CustomerMaster(orderNoTextBox.Text.Trim());
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
        aInvoice.PaymentTypeId = Convert.ToInt32(payTypeDDL.SelectedValue);
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
        aInvoice.ProductOffer = "False";

        aInvoice.Createdate = DateTime.Now;
        aInvoice.AdjustAmount = Convert.ToDecimal(crAmountTextBox.Text);
        aInvoice.ReceivableAmount = Convert.ToDecimal(rcvAmountTextBox.Text);
        if (Convert.ToDecimal(crAmountTextBox.Text) > 0)
        {
            aInvoice.IsAdjustInvoice = true;
        }
        else
        {
            aInvoice.IsAdjustInvoice = false;
            
        }
        ////////////////Product Multiple Offer End ///////////

        aInvoiceBll.SaveInvoice(aInvoice, out invoiceId, out invoiceNo);

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
        InitialGrid();
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
        if (invTextBox.Text == "")
        {
    //   showMessageBox("PlGenerate the Invoice!!");
        }
        else
        {
            string url = "../SInventory_RPTVIEW/InvoiceReportViewer.aspx?InvNo=" + Server.UrlEncode(invTextBox.Text.Trim());
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
            
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
                GetCustInfo(custCode);
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
    protected void Button1_Click(object sender, EventArgs e)
    {
        
        DataTable dtdataaaa = aInvoiceBll.LoadInvoice(invoiceNoSearchTextBox.Text);
        DataTable dtdatainvoicedetail = aInvoiceBll.LoadInvoiceWithDetail(dtdataaaa.Rows[0]["InvoiceId"].ToString());
        gridLineItemGridView.DataSource = dtdatainvoicedetail;
        gridLineItemGridView.DataBind();
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        DataTable aTable = new DataTable();
        aTable = aOrderInfoBll.LoadOrderWithDetail(dtdataaaa.Rows[0]["OrderId"].ToString());
        orderNoTextBox.Text = aTable.Rows[0]["OrderCode"].ToString();
        orderIdHiddenField.Value = aTable.Rows[0]["OrderId"].ToString();
        orderDateTextBox.Text = Convert.ToDateTime(aTable.Rows[0]["SubmissionDate"].ToString()).ToString("dd-MMM-yyyy");
        GetCustInfo(aTable.Rows[0]["CustomerCode"].ToString());
        DataTable aTable2 = new DataTable();
        aTable2 = aTable;
        aTable = dtdatainvoicedetail;
        for (int i = 0; i < aTable.Rows.Count; i++)
        {
            //AddFunc();
            ((HiddenField)gridLineItemGridView.Rows[i].Cells[1].FindControl("orderdetailIdHiddenField")).Value =
                aTable.Rows[i]["OrderDetailsId"].ToString();
            GetProduct(i, aTable.Rows[i]["ProductCode"].ToString());
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
            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text =
                aTable.Rows[i]["IsCampaignProduct"].ToString();
            ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("bQtyTextBox")).Text =
               aTable.Rows[i]["ISGiftProduct"].ToString();
            //   ((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("IsCampaignProduct")).Text;

            //try
            //{
            //    ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("dpTextBox")).Text =
            //  Convert.ToDecimal(aTable.Rows[i]["DiscountPercent"]).ToString();
            //}
            //catch (Exception)
            //{

            //    ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("dpTextBox")).Text = "0";
            //}

            //try
            //{
            //    ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("dpAmtTextBox")).Text =
            //                 Convert.ToDecimal(aTable.Rows[i]["DiscountAmount"]).ToString();
            //}
            //catch (Exception)
            //{

            //    ((TextBox) gridLineItemGridView.Rows[i].Cells[3].FindControl("dpAmtTextBox")).Text = "0";
            //}


            //((TextBox) gridLineItemGridView.Rows[i].Cells[3].FindControl("npTextBox")).Text =
            //    Convert.ToDecimal(aTable.Rows[i]["NetAmount"]).ToString();
            //((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("tpVatTextBox")).Text =
            //    Convert.ToDecimal(aTable.Rows[i]["TotalVatAmount"]).ToString();


        }
        decimal totalprice = Convert.ToDecimal(tpTptalTextBox.Text);




        //  if (Actifast() == true)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                //string ProductCode1 =
                //    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text;

                if ((((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text == "True"))
                {
                    totalprice -=
                        Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].FindControl("tpTextBox")).Text);
                }
            }
        }


        //   Campaing 2
        decimal percentage = 0;

        DataTable dtFixedCustomer = aOrderInfoBll.GetFixedCustomer(aTable2.Rows[0]["CustomerCode"].ToString());
        if (Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"]) == true)
        {
            //2
            DataTable dttradepolicy = aOrderInfoBll.GetTradeTerm(totalprice.ToString());
            if (dttradepolicy.Rows.Count > 0)
            {
                percentage = 0;
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




        // Campaing 

        decimal totaldiscount = 0;
        //  totaldiscount = (percentage * Convert.ToDecimal(tpTptalTextBox.Text)) / 100;
        disTotalTextBox.Text = totaldiscount.ToString();
        for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
        {
            // ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("sdTextBox")).Text = ((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("IsCampaignProduct")).Text;
            decimal cstock = 0;
            decimal tqty = 0;
            tqty = Convert.ToDecimal(((TextBox)gridLineItemGridView.Rows[i].Cells[14].FindControl("tQtyTextBox")).Text);
            cstock =
                Convert.ToDecimal(
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("currentStockTextBox")).Text);
            DataTable dtdata = aInvoiceBll.LoadProductQty(orderIdHiddenField.Value,
                ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text);
            //tqty = Convert.ToDecimal(dtdata.Rows[0][0].ToString());
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
                DataTable dtproductvat =
                    aOrderInfoBll.ProductVat(
                        ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text);
                DataTable dtdiscount =
                   aOrderInfoBll.ProductDiscount(
                       ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("codeTextBox")).Text,
                       hdCustomerMasterId.Value, invDateTextBox.Text);
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

                if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text == "True")
                {

                    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                  0.ToString();
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                       0.ToString("F");
                }


                else
                {
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[9].FindControl("dpTextBox")).Text =
                       percentage.ToString();
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox")).Text =
                        (Convert.ToDecimal(
                            ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) *
                         (percentage / 100)).ToString("F");
                }

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

                TextBox npTextBox = (TextBox)gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox");
                npTextBox.Text = ((Convert.ToDecimal(
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[7].FindControl("tpTextBox")).Text.Trim()) -
                                   Convert.ToDecimal(
                                       ((TextBox)gridLineItemGridView.Rows[i].Cells[10].FindControl("dpAmtTextBox"))
                                           .Text.Trim())) +
                                  Convert.ToDecimal(tpVatTextBox.Text)).ToString();


                if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text == "True"

                    && ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("bQtyTextBox")).Text == "True")
                {

                    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("npTextBox")).Text = 0.ToString();
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("tpVatTextBox")).Text = 0.ToString();
                    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("tpTextBox")).Text = 0.ToString();
                    //(TextBox) gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox").te = 0;
                }
                //if (((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("sdTextBox")).Text == "False"

                //   && ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("bQtyTextBox")).Text == "True")
                //{

                //    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("npTextBox")).Text = 0.ToString();
                //    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("tpVatTextBox")).Text = 0.ToString();
                //    ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("tpTextBox")).Text = 0.ToString();
                //    //(TextBox) gridLineItemGridView.Rows[i].Cells[11].FindControl("npTextBox").te = 0;
                //}

                TotalValueCalculation();
            }
        }


        {
            //   OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();

            // DataTable aTable = new DataTable();
            //aTable = aOrderInfoBll.LoadOrderWithDetail(orderHiddenField.Value);
            // DataTable dtFixedCustomer = aOrderInfoBll.GetFixedCustomer(aTable.Rows[0]["CustomerCode"].ToString());
            //if (Convert.ToBoolean(dtFixedCustomer.Rows[0]["FixedCustomer"]) == true)
            //{

            //}
            //else
            //{
            //FOC Applied Start//
            //if (B() == true)//Flazidol
            //{
            //    addImageButton_Click(this, null);
            //}
            //if (B2() == true)//Nervaid
            //{
            //    addImageButton_Click2(this, null);
            //}
            //if (B3() == true)// Maxivant
            //{
            //    addImageButton_Click3(this, null);
            //}
            //if (B4() == true)//ezepain
            //{
            //    addImageButton_Click4(this, null);
            //}
            //if (B5() == true)//sp
            //{
            //    addImageButton_Click5(this, null);
            //}
            //if (B6() == true)//Moticare Tablet~10mg
            //{
            //    addImageButton_Click6(this, null);
            //}
            // } 
        }

        //FOC Applied End//

        // GetOrderDetailValue(orderId);
        GetDiscounttotalValue();
        //if (dtdata.Rows.Count > 0)
        //{
        //    invIdHiddenField.Value = dtdata.Rows[0]["InvoiceId"].ToString();
        //    orderHiddenField.Value = dtdata.Rows[0]["OrderId"].ToString();
        //    LoadAllDataByOrder(dtdata.Rows[0]["OrderId"].ToString());

            CustomerCreditAmount();
        //    //Session["OrderId"] = null;
        //}
    }
}