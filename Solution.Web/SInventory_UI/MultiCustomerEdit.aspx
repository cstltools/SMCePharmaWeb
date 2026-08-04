<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="MultiCustomerEdit.aspx.cs" Inherits="SInventory_UI_MultiCustomerEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Multiple Customer Edit</td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
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
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
				Search By
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
				Replace By
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
                        Distribution Center</td>
                    <td width="13%" class="TDLeft">
                        <asp:DropDownList ID="comUnitNameDropDownList" runat="server" 
                                          AutoPostBack="True" CssClass="DropDown" 
                        >
                        </asp:DropDownList>
                    </td>
                    <td width="20%" class="TDRight">
                        &nbsp; Distribution Center</td>
                    <td width="13%" class="TDLeft">
                        <asp:DropDownList ID="comUnitNameDropDownList0" runat="server" 
                                          AutoPostBack="True" CssClass="DropDown">
                        </asp:DropDownList>
                    </td>
                    <td width="20%" class="TDRight">
                    </td>
                </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            DZSM&nbsp; Name&nbsp;</td>
                        <td width="13%" class="TDLeft">
                            <asp:DropDownList ID="regionNameDropDownList" runat="server" 
                                AutoPostBack="True" CssClass="DropDown" 
                                >
                            </asp:DropDownList>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;&nbsp;DZSM&nbsp; Name&nbsp;</td>
                        <td width="13%" class="TDLeft">
                            <asp:DropDownList ID="regionNameDropDownList0" runat="server" 
                                AutoPostBack="True" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            FE Name</td>
                        <td width="13%" class="TDLeft">
                            <asp:DropDownList ID="districtNameDropDownList" runat="server" 
                                AutoPostBack="True" CssClass="DropDown" 
                                >
                            </asp:DropDownList>
                        </td>
                        <td width="20%" class="TDRight">
                             &nbsp;FE Name&nbsp;</td>
                        <td width="13%" class="TDLeft">
                            <asp:DropDownList ID="districtNameDropDownList0" runat="server" 
                                AutoPostBack="True" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            
                        </td>
                        <td width="20%" class="TDRight">
                            Territory Name</td>
                        <td width="13%" class="TDLeft">
                            <asp:DropDownList ID="areaNameDropDownList" runat="server" AutoPostBack="True" 
                                CssClass="DropDown" 
                                >
                            </asp:DropDownList>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp; Territory Name</td>
                        <td width="13%" class="TDLeft">
                            <asp:DropDownList ID="areaNameDropDownList0" runat="server" AutoPostBack="True" 
                                CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr runat="server" Visible="False">
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            MIO Name</td>
                        <td width="13%" class="TDLeft" >
                            <asp:DropDownList ID="miaNameDropDownList" runat="server" AutoPostBack="True" 
                                CssClass="DropDown" 
                                >
                            </asp:DropDownList>
                        </td>
                         <td width="20%" class="TDRight">
                             &nbsp;&nbsp; MIO Name</td>
                        <td width="13%" class="TDLeft">
                            <asp:DropDownList ID="miaNameDropDownList0" runat="server" AutoPostBack="True" 
                                CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            Market Name&nbsp;</td>
                        <td class="TDLeft" width="13%">
                            <asp:DropDownList ID="marketNameDropDownList" runat="server" 
                                AutoPostBack="True" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp; &nbsp;Market Name&nbsp;</td>
                        <td class="TDLeft" width="13%">
                            <asp:DropDownList ID="marketNameDropDownList0" runat="server" 
                                AutoPostBack="True" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr runat="server" Visible="False">
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                           Category Name&nbsp;</td>
                        <td class="TDLeft" width="13%">
                            <asp:DropDownList ID="categoryNameDropDownList" runat="server" 
                                AutoPostBack="True" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp; &nbsp;Category Name&nbsp;</td>
                        <td class="TDLeft" width="13%">
                            <asp:DropDownList ID="categoryNameDropDownList0" runat="server" 
                                AutoPostBack="True" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
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
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            <%--<asp:Button ID="searchButton" runat="server" onclick="searchButton_Click" 
                                        Text="Search" />--%>
                            <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                <ContentTemplate>
                            <asp:Button ID="searchButton" runat="server" onclick="searchButton_Click" 
                                Text="Search" />
                                </ContentTemplate>
                                 </asp:UpdatePanel>
                            <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="UpdatePanel3"
                                DisplayAfter="0" DynamicLayout="true">
                                <ProgressTemplate>
                                    <center>
                                        <asp:Image ID="Img21" runat="server" ImageUrl="~/Images/ajax-loader.gif" />
                                    </center>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                           
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                 <ContentTemplate>
                            <asp:Button ID="replaceButton" runat="server" onclick="replaceButton_Click1" 
                                Text="Replace" />
                                </ContentTemplate>
                                 </asp:UpdatePanel>
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel2"
                                DisplayAfter="0" DynamicLayout="true">
                                <ProgressTemplate>
                                    <center>
                                        <asp:Image ID="Img2" runat="server" ImageUrl="~/Images/ajax-loader.gif" />
                                    </center>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            </td>
                        <td class="TDRight" colspan="4">
                            <asp:GridView ID="loadGridView" runat="server" 
                                AutoGenerateColumns="False" CssClass="gridview" DataKeyNames="CustomerMasterId" 
                                >
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" 
                                                oncheckedchanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                    <asp:BoundField DataField="Address" HeaderText="Address" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="Branch" />
                                    <asp:BoundField DataField="MarketName" HeaderText="Shipping Point" />
                                    <asp:BoundField DataField="AreaName" HeaderText="Territory" />
                                    <asp:BoundField DataField="DistrictName" HeaderText="FE" />
                                    <asp:BoundField DataField="RegionName" HeaderText="DZSM" />
                                </Columns>
                            </asp:GridView>
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
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
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="Label1" runat="server" Text="Not Updated :"></asp:Label>
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="Label2" runat="server" ></asp:Label>
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
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>

