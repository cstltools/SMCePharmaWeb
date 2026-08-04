using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.Panal_BLL;

public partial class CommonUI_UserPermission : System.Web.UI.Page
{
    PanalBLL aPanalBll = new PanalBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            aPanalBll.UserDdl(userDropDownList);           
        }
    }

    private void CheckBox()
    {
    }

    protected void userDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        MainMenuLoad();
        aPanalBll.MainMenu(mainMenuDropDownList, userDropDownList.SelectedValue);
        menuGridView.DataSource = null;
        menuGridView.DataBind();
    }
    
    protected void mainMenuGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string status = mainMenuGridView.DataKeys[e.Row.RowIndex].Values[1].ToString();
            CheckBox mainMenuCheckBox = (CheckBox)e.Row.FindControl("mainMenuCheckBox");
            if (status.Trim()=="1")
            {
                mainMenuCheckBox.Checked = true;
                mainMenuCheckBox.Enabled = false;
            }
        }
    }
    
    private void MainMenuLoad()
    {       
        mainMenuGridView.DataSource = aPanalBll.MainMenuLoad(userDropDownList.SelectedValue);
        mainMenuGridView.DataBind();
    }

    private void MenuLoad(string userId,string parantId)
    {
        menuGridView.DataSource = aPanalBll.OtherMenuLoad(userId, parantId);
        menuGridView.DataBind();
    }

    protected void allsaveMenuImageButton_Click(object sender, ImageClickEventArgs e)
    {
            for (int i = 0; i < menuGridView.Rows.Count; i++)
            {
                CheckBox ChkBoxRows = (CheckBox)menuGridView.Rows[i].Cells[0].FindControl("menuCheckBox");
                if (ChkBoxRows.Enabled)
                {
                    if (ChkBoxRows.Checked)
                    {

                        int rowindex = Convert.ToInt32(i);
                        string sL = menuGridView.DataKeys[rowindex][0].ToString();
                        CheckBox mainMenuCheckBox = (CheckBox)menuGridView.Rows[rowindex].Cells[0].FindControl("menuCheckBox");
                        if (mainMenuCheckBox.Checked)
                        {
                            if (mainMenuCheckBox.Enabled != false)
                            {
                                bool ok = aPanalBll.SaveMainMenu(Convert.ToInt32(sL), Convert.ToInt32(userDropDownList.SelectedValue));
                                if (ok == true)
                                {
                                    MainMenuLoad();
                                    aPanalBll.MainMenu(mainMenuDropDownList, userDropDownList.SelectedValue);
                                    msgLabel.Text = "Data Save";
                                    msgLabel.ForeColor = System.Drawing.Color.SeaGreen;
                                }
                                else
                                {
                                    msgLabel.Text = "Eroor!!";
                                    msgLabel.ForeColor = System.Drawing.Color.Red;
                                }
                            }
                        }
                        else
                        {
                            msgLabel.Text = "Select First";
                            msgLabel.ForeColor = System.Drawing.Color.Red;
                        }
                    }
                }
            }
    }
    protected void mainMenuGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
       
        if (e.CommandName == "SaveData")
        {
            //Get rowindex
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string sL = mainMenuGridView.DataKeys[rowindex][0].ToString();
            CheckBox mainMenuCheckBox = (CheckBox)mainMenuGridView.Rows[rowindex].Cells[0].FindControl("mainMenuCheckBox");
            if (mainMenuCheckBox.Checked)
            {
                if (mainMenuCheckBox.Enabled!=false)
                {
                    bool ok = aPanalBll.SaveMainMenu(Convert.ToInt32(sL), Convert.ToInt32(userDropDownList.SelectedValue));
                    if (ok == true)
                    {
                        MainMenuLoad();
                        aPanalBll.MainMenu(mainMenuDropDownList, userDropDownList.SelectedValue);
                        msgLabel.Text = "Data Save";
                        msgLabel.ForeColor = System.Drawing.Color.SeaGreen;
                    }
                    else
                    {
                        msgLabel.Text = "Eroor!!";
                        msgLabel.ForeColor = System.Drawing.Color.Red;
                    }
                }                                
            }
            else
            {
                msgLabel.Text = "Select First";
                msgLabel.ForeColor = System.Drawing.Color.Red;
            }
        }
        if (e.CommandName == "Remove")
        {
            //Get rowindex
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string sL = mainMenuGridView.DataKeys[rowindex][0].ToString();
            CheckBox mainMenuCheckBox = (CheckBox)mainMenuGridView.Rows[rowindex].Cells[0].FindControl("mainMenuCheckBox");
            if (mainMenuCheckBox.Checked)
            {
                bool ok = aPanalBll.MenuPermissionRemove(Convert.ToInt32(sL), Convert.ToInt32(userDropDownList.SelectedValue));
                if (ok == true)
                {
                    MainMenuLoad();
                    aPanalBll.MainMenu(mainMenuDropDownList, userDropDownList.SelectedValue);
                    MenuLoad(userDropDownList.SelectedValue, mainMenuDropDownList.SelectedValue);
                    msgLabel.Text = "Permission Delete";
                    msgLabel.ForeColor = System.Drawing.Color.SeaGreen;
                }
                else
                {
                    msgLabel.Text = "Eroor!!";
                    msgLabel.ForeColor = System.Drawing.Color.Red;
                }
            }
            else
            {
                msgLabel.Text = "Select First";
                msgLabel.ForeColor = System.Drawing.Color.Red;
            }
        }
    }

    protected void menuGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string status = menuGridView.DataKeys[e.Row.RowIndex].Values[1].ToString();
            CheckBox MenuCheckBox = (CheckBox)e.Row.FindControl("menuCheckBox");
            if (status.Trim() == "1")
            {
                MenuCheckBox.Checked = true;
                MenuCheckBox.Enabled = false;
            }
        }
    }
    
    protected void mainMenuDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        MenuLoad(userDropDownList.SelectedValue, mainMenuDropDownList.SelectedValue);
    }
    protected void menuGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "SaveData")
        {
            //Get rowindex
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string sL = menuGridView.DataKeys[rowindex][0].ToString();
            CheckBox menuCheckBox = (CheckBox)menuGridView.Rows[rowindex].Cells[0].FindControl("menuCheckBox");
            if (menuCheckBox.Checked)
            {
                if (menuCheckBox.Enabled!=false)
                {
                    bool ok = aPanalBll.SaveMenuBll(Convert.ToInt32(sL), Convert.ToInt32(userDropDownList.SelectedValue));
                    if (ok == true)
                    {
                        MenuLoad(userDropDownList.SelectedValue, mainMenuDropDownList.SelectedValue);
                        msgLabel.Text = "Data Save";
                        msgLabel.ForeColor = System.Drawing.Color.SeaGreen;
                    }
                    else
                    {
                        msgLabel.Text = "Eroor!!";
                        msgLabel.ForeColor = System.Drawing.Color.Red;
                    }
                }
            }
            else
            {
                msgLabel.Text = "Select First";
                msgLabel.ForeColor = System.Drawing.Color.Red;
            }
        }

        if (e.CommandName == "Remove")
        {
            //Get rowindex
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string sL = menuGridView.DataKeys[rowindex][0].ToString();
            CheckBox mainMenuCheckBox = (CheckBox)menuGridView.Rows[rowindex].Cells[0].FindControl("menuCheckBox");
            if (mainMenuCheckBox.Checked)
            {
                bool ok = aPanalBll.MenuPermissionRemove(Convert.ToInt32(sL), Convert.ToInt32(userDropDownList.SelectedValue));
                if (ok == true)
                {
                    MainMenuLoad();
                    MenuLoad(userDropDownList.SelectedValue, mainMenuDropDownList.SelectedValue);
                    msgLabel.Text = "Permission Delete";
                    msgLabel.ForeColor = System.Drawing.Color.SeaGreen;
                }
                else
                {
                    msgLabel.Text = "Eroor!!";
                    msgLabel.ForeColor = System.Drawing.Color.Red;
                }
            }
            else
            {
                msgLabel.Text = "Select First";
                msgLabel.ForeColor = System.Drawing.Color.Red;
            }

        }
    }
    protected void menuAllCheckBox_CheckedChanged(object sender, EventArgs e)
    {

        CheckBox ChkBoxHeader = (CheckBox)menuGridView.HeaderRow.FindControl("menuAllCheckBox");

        for (int i = 0; i < menuGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)menuGridView.Rows[i].Cells[0].FindControl("menuCheckBox");
            if (ChkBoxRows.Enabled == true)
            {
                if (ChkBoxHeader.Checked == true)
                {
                    ChkBoxRows.Checked = true;
                }
                else
                {
                    ChkBoxRows.Checked = false;
                }
            }

        }
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
}