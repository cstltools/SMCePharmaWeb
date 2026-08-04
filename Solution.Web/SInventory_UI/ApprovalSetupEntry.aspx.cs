using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ApprovalSetupEntry : System.Web.UI.Page
{
    AppSetupDAL appSetupDal=new AppSetupDAL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDown();
            InitialGrid();
        }
    }

    public void DropDown()
    {
        appSetupDal.LoadMenuName(menuDropDownList);
    }

    public void InitialGrid()
    {

        DataTable aDataTable = new DataTable();

        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("UserId");
        aDataTable.Columns.Add("Email");
        DataRow dataRow;
        dataRow = aDataTable.NewRow();

        dataRow["SL"] = "";
        dataRow["UserId"] = "";
        dataRow["Email"] = "";
        

        aDataTable.Rows.Add(dataRow);


        loadGridView.DataSource = null;
        loadGridView.DataBind();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            DropDownList userDropDownList = (DropDownList)loadGridView.Rows[i].FindControl("userDropDownList");
            appSetupDal.LoadUser(userDropDownList);
        }
    }
    protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
    {

        //ImageButton productCodeTextBox = (ImageButton)sender;
        //GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        //int rowindex = 0;
        //rowindex = currentRow.RowIndex;

        DataTable aDataTable = new DataTable();

        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("UserId");
        aDataTable.Columns.Add("Email");
        DataRow dataRow;

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {

            TextBox emailTextBox = (TextBox)loadGridView.Rows[i].FindControl("emailTextBox");
            DropDownList userDropDownList = (DropDownList)loadGridView.Rows[i].FindControl("userDropDownList");

            dataRow = aDataTable.NewRow();

            dataRow["SL"] = menuDropDownList.SelectedValue;
            dataRow["UserId"] = userDropDownList.SelectedValue;
            dataRow["Email"] = emailTextBox.Text;


            aDataTable.Rows.Add(dataRow);
        }
        dataRow = aDataTable.NewRow();

        dataRow["SL"] = "";
        dataRow["UserId"] = "";
        dataRow["Email"] = "";


        aDataTable.Rows.Add(dataRow);
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            DropDownList userDropDownList = (DropDownList)loadGridView.Rows[i].FindControl("userDropDownList");
            appSetupDal.LoadUser(userDropDownList);
            userDropDownList.SelectedValue = aDataTable.Rows[i]["UserId"].ToString();
        }

    }
    protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton productCodeTextBox = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        DataTable aDataTable = new DataTable();

        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("UserId");
        aDataTable.Columns.Add("Email");
        DataRow dataRow;

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            if (rowindex != i)
            {


                TextBox emailTextBox = (TextBox) loadGridView.Rows[i].FindControl("emailTextBox");
                DropDownList userDropDownList = (DropDownList) loadGridView.Rows[i].FindControl("userDropDownList");

                dataRow = aDataTable.NewRow();

                dataRow["SL"] = menuDropDownList.SelectedValue;
                dataRow["UserId"] = userDropDownList.SelectedValue;
                dataRow["Email"] = emailTextBox.Text;


                aDataTable.Rows.Add(dataRow);
            }
        }
        
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            DropDownList userDropDownList = (DropDownList)loadGridView.Rows[i].FindControl("userDropDownList");
            appSetupDal.LoadUser(userDropDownList);
            userDropDownList.SelectedValue = aDataTable.Rows[i]["UserId"].ToString();
        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    public void Clear()
    {
        InitialGrid();
        menuDropDownList.SelectedIndex = 0;
    }
    protected void submitButton_Click(object sender, EventArgs e)
    {
        appSetupDal.DeleteAreaInfo(menuDropDownList.SelectedValue);
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            DropDownList userDropDownList = (DropDownList)loadGridView.Rows[i].FindControl("userDropDownList");
            TextBox emailTextBox = (TextBox) loadGridView.Rows[i].FindControl("emailTextBox");
            AppSetupDAO appSetupDao = new AppSetupDAO()
            {
                SL = Convert.ToInt32(menuDropDownList.SelectedValue),
                UserId = Convert.ToInt32(userDropDownList.SelectedValue),
                Email = emailTextBox.Text,
                EntryBy = Session["LoginName"].ToString(),
                EntryDate = DateTime.Now,
            };
            
            appSetupDal.SaveAppSetup(appSetupDao);
            
        }
        Clear();
        showMessageBox("Data Saved Successfully");
    }
    protected void menuDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dtdata = appSetupDal.LoadAppSetup(" WHERE tblAppSetup.SL='" + menuDropDownList.SelectedValue + "'");
        loadGridView.DataSource = dtdata;
        loadGridView.DataBind();
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            DropDownList userDropDownList = (DropDownList)loadGridView.Rows[i].FindControl("userDropDownList");
            appSetupDal.LoadUser(userDropDownList);
            userDropDownList.SelectedValue = dtdata.Rows[i]["UserId"].ToString();
        }
        if (dtdata.Rows.Count<1)
        {
            InitialGrid();
        }
    }
}