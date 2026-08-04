using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_MiaTargetEdit : System.Web.UI.Page
{
    MiaTargetBLL MiaTargetBLL = new MiaTargetBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            miaTargetInfoIdHiddenField.Value = Request.QueryString["ID"];
            MiaTargetLoad(miaTargetInfoIdHiddenField.Value);           
        }
    }
    
    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (miaCodeTextBox.Text != "" && periodDropDownList.SelectedValue != "" && miaNameTextBox.Text != "" && miaTargetAmountTextBox.Text != "")
        {
            MiaTarget aMiaTarget = new MiaTarget()
            {
                MiaTargetId = Convert.ToInt32(miaTargetInfoIdHiddenField.Value),
                MiaCode = miaCodeTextBox.Text,
                MiaName = miaNameTextBox.Text,
                MiaTargetAmount = Convert.ToDecimal(miaTargetAmountTextBox.Text),
                Period = periodDropDownList.SelectedItem.Text,
            };

            MiaTargetBLL aMiaTargetBLL = new MiaTargetBLL();

            if (!aMiaTargetBLL.UpdateDataForMiaTarget(aMiaTarget))
            {
                MessageLabel.Text = "Data Not Update!!!";
                MessageLabel.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                MessageLabel.Text = "Data Update Successfully!!! Please Reload";
                MessageLabel.ForeColor = System.Drawing.Color.Green;
            }
        }
        else
        {
            MessageLabel.Text = "Please input data in all Textbox";
        }
    }

    private void MiaTargetLoad(string miaId)
    {
        MiaTarget MiaTarget = new MiaTarget();
        MiaTarget = MiaTargetBLL.MiaTargetEditLoad(miaId);
        miaCodeTextBox.Text = MiaTarget.MiaCode;
        miaNameTextBox.Text = MiaTarget.MiaName;
        miaTargetAmountTextBox.Text = MiaTarget.MiaTargetAmount.ToString();
        periodDropDownList.SelectedItem.Text = MiaTarget.Period;
    }


    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);

    }
}