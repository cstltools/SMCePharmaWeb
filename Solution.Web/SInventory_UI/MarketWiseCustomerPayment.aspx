<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="MarketWiseCustomerPayment.aspx.cs" Inherits="SInventory_UI_CustomerPayment" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
                           Market Wise Customer Payment</td>
                    </tr>
               
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            Sales Center</td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                AutoPostBack="True" CssClass="DropDown" 
                                onselectedindexchanged="salesCenterDropDownList_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                         <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0"
                                DynamicLayout="true">
                                <ProgressTemplate>
                                    <div class="divWaiting">
                                        <asp:Image ID="imgWait" runat="server" ImageAlign="Middle" ImageUrl="~/Images/loading-icon-big.gif"
                                            Height="100%" Width="100%" />
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress></td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            Market</td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="marketDropDownList" runat="server" AutoPostBack="True" 
                                CssClass="DropDown" 
                                onselectedindexchanged="marketDropDownList_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                      <tr  id="DivCust123456" runat="server" Visible="False">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            Customer</td>
                        <td width="20%" class="TDRight">
                           <asp:TextBox ID="customerTextBox" runat="server" CssClass="TextBox" 
                                AutoPostBack="True" ontextchanged="customerTextBox_TextChanged"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr id="DivCust" runat="server" Visible="False">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            Customer</td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="customerDropDownList" runat="server" AutoPostBack="True" 
                                CssClass="DropDown" 
                                onselectedindexchanged="customerDropDownList_SelectedIndexChanged">
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
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            Payment Date</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="paymentDtTextBox" runat="server" AutoPostBack="True" ReadOnly="True"
                                CssClass="TextBoxCalander"></asp:TextBox>
                         <%--   <asp:CalendarExtender ID="paymentDtTextBox_CalendarExtender" runat="server" 
                                Format="dd-MMM-yyyy" PopupButtonID="ImageButton" 
                                TargetControlID="paymentDtTextBox">
                            </asp:CalendarExtender>
                            <asp:ImageButton ID="ImageButton" runat="server" 
                                AlternateText="Click to show calendar" 
                                ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="4" />--%>
                            
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
                            Payment Amount</td>
                         <td width="20%" class="TDRight">
                             <asp:TextBox ID="paymentAmountTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                              <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderunitValue" runat="server"
                                                                                        Enabled="True" TargetControlID="paymentAmountTextBox" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>
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
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Payment Type</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="payTypeDDL" runat="server" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
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
                            Ref No</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="refNameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr runat="server" Visible="False">
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Ref Date</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="refDtTextBox" runat="server" AutoPostBack="True" 
                                CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:CalendarExtender ID="paymentDtTextBox_CalendarExtender0" runat="server" 
                                Format="dd-MMM-yyyy" PopupButtonID="ImageButton0" 
                                TargetControlID="refDtTextBox">
                            </asp:CalendarExtender>
                            <asp:ImageButton ID="ImageButton0" runat="server" 
                                AlternateText="Click to show calendar" 
                                ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="4" />
                        </td>
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
                    <tr>
                        <td class="TDLeft" width="13%" colspan="6">
                            <asp:GridView ID="orderGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="InvoiceId,CustomerMasterId,MarketId">
                                <Columns>
                                    <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" 
                                                    oncheckedchanged="chkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" AutoPostBack="True" runat="server" OnCheckedChanged="chkSelect_OnCheckedChanged" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Pro.Invoice No" />
                                    <asp:BoundField DataField="InvoiceDate" HeaderText="Pro.Invoice Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="DelivaryInvoiceNo" HeaderText="Del Invoice No" />
                                    <asp:BoundField DataField="UpdateDate" HeaderText="Del Invoice Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="DeliveryTpGrandTotal" HeaderText="Del Inv Amount" HtmlEncodeFormatString="False"/>
                                     <asp:BoundField DataField="PaymentAmount" HeaderText="Previous Pay"  HtmlEncodeFormatString="False"/>
                                     <asp:BoundField DataField="Due" HeaderText="Due Amount" />
                                       <asp:BoundField DataField="AjAmt" HeaderText="Adjust Amount" />
                                    <asp:TemplateField HeaderText="Pay Amount">
                                        <ItemTemplate>
                                            <asp:TextBox ID="payAmountTextBox" runat="server" AutoPostBack="True" Text= <%# Eval("Due")%> 
                                                ontextchanged="payAmountTextBox_TextChanged"></asp:TextBox>
                                                 <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderunitValue" runat="server"
                                                                                        Enabled="True" TargetControlID="payAmountTextBox" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
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
                             <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                <ContentTemplate>
                            <asp:Button ID="saveButton" runat="server" Text="Save"  OnClientClick="return confirm('Are you sure you want to Save ?');"
                                onclick="saveButton_Click" />
                                </ContentTemplate>
                        </asp:UpdatePanel>
                            <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="UpdatePanel3"
                                DisplayAfter="0" DynamicLayout="true">
                                <ProgressTemplate>
                                    <center>
                                        <asp:Image ID="Img2" runat="server" ImageUrl="~/Images/ajax-loader.gif" />
                                    </center>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
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

