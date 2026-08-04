<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" EnableEventValidation="false"
    AutoEventWireup="true" CodeFile="Copy of TotalSummaryNew.aspx.cs" Inherits="SInventory_UI_TotalSummaryNew" %>

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
                            Business Summary
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
                    
                     <tr id="divSalsesCenter"  runat="server" Visible="true">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                          </td>
                        <td width="13%" class="TDLeft">
                            Zone Name
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="zoneDropDownList" runat="server" 
                                CssClass="DropDown" AutoPostBack="True"
                                onselectedindexchanged="zoneDropDownList_SelectedIndexChanged" >
                            </asp:DropDownList>  </td>
                        <td width="13%" class="TDLeft">
                           
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                           <tr id="Tr1"  runat="server" Visible="true">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                          </td>
                        <td width="13%" class="TDLeft">
                            Depot Name
                           
                        </td>
                        <td width="20%" class="TDRight">
                           <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                CssClass="DropDown" AutoPostBack="True"
                                onselectedindexchanged="salesCenterDropDownList_SelectedIndexChanged" > </asp:DropDownList>  </td>
                        <td width="13%" class="TDLeft">
                           
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    
                      <tr id="Tr2"  runat="server" Visible="true">
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
                            <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" OnPageIndexChanging="OnPageIndexChanging" OnRowCreated="loadGridView_OnRowCreated"
                                CssClass="gridview" ShowFooter="True">
                                <Columns>
                                
                                    <asp:BoundField DataField="ProductCode" HeaderText="Code"  />
                                     <asp:BoundField DataField="ProductName" HeaderText="Product Name"  />
                             
                                   <asp:BoundField DataField="NumberofProformaInvoice" HeaderText="Quantity" DataFormatString="{0:F0}"/>
                                    <asp:BoundField DataField="SumofNetProformaAmount" 
                                        HeaderText="Amount (TP)"  ItemStyle-Width="60" DataFormatString="{0:F0}"
                                  ItemStyle-HorizontalAlign="Right" >
                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                    </asp:BoundField>
                                      <asp:BoundField DataField="ProTpVat" HeaderText="VAT" DataFormatString="{0:F0}"/>
                                       <asp:BoundField DataField="GrossProforma" HeaderText="Gross Invoice Amt" DataFormatString="{0:F0}" />



                                       <asp:BoundField DataField="RetQty" HeaderText="Quantity" DataFormatString="{0:F0}"/>
                                            <asp:BoundField DataField="SumofNetReturnAmount" HeaderText="Amount (TP)" DataFormatString="{0:F0}"/>
                                     <asp:BoundField DataField="DelReTpVat" HeaderText="VAT" DataFormatString="{0:F0}"/>
                                       <asp:BoundField DataField="GrossRetuen" HeaderText="Gross Return Amt" DataFormatString="{0:F0}"/>


                                  
                                         <asp:BoundField DataField="NumberofInvoiceSold" HeaderText="Quantity" DataFormatString="{0:F0}"/>
                                    <asp:BoundField DataField="SumofNetSalesAmount" HeaderText="Amount (TP)" DataFormatString="{0:F0}" />
                                     <asp:BoundField DataField="DelTpVat" HeaderText="VAT" DataFormatString="{0:F0}"/>
                                       <asp:BoundField DataField="GrossSales" HeaderText="Gross Sales Amt" DataFormatString="{0:F0}"/>
                                        <asp:BoundField DataField="TotalDiscountAmount" HeaderText="Sales Discount" DataFormatString="{0:F0}"/>




                                        

                                    
                                    
                                    <asp:BoundField DataField="SumofNetSalesAmountCollection" HeaderText="Amount (TP)" DataFormatString="{0:F0}" />
                                     <asp:BoundField DataField="DelTpVatCollection" HeaderText="VAT" DataFormatString="{0:F0}"/>
                                       <asp:BoundField DataField="GrossSalesCollection" HeaderText="Gross Collection" DataFormatString="{0:F0}"/>
                             
                             <%--     <asp:BoundField DataField="GrossSalesCollection" HeaderText="Gross Collection" DataFormatString="{0:F0}"/>--%>
                                </Columns>
                            </asp:GridView>
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
