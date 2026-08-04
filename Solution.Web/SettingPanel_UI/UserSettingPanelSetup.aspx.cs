using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Library.DAL.SettingPanel_DAL;
using Library.DAO.DWSP_DAO;
using Library.DAO.SettingPanel_DAO;
using SalesSolution.Web.Models;

public partial class SettingPanel_UI_UserSettingPanelSetup : System.Web.UI.Page
{

    private UserSettingPanelDal aPanelDal = new UserSettingPanelDal();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            loadUserSettingData();
        }
    }


    private void loadUserSettingData()
    {
        DataTable aDataTable = aPanelDal.Get_UserSettingPanel();
        if (aDataTable.Rows.Count > 0)
        {
            gv_List.DataSource = aDataTable;
            gv_List.DataBind();

            for (int i = 0; i < aDataTable.Rows.Count; i++)
            {
                DateTime FromDate = Convert.ToDateTime(aDataTable.Rows[i]["FromDate"]);
                DateTime Todate = Convert.ToDateTime(aDataTable.Rows[i]["Todate"]);
               
                    TextBox frmDate = (TextBox)gv_List.Rows[i].FindControl("txtFromDate");
                    frmDate.Text = FromDate.ToString("yyyy-MM-dd HH:mm:ss").Replace(' ', 'T');

                    TextBox txtToDate = (TextBox)gv_List.Rows[i].FindControl("txtToDate");
                    txtToDate.Text = Todate.ToString("yyyy-MM-dd HH:mm:ss").Replace(' ', 'T');
                
            }

        }
    }

    protected void gv_DocumentUpload_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;

        if ((gv.ShowHeader == true && gv.Rows.Count > 0) || (gv.ShowHeaderWhenEmpty == true))
        {
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {

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

        int count = 0;

        for (int i = 0; i < gv_List.Rows.Count; i++)
        {
            CheckBox aCheckBox = (CheckBox)gv_List.Rows[i].FindControl("ckCheckBox");

            if (aCheckBox.Checked)
            {
                count++;
            }
        }

        if (count == 0)
        {
            showMessageBox("Please Select Minimum One");
            return false;
        }

        return true;
    }


    protected void btnUpdate_OnClick(object sender, EventArgs e)
    {
        if (Validation())
        {

            ResultInfo aInfo = aPanelDal.SaveUserPanelSettting(DataPrepareForUpdate());

            if (aInfo.isSuccess)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','UserSettingPanelSetup.aspx');", true);
            }
        }
    }


    private List<UserSettingPanelDao> DataPrepareForUpdate()
    {
        List<UserSettingPanelDao> aList = new List<UserSettingPanelDao>();

        for (int i = 0; i < gv_List.Rows.Count; i++)
        {
            CheckBox aCheckBox = (CheckBox)gv_List.Rows[i].FindControl("ckCheckBox");
            if (aCheckBox.Checked)
            {
                UserSettingPanelDao aDao = new UserSettingPanelDao();
                string SettingPanelId = gv_List.DataKeys[i][0].ToString();
                TextBox fromDate = (TextBox)gv_List.Rows[i].FindControl("txtFromDate");
                TextBox TodateDate = (TextBox)gv_List.Rows[i].FindControl("txtToDate");
                aDao.UserSettingPanelId = int.Parse(SettingPanelId);
                aDao.FromDate = string.IsNullOrEmpty(fromDate.Text.Trim()) ?(DateTime ?) null : Convert.ToDateTime(fromDate.Text.Trim());
                aDao.Todate = string.IsNullOrEmpty(TodateDate.Text.Trim()) ? (DateTime?)null : Convert.ToDateTime(TodateDate.Text.Trim());
                aList.Add(aDao);
            }
        }

        return aList;
    }

    protected void btn_Reset_OnClick(object sender, EventArgs e)
    {
        Response.Redirect("UserSettingPanelSetup.aspx");
    }

    protected void ckAllCheckBox_OnCheckedChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < gv_List.Rows.Count; i++)
        {

            CheckBox allCheckBox = (CheckBox)gv_List.HeaderRow.FindControl("ckAllCheckBox");
            CheckBox ckCheckBox = (CheckBox)gv_List.Rows[i].FindControl("ckCheckBox");

            if(allCheckBox.Checked)
            {
                ckCheckBox.Checked = true;
            }
            else
            {
                ckCheckBox.Checked = false;
            }

        }
    }
}