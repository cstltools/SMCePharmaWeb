<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerMasterEdit.aspx.cs" Inherits="SInventory_UI_CustomerMasterEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Edit</title>
    <link href="../css/custom.css" rel="stylesheet" type="text/css" />
     <link rel="stylesheet" href="../css/style.css" type="text/css">
    <link rel="stylesheet" href="../css/colors/blue.css" id="colors" type="text/css">
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
      <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Customer Master Edit</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;
                            <asp:HiddenField ID="custMastIdHiddenField" runat="server" /></td>
                        <td class="TDRight" width="20%"></td>
                        <td class="TDLeft" width="13%"></td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%"></td>
                        <td class="TDRight" width="20%"></td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                            Customer Code</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="customerCodeTextBox" runat="server" CssClass="TextBox" ReadOnly="true"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%"></td>
                        <td class="TDRight" width="20%"></td>
                        <td class="TDLeft" width="13%">
                            Customer Name</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="customernameTextBox" runat="server" CssClass="TextBox" ReadOnly="true"></asp:TextBox></td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%"></td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                        <td width="13%" class="TDLeft">Address</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="addressTextBox" runat="server" CssClass="TextBox" ReadOnly="true"></asp:TextBox></td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Address Second</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="addressTextBox2" runat="server" CssClass="TextBox" ReadOnly="true"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight">&nbsp;</td>
                        <td width="13%" class="TDLeft">
                            ContactNo</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="contactTextBox" runat="server" CssClass="TextBox" ReadOnly="true"></asp:TextBox></td>
                        <td width="13%" class="TDLeft">&nbsp;</td>
                        <td width="20%" class="TDRight"></td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            City</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="cityTextBox" runat="server" CssClass="TextBox" ReadOnly="true"></asp:TextBox>
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
                            Contact Person</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="contactPersonTextBox" runat="server" CssClass="TextBox" ReadOnly="true"></asp:TextBox>
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
                            Shipping Condition</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="shippingConditionTextBox" runat="server" CssClass="TextBox" ReadOnly="true"></asp:TextBox>
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
                            FE Person Name</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="feNameTextBox" runat="server" CssClass="TextBox" ReadOnly="true"></asp:TextBox>
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
                            DZSM Person Name</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="dzsmNameTextBox" runat="server" CssClass="TextBox" ReadOnly="true"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">DZSM Name</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="regionNameDropDownList" runat="server" 
                                AutoPostBack="True" CssClass="DropDown" 
                                onselectedindexchanged="regionNameDropDownList_SelectedIndexChanged" Enabled="False"></asp:DropDownList></td>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                       <td class="TDLeft" width="13%">
                            Distribution Center</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="comUnitNameDropDownList" runat="server" 
                                CssClass="DropDown" AutoPostBack="True" 
                                onselectedindexchanged="comUnitNameDropDownList_SelectedIndexChanged">
                            </asp:DropDownList></td>
                       <td class="TDLeft" width="13%">&nbsp;</td>
                       <td class="TDRight" width="20%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">&nbsp;</td>
                        <td width="20%" class="TDRight">&nbsp;</td>
                        <td width="13%" class="TDLeft" >
                            FE Name</td>
                            <td width="20%" class="TDRight">
                                <asp:DropDownList ID="districtNameDropDownList" runat="server" 
                                    CssClass="DropDown" AutoPostBack="True" Enabled="False"
                                    onselectedindexchanged="districtNameDropDownList_SelectedIndexChanged">
                                </asp:DropDownList></td>
                        <td width="13%" class="TDLeft">&nbsp;</td>
                        <td width="20%" class="TDRight">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Territory Name</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="areaNameDropDownList" runat="server" AutoPostBack="True" 
                                CssClass="DropDown" Enabled="False"
                                onselectedindexchanged="areaNameDropDownList_SelectedIndexChanged">
                            </asp:DropDownList></td>                            
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">MIO Name</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="miaNameDropDownList" runat="server" AutoPostBack="True" 
                                CssClass="DropDown" Enabled="False"
                                onselectedindexchanged="miaNameDropDownList_SelectedIndexChanged">
                            </asp:DropDownList></td>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                   </tr>
                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Market Name</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="marketNameDropDownList" runat="server" CssClass="DropDown" 
                                AutoPostBack="True">
                            </asp:DropDownList></td>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Category Name</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="categoryNameDropDownList" runat="server"  Enabled="False"
                                CssClass="DropDown" AutoPostBack="True">
                            </asp:DropDownList></td>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Payment Type</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="paymentTypeDropDownList" runat="server" Enabled="False"
                                AutoPostBack="True" CssClass="DropDown">
                                <asp:ListItem></asp:ListItem>
                                <asp:ListItem>Cash</asp:ListItem>
                             <%--   <asp:ListItem>Credit</asp:ListItem>--%>
                            </asp:DropDownList>
                        </td>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            <asp:Button ID="updateButton" runat="server" onclick="updateButton_Click" 
                                Text="Update" />
                            <asp:Button ID="closeButton" runat="server" onclick="closeButton_Click" 
                                Text="Close" />
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

    </div>

    </div>
    </form>
</body>
</html>
