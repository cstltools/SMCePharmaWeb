<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="ReturnInvoiceCreationForCustomer.aspx.cs" Inherits="SInventory_UI_InvoiceCreationForCustomer" %>

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
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Invoice No</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="delinvoicenoTextBox" runat="server" AutoPostBack="True" 
                                CssClass="TextBox" ontextchanged="custNameTextBox_TextChanged"></asp:TextBox>
                            <asp:AutoCompleteExtender ID="delinvoicenoTextBox_AutoCompleteExtender" 
                                runat="server" CompletionListCssClass="autocomplete_completionListElement" 
                                CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem" 
                                CompletionListItemCssClass="autocomplete_listItem" CompletionSetCount="10" 
                                DelimiterCharacters="" EnableCaching="true" Enabled="True" 
                                MinimumPrefixLength="1" ServiceMethod="GetCustomer" 
                                ServicePath="SInventoryWebService.asmx" 
                                ShowOnlyCurrentWordInCompletionListItem="true" 
                                TargetControlID="delinvoicenoTextBox" UseContextKey="True">
                            </asp:AutoCompleteExtender>
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
                            Sales Center</td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                AutoPostBack="True" CssClass="DropDown" >
                            </asp:DropDownList>
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Button ID="Button1" runat="server" onclick="Button1_Click" Text="Search" />
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
                            Customer Code</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="custCodeTextBox" runat="server" AutoPostBack="True" 
                                CssClass="TextBox" ontextchanged="custCodeTextBox_TextChanged"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            CustomerName</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="custNameTextBox" runat="server" AutoPostBack="True" 
                                CssClass="TextBox" ontextchanged="custNameTextBox_TextChanged"></asp:TextBox>
                            <asp:AutoCompleteExtender ID="custNameTextBox_AutoCompleteExtender" 
                                runat="server" CompletionListCssClass="autocomplete_completionListElement" 
                                CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem" 
                                CompletionListItemCssClass="autocomplete_listItem" CompletionSetCount="10" 
                                DelimiterCharacters="" EnableCaching="true" Enabled="True" 
                                MinimumPrefixLength="1" ServiceMethod="GetCustomer" 
                                ServicePath="SInventoryWebService.asmx" 
                                ShowOnlyCurrentWordInCompletionListItem="true" 
                                TargetControlID="custNameTextBox" UseContextKey="True">
                            </asp:AutoCompleteExtender>
                        </td>
                        <td class="TDLeft" width="13%">
                            Customer Address</td>
                        <td class="TDRight" width="20%">
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
                            &nbsp;</td>
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
                    <tr runat="server" Visible="False" id="asdfs">
                        <td width="13%" class="TDLeft">
                            <asp:HiddenField ID="orderIdHiddenField" runat="server" />
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft" >
                            <asp:HiddenField ID="invoiceHiddenField" runat="server" />
                        </td>
                         <td width="20%" class="TDRight">
                            &nbsp;
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
                                AutoGenerateColumns="False" CssClass="gridview" Height="313px" 
                                DataKeyNames="InvoiceDetailId,DCStoreId">
                                <Columns>
                                    <asp:TemplateField HeaderText="SL" Visible="False">
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
                                            <asp:HiddenField ID="orderdetailIdHiddenField" runat="server" Value=<%# Eval("OrderDetailsId")%> />    
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
                                    <asp:TemplateField HeaderText="CStock" Visible="False">
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
                                            <asp:TextBox ID="qtyTextBox" runat="server" CssClass="TextBoxMicroMini" ReadOnly="True"
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
                                    <asp:TemplateField HeaderText="PRQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="prQtyTextBox" runat="server" CssClass="TextBoxMicroMini"  ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fprQtyTextBox" runat="server"
                                                        TargetControlID="prQtyTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="RQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="dQtyTextBox" runat="server" CssClass="TextBoxMicroMini"  AutoPostBack="True" ReadOnly="True"
                                                ontextchanged="dQtyTextBox_TextChanged" ></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fdQtyTextBox" runat="server"
                                                        TargetControlID="dQtyTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" 
                                                oncheckedchanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" AutoPostBack="True" runat="server" OnCheckedChanged="chkSelect_OnCheckedChanged" />
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
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>


