using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.SInventory_DAL;

public partial class Money_Receipt_UI_BatchWiseCollectionReport : System.Web.UI.Page
{

    BatchWiseCollectionReportDal aReportDal = new BatchWiseCollectionReportDal();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownList();
        }
    }

    private void DropDownList()
    {
         aReportDal.LoadDeliveryMan(delDropDownList);
    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void delDropDownList_OnTextChanged(object sender, EventArgs e)
    {
        FindBatchInfo();
    }

    private void FindBatchInfo()
    {
        //if (manufacDropDownList.SelectedValue != "")
        //{
        if (delDropDownList.SelectedValue != "")
        {
            if (dateTextBox.Text != "")
            {
                OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();

                batchDropDownList.Items.Clear();

                if (Session["UserType"].ToString() != "")
                {
                    if (Session["UserType"].ToString() != "Admin")
                    {
                       // aOrderInfoBll.BatchNoLoadByUser(batchDropDownList, dateTextBox.Text, delDropDownList.SelectedValue, Session["UserId"].ToString());
                    }
                    else
                    {
                       // aOrderInfoBll.BatchNoLoad(batchDropDownList, dateTextBox.Text, delDropDownList.SelectedValue);
                        //aOrderInfoBll.BatchNoLoad(batchDropDownList, manufacDropDownList.SelectedValue, dateTextBox.Text, delDropDownList.SelectedValue);
                    }
                }                
            }
            else
            {
                dateTextBox.Text = "";
                ShowMessageBox("Batch Creation Date Is Required !!!!");
            }
        }
        else
        {
            ShowMessageBox("Please Select Delivery Man !!!!");
        }
        //}
        //else
        //{
        //    ShowMessageBox("Please Select company !!!!");
        //}
    }

    protected void submitButton_OnClick(object sender, EventArgs e)
    {
        if (batchDropDownList.SelectedValue != "")
        {
            PopupReport(null);
        }
        else
        {
            batchDropDownList.Focus();
            ShowMessageBox("BatchNo is required !!!!");
        }
    }

    private void PopupReport(string paydetailId)
    {
        Session["paydetailId"] = "";
        Session["paydetailId"] = paydetailId;

        string url = "../SInventory_RPTVIEW/BatchWiseCollectionReportViewer.aspx";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void dateTextBox_TextChanged(object sender, EventArgs e)
    {
        FindBatchInfo();
    }

    protected void clearButton_OnClick(object sender, EventArgs e)
    {
        delDropDownList.SelectedValue = "";
        dateTextBox.Text = "";
        batchDropDownList.Items.Clear();

        nameTextBox.Text = "";
        customerCheckBox.Checked = false;
        singleCustomerTextBox.Text = "";
        hdCustomerId.Value = "";
        singleCustomerTextBox.Enabled = false;
    }


    protected void singleCustomerTextBox_OnTextChanged(object sender, EventArgs e)
    {
        if (singleCustomerTextBox.Text.Contains(':'))
        {
            string[] data = singleCustomerTextBox.Text.Split(':');
            singleCustomerTextBox.Text = data[0];
            nameTextBox.Text = data[1];
            hdCustomerId.Value = data[3];
        }
        else
        {

            if (singleCustomerTextBox.Text != "")
            {
                hdCustomerId.Value = "";
                DataTable aTable = aReportDal.GetCustomerInfoByCode(singleCustomerTextBox.Text.Trim());

                if (aTable.Rows.Count > 0)
                {
                    hdCustomerId.Value =
                        aTable.Rows[0].Field<int>("CustomerMasterId").ToString(CultureInfo.InvariantCulture);

                    nameTextBox.Text = aTable.Rows[0].Field<String>("CustomerName");
                }
                else
                {
                    hdCustomerId.Value = "";
                    singleCustomerTextBox.Text = "";
                    nameTextBox.Text = "";
                    ShowMessageBox("Invalid Customer Info !!");
                }
            }


        }
    }

    protected void customerCheckBox_OnCheckedChanged(object sender, EventArgs e)
    {
        singleCustomerTextBox.Text = "";

        if (customerCheckBox.Checked)
        {
            singleCustomerTextBox.Enabled = true;
        }

        else
        {
            singleCustomerTextBox.Enabled = false;
            hdCustomerId.Value = "";
            nameTextBox.Text = "";
            loadGridView.DataSource = null;
            loadGridView.DataBind();
        }
    }

    protected void searchButton_Click(object sender, EventArgs e)
    {
        DataTable aTable = new DataTable();

        if (batchDropDownList.SelectedValue != "" && !customerCheckBox.Checked)
        {
            aTable = aReportDal.BatchWiseCollection(Convert.ToInt32(batchDropDownList.SelectedValue));
        }

        if (batchDropDownList.SelectedValue == "" && customerCheckBox.Checked)
        {
            aTable = aReportDal.BatchWiseCollectionSingle(singleCustomerTextBox.Text);
        }


        if (aTable.Rows.Count > 0)
        {
            loadGridView.DataSource = aTable;
            loadGridView.DataBind();
        }
        else
        {
            loadGridView.DataSource = null;
            loadGridView.DataBind();
            ShowMessageBox("No Data Found !");
        }

        CalculateTotalReceiveable();
    }

    private void CalculateTotalReceiveable()
    {
        decimal value = 0;

        if (loadGridView.Rows.Count > 0)
        {
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {
                value = value + Convert.ToDecimal(loadGridView.Rows[i].Cells[6].Text.Trim());
            }
        }

        totalReceiveableLabel.Text = "TK. " + value.ToString(CultureInfo.InvariantCulture);
    }

    protected void invoiceButton_Click(object sender, EventArgs e)
    {
        var button = (LinkButton)sender;
        var currentRow = (GridViewRow)button.Parent.Parent;

        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        var dataKey = loadGridView.DataKeys[rowindex];
        if (dataKey != null)
            PopupReport(dataKey["CustPayDetailId"].ToString());

        
    }

   
}