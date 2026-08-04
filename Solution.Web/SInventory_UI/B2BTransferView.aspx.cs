using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

public partial class SInventory_UI_B2BTransferView : System.Web.UI.Page
{

    B2BTransferViewDal aTransferViewDal = new B2BTransferViewDal();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadB2BInformation();
        }
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {

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
    protected void custCetegoryAddImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("NewStockTransferDcToDc.aspx");
    }
    private void LoadB2BInformation()
    {

        DataTable aTable = aTransferViewDal.GetB2bTransferInfo(GetPrameterList());

        if (aTable.Rows.Count > 0)
        {
            loadGridView.DataSource = aTable;
            loadGridView.DataBind();
        }
        else
        {
            loadGridView.DataSource = null;
            loadGridView.DataBind();
        }

    }


    private String GetPrameterList()
    {
        string parameter = "";


        if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {
            parameter = parameter + "AND ChalanDate BETWEEN '" + Convert.ToDateTime(fromDateTextBox.Text.Trim()) + "' AND ' " + Convert.ToDateTime(toDateTextBox.Text.Trim()) + "'";
        }


        return parameter;

    }



    protected void custCetegoryAddImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("NewStockTransferDcToDc.aspx");
    }

    protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
    {
        
    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void searchButton_Click(object sender, EventArgs e)
    {
        LoadB2BInformation();
    }

    protected void submitButton_OnClick(object sender, EventArgs e)
    {
        fromDateTextBox.Text = "";
        toDateTextBox.Text = "";

        LoadB2BInformation();
    }

    protected void editImageButton_Click(object sender, EventArgs e)
    {
        int rowIndex = ((GridViewRow)(((LinkButton)sender).Parent.Parent)).RowIndex;
        string status = loadGridView.Rows[rowIndex].Cells[8].Text;

        if (status != "Received")
        {
            var dataKey = loadGridView.DataKeys[rowIndex];

            int datakeyValue;

            if (dataKey != null)
            {
                datakeyValue = Convert.ToInt32(dataKey[0].ToString());
                bool master = aTransferViewDal.DeleteChallanMasterById(datakeyValue);

                if (master)
                {
                    bool detail = aTransferViewDal.DeleteChallanDetailById(datakeyValue);

                    if (detail)
                    {
                        LoadB2BInformation();
                        ShowMessageBox("Information delete successfully !!");
                    }
                }
            }
        }
        else
        {
            ShowMessageBox("Delete operation is not possible !!");
        }
    }

    protected void btPrint_Click(object sender, EventArgs e)
    {
        int rowIndex = ((GridViewRow)(((LinkButton)sender).Parent.Parent)).RowIndex;
        

        var dataKey = loadGridView.DataKeys[rowIndex];

        String datakeyValue;

        if (dataKey != null)
        {
            datakeyValue =  (dataKey[1].ToString());

            Popup(datakeyValue.ToString());
        }


    }

    public void Popup(string reqId)
    {
        string url = "../SInventory_RPTVIEW/TransferStockReceiveReportViewer.aspx?ChalanId=" + reqId+ "&TYpe=" + "Report";
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
}