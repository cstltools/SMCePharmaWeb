using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_OrderList : System.Web.UI.Page
{
    private DataTable aDataTable = new DataTable();
    ExcelUpForOrderListBLL aExcelUpForMIGOBLL = new ExcelUpForOrderListBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //Load();
            LoadDropDown();
        }
    }

    public void LoadDropDown()
    {
        aExcelUpForMIGOBLL.LoadmanufacturerName(manufacturerDropDownList);
    }

    private void Load()
    {
        aDataTable = aExcelUpForMIGOBLL.LoadOrder();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    //private void PopUp(string Id)
    //{
    //    string url = "ViewOrderDetailList.aspx?ID=" + Id;
    //    string fullURL = "window.open('" + url +
    //                     "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
    //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    //}

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            DataTable dt = new DataTable();
            dt = aExcelUpForMIGOBLL.LoadMigobyID(Convert.ToInt32(loadGridView.DataKeys[rowindex][0].ToString()));
            bool stockTansfer = Convert.ToBoolean(dt.Rows[0].Field<bool>("GenerateOrder").ToString());
            if (stockTansfer == false)
            {
                aExcelUpForMIGOBLL.DeleteData(Convert.ToInt32(loadGridView.DataKeys[rowindex][0].ToString()));
                aExcelUpForMIGOBLL.DeleteDetailData(Convert.ToInt32(loadGridView.DataKeys[rowindex][0].ToString()));
                Load();
            }
            else
            {
                ShowMessageBox("Cant Delete !!! ");
            }

        }
        if (e.CommandName == "OrderGenerate")
        {
            //System.Threading.Thread.Sleep(1000);

        }
        if (e.CommandName == "ViewData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            Session["OrderID"] = loadGridView.DataKeys[rowindex][0].ToString();
            Response.Redirect("../SInventory_UI/ViewOrderDetailList.aspx");
        }
    }

    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void refreshButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("../SInventory_UI/OrderList.aspx");
    }

    public string Parameter()
    {
        string paramter = "";
        if (manufacturerDropDownList.SelectedValue != "" && fromDateTextBox.Text == "" && toTextBox.Text == "")
        {
            paramter = " tblOrderListMaster.ManufacId='" + manufacturerDropDownList.SelectedValue + "";
        }
        if (fromDateTextBox.Text != "" && toTextBox.Text != "" && manufacturerDropDownList.SelectedValue == "")
        {
            paramter = " DocumentDate between '" + fromDateTextBox.Text + "' and '" + toTextBox.Text + "";
        }
        if (fromDateTextBox.Text != "" && toTextBox.Text != "" && manufacturerDropDownList.SelectedValue != "")
        {
            paramter = " tblOrderListMaster.ManufacId = '" + manufacturerDropDownList.SelectedValue + "' and  DocumentDate between '" + fromDateTextBox.Text + "' and '" + toTextBox.Text + "";
        }
        return paramter;
    }
    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (manufacturerDropDownList.SelectedValue != "")
        {
            LoadInitialGrid(loadGridView);
        }
        else
        {
            ShowMessageBox("Please Select Manufacturer !!");
        }
    }
    private void LoadInitialGrid(GridView gridView)
    {
        gridView.DataSource = aExcelUpForMIGOBLL.LoadMigoDate(Parameter());
        gridView.DataBind();
    }
    protected void OrderImageButton_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton imageButtonTra = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)imageButtonTra.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        int Id = Convert.ToInt32(loadGridView.DataKeys[rowindex][0].ToString());
        if (aExcelUpForMIGOBLL.TransfarOrderID_BLL(Id) > 0)
        {
            ShowMessageBox("Transferred successfully!!!");

            Load();
        }

    }
}