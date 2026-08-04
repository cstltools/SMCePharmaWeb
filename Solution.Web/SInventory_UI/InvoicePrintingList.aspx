<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="InvoicePrintingList.aspx.cs" Inherits="SInventory_UI_InvoicePrintingList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Invoice Printing List
                        </td>
                    </tr>
                    <tr>
                <td class="TDLeft" width="13%">
                    &nbsp;</td>
                <td class="TDRight" width="20%">
                    &nbsp;</td>
                <td class="TDLeft" width="13%">
                    DC Name </td>
                <td class="TDRight" width="20%">
                    <asp:DropDownList ID="dcDropDownList" runat="server" CssClass="DropDown">
                    </asp:DropDownList>
                        </td>
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
                        </td>
                        <td width="13%" class="TDLeft">
                            Invoice Date</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="dateTextBox" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgDate"></asp:ImageButton>
                            <asp:CalendarExtender ID="Date" runat="server" Format="dd-MMM-yyyy" TargetControlID="dateTextBox"
                                PopupButtonID="imgDate">
                            </asp:CalendarExtender>
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Button ID="searchButton" runat="server" Text="Search" 
                                onclick="searchButton_Click" />
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
                            Select First &amp; Print</td>
                        <td width="20%" class="TDRight">
                            <asp:Button ID="printButton" runat="server" onclick="printButton_Click" 
                                Text="Print" />
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
                        <td width="20%" class="TDRight" colspan="4">
                            <div id="divForGrid" width="auto" hight="100px" overflow="auto">
                            <asp:GridView ID="reportListGridView" runat="server" CssClass="gridview" 
                                AutoGenerateColumns="False" >
                                <Columns>
                                    <asp:TemplateField HeaderText="Select">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="printCheckBox" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="InvoiceNo" HeaderText="InvoiceNo" />
                                    <asp:BoundField DataField="InvoiceDate" 
                                        HeaderText="InvoiceDate" />
                                    <asp:BoundField DataField="OrderNo" HeaderText="OrderNo" />
                                    <asp:BoundField DataField="OrderDate" HeaderText="OrderDate" />
                                    <asp:BoundField DataField="CustomerCode" HeaderText="CustomerCode" />
                                    <asp:BoundField DataField="CustomerName" 
                                        HeaderText="CustomerName" />
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


