<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="ApiCustomerList.aspx.cs" Inherits="SInventory_UI_ApiCustomerList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <style>
        .divWaiting
        {
            position: absolute;
            z-index: 2147483647 !important;
            opacity: 0.5;
            overflow: hidden;
            text-align: center;
            top: 0;
            left: 0;
            height: 100%;
            width: 100%;
            padding-top: 0px;
        }
    </style>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                           Imported New Customer List</td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            </td>
                        <td width="20%" class="TDRight">
                            <%--<asp:ImageButton ID="cusMasterNewImageButton" runat="server" 
                                ImageUrl="~/images/Add.png" onclick="CustMasterNewImageButton_Click" />--%>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                            Reload</td>
                        <td width="20%" class="TDRight">
                            <asp:ImageButton ID="custMasterReloadImageButton" runat="server" 
                                ImageUrl="~/images/refresh.png" 
                                onclick="CustMasterReloadImageButton_Click" />
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
                <%--    <tr id="Tr1" >
                        <td class="TDLeft" style="text-align: right" width="13%">
                            Customer Code &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="custcodenameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td class="TDLeft" style="text-align: right" width="13%">
                         <asp:Button ID="Button2" runat="server" OnClick="Button1_Click" Text="Search" />
                        </td>
                        <td class="TDRight" width="20%">
                          
                        </td>
                        <td class="TDLeft" style="text-align: right" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%" >
                           
                        </td>
                    </tr>--%>
                    <tr runat="server" Visible="False">
                        <%--<td class="TDLeft" style="text-align: right" width="13%">
                            Customer Code &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="custcodenameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>--%>
                        <td class="TDLeft" style="text-align: right" width="13%">
                            FE Code &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="districtNameDropDownList" runat="server" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td class="TDLeft" style="text-align: right" width="13%">
                            Territory Code &nbsp;
                        </td>
                        <td class="TDRight" width="20%" >
                            <asp:DropDownList ID="areaNameDropDownList" runat="server" 
                                CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr runat="server" Visible="False">
                        <td class="TDLeft" style="text-align: right" width="13%">
                            MIA Code &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="miaNameDropDownList" runat="server"
                                CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td class="TDLeft" style="text-align: right" width="13%">
                            Market Code &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="marketNameDropDownList" runat="server" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td class="TDLeft" style="text-align: right" width="13%">
                            DZSM Code &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            <%--<asp:DropDownList ID="regionNameDropDownList" runat="server"  CssClass="DropDown" ></asp:DropDownList>--%>
                            <asp:DropDownList ID="regionNameDropDownList" runat="server" 
                                AutoPostBack="True" CssClass="DropDown"  Width="165px" >
                           </asp:DropDownList>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                               <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0"
                                DynamicLayout="true">
                                <ProgressTemplate>
                                    <div class="divWaiting">
                                        <asp:Image ID="imgWait" runat="server" ImageAlign="Middle" ImageUrl="~/Images/loading-icon-big.gif"
                                            Height="100%" Width="100%" />
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                    </tr>
                    
           
                    <tr>
                        <td class="TDLeft" colspan="6">
                            <div id="gridContainer1" style="height: 500px; overflow: auto; width: auto">
                                <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" CssClass="gridview"
                                    DataKeyNames="tempCustomerMasterId" OnRowCommand="loadGridView_RowCommand">
                                    <Columns>
                                        <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center Name" />
                                        <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center Code" />
                                        <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                        <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                        <asp:BoundField DataField="Address" HeaderText="Address" />
                                        <asp:BoundField DataField="CellNo" HeaderText="Cell No" /> 
                                        <asp:BoundField DataField="MiaCode" HeaderText="Mio Code" />
                                        <asp:BoundField DataField="MIAName" HeaderText="Mio Name" />
                                        <%--<asp:BoundField DataField="DistrictCode" HeaderText="FE Code" />
                                        <asp:BoundField DataField="AreaCode" HeaderText="Territory Code" />
                                        <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />
                                        <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                        <asp:BoundField DataField="RegionCode" HeaderText="DZSM Code" />--%>

                                        <asp:TemplateField HeaderText="Edit">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="editImageButton" runat="server" CommandArgument="<%# Container.DataItemIndex %>"
                                                    CommandName="EditData" ImageUrl="~/images/edit.png" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Add To Customer">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="addImageButton" runat="server" CommandArgument="<%# Container.DataItemIndex %>"
                                                    CommandName="AddData" ImageUrl="~/images/lineSelect.gif" />
                                            </ItemTemplate>

                                        </asp:TemplateField>
                                     
                                    </Columns>
                                </asp:GridView>
                            </div>
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

