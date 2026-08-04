<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="StockTransferDcToDc.aspx.cs" Inherits="SInventory_UI_StockTransferDcToDc" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style1
        {
            VERTICAL-ALIGN: TOP;
            TEXT-ALIGN: right;
            FONT-WEIGHT: NONE;
            FONT-SIZE: 9pt;
            COLOR: #000000;
            FONT-FAMILY: Estrangelo Edessa,Arial,Times New Roman;
            TEXT-DECORATION: NONE;
            BACKGROUND: #F2F2F2; /*C0C0C0*/
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <link type="text/css" href="../css/Date/jquery.datepick.css" rel="stylesheet">
    <script type="text/javascript" src="../css/Date/jquery.datepick.js"></script>
   <script type="text/javascript">
       $(function () {
           $('.datepick').datepick();
       });
       var prm = Sys.WebForms.PageRequestManager.getInstance();
       if (prm != null) {
           prm.add_endRequest(function (sender, e) {
               if (sender._postBackSettings.panelsToUpdate != null) {

                   $('.datepick').datepick();
               }
           });
       }; 
 </script>

     <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Stock Transfer DC to DC
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
                            From</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            To</td>
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
                            <asp:TextBox ID="chalanNoTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            ComUnit Code</td>
                        <td width="13%" class="TDLeft">
                            <asp:TextBox ID="fromComUnitCodeTextBox" runat="server" AutoPostBack="True" 
                                CssClass="TextBox" ontextchanged="fromComUnitCodeTextBox_TextChanged" ></asp:TextBox>
                        </td>
                        <td width="20%" class="TDRight">
                            To ComUnit Code</td>
                        <td width="13%" class="TDLeft">
                            <asp:TextBox ID="toComUnitCodeTextBox" runat="server" CssClass="TextBox" 
                                ontextchanged="toComUnitCodeTextBox_TextChanged" AutoPostBack="True"></asp:TextBox>
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            ComUnit Name</td>
                        <td width="13%" class="TDLeft">
                            <asp:TextBox ID="fromComUnitNameTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td width="20%" class="TDRight">
                            ComUnit Name</td>
                        <td width="13%" class="TDLeft">
                            <asp:TextBox ID="toComUnitNameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            Com Unit&nbsp; Address</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="fromComUnitAddressTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True" TextMode="MultiLine"></asp:TextBox>
                        </td>
                        <td class="TDRight" width="20%">
                            Com Unit&nbsp; Address</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="toComUnitAddressTextBox" runat="server" CssClass="TextBox" 
                                TextMode="MultiLine"></asp:TextBox>
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
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                   
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" colspan="4" rowspan="9">
                            <asp:GridView ID="gridLineItemGridView" runat="server" 
                                
                                 CssClass="gridview" AutoGenerateColumns="False" >
                                <Columns>
                                    <asp:BoundField DataField="SL" HeaderText="SL" />
                                    <asp:TemplateField HeaderText="Product Code">
                                        <ItemTemplate>
                                            <asp:TextBox ID="productCodeTextBox" runat="server" Width="86px" 
                                                Text= <%#Eval("ProductCode") %> AutoPostBack="True" 
                                                ontextchanged="productCodeTextBox_TextChanged"></asp:TextBox>
                                                <asp:FilteredTextBoxExtender ID="fproductCodeTextBox" runat="server"
                                                    TargetControlID="productCodeTextBox"         
                                                    FilterType="Custom, Numbers"
                                                    ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Product Name">
                                        <ItemTemplate>
                                            <asp:TextBox ID="productNameTextBox" runat="server" Width="200px" 
                                                Text= <%# Eval("ProductName")%> AutoPostBack="True" ontextchanged="productNameTextBox_TextChanged" 
                                                ></asp:TextBox>
                                                <asp:AutoCompleteExtender ID="productNameTextBox_AutoCompleteExtender" runat="server"
                                         DelimiterCharacters="" EnableCaching="true"
                                        Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                        ServiceMethod="GetProduct2" ServicePath="SInventoryWebService.asmx"  TargetControlID="productNameTextBox" 
                                        UseContextKey="True"
                                        CompletionListCssClass="autocomplete_completionListElement" 
                                        CompletionListItemCssClass="autocomplete_listItem" 
                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                        ShowOnlyCurrentWordInCompletionListItem="true">
                                    </asp:AutoCompleteExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                    <asp:TemplateField HeaderText="Quantity">
                                        <ItemTemplate>
                                           
                                            <asp:TextBox ID="quantityTextBox" runat="server" Text= <%# Eval("Quantity")%> 
                                                AutoPostBack="True" Width="100px"></asp:TextBox>
                                           
                                        </ItemTemplate>
                                        
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Batch No">
                                        <ItemTemplate>
                                            <asp:TextBox ID="batchNoTextBox" runat="server" CssClass="TextBoxMicroMini"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Add Item">
                                        <ItemTemplate>
                                           
                                            <asp:ImageButton ID="AddLButton" runat="server" ImageUrl="~/images/lineAdd.png" 
                                                onclick="AddLButton_Click" />
                                           
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Remove Item">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="DeleteImageButton" runat="server" 
                                                ImageUrl="~/images/list_edit.png" onclick="DeleteImageButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                          
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
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
                    </tr>
                    <tr>
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
                    </tr>
                    <tr>
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
                    </tr>
                    <tr>
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
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;&nbsp;</td>
                        <td width="20%" class="TDRight">
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
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="style1" width="20%">
                            Total Value With VAT : </td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="totalTextBox" runat="server" ReadOnly="True"></asp:TextBox>
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="style1" width="20%">
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
                        <td class="style1" width="20%">
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
                        <td class="style1" width="20%">
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
</asp:Content>

