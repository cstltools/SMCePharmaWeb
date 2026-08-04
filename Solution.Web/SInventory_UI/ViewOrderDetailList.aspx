<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="ViewOrderDetailList.aspx.cs" Inherits="SInventory_UI_ViewOrderDetailList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div>
        <table width="100%" class="TableWorkArea">
            <tr>
                <td colspan="6" class="TableHeading">
                    Order List 
                </td>
            </tr>
           
          
           
           
            <tr>
                <td class="TDLeft" width="13%">
                </td>
                <td class="TDRight" width="20%">
                    
                </td>
                <td class="TDLeft" width="13%">
                    <asp:HyperLink ID="HyperLink1" runat="server" 
                        NavigateUrl="~/SInventory_UI/OrderList.aspx">Back to List</asp:HyperLink>
                    <asp:HiddenField ID="userIdHiddenField" runat="server" />
                </td>
                <td class="TDRight" width="20%">
                   
                </td>
                <td class="TDLeft" width="13%">
                    &nbsp;
                </td>
                <td class="TDRight" width="20%">
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
                </td>
                <td width="100%" class="TDRight" colspan="4">
                     <div id ="gridContainer1" style ="height:400px;overflow:auto;width:960px ">
                    <asp:GridView ID="loadGridView" runat="server" CssClass="gridview" AutoGenerateColumns="False">
                        <Columns>
                            <asp:TemplateField HeaderText="#SL">
                                <ItemTemplate>
                                    <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:BoundField DataField="SalesCentre" HeaderText="Sales Centre" />
                            <asp:BoundField DataField="SalesCentreName" HeaderText="Name" />
                            <asp:BoundField DataField="MIOName" HeaderText="MIO" />
                            <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />
                            <asp:BoundField DataField="FECode" HeaderText="FE Code" />
                            <asp:BoundField DataField="DZSMCode" HeaderText="DZSM Code" />
                            <asp:BoundField DataField="CustomerID" HeaderText="CustomerID" />
                            <asp:BoundField DataField="CustomerName" HeaderText="CustomerName" />
                            <asp:BoundField DataField="ProductCode" HeaderText="ProductCode" />
                            <asp:BoundField DataField="ProductName" HeaderText="ProductName" />
                            <asp:BoundField DataField="OrderQty" HeaderText="OrderQty" />
                            <asp:BoundField DataField="GrossValue" HeaderText="GrossValue" />
                             <asp:BoundField DataField="OrderCode" HeaderText="Order Code" />
                            <asp:BoundField DataField="SubmissionDate" HeaderText="SubmissionDate " DataFormatString="{0:dd-MMM-yyyy}"/>
                        </Columns>
                    </asp:GridView>
                    </div>
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
                <td width="13%" class="TDLeft">
                    &nbsp;
                </td>
                <td width="20%" class="TDRight">
                   
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
                    &nbsp;
                </td>
                <td class="TDRight" width="20%">
                    &nbsp;
                </td>
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
                    &nbsp;
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
                    &nbsp;
                </td>
                <td class="TDLeft" width="13%">
                    &nbsp;
                </td>
                <td class="TDRight" width="20%">
                    &nbsp;
                </td>
            </tr>
        </table>
    </div>
</asp:Content>

