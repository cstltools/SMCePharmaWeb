<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="Testing_OrderStatus.aspx.cs" Inherits="SInventory_UI_Testing_OrderStatus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Order Status
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            <td width="13%" class="TDLeft">
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
                        <td width="20%" style="text-align: right;" class="TDRight">
                            Order No: &nbsp;
                        </td>
                        <td width="13%"  class="TDLeft">
                             <asp:TextBox ID="orderNoTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
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
                        <td width="13%" class="TDLeft">
                            &nbsp;
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
                            <asp:Button ID="searchButton" runat="server" OnClick="searchButton_OnClick" Text="Search" />
                        </td>
                        <td class="TDRight" width="20%">
                            
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" style=" font-size: 15px; font-weight: bold; " class="TDRight">
                            MIO Order:
                        </td>
                        <td width="13%" class="TDLeft">
                            
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
                        <td width="13%" class="TDLeft">
                            &nbsp;
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
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%"  class="TDRight">
                            Sales Center Code: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="salesCenterCodeTextBox" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%"  class="TDRight">
                            MIO Code: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="mioCodeTextBox" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%"  class="TDRight">
                            Sales Center Name: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="salesCenterNameTextBox" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%"  class="TDRight">
                            MIO Name: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="mioNameTextBox" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight"  width="20%">
                            Customer Code: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="customerCodeTextBox" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight"  width="20%">
                            Gross Value: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="grossValueTextBox" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%"  class="TDRight">
                            Customer Name: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="CustomerNameTextBox" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="10%"  class="TDRight">
                            Submission Date:&nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="submissionDateTextBox" runat="server" Text=""></asp:Label>
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
                        <td width="16%" class="TDLeft">
                        </td>
                        <td width="43%" class="TDRight"colspan="4">
                            <asp:GridView ID="loadGridView" runat="server" CssClass="gridview" AutoGenerateColumns="False"
                                DataKeyNames="OrderDetailId">
                                <Columns>
                                    <asp:BoundField DataField="Productcode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="OrderQty" HeaderText="Quantity" />
                                    <asp:BoundField DataField="GrossValue" HeaderText="Trade Price" />
                                    <asp:BoundField DataField="UnitVatAmount" HeaderText="UnitVatAmount" />
                                    <asp:BoundField DataField="TotalVatAmount" HeaderText="TotalVatAmount" />

                                    <asp:BoundField DataField="DiscountPercent" HeaderText="DisPercent" />
                                    <asp:BoundField DataField="DisAmt" HeaderText="DisAmount" />
                                    
                                         <asp:BoundField DataField="NetAmount" HeaderText="NetAmount" />
                                                <asp:BoundField DataField="CampaignName" HeaderText="Campaign" />
                                </Columns>
                            </asp:GridView>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
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
                    
                    <div runat="server" Visible="False" />
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" style=" font-size: 15px; font-weight: bold; " class="TDRight">
                            Proforma Information:
                        </td>
                        <td width="13%" class="TDLeft">
                            
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
                        <td class="TDLeft" style="color: red; font-size: 14px;" width="13%">
                           <asp:Label ID="proformaMessageLabel" runat="server" Text=""></asp:Label> &nbsp;
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
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%"  class="TDRight">
                            Invoice Number: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="invoiceNumberLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%"  class="TDRight">
                           Invoice Date: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="invoiceDateLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%"  class="TDRight">
                            TP Total: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="tpTotalLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%"  class="TDRight">
                            TP Discount: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="tpDiscountLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight"  width="20%">
                            TP VAT: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="tpVatLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight"  width="20%">
                            TP Grand Total: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="tpGrandTotalLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight" width="20%">
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
                        <td width="16%" class="TDLeft">
                        </td>
                        <td width="43%" class="TDRight"colspan="4">
                            <asp:GridView ID="proformaGridView" runat="server" CssClass="gridview" AutoGenerateColumns="False"
                                DataKeyNames="InvoiceDetailId">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="TotalPrice" HeaderText="Total Price" />
                                    <asp:BoundField DataField="TotalPriceVatAmount" HeaderText="Total Price Vat Amount" />
                                    <asp:BoundField DataField="DiscountPercentage" HeaderText="Discount Percentage" />
                                    <asp:BoundField DataField="NetAmount" HeaderText="Net Amount" />
                                </Columns>
                            </asp:GridView>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
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
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" style=" font-size: 15px; font-weight: bold; " class="TDRight">
                            Delivery Information:
                        </td>
                        <td width="13%" class="TDLeft">
                            
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
                        <td class="TDLeft" style="color: red; font-size: 10px;" width="13%">
                           <asp:Label ID="deliveryInvoiceMsgLabel" ForeColor="red" runat="server" Text=""></asp:Label> &nbsp;
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
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%"  class="TDRight">
                            Delivery Invoice Number: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="deliveryInvoiceNumberLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%"  class="TDRight">
                           Delivery TP Total: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="deliveryTPTotalLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%"  class="TDRight">
                            Delivery TP Discount: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="deliveryTPDiscountLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%"  class="TDRight">
                            Delivery TP VAT: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="deliveryTPVATLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight"  width="20%">
                           Delivery TP Grand Total: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="deliveryTPGrandTotalLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight"  width="20%">
                           Delivery Status: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="deliveryStatusLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight" width="20%">
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
                        <td width="16%" class="TDLeft">
                        </td>
                        <td width="43%" class="TDRight"colspan="4">
                            <asp:GridView ID="deliveryGridView" runat="server" CssClass="gridview" AutoGenerateColumns="False"
                                DataKeyNames="InvoiceDetailId">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="DeliveryTotalPrice" HeaderText="Total Price" />
                                    <asp:BoundField DataField="DeliveryTotalPriceVatAmount" HeaderText="Total Price Vat Amount" />
                                    <asp:BoundField DataField="DeliveryDiscountPercentage" HeaderText="Discount Percentage" />
                                    <asp:BoundField DataField="DeliveryNetAmount" HeaderText="Net Amount" />
                                </Columns>
                            </asp:GridView>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
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
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" style=" font-size: 15px; font-weight: bold; " class="TDRight">
                            Payment Status:
                        </td>
                        <td width="13%" class="TDLeft">
                            
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
                        <td class="TDLeft" style="color: red; font-size: 10px;" width="13%">
                           <asp:Label ID="paymentMsgLabel" ForeColor="red" runat="server" Text=""></asp:Label> &nbsp;
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
                        </td>
                        <td class="TDRight"  width="20%">
                           Payment Amount: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="paymentAmountLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight"  width="20%">
                           Payment Status: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="paymentStatusLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight" width="20%">
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
                        <div/>
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
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
