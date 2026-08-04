<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="InvoiceManagement.aspx.cs" Inherits="SInventory_UI_InvoiceManagement" %>

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
                            Invoice</td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            Customer Code</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="custCodeTextBox" runat="server" AutoPostBack="True" 
                                CssClass="TextBox" ontextchanged="custCodeTextBox_TextChanged" ></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            CustomerName</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="custNameTextBox" runat="server" CssClass="TextBox" 
                                AutoPostBack="True" ontextchanged="custNameTextBox_TextChanged"></asp:TextBox>
                            
                            <asp:AutoCompleteExtender ID="custNameTextBox_AutoCompleteExtender" runat="server"
                                         DelimiterCharacters="" EnableCaching="true"
                                        Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                        ServiceMethod="GetCustomer_New" ServicePath="SInventoryWebService.asmx"  TargetControlID="custNameTextBox" 
                                        UseContextKey="True"
                                        CompletionListCssClass="autocomplete_completionListElement" 
                                        CompletionListItemCssClass="autocomplete_listItem" 
                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                        ShowOnlyCurrentWordInCompletionListItem="true"
                                        >
                                    </asp:AutoCompleteExtender>


                        </td>
                        <td width="13%" class="TDLeft">
                            Customer Address</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="custAddressTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            Salse Center</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="comUnitNameTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            MIA Code</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="miaCodeTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            MIA Name</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="miaNameTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            Distirict
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="districtNameTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            Area</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="areaNameTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            Merket</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="marketNameTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            Customer Category</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="custCategoryTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
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
                            Invoice Date</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="invDateTextBox" runat="server" CssClass="TextBoxCalander" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            Order No</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="orderNoTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            Order Date</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="orderDateTextBox" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                                 <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgorderDate"></asp:ImageButton>
                            <asp:CalendarExtender ID="orderDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="orderDateTextBox"
                                PopupButtonID="imgorderDate">
                            </asp:CalendarExtender>
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
                            Override Limit
                        </td>
                         <td width="20%" class="TDRight">
                            <asp:CheckBox ID="chbOverrideLimit" runat="server" Text="Authorize > 50k" />
                        </td>
                        <td width="13%" class="TDLeft">
                            Payment Type</td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="payTypeDDL" runat="server" CssClass="DropDown">
                            </asp:DropDownList>
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
                        <td class="TDLeft" width="13%" colspan="6">
                            <asp:GridView ID="gridLineItemGridView" runat="server" 
                                AutoGenerateColumns="False" CssClass="gridview" Height="313px">
                                <Columns>
                                    <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="slLabel" runat="server" Text= <%# Eval("SL")%>></asp:Label>
                                            <asp:ImageButton ID="addImageButton" runat="server" 
                                                ImageUrl="~/images/lineAdd.png" onclick="addImageButton_Click" />
                                            <asp:ImageButton ID="removeImageButton" runat="server" 
                                                ImageUrl="~/images/lineDelete.png" onclick="removeImageButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Code">
                                        <ItemTemplate>
                                            <asp:TextBox ID="codeTextBox" runat="server" Text= <%# Eval("ProductCode")%> 
                                                CssClass="TextBoxMicroMini" AutoPostBack="True" 
                                                ontextchanged="codeTextBox_TextChanged"></asp:TextBox>
                                                <asp:FilteredTextBoxExtender ID="fcodeTextBox" runat="server"
                                                    TargetControlID="codeTextBox"         
                                                    FilterType="Custom, Numbers"
                                                    ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Name">
                                        <ItemTemplate>
                                            <asp:TextBox ID="nameTextBox" runat="server" CssClass="TextBox" 
                                                Text= <%# Eval("ProductName")%> AutoPostBack="True" 
                                                ontextchanged="nameTextBox_TextChanged" ></asp:TextBox>
                                                <asp:AutoCompleteExtender ID="nameTextBox_AutoCompleteExtender" runat="server"
                                         DelimiterCharacters="" EnableCaching="true"
                                        Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                        ServiceMethod="GetProduct2" ServicePath="SInventoryWebService.asmx"  TargetControlID="nameTextBox" 
                                        UseContextKey="True"
                                        CompletionListCssClass="autocomplete_completionListElement" 
                                        CompletionListItemCssClass="autocomplete_listItem" 
                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                        ShowOnlyCurrentWordInCompletionListItem="true"
                                        >
                                    </asp:AutoCompleteExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="CStock">
                                        <ItemTemplate>
                                            <asp:TextBox ID="currentStockTextBox" runat="server" 
                                                CssClass="TextBoxMicroMini" Text= <%# Eval("StockQty")%> ReadOnly="True"></asp:TextBox>
                                                <asp:FilteredTextBoxExtender ID="fcurrentStockTextBox" runat="server"
                                                    TargetControlID="currentStockTextBox"         
                                                    FilterType="Custom, Numbers"
                                                    ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="UP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="unitPriceTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                Text= <%# Eval("UnitPrice")%> ReadOnly="True"></asp:TextBox>
                                                              <asp:FilteredTextBoxExtender ID="funitPriceTextBox" runat="server"
                                                    TargetControlID="unitPriceTextBox"         
                                                    FilterType="Custom, Numbers"
                                                    ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="UVAT">
                                        <ItemTemplate>
                                            <asp:TextBox ID="upVatTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                Text= <%# Eval("UnitVAT")%> ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fupVatTextBox" runat="server"
                                                    TargetControlID="upVatTextBox"         
                                                    FilterType="Custom, Numbers"
                                                    ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="qtyTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                Text= <%# Eval("Quantity")%> AutoPostBack="True" 
                                                ontextchanged="qtyTextBox_TextChanged"></asp:TextBox>
                                                   <asp:FilteredTextBoxExtender ID="fqtyTextBox" runat="server"
                                                    TargetControlID="qtyTextBox"         
                                                    FilterType="Custom, Numbers"
                                                    ValidChars="." />
                                                
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="TP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="tpTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                Text= <%# Eval("TotalPrice")%> ReadOnly="True"></asp:TextBox>
                                             <asp:FilteredTextBoxExtender ID="ftpTextBox" runat="server"
                                                    TargetControlID="tpTextBox"         
                                                    FilterType="Custom, Numbers"
                                                    ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="TPVAT">
                                        <ItemTemplate>
                                            <asp:TextBox ID="tpVatTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                Text= <%# Eval("VAT")%> ReadOnly="True"></asp:TextBox>
                                             <asp:FilteredTextBoxExtender ID="ftpVatTextBox" runat="server"
                                                        TargetControlID="tpVatTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />

                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="DP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="dpTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                Text= <%# Eval("DiscountPercentage")%> ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fdpTextBox" runat="server"
                                                        TargetControlID="dpTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />

                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="DAmt">
                                        <ItemTemplate>
                                            <asp:TextBox ID="dpAmtTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                Text= <%# Eval("DiscountAmount")%> ReadOnly="True"></asp:TextBox>
                                             <asp:FilteredTextBoxExtender ID="fdpAmtTextBox" runat="server"
                                                        TargetControlID="dpAmtTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="NP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="npTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                Text= <%# Eval("NetPrice")%> ReadOnly="True"></asp:TextBox>
                                             <asp:FilteredTextBoxExtender ID="fnpTextBox" runat="server"
                                                        TargetControlID="npTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="BQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="bQtyTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                Text= <%# Eval("BonusQty")%> AutoPostBack="True" 
                                                ontextchanged="bQtyTextBox_TextChanged" ReadOnly="True"></asp:TextBox>
                                                <asp:FilteredTextBoxExtender ID="fbQtyTextBox" runat="server"
                                                        TargetControlID="bQtyTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="TQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="tQtyTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                Text= <%# Eval("TotalQty")%> ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="ftQtyTextBox" runat="server"
                                                        TargetControlID="tQtyTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />
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
                            TP Total</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="tpTptalTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
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
                            VAT Total</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="vatTotalTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
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
                            Discount Total</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="disTotalTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
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
                            Grand Total</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="grandTotalTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
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
                            <asp:Button ID="saveButton" runat="server" Text="Invoice Generate" 
                                onclick="saveButton_Click" />
                            <asp:Button ID="updateButton" runat="server" Text="Update Invoice" 
                                onclick="updateButton_Click" Visible="False" />
                            <asp:Button ID="clearButton" runat="server" Text="Clear" 
                                onclick="clearButton_Click" />
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
                            Print InvNo</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="invTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Button ID="printButton" runat="server" onclick="printButton_Click" 
                                Text="Print" />
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                             <asp:HiddenField ID="hdCustomerMasterId" runat="server" />
                             <asp:HiddenField ID="hdComUnitId" runat="server" />
                           
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:HiddenField ID="hdMiaId" runat="server" />
                            <asp:HiddenField ID="hdInvoiceId" runat="server" />
                            <asp:HiddenField ID="hdInvoiceNo" runat="server" />
                        </td>
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
                
                <br />
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="4" class="TableHeading">Search Invoices</td>
                    </tr>
                    <tr>
                        <td width="20%" class="TDLeft">Invoice Date</td>
                        <td width="30%" class="TDRight">
                            <asp:TextBox ID="searchDateTextBox" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgSearchDate"></asp:ImageButton>
                            <asp:CalendarExtender ID="SearchDateExtender" runat="server" Format="dd-MMM-yyyy" TargetControlID="searchDateTextBox" PopupButtonID="imgSearchDate">
                            </asp:CalendarExtender>
                        </td>
                        <td width="20%" class="TDLeft">
                            <asp:Button ID="searchListButton" runat="server" Text="Search" OnClick="searchListButton_Click" />
                        </td>
                        <td width="30%" class="TDRight">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <asp:GridView ID="gvInvoiceList" runat="server" AutoGenerateColumns="False" CssClass="gridview" Width="100%" OnRowCommand="gvInvoiceList_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="InvoiceId" HeaderText="Invoice ID" Visible="False" />
                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" />
                                    <asp:BoundField DataField="InvoiceDate" HeaderText="Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                                    <asp:BoundField DataField="TpGrandTotal" HeaderText="Grand Total" />
                                    <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditInvoice" CommandArgument='<%# Eval("InvoiceNo") %>' Text="Edit" />
                                            |
                                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteInvoice" CommandArgument='<%# Eval("InvoiceNo") %>' Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this invoice?');" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>


