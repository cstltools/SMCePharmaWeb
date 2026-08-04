using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_CreatePickingOnDC : System.Web.UI.Page
{
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["UserType"].ToString() != "")
            {
                if (Session["UserType"].ToString() == "Admin")
                {
                    aRequisitionBll.DCLoad(dcDropDownList);
                    picDateTextBox.Text = Convert.ToDateTime(DateTime.Today.ToShortDateString()).ToString("dd-MMM-yyyy");
                }
                else
                {
                    string comUnit = Session["ComUnitId"].ToString();
                    aRequisitionBll.DCLoad(dcDropDownList, comUnit);
                    picDateTextBox.Text = Convert.ToDateTime(DateTime.Today.ToShortDateString()).ToString("dd-MMM-yyyy");
                }
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }
    }

    protected void searchButton_Click(object sender, EventArgs e)
    {
        LoadGrid();
    }

    private void LoadGrid()
    {
        DataTable aDataTable = new DataTable();
        if (dcDropDownList.SelectedValue != "" && dateTextBox.Text != "")
        {
            aDataTable = aInvoiceBll.InvoiceForDCPickingBLL(dcDropDownList.SelectedValue, dateTextBox.Text.Trim());
            if (aDataTable.Rows.Count > 0)
            {
                reportListGridView.DataSource = null;
                reportListGridView.DataBind();
                reportListGridView.DataSource = aDataTable;
                reportListGridView.DataBind();
            }
            else
            {
                reportListGridView.DataSource = null;
                reportListGridView.DataBind();
                showMessageBox("No Data Found!!");
            }
        }
        else
        {
            showMessageBox("Select DC & Date !!");
        }
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void createButton_Click(object sender, EventArgs e)
    {
        Save();
    }


    private void Save()
    {
        string[] comUnitCode = dcDropDownList.SelectedItem.Text.Split(':');
        DCPicking aDcPicking = new DCPicking();
        aDcPicking.ComUnitId = Convert.ToInt32(dcDropDownList.SelectedValue);
        aDcPicking.DCPicDate = Convert.ToDateTime(picDateTextBox.Text.Trim());
        aDcPicking.AreaId = Convert.ToInt32(areaDropDownList.SelectedValue);
        aDcPicking.ComUnitCode = comUnitCode[0];
       int DCPicId = 0;
       DCPicId = aInvoiceBll.DcPickingSaveBLL(aDcPicking);
        List<DCPickingDetail> aDcPickingDetailsList = new List<DCPickingDetail>();
       for (int i = 0; i < reportListGridView.Rows.Count; i++)
        {
             CheckBox aCheckBox = (CheckBox) reportListGridView.Rows[i].Cells[0].FindControl("printCheckBox");
             if (aCheckBox.Checked == true)
             {
                 DCPickingDetail aDcPickingDetail = new DCPickingDetail();

                 aDcPickingDetail.InvoiceNo = reportListGridView.Rows[i].Cells[1].Text.Trim();
                 aDcPickingDetail.DCPicId = DCPicId;
                 aDcPickingDetailsList.Add(aDcPickingDetail);
             }
        }
       string msg = aInvoiceBll.DcPickingDetailSaveBLL(aDcPickingDetailsList);

        LoadGrid();
        showMessageBox(msg);
    }
    protected void dcDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        aInvoiceBll.AreaDropDownLoad(areaDropDownList,dcDropDownList.SelectedValue);
    }
}