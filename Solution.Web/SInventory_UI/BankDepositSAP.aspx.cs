using System;
using System.Activities.Statements;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using CrystalDecisions.Shared;
using Library.BLL.SInventory_BLL;
using Library.DAL.DataManager;
using Library.DAL.MasterSetup_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.Models;

public partial class SInventory_UI_BankDepositSAP : System.Web.UI.Page
{
    TotalSummaryBLL aSummaryBll = new TotalSummaryBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            fromDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            toDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            DropDownlist();
        }
    }


    protected void fromDateTextBox_TextChanged(object sender, EventArgs e)
    {
        DateTime Fromd = Convert.ToDateTime("01-Apr-2022");
        DateTime inputDateTime = Convert.ToDateTime(fromDateTextBox.Text);
        if (inputDateTime < Fromd)
        {
            fromDateTextBox.Text = DateTime.Now.ToString("01 April, 2022");
        }
    }

     
    public void DropDownlist()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        aOrderInfoBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());
        aOrderInfoBll.LoadTerritory(territoryDropDownList, Session["UserId"].ToString());
        aOrderInfoBll.LoadZone(zoneDropDownList, Session["UserId"].ToString());
        // salesCenterDropDownList.SelectedIndex = 1;
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        LoadInfo();
    }
    private static BonusCampaignNewDAL _BonusCampaignNewDAL = new BonusCampaignNewDAL();
    private void LoadInfo()
    {
        if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {
            DataTable aDataTable = new DataTable();
            try
            {
                ResultInfo Res = new ResultInfo();
                  Res = _BonusCampaignNewDAL.BankDeposit_SAP_Process(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()));

                if (Res.isSuccess)
                {
                    aDataTable = aSummaryBll.LoadBankDepositSAP(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()));
                    if (aDataTable.Rows.Count > 0)
                    {
                        loadGridView.DataSource = aDataTable;
                        loadGridView.DataBind();


                    }
                    else
                    {
                        showMessageBox("No Data Found!!");
                        loadGridView.DataSource = null;
                        loadGridView.DataBind();
                    }
                }
               

            }
            catch (Exception)
            {
                
              //  throw;
            }
           
        }
        else
        {
            showMessageBox("Please Select Date Range!!");
        }
    }


    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void excelButton1_Click(object sender, EventArgs e)
    {
         if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {
        string fromDate = fromDateTextBox.Text;
        string toDate = toDateTextBox.Text;

        string url = "../SInventory_RPTVIEW/BusinessSummaryViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate;
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
         else
         {
             showMessageBox("Please Select Date Range!!");
         }

    }
    protected void OnPageIndexChanging(object sender, GridViewPageEventArgs e)
    {
       
    }

    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadInfo();
    }
    protected void rptTypeDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (rptTypeDropDownList.SelectedValue == "BranchWise")
        //{
            
        //}

        //else if ()
        //{
            
        //}

        //else
        //{
            
        //}
    }
    public override void VerifyRenderingInServerForm(Control control)
    {
        // //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
    }
    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        if (loadGridView.Rows.Count > 0)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Bank Deposit (SAP)_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".csv");
            Response.Charset = "";
            Response.ContentType = "text/csv";
            Response.ContentEncoding = Encoding.Default;

            StringBuilder sb = new StringBuilder();

            // Export Header
            foreach (DataControlField column in loadGridView.Columns)
            {
                sb.Append(column.HeaderText + ',');
            }
            sb.Append("\r\n");

            // Export Rows
            foreach (GridViewRow row in loadGridView.Rows)
            {

                string customerCode = "";
                Label lblCustomerCode = (Label)row.FindControl("lblCustomerCode");
                if (lblCustomerCode != null)
                    customerCode = lblCustomerCode.Text;

                string amount = "";
                Label lblAmount = (Label)row.FindControl("lblAmount");
                if (lblAmount != null)
                    amount = lblAmount.Text;

                string depositDate = "";
                Label lblDepositDate = (Label)row.FindControl("lblDepositDate");
                if (lblDepositDate != null)
                    depositDate = lblDepositDate.Text;

                string bankAccountNo = "";
                Label lblBankAccountNo = (Label)row.FindControl("lblBankAccountNo");
                if (lblBankAccountNo != null)
                    bankAccountNo = lblBankAccountNo.Text;

                string reference = "";
                Label lblReference = (Label)row.FindControl("lblReference");
                if (lblReference != null)
                    reference = lblReference.Text;

                string cqNumber = "";
                Label lblCQNumber = (Label)row.FindControl("lblCQNumber");
                if (lblCQNumber != null)
                    cqNumber = lblCQNumber.Text;


                // Handle commas inside values (surround with quotes if needed)
                sb.Append(FormatCSVValue(customerCode) + ",");
                sb.Append(FormatCSVValue(amount) + ",");
                sb.Append(FormatCSVValue(depositDate) + ",");
                sb.Append(FormatCSVValue(bankAccountNo) + ",");
                sb.Append(FormatCSVValue(reference) + ",");
                sb.Append(FormatCSVValue(cqNumber) + ",");
                sb.Append("\r\n");
            }

            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
    }

    protected void btnFinalSubmit_Click(object sender, EventArgs e)
    {


        if (loadGridView.Rows.Count > 0)
        {
            try
            {
                // Date Setup


                // SQL Call


                DataTable dt = aSummaryBll.LoadBankDepositSAP(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()));


                // Map DataTable to List<BankDepositModel>
                List<BankDepositModel> aList = new List<BankDepositModel>();
                foreach (DataRow row in dt.Rows)
                {
                    BankDepositModel aInfo = new BankDepositModel
                    {
                        CustomerCode = row["CustomerCode"] != DBNull.Value ? row["CustomerCode"].ToString() : "",
                        Amount = row["Amount"] != DBNull.Value ? row["Amount"].ToString() : "",
                        ValueDate = row["DepositDate"] != DBNull.Value ? row["DepositDate"].ToString() : "",
                        BankAccountNo = row["BankAccountNo"] != DBNull.Value ? row["BankAccountNo"].ToString() : "",
                        Reference = row["Reference"] != DBNull.Value ? row["Reference"].ToString() : "",
                        CQNumber = row["CQNumber"] != DBNull.Value ? row["CQNumber"].ToString() : ""
                    };
                    aList.Add(aInfo);
                }

                BankDepositDAO myOrders = new BankDepositDAO
                {
                    Posting = aList
                };

                string jsonData = JsonConvert.SerializeObject(myOrders);

                string apiUrl = "https://smcsap.smc-bd.org:42223/RESTAdapter/eph_mio";
                string username = "smc_epharma"; string password = "Eph@rma2023#";

                // Synchronous HTTP call
                // using (HttpClient httpClient = new HttpClient())
                //{
                //    string credentials = Convert.ToBase64String(Encoding.ASCII.GetBytes(username + ":" + password));
                //    httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", credentials);

                //    HttpContent content = new StringContent(jsonData, Encoding.UTF8, "application/json");

                //    // Call the API synchronously
                //    HttpResponseMessage response = httpClient.PostAsync(apiUrl, content).GetAwaiter().GetResult();

                //    string responseContent = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();


                //    string hiddenFieldValues = "";

                //foreach (GridViewRow row in loadGridView.Rows)
                //{
                //    HiddenField hfSL = (HiddenField)row.FindControl("hfSL");
                //    if (hfSL != null)
                //    {
                //        string SL = hfSL.Value;

                //        // Only add a comma if it's not the first value
                //        if (!string.IsNullOrEmpty(hiddenFieldValues))
                //        {
                //            hiddenFieldValues += ",";
                //        }

                //        hiddenFieldValues += SL;
                //    }
                //}

                //// Now, 'hiddenFieldValues' will contain all the hidden field values without a trailing comma
                //// Example: "1,2,3,4,5"

                //try
                //{
                //    ResultInfo Res = new ResultInfo();
                //    Res = _BonusCampaignNewDAL.BankDeposit_SAP_ProcessUpdate(hiddenFieldValues);

                //    if (Res.isSuccess)
                //    {
                //        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','BankDepositSAP.aspx');", true);

                //    }
                //    else
                //    {
                //        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

                //    }

                //}
                //catch
                //{

                //}

 
                //}
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Error: " + ex.Message.Replace("'", "\\'") + "');", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No data found!" + "','Faild');", true);
        }
    }
     

    //  throw;
 
         
 

// Helper method to handle commas and quotes
private string FormatCSVValue(string value)
    {
        if (value.Contains(",") || value.Contains("\""))
        {
            return "\"" + value.Replace("\"", "\"\"") + "\"";
        }
        return value;
    }


    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("BankDepositSAP.aspx");
    }
}

public class BankDepositModel
{
    public string CustomerCode { get; set; }
    public string Amount { get; set; }
    public string ValueDate { get; set; }
    public string BankAccountNo { get; set; }
    public string Reference { get; set; }
    public string CQNumber { get; set; }
}
public class BankDepositDAO
{
    public List<BankDepositModel> Posting { get; set; }
}
