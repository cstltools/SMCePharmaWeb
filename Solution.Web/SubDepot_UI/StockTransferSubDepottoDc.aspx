<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="StockTransferSubDepottoDc.aspx.cs" Inherits="SubDepot_UI_StockTransferSubDepottoDc" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Stock Transfer Sub-Depot to DC  
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            To </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            From</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                            Chalan Date</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="chalanDateTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td class="TDRight" width="20%">
                            ChalanNo</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="chalanNoTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                    
                       <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            Sales Center </td>
                        <td width="13%" class="TDLeft">
                            <asp:DropDownList ID="salescenterDropDownList1" runat="server" AutoPostBack="True"
                           CssClass="DropDown"     onselectedindexchanged="salescenterDropDownList1_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                        <td width="20%" class="TDRight">
                            Sub-Depot </td>
                        <td width="13%" class="TDLeft">
                            <asp:DropDownList ID="subdeportDropDownList2" runat="server" AutoPostBack="True"
                               CssClass="DropDown"   onselectedindexchanged="subdeportDropDownList2_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    

                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            Sales Center Code</td>
                        <td width="13%" class="TDLeft">
                            <asp:TextBox ID="fromComUnitCodeTextBox" runat="server" AutoPostBack="True" 
                                CssClass="TextBox" ontextchanged="fromComUnitCodeTextBox_TextChanged" ReadOnly="True"></asp:TextBox>
                        </td>
                        <td width="20%" class="TDRight">
                            Sub-Depot Code</td>
                        <td width="13%" class="TDLeft">
                            <asp:TextBox ID="toComUnitCodeTextBox" runat="server" CssClass="TextBox" 
                                ontextchanged="toComUnitCodeTextBox_TextChanged" AutoPostBack="True" ReadOnly="True"></asp:TextBox>
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                   
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                             Name</td>
                        <td width="13%" class="TDLeft">
                            <asp:TextBox ID="fromComUnitNameTextBox" runat="server" CssClass="TextBox" ReadOnly="True"
                                ></asp:TextBox>
                        </td>
                        <td width="20%" class="TDRight">
                             Name</td>
                        <td width="13%" class="TDLeft">
                            <asp:TextBox ID="toComUnitNameTextBox" runat="server" ReadOnly="True" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            Address</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="fromComUnitAddressTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True" TextMode="MultiLine"></asp:TextBox>
                        </td>
                        <td class="TDRight" width="20%">
                            Address</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="toComUnitAddressTextBox" runat="server" CssClass="TextBox" 
                             ReadOnly="True"   TextMode="MultiLine"></asp:TextBox>
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            Truck Number</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="truckNoTextBox" runat="server" CssClass="TextBox" 
                                Height="21px"></asp:TextBox>
                        </td>
                        <td class="TDRight" width="20%">
                            Driver Name</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="driverNameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
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
                            Manufacturer</td>
                        <td class="TDLeft" width="13%">
                            <asp:DropDownList ID="manufacDropDownList" runat="server" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                   
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            Product</td>
                        <td class="TDLeft" width="13%">
                            <asp:DropDownList ID="productDropDownList" runat="server" AutoPostBack="True" 
                                CssClass="DropDown" 
                              >
                            </asp:DropDownList>
                        </td>
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
                           </td>
                              <td class="TDRight" width="20%">
                           </td>
                        <td class="TDLeft" width="13%" runat="server" Visible="False">
                            <asp:TextBox ID="prodctCodeTextBox" runat="server" CssClass="TextBox" 
                                Height="21px"></asp:TextBox>
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:Button ID="Button1" runat="server" Text="Search Product" onclick="Button1_Click" />
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
                            <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="SubDCStoreId,VATAmountPerUnit,UnitPrice" >
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" 
                                                oncheckedchanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="PCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="PName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="StockQty" HeaderText="Stock Qty" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />
                                        <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ReceiveDate" />
                                    <asp:TemplateField HeaderText="Transfer Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="transferQtyTextBox" runat="server" CssClass="TextBox" 
                                                Height="21px"    ontextchanged="dQtyTextBox_TextChanged" AutoPostBack="True"></asp:TextBox>
                                                 <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderconvRate" runat="server"
                                                    Enabled="True" TargetControlID="transferQtyTextBox" FilterType="Custom" ValidChars="0123456789">
                                                </asp:FilteredTextBoxExtender>
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
                            <asp:Button ID="addButton" runat="server" Text="Add" 
                                onclick="addButton_Click" />
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
                        <td class="TDLeft" colspan="6">
                            <asp:GridView ID="chalanGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="SubDCStoreId,VATAmountPerUnit,UnitPrice">
                                <Columns>
                                    
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="TransferQty" HeaderText="Transfer Qty" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />
                                        <asp:TemplateField HeaderText="Remove Item">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="DeleteImageButton" runat="server" 
                                                ImageUrl="~/images/lineDelete.png" onclick="DeleteImageButton_Click" />
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
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp; </td>
                        <td class="TDRight" width="20%" colspan="2">
                            Taka :&nbsp;&nbsp;
                            <asp:Label ID="grandTotalWordLabel" runat="server"></asp:Label>
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
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
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft" >
                            &nbsp;</td>
                            <td width="20%" class="TDRight">
                                &nbsp;</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                            <asp:Button ID="submitButton" runat="server" onclick="submitButton_Click1" 
                                Text="Submit" />
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr runat="server" Visible="False">
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Chalan No</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="printChalanNoTextBox" runat="server" AutoPostBack="True" 
                                CssClass="TextBox" ontextchanged="fromComUnitCodeTextBox_TextChanged"></asp:TextBox>
                        </td>                            

                        <td class="TDLeft" width="13%">
                            <asp:Button ID="Button2" runat="server" BackColor="#660033" 
                                onclick="Button2_Click" Text="Print" />
                        </td>
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

