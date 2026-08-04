<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WarehouseStockInEdit.aspx.cs"
    Inherits="SInventory_UI_WarehouseStockInEdit" %>

<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Edit</title>
    <link href="../css/custom.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../css/style.css" type="text/css">
    <link rel="stylesheet" href="../css/colors/blue.css" id="colors" type="text/css">
    <link href="../css/GV.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
            <ContentTemplate>
                <div>
                    <table width="100%" class="TableWorkArea">
                        <tr>
                            <td colspan="6" class="TableHeading">
                                Warehouse Stock In Edit
                            </td>
                        </tr>
                        <tr>
                            <td width="13%" class="TDLeft">
                                &nbsp;
                            </td>
                            <td width="20%" class="TDRight">
                            </td>
                            <td width="13%" class="TDLeft">
                            </td>
                            <td width="20%" style="text-align: right; padding-right: 10px;" class="TDRight">
                                <%--<asp:LinkButton ID="viewLinkButton" CssClass="btn buttons smallBtn" ForeColor="green" OnClick="viewLinkButton_OnClick" runat="server">View Details</asp:LinkButton>--%>
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
                                &nbsp;
                            </td>
                            <td width="13%" style="text-align: right; padding-right: 10px;" class="TDLeft">
                                Manufacturer: <span style="color: red">*</span>
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:DropDownList ID="manufacturerDropDownList" Width="175px" Height="23px" runat="server" CssClass="DropDown">
                                </asp:DropDownList>
                                <asp:HiddenField ID="stockInIdHiddenField" runat="server" />
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
                            <td width="13%" style="text-align: right; padding-right: 10px;" class="TDLeft">
                                Stock In Date:<span style="color: red">*</span>
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="stockInDateTextBox" Width="150px" Height="23px" runat="server" CssClass="TextBoxCalander" AutoPostBack="True" OnTextChanged="stockInDateTextBox_OnTextChanged"></asp:TextBox>
                                <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                    TabIndex="4" ID="imgDate"></asp:ImageButton>
                                <cc1:CalendarExtender ID="manufacturerDate1" runat="server" Format="dd-MMM-yyyy"
                                    TargetControlID="stockInDateTextBox">
                                </cc1:CalendarExtender>
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
                            <td width="13%" style="text-align: right; padding-right: 10px;" class="TDLeft">
                                Challan Number:<span style="color: red">*</span>
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="challanNoTextBox" Height="23px" runat="server"></asp:TextBox>
                            </td>
                            <td width="13%" class="TDLeft">
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
                            <td class="TDLeft" style="text-align: right; padding-right: 10px;" width="13%">
                                Challan Date:<span style="color: red">*</span>
                            </td>
                            <td class="TDRight" width="20%">
                                <asp:TextBox ID="challanDateTextBox" Width="150px" Height="23px" runat="server" CssClass="TextBoxCalander" AutoPostBack="True" OnTextChanged="challanDateTextBox_OnTextChanged"></asp:TextBox>
                                <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                    TabIndex="4" ID="ImageButton4"></asp:ImageButton>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy"
                                    TargetControlID="challanDateTextBox">
                                </cc1:CalendarExtender>
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
                            <td class="TDLeft" style="text-align: right; padding-right: 10px;" width="13%">
                                Reference Number:
                            </td>
                            <td class="TDRight" width="20%">
                                <asp:TextBox ID="referenceNoTextBox" Height="23px" runat="server"></asp:TextBox>
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
                            <td class="TDLeft" style="text-align: right; padding-right: 10px;" width="13%">
                                Reference Date:
                            </td>
                            <td class="TDRight" width="20%">
                                <asp:TextBox ID="referenceDateTextBox" Width="150px" Height="23px" runat="server" CssClass="TextBoxCalander" AutoPostBack="True" OnTextChanged="referenceDateTextBox_OnTextChanged"></asp:TextBox>
                                <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                    TabIndex="4" ID="ImageButton5"></asp:ImageButton>
                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" Format="dd-MMM-yyyy"
                                    TargetControlID="referenceDateTextBox">
                                </cc1:CalendarExtender>
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
                            <td class="TDLeft" style="text-align: right; padding-right: 10px;" width="13%">
                                Remarks:
                            </td>
                            <td class="TDRight" width="20%">
                                <asp:TextBox ID="remarksTextBox" Height="20px" runat="server" TextMode="MultiLine"></asp:TextBox>
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
                        <tr>
                            <td class="TDLeft" width="13%">
                                &nbsp;
                            </td>
                            <td class="TDRight" width="20%" colspan="4">
                                <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False" CssClass="gridview">
                                    <Columns>
                                        <asp:TemplateField HeaderText="SL">
                                                <ItemTemplate>
                                                    <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                                    <asp:HiddenField ID="productidHiddenField" Value='<%# Eval("ProductId")%>' runat="server" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Product Code">
                                            <ItemTemplate>
                                                <asp:TextBox ID="productCodeTextBox" runat="server" Height="23px" Width="60px" CssClass="TextBoxCalander"
                                                    AutoPostBack="True" ToolTip="true" OnTextChanged="productCodeTextBox_TextChanged"
                                                    Text='<%# Eval("ProductCode")%>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Product Name">
                                            <ItemTemplate>
                                                <asp:TextBox ID="productNameTextBox" runat="server" Height="23px" Width="140px" CssClass="TextBox"
                                                    Text='<%# Eval("ProductName")%>' AutoPostBack="True" ReadOnly="True" ToolTip="true"
                                                    OnTextChanged="productNameTextBox_TextChanged"></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="PackSize">
                                            <ItemTemplate>
                                                <asp:TextBox ID="packSizeTextBox" Height="23px" Width="60px" runat="server" CssClass="TextBoxCalander"
                                                    ReadOnly="True" Text='<%# Eval("PackSize")%>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Batch">
                                            <ItemTemplate>
                                                <asp:TextBox ID="batchTextBox" Width="60px" Height="23px" runat="server" CssClass="TextBoxCalander"
                                                    Text='<%# Eval("Batch")%>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Mfg. Date">
                                            <ItemTemplate>
                                                <asp:TextBox ID="mfgDateTextBox" runat="server" Height="23px" Width="80px" Text='<%# Eval("MfgDate")%>'
                                                    CssClass="TextBox" AutoPostBack="True" OnTextChanged="mfgDateTextBox_OnTextChanged"></asp:TextBox>
                                                <cc1:CalendarExtender ID="manufacturerDate1" runat="server" Format="dd-MMM-yyyy"
                                                    TargetControlID="mfgDateTextBox">
                                                </cc1:CalendarExtender>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Exp. Date">
                                            <ItemTemplate>
                                                <asp:TextBox ID="expDateDateTextBox" runat="server" Height="23px" Width="80px" Text='<%# Eval("ExpDate")%>'
                                                    CssClass="TextBox" OnTextChanged="expDateDateTextBox_OnTextChanged" AutoPostBack="True"></asp:TextBox>
                                                <cc1:CalendarExtender ID="manufacturerDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="expDateDateTextBox">
                                                </cc1:CalendarExtender>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Qty">
                                            <ItemTemplate>
                                                <asp:TextBox ID="reqQtyTextBox" runat="server" Height="23px" Width="60px" CssClass="TextBoxCalander"
                                                    Text='<%# Eval("Quantity")%>' AutoPostBack="True" OnTextChanged="reqQtyTextBox_OnTextChanged"></asp:TextBox>
                                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderQuantity" runat="server"
                                                    Enabled="True" TargetControlID="reqQtyTextBox" FilterType="Custom" ValidChars="0123456789.">
                                                </cc1:FilteredTextBoxExtender>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Price">
                                            <ItemTemplate>
                                                <asp:TextBox ID="costPriceTextBox" runat="server" Height="23px" Width="60px" Text='<%# Eval("Price")%>'
                                                    CssClass="TextBoxCalander" AutoPostBack="True" OnTextChanged="costPriceTextBox_OnTextChanged"></asp:TextBox>
                                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderPrice" runat="server" Enabled="True"
                                                    TargetControlID="costPriceTextBox" FilterType="Custom" ValidChars="0123456789.">
                                                </cc1:FilteredTextBoxExtender>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vat">
                                            <ItemTemplate>
                                                <asp:TextBox ID="vatTextBox" runat="server" Height="23px" Width="60px" CssClass="TextBoxCalander"
                                                    Text='<%# Eval("Vat")%>' AutoPostBack="True" OnTextChanged="vatTextBox_OnTextChanged"></asp:TextBox>
                                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderVat" runat="server" Enabled="True"
                                                    TargetControlID="vatTextBox" FilterType="Custom" ValidChars="0123456789.">
                                                </cc1:FilteredTextBoxExtender>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total Amount">
                                            <ItemTemplate>
                                                <asp:TextBox ID="totalValueTextBox" runat="server" Height="23px" Width="60px" CssClass="TextBoxCalander"
                                                    Text='<%# Eval("TotalAmount")%>' ReadOnly="True" AutoPostBack="True" OnTextChanged="totalValueTextBox_OnTextChanged"></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Add">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/images/lineAdd.png"
                                                    OnClick="ImageButton1_Click" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Remove">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/images/lineDelete.png"
                                                    OnClick="ImageButton2_Click" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
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
                        <tr>
                            <td width="13%" class="TDLeft">
                            </td>
                            <td width="20%" class="TDRight">
                            </td>
                            <td width="13%" style="text-align: right; padding-right: 10px;" class="TDLeft">
                                Total Qty :
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="totalQtyTextBox" Height="23px" runat="server" class="TextBox" ReadOnly="True"></asp:TextBox>
                            </td>
                            <td width="13%" class="TDLeft">
                            </td>
                            <td width="20%" class="TDRight">
                            </td>
                        </tr>
                        <tr>
                            <td class="TDLeft" width="13%">
                                &nbsp;
                            </td>
                            <td class="TDRight" style="text-align: right; padding-right: 10px;" width="20%">
                                &nbsp;
                            </td>
                            <td class="TDLeft" style="text-align: right; padding-right: 10px;" width="13%">
                                Total Vat:
                            </td>
                            <td class="TDRight" width="20%">
                                <asp:TextBox ID="totalVatTextBox" Height="23px" ReadOnly="True" class="TextBox" runat="server"></asp:TextBox>
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
                            </td>
                            <td width="20%" class="TDRight">
                            </td>
                            <td width="13%" style="text-align: right; padding-right: 10px;" class="TDLeft">
                                Grand Total:
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="grandTotalTextBox" Height="23px" runat="server" class="TextBox"
                                    ReadOnly="True"></asp:TextBox>
                            </td>
                            <td width="13%" class="TDLeft">
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
                                <asp:Button ID="submitButton" runat="server" OnClick="submitButton_Click" Text="Update"  OnClientClick="return confirm('Are you sure you want to Update ?');"/>
                                &nbsp; &nbsp; &nbsp; <asp:Button ID="closeButton" BackColor="#C46210" runat="server" OnClick="closeButton_Click" Text="Close" />
                            </td>
                            <td class="TDLeft" width="13%">
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
    </div>
    </form>
</body>
</html>
