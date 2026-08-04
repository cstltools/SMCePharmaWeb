<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="AdminMenuPanal.aspx.cs" Inherits="CommonUI_AdminMenuPanal" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script src="../scripts/jquery.min.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.js" type="text/javascript"></script>
    <script src="../scripts/jquery.js" type="text/javascript"></script>
    <link href="../css/jquery-ui.css" rel="stylesheet" type="text/css" />
    
    
    <script type="text/javascript">

        $(document).ready(function() {
            $('#accordion').accordion({
                collapsible: true,
                active: 0,
                autoHeight: false
            });
        });

////On UpdatePanel Refresh
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        if (prm != null) {
            prm.add_endRequest(function (sender, e) {
                if (sender._postBackSettings.panelsToUpdate != null) {

                    $("#accordion").accordion({
                        collapsible: true,
                        active: parseInt(document.getElementById('<%= this.hidAccordionIndex.ClientID %>').value),
                        autoHeight: false

                    });

                }
            });
       };
            
          
        
    </script>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                 <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                           Menu Management Panal
                        </td>
                    </tr>
                   
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                          
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:Label ID="msgLabel" runat="server"></asp:Label>
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    </table>
                     <asp:HiddenField ID="hidAccordionIndex" runat="server" Value="1" />
                <div id="accordion" width="100%">
               
                    
                    <h3>
                        MAIN MENU PANAL</h3>
                    <div>
                        <table width="100%" class="TableWorkArea">
                    <tr>
                        <td width="13%" class="TDLeft">
                            Main Menu Name :</td>
                        <td width="20%" class="TDRight">
                            
                            <asp:TextBox ID="mainMenuNameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            Add Page : Yes ?</td>
                        <td width="20%" class="TDRight">
                            <asp:CheckBox ID="addPageCheckBox" runat="server" AutoPostBack="True" 
                                oncheckedchanged="addPageCheckBox_CheckedChanged" />
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp; </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <div id="divAddpage" runat="server" Visible="False">
                    <tr>
                        <td width="13%" class="TDLeft">
                             Destination Folder :
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="mainMenuDesFolderTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            Page Name :
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="mainMenuPageNameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    </div>
                            <tr>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                                <td class="TDRight" width="20%">
                                    &nbsp;</td>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                                <td class="TDRight" width="20%">
                                    <asp:Button ID="saveMainMenuButton" runat="server" Text="Save" 
                                        onclick="saveMainMenuButton_Click" />
                                </td>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                                <td class="TDRight" width="20%">
                                    &nbsp;</td>
                            </tr>
                    </table>
                    </div>
                    <h3>
                       MENU PANAL</h3>
                    <div>
                         <table width="100%" class="TableWorkArea">
                    <tr>
                        <td width="13%" class="TDLeft">
                            Main Menu :</td>
                        <td width="20%" class="TDRight">
                          
                            <asp:DropDownList ID="ddlMMenuNameMPanal" runat="server" CssClass="DropDown" 
                                >
                            </asp:DropDownList>
                        </td>
                        <td width="13%" class="TDLeft">
                            Menu Name :</td>
                             <td width="20%" class="TDRight">
                          <asp:TextBox ID="menuNameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                           
                            Add Page : Yes ?</td>
                        <td width="20%" class="TDRight">
                         
                            <asp:CheckBox ID="addPageCheckBoxMenu" runat="server" AutoPostBack="True" oncheckedchanged="addPageCheckBoxMenu_CheckedChanged" 
                                />
                        </td>
                    </tr>
                   <div id="divMenu" runat="server" Visible="False">
                    <tr>
                        <td width="13%" class="TDLeft">
                             Destination Folder :
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="menuDisFolderTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            Page Name :
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="menuPageTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    </div>
                             <tr>
                                 <td class="TDLeft" width="13%">
                                     &nbsp;</td>
                                 <td class="TDRight" width="20%">
                                     &nbsp;</td>
                                 <td class="TDLeft" width="13%">
                                     &nbsp;</td>
                                     <td width="20%" class="TDRight">
                           
                                         <asp:Button ID="menuSaveButton" runat="server" onclick="menuSaveButton_Click" 
                                             Text="Save" />
                           
                                      </td>
                                 <td class="TDLeft" width="13%">
                                     &nbsp;</td>
                                 <td class="TDRight" width="20%">
                                     &nbsp;</td>
                             </tr>
                    </table>
                    </div>
                 <h3>
                      SUB MENU PANAL</h3>
                    <div>
                         <table width="100%" class="TableWorkArea">
                    <tr>
                        <td width="13%" class="TDLeft">
                            Main Menu :</td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="ddlSubMMenuNameMPanal" runat="server" CssClass="DropDown" 
                                AutoPostBack="True" 
                                onselectedindexchanged="ddlSubMMenuNameMPanal_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                        <td width="13%" class="TDLeft" colspan="2">
                            Menu Name :</td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="ddlMenuNameForSubMenu" runat="server" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td width="13%" class="TDLeft">
                            Sub Menu Name :</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="subMenuNameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            Add Page : Yes ?</td>
                        <td width="20%" class="TDRight">
                            <asp:CheckBox ID="addPageCheckBoxSubMenu" runat="server" AutoPostBack="True" oncheckedchanged="addPageCheckBoxSubMenu_CheckedChanged" 
                                 />
                        </td>
                        <td width="13%" class="TDLeft" colspan="2">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                     <div id="divSubMenu" runat="server" Visible="False">
                     <tr>
                        <td width="13%" class="TDLeft">
                            Destination Folder :</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="submenuDisFolderTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft" colspan="2">
                            Page Name :</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="submenuPageTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    </div>
                     <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft" colspan="2">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:Button ID="subMenuSaveButton" runat="server" Text="Save" 
                                onclick="subMenuSaveButton_Click" />
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    </table>
                    </div>
                      <h3>
                        CHILD MENU PANAL</h3>
                    <div>
                         <table width="100%" class="TableWorkArea">
                    <tr>
                        <td width="13%" class="TDLeft">
                            Main Menu :</td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="ddlChMMenuNameMPanal" runat="server" CssClass="DropDown" 
                                AutoPostBack="True" 
                                onselectedindexchanged="ddlChMMenuNameMPanal_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                        <td width="13%" class="TDLeft" colspan="2">
                            Menu Name :</td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="ddlMenuNameForChildMenu" runat="server" 
                                CssClass="DropDown" 
                                onselectedindexchanged="ddlMenuNameForChildMenu_SelectedIndexChanged" 
                                AutoPostBack="True">
                            </asp:DropDownList>
                        </td>
                        <td width="13%" class="TDLeft">
                            Sub Menu Name :</td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="ddlsubMenuName" runat="server" CssClass="DropDown" >
                               
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            Child Menu Name :</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="childMenuNameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft" colspan="2">
                            Destination Folder :</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="childDisFolderTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            Page Name :</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="childMenuPageTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft" colspan="2">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:Button ID="saveChildMenu" runat="server" Text="Save" 
                                onclick="saveChildMenu_Click" />
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft" colspan="2">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                   
                    </table>
                    </div>
                        
                     <%-- <h2>
                        Section 5</h2>
                    <div>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft" colspan="2">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft" colspan="2">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    </div>--%>
                </div>
             
            </div>
           
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

