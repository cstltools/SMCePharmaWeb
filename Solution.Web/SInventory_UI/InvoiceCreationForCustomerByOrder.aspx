<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="True" CodeFile="InvoiceCreationForCustomerByOrder.aspx.cs" Inherits="SInventory_UI_InvoiceCreationForCustomer" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">




    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Invoice Creation</div>

                <div class="ms-auto">
                    <div class="btn-group">

                        <asp:LinkButton ID="viewLinkButton" class="btn btn-sm btn-sm btn-outline-info"
                            OnClick="backLinkButton_Click" runat="server"><i class="fa fa-backward"></i>&nbsp Back To List</asp:LinkButton>



                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                      <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
                                    <div class="row">




                                        <div class="card-body">
                                            <br />



                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-2 col-form-label">Customer Code:</label>

                                                <div class="col-sm-2">
                                                    <asp:TextBox ID="custCodeTextBox" runat="server" AutoPostBack="True" ReadOnly="True"
                                                        CssClass="form-control form-control-sm " OnTextChanged="custCodeTextBox_TextChanged"></asp:TextBox>


                                                </div>

                                                <label for="mainName" class="col-sm-2 col-form-label">Customer Name	:</label>

                                                <div class="col-sm-2">
                                                    <asp:TextBox ID="custNameTextBox" runat="server" CssClass="form-control form-control-sm " ReadOnly="True"
                                                        AutoPostBack="True" OnTextChanged="custNameTextBox_TextChanged"></asp:TextBox>

                                                    <asp:AutoCompleteExtender ID="custNameTextBox_AutoCompleteExtender" runat="server"
                                                        DelimiterCharacters="" EnableCaching="True"
                                                        Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                                        ServiceMethod="GetCustomer" ServicePath="SInventoryWebService.asmx" TargetControlID="custNameTextBox"
                                                        UseContextKey="True"
                                                        CompletionListCssClass="autocomplete_completionListElement"
                                                        CompletionListItemCssClass="autocomplete_listItem"
                                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                                        ShowOnlyCurrentWordInCompletionListItem="True">
                                                    </asp:AutoCompleteExtender>




                                                </div>


                                                <label for="mainName" class="col-sm-2 col-form-label">Customer Address:</label>

                                                <div class="col-sm-2">
                                                    <asp:TextBox ID="custAddressTextBox" runat="server" CssClass="form-control "
                                                        ReadOnly="True" TextMode="MultiLine" Rows="1"></asp:TextBox>




                                                </div>

                                            </div>

                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-2 col-form-label">Salse Center:</label>

                                                <div class="col-sm-2">

                                                    <asp:TextBox ID="comUnitNameTextBox" runat="server" CssClass="form-control form-control-sm "
                                                        ReadOnly="True"></asp:TextBox>


                                                </div>

                                                <label for="mainName" class="col-sm-2 col-form-label">MIO Code:</label>

                                                <div class="col-sm-2">
                                                    <asp:TextBox ID="miaCodeTextBox" runat="server" CssClass="form-control form-control-sm "
                                                        ReadOnly="True"></asp:TextBox>


                                                </div>

                                                <label for="mainName" class="col-sm-2 col-form-label">MIO Name:</label>

                                                <div class="col-sm-2">
                                                    <asp:TextBox ID="miaNameTextBox" runat="server" CssClass="form-control form-control-sm "
                                                        ReadOnly="True"></asp:TextBox>

                                                </div>



                                            </div>

                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-2 col-form-label">FE Name:</label>

                                                <div class="col-sm-2">

                                                    <asp:TextBox ID="districtNameTextBox" runat="server" CssClass="form-control form-control-sm "
                                                        ReadOnly="True"></asp:TextBox>


                                                </div>

                                                <label for="mainName" class="col-sm-2 col-form-label">Territory Name:</label>

                                                <div class="col-sm-2">
                                                    <asp:TextBox ID="areaNameTextBox" runat="server" CssClass="form-control form-control-sm "
                                                        ReadOnly="True"></asp:TextBox>


                                                </div>

                                                <label for="mainName" class="col-sm-2 col-form-label">Merket:</label>

                                                <div class="col-sm-2">
                                                    <asp:TextBox ID="marketNameTextBox" runat="server" CssClass="form-control form-control-sm "
                                                        ReadOnly="True"></asp:TextBox>

                                                </div>



                                            </div>



                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-2 col-form-label">Invoice Date:</label>

                                                <div class="col-sm-2">

                                                    <asp:TextBox ID="invDateTextBox" runat="server" CssClass="form-control form-control-sm "
                                                        ReadOnly="True"></asp:TextBox>

                                                </div>

                                                <label for="mainName" class="col-sm-2 col-form-label">Order No:</label>

                                                <div class="col-sm-2">
                                                    <asp:TextBox ID="orderNoTextBox" runat="server" CssClass="form-control form-control-sm " ReadOnly="True"></asp:TextBox>


                                                </div>

                                                <label for="mainName" class="col-sm-2 col-form-label">Order Date:</label>

                                                <div class="col-sm-2">
                                                    <asp:TextBox ID="orderDateTextBox" runat="server" CssClass="form-control form-control-sm " ReadOnly="True"></asp:TextBox>

                                                </div>



                                            </div>


                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-2 col-form-label">Customer Category:</label>

                                                <div class="col-sm-2">

                                                    <asp:TextBox ID="custCategoryTextBox" runat="server" CssClass="form-control form-control-sm "
                                                        ReadOnly="True"></asp:TextBox>


                                                </div>

                                                <label for="mainName" class="col-sm-2 col-form-label">Payment Type:</label>

                                                <div class="col-sm-2">
                                                    <asp:DropDownList ID="payTypeDDL" runat="server" CssClass="form-control form-control-sm ">
                                                    </asp:DropDownList>


                                                </div>

                                                <label for="mainName" class="col-sm-2 col-form-label">Remarks:</label>

                                                <div class="col-sm-2">
                                                    <asp:TextBox ID="remarksTextBox" runat="server" CssClass="form-control form-control-sm "></asp:TextBox>

                                                </div>



                                            </div>


                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-2 col-form-label">Provider Type:</label>

                                                <div class="col-sm-2">

                                                    <asp:TextBox ID="cusTypeTextBox" runat="server" CssClass="form-control form-control-sm "></asp:TextBox>

                                                </div>

                                                <label for="mainName" class="col-sm-2 col-form-label">Delivery Person Name:</label>

                                                <div class="col-sm-2">
                                                    <asp:TextBox ID="deliverypersonNameTextBox" runat="server" CssClass="form-control form-control-sm "></asp:TextBox>

                                                </div>

                                                <label for="mainName" class="col-sm-2 col-form-label">Delivery Person Mob. No:</label>

                                                <div class="col-sm-2">
                                                    <asp:TextBox ID="deliverypersonMobileTextBox" runat="server" CssClass="form-control form-control-sm "></asp:TextBox>

                                                </div>



                                            </div>

                                            <div class="form-group row" style="margin-top:15px">
    <label for="mainName" class="col-sm-3 col-form-label"> DA Name:</label>

    <div class="col-sm-5">


         <asp:DropDownList  runat="server"  class="form-select form-select-sm mb-3 mySelect2 " id="ddlDAName" ></asp:DropDownList>

          <script type="text/javascript">
      function pageLoad() {
          $('.mySelect2').select2({
              theme: 'bootstrap4',
              width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
              placeholder: $(this).data('placeholder'),
              allowClear: Boolean($(this).data('allow-clear')),
          });
          $('.datepicker').pickadate({
              selectMonths: true,
              selectYears: true
          })

      }
          </script>
    </div>
    <span class="text-sm-left text-c-red">*</span>
