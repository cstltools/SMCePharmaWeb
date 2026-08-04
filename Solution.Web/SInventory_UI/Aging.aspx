<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" EnableEventValidation="false"
    AutoEventWireup="true" CodeFile="Aging.aspx.cs" Inherits="SInventory_UI_Aging" %>

<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<%--    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>--%>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Aging wise receivable report
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
                    
                    
                    
                      <%--<tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            Report Type</td>
                        <td width="13%" class="TDLeft">
                            <asp:DropDownList ID="rptTypeDropDownList" runat="server" runat="server"
                                CssClass="DropDown" 
                                onselectedindexchanged="rptTypeDropDownList_SelectedIndexChanged" >
                                <asp:ListItem Text="Branch Wise" Value="BranchWise"></asp:ListItem>
                                <asp:ListItem Text="DZSM Wise" Value="DZSMWise"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td width="20%" class="TDRight">
                            </td>
                        <td width="13%" class="TDLeft">
                           
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>--%>
                    
                    

                   
                   <tr runat="server" visible="True" id="Tr3">
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" width="13%">
                            	SC  :
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="dcDropDownList2" runat="server" CssClass="DropDown" 
                                
                                >
                            </asp:DropDownList>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                     
                           <tr id="Tr1"  runat="server" Visible="False">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                          </td>
                        <td width="13%" class="TDLeft">
                            Depot Name
                           
                        </td>
                        <td width="20%" class="TDRight">
                           <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                CssClass="DropDown" > </asp:DropDownList>  </td>
                        <td width="13%" class="TDLeft">
                           
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    
                      <tr id="Tr2"  runat="server" Visible="False">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                          </td>
                        <td width="13%" class="TDLeft">
                             Territory Name
                        </td>
                        <td width="20%" class="TDRight">
                             <asp:DropDownList ID="territoryDropDownList" runat="server" 
                                CssClass="DropDown" >
                            </asp:DropDownList> </td>
                        <td width="13%" class="TDLeft">
                           
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
                            From Date
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:CalendarExtender ID="fromDate" runat="server" Format="dd-MMM-yyyy" PopupButtonID="imgDateFrom"
                                TargetControlID="fromDateTextBox">
                            </asp:CalendarExtender>
                            <asp:ImageButton ID="imgDateFrom" runat="server" AlternateText="Click to show calendar"
                                ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="4" />
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
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
                            To Date
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="toDateTextBox" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:CalendarExtender ID="toDate" runat="server" Format="dd-MMM-yyyy" PopupButtonID="imgDateTo"
                                TargetControlID="toDateTextBox">
                            </asp:CalendarExtender>
                            <asp:ImageButton ID="imgDateTo" runat="server" AlternateText="Click to show calendar"
                                ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="4" />
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
                            <asp:Button ID="viewRptButton" runat="server" OnClick="viewRptButton_Click" Text="Search" />
                     <%--    <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0"
                                DynamicLayout="true">
                      <ProgressTemplate>
                                    <div class="divWaiting">
                                        <asp:Image ID="imgWait" runat="server" ImageAlign="Middle" ImageUrl="~/Images/loading-icon-big.gif"
                                            Height="100%" Width="100%" />
                                    </div>
                               </ProgressTemplate>
                            </asp:UpdateProgress>--%>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                            <asp:Button ID="excelButton1" runat="server" Text="Export to Excel" OnClick="btnExportToExcel_Click" />
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
                          <asp:UpdatePanel ID="UpdatePanel2"  runat="server">
                        <ContentTemplate>
                        <td width="13%" class="TDLeft" colspan="6">
                         <div style="overflow-x:auto!important ;width: 1350px!important; overflow-y:auto!important;height: 600px">
                                <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"  OnRowCreated="loadGridView_OnRowCreated"
                                CssClass="gridview" ShowFooter="True" style="overflow-x:auto!important ;width: 500px!important; overflow-y:auto!important;">
                               <Columns>
                                    <%--<asp:TemplateField HeaderText="#SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                 <%--   <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center"  />--%>
                                    <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center"  />
                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code"  />
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name"  />
                                    <asp:BoundField DataField="OrderNo" HeaderText="Order No"  />
                                    <asp:BoundField DataField="OrderDate" HeaderText="Order Date"  />
                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No"  />
                                    <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date"  />
                                     <asp:BoundField DataField="DistrictCode" HeaderText="FE Code"  />
                                    <asp:BoundField DataField="AreaCode" HeaderText="Territory Code"  />
                                      <asp:BoundField DataField="MainMIOCODE" HeaderText="MIO CODE"  />
                                    <asp:BoundField DataField="MainMIONAME" HeaderText="MIO NAME"  />
                             <%--       <asp:BoundField DataField="MiaCode" HeaderText="Mia Code"  />--%>
                                   
                                    <asp:BoundField DataField="MarketCode" HeaderText="Market Code"  />
                                    <asp:BoundField DataField="MarketName" HeaderText="Market Name"  />

                                    <asp:BoundField DataField="IntransitDay" HeaderText="Intransit Day"  />
                                  
                                    <asp:BoundField DataField="SpecialAmount" HeaderText="Type"  />
                                    
                                          <asp:BoundField DataField="DiscountAmount" HeaderText="TP Amount"  />
                                    <asp:BoundField DataField="NetAmount" HeaderText="Net Amount"  />
                                <%--    <asp:BoundField DataField="TotalPriceVatAmount" HeaderText="Total Price Vat Amount"  />--%>
                              
                                  
                                  
                                  
                                    
                                    
                                                    <asp:BoundField DataField="DiscountAmount_2" HeaderText="TP Amount"  />
                                    <asp:BoundField DataField="NetAmount_2" HeaderText="Net Amount"  />
                    <%--                <asp:BoundField DataField="TotalPriceVatAmount_2" HeaderText="Total Price Vat Amount"  />--%>
                         
                                    
                                    
                                                    <asp:BoundField DataField="DiscountAmount_3" HeaderText="TP Amount"  />
                                      <asp:BoundField DataField="NetAmount_3" HeaderText="Net Amount"  />
                           <%--         <asp:BoundField DataField="TotalPriceVatAmount_3" HeaderText="Total Price Vat Amount"  />--%>
                    
                                    
                                    
                                                <asp:BoundField DataField="DiscountAmount_4" HeaderText="TP Amount"  />
                                      <asp:BoundField DataField="NetAmount_4" HeaderText="Net Amount"  />
                                   <%-- <asp:BoundField DataField="TotalPriceVatAmount_4" HeaderText="Total Price Vat Amount"  />--%>
                         
                                    
                                    
                                    
                                          <asp:BoundField DataField="DiscountAmount_5" HeaderText="TP Amount"  />
                                        <asp:BoundField DataField="NetAmount_5" HeaderText="Net Amount"  />
                             <%--       <asp:BoundField DataField="TotalPriceVatAmount_5" HeaderText="Total Price Vat Amount"  />--%>
                              
                                    
                                    
                                           <asp:BoundField DataField="DiscountAmount_6" HeaderText="TP Amount"  />
                                        <asp:BoundField DataField="NetAmount_6" HeaderText="Net Amount"  />
                              <%--      <asp:BoundField DataField="TotalPriceVatAmount_6" HeaderText="Total Price Vat Amount"  />--%>
                                <asp:BoundField DataField="TotalTP" HeaderText="Total TP Amount"  />
                                 <asp:BoundField DataField="TotalNet" HeaderText="Total Net Amount"  />
                                     
                                    <%-- <asp:BoundField DataField="NumberofProformaInvoice" HeaderText="Number of Proforma Invoice" 
                                ItemStyle-Width="60" DataFormatString="{0:D}"
                                  ItemStyle-HorizontalAlign="Right" >
                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                    </asp:BoundField>--%>
                                    

                                <%--<asp:BoundField DataField="NumberofProformaInvoice" HeaderText="No of Invoice" 
                                ItemStyle-Width="60" DataFormatString="{0:D}"
                                  ItemStyle-HorizontalAlign="Right" >
                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="NumberofProformaInvoice" HeaderText="Number of Proforma Invoice" visible="false" />
                                 
                                    <asp:BoundField DataField="SumofNetProformaAmount" 
                                        HeaderText="Amount (TP)"  ItemStyle-Width="60" 
                                  ItemStyle-HorizontalAlign="Right" >
                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                    </asp:BoundField>
                                      <asp:BoundField DataField="ProTpVat" HeaderText="VAT" />
                                       <asp:BoundField DataField="NetInvoiceAmt" HeaderText="Gross Invoice Amt"  />


                                       <asp:BoundField DataField="NumberofReturnInvoice" HeaderText="Number of Returned Invoices" DataFormatString="{0:D}" visible="false"/>
                                    <asp:BoundField DataField="SumofNetReturnAmount" HeaderText="Amount (TP)"  />
                                     <asp:BoundField DataField="DelReTpVat" HeaderText="VAT" />
                                       <asp:BoundField DataField="NetReturnAmt" HeaderText="Gross Return Amt" />

                                         <asp:BoundField DataField="salesTP" HeaderText="Amount (TP)" />
                                     <asp:BoundField DataField="SalesVat" HeaderText="VAT" />
                                       <asp:BoundField DataField="SalesTotal" HeaderText="Gross Sales Amt" />

                                    <asp:BoundField DataField="NumberofInvoiceSold" HeaderText="Number of Invoices Sold" DataFormatString="{0:D}" visible="false"/>
                                    <asp:BoundField DataField="SumofNetSalesAmount" HeaderText="Amount (TP)" />
                                     <asp:BoundField DataField="DelTpVat" HeaderText="VAT" />
                                       <asp:BoundField DataField="NetSalesAmt" HeaderText="Gross Collection" />

                                          <asp:BoundField DataField="NumberofInvoiceSold" HeaderText="Number of Invoices Sold"  visible="false"/>
                                    <asp:BoundField DataField="Outstanding1" HeaderText="Amount (TP)" />
                                     <asp:BoundField DataField="Outstanding2" HeaderText="VAT" />
                                       <asp:BoundField DataField="Outstanding3" HeaderText="Gross Outstanding Amt." />--%>

                                </Columns>
                            </asp:GridView>
                         </div>
                            <br/>  <br/>  <br/>  <br/>  
                        </td>
                            </ContentTemplate>
                    </asp:UpdatePanel>
                    </tr>
                </table>
            </div>
    <%--    </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>
