<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="ReturnDelivaryInvoiceCreationForCustomerByOrder.aspx.cs" Inherits="SInventory_UI_DelivaryInvoiceCreationForCustomerByOrderAuto" %>

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
                           Return Invoice</td>
                    </tr>
                     <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                         </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="ReturnInvoiceView.aspx">Details List</asp:HyperLink>                          
                            
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                     <tr>
                        <td class="TDLeft" width="13%">
                            <%--<asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="DelivaryInvoiceCreationAuto.aspx">Back to List</asp:HyperLink>--%>                          
                            &nbsp;Is Sub Depot : </td>
                        <td class="TDRight" width="20%">
                            <asp:CheckBox ID="CheckBox1" runat="server" />
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
                    <tr>
                        <td class="TDLeft" width="13%">
                            Invoice No</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="searchOrderNoTextBox" runat="server" AutoPostBack="True" 
                                CssClass="TextBox" ontextchanged="custCodeTextBox_TextChanged"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Button ID="Button2" runat="server" onclick="Button2_Click" Text="Search" />
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <hr/>
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
                                        ServiceMethod="GetCustomer" ServicePath="SInventoryWebService.asmx"  TargetControlID="custNameTextBox" 
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
                            MIO Code</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="miaCodeTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            MIO Name</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="miaNameTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                           FE Name
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="districtNameTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            Territory Name</td>
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
                            Order No</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="orderNoTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            Order Date</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="orderDateTextBox" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:ImageButton ID="imgorderDate" runat="server" 
                                AlternateText="Click to show calendar" 
                                ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="4" />
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
                            Delivery Person Mob.No </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="deliverypersonNameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            Delivery Person Name </td>
                        <td width="20%" class="TDRight">
                            <asp:CalendarExtender ID="orderDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="orderDateTextBox"
                                PopupButtonID="imgorderDate">
                            </asp:CalendarExtender>
                            <asp:TextBox ID="deliverypersonMobileTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                    </tr>
                    <tr runat="server" id="asdfs">
                        <td width="13%" class="TDLeft" >
                            Remarks</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="remarksTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                         <td width="20%" class="TDRight">
                             &nbsp;</td>
                        <td id="Td1" width="13%" class="TDLeft" runat="server" Visible="False">
                            Payment Type</td>
                        <td id="Td2" width="20%" class="TDRight" runat="server" Visible="False">
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
                            <asp:HiddenField ID="invoiceNoHiddenField" runat="server" />
                            <asp:HiddenField ID="invoiceHiddenField" runat="server" />
                            <asp:HiddenField ID="orderIdHiddenField" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%" colspan="6">
                            <asp:GridView ID="gridLineItemGridView" runat="server" 
                                AutoGenerateColumns="False" CssClass="gridview" 
                                DataKeyNames="InvoiceDetailId,DCStoreId,SubDCStoreId">
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
                                                Text= <%# Eval("DeliveryTotalQuantity")%> AutoPostBack="True" 
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
                                                Text= <%# Eval("DeliveryTotalPrice")%> ReadOnly="True"></asp:TextBox>
                                             <asp:FilteredTextBoxExtender ID="ftpTextBox" runat="server"
                                                    TargetControlID="tpTextBox"         
                                                    FilterType="Custom, Numbers"
                                                    ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                    <asp:TemplateField HeaderText="DP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="dpTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                Text= <%# Eval("DeliveryDiscountPercentage")%> ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fdpTextBox" runat="server"
                                                        TargetControlID="dpTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />

                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="DAmt">
                                        <ItemTemplate>
                                            <asp:TextBox ID="dpAmtTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                Text= <%# Eval("DeliveryDiscountAmount")%> ReadOnly="True"></asp:TextBox>
                                             <asp:FilteredTextBoxExtender ID="fdpAmtTextBox" runat="server"
                                                        TargetControlID="dpAmtTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="SD">
                                        <ItemTemplate>
                                            <asp:TextBox ID="sdTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                Text= <%# Eval("SpecialAmount")%> ReadOnly="True"></asp:TextBox>
                                             <asp:FilteredTextBoxExtender ID="fsdTextBox" runat="server"
                                                        TargetControlID="sdTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="TPVAT">
                                        <ItemTemplate>
                                            <asp:TextBox ID="tpVatTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                Text= <%# Eval("DeliveryTotalPriceVatAmount")%> ReadOnly="True"></asp:TextBox>
                                             <asp:FilteredTextBoxExtender ID="ftpVatTextBox" runat="server"
                                                        TargetControlID="tpVatTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />

                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="NP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="npTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                Text= <%# Eval("DeliveryNetAmount")%> ReadOnly="True"></asp:TextBox>
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
                                                Text= <%# Eval("DeliveryTotalQuantity")%> ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="ftQtyTextBox" runat="server"
                                                        TargetControlID="tQtyTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="DQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="rQtyTextBox" runat="server" CssClass="TextBoxMicroMini"  AutoPostBack="True" Enabled="False"
                                                         ontextchanged="dQtyTextBox_TextChanged" Text= <%# Eval("DeliveryTotalQuantity")%> ></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="frQtyTextBox" runat="server"
                                                                         TargetControlID="rQtyTextBox"         
                                                                         FilterType="Custom, Numbers"
                                                                         ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="PRQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="prQtyTextBox" runat="server" CssClass="TextBoxMicroMini" 
                                                          Text= <%# Eval("TQty")%> ></asp:TextBox>
                                            
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="RQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="dQtyTextBox" runat="server" CssClass="TextBoxMicroMini"  AutoPostBack="True"
                                                ontextchanged="dQtyTextBox_TextChanged" Text= <%# Eval("DeliveryTotalQuantity")%> ></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fdQtyTextBox" runat="server"
                                                        TargetControlID="dQtyTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                    <asp:TemplateField HeaderText="Check">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="isreturnCheckBox" AutoPostBack="True" runat="server" OnCheckedChanged="isreturnCheckBox_OnCheckedChanged" Checked="true" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <br>
                               <br>
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
                            Special Discount</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="pdTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
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
                            <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                <ContentTemplate>
                                    <asp:Button ID="Button1" runat="server" Text="Invoice Generate" OnClick="saveButton_Click" OnClientClick="return confirm('Are you sure you want to Save Return Invoice ?');" />
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


