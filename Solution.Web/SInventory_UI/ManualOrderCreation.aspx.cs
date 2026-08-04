using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;


public partial class SInventory_UI_ManualOrderCreation : System.Web.UI.Page
{
    OrderListBLL aOrderListBLL = new OrderListBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            InitialGrid();
            Todate();
            OrdNo();
            DropDownLoad();
        }
    }
  
    private void DropDownLoad()
    {
        aOrderListBLL.LoadmanufacturerName(manufacturerDropDownList);
        
        aOrderListBLL.DCLoad(dcDropDownList);
    }
    private void OrdNo()
    {

        orderNoTextBox.Text = aOrderListBLL.OrdNo();
    }
    private void Todate()
    {
        orderDateTextBox.Text = Convert.ToDateTime(DateTime.Today.ToShortDateString()).ToString("dd MMMM, yyyy");
    }

    public void CustomerInfo(string custCode)
    {
        DataTable dtcust = aOrderListBLL.CustomerInfo(custCode);
        if (dtcust.Rows.Count>0)
        {
            //if (dcDropDownList.SelectedValue ==dtcust.Rows[0]["ComUnitId"].ToString())
            //{
                custNameLabel.Text = dtcust.Rows[0]["CustomerName"].ToString();
                mioCodeLabel.Text = dtcust.Rows[0]["MiaCode"].ToString();
                mioNameLabel.Text = dtcust.Rows[0]["MiaName"].ToString();
                marketNameLabel.Text = dtcust.Rows[0]["MarketName"].ToString();
                teritory.Text = dtcust.Rows[0]["AreaCode"].ToString();
                FCBLabel3.Text = dtcust.Rows[0]["FixedCustomer"].ToString();
            //}
            //else
            //{
            //    //showMessageBox("Customer is not Valid");
            //}
        }
    }
    private void InitialGrid()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("PackSize");
        aDataTable.Columns.Add("Quantity");
        aDataTable.Columns.Add("ProductId");
        aDataTable.Columns.Add("UnitPrice");
        aDataTable.Columns.Add("VAT");

        aDataTable.Columns.Add("Totaltp");
        aDataTable.Columns.Add("TotaltpVat");


        DataRow dataRow;

        dataRow = aDataTable.NewRow();

        dataRow["SL"] = "1";
        dataRow["ProductCode"] = "";
        dataRow["ProductName"] = "";
        dataRow["PackSize"] = "";
        dataRow["Quantity"] = "";
        dataRow["UnitPrice"] = "";
        dataRow["ProductId"] = "";
        dataRow["VAT"] = "";
        dataRow["Totaltp"] = "";
        dataRow["TotaltpVat"] = "";

        aDataTable.Rows.Add(dataRow);

        productGridView.DataSource = null;
        productGridView.DataBind();
        productGridView.DataSource = aDataTable;
        productGridView.DataBind();

        foreach (GridViewRow row in productGridView.Rows)
        {
            TextBox productTextBox = (TextBox)productGridView.Rows[row.RowIndex].Cells[3].FindControl("productNameTextBox");
           
        }
       
    }

    private void AddRowInGrid()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("PackSize");
        aDataTable.Columns.Add("Quantity");
        aDataTable.Columns.Add("UnitPrice");
        aDataTable.Columns.Add("VAT");
        aDataTable.Columns.Add("ProductId");

        aDataTable.Columns.Add("IsCampaignProductDropDownList");
        aDataTable.Columns.Add("IsGiftProductDropDownList");


        aDataTable.Columns.Add("Totaltp");
        aDataTable.Columns.Add("TotaltpVat");


       

        DataRow dataRow;

        if (productGridView.Rows.Count > 0)
        {
            for (int i = 0; i < productGridView.Rows.Count; i++)
            {

                dataRow = aDataTable.NewRow();
                TextBox vatTextBox =
                    (TextBox)productGridView.Rows[i].Cells[5].FindControl("vatTextBox");
                TextBox tpTextBox =
                    (TextBox)productGridView.Rows[i].Cells[6].FindControl("tpTextBox");

                dataRow["SL"] = Convert.ToString(i + 1);
                TextBox productCodeTextBox = (TextBox)productGridView.Rows[i].Cells[1].FindControl("productCodeTextBox");
                dataRow["ProductCode"] = productCodeTextBox.Text.Trim();
                TextBox productNameTextBox = (TextBox)productGridView.Rows[i].Cells[2].FindControl("productNameTextBox");
                dataRow["ProductName"] = productNameTextBox.Text.Trim();
                TextBox packSizeTextBox = (TextBox)productGridView.Rows[i].Cells[3].FindControl("packSizeTextBox");
                dataRow["PackSize"] = packSizeTextBox.Text;
                TextBox quantityTextBox = (TextBox)productGridView.Rows[i].Cells[4].FindControl("reqQtyTextBox");
                HiddenField unitpriceHiddenField = (HiddenField)productGridView.Rows[i].Cells[0].FindControl("unitpriceHiddenField");
                HiddenField productidHiddenField = (HiddenField)productGridView.Rows[i].Cells[0].FindControl("productidHiddenField");
                dataRow["Quantity"] = quantityTextBox.Text.Trim();
                dataRow["ProductId"] = productidHiddenField.Value.Trim();
                dataRow["UnitPrice"] = unitpriceHiddenField.Value;
                dataRow["VAT"] = vatTextBox.Text;

                TextBox TotaltpTextBox = (TextBox)productGridView.Rows[i].Cells[3].FindControl("TotaltpTextBox");
                TextBox TotaltpVatTextBox = (TextBox)productGridView.Rows[i].Cells[3].FindControl("TotaltpVatTextBox");

                dataRow["Totaltp"] = TotaltpTextBox.Text;
                dataRow["TotaltpVat"] = TotaltpVatTextBox.Text;



                DropDownList C =
                (DropDownList)productGridView.Rows[i].Cells[1].FindControl("IsCampaignProductDropDownList");
                DropDownList G =
                (DropDownList)productGridView.Rows[i].Cells[1].FindControl("IsGiftProductDropDownList");



                dataRow["IsCampaignProductDropDownList"] = C.SelectedItem.Text;
                dataRow["IsGiftProductDropDownList"] = G.SelectedItem.Text;

                aDataTable.Rows.Add(dataRow);
            }
        }
        int sl = aDataTable.Rows.Count;

        dataRow = aDataTable.NewRow();

        dataRow["SL"] = Convert.ToString(sl + 1);
        dataRow["ProductCode"] = "";
        dataRow["ProductName"] = "";
        dataRow["PackSize"] = "";
        dataRow["Quantity"] = "";
        dataRow["ProductId"] = "";
        dataRow["UnitPrice"] = "";
        dataRow["VAT"] = "";
        dataRow["IsCampaignProductDropDownList"] = "";
        dataRow["IsGiftProductDropDownList"] = "";

        dataRow["Totaltp"] = "";
        dataRow["TotaltpVat"] = "";


        aDataTable.Rows.Add(dataRow);


        productGridView.DataSource = null;
        productGridView.DataBind();
        productGridView.DataSource = aDataTable;
        productGridView.DataBind();
        foreach (GridViewRow row in productGridView.Rows)
        {
            TextBox productTextBox = (TextBox)productGridView.Rows[row.RowIndex].Cells[3].FindControl("productNameTextBox");
            
        }
        for (int j = 0; j < aDataTable.Rows.Count; j++)
        {
            DropDownList ddlIsCampaignProductDropDownList =
                ((DropDownList)productGridView.Rows[j].Cells[5].FindControl("IsCampaignProductDropDownList"));
            ddlIsCampaignProductDropDownList.SelectedValue = aDataTable.Rows[j]["IsCampaignProductDropDownList"].ToString();


            DropDownList ddIsGiftProductDropDownList =
               ((DropDownList)productGridView.Rows[j].Cells[5].FindControl("IsGiftProductDropDownList"));
            ddIsGiftProductDropDownList.SelectedValue = aDataTable.Rows[j]["IsGiftProductDropDownList"].ToString();
        }
    }
    protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
    {
        AddRowInGrid();
    }
    protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton productCodeTextBox = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("ProductId");
        aDataTable.Columns.Add("PackSize");
        aDataTable.Columns.Add("Quantity");
        aDataTable.Columns.Add("UnitPrice");
        aDataTable.Columns.Add("VAT");
        aDataTable.Columns.Add("IsCampaignProductDropDownList");
        aDataTable.Columns.Add("IsGiftProductDropDownList");

        aDataTable.Columns.Add("Totaltp");
        aDataTable.Columns.Add("TotaltpVat");


 


        DataRow dataRow;

        if (productGridView.Rows.Count > 0)
        {
            int sl1 = 1;
            for (int i = 0; i < productGridView.Rows.Count; i++)
            {
                if (i != rowindex)
                {
                    dataRow = aDataTable.NewRow();
                    TextBox vatTextBox =
                    (TextBox)productGridView.Rows[i].Cells[5].FindControl("vatTextBox");
                    dataRow["SL"] = Convert.ToString(sl1);
                    TextBox productCodeTextBox2 = (TextBox)productGridView.Rows[i].Cells[1].FindControl("productCodeTextBox");
                    dataRow["ProductCode"] = productCodeTextBox2.Text.Trim();
                    TextBox productNameTextBox = (TextBox)productGridView.Rows[i].Cells[2].FindControl("productNameTextBox");
                    dataRow["ProductName"] = productNameTextBox.Text.Trim();
                    TextBox packSizeTextBox = (TextBox)productGridView.Rows[i].Cells[3].FindControl("packSizeTextBox");
                    dataRow["PackSize"] = packSizeTextBox.Text;
                    TextBox quantityTextBox = (TextBox)productGridView.Rows[i].Cells[4].FindControl("reqQtyTextBox");
                    HiddenField unitpriceHiddenField = (HiddenField)productGridView.Rows[i].Cells[0].FindControl("unitpriceHiddenField");
                    HiddenField productidHiddenField = (HiddenField)productGridView.Rows[i].Cells[0].FindControl("productidHiddenField");
                    dataRow["Quantity"] = quantityTextBox.Text.Trim();
                    dataRow["UnitPrice"] = unitpriceHiddenField.Value.Trim();
                    dataRow["VAT"] = vatTextBox.Text;

                    TextBox TotaltpTextBox = (TextBox)productGridView.Rows[i].Cells[3].FindControl("TotaltpTextBox");
                    TextBox TotaltpVatTextBox = (TextBox)productGridView.Rows[i].Cells[3].FindControl("TotaltpVatTextBox");

                    dataRow["Totaltp"] = TotaltpTextBox.Text;
                    dataRow["TotaltpVat"] = TotaltpVatTextBox.Text;


                    DropDownList C =
                    (DropDownList)productGridView.Rows[i].Cells[1].FindControl("IsCampaignProductDropDownList");
                    DropDownList G =
                    (DropDownList)productGridView.Rows[i].Cells[1].FindControl("IsGiftProductDropDownList");



                    dataRow["IsCampaignProductDropDownList"] = C.SelectedItem.Text;
                    dataRow["IsGiftProductDropDownList"] = G.SelectedItem.Text;


                    dataRow["ProductId"] = productidHiddenField.Value.Trim();
                    aDataTable.Rows.Add(dataRow);
                    sl1 += 1;
                }
            }
        }
        productGridView.DataSource = null;
        productGridView.DataBind();
        productGridView.DataSource = aDataTable;
        productGridView.DataBind();
        if (productGridView.Rows.Count < 1)
        {
            InitialGrid();
        }
        foreach (GridViewRow row in productGridView.Rows)
        {
            TextBox productTextBox = (TextBox)productGridView.Rows[row.RowIndex].Cells[3].FindControl("productNameTextBox");
            
        }
        for (int j = 0; j < aDataTable.Rows.Count; j++)
        {
            DropDownList ddlIsCampaignProductDropDownList =
                ((DropDownList)productGridView.Rows[j].Cells[5].FindControl("IsCampaignProductDropDownList"));
            ddlIsCampaignProductDropDownList.SelectedValue = aDataTable.Rows[j]["IsCampaignProductDropDownList"].ToString();


            DropDownList ddIsGiftProductDropDownList =
               ((DropDownList)productGridView.Rows[j].Cells[5].FindControl("IsGiftProductDropDownList"));
            ddIsGiftProductDropDownList.SelectedValue = aDataTable.Rows[j]["IsGiftProductDropDownList"].ToString();
        }
    }
    private void GetProductInGrid(int rowindex, string productCode)
    {
        DCStoreBLL _aDcStockReceiveBll = new DCStoreBLL();
        DataTable aDataTable = new DataTable();
        if (!string.IsNullOrEmpty(productCode))
        {

            aDataTable = _aDcStockReceiveBll.ProductInfoNew(productCode);
            if (aDataTable.Rows.Count > 0)
            {
                HiddenField productidHiddenField = (HiddenField)productGridView.Rows[rowindex].Cells[0].FindControl("productidHiddenField");
                TextBox productNameTextBox =
                    (TextBox)productGridView.Rows[rowindex].Cells[2].FindControl("productNameTextBox");
                productNameTextBox.Text = aDataTable.Rows[0]["ProductName"].ToString();
                TextBox packSizeTextBox = (TextBox)productGridView.Rows[rowindex].Cells[3].FindControl("packSizeTextBox");
                packSizeTextBox.Text = aDataTable.Rows[0]["PackSize"].ToString();
                HiddenField unitpriceHiddenField = (HiddenField)productGridView.Rows[rowindex].Cells[0].FindControl("unitpriceHiddenField");
                unitpriceHiddenField.Value = aDataTable.Rows[0]["UnitPrice"].ToString();
                productidHiddenField.Value = aDataTable.Rows[0]["ProductId"].ToString();
                TextBox vatTextBox =
                    (TextBox)productGridView.Rows[rowindex].Cells[5].FindControl("vatTextBox");
                TextBox tpTextBox =
                    (TextBox)productGridView.Rows[rowindex].Cells[6].FindControl("tpTextBox");
                tpTextBox.Text = aDataTable.Rows[0]["UnitPrice"].ToString();
                vatTextBox.Text = aDataTable.Rows[0]["VATAmountPerUnit"].ToString();

            }
        }
    }
    protected void productCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        DCStoreBLL _aDcStockReceiveBll = new DCStoreBLL();

        TextBox TextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        TextBox productCodeTextBox = (TextBox)productGridView.Rows[rowindex].Cells[1].FindControl("productCodeTextBox");

        string productCode = productCodeTextBox.Text.Trim();
        GetProductInGrid(rowindex, productCode);
    }


    private void SaveAllData()
    {
        
        int maxReqId;
        OrderInfoMaster aListMasterDao = new OrderInfoMaster()
                                       {
                                           OrderCode = orderNoTextBox.Text,
                                           ComUnitId= Convert.ToInt32(dcDropDownList.SelectedValue),
                                           ComUnitName = dcDropDownList.SelectedItem.Text.Split(':')[1].Trim(),
                                           ComUnitCode = dcDropDownList.SelectedItem.Text.Split(':')[0].Trim(),
                                           MIOCode = mioCodeLabel.Text,
                                           MIOName = mioNameLabel.Text,
                                           teritory = teritory.Text,
                                           ManufacId = Convert.ToInt32(manufacturerDropDownList.SelectedValue),
                                           CustomerCode = custCodeTextBox.Text,
                                           SubmissionDate = Convert.ToDateTime(orderDateTextBox.Text),
                                           CustomerName = custNameLabel.Text,
                                           IsManual = true,
                                           FCB=Convert.ToBoolean(FCBLabel3.Text)

                                       };
        decimal totalprice = 0;
        for (int i = 0; i < productGridView.Rows.Count; i++)
        {
            TextBox quantityTextBox = (TextBox)productGridView.Rows[i].Cells[4].FindControl("reqQtyTextBox");
            HiddenField unitpriceHiddenField = (HiddenField)productGridView.Rows[i].Cells[0].FindControl("unitpriceHiddenField");

            totalprice += Convert.ToDecimal(unitpriceHiddenField.Value)*Convert.ToDecimal(quantityTextBox.Text);
        }
        aListMasterDao.GrossValue = totalprice;

        bool requsitionSave = aOrderListBLL.SaveOrderMaster(aListMasterDao, out maxReqId);

        List<OrderInfoDetail> aOrderInfoDetailList = new List<OrderInfoDetail>();
        
        for (int i = 0; i < productGridView.Rows.Count; i++)
        {
            
            TextBox productCodeTextBox = (TextBox)productGridView.Rows[i].Cells[1].FindControl("productCodeTextBox");
            TextBox productNameTextBox = (TextBox)productGridView.Rows[i].Cells[2].FindControl("productNameTextBox");
            TextBox quantityTextBox = (TextBox)productGridView.Rows[i].Cells[4].FindControl("reqQtyTextBox");
            HiddenField productidHiddenField = (HiddenField)productGridView.Rows[i].Cells[0].FindControl("productidHiddenField");
            HiddenField unitpriceHiddenField = (HiddenField)productGridView.Rows[i].Cells[0].FindControl("unitpriceHiddenField");
            OrderInfoDetail aOrderInfoDetail = new OrderInfoDetail();
            aOrderInfoDetail.ProductCode = productCodeTextBox.Text.Trim();
            aOrderInfoDetail.ProductName = productNameTextBox.Text.Trim();
            aOrderInfoDetail.ProductId = Convert.ToInt32(productidHiddenField.Value);
            aOrderInfoDetail.Quantity = Convert.ToDecimal(quantityTextBox.Text.Trim());
            aOrderInfoDetail.OrderId = maxReqId;
            aOrderInfoDetail.TradePrice = Convert.ToDecimal(unitpriceHiddenField.Value);
            aOrderInfoDetail.TotalTradePrice = aOrderInfoDetail.Quantity*aOrderInfoDetail.TradePrice;


            DropDownList giftTextBox = (DropDownList)productGridView.Rows[i].Cells[2].FindControl("IsGiftProductDropDownList");
            DropDownList campTextBox = (DropDownList)productGridView.Rows[i].Cells[4].FindControl("IsCampaignProductDropDownList");

            aOrderInfoDetail.IsgiftProduct = giftTextBox.Text;
            aOrderInfoDetail.IsCampaignProduct = campTextBox.Text;


            aOrderInfoDetailList.Add(aOrderInfoDetail);
        }

        string msg = aOrderListBLL.SaveOrderDetail(aOrderInfoDetailList);
        Clear();
        showMessageBox(msg);
    }

    public bool Validation()
    {
        if (manufacturerDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Select Manufacturer !!!");
            manufacturerDropDownList.Focus();
            manufacturerDropDownList.BackColor = Color.GhostWhite;
            return false;
        }
        
        if (dcDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Select Distribution Center  !!!");
            dcDropDownList.Focus();
            dcDropDownList.BackColor = Color.GhostWhite;
            return false;
        }
        if (productGridView.Rows.Count > 0)
        {
            for (int i = 0; i < productGridView.Rows.Count; i++)
            {
                if (((TextBox)productGridView.Rows[i].FindControl("reqQtyTextBox")).Text == "")
                {
                    ((TextBox)productGridView.Rows[i].FindControl("reqQtyTextBox")).Focus();
                    showMessageBox("Please fill out Req.Qty!!");
                    return false;
                }
            }
        }
        if (productGridView.Rows.Count > 0)
        {
            for (int i = 0; i < productGridView.Rows.Count; i++)
            {
                if (((TextBox)productGridView.Rows[i].FindControl("productCodeTextBox")).Text == "")
                {
                    ((TextBox)productGridView.Rows[i].FindControl("productCodeTextBox")).Focus();
                    showMessageBox("Please fill out productCode!!");
                    return false;
                }
            }
        }
        if (productGridView.Rows.Count > 0)
        {
            for (int i = 0; i < productGridView.Rows.Count; i++)
            {
                if (((TextBox)productGridView.Rows[i].FindControl("productNameTextBox")).Text == "")
                {
                    ((TextBox)productGridView.Rows[i].FindControl("productNameTextBox")).Focus();
                    showMessageBox("Please fill out productName!!");
                    return false;
                }
            }
        }
        return true;
    }
    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (Validation())
        {
            SaveAllData();
        }
        else
        {
            showMessageBox("Select Manufacturer Name!!");
        }
       
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    private void Clear()
    {
       // manufacturerDropDownList.SelectedValue = "";
        InitialGrid();
        Todate();
        OrdNo();
        DropDownLoad();
        teritory.Text = string.Empty;
        custNameLabel.Text = string.Empty;
        mioCodeLabel.Text = string.Empty;
        mioNameLabel.Text = string.Empty;
        marketNameLabel.Text = string.Empty;
        custCodeTextBox.Text = string.Empty;
    }
    protected void productNameTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox TextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        TextBox productNameTextBox = (TextBox)productGridView.Rows[rowindex].Cells[2].FindControl("productNameTextBox");

        string productName = productNameTextBox.Text.Trim();
        if (productName.Contains(':'))
        {
            string[] productInfo = productName.Split(':');

            TextBox productCodeTextBox = (TextBox)productGridView.Rows[rowindex].Cells[1].FindControl("productCodeTextBox");

            productCodeTextBox.Text = productInfo[0];
            //productNameTextBox.Text = productInfo[1];
            string productCode = productCodeTextBox.Text.Trim();
            GetProductInGrid(rowindex, productCode);
        }
        else
        {
            showMessageBox("Input Correct Data!!");
        }
    }
    protected void miaImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("OrderRequisitionView.aspx");
    }
    protected void manufacturerDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        InitialGrid();
    }
    protected void custCodeTextBox_TextChanged(object sender, EventArgs e)
    {

        string empName = custCodeTextBox.Text.Trim();
        if (empName.Contains(':'))
        {
            string[] emp = empName.Split('|');

            hfCustomerId.Value = emp[1].Trim();
            custCodeTextBox.Text = emp[0].Trim();



        }
        else
        {

            custCodeTextBox.Text = "";
            hfCustomerId.Value = "";
            showMessageBox("Input Correct Data !!");
        }

    }

    protected void resetbtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("ManualOrderCreation.aspx");
    }
}