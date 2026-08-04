using System;
using System.Activities.Statements;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_DCUserPermission : System.Web.UI.Page
{
    DCUserPermissionBll aDcUserPermissionBll = new DCUserPermissionBll();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadUser();
            LoadDCList();
        }
    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private void LoadUser()
    {
        aDcUserPermissionBll.LoadUserInfo(userDropDownList);
    }

    private void LoadDCList()
    {
        DataTable aTable = aDcUserPermissionBll.LoadDCList();

        if (aTable.Rows.Count > 0)
        {
            for (int j = 0; j < aTable.Rows.Count; j++)
            {
                var item = new ListItem
                {
                    Text = aTable.Rows[j]["CompanyUnit"].ToString(),
                    Value = aTable.Rows[j]["ComUnitId"].ToString()
                };

                dcCheckBoxList.Items.Add(item);
            }
        }
    }

    protected void userDropDownList_OnTextChanged(object sender, EventArgs e)
    {
        UncheckAllCheckBox();

        if (userDropDownList.SelectedValue != "")
        {
            DataTable aDataTable = aDcUserPermissionBll.LoadDCUserPermissionById(userDropDownList.SelectedValue);

            if (aDataTable.Rows.Count > 0)
            {
                for (int i = 0; i < dcCheckBoxList.Items.Count; i++)
                {
                    for (int j = 0; j < aDataTable.Rows.Count; j++)
                    {
                        if (dcCheckBoxList.Items[i].Value == aDataTable.Rows[j].Field<Int32>("CompanyUnitId").ToString(CultureInfo.InvariantCulture))
                        {
                            dcCheckBoxList.Items[i].Selected = true;
                        }
                    }
                }
            }
        }

    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (Validation())
        {
            var aPermissionDaoList = new List<UserCompanyUnitDao>();
            UserCompanyUnitDao aCompanyUnitDao;

            Int32 checkCount = CountDCCheck();

            for (int i = 0; i < dcCheckBoxList.Items.Count; i++)
            {
                if (dcCheckBoxList.Items[i].Selected)
                {
                    aCompanyUnitDao = new UserCompanyUnitDao();

                    aCompanyUnitDao.CompanyUnitId = Convert.ToInt32(dcCheckBoxList.Items[i].Value);
                    aCompanyUnitDao.UserId = Convert.ToInt32(userDropDownList.SelectedValue);

                    if (dcCheckBoxList.Items[i].Value == "15")
                    {
                        aCompanyUnitDao.CWHPermission = true;
                    }

                    if (checkCount == 11)
                    {
                        aCompanyUnitDao.NationalReportPermission = true;
                    }
   
                    aPermissionDaoList.Add(aCompanyUnitDao);
                }

            }

            bool status = aDcUserPermissionBll.LoadDCUserPermissionDataForSave(aPermissionDaoList,userDropDownList.SelectedValue);

            if (status)
            {
                Clear();
                ShowMessageBox("Permission Info Saved Successfully!!! ");
            }
            else
            {
                ShowMessageBox("Permission Info doesn't Saved Successfully!!! ");
            }
        }
    }

    private int CountDCCheck()
    {
        Int32 checkCount = 0;

        for (int i = 0; i < dcCheckBoxList.Items.Count; i++)
        {
            if (dcCheckBoxList.Items[i].Selected && dcCheckBoxList.Items[i].Value != "15" )
            {
                checkCount++;
            }
        }

        return checkCount;
    }


    private bool Validation()
    {
        if (userDropDownList.SelectedValue != "")
        {
            int selectCount = 0;

            for (int i = 0; i < dcCheckBoxList.Items.Count; i++)
            {
                if (dcCheckBoxList.Items[i].Selected)
                {
                    selectCount++;
                }
            }

            if (selectCount == 0)
            {
                ShowMessageBox("You have to select at least one DC !!!");
                return false;
            }

        }
        else
        {
            ShowMessageBox("You have to select an user !!!");
            return false;
        }

        return true;
    }

    protected void clearButton_Click(object sender, EventArgs e)
    {
        Clear();
    }

    private void Clear()
    {
        userDropDownList.SelectedValue = "";
        UncheckAllCheckBox();
    }

    private void UncheckAllCheckBox()
    {
        for (int i = 0; i < dcCheckBoxList.Items.Count; i++)
        {
            dcCheckBoxList.Items[i].Selected = false;
        }
    }
}