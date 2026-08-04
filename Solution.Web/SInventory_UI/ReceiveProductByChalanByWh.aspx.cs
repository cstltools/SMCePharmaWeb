using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ReceiveProductByChalanByWh : System.Web.UI.Page
{
    StockRcvByWhDal aDal = new StockRcvByWhDal();
    SCtoWHTransferDal aCtoWhTransferDal=new SCtoWHTransferDal();
    DataTable aTable = new DataTable();
    private string reqId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            reqId = Request.QueryString["ReqId"];
            LoadInfo(reqId);
            LoadGrid(reqId);
        }
    }


    private void LoadInfo(string reqId)
    {
        aTable = aDal.LoadMasterInfo(reqId);
        hdReqId.Value = reqId;
        clnNoTextBox.Text = aTable.Rows[0]["IssueChalanNo"].ToString();
        clnDateTextBox.Text = Convert.ToDateTime(aTable.Rows[0]["IssuChalanDate"].ToString()).ToString("dd-MMM-yyyy");
        rcvDateTextBox.Text = Convert.ToDateTime(System.DateTime.Today.ToString()).ToString("dd-MMM-yyyy");
        driverNameTextBox.Text = aTable.Rows[0]["DriverName"].ToString();
        truckTextBox.Text = aTable.Rows[0]["TruckNo"].ToString();
        hdComUnitId.Value = aTable.Rows[0]["ComUnitId"].ToString();
    }


    private void LoadGrid(string reqId)
    {
        DataTable aDataTableForGrid = aDal.GetChallanDetailByReqId(reqId);

        if (aDataTableForGrid.Rows.Count > 0)
        {
            rcvGridView.DataSource = aDataTableForGrid;
            rcvGridView.DataBind();
        }
        else
        {
            ShowMessageBox("Stock Already Received !!");
        }
    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void damageTextBox_TextChanged(object sender, EventArgs e)
    {
        int setRowIndex = ((GridViewRow)(((TextBox)sender).Parent.Parent)).RowIndex;

        decimal issueQty = 0;
        decimal damageQty = 0;
        decimal MainQty = Convert.ToDecimal(rcvGridView.Rows[setRowIndex].Cells[4].Text.Trim());
        //  MainQty = 



        issueQty = Convert.ToDecimal(rcvGridView.Rows[setRowIndex].Cells[4].Text.Trim());
        damageQty =
            Convert.ToDecimal(
                ((TextBox)rcvGridView.Rows[setRowIndex].Cells[8].FindControl("damageTextBox")).Text.Trim());


        if (damageQty > MainQty)
        {
            ShowMessageBox("Quantity Must be equal or less then Issue Qty.");
            ((TextBox)rcvGridView.Rows[setRowIndex].Cells[8].FindControl("damageTextBox")).Text = "";
            //  (rcvGridView.Rows[setRowIndex].Cells[4]).Text = MainQty.ToString();
            //aDataTableForGrid = aRequisitionBll.GetStockInTransfarByReqId(reqId);

            //rcvGridView.DataSource = aDataTableForGrid;
            //rcvGridView.DataBind();
        }
        else
        {
            damageQty = Convert.ToDecimal(((TextBox)rcvGridView.Rows[setRowIndex].Cells[8].FindControl("damageTextBox")).Text.Trim() != "" ? ((TextBox)rcvGridView.Rows[setRowIndex].Cells[8].FindControl("damageTextBox")).Text.Trim() : "0");
            ((TextBox)rcvGridView.Rows[setRowIndex].Cells[7].FindControl("rcvQtyTextBox")).Text =
                Convert.ToString(issueQty - damageQty);
        }
    }

    protected void rcvQtyTextBox_TextChanged(object sender, EventArgs e)
    {
        int setRowIndex = ((GridViewRow)(((TextBox)sender).Parent.Parent)).RowIndex;

        decimal issueQty = 0;
        decimal rcveQty = 0;
        issueQty = Convert.ToDecimal(rcvGridView.Rows[setRowIndex].Cells[4].Text.Trim());
        rcveQty = Convert.ToDecimal(((TextBox)rcvGridView.Rows[setRowIndex].Cells[7].FindControl("rcvQtyTextBox")).Text.Trim() != "" ? ((TextBox)rcvGridView.Rows[setRowIndex].Cells[7].FindControl("rcvQtyTextBox")).Text.Trim() : "0");
        ((TextBox)rcvGridView.Rows[setRowIndex].Cells[8].FindControl("damageTextBox")).Text =
            Convert.ToString(issueQty - rcveQty);
    }

    protected void backLinkButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("StockRcvByWH.aspx");
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        Save();
    }

    private bool Validation()
    {
        if (rcvGridView.Rows.Count > 0)
        {
            for (int i = 0; i < rcvGridView.Rows.Count; i++)
            {
                if (((TextBox)rcvGridView.Rows[i].FindControl("damageTextBox")).Text == "")
                {
                    ShowMessageBox("Please fill out UnRcvQty !!");
                    return false;
                }
            }
        }
        return true;
    }


    private void Save()
    {
        WhStockConditionFreezeBll _aConditionFreezeBll = new WhStockConditionFreezeBll();
        if (Validation())
        {
            bool DCStoreId = false;
            int freezeID = 0;

            for (int i = 0; i < rcvGridView.Rows.Count; i++)
            {
                TextBox rcvQtyTextBox = (TextBox)rcvGridView.Rows[i].Cells[8].FindControl("rcvQtyTextBox");
                TextBox damageTextBox = (TextBox)rcvGridView.Rows[i].Cells[9].FindControl("damageTextBox");
                int stockConditionId = Convert.ToInt32(rcvGridView.DataKeys[i][5].ToString());
                int dcstorreId = Convert.ToInt32(rcvGridView.DataKeys[i][3].ToString());
                int freezeaId = Convert.ToInt32(rcvGridView.DataKeys[i][2].ToString());
                if (Convert.ToDecimal(rcvQtyTextBox.Text.Trim()) > 0 && dcstorreId > 0 && (freezeaId == 0 || string.IsNullOrEmpty(freezeaId.ToString())))
                {

                    CentralStoreDao aDcStockNew = new CentralStoreDao();
                    {
                        aDcStockNew.ProductId = Convert.ToInt32(rcvGridView.DataKeys[i][4].ToString());
                        aDcStockNew.ProductCode = rcvGridView.Rows[i].Cells[0].Text;
                        aDcStockNew.ProductName = rcvGridView.Rows[i].Cells[1].Text;
                        aDcStockNew.PackSize = rcvGridView.Rows[i].Cells[2].Text;
                        aDcStockNew.BatchNo = rcvGridView.Rows[i].Cells[3].Text;
                        aDcStockNew.Quantity = Convert.ToDecimal(rcvQtyTextBox.Text.Trim());
                        aDcStockNew.StockInQty = Convert.ToDecimal(rcvQtyTextBox.Text.Trim());
                        aDcStockNew.ExpDate = Convert.ToDateTime(rcvGridView.Rows[i].Cells[6].Text);
                        aDcStockNew.MfgDate = Convert.ToDateTime(rcvGridView.Rows[i].Cells[5].Text);
                        aDcStockNew.ReceiveDate = Convert.ToDateTime(DateTime.Now.ToString("dd-MMM-yyyy"));
                        aDcStockNew.ChalanNo = clnNoTextBox.Text.Trim();
                        aDcStockNew.ChalanDate = Convert.ToDateTime(clnDateTextBox.Text.Trim());
                        aDcStockNew.UnitPrice = Convert.ToDecimal(rcvGridView.Rows[i].Cells[10].Text);
                        aDcStockNew.VATPerUnit = Convert.ToDecimal(rcvGridView.Rows[i].Cells[11].Text);
                        aDcStockNew.TotalPrice = Convert.ToDecimal(rcvGridView.Rows[i].Cells[4].Text)*
                                                 Convert.ToDecimal(rcvGridView.Rows[i].Cells[10].Text);
                        aDcStockNew.TotalVAT = Convert.ToDecimal(rcvGridView.Rows[i].Cells[4].Text)*
                                               Convert.ToDecimal(rcvGridView.Rows[i].Cells[11].Text);
                        aDcStockNew.TotalAmount = (Convert.ToDecimal(rcvGridView.Rows[i].Cells[4].Text)*
                                                   Convert.ToDecimal(rcvGridView.Rows[i].Cells[10].Text)) +
                                                  (Convert.ToDecimal(rcvGridView.Rows[i].Cells[4].Text)*
                                                   Convert.ToDecimal(rcvGridView.Rows[i].Cells[11].Text));
                        aDcStockNew.MigoDetailID = Convert.ToInt32(rcvGridView.DataKeys[i][1].ToString());
                        aDcStockNew.DCStoreId = Convert.ToInt32(rcvGridView.DataKeys[i][3].ToString());
                        aDcStockNew.DCStoreFreezeId = Convert.ToInt32(rcvGridView.DataKeys[i][2].ToString());
                        aDcStockNew.StockCondition = "Available";
                        aDcStockNew.ProductStockType = "Regular";
                    }
                    ;

                    DCStoreId = aDal.CentralStorStockIn(aDcStockNew);
                }
                else
                {
                   
                    if (Convert.ToDecimal(rcvQtyTextBox.Text.Trim()) > 0)
                    {

                        var aConditionFreezeDao = new WhStockConditionFreezeDao()
                        {
                            ReceiveId = Convert.ToInt32(rcvGridView.DataKeys[i][1].ToString()),
                            FreezeQty = Convert.ToDecimal(rcvQtyTextBox.Text.Trim()),
                            EntryBy = Session["LoginName"].ToString(),
                            EntryDate = DateTime.Now
                        };

                        int stockConditionFreezeId = 0;
                        stockConditionFreezeId = _aConditionFreezeBll.SaveforWh(aConditionFreezeDao);

                        int rcvId = 0;
                        DataTable dtmaindata = aCtoWhTransferDal.DCStoreWIthTransfer(dcstorreId.ToString());
                        if (!string.IsNullOrEmpty(dtmaindata.Rows[0]["ReceiveId"].ToString()))
                        {
                            rcvId = Convert.ToInt32(dtmaindata.Rows[0]["ReceiveId"].ToString());
                        }
                        else
                        {
                            DataTable dtrcvdata = aCtoWhTransferDal.GetRcvId(dtmaindata);
                            rcvId = Convert.ToInt32(dtrcvdata.Rows[0]["ReceiveId"].ToString());
                        }

                        WhStoreFreezeDao aDCStoreFreezeDAO = new WhStoreFreezeDao();

                        aDCStoreFreezeDAO.ProductId = Convert.ToInt32(rcvGridView.DataKeys[i][4].ToString());
                        aDCStoreFreezeDAO.ProductName = rcvGridView.Rows[i].Cells[1].Text;
                        aDCStoreFreezeDAO.PackSize = rcvGridView.Rows[i].Cells[2].Text;
                        aDCStoreFreezeDAO.BatchNo = rcvGridView.Rows[i].Cells[3].Text;
                        aDCStoreFreezeDAO.TotalQuantity = Convert.ToDecimal(rcvQtyTextBox.Text.Trim());
                        aDCStoreFreezeDAO.StockQty = Convert.ToDecimal(rcvQtyTextBox.Text.Trim());
                        aDCStoreFreezeDAO.DamageQty = 0;
                        aDCStoreFreezeDAO.ExpDate = Convert.ToDateTime(rcvGridView.Rows[i].Cells[5].Text);
                        aDCStoreFreezeDAO.ReceiveDate = Convert.ToDateTime(rcvGridView.Rows[i].Cells[6].Text);
                        aDCStoreFreezeDAO.StockRcvDate = Convert.ToDateTime(rcvDateTextBox.Text.Trim());
                        //aDCStoreFreezeDAO.ReceiveId = Convert.ToInt32(rcvGridView.DataKeys[i][1].ToString());
                        aDCStoreFreezeDAO.ReceiveId = rcvId;
                        aDCStoreFreezeDAO.WhStockConditionFreezeID = stockConditionFreezeId;
                        aDCStoreFreezeDAO.StockCondition = "Restricted";
                        freezeID = _aConditionFreezeBll.SaveWhStoreFreeze(aDCStoreFreezeDAO);
                    }
                }



                if (Convert.ToDecimal(damageTextBox.Text.Trim()) > 0)
                {

                    var aConditionFreezeDao = new WhStockConditionFreezeDao()
                    {
                        ReceiveId = Convert.ToInt32(rcvGridView.DataKeys[i][1].ToString()),
                        FreezeQty = Convert.ToDecimal(damageTextBox.Text.Trim()),
                        EntryBy = Session["LoginName"].ToString(),
                        EntryDate = DateTime.Now
                    };

                    int stockConditionFreezeId = 0;
                    stockConditionFreezeId = _aConditionFreezeBll.SaveforWh(aConditionFreezeDao);


                    int rcvId = 0;
                    DataTable dtmaindata = aCtoWhTransferDal.DCStoreWIthTransfer(dcstorreId.ToString());
                    if (!string.IsNullOrEmpty(dtmaindata.Rows[0]["ReceiveId"].ToString()))
                    {
                        rcvId = Convert.ToInt32(dtmaindata.Rows[0]["ReceiveId"].ToString());
                    }
                    else
                    {
                        DataTable dtrcvdata = aCtoWhTransferDal.GetRcvId(dtmaindata);
                        rcvId = Convert.ToInt32(dtrcvdata.Rows[0]["ReceiveId"].ToString());
                    }
                    WhStoreFreezeDao aDCStoreFreezeDAO = new WhStoreFreezeDao();

                    aDCStoreFreezeDAO.ProductId = Convert.ToInt32(rcvGridView.DataKeys[i][4].ToString());
                    aDCStoreFreezeDAO.ProductName = rcvGridView.Rows[i].Cells[1].Text;
                    aDCStoreFreezeDAO.PackSize = rcvGridView.Rows[i].Cells[2].Text;
                    aDCStoreFreezeDAO.BatchNo = rcvGridView.Rows[i].Cells[3].Text;
                    aDCStoreFreezeDAO.TotalQuantity = Convert.ToDecimal(damageTextBox.Text.Trim());
                    aDCStoreFreezeDAO.StockQty = Convert.ToDecimal(damageTextBox.Text.Trim());
                    aDCStoreFreezeDAO.DamageQty = 0;
                    aDCStoreFreezeDAO.ExpDate = Convert.ToDateTime(rcvGridView.Rows[i].Cells[5].Text);
                    aDCStoreFreezeDAO.ReceiveDate = Convert.ToDateTime(rcvGridView.Rows[i].Cells[6].Text);
                    aDCStoreFreezeDAO.StockRcvDate = Convert.ToDateTime(rcvDateTextBox.Text.Trim());
                    aDCStoreFreezeDAO.ReceiveId = rcvId;
                    //aDCStoreFreezeDAO.ReceiveId = Convert.ToInt32(rcvGridView.DataKeys[i][1].ToString());
                    aDCStoreFreezeDAO.WhStockConditionFreezeID = stockConditionFreezeId;
                    aDCStoreFreezeDAO.StockCondition = "Restricted";
                    freezeID = _aConditionFreezeBll.SaveWhStoreFreeze(aDCStoreFreezeDAO);
                }
            }

            if (DCStoreId || freezeID > 0)
            {
                aDal.updateChallanStatus(Convert.ToInt32(rcvGridView.DataKeys[0][0].ToString()));
            }

            //DC Freez
            ShowMessageBox("Data Save Successfully!!");
            //Popup(hdReqId.Value);
            Clear();
        }
    }

    private void Clear()
    {

        hdReqId.Value = "";
        clnNoTextBox.Text = "";
        clnDateTextBox.Text = "";
        rcvDateTextBox.Text = "";
        driverNameTextBox.Text = "";
        truckTextBox.Text = "";
        hdComUnitId.Value = "";
        rcvGridView.DataSource = null;
        rcvGridView.DataBind();
    }
}