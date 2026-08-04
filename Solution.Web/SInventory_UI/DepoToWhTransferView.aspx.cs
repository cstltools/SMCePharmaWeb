using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.SInventory_DAL;

public partial class SInventory_UI_DepoToWhTransferView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();

    SCtoWHTransferDal areaBll = new SCtoWHTransferDal();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AreaLoad();
        }
    }

    private void AreaLoad()
    {
        aDataTable = areaBll.LoadDepoToWHTransferInfo();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string areaId = loadGridView.DataKeys[rowindex][0].ToString();

            if (areaBll.DeleteDepoToWHTransfer(areaId))
            {
                ShowMessageBox("Delete successfully !!!");
            }

            AreaLoad();
        }

        if (e.CommandName == "TransferData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string areaId = loadGridView.DataKeys[rowindex][0].ToString();

            TransferStock(areaId);
            AreaLoad();
        }
    }

    private void TransferStock(string areaId)
    {
        DataTable aTable = areaBll.LoadChallanDetailById(areaId);

        if (aTable.Rows.Count > 0)
        {
            bool status = false;

            for (int i = 0; i < aTable.Rows.Count; i++)
            {


                if (aTable.Rows[i].Field<int>("DCStoreId") != 0 && aTable.Rows[i].Field<int>("DCStoreFreezeId") == 0)
                {
                    DataTable dtdcinfo = DCInfoWithDCId(aTable.Rows[i].Field<int>("DCStoreId").ToString());
                    status = UpdateDCStockQuantity(aTable.Rows[i].Field<int>("DCStoreId").ToString(), (Convert.ToDecimal(dtdcinfo.Rows[0]["StockQty"].ToString()) - aTable.Rows[i].Field<Decimal>("Quantity")).ToString());
                }
                else
                {
                    DataTable dtdcinfo = DcFreezeInfo(aTable.Rows[i].Field<int>("DCStoreFreezeId").ToString());
                    status = UpdateFreezeQuantity(aTable.Rows[i].Field<int>("DCStoreFreezeId").ToString(),
                        (Convert.ToDecimal(dtdcinfo.Rows[0]["StockQty"].ToString()) - aTable.Rows[i].Field<Decimal>("Quantity")).ToString());
                }
            }

            if (status)
            {
                if (areaBll.UpdateChalanMasterStatus(areaId))
                {
                    ShowMessageBox("Stock Transfer Complete !!!");
                }
            }
        }
    }

    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }


    public bool UpdateDCStockQuantity(string stockId, string Quantity)
    {
       return areaBll.UpdateDCStockQuantity(stockId, Quantity);
    }

    public DataTable DCInfoWithDCId(string dcstoreId)
    {
        return areaBll.DCInfoWithDCId(dcstoreId);


    }

    private bool UpdateFreezeQuantity(string dcFreezeId, string Quantity)
    {
        return areaBll.UpdateFreezeQuantity(dcFreezeId, Quantity);
    }

    private DataTable DcFreezeInfo(string dcFreezeId)
    {
        return areaBll.DcFreezeInfoId(dcFreezeId);
    }

    private void PopUp(string Id)
    {
        string url = "AreaEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
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
    protected void areaInfoNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("DepoToWHTransfer.aspx");
    }
    protected void areaReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        AreaLoad();
    }
}