<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="BranchTotalSummary.aspx.cs" Inherits="SInventory_UI_BranchTotalSummary" %>

<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
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
                    
                    
                    
                    <%--  <tr>
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
                    
                    

                    
                    
                    
                    
                      <tr id="divDzsm" runat="server" Visible="False">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            DZSM Name</td>
                        <td width="13%" class="TDLeft">
                            <asp:DropDownList ID="dzsmDropDownList" runat="server" 
                                CssClass="DropDown" >
                            </asp:DropDownList>
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
                        </td>
                        <td width="13%" class="TDLeft">
                            Sales Center
                        </td>
                        <td width="20%" class="TDRight">
                         <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                CssClass="DropDown" >
                            </asp:DropDownList>
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
                            <asp:Button ID="excelButton1" runat="server" Text="Export to Excel(Sales)" OnClick="excelButton1_Click" />
                             <asp:Button ID="proformaButton1" runat="server" Text="Export to Excel(Proforma)" OnClick="excelButton1_Click2" />
                               <asp:Button ID="marketwiseButton" runat="server" Text="Export to Excel(Market wise Proforma Summary)" OnClick="excelButton_Click3" />
                               <asp:Button ID="salesButton" runat="server" Text="Export to Excel(Market wise Sales Summary)" OnClick="excelButton_Click4" />

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
                   
                    <tr >
                        <td width="13%" class="TDLeft" colspan="6" >
                            <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" OnPageIndexChanging="OnPageIndexChanging"
                                CssClass="gridview" >
                                <Columns>
                                    <%--<asp:TemplateField HeaderText="#SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center" />
                                    <asp:BoundField DataField="ShortName" HeaderText="Sales Center Name "  />
                                    
                                    
                                      <asp:BoundField DataField="NumberofOrder" HeaderText="Number of Order"  />
                                        <asp:BoundField DataField="NumberOfOrderValue" HeaderText="Sum of Net Order Amount(TP)"  />
                                    <%-- <asp:BoundField DataField="NumberofProformaInvoice" HeaderText="Number of Proforma Invoice" 
                                ItemStyle-Width="60" DataFormatString="{0:D}"
                                  ItemStyle-HorizontalAlign="Right" >
                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                    </asp:BoundField>--%>
                                    

                                <asp:BoundField DataField="NumberofProformaInvoice" HeaderText="Number of Proforma Invoice" 
                                ItemStyle-Width="60" DataFormatString="{0:D}"
                                  ItemStyle-HorizontalAlign="Right" >
                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                    </asp:BoundField>
                                  <%--  <asp:BoundField DataField="NumberofProformaInvoice" HeaderText="Number of Proforma Invoice" />--%>
                                 
                                    <asp:BoundField DataField="SumofNetProformaAmount" 
                                        HeaderText="Sum of Net Proforma Amount(TP)"  ItemStyle-Width="60" DataFormatString="{0:N2}"
                                  ItemStyle-HorizontalAlign="Right" >
                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                    </asp:BoundField>
                                      <asp:BoundField DataField="ProTpVat" HeaderText="Proforma Total Vat" />
                                      
                                           <asp:BoundField DataField="CustomerCoverPer" HeaderText="Chemist Coverage(%)" />

                                    <asp:BoundField DataField="NumberofInvoiceSold" HeaderText="Number of Invoices Sold" DataFormatString="{0:D}"/>
                                    <asp:BoundField DataField="SumofNetSalesAmount" HeaderText="Sum of Net Sales Amount(TP)" />
                                     <asp:BoundField DataField="DelTpVat" HeaderText="Sales Total Vat" />
                                    <asp:BoundField DataField="NumberofReturnInvoice" HeaderText="Number of Returned Invoices" DataFormatString="{0:D}"/>
                                    <asp:BoundField DataField="SumofNetReturnAmount" HeaderText="Sum of Net Return Amount(TP)" />
                                     <asp:BoundField DataField="DelReTpVat" HeaderText="Return Total Vat" />
                                     
                                     
                                        <asp:BoundField DataField="NumberofUndelInvoice" HeaderText="Number of Undelivered Invoice " />
                                           <asp:BoundField DataField="SumofNetUnAmount" HeaderText="Sum of Net UndeliveredAmount(TP)" />
                                              <asp:BoundField DataField="UnTpVat" HeaderText="Undelivered Total Vat" />
                                   
                                </Columns>
                            </asp:GridView>
                            <br/>  <br/>  <br/>  <br/>  
                        </td>
                    </tr>
                    
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