</div>
            

                                            <br />
                                            <div class="row">
                                                <div class="table-responsive" id="MainGradeDiv">
                                                    <asp:GridView ID="gridLineItemGridView" runat="server"
                                                        AutoGenerateColumns="False" CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender" DataKeyNames="ISGiftProduct">
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="SL" Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="slLabel" runat="server" Text='<%# Eval("SL")%>'></asp:Label>
                                                                    <asp:ImageButton ID="addImageButton" runat="server"
                                                                        ImageUrl="~/images/lineAdd.png" OnClick="addImageButton_Click" />
                                                                    <asp:ImageButton ID="removeImageButton" runat="server"
                                                                        ImageUrl="~/images/lineDelete.png" OnClick="removeImageButton_Click" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Code">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="codeTextBox" runat="server" Text='<%# Eval("ProductCode")%>'
                                                                        CssClass="form-control form-control-sm " AutoPostBack="True"
                                                                        OnTextChanged="codeTextBox_TextChanged"></asp:TextBox>
                                                                    <asp:HiddenField ID="orderdetailIdHiddenField" runat="server" Value='<%# Eval("OrderDetailsId")%>' />
                                                                    <asp:HiddenField ID="CampaignTypeHiddenField" runat="server" Value='<%# Eval("CampaignType")%>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Product Name">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="nameTextBox" runat="server" ReadOnly="true" TextMode="MultiLine" CssClass="form-control-sm "
                                                                        Text='<%# Eval("ProductName")%>' AutoPostBack="True"
                                                                        OnTextChanged="nameTextBox_TextChanged"></asp:TextBox>
                                                                    <asp:AutoCompleteExtender ID="nameTextBox_AutoCompleteExtender" runat="server"
                                                                        DelimiterCharacters="" EnableCaching="True"
                                                                        Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                                                        ServiceMethod="GetProduct2" ServicePath="SInventoryWebService.asmx" TargetControlID="nameTextBox"
                                                                        UseContextKey="True"
                                                                        CompletionListCssClass="autocomplete_completionListElement"
                                                                        CompletionListItemCssClass="autocomplete_listItem"
                                                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                                                        ShowOnlyCurrentWordInCompletionListItem="True">
                                                                    </asp:AutoCompleteExtender>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="CStock">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="currentStockTextBox" runat="server"
                                                                        CssClass="form-control form-control-sm " Text='<%# Eval("StockQty")%>' ReadOnly="True"></asp:TextBox>
                                                                    <asp:FilteredTextBoxExtender ID="fcurrentStockTextBox" runat="server"
                                                                        TargetControlID="currentStockTextBox"
                                                                        FilterType="Custom, Numbers"
                                                                        ValidChars="." />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="UP">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="unitPriceTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                        Text='<%# Eval("UnitPrice")%>' ReadOnly="True"></asp:TextBox>
                                                                    <asp:FilteredTextBoxExtender ID="funitPriceTextBox" runat="server"
                                                                        TargetControlID="unitPriceTextBox"
                                                                        FilterType="Custom, Numbers"
                                                                        ValidChars="." />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="UVAT">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="upVatTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                        Text='<%# Eval("UnitVAT")%>' ReadOnly="True"></asp:TextBox>
                                                                    <asp:FilteredTextBoxExtender ID="fupVatTextBox" runat="server"
                                                                        TargetControlID="upVatTextBox"
                                                                        FilterType="Custom, Numbers"
                                                                        ValidChars="." />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Qty">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="qtyTextBox" runat="server" CssClass="form-control form-control-sm " ReadOnly="True"
                                                                        Text='<%# Eval("Quantity")%>' AutoPostBack="True"
                                                                        OnTextChanged="qtyTextBox_TextChanged"></asp:TextBox>
                                                                    <asp:FilteredTextBoxExtender ID="fqtyTextBox" runat="server"
                                                                        TargetControlID="qtyTextBox"
                                                                        FilterType="Custom, Numbers"
                                                                        ValidChars="." />

                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="TP">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="tpTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                        Text='<%# Eval("TotalPrice")%>' ReadOnly="True"></asp:TextBox>
                                                                    <asp:FilteredTextBoxExtender ID="ftpTextBox" runat="server"
                                                                        TargetControlID="tpTextBox"
                                                                        FilterType="Custom, Numbers"
                                                                        ValidChars="." />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="DP">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="dpTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                        Text='<%# Eval("DiscountPercentage")%>' ReadOnly="True"></asp:TextBox>
                                                                    <asp:FilteredTextBoxExtender ID="fdpTextBox" runat="server"
                                                                        TargetControlID="dpTextBox"
                                                                        FilterType="Custom, Numbers"
                                                                        ValidChars="." />

                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="DAmt">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="dpAmtTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                        Text='<%# Eval("DiscountAmount")%>' ReadOnly="True"></asp:TextBox>
                                                                    <asp:FilteredTextBoxExtender ID="fdpAmtTextBox" runat="server"
                                                                        TargetControlID="dpAmtTextBox"
                                                                        FilterType="Custom, Numbers"
                                                                        ValidChars="." />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="SD">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="sdTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                        Text='<%# Eval("IsCampaignProduct")%>' ReadOnly="True"></asp:TextBox>
                                                                    <%-- <asp:FilteredTextBoxExtender ID="fsdTextBox" runat="server"
                                                        TargetControlID="sdTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />--%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="TPVAT">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="tpVatTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                        Text='<%# Eval("VAT")%>' ReadOnly="True"></asp:TextBox>
                                                                    <asp:FilteredTextBoxExtender ID="ftpVatTextBox" runat="server"
                                                                        TargetControlID="tpVatTextBox"
                                                                        FilterType="Custom, Numbers"
                                                                        ValidChars="." />

                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="NP">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="npTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                        Text='<%# Eval("NetPrice")%>' ReadOnly="True"></asp:TextBox>
                                                                    <asp:FilteredTextBoxExtender ID="fnpTextBox" runat="server"
                                                                        TargetControlID="npTextBox"
                                                                        FilterType="Custom, Numbers"
                                                                        ValidChars="." />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="BQty">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="bQtyTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                        Text='<%# Eval("ISGiftProduct")%>' AutoPostBack="True"
                                                                        OnTextChanged="bQtyTextBox_TextChanged" ReadOnly="True"></asp:TextBox>
                                                                    <asp:FilteredTextBoxExtender ID="fbQtyTextBox" runat="server"
                                                                        TargetControlID="bQtyTextBox"
                                                                        FilterType="Custom, Numbers"
                                                                        ValidChars="." />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="TQty">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="tQtyTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                        Text='<%# Eval("TotalQty")%>' ReadOnly="True"></asp:TextBox>
                                                                    <%--   <asp:FilteredTextBoxExtender ID="ftQtyTextBox" runat="server"
                                                        TargetControlID="tQtyTextBox"         
                                                        FilterType="Custom, Numbers"  ReadOnly="True"
                                                        ValidChars="." />--%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="A.M">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="amTextBox" runat="server" CssClass="form-control form-control-sm "></asp:TextBox>
                                                                    <%--   <asp:FilteredTextBoxExtender ID="ftQtyTextBox" runat="server"
                                                        TargetControlID="tQtyTextBox"         
                                                        FilterType="Custom, Numbers"  ReadOnly="True"
                                                        ValidChars="." />--%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <%--  <asp:TemplateField HeaderText="Campaign Type">
                                        <ItemTemplate>
                                            <asp:TextBox ID="CampaignTypeHiddenField" runat="server" CssClass="form-control form-control-sm " 
                                                Text= <%# Eval("CampaignType")%> ></asp:TextBox>
                                      
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                                            <asp:TemplateField HeaderText="add" runat="server" Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:ImageButton ID="addImageButton2" runat="server"
                                                                        ImageUrl="~/images/lineAdd.png" OnClick="addImageButton_Click" />
                                                                    <%-- <asp:ImageButton ID="removeImageButton" runat="server" 
                                                ImageUrl="~/images/lineDelete.png" onclick="removeImageButton_Click" />--%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>

                                                </div>
                                            </div>

                                            <br />
                                            <div class="row">
                                                <div class="col-4">&nbsp;</div>
                                                <div class="col-6">
                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">TP Total:</label>

                                                        <div class="col-sm-5">

                                                            <asp:TextBox ID="tpTptalTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                ReadOnly="True"></asp:TextBox>



                                                        </div>

                                                    </div>


                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Discount Total:</label>

                                                        <div class="col-sm-5">

                                                            <asp:TextBox ID="disTotalTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                ReadOnly="True"></asp:TextBox>


                                                        </div>

                                                    </div>


                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Special Discount:</label>

                                                        <div class="col-sm-5">

                                                            <asp:TextBox ID="pdTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                ReadOnly="True"></asp:TextBox>


                                                        </div>

                                                    </div>


                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">VAT Total:</label>

                                                        <div class="col-sm-5">

                                                            <asp:TextBox ID="vatTotalTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                ReadOnly="True"></asp:TextBox>


                                                        </div>

                                                    </div>

                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Grand Total:</label>

                                                        <div class="col-sm-5">

                                                            <asp:TextBox ID="grandTotalTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                ReadOnly="True"></asp:TextBox>



                                                        </div>

                                                    </div>


                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Credit Amount:</label>

                                                        <div class="col-sm-5">

                                                            <asp:TextBox ID="crAmountTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                ReadOnly="True"></asp:TextBox>



                                                        </div>

                                                    </div>



                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Receivable Amount:</label>

                                                        <div class="col-sm-5">

                                                            <asp:TextBox ID="rcvAmountTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                ReadOnly="True"></asp:TextBox>



                                                        </div>

                                                    </div>



                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Adjust Return Invoice No:</label>

                                                        <div class="col-sm-5">

                                                            <asp:TextBox ID="adjustInvoiceNoTextBox" runat="server" CssClass="form-control form-control-sm "
                                                                ReadOnly="false"></asp:TextBox>



                                                        </div>

                                                    </div>

                                                </div>


                                            </div>



                                            <br />
                                            <div class="row">
                                                <div class="col-4">&nbsp;</div>
                                                <div class="col-6">

                                                    <div class="form-group row">
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                        <div class="col-sm-8">

                                                            <asp:LinkButton ID="submitButton" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClientClick="return submitButton_ClientClick(this);" OnClick="saveButton_Click" Style="background-color: #00bcd4; color: #fff;"
                                                               > <i class="fa fa-check-square"></i>&nbsp; Invoice Generate</asp:LinkButton>

 <%--OnClientClick="return sweetAlertConfirm_Submit(this);"--%>
                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="col-2">&nbsp;</div>
                                            </div>

                                            <script type="text/javascript">
                                                // Prevent double-click / repeated submits: once the user confirms and the
                                                // button is actually posting back, disable it until the async postback ends.
                                                function submitButton_ClientClick(btnSave) {
                                                    if (btnSave.dataset.submitting === "true") {
                                                        return false;
                                                    }
                                                    var result = sweetAlertConfirm_Submit(btnSave);
                                                    if (result === true) {
                                                        btnSave.dataset.submitting = "true";
                                                        btnSave.classList.add("disabled");
                                                        btnSave.style.pointerEvents = "none";
                                                    }
                                                    return result;
                                                }

                                                if (typeof Sys !== "undefined" && Sys.WebForms && Sys.WebForms.PageRequestManager) {
                                                    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                                                        var btnSave = document.getElementById('<%= submitButton.ClientID %>');
                                                        if (btnSave) {
                                                            btnSave.dataset.submitting = "false";
                                                            btnSave.classList.remove("disabled");
                                                            btnSave.style.pointerEvents = "";
                                                        }
                                                    });
                                                }
                                            </script>

                                            <br />

                                            <div class="row">
                                                <div class="col-3">&nbsp;</div>
                                                <div class="col-8">
                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Print Inv No:</label>

                                                        <div class="col-sm-5">

                                                            <asp:TextBox ID="invTextBox" runat="server" CssClass="form-control form-control-sm "></asp:TextBox>



                                                        </div>
                                                        <div class="col-sm-2">
                                                            <asp:LinkButton ID="printButton" runat="server" class="btn btn-sm btn-info" OnClick="printButton_Click"><i class="fa fa-print"></i>&nbsp; Print</asp:LinkButton>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>


                            <asp:UpdatePanel ID="UpdatePanel1" runat="server" Visible="False">
                                <ContentTemplate>
                                    <div>
                                        <table width="100%" class="TableWorkArea">
                                            <tr>
                                                <td colspan="6" class="TableHeading">Proforma Invoice Creation</td>
                                            </tr>
                                            <tr>
                                                <td class="TDLeft" width="13%">
                                                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="InvoiceCreationByOrder.aspx">Back to List</asp:HyperLink>
                                                </td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td width="13%" class="TDLeft">Customer Code</td>
                                                <td width="20%" class="TDRight"></td>
                                                <td width="13%" class="TDLeft">CustomerName</td>
                                                <td width="20%" class="TDRight"></td>
                                                <td width="13%" class="TDLeft">Customer Address</td>
                                                <td width="20%" class="TDRight"></td>
                                            </tr>
                                            <tr>
                                                <td width="13%" class="TDLeft">Salse Center</td>
                                                <td width="20%" class="TDRight"></td>
                                                <td width="13%" class="TDLeft">MIO Code</td>
                                                <td width="20%" class="TDRight"></td>
                                                <td width="13%" class="TDLeft">MIO Name</td>
                                                <td width="20%" class="TDRight"></td>
                                            </tr>
                                            <tr>
                                                <td width="13%" class="TDLeft">FE Name
                                                </td>
                                                <td width="20%" class="TDRight"></td>
                                                <td width="13%" class="TDLeft">Territory Name</td>
                                                <td width="20%" class="TDRight"></td>
                                                <td width="13%" class="TDLeft">Merket</td>
                                                <td width="20%" class="TDRight"></td>
                                            </tr>

                                            <tr>
                                                <td width="13%" class="TDLeft">Invoice Date</td>
                                                <td width="20%" class="TDRight"></td>
                                                <td width="13%" class="TDLeft">Order No</td>
                                                <td width="20%" class="TDRight"></td>
                                                <td width="13%" class="TDLeft">Order Date</td>
                                                <td width="20%" class="TDRight">

                                                    <%-- <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgorderDate"></asp:ImageButton>
                            <asp:CalendarExtender ID="orderDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="orderDateTextBox"
                                PopupButtonID="imgorderDate">
                            </asp:CalendarExtender>--%>
                                                </td>
                                            </tr>
                                            <tr>

                                                <td width="13%" class="TDLeft">Customer Category
                                                </td>
                                                <td width="20%" class="TDRight"></td>
                                                <td width="13%" class="TDLeft">Payment Type</td>
                                                <td width="20%" class="TDRight"></td>
                                                <td width="13%" class="TDLeft">Remarks</td>
                                                <td width="20%" class="TDRight"></td>
                                            </tr>
                                            <tr>


                                                <td width="13%" class="TDLeft">Customer Type
                                                </td>
                                                <td width="20%" class="TDRight"></td>

                                                <td width="13%" class="TDLeft">Delivery Person Name  
                                                </td>
                                                <td width="20%" class="TDRight"></td>


                                                <td width="13%" class="TDLeft">Delivery Person Mob.No   </td>
                                                <td width="20%" class="TDRight"></td>
                                                <td width="13%" class="TDLeft"></td>
                                                <td width="20%" class="TDRight"></td>
                                            </tr>
                                            <tr>
                                                <td class="TDLeft" width="13%">
                                                    <asp:HiddenField ID="orderIdHiddenField" runat="server" />
                                                </td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="TDLeft" width="13%" colspan="6">

                                                    <br />

                                                </td>

                                            </tr>

                                            <tr>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">TP Total</td>
                                                <td class="TDRight" width="20%"></td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">Discount Total</td>
                                                <td class="TDRight" width="20%"></td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">Special Discount</td>
                                                <td class="TDRight" width="20%"></td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">VAT Total</td>
                                                <td class="TDRight" width="20%"></td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                            </tr>

                                            <tr>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">Grand Total</td>
                                                <td class="TDRight" width="20%"></td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">Credit Amount</td>
                                                <td class="TDRight" width="20%"></td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">Receivable Amount</td>
                                                <td class="TDRight" width="20%"></td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">Adjust Return Invoice No</td>
                                                <td class="TDRight" width="20%"></td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">
                                                    <asp:Label ID="warningLabel" runat="server" Font-Bold="True" Font-Italic="True"
                                                        Font-Size="Small" ForeColor="#FF3300"></asp:Label>
                                                </td>
                                                <td class="TDRight" width="20%">&nbsp;
                                                </td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">
                                                    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                                        <ContentTemplate>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                    <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="UpdatePanel3"
                                                        DisplayAfter="0" DynamicLayout="True">
                                                        <ProgressTemplate>
                                                            <center>
                                                                <asp:Image ID="Img2" runat="server" ImageUrl="~/Images/ajax-loader.gif" />
                                                            </center>
                                                        </ProgressTemplate>
                                                    </asp:UpdateProgress>

                                                </td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">Print InvNo</td>
                                                <td class="TDRight" width="20%"></td>
                                                <td class="TDLeft" width="13%"></td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="TDLeft" width="13%">
                                                    <asp:HiddenField ID="hdCustomerMasterId" runat="server" />
                                                    <asp:HiddenField ID="hdComUnitId" runat="server" />

                                                </td>
                                                <td class="TDRight" width="20%">
                                                    <asp:HiddenField ID="hdMiaId" runat="server" />
                                                    <asp:HiddenField ID="orderHiddenField" runat="server" />
                                                </td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                                <td class="TDLeft" width="13%">&nbsp;</td>
                                                <td class="TDRight" width="20%">&nbsp;</td>
                                            </tr>
                                        </table>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


