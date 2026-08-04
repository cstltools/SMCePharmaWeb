using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_SampleStockforWarehouse : System.Web.UI.Page
{
    SampleStockForWHBll aConventionBll = new SampleStockForWHBll();


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            aConventionBll.ProductLoadBll(productDropDownList);
            aConventionBll.SalesCenterLoadBll(DistributioncenterDropDownList1);
        }

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

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("WhFreezeStockRelease.aspx");
    }

    protected void ListImageButton_Click(object sender, EventArgs e)
    {

        Response.Redirect("~/SInventory_UI/SampleStockForWareHouseView.aspx");

    }

    public bool HasSubDCStoreId(int dcstoreId)
    {
        for (int i = 0; i < ProductGridView.Rows.Count; i++)
        {
            if (Convert.ToInt32(ProductGridView.DataKeys[i][0].ToString()) == dcstoreId)
            {
                return false;
                break;
            }
        }
        return true;
    }
    protected void addButton_Click(object sender, EventArgs e)
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("ReceiveId");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("ReceiveDate");
        aDataTable.Columns.Add("BatchNo");
        aDataTable.Columns.Add("ExpDate");
        aDataTable.Columns.Add("StockInQty");
        aDataTable.Columns.Add("ConventionStock");

        DataRow dataRow = null;
        for (int i = 0; i < DerectStoctGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)DerectStoctGridView.Rows[i].Cells[0].FindControl("chkSelect");
            if (ChkBoxRows.Checked && ((TextBox)DerectStoctGridView.Rows[i].Cells[6].FindControl("ConventionTextBox")).Text.Trim() != "")
            {
                if (HasSubDCStoreId(Convert.ToInt32(DerectStoctGridView.DataKeys[i][0].ToString())))
                {
                    dataRow = aDataTable.NewRow();
                    dataRow["ReceiveId"] = DerectStoctGridView.DataKeys[i][0].ToString();
                    dataRow["ProductCode"] = DerectStoctGridView.Rows[i].Cells[1].Text;
                    dataRow["ProductName"] = DerectStoctGridView.Rows[i].Cells[2].Text;
                    dataRow["ReceiveDate"] = DerectStoctGridView.Rows[i].Cells[6].Text;
                    dataRow["BatchNo"] = DerectStoctGridView.Rows[i].Cells[4].Text;
                    dataRow["ExpDate"] = DerectStoctGridView.Rows[i].Cells[5].Text;
                    dataRow["StockInQty"] = DerectStoctGridView.Rows[i].Cells[3].Text;
                    dataRow["ConventionStock"] = ((TextBox)DerectStoctGridView.Rows[i].Cells[7].FindControl("ConventionTextBox")).Text.Trim();
                    aDataTable.Rows.Add(dataRow);
                }
            }
        }
        for (int i = 0; i < ProductGridView.Rows.Count; i++)
        {
            dataRow = aDataTable.NewRow();
            dataRow["ReceiveId"] = ProductGridView.DataKeys[i][0].ToString();
            dataRow["ProductCode"] = ProductGridView.Rows[i].Cells[0].Text;
            dataRow["ProductName"] = ProductGridView.Rows[i].Cells[1].Text;
            dataRow["ReceiveDate"] = ProductGridView.Rows[i].Cells[2].Text;
            dataRow["BatchNo"] = ProductGridView.Rows[i].Cells[3].Text;
            dataRow["ExpDate"] = ProductGridView.Rows[i].Cells[4].Text;
            dataRow["StockInQty"] = ProductGridView.Rows[i].Cells[5].Text;
            dataRow["ConventionStock"] = ProductGridView.Rows[i].Cells[6].Text;

            aDataTable.Rows.Add(dataRow);
        }

        ProductGridView.DataSource = aDataTable;
        ProductGridView.DataBind();
    }

    protected void DeleteImageButton_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton productCodeTextBox = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("ReceiveId");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("ReceiveDate");
        aDataTable.Columns.Add("BatchNo");
        aDataTable.Columns.Add("ExpDate");
        aDataTable.Columns.Add("StockInQty");
        aDataTable.Columns.Add("ConventionStock");


        DataRow dataRow = null;
        for (int i = 0; i < ProductGridView.Rows.Count; i++)
        {
            if (i != rowindex)
            {
                dataRow = aDataTable.NewRow();
                dataRow["ReceiveId"] = ProductGridView.DataKeys[i][0].ToString();
                dataRow["ProductCode"] = ProductGridView.Rows[i].Cells[0].Text;
                dataRow["ProductName"] = ProductGridView.Rows[i].Cells[1].Text;
                dataRow["ReceiveDate"] = ProductGridView.Rows[i].Cells[2].Text;
                dataRow["BatchNo"] = ProductGridView.Rows[i].Cells[3].Text;
                dataRow["ExpDate"] = ProductGridView.Rows[i].Cells[4].Text;
                dataRow["StockInQty"] = ProductGridView.Rows[i].Cells[5].Text;
                dataRow["ConventionStock"] = ProductGridView.Rows[i].Cells[6].Text;

                aDataTable.Rows.Add(dataRow);
            }

        }

        ProductGridView.DataSource = aDataTable;
        ProductGridView.DataBind();

    }



    protected void dQtyTextBox_TextChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < DerectStoctGridView.Rows.Count; i++)
        {
            CheckBox cbReject = (CheckBox)DerectStoctGridView.Rows[i].FindControl("chkSelect");
            if (cbReject.Checked)
            {
                int rowindex = i;
                decimal mainqty = 0;
                decimal delqty = 0;
                delqty =
                    string.IsNullOrEmpty(
                        ((TextBox)DerectStoctGridView.Rows[rowindex].Cells[3].FindControl("ConventionTextBox")).Text)
                        ? 0
                        : Convert.ToDecimal(
                            ((TextBox)DerectStoctGridView.Rows[rowindex].Cells[3].FindControl("ConventionTextBox")).Text);

                mainqty = string.IsNullOrEmpty(DerectStoctGridView.Rows[i].Cells[3].Text)
                    ? 0
                    : Convert.ToDecimal(DerectStoctGridView.Rows[i].Cells[3].Text);
                if (delqty <= mainqty)
                {

                }
                else
                {
                    showMessageBox("Stock Out Qty. can't be more then Stock Quantity");
                    ((TextBox)DerectStoctGridView.Rows[rowindex].Cells[3].FindControl("ConventionTextBox")).Text =
                        string.Empty;
                }
            }

        }



    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        DataTable dtdata = aConventionBll.GetProductDcStore(productDropDownList.SelectedValue);
        if (dtdata.Rows.Count > 0)
        {
            DerectStoctGridView.DataSource = dtdata;
            DerectStoctGridView.DataBind();
        }
        else
        {
            showMessageBox("No Product Found!!");
        }

    }

    protected void DistributioncenterDropDownList1_OnSelectedIndexChanged(object sender, EventArgs e)
    {

        Session["ComUnitId"] = null;
        Session["ComUnitId"] = DistributioncenterDropDownList1.SelectedValue;
    }


    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox)DerectStoctGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < DerectStoctGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)DerectStoctGridView.Rows[i].Cells[0].FindControl("chkSelect");
            if (ChkBoxHeader.Checked == true)
            {
                ChkBoxRows.Checked = true;
            }
            else
            {
                ChkBoxRows.Checked = false;
            }
        }
    }
    private void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    private void Clear()
    {

        DateTextBox.Text = string.Empty;

        ActionDropDownList.SelectedValue = string.Empty;
        productDropDownList.SelectedValue = string.Empty;
        DistributioncenterDropDownList1.SelectedValue = string.Empty;
        ProductGridView.DataBind();
        DerectStoctGridView.DataSource = null;
        DerectStoctGridView.DataBind();

    }
    private bool Validation()
    {

        if (DistributioncenterDropDownList1.SelectedValue == "")
        {
            showMessageBox("Please Select Distribution center!!");
            return false;
        }
        if (ActionDropDownList.SelectedValue == "0")
        {
            showMessageBox("Please Select Action !!");
            return false;
        }
        if (DateTextBox.Text.Trim() == "")
        {
            showMessageBox("Please Insert  Date!!");
            return false;
        }

        if (productDropDownList.Text.Trim() == "")
        {
            showMessageBox("Please Select Product!!");
            return false;
        }

        if (ProductGridView.Rows.Count < 1)
        {
            showMessageBox("Please Add product and Qty");
            return false;
        }
        return true;
    }
    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (Validation())
        {
            SampleStockForWareHouseMaster aDcStockOutMasterDao = new SampleStockForWareHouseMaster()
            {
                WareHouseId = Convert.ToInt32(DistributioncenterDropDownList1.SelectedValue),
                Action = Convert.ToString(ActionDropDownList.SelectedItem.Text),
                Date = Convert.ToDateTime(DateTextBox.Text.Trim()),
                EntryBy = Session["LoginName"].ToString(),
                EntryDate = Convert.ToDateTime(DateTime.Now),
                Status = "Posted",
            };
            int SubDcStockOutMasterId;
            bool status = aConventionBll.SaveDataForSubDcStockOutMasterBll(aDcStockOutMasterDao, out SubDcStockOutMasterId);

            List<SampleStockForWHDetails> aStockOutDetailsDaoList = new List<SampleStockForWHDetails>();

            if (status == true)
            {
                for (int i = 0; i < ProductGridView.Rows.Count; i++)
                {
                    SampleStockForWHDetails aStockOutDetailsDao = new SampleStockForWHDetails();
                    aStockOutDetailsDao.SampleStockForWHMasterId = SubDcStockOutMasterId;
                    aStockOutDetailsDao.ReceiveId = Convert.ToInt32(ProductGridView.DataKeys[i][0].ToString());
                    aStockOutDetailsDao.ProductCode = ProductGridView.Rows[i].Cells[0].Text;
                    aStockOutDetailsDao.ProductName = ProductGridView.Rows[i].Cells[1].Text;
                    aStockOutDetailsDao.BatchNo = ProductGridView.Rows[i].Cells[3].Text;
                    aStockOutDetailsDao.ExpDate = Convert.ToDateTime(ProductGridView.Rows[i].Cells[4].Text);
                    aStockOutDetailsDao.ReceiveDate = Convert.ToDateTime(ProductGridView.Rows[i].Cells[2].Text);
                    aStockOutDetailsDao.SampleStock = Convert.ToInt32(ProductGridView.Rows[i].Cells[6].Text);
                    aStockOutDetailsDaoList.Add(aStockOutDetailsDao);
                }
                if (aConventionBll.SaveDataForSubStockOutDetailBll(aStockOutDetailsDaoList))
                {
                    if (aConventionBll.StockOutDetail(aStockOutDetailsDaoList))
                    {
                        showMessageBox("Data save successfully");
                        Clear();
                        Response.Redirect("~/SInventory_UI/SampleStockForWareHouseView.aspx");
                    }
           
                }

            }

        }
    }
}