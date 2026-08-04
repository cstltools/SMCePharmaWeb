using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.MasterSetup_DAL;
using Library.DAO.DoctorModule_DAO;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class DoctorModule_UI_LeaveConfig : System.Web.UI.Page
{
    private static LeaveDal _leaveDal = new LeaveDal();
    static CommonDataLoad _dataLoad = new CommonDataLoad();
    private static BonusCampaignNewDAL _BonusCampaignNewDAL = new BonusCampaignNewDAL();

    protected void Page_Load(object sender, EventArgs e)
    {

        Page.Form.Attributes.Add("enctype", "multipart/form-data");
        if (!IsPostBack)
        {
            LoadInitialInfo();

           
            LoadInitialGrid();
            LoadgvDDl();


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

    private void GetOneRecord(string Id)
    {
        try
        {
            using (DataTable dt = _BonusCampaignNewDAL.GetLeaveConfigSetupById(Id))
            {
                txtLeaveName.Text = dt.Rows[0]["LeaveName"].ToString();

                bool CountGovtLeave = false;
                try
                {
                    CountGovtLeave = Convert.ToBoolean(dt.Rows[0]["CountGovtLeave"].ToString());
                }
                catch { }

                if (CountGovtLeave)
                {

                    rbCountGovtLeave.Items[0].Selected = true;
                }
                else
                {

                    rbCountGovtLeave.Items[1].Selected = true;
                }
              
                bool CountEmployeeHoliday = false;
                try
                {
                    CountEmployeeHoliday = Convert.ToBoolean(dt.Rows[0]["CountEmployeeHoliday"].ToString());
                }
                catch { }

                if (CountEmployeeHoliday)
                {

                    rbEmployeeWeeklyHoliday.Items[0].Selected = true;
                }
                else
                {

                    rbEmployeeWeeklyHoliday.Items[1].Selected = true;
                }


                rbEmployeeWeeklyHoliday_SelectedIndexChanged(null, null);


                ddlLeaveConType.SelectedValue = dt.Rows[0]["LeaveTypeId"].ToString();
                ddlDayName.SelectedValue = dt.Rows[0]["DayNameId"].ToString();

                ddlLeaveConType_SelectedIndexChanged(null, null);
                bool EligbleforProbationEmployee = false;
                try
                {
                    EligbleforProbationEmployee = Convert.ToBoolean(dt.Rows[0]["EligbleforProbationEmployee"].ToString());
                }
                catch { }

                if (EligbleforProbationEmployee)
                {

                    rbEligbleforProbationEmployee.Items[0].Selected = true;
                }
                else
                {

                    rbEligbleforProbationEmployee.Items[1].Selected = true;
                }


                try
                {
                    chkIsActive.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"].ToString());

                }
                catch
                {
                    chkIsActive.Checked = false;
                }

                string[] degree = dt.Rows[0]["ProductDCID"].ToString().Split(',');

                foreach (ListItem item in EmployeeIdSelect.Items)
                {
                    for (int i = 0; i < degree.Length; i++)
                    {
                        if (item.Value == degree[i].ToString())
                        {
                            item.Selected = true;

                        }
                    }
                }

                try
                {
                    itemGridView.DataSource = dt;
                    itemGridView.DataBind();
                    LoadgvDDl();

                    for (int i = 0; i < itemGridView.Rows.Count; i++)
                    {
                        ((DropDownList)itemGridView.Rows[i].Cells[1].FindControl("ddlJoiningDateCount")).SelectedValue = ((HiddenField)itemGridView.Rows[i].Cells[1].FindControl("hfJoiningDateCount")).Value.Trim();
                    }
                }
                catch
                {

                }
            }
        }
        catch { }
    }

                private void LoadgvDDl()
    {
        DataTable dt = _dataLoad.Get_JoiningDateCountInfo();
        for (int i = 0; i < itemGridView.Rows.Count; i++)
        {


            DropDownList ddlJoiningDateCount = ((DropDownList)itemGridView.Rows[i].Cells[1].FindControl("ddlJoiningDateCount"));

            ddlJoiningDateCount.DataSource = dt;
            ddlJoiningDateCount.DataValueField = "JoiningDateCountId";
            ddlJoiningDateCount.DataTextField = "JoiningDateCountName";
            ddlJoiningDateCount.DataBind();
            ddlJoiningDateCount.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
            ddlJoiningDateCount.SelectedIndex = 0;

        }
    }

    private void LoadInitialGrid()
    {
        DataTable aTable = new DataTable();

        aTable.Columns.Add("CountDays");
        aTable.Columns.Add("JoiningDateCountId");



        DataRow dr;

        dr = aTable.NewRow();
        dr["CountDays"] = "";
        dr["JoiningDateCountId"] = "";


        aTable.Rows.Add(dr);

        itemGridView.DataSource = null;
        itemGridView.DataBind();

        itemGridView.DataSource = aTable;
        itemGridView.DataBind();


        
    }

    private void LoadInitialInfo()
    {


        try
        {
            using (DataTable dt = _dataLoad.GetEmployeeList_Active())
            {
                EmployeeIdSelect.DataSource = dt;
                EmployeeIdSelect.DataValueField = "EmpInfoId";
                EmployeeIdSelect.DataTextField = "EmpName";
                EmployeeIdSelect.DataBind();
                try
                {
                  
                    EmployeeIdSelect.Items.Insert(-1, "");
                }
                catch (Exception ex) { }

                try
                {
                     
                    //EmployeeIdSelect.SelectedIndex = 0;
                }
                catch (Exception ex) { }
            }


        }
        catch (Exception ex) { }




        try
        {
            using (DataTable dt = _dataLoad.Get_DayName())
            {
                ddlDayName.DataSource = dt;
                ddlDayName.DataValueField = "DayNameValueId";
                ddlDayName.DataTextField = "DayNameValue";
                ddlDayName.DataBind();
                ddlDayName.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlDayName.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }


        try
        {
            using (DataTable dt = _dataLoad.Get_LeaveConType())
            {
                ddlLeaveConType.DataSource = dt;
                ddlLeaveConType.DataValueField = "LeaveConTypeId";
                ddlLeaveConType.DataTextField = "LeaveConType";
                ddlLeaveConType.DataBind();
                ddlLeaveConType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlLeaveConType.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }



    }
    //public void date()
    //{
    //    for (int i = 1; i <= 31; i++)
    //    {
    //        ddlDay.Items.Add(i.ToString());
    //    }
    //}
   

        [WebMethod]
    public static EmployeeLeave GetEmployeeEditData(int id)
    {
        return (_leaveDal.GetEmployeeLeaveForEdit(id));
    }

    [WebMethod]
    public static ResultInfo Save_Leaveinfo(EmployeeLeave employee)
    {

        
            return (_leaveDal.Save_LeaveInfo(employee, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
        

    }

    protected void rbEmployeeWeeklyHoliday_SelectedIndexChanged(object sender, EventArgs e)
    {
        divDay.Visible = false;
        if (rbEmployeeWeeklyHoliday.Items[0].Selected)
        {
            divDay.Visible = true;

        }
    }






   

    protected void ddlLeaveConType_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadInitialGrid();
        LoadgvDDl();
        divList.Visible = false;
        divEmp.Visible = false;
        try
        { 
            EmployeeIdSelect.Items.Clear();
        }
        catch (Exception ex) { }
        if (ddlLeaveConType.SelectedItem.Text == "Foreign")
        {
            divEmp.Visible = true;

            try
            {
                using (DataTable dt = _dataLoad.GetEmployeeList_Active())
                {
                    EmployeeIdSelect.DataSource = dt;
                    EmployeeIdSelect.DataValueField = "EmpInfoId";
                    EmployeeIdSelect.DataTextField = "EmpName";
                    EmployeeIdSelect.DataBind();
                    try
                    {

                        EmployeeIdSelect.Items.Insert(-1, "");
                    }
                    catch (Exception ex) { }

                    try
                    {

                        //EmployeeIdSelect.SelectedIndex = 0;
                    }
                    catch (Exception ex) { }

                }
            }
            catch (Exception ex) { }

        }

        if (ddlLeaveConType.SelectedItem.Text == "Annual" || ddlLeaveConType.SelectedItem.Text == "Sick" || ddlLeaveConType.SelectedItem.Text == "Casual")
        {
            divList.Visible = true;
        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        DataTable aTable = new DataTable();
         
        aTable.Columns.Add("CountDays");
        aTable.Columns.Add("JoiningDateCountId");
        DataRow dr;
        for (int i = 0; i < itemGridView.Rows.Count; i++)
        {

            dr = aTable.NewRow();



            dr["CountDays"] =
                ((TextBox)itemGridView.Rows[i].Cells[1].FindControl("txtCountDays")).Text.Trim();

            dr["JoiningDateCountId"] = ((DropDownList)itemGridView.Rows[i].Cells[1].FindControl("ddlJoiningDateCount")).SelectedValue;

            ((HiddenField)itemGridView.Rows[i].Cells[1].FindControl("hfJoiningDateCount")).Value  = ((DropDownList)itemGridView.Rows[i].Cells[1].FindControl("ddlJoiningDateCount")).SelectedValue;









            aTable.Rows.Add(dr);

        }


       

        dr = aTable.NewRow();
        dr["CountDays"] = "";
        dr["JoiningDateCountId"] = "";

       
 

        aTable.Rows.Add(dr);


        
        itemGridView.DataSource = null;
        itemGridView.DataBind();
        itemGridView.DataSource = aTable;
        itemGridView.DataBind();

        LoadgvDDl();

        for (int i = 0; i < itemGridView.Rows.Count; i++)
        {
            ((DropDownList)itemGridView.Rows[i].Cells[1].FindControl("ddlJoiningDateCount")).SelectedValue = ((HiddenField)itemGridView.Rows[i].Cells[1].FindControl("hfJoiningDateCount")).Value.Trim();
        }

        }

    protected void btnDel_Click(object sender, EventArgs e)
    {
        int rowIndex = ((GridViewRow)(((LinkButton)sender).Parent.Parent)).RowIndex;

        DataTable aTable = new DataTable();

        aTable.Columns.Add("CountDays");
        aTable.Columns.Add("JoiningDateCountId");
        DataRow dr;
         
        for (int i = 0; i < itemGridView.Rows.Count; i++)
        {
            if (i != rowIndex)
            {
                dr = aTable.NewRow();

                dr["CountDays"] =
                    ((TextBox)itemGridView.Rows[i].Cells[1].FindControl("txtCountDays")).Text.Trim();

                dr["JoiningDateCountId"] = ((DropDownList)itemGridView.Rows[i].Cells[1].FindControl("ddlJoiningDateCount")).SelectedValue;

                ((HiddenField)itemGridView.Rows[i].Cells[1].FindControl("hfJoiningDateCount")).Value = ((DropDownList)itemGridView.Rows[i].Cells[1].FindControl("ddlJoiningDateCount")).SelectedValue;
                 
                aTable.Rows.Add(dr);
            }
        }
       
        itemGridView.DataSource = aTable;
        itemGridView.DataBind();

        LoadgvDDl();

        for (int i = 0; i < itemGridView.Rows.Count; i++)
        {
            ((DropDownList)itemGridView.Rows[i].Cells[1].FindControl("ddlJoiningDateCount")).SelectedValue = ((HiddenField)itemGridView.Rows[i].Cells[1].FindControl("hfJoiningDateCount")).Value.Trim();
        }

    }



    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (Validation())
        {

            List<LeaveConfigCountDtl> MarketList = new List<LeaveConfigCountDtl>();


            for (int i = 0; i < itemGridView.Rows.Count; i++)
            {
                DropDownList ddlJoiningDateCount = ((DropDownList)itemGridView.Rows[i].Cells[1].FindControl("ddlJoiningDateCount"));
               
                TextBox txtCountDays = ((TextBox)itemGridView.Rows[i].Cells[1].FindControl("txtCountDays"));


                if(ddlJoiningDateCount.SelectedValue!="" && txtCountDays.Text != "")
                {
                    LeaveConfigCountDtl _DAO = new LeaveConfigCountDtl();

                    _DAO.JoiningDateCountId = ddlJoiningDateCount.SelectedIndex > 0 ? int.Parse(ddlJoiningDateCount.SelectedValue) : (int?)null;

                    _DAO.DaysPerMonthly =   (txtCountDays.Text);



                    MarketList.Add(_DAO);
                }

               

            }



            LeaveConfigDAO aMaster = new LeaveConfigDAO();

            aMaster.LeaveConfigId = id_mastetID.Value == "" ? 0 : Convert.ToInt32(id_mastetID.Value);

            aMaster.LeaveName = string.IsNullOrEmpty(txtLeaveName.Text) ? null : txtLeaveName.Text;
            aMaster.CountGovtLeave = false;
            if (rbCountGovtLeave.Items[0].Selected)
            {
                aMaster.CountGovtLeave = true;
            }
            aMaster.CountEmployeeHoliday = false;
            if (rbEmployeeWeeklyHoliday.Items[0].Selected)
            {
                aMaster.CountEmployeeHoliday = true;
            }
            
            aMaster.DayNameId = ddlDayName.SelectedIndex > 0 ? int.Parse(ddlDayName.SelectedValue) : (int?)null;

            aMaster.EligbleforProbationEmployee = false;
            if (rbEligbleforProbationEmployee.Items[0].Selected)
            {
                aMaster.EligbleforProbationEmployee = true;
            }

            aMaster.LeaveTypeId = ddlLeaveConType.SelectedIndex > 0 ? int.Parse(ddlLeaveConType.SelectedValue) : (int?)null;

            aMaster.IsActive = chkIsActive.Checked;



            string DisArray = "";

            foreach (ListItem item in EmployeeIdSelect.Items)
            {
                if (item.Selected)
                {

                    DisArray = DisArray + item.Value + ",";
                }
            }

            DisArray = DisArray.TrimEnd(',');


            ResultInfo Res = _BonusCampaignNewDAL.SaveLeaveConfig(aMaster, DisArray, MarketList,  Session["UserId"].ToString());
            if (Res.isSuccess == true)
            {
             
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','LeaveConfigList.aspx');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }

        }

    }

    private bool Validation()
    {
        return true;
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("LeaveConfig.aspx");
    }
}