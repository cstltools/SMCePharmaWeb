using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.Panal_BLL;
using Library.DAO.Panal_Entities;

public partial class CommonUI_AdminMenuPanal : System.Web.UI.Page
{
    ObjPanal aObjPanal;
    PanalBLL aPanalBll = new PanalBLL();
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            LoadDDL();
        }
        else
        {
            msgLabel.Text = "";
        }
    }
    protected void addPageCheckBox_CheckedChanged(object sender, EventArgs e)
    {
        //////for jquery Accordian///////
        hidAccordionIndex.Value = "0";
        //////////////////////////////
        if (addPageCheckBox.Checked==true)
        {
            divAddpage.Visible = true;
        }
        else
        {
            divAddpage.Visible = false;
        }
    }

    private void LoadDDL()
    {
        aPanalBll.MainMenuDropdown(ddlMMenuNameMPanal);
        aPanalBll.MainMenuDropdown(ddlSubMMenuNameMPanal);
        aPanalBll.MainMenuDropdown(ddlChMMenuNameMPanal);
    }
    protected void addPageCheckBoxMenu_CheckedChanged(object sender, EventArgs e)
    {
        //////for jquery Accordian///////
        hidAccordionIndex.Value = "1";
        //////////////////////////////
        if (addPageCheckBoxMenu.Checked == true)
        {
            divMenu.Visible = true;
        }
        else
        {
            divMenu.Visible = false;
        }
    }

    private bool SubMenuValidation()
    {
        if (string.IsNullOrEmpty(ddlMenuNameForSubMenu.SelectedValue))
        {
            msgLabel.Text = "Select Required DropDown!!";
            msgLabel.ForeColor = System.Drawing.Color.Red;
            return false;
        }
        if (string.IsNullOrEmpty(subMenuNameTextBox.Text))
        {
            msgLabel.Text = "Fill Required TextBox!!";
            msgLabel.ForeColor = System.Drawing.Color.Red;
            return false;
        }
        if (addPageCheckBoxSubMenu.Checked)
        {
            if (string.IsNullOrEmpty(submenuDisFolderTextBox.Text))
            {
                msgLabel.Text = "Fill Required TextBox!!";
                msgLabel.ForeColor = System.Drawing.Color.Red;
                return false;
            }
            if (string.IsNullOrEmpty(submenuPageTextBox.Text))
            {
                msgLabel.Text = "Fill Required TextBox!!";
                msgLabel.ForeColor = System.Drawing.Color.Red;
                return false;
            }
        }

        return true;
    }
    private void SubMenuSave()
    {
        aObjPanal = new ObjPanal();
        aObjPanal.ManuName = subMenuNameTextBox.Text.Trim();
        if (addPageCheckBoxSubMenu.Checked)
        {
            aObjPanal.URL = "../" + submenuDisFolderTextBox.Text.Trim() + "/" + submenuPageTextBox.Text.Trim();
        }
        else
        {
            aObjPanal.URL = "#";
        }
        aObjPanal.ParantId = ddlMenuNameForSubMenu.SelectedValue;
        
        bool mainMenuSaveOk = aPanalBll.MenuSaveBll(aObjPanal);

        if (mainMenuSaveOk)
        {
            msgLabel.Text = "Menu Save";
            msgLabel.ForeColor = System.Drawing.Color.Green;
            subMenuNameTextBox.Text = "";
            submenuDisFolderTextBox.Text = "";
            submenuPageTextBox.Text = "";
            addPageCheckBoxSubMenu.Checked = false;
            ddlMenuNameForSubMenu.SelectedIndex = -1;
          
            divSubMenu.Visible = false;
            LoadDDL();
        }
    }




    private bool MenuValidation()
    {
        if (string.IsNullOrEmpty(ddlMMenuNameMPanal.SelectedValue))
        {
            msgLabel.Text = "Select Required DropDown!!";
            msgLabel.ForeColor = System.Drawing.Color.Red;
            return false;
        }
        if (string.IsNullOrEmpty(menuNameTextBox.Text))
        {
            msgLabel.Text = "Fill Required TextBox!!";
            msgLabel.ForeColor = System.Drawing.Color.Red;
            return false;
        }
        if (addPageCheckBoxMenu.Checked)
        {
            if (string.IsNullOrEmpty(menuDisFolderTextBox.Text))
            {
                msgLabel.Text = "Fill Required TextBox!!";
                msgLabel.ForeColor = System.Drawing.Color.Red;
                return false;
            }
            if (string.IsNullOrEmpty(menuPageTextBox.Text))
            {
                msgLabel.Text = "Fill Required TextBox!!";
                msgLabel.ForeColor = System.Drawing.Color.Red;
                return false;
            }
        }

        return true;
    }
    private void MenuSave()
    {
        aObjPanal = new ObjPanal();
        aObjPanal.ManuName = menuNameTextBox.Text.Trim();
        if (addPageCheckBoxMenu.Checked)
        {
            aObjPanal.URL = "../" + menuDisFolderTextBox.Text.Trim() + "/" + menuPageTextBox.Text.Trim();
        }
        else
        {
            aObjPanal.URL = "#";
        }
        aObjPanal.ParantId = ddlMMenuNameMPanal.SelectedValue;
       
        bool mainMenuSaveOk = aPanalBll.MenuSaveBll(aObjPanal);

        if (mainMenuSaveOk)
        {
            msgLabel.Text = "Menu Save";
            msgLabel.ForeColor = System.Drawing.Color.Green;
            menuNameTextBox.Text = "";
            menuDisFolderTextBox.Text = "";
            menuPageTextBox.Text = "";
            addPageCheckBoxMenu.Checked = false;
            divMenu.Visible = false;
            LoadDDL();
        }
    }


    private bool MainMenuValidation()
    {
        if (string.IsNullOrEmpty(mainMenuNameTextBox.Text))
        {
            msgLabel.Text = "Fill Required TextBox!!";
            msgLabel.ForeColor = System.Drawing.Color.Red;
            return false;
        }
        if (addPageCheckBox.Checked)
        {
            if (string.IsNullOrEmpty(mainMenuDesFolderTextBox.Text))
            {
                msgLabel.Text = "Fill Required TextBox!!";
                msgLabel.ForeColor = System.Drawing.Color.Red;
                return false;
            }
            if (string.IsNullOrEmpty(mainMenuPageNameTextBox.Text))
            {
                msgLabel.Text = "Fill Required TextBox!!";
                msgLabel.ForeColor = System.Drawing.Color.Red;
                return false;
            }
        }

        return true;
    }
    private void MainMenuSave()
    {
        aObjPanal = new ObjPanal();
        aObjPanal.ManuName = mainMenuNameTextBox.Text.Trim();
        if (addPageCheckBox.Checked)
        {
            aObjPanal.URL = "../" + mainMenuDesFolderTextBox.Text.Trim()+"/"+mainMenuPageNameTextBox.Text.Trim();
        }
        else
        {
            aObjPanal.URL = "#";
        }
        aObjPanal.ParantId = null;
       
        bool mainMenuSaveOk = aPanalBll.MenuSaveBll(aObjPanal);

        if (mainMenuSaveOk)
        {
            msgLabel.Text = "MainMenu Save";
            msgLabel.ForeColor = System.Drawing.Color.Green;
            mainMenuNameTextBox.Text = "";
            mainMenuDesFolderTextBox.Text = "";
            mainMenuPageNameTextBox.Text = "";
            addPageCheckBox.Checked = false;
            divAddpage.Visible = false;
            LoadDDL();
        }

    }



    private bool ChildMenuValidation()
    {
        if (string.IsNullOrEmpty(ddlsubMenuName.SelectedValue))
        {
            msgLabel.Text = "Select Required DropDown!!";
            msgLabel.ForeColor = System.Drawing.Color.Red;
            return false;
        }
        if (string.IsNullOrEmpty(childMenuNameTextBox.Text))
        {
            msgLabel.Text = "Fill Required TextBox!!";
            msgLabel.ForeColor = System.Drawing.Color.Red;
            return false;
        }
       
            if (string.IsNullOrEmpty(childDisFolderTextBox.Text))
            {
                msgLabel.Text = "Fill Required TextBox!!";
                msgLabel.ForeColor = System.Drawing.Color.Red;
                return false;
            }
            if (string.IsNullOrEmpty(childMenuPageTextBox.Text))
            {
                msgLabel.Text = "Fill Required TextBox!!";
                msgLabel.ForeColor = System.Drawing.Color.Red;
                return false;
            }
       

        return true;
    }
    private void ChildMenuSave()
    {
        aObjPanal = new ObjPanal();
        aObjPanal.ManuName = childMenuNameTextBox.Text.Trim();
        
        aObjPanal.URL = "../" + childDisFolderTextBox.Text.Trim() + "/" + childMenuPageTextBox.Text.Trim();
       
        aObjPanal.ParantId = ddlsubMenuName.SelectedValue;

        bool mainMenuSaveOk = aPanalBll.MenuSaveBll(aObjPanal);

        if (mainMenuSaveOk)
        {
            msgLabel.Text = "MainMenu Save";
            msgLabel.ForeColor = System.Drawing.Color.Green;
            childMenuNameTextBox.Text = "";
            childDisFolderTextBox.Text = "";
            childMenuPageTextBox.Text = "";

            ddlMenuNameForChildMenu.SelectedIndex = -1;
            ddlsubMenuName.SelectedIndex = -1;
           
            LoadDDL();
        }

    }

    

    protected void menuSaveButton_Click(object sender, EventArgs e)
    {
        //////for jquery Accordian///////
        hidAccordionIndex.Value = "1";
        //////////////////////////////
        if (MenuValidation()==true)
        {
            MenuSave();
        }
    }
    protected void saveMainMenuButton_Click(object sender, EventArgs e)
    {
        //////for jquery Accordian///////
        hidAccordionIndex.Value = "0";
        //////////////////////////////
        if (MainMenuValidation()==true)
        {
            MainMenuSave();

            
        }
    }

    protected void subMenuSaveButton_Click(object sender, EventArgs e)
    {
        //////for jquery Accordian///////
        hidAccordionIndex.Value = "2";
        //////////////////////////////
        if (SubMenuValidation()==true)
        {
            SubMenuSave();
        }
    }
    protected void ddlSubMMenuNameMPanal_SelectedIndexChanged(object sender, EventArgs e)
    {
        //////for jquery Accordian///////
        hidAccordionIndex.Value = "2";
        //////////////////////////////
        if (ddlSubMMenuNameMPanal.SelectedValue!="")
        {
            aPanalBll.MenuDropdown(ddlMenuNameForSubMenu, ddlSubMMenuNameMPanal.SelectedValue);
        }
    }
    protected void ddlChMMenuNameMPanal_SelectedIndexChanged(object sender, EventArgs e)
    {
        //////for jquery Accordian///////
        hidAccordionIndex.Value = "3";
        //////////////////////////////
        if (ddlChMMenuNameMPanal.SelectedValue != "")
        {
            aPanalBll.MenuDropdown(ddlMenuNameForChildMenu, ddlChMMenuNameMPanal.SelectedValue);
        }
    }
   
    protected void ddlMenuNameForChildMenu_SelectedIndexChanged(object sender, EventArgs e)
    {
        //////for jquery Accordian///////
        hidAccordionIndex.Value = "3";
        //////////////////////////////
        if (ddlMenuNameForChildMenu.SelectedValue != "")
        {
            aPanalBll.MenuDropdown(ddlsubMenuName, ddlMenuNameForChildMenu.SelectedValue);
        }
    }
    protected void saveChildMenu_Click(object sender, EventArgs e)
    {
        //////for jquery Accordian///////
        hidAccordionIndex.Value = "3";
        //////////////////////////////
        if (ChildMenuValidation()==true)
        {
            ChildMenuSave();
        }
    }
    protected void addPageCheckBoxSubMenu_CheckedChanged(object sender, EventArgs e)
    {
        //////for jquery Accordian///////
        hidAccordionIndex.Value = "2";
        //////////////////////////////
        if (addPageCheckBoxSubMenu.Checked == true)
        {
            divSubMenu.Visible = true;
        }
        else
        {
            divSubMenu.Visible = false;
        }
    }
    
}