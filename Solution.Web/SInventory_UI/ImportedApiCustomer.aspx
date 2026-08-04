
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ImportedApiCustomer.aspx.cs" Inherits="SInventory_UI_ImportedApiCustomer" %>

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
                            Imported Api Customer Edit</td>
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
                            <asp:TextBox ID="customernameTextBox" runat="server" CssClass="TextBox"></asp:TextBox></td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%"></td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                        <td width="13%" class="TDLeft">Address</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="addressTextBox" runat="server" CssClass="TextBox" ></asp:TextBox></td>
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
                            <asp:TextBox ID="addressTextBox2" runat="server" CssClass="TextBox" ></asp:TextBox>
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
                            <asp:TextBox ID="contactTextBox" runat="server" CssClass="TextBox" ></asp:TextBox></td>
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
                            <asp:TextBox ID="cityTextBox" runat="server" CssClass="TextBox" ></asp:TextBox>
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
                            <asp:TextBox ID="contactPersonTextBox" runat="server" CssClass="TextBox" ></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <%--<tr>
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
                    </tr>--%>
                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                       <td class="TDLeft" width="13%">
                            Distribution Center</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="comUnitNameDropDownList" runat="server" 
                                CssClass="DropDown">
                            </asp:DropDownList></td>
                       <td class="TDLeft" width="13%">&nbsp;</td>
                       <td class="TDRight" width="20%">&nbsp;</td>
                    </tr>
                    
                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">DZSM&nbsp; Code</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="regionNameDropDownList" runat="server" 
                                AutoPostBack="True" CssClass="DropDown" 
                                onselectedindexchanged="regionNameDropDownList_SelectedIndexChanged"></asp:DropDownList></td>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                    </tr>
                    
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            DZSM Name</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="dzsmNameTextBox" ReadOnly="True" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    
                    
                    <tr>
                        <td width="13%" class="TDLeft">&nbsp;</td>
                        <td width="20%" class="TDRight">&nbsp;</td>
                        <td width="13%" class="TDLeft" >
                            FE Code</td>
                            <td width="20%" class="TDRight">
                                <asp:DropDownList ID="districtNameDropDownList" runat="server" 
                                    CssClass="DropDown" AutoPostBack="True" 
                                    onselectedindexchanged="districtNameDropDownList_SelectedIndexChanged">
                                </asp:DropDownList></td>
                        <td width="13%" class="TDLeft">&nbsp;</td>
                        <td width="20%" class="TDRight">&nbsp;</td>
                    </tr>

                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            FE Name</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="feNameTextBox" ReadOnly="True" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    
                    
                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Territory Code</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="areaNameDropDownList" runat="server" AutoPostBack="True" 
                                CssClass="DropDown" 
                                onselectedindexchanged="areaNameDropDownList_SelectedIndexChanged">
                            </asp:DropDownList></td>                            
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                    </tr>
                    
                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Territory Name</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="territoryNameTextBox" ReadOnly="True" runat="server" CssClass="TextBox"></asp:TextBox></td>                            
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                    </tr>

                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">MIO Code</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="miaNameDropDownList" runat="server" AutoPostBack="True" 
                                CssClass="DropDown" 
                                onselectedindexchanged="miaNameDropDownList_SelectedIndexChanged">
                            </asp:DropDownList></td>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                   </tr>
                   
                   <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">
                            MIO Name</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="mioNameTextBox" ReadOnly="True" runat="server" CssClass="TextBox"></asp:TextBox></td>                            
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                    </tr>

                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Market Code</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="marketNameDropDownList" runat="server" CssClass="DropDown" 
                                AutoPostBack="True" OnTextChanged="marketNameDropDownList_OnTextChanged">
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
                            <asp:TextBox ID="marketNameTextBox" ReadOnly="True" runat="server" CssClass="TextBox"></asp:TextBox></td>                            
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                    </tr>

                    <%--<tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Category Name</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="categoryNameDropDownList" runat="server" 
                                CssClass="DropDown" AutoPostBack="True">
                            </asp:DropDownList></td>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                    </tr>--%>
                    <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Payment Type</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="paymentTypeDropDownList" runat="server" 
                                AutoPostBack="True" CssClass="DropDown">
                                <asp:ListItem>Cash</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                    </tr>
                     <tr>
                        <td class="TDLeft" width="13%">&nbsp;</td>
                        <td class="TDRight" width="20%">&nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Fixed Business</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="fbDropDownList" runat="server" 
                                AutoPostBack="True" CssClass="DropDown">
                                <asp:ListItem Value="0">False</asp:ListItem>
                                <asp:ListItem Value="1">True</asp:ListItem>
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