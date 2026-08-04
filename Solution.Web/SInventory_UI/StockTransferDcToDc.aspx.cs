using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_StockTransferDcToDc : System.Web.UI.Page
{
    ChalanBLL aChalanBll=new ChalanBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            InitialGrid();
            ChalanId();
            Todate();
        }
        
    }

    public void Todate()
    {
        chalanDateTextBox.Text = DateTime.Today.ToShortDateString();
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    public void Clear()
    {
        chalanDateTextBox.Text = string.Empty;
        chalanNoTextBox.Text = string.Empty;
        fromComUnitAddressTextBox.Text = string.Empty;
        fromComUnitCodeTextBox.Text = string.Empty;
        fromComUnitNameTextBox.Text = string.Empty;
        toComUnitNameTextBox.Text = string.Empty;
        toComUnitCodeTextBox.Text = string.Empty;
        toComUnitAddressTextBox.Text = string.Empty;
        driverNameTextBox.Text = string.Empty;
        truckNoTextBox.Text = string.Empty;
        InitialGrid();
    }
    protected void productCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        DCStoreBLL _aDcStockReceiveBll = new DCStoreBLL();

        TextBox productCodeTextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        TextBox productCodeTextBox1 = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("productCodeTextBox");

        string productCode = productCodeTextBox1.Text.Trim();
        DataTable aDataTable = new DataTable();
        if (!string.IsNullOrEmpty(productCode))
        {
            aDataTable = _aDcStockReceiveBll.ProductInfo(productCode);
            if (aDataTable.Rows.Count > 0)
            {
                TextBox productNameTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[2].FindControl("productNameTextBox");
                productNameTextBox.Text = aDataTable.Rows[0]["ProductName"].ToString();
            }
        }
    }

    public void GetProduct(int rowindex,string productCode)
    {
        DCStoreBLL _aDcStockReceiveBll = new DCStoreBLL();

        DataTable aDataTable = new DataTable();
        if (!string.IsNullOrEmpty(productCode))
        {
            aDataTable = _aDcStockReceiveBll.ProductInfo(productCode);
            if (aDataTable.Rows.Count > 0)
            {
                TextBox productNameTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[2].FindControl("productNameTextBox");
                productNameTextBox.Text = aDataTable.Rows[0]["ProductName"].ToString();
            }
        }
    }
    
    
    protected void submitButton_Click1(object sender, EventArgs e)
    {
        ChalanInfo aChalanInfo = new ChalanInfo()
        {
            ChalanDate = Convert.ToDateTime(chalanDateTextBox.Text.Trim()),
            ChalanNo = chalanNoTextBox.Text.Trim(),
            TrackNo = truckNoTextBox.Text.Trim(),
            DriverName = driverNameTextBox.Text.Trim(),
            FromComUnitCode = fromComUnitCodeTextBox.Text.Trim(),
            FromComUnitName = fromComUnitNameTextBox.Text.Trim(),
            FromComUnitAddress = fromComUnitAddressTextBox.Text.Trim(),
            ToComUnitCode = toComUnitCodeTextBox.Text.Trim(),
            ToComUnitName = toComUnitNameTextBox.Text.Trim(),
            ToComUnitAddress = toComUnitAddressTextBox.Text.Trim(),
        };

        int chalanId;
        bool status = aChalanBll.SaveDataForChalanInfo(aChalanInfo, out chalanId);

        List<ChalanDetail> aChalanDetailList = new List<ChalanDetail>();

        if (status == true)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                TextBox productCodeTextBox =
                    (TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("productCodeTextBox");
                TextBox productNameTextBox =
                    (TextBox)gridLineItemGridView.Rows[i].Cells[2].FindControl("productNameTextBox");
                TextBox quantityTextBox =
                    (TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("quantityTextBox");
                ChalanDetail aChalanDetail = new ChalanDetail()
                {
                    ChalanId = chalanId,
                    ProductCode = productCodeTextBox.Text.Trim(),
                    ProductName = productNameTextBox.Text.Trim(),
                    Quantity = Convert.ToDecimal(quantityTextBox.Text.Trim()),
                };


                aChalanDetailList.Add(aChalanDetail);

            }
            if (aChalanBll.SaveDataForChalanDetail(aChalanDetailList))
            {
                showMessageBox("Data save successfully");
                ChalanId();
            }
            Clear();
            Todate();
        }
    }
    public void ChalanId()
    {
        ChalanBLL aChalanBll = new ChalanBLL();
        chalanNoTextBox.Text = aChalanBll.ChalanNoForShow();
    }
    private void InitialGrid()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("Quantity");
        DataRow dataRow;

        dataRow = aDataTable.NewRow();

        dataRow["SL"] = "1";
        dataRow["ProductCode"] = "";
        dataRow["ProductName"] = "";
        dataRow["Quantity"] = "";
        aDataTable.Rows.Add(dataRow);

        gridLineItemGridView.DataSource = null;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.DataSource = aDataTable;
        gridLineItemGridView.DataBind();

    }
    
    protected void fromComUnitCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        string unitCode = fromComUnitCodeTextBox.Text.Trim();
        DataTable aDataTable = new DataTable();
        if (!string.IsNullOrEmpty(unitCode))
        {
            aDataTable = aChalanBll.ComUnit(unitCode);
            if (aDataTable.Rows.Count > 0)
            {
                fromComUnitNameTextBox.Text = aDataTable.Rows[0]["ComUnitName"].ToString();
                fromComUnitAddressTextBox.Text = aDataTable.Rows[0]["Address"].ToString();
            }
            else
            {
                showMessageBox("Company Unit Information Not Found!!");
            }
        }
    }
    protected void toComUnitCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        string unitCode = toComUnitCodeTextBox.Text.Trim();
        DataTable aDataTable = new DataTable();
        if (!string.IsNullOrEmpty(unitCode))
        {
            aDataTable = aChalanBll.ComUnit(unitCode);
            if (aDataTable.Rows.Count > 0)
            {
                toComUnitNameTextBox.Text = aDataTable.Rows[0]["ComUnitName"].ToString();
                toComUnitAddressTextBox.Text = aDataTable.Rows[0]["Address"].ToString();
            }
            else
            {
                showMessageBox("Company Unit Information Not Found!!");
            }
        }
    }
    
    protected void AddLButton_Click(object sender, ImageClickEventArgs e)
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("Quantity");
        
        DataRow dataRow;

        if (gridLineItemGridView.Rows.Count > 0)
        {
            for (int i = 0; i < gridLineItemGridView.Rows.Count; i++)
            {
                dataRow = aDataTable.NewRow();

                dataRow["SL"] = Convert.ToString(i + 1);
                dataRow["ProductCode"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("productCodeTextBox")).Text.Trim();
                dataRow["ProductName"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[2].FindControl("productNameTextBox")).Text.Trim();
                dataRow["Quantity"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("quantityTextBox")).Text.Trim();
                aDataTable.Rows.Add(dataRow);
            }
        }

        int sl = aDataTable.Rows.Count;
        dataRow = aDataTable.NewRow();

        dataRow["SL"] = Convert.ToString(sl + 1);
        dataRow["ProductCode"] = "";
        dataRow["ProductName"] = "";
        dataRow["Quantity"] = "";
        aDataTable.Rows.Add(dataRow);

        gridLineItemGridView.DataSource = null;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.DataSource = aDataTable;
        gridLineItemGridView.DataBind();

    }
    protected void DeleteImageButton_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton productCodeTextBox = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("Quantity");
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
                    dataRow["ProductCode"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[1].FindControl("productCodeTextBox")).Text.Trim();
                    dataRow["ProductName"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[2].FindControl("productNameTextBox")).Text.Trim();
                    dataRow["Quantity"] = ((TextBox)gridLineItemGridView.Rows[i].Cells[3].FindControl("quantityTextBox")).Text.Trim();
                    aDataTable.Rows.Add(dataRow);
                    sl1 += 1;
                }
            }
        }

        gridLineItemGridView.DataSource = null;
        gridLineItemGridView.DataBind();
        gridLineItemGridView.DataSource = aDataTable;
        gridLineItemGridView.DataBind();

    }
    protected void productNameTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox TextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        string product = ((TextBox)gridLineItemGridView.Rows[rowindex].Cells[2].FindControl("productNameTextBox")).Text;

        if (!string.IsNullOrEmpty(product))
        {
            if (product.Contains(':'))
            {
                string[] proNameAndPackSize = product.Split(':');


                TextBox productCodeTextBox = (TextBox)gridLineItemGridView.Rows[rowindex].Cells[1].FindControl("productCodeTextBox");
                productCodeTextBox.Text = proNameAndPackSize[1];
                string productCode = productCodeTextBox.Text.Trim();
                GetProduct(rowindex, productCode);
            }

        }

    }
}