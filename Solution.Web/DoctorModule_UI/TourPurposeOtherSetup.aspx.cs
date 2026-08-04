using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DoctorModule_DAL;
using Library.DAO.SInventory_Entities;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class DoctorModule_UI_TourPurposeOtherSetup : System.Web.UI.Page
{
    //private static SetupDAL _setupDAL
    //;
    static SetupDAL _setupDAL=new SetupDAL();
        string DtlId = "";
    static CommonDataLoad _dataLoad = new CommonDataLoad();
    static Setup2DAL _setupDAL2 = new Setup2DAL();


    private DataTable VisitDataTable
    {
        get
        {
            if (Session["VisitDataTable"] == null)
            {
                // Initialize the DataTable with the necessary columns
                DataTable dt = new DataTable();
                dt.Columns.Add("RoleId");
                dt.Columns.Add("TerritoryId");
                dt.Columns.Add("AreaId");
                dt.Columns.Add("RegionId");
                dt.Columns.Add("StationTypeId");
                dt.Columns.Add("Role");
                dt.Columns.Add("Territory");
                dt.Columns.Add("Area");
                dt.Columns.Add("Region");
                dt.Columns.Add("Group");
                dt.Columns.Add("GroupId");
                dt.Columns.Add("StationType");
                Session["VisitDataTable"] = dt;
            }
            return (DataTable)Session["VisitDataTable"];
        }
        set
        {
            Session["VisitDataTable"] = value;
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session["VisitDataTable"] = null;
            BindGridView();
            rolePanel.Visible = true;
            territoryGroup.Visible = false;
            areaGroup.Visible = false;
            regionGroup.Visible = false;
        
            // Populate dropdown lists
            PopulateDropDownLists();

            try
            {
                using (DataTable dt = _dataLoad.GetRoleTypeInfoDALFFS())
                {
                    ddlRoleType.DataSource = dt;
                    ddlRoleType.DataValueField = "RoleTypeId";
                    ddlRoleType.DataTextField = "RoleType";
                    ddlRoleType.DataBind();
                    try
                    {
                        ddlRoleType.Items.Insert(-1, "");
                        ddlRoleType.SelectedIndex = 0;
                    }
                    catch (Exception ex) { }
                }


            }
            catch (Exception ex) { }

            try
            {
                using (DataTable dt = _dataLoad.GetEmployeeList_ActiveFS())
                {
                    EmployeeIdSelect.DataSource = dt;
                    EmployeeIdSelect.DataValueField = "EmpInfoId";
                    EmployeeIdSelect.DataTextField = "EmpName";
                    EmployeeIdSelect.DataBind();
                    try
                    {
                        EmployeeIdSelect.Items.Insert(-1, "");
                        EmployeeIdSelect.SelectedIndex = 0;
                    }
                    catch (Exception ex) { }
                }


            }
            catch (Exception ex) { }
            DataTable aDataTable = new DataTable();
            aDataTable.Columns.Add("ExpenseTypDetailsId");
            aDataTable.Columns.Add("FieldName");
            aDataTable.Columns.Add("IsRequied");
            gv_DA.DataSource = aDataTable;
            gv_DA.DataBind();

            if (!string.IsNullOrEmpty(Request.QueryString["id"]))
            {
                btnUpdate.Visible = true;

                id_mastetID.Value = Request.QueryString["id"];
               GetOneRecord(id_mastetID.Value);
            }
            else
            {
                btnSave.Visible = true;
            }
        }

    }

    private void BindGridView()
    {
        gvList.DataSource = VisitDataTable;
        gvList.DataBind();
    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        DataTable dt = VisitDataTable;

        // Prepare the values to be added
        string roleId = roleSelect.SelectedValue == "0" || string.IsNullOrEmpty(roleSelect.SelectedValue) ? "0" : roleSelect.SelectedValue;
        string roleName = roleId == "0" ? "" : roleSelect.SelectedItem.Text;

        string territoryId = territorySelect.SelectedValue == "0" || string.IsNullOrEmpty(territorySelect.SelectedValue) ? "0" : territorySelect.SelectedValue;
        string territoryName = territoryId == "0" ? "" : territorySelect.SelectedItem.Text;

        string areaId = areaSelect.SelectedValue == "0" || string.IsNullOrEmpty(areaSelect.SelectedValue) ? "0" : areaSelect.SelectedValue;
        string areaName = areaId == "0" ? "" : areaSelect.SelectedItem.Text;

        string regionId = regionSelect.SelectedValue == "0" || string.IsNullOrEmpty(regionSelect.SelectedValue) ? "0" : regionSelect.SelectedValue;
        string regionName = regionId == "0" ? "" : regionSelect.SelectedItem.Text;

  

        string GroupId = GroupSelect.SelectedValue == "0" || string.IsNullOrEmpty(GroupSelect.SelectedValue) ? "0" : GroupSelect.SelectedValue;
        string GroupName = regionId == "0" ? "" : GroupSelect.SelectedItem.Text;

        string stationTypeId = StationSelect.SelectedValue == "0" || string.IsNullOrEmpty(StationSelect.SelectedValue) ? "0" : StationSelect.SelectedValue;
        string stationTypeName = stationTypeId == "0" ? "" : StationSelect.SelectedItem.Text;

        if (roleSelect.SelectedValue == "0" || string.IsNullOrEmpty(roleSelect.SelectedValue))
        {
            roleSelect.Focus();
            return;
        }

        if (StationSelect.SelectedValue == "0" || string.IsNullOrEmpty(StationSelect.SelectedValue))
        {
            StationSelect.Focus();
            return;
        }

        // Validation: at least one of the following must be selected - territorySelect, areaSelect, or regionSelect
        if ((territorySelect.SelectedValue == "0" || string.IsNullOrEmpty(territorySelect.SelectedValue)) &&
            (areaSelect.SelectedValue == "0" || string.IsNullOrEmpty(areaSelect.SelectedValue)) &&
            (regionSelect.SelectedValue == "0" || string.IsNullOrEmpty(regionSelect.SelectedValue))
             &&
            (GroupSelect.SelectedValue == "0" || string.IsNullOrEmpty(GroupSelect.SelectedValue))
            )
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please select at least one of Territory, Area,  Region or Group" + "','Faild');", true);

         //   showMessageBoxN("Please select at least one of Territory, Area, or Region.");
            return;
        }

        // Check if the same row already exists in the DataTable
        foreach (DataRow row in dt.Rows)
        {
            if (row["RoleId"].ToString() == roleId &&
                row["TerritoryId"].ToString() == territoryId &&
                row["AreaId"].ToString() == areaId &&
                row["RegionId"].ToString() == regionId &&
                row["GroupId"].ToString() == GroupId &&
                row["StationTypeId"].ToString() == stationTypeId)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist in Table!" + "','Faild');", true);
                // Show a message if the row already exists
                //ClientScript.RegisterStartupScript(this.GetType(), "alert", "This entry already exists in the grid.", true);
                return;  // Exit the method and do not add the duplicate row
            }
        }

        // Create a new row with the selected values
        DataRow dr = dt.NewRow();
        dr["RoleId"] = roleId;
        dr["Role"] = roleName;
        dr["TerritoryId"] = territoryId;
        dr["Territory"] = territoryName;
        dr["AreaId"] = areaId;
        dr["Area"] = areaName;
        dr["RegionId"] = regionId;
        dr["Region"] = regionName;
        dr["GroupId"] = GroupId;
        dr["Group"] = GroupName;
        dr["StationTypeId"] = stationTypeId;
        dr["StationType"] = stationTypeName;

        // Add the row to the DataTable
        dt.Rows.Add(dr);

        // Save the DataTable in session and bind it to the GridView
        VisitDataTable = dt;
        BindGridView();

        territorySelect.SelectedIndex = 0;
        areaSelect.SelectedIndex = 0;
        regionSelect.SelectedIndex = 0;
        GroupSelect.SelectedIndex = 0;
    }


    // Event for handling the delete command in the GridView
   
    public void showMessageBoxN(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }


    protected void gvList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteRow")
        {
            // Get the row index from the CommandArgument
            int rowIndex = Convert.ToInt32(e.CommandArgument);

            // Get the current DataTable from the session
            DataTable dt = VisitDataTable;

            // Delete the selected row
            dt.Rows[rowIndex].Delete();

            // Save the updated DataTable back to the session and rebind the GridView
            VisitDataTable = dt;
            BindGridView();
        }
    }

    private void PopulateDropDownLists()
    {

        try
        {
            using (DataTable dt = _setupDAL.Get_TourPurposeInfoNew())
            {
                ddlTourPurpose.DataSource = dt;
                ddlTourPurpose.DataValueField = "TPId";
                ddlTourPurpose.DataTextField = "TPName";
                ddlTourPurpose.DataBind();
                ddlTourPurpose.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                ddlTourPurpose.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

        try
        {
            using (DataTable dt = _setupDAL.Get_TourPlanTypeDDL())
            {
                StationSelect.DataSource = dt;
                StationSelect.DataValueField = "TourTypeId";
                StationSelect.DataTextField = "TourTypeName";
                StationSelect.DataBind();
                StationSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                StationSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
        // Add items to Territory dropdown
        try
        {
            using (DataTable dt = _setupDAL2.GetTerritoryListOrdPerALL())
            {
                territorySelect.DataSource = dt;
                territorySelect.DataValueField = "TerritoryId";
                territorySelect.DataTextField = "TerritoryName";
                territorySelect.DataBind();
                territorySelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                territorySelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

        // Add items to Area dropdown
        try
        {
            using (DataTable dt = _setupDAL2.GetAreaListOrdPerALL())
            {
                areaSelect.DataSource = dt;
                areaSelect.DataValueField = "AreaId";
                areaSelect.DataTextField = "AreaName";
                areaSelect.DataBind();
                areaSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                areaSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

        // Add items to Region dropdown


        try
        {
            using (DataTable dt = _setupDAL2.GetZoneListOrdPer())
            {
                regionSelect.DataSource = dt;
                regionSelect.DataValueField = "RegionId";
                regionSelect.DataTextField = "RegionName";
                regionSelect.DataBind();
                regionSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                regionSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { } 
        try
        {
            using (DataTable dt = _setupDAL2.GetGroupListOrdPer())
            {
                GroupSelect.DataSource = dt;
                GroupSelect.DataValueField = "GroupId";
                GroupSelect.DataTextField = "GroupName";
                GroupSelect.DataBind();
                GroupSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                GroupSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { } 

    }
    protected void VisitType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (visitType.SelectedValue == "market")
        {
            rolePanel.Visible = false;
            territoryGroup.Visible = true;
            areaGroup.Visible = true;
            regionGroup.Visible = true;
            
        }
        else
        {
            rolePanel.Visible = true;
            territoryGroup.Visible = false;
            areaGroup.Visible = false;
            regionGroup.Visible = false;
            
        }
    }
    private void GetOneRecord(string Id)
    {
        try
        {
            using (DataTable dt = _setupDAL.GetEditDataForTPOtherId(Convert.ToInt32(Id)))
            {

                try
                {
                    chkIsActive.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"].ToString());

                }
                catch (Exception ex)
                {
                    chkFixed.Checked = false;
                }

                visitType.Items[1].Selected = true;
                //try
                //{
                //    ddlTourPurpose.SelectedValue =  (dt.Rows[0]["TourPurposeId"].ToString());
                //}
                //catch (Exception ex)
                //{

                //}

                //    TxtName.Text = dt.Rows[0]["ExpenseTypeName"].ToString();
                //    txtAmount.Text = dt.Rows[0]["ExpenseAmount"].ToString();
                //    hfForMe.Value = dt.Rows[0]["ExpenseTypDetailsIdStr"].ToString();

                //    try
                //    {
                //      if(Convert.ToBoolean(dt.Rows[0]["ImageRequired"].ToString()) == true)
                //        {
                //            rbImgType.Items[0].Selected = true;
                //        }
                //        else
                //        {
                //            rbImgType.Items[1].Selected = true;

                //        }
                //    }
                //    catch(Exception ex)
                //    {

                //    }

                //    try
                //    {
                //        customSwitch1.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"].ToString());
                //    }
                //    catch (Exception ex)
                //    {
                //        customSwitch1.Checked = false;
                //    }




                //    string[] RoleTypeMultArr = dt.Rows[0]["RoleTypeMult"].ToString().Split(',');

                //    foreach (ListItem item in ddlRoleType.Items)
                //    {
                //        for (int i = 0; i < RoleTypeMultArr.Length; i++)
                //        {
                //            if (item.Value == RoleTypeMultArr[i].ToString())
                //            {
                //                item.Selected = true;

                //            }
                //        }
                //    }


                //    string[] EmpNameMultArr = dt.Rows[0]["EmpNameMult"].ToString().Split(',');

                //    foreach (ListItem item in EmployeeIdSelect.Items)
                //    {
                //        for (int i = 0; i < EmpNameMultArr.Length; i++)
                //        {
                //            if (item.Value == EmpNameMultArr[i].ToString())
                //            {
                //                item.Selected = true;

                //            }
                //        }
                //    }


                //}



                Session["VisitDataTable"] = dt;
                gvList.DataSource = dt;
                gvList.DataBind();








            }
        }
        
        catch (Exception ex) { }
    }
    
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    
    


     

    protected void addButtonDA_Click(object sender, EventArgs e)
    {
        IsRequired.CssClass = "form-select form-select-sm mb-3 mySelect2";
        txtFieldName.CssClass = "form-control form-control-sm  mb-3";

        if (txtFieldName.Text != "")
        {
            Add();

        }
        else
        {
            txtFieldName.ToolTip = "please fill out this field";
            txtFieldName.CssClass = "form-control form-control-sm  mb-3";
            txtFieldName.Focus();

        }

    }

    private void InitializeDataTable()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("ExpenseTypDetailsId");
        aDataTable.Columns.Add("FieldName");
        aDataTable.Columns.Add("IsRequied");

        ViewState["CurrentTable"] = aDataTable;
    }

    public void Add()
    {
        DataTable aDataTable = ViewState["CurrentTable"] as DataTable;

        if (aDataTable == null)
        {
            InitializeDataTable();
            aDataTable = ViewState["CurrentTable"] as DataTable;
        }

        // Clear existing rows in DataTable
        aDataTable.Rows.Clear();

        for (int i = 0; i < gv_DA.Rows.Count; i++)
        {
            HiddenField hfExpenseTypDetailsId = (HiddenField)gv_DA.Rows[i].Cells[1].FindControl("hfExpenseTypDetailsId");
            Label lbl_FieldName = (Label)gv_DA.Rows[i].Cells[1].FindControl("lbl_FieldName");
            Label lbl_IsRequied = (Label)gv_DA.Rows[i].Cells[1].FindControl("lbl_IsRequied");

            DataRow dataRow = aDataTable.NewRow();
            dataRow["ExpenseTypDetailsId"] = hfExpenseTypDetailsId.Value;
            dataRow["FieldName"] = lbl_FieldName.Text;
            dataRow["IsRequied"] = lbl_IsRequied.Text;

            aDataTable.Rows.Add(dataRow);
        }

        // Check if the FieldName already exists
        string newFieldName = txtFieldName.Text.Trim();
        bool fieldNameExists = aDataTable.AsEnumerable().Any(row => row.Field<string>("FieldName") == newFieldName);

        if (!fieldNameExists)
        {
            DataRow newDataRow = aDataTable.NewRow();
            newDataRow["ExpenseTypDetailsId"] = "0";
            newDataRow["FieldName"] = newFieldName;
            newDataRow["IsRequied"] = IsRequired.SelectedValue;

            aDataTable.Rows.Add(newDataRow);
        }

        ViewState["CurrentTable"] = aDataTable;
        gv_DA.DataSource = aDataTable;
        gv_DA.DataBind();

        txtFieldName.Text = string.Empty;
        IsRequired.SelectedIndex = 0;
    }
    protected void deleteImageButton_Click(object sender, EventArgs e)
    {
        LinkButton lnkRemove = (LinkButton)sender;
        int rowIndex = Convert.ToInt32(lnkRemove.CommandArgument);

        DataTable aDataTable = ViewState["CurrentTable"] as DataTable;
        aDataTable.Rows[rowIndex].Delete();
        aDataTable.AcceptChanges();

        ViewState["CurrentTable"] = aDataTable;
        gv_DA.DataSource = aDataTable;
        gv_DA.DataBind();
    }


    public void Remove(int row)
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("ExpenseTypDetailsId");
        aDataTable.Columns.Add("FieldName");
        aDataTable.Columns.Add("IsRequied");

        int count = 0;
        DataRow dataRow = null;
        int i = row;
            HiddenField hfExpenseTypDetailsId = ((HiddenField)gv_DA.Rows[i].Cells[1].FindControl("hfExpenseTypDetailsId"));
            DataTable dt = new DataTable();
            if (hfExpenseTypDetailsId.Value == "0")
            {
                
            }
            else
            {
                dt = _setupDAL.checkFroDelete(string.IsNullOrEmpty(hfExpenseTypDetailsId.Value) ? (int?)null : int.Parse(hfExpenseTypDetailsId.Value));
            }
           
            
                if (dt.Rows.Count == 0)
                {
                    if (i != row)
            {

                
                    if (dt.Rows.Count == 0)
                    {
                        Label lbl_FieldName = ((Label)gv_DA.Rows[i].Cells[1].FindControl("lbl_FieldName"));
                        Label lbl_IsRequied = ((Label)gv_DA.Rows[i].Cells[1].FindControl("lbl_IsRequied"));
                        dataRow = aDataTable.NewRow();
                        dataRow["ExpenseTypDetailsId"] = hfExpenseTypDetailsId.Value;
                        dataRow["FieldName"] = lbl_FieldName.Text;
                        dataRow["IsRequied"] = lbl_IsRequied.Text;

                        

                        aDataTable.Rows.Add(dataRow);
                    }
             
                }
                else
                {
                    if (hfExpenseTypDetailsId.Value != "0")
                    {
                        ResultInfo Res = _setupDAL.delExpensDetls(hfExpenseTypDetailsId.Value);
                    }
                }
                }
                else
                {
                    count++;
                    showMessageBox("Can not be deleted!");
                }
             
       
       

        if (count == 0)
        {

            gv_DA.DataSource = aDataTable;
            gv_DA.DataBind();
        }


    }

    //protected void deleteImageButton_Click(object sender, EventArgs e)
    //{
    //    LinkButton ImageButton = (LinkButton)sender;
    //    GridViewRow currentRow = (GridViewRow)ImageButton.Parent.Parent;
    //    int rowindex = 0;
    //    rowindex = currentRow.RowIndex;

    //    Remove(rowindex);
    //}

    public bool Validation()
    {


         


        if (ddlTourPurpose.SelectedValue == "")
        {
            ddlTourPurpose.ToolTip = "please fill out this field";

            ddlTourPurpose.Focus();
            return false;
        }

          

         

        if (gvList.Rows.Count == 0)
        {
            showMessageBox("please Add to List One Row");

            return false;
        }


        

        return true;
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (Validation())
        {

            // List to hold TourPurposeOtherSetupDtl objects
            List<TourPurposeOtherSetupDtl> MarketList = new List<TourPurposeOtherSetupDtl>();

            // Loop through the GridView rows
            for (int i = 0; i < gvList.Rows.Count; i++)
            {
                // Get the current row
                GridViewRow row = gvList.Rows[i];

                // Retrieve HiddenFields and Labels from the GridView row
                HiddenField hfRoleId = (HiddenField)row.FindControl("hfRoleId");
                HiddenField hfTerritoryId = (HiddenField)row.FindControl("hfTerritoryId");
                HiddenField hfAreaId = (HiddenField)row.FindControl("hfAreaId");
                HiddenField hfRegionId = (HiddenField)row.FindControl("hfRegionId");
                HiddenField hfGroupId = (HiddenField)row.FindControl("hfGroupId");
                HiddenField hfStationTypeId = (HiddenField)row.FindControl("hfStationTypeId");

                Label lblRole = (Label)row.FindControl("lblRole");
                Label lblTerritory = (Label)row.FindControl("lblTerritory");
                Label lblArea = (Label)row.FindControl("lblArea");
                Label lblRegion = (Label)row.FindControl("lblRegion");
                Label lblStationType = (Label)row.FindControl("lblStationType");

                // Create a new instance of the TourPurposeOtherSetupDtl model
                TourPurposeOtherSetupDtl _DAO = new TourPurposeOtherSetupDtl();

                // Populate the model with the values from the GridView row
                _DAO.RoleName = lblRole.Text;
                _DAO.TerritoryId = string.IsNullOrEmpty(hfTerritoryId.Value) ? (int?)null : int.Parse(hfTerritoryId.Value);
                _DAO.AreaId = string.IsNullOrEmpty(hfAreaId.Value) ? (int?)null : int.Parse(hfAreaId.Value);
                _DAO.RegionId = string.IsNullOrEmpty(hfRegionId.Value) ? (int?)null : int.Parse(hfRegionId.Value);
                _DAO.GroupId = string.IsNullOrEmpty(hfGroupId.Value) ? (int?)null : int.Parse(hfGroupId.Value);
                _DAO.TourTypeId = string.IsNullOrEmpty(hfStationTypeId.Value) ? (int?)null : int.Parse(hfStationTypeId.Value);

                // Add the populated model to the list
                MarketList.Add(_DAO);
            }

            // Now MarketList contains the list of populated TourPurposeOtherSetupDtl objects





            TourPurposeOtherSetup aMaster = new TourPurposeOtherSetup();

            aMaster.TourPurposeOtherSetupId = id_mastetID.Value == "" ? 0 : Convert.ToInt32(id_mastetID.Value);

            aMaster.TourPurposeId = ddlTourPurpose.SelectedIndex > 0 ? int.Parse(ddlTourPurpose.SelectedValue) : (int?)null;

            int VisitTypeId = 0;
            if (visitType.Items[0].Selected)
            {
                VisitTypeId = 1;
            }
            else
            {
                VisitTypeId = 2;
            }

            aMaster.VisitTypeId = VisitTypeId;
            aMaster.IsActive = chkIsActive.Checked;


          ResultInfo Res = _setupDAL.SaveTPOtherMaster(aMaster, MarketList, Session["UserId"].ToString());
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','TourPurposeOtherSetup.aspx');", true);

            }

            else if (Res.isDuplicateCheck == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }

            else if (Res.isValiCheck == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Data cannot be deactivated!" + "','Faild');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }

        }
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {

    }

    protected void chkFixed_CheckedChanged(object sender, EventArgs e)
    {
        txtAmount.Text = string.Empty;
        txtAmount.ReadOnly = true;
        if (chkFixed.Checked)
        {
            txtAmount.ReadOnly= false;
        }
    }

    protected void roleSelect_SelectedIndexChanged(object sender, EventArgs e)
    {

        territoryGroup.Visible = false;
        areaGroup.Visible = false;
        regionGroup.Visible = false;
        DivGroup.Visible = false;
        territorySelect.SelectedIndex = 0;
        areaSelect.SelectedIndex = 0;
        regionSelect.SelectedIndex = 0;
        GroupSelect.SelectedIndex = 0;
        if (roleSelect.SelectedValue == "MIO")
        {
            territoryGroup.Visible = true;
        }if (roleSelect.SelectedValue == "AM")
        {
            areaGroup.Visible = true;
        }if (roleSelect.SelectedValue == "DZSM")
        {
            regionGroup.Visible = true;
        }
 if (roleSelect.SelectedValue == "NSM")
        {
            DivGroup.Visible = true;
        }
    }

    protected void restbtn_Click(object sender, EventArgs e)
    {

    }

    protected void ddlTourPurpose_SelectedIndexChanged(object sender, EventArgs e)
    {
        GetOneRecord(ddlTourPurpose.SelectedValue);
    }
}