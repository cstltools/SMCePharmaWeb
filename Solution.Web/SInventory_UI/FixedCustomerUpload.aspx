<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="FixedCustomerUpload.aspx.cs" Inherits="SInventory_UI_FixedCustomerUpload" %>

<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>
        <table width="100%" class="TableWorkArea">
            <tr>
                <td colspan="6" class="TableHeading">
                    Fixed Customer Data Upload
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
                <td class="TDLeft" width="13%">
                </td>
                <td class="TDRight" width="20%">
                </td>
                <td class="TDLeft" width="13%">
                    Document Upload Date:
                </td>
                <td class="TDRight" width="20%">
                    <asp:TextBox ID="documentDateTextBox" runat="server" CssClass="datepick"></asp:TextBox>
                    <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                        TabIndex="4" ID="imgDate"></asp:ImageButton>
                    <asp:CalendarExtender ID="Date" runat="server" Format="dd-MMM-yyyy" TargetControlID="documentDateTextBox"
                        PopupButtonID="imgDate">
                    </asp:CalendarExtender>
                </td>
                <td class="TDLeft" width="13%">
                    &nbsp;
                </td>
                <td class="TDRight" width="20%">
                </td>
            </tr>
            <tr>
                <td width="13%" class="TDLeft">
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
                <td class="TDLeft" width="13%">
                </td>
                <td class="TDRight" width="20%">
                </td>
                <td class="TDLeft" width="13%">
                    Select File:
                </td>
                <td class="TDRight" width="20%">
                    <asp:FileUpload ID="id_fu" runat="server" ToolTip="Select File To Upload." class="btn" />
                    <asp:Label ID="lbl_up_status" runat="server"></asp:Label>
                    <asp:HiddenField ID="IsFileUploaded" runat="server" />
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
                </td>
                <td width="20%" class="TDRight">
                    <asp:Button ID="Button1" runat="server" class="btn btn-primary" Text="Upload" OnClick="btnUpload_Click" />
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
                    <div id="gridContainer1" style="height: auto; overflow: auto; width: 960px">
                        <asp:GridView ID="loadGridView" runat="server" CssClass="gridview" AutoGenerateColumns="False"
                            OnRowDataBound="loadGridView_RowDataBound">
                            <Columns>
                                <asp:TemplateField HeaderText="#SL">
                                    <ItemTemplate>
                                        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Code" HeaderText="Customer Code" HtmlEncode="False" HtmlEncodeFormatString="False" />
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
                    <asp:Button ID="submitButton" runat="server" CssClass="button-padding-right"  OnClick="submitButton_Click"
                        Text="F C B" OnClientClick="return confirm('Are you sure you want to Save ?');" />
                    <asp:Button ID="Regular" runat="server" CssClass="button-padding-right" OnClick="regularButton_Click" BackColor="#F1A425"
                        Text="Regular" OnClientClick="return confirm('Are you sure you want to Save ?');" />
                    <asp:Button ID="cancelUploadListButton" CssClass="button-padding-right" runat="server" OnClick="cancelUploadListButton_Click" BackColor="#001BFF"
                        Text="Cancel" OnClientClick="return confirm('Are you sure you want to Re-Upload ?');" />
                    <asp:Button ID="refreshButton" runat="server" OnClick="refreshButton_Click" Text="Refresh" />
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
