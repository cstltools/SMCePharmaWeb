<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="CustomerTagChangeList.aspx.cs" Inherits="SInventory_UI_CustomerList" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Customer Tag Change Upload List</td>
                    </tr>
                     <tr>
                <td width="13%" class="TDLeft">
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
                <td width="13%" class="TDLeft">
                    &nbsp;
                </td>
                <td width="20%" class="TDRight">
                    &nbsp;
                </td>
            </tr>
                    <tr>
                <td class="TDLeft" width="13%">
                </td>
                <td class="TDRight" width="20%">
                </td>
                <td class="TDLeft" width="13%">
                    Manufacturer:
                </td>
                <td class="TDRight" width="20%">
                    <asp:DropDownList ID="manufacturerDropDownList" runat="server" CssClass="radioButtonList">
                    </asp:DropDownList>
                </td>
                <td class="TDLeft" width="13%">
                    &nbsp;
                </td>
                <td class="TDRight" width="20%">
                </td>
            </tr>
                <tr>
                    <td class="TDLeft" width="13%">
                        &nbsp;</td>
                    <td class="TDRight" width="20%">
                        &nbsp;</td>
                    <td class="TDLeft" width="13%">
                        &nbsp;</td>
                    <td class="TDRight" width="20%">
                        &nbsp;</td>
                    <td class="TDLeft" width="13%">
                        &nbsp;</td>
                    <td class="TDRight" width="20%">
                        &nbsp;</td>
                </tr>
             <tr>
                <td width="13%" class="TDLeft">
                    &nbsp;
                </td>
                <td width="20%" class="TDRight">
                    &nbsp;
                </td>
                <td width="13%" class="TDLeft">
                    &nbsp;
                </td>
                <td width="20%" class="TDRight">
                    <asp:Button ID="submitButton" runat="server"  Text="Search" 
                        onclick="submitButton_Click"   />
                     <asp:Button ID="refreshButton" runat="server" OnClick="refreshButton_Click" Text="Refresh" />
                    <%--OnClick="searchButton_Click"--%>
                </td>
                <td width="13%" class="TDLeft">
                    &nbsp;</td>
                <td width="20%" class="TDRight">
                    &nbsp;
                </td>
            </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft"></td>

                        <td width="20%" class="TDRight" colspan="4">
                            <div id ="gridContainer1" style ="height:400px;overflow:auto;width:auto ">
                             <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                CssClass="gridview" DataKeyNames="CustomerTagChangeExcelFileMasterID" 
                                onrowcommand="loadGridView_RowCommand" >
                                <Columns>
                                     <asp:TemplateField HeaderText="#SL">
                                <ItemTemplate>
                                    <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                                    <asp:BoundField DataField="ManufacName" HeaderText="Manufacture Name" />
                                    <asp:BoundField DataField="CustomerTagChangeExcelFileDocumentDate" HeaderText="Document Upload Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <%--<asp:BoundField DataField="Transfer" HeaderText="Transfer to Customer Master" />--%>
                                    <asp:BoundField DataField="EntryBy" HeaderText="Entry By" />
                                    <asp:BoundField DataField="EntryDate" HeaderText="Entry Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <%-- <asp:TemplateField HeaderText="View Detail">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="viewImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="ViewData" 
                                                ImageUrl="~/images/viewlists.png" />
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                    <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="DeleteData" 
                                              OnClientClick="return confirm('Are you sure you want to Delete ?');"  ImageUrl="~/images/lineDelete.png" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Verify">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ImageButton1" runat="server" CommandArgument="<%# Container.DataItemIndex %>" CommandName="VerifyData" 
                                                             ImageUrl="~/images/viewlists.png" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Verified">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="verifiedLinkButton" runat="server" 
                                                onclick="verifiedLinkButton_Click" ></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Unverified">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="unverifiedLinkButton" runat="server" OnClick="unverifiedLinkButton_OnClick" ></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                     <asp:TemplateField HeaderText="Update Customer">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="transferImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="TransferData" 
                                               OnClientClick="return confirm('Are you sure you want to Update ?');"   ImageUrl="~/images/Transfer.png" onclick="transferImageButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                          </div>
                        </td>
                        <td width="20%" class="TDRight">
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
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
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
                        <td width="13%" class="TDLeft" >
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
        </ContentTemplate>
    </asp:UpdatePanel>


</asp:Content>

