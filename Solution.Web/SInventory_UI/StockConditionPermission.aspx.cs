using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_StockConditionPermission : System.Web.UI.Page
{
    StockConditionPermissionBll aConditionPermissionBll = new StockConditionPermissionBll();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadUserOnDropdownList();
            LoadStockCondition();
        }
    }

    private void LoadStockCondition()
    {
        DataTable aTable = aConditionPermissionBll.LoadStockConditionList();

        if (aTable.Rows.Count > 0)
        {
            for (int j = 0; j < aTable.Rows.Count; j++)
            {
                var item = new ListItem
                {
                    Text = aTable.Rows[j]["StockCondition"].ToString(),
                    Value = aTable.Rows[j]["StockConId"].ToString()
                };

                stockConditionCheckBoxList.Items.Add(item);
            }
        }
    }

    private void LoadUserOnDropdownList()
    {
        aConditionPermissionBll.LoadUserInfo(userDropDownList);
    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private bool Validation()
    {
        if (userDropDownList.SelectedValue != "")
        {
            int selectCount = 0;

            for (int i = 0; i < stockConditionCheckBoxList.Items.Count; i++)
            {
                if (stockConditionCheckBoxList.Items[i].Selected)
                {
                    selectCount++;
                }
            }

            if (selectCount == 0)
            {
                ShowMessageBox("You have to select at least one condition !!!");
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

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (Validation())
        {
            var aPermissionDaoList = new List<StockConditionPermissionDao>();
            StockConditionPermissionDao aPermissionDao;

            for (int i = 0; i < stockConditionCheckBoxList.Items.Count; i++)
            {
                if (stockConditionCheckBoxList.Items[i].Selected)
                {
                    aPermissionDao = new StockConditionPermissionDao();

                    aPermissionDao.StockConId = Convert.ToInt32(stockConditionCheckBoxList.Items[i].Value);
                    aPermissionDao.UserId = Convert.ToInt32(userDropDownList.SelectedValue);
                    aPermissionDao.Permission = true;
                    aPermissionDaoList.Add(aPermissionDao);
                }
               
            }

            bool status = aConditionPermissionBll.LoadStockPermissionDataForSave(aPermissionDaoList);

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

    
    protected void userDropDownList_OnTextChanged(object sender, EventArgs e)
    {

        UncheckAllCheckBox();

        if (userDropDownList.SelectedValue != "")
        {
            DataTable aDataTable = aConditionPermissionBll.LoadStockConditionByUserId(userDropDownList.SelectedValue);

            if (aDataTable.Rows.Count > 0)
            {
                for (int i = 0; i < stockConditionCheckBoxList.Items.Count; i++)
                {
                    for (int j = 0; j < aDataTable.Rows.Count; j++)
                    {
                        if (stockConditionCheckBoxList.Items[i].Value == aDataTable.Rows[j].Field<Int32>("StockConId").ToString(CultureInfo.InvariantCulture))
                        {
                            stockConditionCheckBoxList.Items[i].Selected = true;
                        }
                    }                
                }
            }
        }
    }

    private void UncheckAllCheckBox()
    {
        for (int i = 0; i < stockConditionCheckBoxList.Items.Count; i++)
        {
            stockConditionCheckBoxList.Items[i].Selected = false;
        }
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
}