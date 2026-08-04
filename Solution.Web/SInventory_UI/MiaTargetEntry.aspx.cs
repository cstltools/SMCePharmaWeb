using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_MiaTargetEntry : System.Web.UI.Page
{
    MiaTargetBLL aMiaTargetBLL = new MiaTargetBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
        }
    }
    
    private void Clear()
    {
        miaCodeTextBox.Text = string.Empty;
        periodDropDownList.SelectedValue = null;
        miaNameTextBox.Text = string.Empty;
        miaTargetAmountTextBox.Text = string.Empty;

    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private bool Validation()
    {
        if (miaCodeTextBox.Text == "")
        {
            showMessageBox("Please Input Representitive Code!!");
            return false;
        }

        if (miaTargetAmountTextBox.Text == "")
        {
            showMessageBox("Please Input Target Amount!!");
            return false;
        }

        return true;
    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (Validation() == true)
        {
            MiaTarget aMiaTarget = new MiaTarget()
            {
                MiaCode = miaCodeTextBox.Text,
                MiaName = miaNameTextBox.Text,
                MiaTargetAmount = Convert.ToDecimal(miaTargetAmountTextBox.Text),
                Period = periodDropDownList.SelectedItem.Text,
                Year = DateTime.Now.Year.ToString()
            };

            MiaTargetBLL aMiaTargetBLL = new MiaTargetBLL();
            if (aMiaTargetBLL.SaveMiaTarget(aMiaTarget))
            {
                showMessageBox("Data Save Successfully");
            }
            Clear();
        }
        else
        {
            showMessageBox("Please input data in all Textbox");
        }
    }

   
    protected void miaViewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("MiaTargetView.aspx");
    }
    protected void miaCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        string MiaCode = miaCodeTextBox.Text.Trim();
        DataTable aDataTable = new DataTable();
        if (!string.IsNullOrEmpty(MiaCode))
        {
            aDataTable = aMiaTargetBLL.LoadMIAInfo(MiaCode);
            if (aDataTable.Rows.Count > 0)
            {
                miaNameTextBox.Text = aDataTable.Rows[0]["MiaName"].ToString();
            }
            else
            {
                Clear();
                showMessageBox("MIA Information Not Found!!");
            }
        }
    }
}