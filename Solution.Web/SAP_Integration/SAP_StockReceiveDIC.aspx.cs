using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.SAP_IntegrationDAL;
using SalesSolution.Web.Models;

public partial class SAP_Integration_SAP_StockReceiveDIC : System.Web.UI.Page
{
    private static SAP_IntrigationPointDAL _DAL = new SAP_IntrigationPointDAL();
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                hdfStockMovementMasterId.Value = "";

                if (Session["StockMovementMasterId"] != null)
                {

                    hdfStockMovementMasterId.Value = Session["StockMovementMasterId"].ToString();
                    LoadSapDataById();
                }
            }
        }
        catch (Exception ex)
        {

        }
    }

    private void LoadSapDataById()
    {
        lblChallanNo.Text = "";
        lblChallanDate.Text = "";
        lblStatus.Text = "";
        lblFrom.Text = "";
        lblTo.Text = "";

        loadGridView.DataSource = null;
        loadGridView.DataBind();

        if (hdfStockMovementMasterId.Value != "")
        {
            try
            {
                DataTable dtTable = _DAL.GetSAPStockDataById(hdfStockMovementMasterId.Value);

                // Master

                lblChallanNo.Text = dtTable.Rows[0].Field<string>("challan_code");
                lblChallanDate.Text = dtTable.Rows[0].Field<DateTime>("challan_date").ToString("dd-MMM-yyyy");
                lblStatus.Text = dtTable.Rows[0].Field<string>("action");
                lblFrom.Text = dtTable.Rows[0].Field<string>("FromWH");
                lblTo.Text = dtTable.Rows[0].Field<string>("to_plant_code");

                // Details

                if (dtTable.Rows.Count > 0)
                {
                    loadGridView.DataSource = dtTable;
                    loadGridView.DataBind();

                    for (int i = 0; i < loadGridView.Rows.Count; i++)
                    {
                        string receiveType = loadGridView.DataKeys[i]["ReceiveType"].ToString();
                        string productCode = loadGridView.DataKeys[i]["ProductCode"].ToString();
                        decimal currentStockQuantity = Convert.ToDecimal(loadGridView.DataKeys[i]["StockQuantity"]);
                        decimal unitPrice = Convert.ToDecimal(loadGridView.DataKeys[i]["UnitPrice"]);
                        decimal rcvQuantity = Convert.ToDecimal(loadGridView.DataKeys[i]["quantity"]);
                        decimal StockQuantityChk = Convert.ToDecimal(loadGridView.DataKeys[i]["StockQuantityChk"]);

                        if (receiveType != "B2B")
                        {
                            loadGridView.Columns[7].Visible = false;
                        }
                        //|| unitPrice == 0
                        if (string.IsNullOrEmpty(productCode)  || rcvQuantity == 0)
                        {
                            loadGridView.Rows[i].BackColor = Color.Red;
                            ApproveButton.Visible = false;
                        }

                        if (receiveType == "B2B")
                        {

                            if (StockQuantityChk == 0)
                            {
                                loadGridView.Rows[i].BackColor = Color.Red;
                                ApproveButton.Visible = false;
                            }

                        }

                    }
                }
            }
            catch
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No data found!" + "','Faild');", true);
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


    protected void ApproveButton_Click(object sender, EventArgs e)
    {
        if (DataValidation()) { 
        if (lblChallanNo.Text.Trim() != "")
        {

            if (loadGridView.Rows.Count == 0)
            {
                ShowMessageBox("There is no product for approval !!");
            }
            else
            {

                 
                for (int i = 0; i < loadGridView.Rows.Count; i++)
                {
                    HiddenField hfStockMovementDetailId = ((HiddenField)loadGridView.Rows[i].Cells[1].FindControl("hfStockMovementDetailId"));
                    TextBox txtquantity = (TextBox)loadGridView.Rows[i].FindControl("txtquantity");

                    int ? StockMovementDetailId = string.IsNullOrEmpty(hfStockMovementDetailId.Value) ? (int?)null : int.Parse(hfStockMovementDetailId.Value);
                    decimal? quantity = string.IsNullOrEmpty(txtquantity.Text) ? (decimal?)null : decimal.Parse(txtquantity.Text);



                    ResultInfo ResSAp = _DAL.UpdateSAPQtyStockReceive(StockMovementDetailId, quantity);


                }


                    ResultInfo Res = _DAL.SaveStockReceive(lblChallanNo.Text.Trim());

                if (Res.isSuccess)
                {
                        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','SAP_IntrigationPointDIC.aspx');", true);

                    }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

                }
            }
            
        }
        else
        {
            ShowMessageBox("There is no challan number for approval !!");
        }

       
        }
    }
    private bool DataValidation()
    {
        

      

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            TextBox txtquantity = (TextBox)loadGridView.Rows[i].FindControl("txtquantity");
            txtquantity.CssClass = "form-control form-control-sm";
            if (txtquantity.Text == "")
            {
                txtquantity.ToolTip = "please fill out this field";
                txtquantity.CssClass = "form-control form-control-sm is-invalid";
                txtquantity.Focus();
                return false;
            }

          

            
            decimal? quantity = string.IsNullOrEmpty(txtquantity.Text) ? (decimal?)null : decimal.Parse(txtquantity.Text);

            if (quantity <= 0)
            {
                txtquantity.ToolTip = "please fill out this field";
                txtquantity.CssClass = "form-control form-control-sm is-invalid";
                txtquantity.Focus();
                return false;
            }
        }
        return true;
    }

    protected void BackToListButton_Click(object sender, EventArgs e)
    {
       Response.Redirect("SAP_IntrigationPoint.aspx");
    }
}