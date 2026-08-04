using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlTypes;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_WarehouseStockInEdit : System.Web.UI.Page
{
    WarehouseStockInBll aWarehouseStockInBll = new WarehouseStockInBll();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            InitialGrid();
            DropDownLoad();

           stockInIdHiddenField.Value = Request.QueryString["ID"];
           LoadWarehouseStockInInfo(stockInIdHiddenField.Value);
        }
    }

    private void LoadWarehouseStockInInfo(string value)
    {
        DataTable aDataTable = new DataTable();

        aDataTable = aWarehouseStockInBll.LoadWarehouseStockInMasterInfo(value);

        stockInDateTextBox.Text = aDataTable.Rows[0].Field<DateTime>("WHStockInDate").ToString("dd-MMM-yyyy");
        manufacturerDropDownList.SelectedValue = aDataTable.Rows[0].Field<Int32>("ManufacId").ToString(CultureInfo.InvariantCulture);
        challanNoTextBox.Text = aDataTable.Rows[0].Field<String>("ChallanNo");
        challanDateTextBox.Text = aDataTable.Rows[0].Field<DateTime>("ChallanDate").ToString("dd-MMM-yyyy");
        referenceNoTextBox.Text = aDataTable.Rows[0].Field<String>("ReferenceNo");
        referenceDateTextBox.Text = aDataTable.Rows[0].Field<DateTime>("ReferenceDate").ToString("dd-MMM-yyyy");
        remarksTextBox.Text = aDataTable.Rows[0].Field<String>("Remarks");

        totalQtyTextBox.Text = aDataTable.Rows[0].Field<Int32>("TotalQuantity").ToString();
        totalVatTextBox.Text = aDataTable.Rows[0].Field<Decimal>("TotalVat").ToString(CultureInfo.InvariantCulture);
        grandTotalTextBox.Text = aDataTable.Rows[0].Field<Decimal>("TotalValue").ToString(CultureInfo.InvariantCulture);

        DataTable detailDt = new DataTable();

        detailDt = aWarehouseStockInBll.LoadWarehouseStockInDetailInfo(value);
        
        productGridView.DataSource = detailDt;
        productGridView.DataBind();

    }

    private void DropDownLoad()
    {
        aWarehouseStockInBll.LoadmanufacturerName(manufacturerDropDownList);
    }

    private void InitialGrid()
    {
        DataTable aDataTable = new DataTable();

        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("PackSize");
        aDataTable.Columns.Add("Batch");
        aDataTable.Columns.Add("ExpDate");
        aDataTable.Columns.Add("MfgDate");
        aDataTable.Columns.Add("Quantity");

        aDataTable.Columns.Add("Price");
        aDataTable.Columns.Add("Vat");
        aDataTable.Columns.Add("TotalAmount");

        aDataTable.Columns.Add("ProductId");

        DataRow dataRow;

        dataRow = aDataTable.NewRow();


        dataRow["ProductCode"] = "";
        dataRow["ProductName"] = "";
        dataRow["PackSize"] = "";
        dataRow["Batch"] = "";
        dataRow["ExpDate"] = "";
        dataRow["MfgDate"] = "";
        dataRow["Quantity"] = "";
        dataRow["Price"] = "";
        dataRow["Vat"] = "";
        dataRow["TotalAmount"] = "";
        dataRow["ProductId"] = "";

        aDataTable.Rows.Add(dataRow);

        productGridView.DataSource = null;
        productGridView.DataBind();
        productGridView.DataSource = aDataTable;
        productGridView.DataBind();

        CalculateQuantityVatAndValue();
    }

    private void AddRowInGrid()
    {
        DataTable aDataTable = new DataTable();

        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("PackSize");

        aDataTable.Columns.Add("Batch");
        aDataTable.Columns.Add("ExpDate");
        aDataTable.Columns.Add("MfgDate");

        aDataTable.Columns.Add("Quantity");

        aDataTable.Columns.Add("Price");
        aDataTable.Columns.Add("Vat");
        aDataTable.Columns.Add("TotalAmount");

        aDataTable.Columns.Add("ProductId");

        DataRow dataRow;

        if (productGridView.Rows.Count > 0)
        {
            for (int i = 0; i < productGridView.Rows.Count; i++)
            {

                dataRow = aDataTable.NewRow();


                HiddenField unitpriceHiddenField = (HiddenField)productGridView.Rows[i].Cells[0].FindControl("unitpriceHiddenField");
                HiddenField productidHiddenField = (HiddenField)productGridView.Rows[i].Cells[0].FindControl("productidHiddenField");


                TextBox productCodeTextBox = (TextBox)productGridView.Rows[i].Cells[1].FindControl("productCodeTextBox");
                dataRow["ProductCode"] = productCodeTextBox.Text.Trim();

                TextBox productNameTextBox = (TextBox)productGridView.Rows[i].Cells[2].FindControl("productNameTextBox");
                dataRow["ProductName"] = productNameTextBox.Text.Trim();

                TextBox packSizeTextBox = (TextBox)productGridView.Rows[i].Cells[3].FindControl("packSizeTextBox");
                dataRow["PackSize"] = packSizeTextBox.Text;

                TextBox batchTextBox =
                    (TextBox)productGridView.Rows[i].Cells[4].FindControl("batchTextBox");
                dataRow["Batch"] = batchTextBox.Text;

                TextBox expDateTextBox =
                    (TextBox)productGridView.Rows[i].Cells[6].FindControl("expDateDateTextBox");
                dataRow["ExpDate"] = expDateTextBox.Text.Trim();

                TextBox mfgDateTextBox = (TextBox)productGridView.Rows[i].Cells[5].FindControl("mfgDateTextBox");
                dataRow["MfgDate"] = mfgDateTextBox.Text.Trim();

                TextBox quantityTextBox = (TextBox)productGridView.Rows[i].Cells[7].FindControl("reqQtyTextBox");
                dataRow["Quantity"] = quantityTextBox.Text.Trim();

                TextBox costPriceTextBox = (TextBox)productGridView.Rows[i].Cells[8].FindControl("costPriceTextBox");
                dataRow["Price"] = costPriceTextBox.Text.Trim();

                TextBox vatTextBox = (TextBox)productGridView.Rows[i].Cells[9].FindControl("vatTextBox");
                dataRow["Vat"] = vatTextBox.Text.Trim();

                TextBox totalValueTextBox = (TextBox)productGridView.Rows[i].Cells[10].FindControl("totalValueTextBox");
                dataRow["TotalAmount"] = totalValueTextBox.Text.Trim();

                dataRow["ProductId"] = productidHiddenField.Value.Trim();

                aDataTable.Rows.Add(dataRow);
            }
        }
        int sl = aDataTable.Rows.Count;

        dataRow = aDataTable.NewRow();

        dataRow["ProductCode"] = "";
        dataRow["ProductName"] = "";
        dataRow["PackSize"] = "";
        dataRow["Batch"] = "";
        dataRow["ExpDate"] = "";
        dataRow["MfgDate"] = "";
        dataRow["Quantity"] = "";
        dataRow["Price"] = "";
        dataRow["Vat"] = "";
        dataRow["TotalAmount"] = "";
        dataRow["ProductId"] = "";

        aDataTable.Rows.Add(dataRow);


        productGridView.DataSource = null;
        productGridView.DataBind();
        productGridView.DataSource = aDataTable;
        productGridView.DataBind();


        CalculateQuantityVatAndValue();
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
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("ProductId");
        aDataTable.Columns.Add("PackSize");

        aDataTable.Columns.Add("Batch");
        aDataTable.Columns.Add("ExpDate");
        aDataTable.Columns.Add("MfgDate");

        aDataTable.Columns.Add("Quantity");

        aDataTable.Columns.Add("Price");
        aDataTable.Columns.Add("Vat");
        aDataTable.Columns.Add("TotalAmount");

        DataRow dataRow;

        if (productGridView.Rows.Count > 0)
        {
            int sl1 = 1;
            for (int i = 0; i < productGridView.Rows.Count; i++)
            {
                if (i != rowindex)
                {
                    dataRow = aDataTable.NewRow();

                    TextBox productCodeTextBox2 = (TextBox)productGridView.Rows[i].Cells[1].FindControl("productCodeTextBox");
                    dataRow["ProductCode"] = productCodeTextBox2.Text.Trim();
                    TextBox productNameTextBox = (TextBox)productGridView.Rows[i].Cells[2].FindControl("productNameTextBox");
                    dataRow["ProductName"] = productNameTextBox.Text.Trim();
                    TextBox packSizeTextBox = (TextBox)productGridView.Rows[i].Cells[3].FindControl("packSizeTextBox");
                    dataRow["PackSize"] = packSizeTextBox.Text;

                    HiddenField productidHiddenField = (HiddenField)productGridView.Rows[i].Cells[0].FindControl("productidHiddenField");

                    TextBox batchTextBox = (TextBox)productGridView.Rows[i].Cells[4].FindControl("batchTextBox");
                    dataRow["Batch"] = batchTextBox.Text;

                    TextBox expDateTextBox =
                        (TextBox)productGridView.Rows[i].Cells[6].FindControl("expDateDateTextBox");
                    dataRow["ExpDate"] = expDateTextBox.Text.Trim();

                    TextBox mfgDateTextBox = (TextBox)productGridView.Rows[i].Cells[5].FindControl("mfgDateTextBox");
                    dataRow["MfgDate"] = mfgDateTextBox.Text.Trim();

                    TextBox quantityTextBox = (TextBox)productGridView.Rows[i].Cells[7].FindControl("reqQtyTextBox");
                    dataRow["Quantity"] = quantityTextBox.Text.Trim();

                    TextBox costPriceTextBox = (TextBox)productGridView.Rows[i].Cells[8].FindControl("costPriceTextBox");
                    dataRow["Price"] = costPriceTextBox.Text.Trim();

                    TextBox vatTextBox = (TextBox)productGridView.Rows[i].Cells[9].FindControl("vatTextBox");
                    dataRow["Vat"] = vatTextBox.Text.Trim();

                    TextBox totalValueTextBox = (TextBox)productGridView.Rows[i].Cells[10].FindControl("totalValueTextBox");
                    dataRow["TotalAmount"] = totalValueTextBox.Text.Trim();

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

        CalculateQuantityVatAndValue();
    }
    private void GetProductInGrid(int rowindex, string productCode)
    {
        DataTable aDataTable = new DataTable();

        if (!string.IsNullOrEmpty(productCode))
        {

            aDataTable = aWarehouseStockInBll.ProductInfo(productCode);

            if (aDataTable.Rows.Count > 0)
            {
                HiddenField productidHiddenField = (HiddenField)productGridView.Rows[rowindex].Cells[0].FindControl("productidHiddenField");
                productidHiddenField.Value = aDataTable.Rows[0]["ProductId"].ToString();

                TextBox productNameTextBox =
                    (TextBox)productGridView.Rows[rowindex].Cells[2].FindControl("productNameTextBox");
                productNameTextBox.Text = aDataTable.Rows[0]["ProductName"].ToString();

                TextBox packSizeTextBox = (TextBox)productGridView.Rows[rowindex].Cells[3].FindControl("packSizeTextBox");
                packSizeTextBox.Text = aDataTable.Rows[0]["PackSize"].ToString();
            }
        }
    }
    protected void productCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox TextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        TextBox productCodeTextBox = (TextBox)productGridView.Rows[rowindex].Cells[1].FindControl("productCodeTextBox");

        string productCode = productCodeTextBox.Text.Trim();
        GetProductInGrid(rowindex, productCode);
    }


    private void UpdateAllData()
    {
        WarehouseStockInMasterDao aStockInMasterDao = new WarehouseStockInMasterDao();

        aStockInMasterDao.WHStockInMasterID = Convert.ToInt32(stockInIdHiddenField.Value);
        aStockInMasterDao.WHStockInDate = Convert.ToDateTime(stockInDateTextBox.Text.Trim());
        aStockInMasterDao.ManufacId = Convert.ToInt32(manufacturerDropDownList.SelectedValue);
        aStockInMasterDao.TotalVat = Convert.ToDecimal(totalVatTextBox.Text);
        aStockInMasterDao.TotalQuantity = Convert.ToInt32(totalQtyTextBox.Text);
        aStockInMasterDao.TotalValue = Convert.ToDecimal(grandTotalTextBox.Text);
        aStockInMasterDao.ChallanNo = challanNoTextBox.Text;
        aStockInMasterDao.ChallanDate = Convert.ToDateTime(challanDateTextBox.Text);
        aStockInMasterDao.ReferenceNo = referenceNoTextBox.Text;

        if (referenceDateTextBox.Text != "")
        {
            aStockInMasterDao.ReferenceDate = ((referenceDateTextBox.Text).Trim());
        }
        else
        {
            aStockInMasterDao.ReferenceDate = "";
        }

        aStockInMasterDao.Remarks = remarksTextBox.Text;
        aStockInMasterDao.UpdateBy = Session["LoginName"].ToString();
        aStockInMasterDao.UpdateDate = DateTime.Now;

        bool stockInSave = aWarehouseStockInBll.UpdateStockInMasterInfo(aStockInMasterDao);

        aWarehouseStockInBll.DeleteWhStockInDetailById(Convert.ToInt32(stockInIdHiddenField.Value));

        WharehouseStockInDetailsDao aWharehouseStockInDetailsDao;
        List<WharehouseStockInDetailsDao> aDetailList = new List<WharehouseStockInDetailsDao>();

        for (int i = 0; i < productGridView.Rows.Count; i++)
        {
            HiddenField productidHiddenField = (HiddenField)productGridView.Rows[i].Cells[1].FindControl("productidHiddenField");
            TextBox batchTextBox = (TextBox)productGridView.Rows[i].Cells[4].FindControl("batchTextBox");
            TextBox expDateTextBox = (TextBox)productGridView.Rows[i].Cells[6].FindControl("expDateDateTextBox");
            TextBox mfgDateTextBox = (TextBox)productGridView.Rows[i].Cells[5].FindControl("mfgDateTextBox");
            TextBox quantityTextBox = (TextBox)productGridView.Rows[i].Cells[7].FindControl("reqQtyTextBox");
            TextBox costPriceTextBox = (TextBox)productGridView.Rows[i].Cells[8].FindControl("costPriceTextBox");
            TextBox vatTextBox = (TextBox)productGridView.Rows[i].Cells[9].FindControl("vatTextBox");
            TextBox totalValueTextBox = (TextBox)productGridView.Rows[i].Cells[10].FindControl("totalValueTextBox");

            aWharehouseStockInDetailsDao = new WharehouseStockInDetailsDao();

            aWharehouseStockInDetailsDao.WHStockInMasterID = Convert.ToInt32(stockInIdHiddenField.Value);
            aWharehouseStockInDetailsDao.ProductId = Convert.ToInt32(productidHiddenField.Value);
            aWharehouseStockInDetailsDao.Batch = batchTextBox.Text;
            aWharehouseStockInDetailsDao.ExpDate = Convert.ToDateTime(expDateTextBox.Text);
            aWharehouseStockInDetailsDao.MfgDate = Convert.ToDateTime(mfgDateTextBox.Text);
            aWharehouseStockInDetailsDao.Qty = Convert.ToDecimal(quantityTextBox.Text);
            aWharehouseStockInDetailsDao.Price = Convert.ToDecimal(costPriceTextBox.Text);
            aWharehouseStockInDetailsDao.VAT = Convert.ToDecimal(vatTextBox.Text);
            aWharehouseStockInDetailsDao.TotalAmount = Convert.ToDecimal(totalValueTextBox.Text);

            aDetailList.Add(aWharehouseStockInDetailsDao);
        }

        string msg = aWarehouseStockInBll.UpdateWarehouseStockInDetail(aDetailList);
        Clear();
        showMessageBox(msg);
    }

    private bool Validation()
    {
        if (manufacturerDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Select Manufacturer !!!");
            manufacturerDropDownList.Focus();
            manufacturerDropDownList.BackColor = Color.GhostWhite;
            return false;
        }

        if (stockInDateTextBox.Text == "")
        {
            showMessageBox("Please insert stock in date !!!");
            stockInDateTextBox.Focus();
            stockInDateTextBox.BackColor = Color.GhostWhite;
            return false;
        }

        if (challanNoTextBox.Text == "")
        {
            showMessageBox("Please insert challan number !!!");
            challanNoTextBox.Focus();
            challanNoTextBox.BackColor = Color.GhostWhite;
            return false;
        }

        if (challanDateTextBox.Text == "")
        {
            showMessageBox("Please insert challan date !!!");
            challanDateTextBox.Focus();
            challanDateTextBox.BackColor = Color.GhostWhite;
            return false;
        }

        if (productGridView.Rows.Count > 0)
        {
            for (int i = 0; i < productGridView.Rows.Count; i++)
            {
                if (((TextBox)productGridView.Rows[i].FindControl("productCodeTextBox")).Text == "")
                {
                    ((TextBox)productGridView.Rows[i].FindControl("productCodeTextBox")).Focus();
                    showMessageBox("Please fill out product code!!");
                    return false;
                }

                if (((TextBox)productGridView.Rows[i].FindControl("batchTextBox")).Text == "")
                {
                    ((TextBox)productGridView.Rows[i].FindControl("batchTextBox")).Focus();
                    showMessageBox("Please fill out batch!!");
                    return false;
                }

                if (((TextBox)productGridView.Rows[i].FindControl("expDateDateTextBox")).Text == "")
                {
                    ((TextBox)productGridView.Rows[i].FindControl("expDateDateTextBox")).Focus();
                    showMessageBox("Please fill out exp. Date!!");
                    return false;
                }

                if (((TextBox)productGridView.Rows[i].FindControl("mfgDateTextBox")).Text == "")
                {
                    ((TextBox)productGridView.Rows[i].FindControl("mfgDateTextBox")).Focus();
                    showMessageBox("Please fill out Mfg. Date!!");
                    return false;
                }

                if (((TextBox)productGridView.Rows[i].FindControl("reqQtyTextBox")).Text == "")
                {
                    ((TextBox)productGridView.Rows[i].FindControl("reqQtyTextBox")).Focus();
                    showMessageBox("Please fill out Req.Qty!!");
                    return false;
                }

                if (((TextBox)productGridView.Rows[i].FindControl("costPriceTextBox")).Text == "")
                {
                    ((TextBox)productGridView.Rows[i].FindControl("costPriceTextBox")).Focus();
                    showMessageBox("Please fill out Price!!");
                    return false;
                }

                if (((TextBox)productGridView.Rows[i].FindControl("vatTextBox")).Text == "")
                {
                    ((TextBox)productGridView.Rows[i].FindControl("vatTextBox")).Focus();
                    showMessageBox("Please fill out vat!!");
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
            {
                UpdateAllData();
            }
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
        InitialGrid();
        DropDownLoad();
        stockInDateTextBox.Text = string.Empty;
        challanNoTextBox.Text = string.Empty;
        challanDateTextBox.Text = string.Empty;
        referenceNoTextBox.Text = string.Empty;
        referenceDateTextBox.Text = string.Empty;
        remarksTextBox.Text = string.Empty;
        totalQtyTextBox.Text = string.Empty;
        grandTotalTextBox.Text = string.Empty;
        totalVatTextBox.Text = string.Empty;
        stockInIdHiddenField.Value = "";
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


    protected void reqQtyTextBox_OnTextChanged(object sender, EventArgs e)
    {
        TextBox TextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        CalculateTotalValue(rowindex);
    }

    protected void costPriceTextBox_OnTextChanged(object sender, EventArgs e)
    {
        TextBox TextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        CalculateTotalValue(rowindex);
    }

    private void CalculateTotalValue(int rowindex)
    {
        TextBox quantityTextBox = (TextBox)productGridView.Rows[rowindex].Cells[7].FindControl("reqQtyTextBox");
        TextBox costPriceTextBox = (TextBox)productGridView.Rows[rowindex].Cells[8].FindControl("costPriceTextBox");
        TextBox vatTextBox = (TextBox)productGridView.Rows[rowindex].Cells[9].FindControl("vatTextBox");
        TextBox totalValueTextBox = (TextBox)productGridView.Rows[rowindex].Cells[10].FindControl("totalValueTextBox");

        decimal totalValue = 0;
        decimal totalVat = 0;
        string vat = vatTextBox.Text;
        string quantity = quantityTextBox.Text;
        string price = costPriceTextBox.Text;

        if (quantity != "" && price != "" && vat != "")
        {
            totalVat = totalVat + (Convert.ToDecimal(quantity) * Convert.ToDecimal(vat));
            totalValue = totalValue + (totalVat + (Convert.ToDecimal(quantity) * Convert.ToDecimal(price)));
            totalValueTextBox.Text = totalValue.ToString(CultureInfo.InvariantCulture);

            CalculateQuantityVatAndValue();
        }

        else
        {
            totalValueTextBox.Text = "";
            CalculateQuantityVatAndValue();
        }
    }

    private void CalculateQuantityVatAndValue()
    {
        int totalQuantity = 0;
        decimal value = 0;
        decimal totalVat = 0;

        if (productGridView.Rows.Count > 0)
        {
            for (int i = 0; i < productGridView.Rows.Count; i++)
            {
                if (((TextBox)productGridView.Rows[i].FindControl("reqQtyTextBox")).Text != "")
                {
                    int qty = Convert.ToInt32(((TextBox)productGridView.Rows[i].FindControl("reqQtyTextBox")).Text);
                    totalQuantity = totalQuantity + qty;
                }

                if (((TextBox)productGridView.Rows[i].FindControl("vatTextBox")).Text != "")
                {
                    if (((TextBox)productGridView.Rows[i].FindControl("reqQtyTextBox")).Text != "")
                    {
                        int qty = Convert.ToInt32(((TextBox)productGridView.Rows[i].FindControl("reqQtyTextBox")).Text);
                        decimal vat = Convert.ToDecimal(((TextBox)productGridView.Rows[i].FindControl("vatTextBox")).Text);
                        totalVat = totalVat + (qty * vat);
                    }

                }

                if (((TextBox)productGridView.Rows[i].FindControl("totalValueTextBox")).Text != "")
                {
                    decimal costPrice = Convert.ToDecimal(((TextBox)productGridView.Rows[i].FindControl("totalValueTextBox")).Text);
                    value = value + costPrice;
                }
            }

            totalQtyTextBox.Text = totalQuantity.ToString();
            totalVatTextBox.Text = totalVat.ToString(CultureInfo.InvariantCulture);
            grandTotalTextBox.Text = value.ToString(CultureInfo.InvariantCulture);
        }
    }

    protected void totalValueTextBox_OnTextChanged(object sender, EventArgs e)
    {
        CalculateQuantityVatAndValue();
    }

    protected void vatTextBox_OnTextChanged(object sender, EventArgs e)
    {
        TextBox TextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        CalculateTotalValue(rowindex);
    }

    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }

    protected void stockInDateTextBox_OnTextChanged(object sender, EventArgs e)
    {
        DateTime value;

        if (!DateTime.TryParse(stockInDateTextBox.Text, out value))
        {
            stockInDateTextBox.Text = "";
            showMessageBox("Please insert valid date");
        }
    }

    protected void challanDateTextBox_OnTextChanged(object sender, EventArgs e)
    {
        DateTime value;

        if (!DateTime.TryParse(challanDateTextBox.Text, out value))
        {
            challanDateTextBox.Text = "";
            showMessageBox("Please insert valid date");
        }
    }

    protected void referenceDateTextBox_OnTextChanged(object sender, EventArgs e)
    {
        DateTime value;

        if (!DateTime.TryParse(referenceDateTextBox.Text, out value))
        {
            referenceDateTextBox.Text = "";
            showMessageBox("Please insert valid date");
        }
    }

    protected void mfgDateTextBox_OnTextChanged(object sender, EventArgs e)
    {
        TextBox TextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        TextBox mfgDateTextBox = (TextBox)productGridView.Rows[rowindex].Cells[5].FindControl("mfgDateTextBox");

        DateTime value;

        if (!DateTime.TryParse(mfgDateTextBox.Text, out value))
        {
            mfgDateTextBox.Text = "";
            showMessageBox("Please insert valid date");
        }

    }

    protected void expDateDateTextBox_OnTextChanged(object sender, EventArgs e)
    {
        TextBox TextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        TextBox expDateDateTextBox = (TextBox)productGridView.Rows[rowindex].Cells[6].FindControl("expDateDateTextBox");

        DateTime value;

        if (!DateTime.TryParse(expDateDateTextBox.Text, out value))
        {
            expDateDateTextBox.Text = "";
            showMessageBox("Please insert valid date");
        }
    }
}