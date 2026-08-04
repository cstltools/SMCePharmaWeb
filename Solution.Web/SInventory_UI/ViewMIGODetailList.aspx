<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="ViewMIGODetailList.aspx.cs" Inherits="SInventory_UI_ViewMIGODetailList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div>
        <table width="100%" class="TableWorkArea">
            <tr>
                <td colspan="6" class="TableHeading">
                    MIGO Detail List
                </td>
            </tr>
            
            <tr>
                <td width="13%" class="TDLeft">
                    &nbsp;
                </td>
                <td width="20%" class="TDRight">
                     <asp:HyperLink ID="HyperLink1" runat="server" 
                        NavigateUrl="~/SInventory_UI/MIGOList.aspx">Back to List</asp:HyperLink>
                    <asp:HiddenField ID="userIdHiddenField" runat="server" />
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
                            <asp:BoundField DataField="ShipToParty" HeaderText="ShipToParty" />
                            <asp:BoundField DataField="PONo" HeaderText="PO.No" />
                            <asp:BoundField DataField="PODate" HeaderText="PO.Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                            <asp:BoundField DataField="ItemNo" HeaderText="ItemNo" />
                            <asp:BoundField DataField="OrderDocNo" HeaderText="OrderDocNo" />
                            <asp:BoundField DataField="OrderDocDate" HeaderText="OrderDocDate" DataFormatString="{0:dd-MMM-yyyy}"/>
                            <asp:BoundField DataField="DeliveryDocNo" HeaderText="DeliveryDocNo" />
                            <asp:BoundField DataField="DeliveryDocDate" HeaderText="DeliveryDocDate" DataFormatString="{0:dd-MMM-yyyy}"/>
                            <asp:BoundField DataField="LMID" HeaderText="LMID" />
                            <asp:BoundField DataField="LMIDDescription" HeaderText="LMIDDescription" />
                            <asp:BoundField DataField="Batch" HeaderText="Batch" />
                            <asp:BoundField DataField="ExpDate" HeaderText="ExpDate" DataFormatString="{0:dd-MMM-yyyy}"/>
                            <asp:BoundField DataField="MfgDate" HeaderText="MfgDate" DataFormatString="{0:dd-MMM-yyyy}"/>
                            <asp:BoundField DataField="Qty" HeaderText="Qty" />
                            <asp:BoundField DataField="VATChallan" HeaderText="VATChallan" />
                            <asp:BoundField DataField="BilltoParty" HeaderText="BilltoParty" />
                            <asp:BoundField DataField="InvoiceNo" HeaderText="InvoiceNo" />
                            <asp:BoundField DataField="InvoiceDate" HeaderText="InvoiceDate" DataFormatString="{0:dd-MMM-yyyy}"/>
                            <asp:BoundField DataField="CaseNoofShipper" HeaderText="CaseNoofShipper" />
                            <asp:BoundField DataField="VAT" HeaderText="VAT" />
                            <asp:BoundField DataField="Amount" HeaderText="Amount" />
                            <asp:BoundField DataField="Total" HeaderText="Total" />
                            <asp:BoundField DataField="TransportNo" HeaderText="TransportNo" />
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

