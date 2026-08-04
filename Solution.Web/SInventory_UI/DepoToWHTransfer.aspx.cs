using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_DepoToWHTransfer : System.Web.UI.Page
{
    SCtoWHTransferDal aDal = new SCtoWHTransferDal();
    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ChalanId();
            Todate();
            LoadDropDown();
        }
    }

    private void Todate()
    {
        chalanDateTextBox.Text = DateTime.Today.ToShortDateString();
    }

    private void LoadDropDown()
    {
        aDal.LoadmanufacturerName(manufacDropDownList);
        aDal.DCLoad(salescenterDropDownList1);
        aDal.ProductLoad(productDropDownList);
        aDal.WareHouseLoad(subdeportDropDownList2);
        manufacDropDownList.SelectedValue = 1.ToString(CultureInfo.InvariantCulture);
        subdeportDropDownList2.SelectedValue = 1.ToString(CultureInfo.InvariantCulture);
        toComUnitCodeTextBox_TextChanged(null, null);
    }

    private void ChalanId()
    {
        chalanNoTextBox.Text = ChalanNoForShow();
    }

    private string ChalanNoForShow()
    {
        string chalanNo = "";
        chalanNo = ChalanNoGenerator(aClsPrimaryKeyFind.PrimaryKeyMax("SChalanId", "tblDepotToWHChalanInfo"));
        return chalanNo;
    }

    private string ChalanNoGenerator(int id)
    {
        string code = string.Empty;
        string Id = id.ToString(CultureInfo.InvariantCulture);

        if (Id.Length == 1)
        {
            Id = "00000" + Id;
        }
        if (Id.Length == 2)
        {
            Id = "0000" + Id;
        }
        if (Id.Length == 3)
        {
            Id = "000" + Id;
        }

        code = "SDC" + Id;

        return code;
    }

    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void fromComUnitCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        string unitCode = salescenterDropDownList1.SelectedItem.Text.Split(':')[0];
        fromComUnitCodeTextBox.Text = unitCode;
        var aDataTable = new DataTable();
        if (!string.IsNullOrEmpty(unitCode))
        {
            aDataTable = aDal.LoadComUnit(unitCode);
            if (aDataTable.Rows.Count > 0)
            {
                fromComUnitNameTextBox.Text = aDataTable.Rows[0]["ComUnitName"].ToString();
                fromComUnitAddressTextBox.Text = aDataTable.Rows[0]["Address"].ToString();
            }
            else
            {
                ShowMessageBox("Company Unit Information Not Found!!");
                fromComUnitNameTextBox.Text = string.Empty;
                fromComUnitAddressTextBox.Text = string.Empty;
                fromComUnitCodeTextBox.Text = string.Empty;
            }
        }
    }

    protected void toComUnitCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        string unitCode = subdeportDropDownList2.SelectedItem.Text.Split(':')[0];
        toComUnitCodeTextBox.Text = unitCode;
        DataTable aDataTable = new DataTable();
        if (!string.IsNullOrEmpty(unitCode))
        {
            aDataTable = aDal.WareHouseInfoLoad(subdeportDropDownList2.SelectedValue);

            if (aDataTable.Rows.Count > 0)
            {
                toComUnitNameTextBox.Text = aDataTable.Rows[0]["WearhouseName"].ToString();
                toComUnitAddressTextBox.Text = aDataTable.Rows[0]["Address"].ToString();
            }
            else
            {
                ShowMessageBox("WH Information Not Found!!");
                toComUnitNameTextBox.Text = string.Empty;
                toComUnitAddressTextBox.Text = string.Empty;
                toComUnitCodeTextBox.Text = string.Empty;
            }
        }
    }

    protected void salescenterDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        string unitCode = salescenterDropDownList1.SelectedItem.Text.Split(':')[0];
        fromComUnitCodeTextBox.Text = unitCode;
        DataTable aDataTable = new DataTable();
        if (!string.IsNullOrEmpty(unitCode))
        {
            aDataTable = aDal.LoadComUnit(unitCode);
            if (aDataTable.Rows.Count > 0)
            {
                fromComUnitNameTextBox.Text = aDataTable.Rows[0]["ComUnitName"].ToString();
                fromComUnitAddressTextBox.Text = aDataTable.Rows[0]["Address"].ToString();
            }
            else
            {
                ShowMessageBox("Company Unit Information Not Found!!");
                fromComUnitNameTextBox.Text = string.Empty;
                fromComUnitAddressTextBox.Text = string.Empty;
                fromComUnitCodeTextBox.Text = string.Empty;
            }
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {

        if (fromComUnitCodeTextBox.Text != "" && productDropDownList.SelectedValue != "")
        {
            DataTable dtdata = aDal.GetProductDcStoreSubdeport(productDropDownList.SelectedValue, fromComUnitCodeTextBox.Text);
            if (dtdata.Rows.Count > 0)
            {
                productGridView.DataSource = dtdata;
                productGridView.DataBind();
            }
            else
            {
                ShowMessageBox("No Product Found!!");
            }
        }
        else
        {
            ShowMessageBox("Please select product & sales center!!");
        }

        
    }

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox)productGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < productGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)productGridView.Rows[i].Cells[0].FindControl("chkSelect");
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

    public bool HasDCStoreId(int dcstoreId)
    {
        for (int i = 0; i < chalanGridView.Rows.Count; i++)
        {
            if (Convert.ToInt32(chalanGridView.DataKeys[i][0].ToString()) == dcstoreId)
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
        aDataTable.Columns.Add("DCStoreId");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("TransferQty");
        aDataTable.Columns.Add("BatchNo");
        aDataTable.Columns.Add("ExpDate");
        aDataTable.Columns.Add("VATAmountPerUnit");
        aDataTable.Columns.Add("UnitPrice");
        aDataTable.Columns.Add("DCStoreFreezeId");
        aDataTable.Columns.Add("hfPurposeId");
        

        DataRow dataRow = null;
        for (int i = 0; i < productGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)productGridView.Rows[i].Cells[0].FindControl("chkSelect");
            if (ChkBoxRows.Checked && ((TextBox)productGridView.Rows[i].Cells[6].FindControl("transferQtyTextBox")).Text.Trim() != "")
            {
                if (HasDCStoreId(Convert.ToInt32(productGridView.DataKeys[i][0].ToString())))
                {
                    dataRow = aDataTable.NewRow();
                    dataRow["ProductCode"] = productGridView.Rows[i].Cells[1].Text;
                    dataRow["ProductName"] = productGridView.Rows[i].Cells[2].Text;
                    dataRow["TransferQty"] =
                        ((TextBox)productGridView.Rows[i].Cells[6].FindControl("transferQtyTextBox")).Text.Trim();

                    dataRow["BatchNo"] = productGridView.Rows[i].Cells[4].Text;
                    dataRow["ExpDate"] = productGridView.Rows[i].Cells[5].Text;
                    dataRow["VATAmountPerUnit"] = productGridView.DataKeys[i][1].ToString();
                    dataRow["DCStoreId"] = productGridView.DataKeys[i][0].ToString();
                    dataRow["UnitPrice"] = productGridView.DataKeys[i][2].ToString();
                    dataRow["DCStoreFreezeId"] = productGridView.DataKeys[i][3].ToString();
                    dataRow["hfPurposeId"] = 1.ToString();

                    aDataTable.Rows.Add(dataRow);
                }
            }
        }

        for (int i = 0; i < chalanGridView.Rows.Count; i++)
        {
            dataRow = aDataTable.NewRow();
            dataRow["ProductCode"] = chalanGridView.Rows[i].Cells[0].Text;
            dataRow["ProductName"] = chalanGridView.Rows[i].Cells[1].Text;
            dataRow["TransferQty"] = chalanGridView.Rows[i].Cells[2].Text;
            dataRow["BatchNo"] = chalanGridView.Rows[i].Cells[3].Text;
            dataRow["ExpDate"] = chalanGridView.Rows[i].Cells[4].Text;
            dataRow["VATAmountPerUnit"] = chalanGridView.DataKeys[i][1].ToString();
            dataRow["DCStoreId"] = chalanGridView.DataKeys[i][0].ToString();
            dataRow["UnitPrice"] = chalanGridView.DataKeys[i][2].ToString();
            dataRow["DCStoreFreezeId"] = chalanGridView.DataKeys[i][3].ToString();

            DropDownList ddlPurpose = ((DropDownList)chalanGridView.Rows[i].Cells[6].FindControl("purposeDropDownList"));
            dataRow["hfPurposeId"] = ddlPurpose.SelectedValue;

            aDataTable.Rows.Add(dataRow);
        }

        chalanGridView.DataSource = aDataTable;
        chalanGridView.DataBind();

        for (int i = 0; i < chalanGridView.Rows.Count; i++)
        {
            DropDownList ddlPurpose = ((DropDownList)chalanGridView.Rows[i].Cells[6].FindControl("purposeDropDownList"));
            aDal.LoadPurposeDropDownList(ddlPurpose);

            HiddenField hfPurpose = ((HiddenField)chalanGridView.Rows[i].Cells[6].FindControl("hfPurposeId"));
            ddlPurpose.SelectedValue = hfPurpose.Value; 
        }

        for (int i = 0; i < chalanGridView.Rows.Count; i++)
        {
            DropDownList ddlPurpose = ((DropDownList)chalanGridView.Rows[i].Cells[6].FindControl("purposeDropDownList"));
            HiddenField hfPurpose = ((HiddenField)chalanGridView.Rows[i].Cells[6].FindControl("hfPurposeId"));
            ddlPurpose.SelectedValue = hfPurpose.Value; 
        }
    }

    protected void DeleteImageButton_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton productCodeTextBox = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("DCStoreId");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("TransferQty");
        aDataTable.Columns.Add("BatchNo");
        aDataTable.Columns.Add("ExpDate");
        aDataTable.Columns.Add("VATAmountPerUnit");
        aDataTable.Columns.Add("UnitPrice");
        aDataTable.Columns.Add("DCStoreFreezeId");
        aDataTable.Columns.Add("hfPurposeId");

        DataRow dataRow = null;
        for (int i = 0; i < chalanGridView.Rows.Count; i++)
        {
            if (i != rowindex)
            {
                dataRow = aDataTable.NewRow();
                dataRow["ProductCode"] = chalanGridView.Rows[i].Cells[0].Text;
                dataRow["ProductName"] = chalanGridView.Rows[i].Cells[1].Text;
                dataRow["TransferQty"] =
                    chalanGridView.Rows[i].Cells[2].Text;

                dataRow["BatchNo"] = chalanGridView.Rows[i].Cells[3].Text;
                dataRow["ExpDate"] = chalanGridView.Rows[i].Cells[4].Text;
                dataRow["VATAmountPerUnit"] = chalanGridView.DataKeys[i][1].ToString();
                dataRow["DCStoreId"] = chalanGridView.DataKeys[i][0].ToString();
                dataRow["UnitPrice"] = chalanGridView.DataKeys[i][2].ToString();
                dataRow["DCStoreFreezeId"] = chalanGridView.DataKeys[i][3].ToString();

                DropDownList ddlPurpose = ((DropDownList)chalanGridView.Rows[i].Cells[6].FindControl("purposeDropDownList"));
                dataRow["hfPurposeId"] = ddlPurpose.SelectedValue; 

                aDataTable.Rows.Add(dataRow);
            }

        }

        chalanGridView.DataSource = aDataTable;
        chalanGridView.DataBind();

        for (int i = 0; i < chalanGridView.Rows.Count; i++)
        {
            DropDownList ddlPurpose = ((DropDownList)chalanGridView.Rows[i].Cells[6].FindControl("purposeDropDownList"));
            aDal.LoadPurposeDropDownList(ddlPurpose);

        }

        for (int i = 0; i < chalanGridView.Rows.Count; i++)
        {
            DropDownList ddlPurpose = ((DropDownList)chalanGridView.Rows[i].Cells[6].FindControl("purposeDropDownList"));
            HiddenField hfPurpose = ((HiddenField)chalanGridView.Rows[i].Cells[6].FindControl("hfPurposeId"));
            ddlPurpose.SelectedValue = hfPurpose.Value;
        }
    }

    public bool Validation()
    {
        if (chalanNoTextBox.Text == "")
        {
            ShowMessageBox("Please Insert chalanNo!!");
            return false;
        }
        if (chalanDateTextBox.Text.Trim() == "")
        {
            ShowMessageBox("Please Insert chalanDate!!");
            return false;
        }
        if (manufacDropDownList.SelectedValue == "")
        {
            ShowMessageBox("Please Select Manufacturer!!");
            return false;
        }
        if (fromComUnitCodeTextBox.Text.Trim() == "")
        {
            ShowMessageBox("Please Select fromComUnit!!");
            return false;
        }
        if (toComUnitCodeTextBox.Text.Trim() == "")
        {
            ShowMessageBox("Please Select toComUnit!!");
            return false;
        }

        if (chalanGridView.Rows.Count < 1)
        {
            ShowMessageBox("Please Add Product!!");
            return false;
        }

        DataTable aTable = aDal.CheckChalanStatus(fromComUnitCodeTextBox.Text.ToUpper().Trim());
        
        if (aTable.Rows.Count > 0)
        {
            ShowMessageBox("Operation not possible because Challan exist for transfer!!");
            return false;
        }



        return true;
    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (Validation())
        {
            DepoToWHTransferDao aChalanInfo = new DepoToWHTransferDao()
            {
                ChalanDate = Convert.ToDateTime(chalanDateTextBox.Text.Trim()),
                ChalanNo = chalanNoTextBox.Text.Trim(),
                TrackNo = truckNoTextBox.Text.Trim(),
                DriverName = driverNameTextBox.Text.Trim(),
                FromComUnitCode = fromComUnitCodeTextBox.Text.ToUpper().Trim(),
                FromComUnitName = fromComUnitNameTextBox.Text.Trim(),
                FromComUnitAddress = fromComUnitAddressTextBox.Text.Trim(),
                WHCode = toComUnitCodeTextBox.Text.ToUpper().Trim(),
                WHName = toComUnitNameTextBox.Text.Trim(),
                WHAddress = toComUnitAddressTextBox.Text.Trim(),
                ManufacId = Convert.ToInt32(manufacDropDownList.SelectedValue),
            };
            decimal totalvalue = 0;
            decimal totalvat = 0;
            decimal grandtotal = 0;
            for (int i = 0; i < chalanGridView.Rows.Count; i++)
            {
                totalvat +=
                    Convert.ToDecimal(
                        chalanGridView.Rows[i].Cells[2].Text) *
                    Convert.ToDecimal(chalanGridView.DataKeys[i][1].ToString());
                totalvalue += Convert.ToDecimal(chalanGridView.DataKeys[i][2].ToString()) *
                              Convert.ToDecimal(
                                  chalanGridView.Rows[i].Cells[2].Text);
                grandtotal += Convert.ToDecimal(chalanGridView.DataKeys[i][2].ToString()) *
                              Convert.ToDecimal(
                                  chalanGridView.Rows[i].Cells[2].Text) +
                              Convert.ToDecimal(
                                  chalanGridView.Rows[i].Cells[2].Text) *
                              Convert.ToDecimal(chalanGridView.DataKeys[i][1].ToString());
            }
            aChalanInfo.TotalValue = totalvalue;
            aChalanInfo.TotalVat = totalvat;
            aChalanInfo.GrandTotal = grandtotal;

            int chalanId;
            bool status = SaveDataForChalanInfo(aChalanInfo, out chalanId);
            DataTable dt = aDal.LoadChalanById(chalanId.ToString(CultureInfo.InvariantCulture));
            
            if (dt.Rows.Count > 0)
            {
                printChalanNoTextBox.Text = dt.Rows[0]["ChalanNo"].ToString();
            }

            List<DepoToWHTransferDetailDao> aChalanDetailList = new List<DepoToWHTransferDetailDao>();

            if (status == true)
            {
                DepoToWHTransferDetailDao aChalanDetail;

                for (int i = 0; i < chalanGridView.Rows.Count; i++)
                {
                    aChalanDetail = new DepoToWHTransferDetailDao();

                    aChalanDetail.ChalanId = chalanId;
                    aChalanDetail.DCStoreId = Convert.ToInt32(chalanGridView.DataKeys[i][0].ToString());
                    aChalanDetail.DCStoreFreezeId = Convert.ToInt32(chalanGridView.DataKeys[i][3].ToString());
                    aChalanDetail.ProductCode = chalanGridView.Rows[i].Cells[0].Text;
                    aChalanDetail.ProductName = chalanGridView.Rows[i].Cells[1].Text;
                    aChalanDetail.Quantity = Convert.ToDecimal(chalanGridView.Rows[i].Cells[2].Text);
                    aChalanDetail.BatchNo = chalanGridView.Rows[i].Cells[3].Text;
                    aChalanDetail.UnitPrice = Convert.ToDecimal(chalanGridView.DataKeys[i][2].ToString());

                    DropDownList ddlPurpose = ((DropDownList)chalanGridView.Rows[i].Cells[6].FindControl("purposeDropDownList"));
                    aChalanDetail.PurposeId = Convert.ToInt32(ddlPurpose.SelectedValue);

                    aChalanDetail.Value =
                        Convert.ToDecimal(chalanGridView.DataKeys[i][2].ToString())*
                        Convert.ToDecimal(chalanGridView.Rows[i].Cells[2].Text);
                    aChalanDetail.Vat =
                        Convert.ToDecimal(chalanGridView.Rows[i].Cells[2].Text)*
                        Convert.ToDecimal(chalanGridView.DataKeys[i][1].ToString());
                    aChalanDetail.ValueWVat =
                        Convert.ToDecimal(chalanGridView.DataKeys[i][2].ToString())*
                        Convert.ToDecimal(chalanGridView.Rows[i].Cells[2].Text) +
                        Convert.ToDecimal(chalanGridView.Rows[i].Cells[2].Text)*
                        Convert.ToDecimal(chalanGridView.DataKeys[i][1].ToString());
                    
                    aChalanDetailList.Add(aChalanDetail);
                }
                if (SaveDataForChalanDetail(aChalanDetailList))
                {
                    ShowMessageBox("Data save successfully !!!");
                    Clear();
                    Todate();
                    ChalanId();
                }

            }
        }
    }

    public void Clear()
    {
        prodctCodeTextBox.Text = string.Empty;
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
        chalanGridView.DataSource = null;
        chalanGridView.DataBind();
        productGridView.DataSource = null;
        productGridView.DataBind();
    }

    public bool SaveDataForChalanDetail(List<DepoToWHTransferDetailDao> aIChalanList)
    {
        foreach (var chalanDetail in aIChalanList)
        {
            chalanDetail.ChalanDetailId = aClsPrimaryKeyFind.PrimaryKeyMax("SChalanDetailsId", "tblDepotToWHChalanDetail");
            aDal.SaveDataForChalanDetail(chalanDetail);

            //if (chalanDetail.DCStoreFreezeId != 0)
            //{
            //    DataTable dtdcinfo = DcFreezeInfo(chalanDetail.DCStoreFreezeId.ToString());
            //    UpdateFreezeQuantity(chalanDetail.DCStoreFreezeId.ToString(), (Convert.ToDecimal(dtdcinfo.Rows[0]["StockQty"].ToString()) - chalanDetail.Quantity).ToString());
            //}
            //else
            //{
            //    DataTable dtdcinfo = DCInfoWithDCId(chalanDetail.DCStoreId.ToString());
            //    UpdateDCStockQuantity(chalanDetail.DCStoreId.ToString(), (Convert.ToDecimal(dtdcinfo.Rows[0]["StockQty"].ToString()) - chalanDetail.Quantity).ToString());
            //}

           
        }
        return true;
    }

    private void UpdateFreezeQuantity(string dcFreezeId, string Quantity)
    {
        aDal.UpdateFreezeQuantity(dcFreezeId, Quantity);
    }

    private DataTable DcFreezeInfo(string dcFreezeId)
    {
        return aDal.DcFreezeInfoId(dcFreezeId);
    }

    public void UpdateDCStockQuantity(string stockId, string Quantity)
    {
        aDal.UpdateDCStockQuantity(stockId, Quantity);
    }

    public DataTable DCInfoWithDCId(string dcstoreId)
    {
        return aDal.DCInfoWithDCId(dcstoreId);
    }

    public bool SaveDataForChalanInfo(DepoToWHTransferDao aChalanInfo, out int ChalanId)
    {
        ChalanId = aClsPrimaryKeyFind.PrimaryKeyMax("SChalanId", "tblDepotToWHChalanInfo");
        aChalanInfo.ChalanId = ChalanId;
        aChalanInfo.ChalanNo = ChalanNoGenerator(aChalanInfo.ChalanId);
        return aDal.SaveDataForChalanInfo(aChalanInfo);
    }



    protected void Button2_Click(object sender, EventArgs e)
    {
        string url = "../SInventory_RPTVIEW/DcToWHChalanReportViewer.aspx?chalanno=" + printChalanNoTextBox.Text;
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void dQtyTextBox_TextChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < productGridView.Rows.Count; i++)
        {
            //CheckBox cbReject = (CheckBox)productGridView.Rows[i].FindControl("chkSelect");
            //if (cbReject.Checked)
            {
                int rowindex = i;
                decimal mainqty = 0;
                decimal delqty = 0;
                delqty =
                    string.IsNullOrEmpty(
                        ((TextBox)productGridView.Rows[rowindex].Cells[3].FindControl("transferQtyTextBox")).Text)
                        ? 0
                        : Convert.ToDecimal(
                            ((TextBox)productGridView.Rows[rowindex].Cells[3].FindControl("transferQtyTextBox")).Text);

                mainqty = string.IsNullOrEmpty(productGridView.Rows[i].Cells[3].Text)
                    ? 0
                    : Convert.ToDecimal(productGridView.Rows[i].Cells[3].Text);
                if (delqty <= mainqty)
                {

                }
                else
                {
                    ShowMessageBox("Transfer Qty. cantbe more then Stock Quantity");
                    ((TextBox)productGridView.Rows[rowindex].Cells[3].FindControl("transferQtyTextBox")).Text =
                        string.Empty;
                }
            }
        }
    }

    protected void Button3_Click(object sender, EventArgs e)
    {
        if (fromComUnitCodeTextBox.Text != "" && productDropDownList.SelectedValue != "")
        {
            DataTable dtdata = aDal.GetProductDcFreezeStore(productDropDownList.SelectedValue, fromComUnitCodeTextBox.Text);
            if (dtdata.Rows.Count > 0)
            {
                productGridView.DataSource = dtdata;
                productGridView.DataBind();
            }
            else
            {
                ShowMessageBox("No Product Found!!");
            }
        }
        else
        {
            ShowMessageBox("Please select product & sales center!!");
        }
    }

    protected void DistrictInfoListImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("DepoToWhTransferView.aspx");
    }

    protected void viewLinkButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("DepoToWhTransferView.aspx");
    }

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("DepoToWHTransfer.aspx");

    }
}