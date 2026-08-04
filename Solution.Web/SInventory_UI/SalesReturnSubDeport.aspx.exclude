<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="SalesReturnSubDeport.aspx.cs" Inherits="SInventory_UI_SalesReturnSubDeport" %>

<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
  <%--  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js"
        integrity="sha512-rMGGF4wg1R73ehtnxXBt5mbUfN9JUJwbk21KMlnLZDJh7BkPmeovBuddZCENJddHYYMkCh9hPFnPmS9sspki8g=="
        crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.min.css"
        integrity="sha512-yVvxUQV0QESBt1SyZbNJMAwyKvFTLMyXSyBHDO4BG5t7k/Lw34tyqlSDlKIrIENIzCl+RVUNjmCPG+V/GMesRw=="
        crossorigin="anonymous" />--%>
    <style type="text/css">
        /*AutoComplete flyout */
        .autocomplete_completionListElement
        {
            margin: 0px !important;
            background-color: White;
            color: windowtext;
            border: buttonshadow;
            border-width: 1px;
            border-style: solid;
            cursor: default;
            overflow: auto;
            font-family: Calibri;
            font-size: 12px;
            text-align: left;
            list-style-type: none;
            margin-left: 0px;
            padding-left: 0px;
            max-height: 350px;
            width: 40% !important;
        }
        
        /* AutoComplete highlighted item */
        
        .autocomplete_highlightedListItem
        {
            background-color: yellow;
            color: black;
            padding: 1px;
        }
        
        /* AutoComplete item */
        
        .autocomplete_listItem
        {
            background-color: white;
            color: blue;
            padding: 0px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">



      <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Sales Return (Sub-Depot) </div>

                <div class="ms-auto">
                    <div class="btn-group">


                     <asp:LinkButton ID="viewLinkButton"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="viewLinkButton_Click" runat="server"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                    

                              <script type="text/javascript">
                                              function pageLoad() {
                                                  $('.datepicker').pickadate({
                                                      selectMonths: true,
                                                      selectYears: true
                                                  })
                                                  $('.mySelect2').select2({
                                                      theme: 'bootstrap4',
                                                      width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                      placeholder: $(this).data('placeholder'),
                                                      allowClear: Boolean($(this).data('allow-clear')),
                                                  });
                                              }
                              </script>

               
                    <div class="card-body">
                        
                       <div class="row">
                           
                           <div class="col-md-4">
                                   <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  Customer Code  :</label>

                                    <div class="col-sm-7">
                                     
                                <asp:TextBox ID="custCodeTextBox" runat="server" AutoPostBack="True" CssClass="form-control form-control-sm mb-3"
                                    OnTextChanged="custCodeTextBox_TextChanged"></asp:TextBox>
                                <asp:HiddenField ID="hdCustomerMasterId" runat="server" />
                                <asp:HiddenField ID="orderIdHiddenField" runat="server" />
                                <asp:HiddenField ID="orderHiddenField" runat="server" />
                                <asp:HiddenField ID="hdComUnitId" runat="server" />
                                <asp:HiddenField ID="hdMiaId" runat="server" />
                                    
                                    </div>
                                  
                                </div> 


                               <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">   Salse Center :</label>

                                    <div class="col-sm-7">
                                        <asp:TextBox ID="comUnitNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>
                                    
                                  
                                    </div>
                               
                                </div> 

                                    <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">   FE Name:</label>

                                    <div class="col-sm-7">
                                      
                                      <asp:TextBox ID="districtNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>
                                  
                                    </div>
                               
                                </div> 


                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">   Customer Category:</label>

                                    <div class="col-sm-7">
                                        <asp:TextBox ID="custCategoryTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>
                                  
                                  
                                    </div>
                               
                                </div> 


                               
                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">   Invoice No:</label>

                                    <div class="col-sm-7">
                                      
                                  <asp:TextBox ID="ddlInvoice" runat="server" CssClass="form-control form-control-sm mb-3" 
                                                AutoPostBack="True" ToolTip="true" ontextchanged="productCodeTextBox_TextChanged" Text= <%# Eval("InvoiceNo")%>></asp:TextBox>
                                                <asp:AutoCompleteExtender ID="productCodeTextBox1_AutoCompleteExtender" runat="server"
                                                     DelimiterCharacters="" EnableCaching="true"
                                                    Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                                    ServiceMethod="GetAllInvoice" ServicePath="SInventoryWebService.asmx"  TargetControlID="ddlInvoice" 
                                                    UseContextKey="True"
                                                    CompletionListCssClass="autocomplete_completionListElement" 
                                                    CompletionListItemCssClass="autocomplete_listItem" 
                                                    CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                                    ShowOnlyCurrentWordInCompletionListItem="true"
                                                    >
                                                </asp:AutoCompleteExtender>
                                  
                                    </div>
                               
                                </div> 

                             

                              </div>

                             <div class="col-md-4">
                                   <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  Customer Name :</label>

                                    <div class="col-sm-7">
                                      <asp:TextBox ID="custNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3" AutoPostBack="True"
                                    OnTextChanged="custNameTextBox_TextChanged"></asp:TextBox>
                                <asp:AutoCompleteExtender ID="custNameTextBox_AutoCompleteExtender" runat="server"
                                    DelimiterCharacters="" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                    CompletionSetCount="10" ServiceMethod="GetCustomer" ServicePath="SInventoryWebService.asmx"
                                    TargetControlID="custNameTextBox" UseContextKey="True" CompletionListCssClass="autocomplete_completionListElement"
                                    CompletionListItemCssClass="autocomplete_listItem" CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                    ShowOnlyCurrentWordInCompletionListItem="true">
                                </asp:AutoCompleteExtender>
                              
                                    </div>
                                    
                                </div> 


                                   <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label"> MIO Code  :</label>

                                    <div class="col-sm-7">
                                       <asp:TextBox ID="miaCodeTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>
                                  
                                    </div>
                               
                                </div> 

                                 <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  Territory Name:</label>

                                    <div class="col-sm-7">
                                   
                                   <asp:TextBox ID="areaNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>
                                    </div>
                               
                                </div> 


                                 <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label"> Remarks:</label>

                                    <div class="col-sm-7">

                                <asp:TextBox ID="orderNoTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>

                                   
                                  
                                    </div>
                               
                                </div> 


                                 <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label"> Fixed Business Customer ?:</label>

                                    <div class="col-sm-7">
                                        
                                     <asp:CheckBox ID="fixedcustomerCheckBox1" runat="server" />
                                    </div>
                               
                                </div> 

                              </div>
                           <div class="col-md-4">
                                   <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  Customer Address :</label>

                                    <div class="col-sm-7">
                                       <asp:TextBox ID="custAddressTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>
                                  
                                    </div>
                               
                                </div> 

                               
                                    <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label"> MIO Name :</label>

                                    <div class="col-sm-7">
                                     
                                <asp:TextBox ID="miaNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>
                                  
                                    </div>
                               
                                </div> 


                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label"> Merket :</label>

                                    <div class="col-sm-7">
                                 
                                <asp:TextBox ID="marketNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>
                                  
                                    </div>
                               
                                </div> 
 


                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  Invoice Date  :</label>

                                    <div class="col-sm-7">
                                      
                                    <asp:TextBox ID="orderDateTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>
                                    </div>
                               
                                </div> 


                              

                              </div>
                           </div>


                              <br/>
                     <div class="row">
           <div class="table-responsive" id="MainGradeDiv">
        <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False"   CssClass="table table-bordered  text-center thead-dark" OnPreRender="gv_DocumentUpload_PreRender"
                                DataKeyNames="ProductId,UnitPrice">
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:TemplateField HeaderText="Return Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="transferQtyTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderconvRate" runat="server"
                                                Enabled="True" TargetControlID="transferQtyTextBox" FilterType="Custom" ValidChars="0123456789">
                                            </asp:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                           </div>
                           </div>

                   <div class="row">
                        <div class="col-md-8">
                            </div>
                              <div class="col-md-4">
                                   <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label"> </label>

                                    <div class="col-sm-7 pull-right">
                          

                                         <asp:LinkButton ID="addButton" CssClass="btn btn-sm btn-info mb-2  pull-right" runat="server" OnClick="addButton_Click" >   <i class="fa fa-plus"></i>&nbsp; Add to List</asp:LinkButton>
                                        </div>
                                       </div>
                              </div>
                   </div>
                         <br />
                             <div class="row">
           <div class="table-responsive" id="MassinGradeDiv">
                 <asp:GridView ID="gridLineItemGridView" runat="server" AutoGenerateColumns="False"
                                CssClass="table table-bordered  text-center thead-dark" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                    <asp:TemplateField HeaderText="SL" Visible="False">
                                        <ItemTemplate>
                                            <asp:Label ID="slLabel" runat="server" Text='<%# Eval("SL")%>'></asp:Label>
                                            <asp:ImageButton ID="addImageButton" runat="server" ImageUrl="~/images/lineAdd.png"
                                                OnClick="addImageButton_Click" />
                                            <asp:ImageButton ID="removeImageButton" runat="server" ImageUrl="~/images/lineDelete.png"
                                                OnClick="removeImageButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Code">
                                        <ItemTemplate>
                                            <asp:TextBox ID="codeTextBox" runat="server" Text='<%# Eval("ProductCode")%>' CssClass="TextBoxMicroMini"
                                                AutoPostBack="True" OnTextChanged="codeTextBox_TextChanged"></asp:TextBox>
                                            <asp:HiddenField ID="orderdetailIdHiddenField" runat="server" Value='<%# Eval("OrderDetailsId")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Name">
                                        <ItemTemplate>
                                            <asp:TextBox ID="nameTextBox" runat="server" CssClass="TextBox" Text='<%# Eval("ProductName")%>'
                                                AutoPostBack="True" OnTextChanged="nameTextBox_TextChanged"></asp:TextBox>
                                            <asp:AutoCompleteExtender ID="nameTextBox_AutoCompleteExtender" runat="server" DelimiterCharacters=""
                                                EnableCaching="true" Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                                ServiceMethod="GetProduct2" ServicePath="SInventoryWebService.asmx" TargetControlID="nameTextBox"
                                                UseContextKey="True" CompletionListCssClass="autocomplete_completionListElement"
                                                CompletionListItemCssClass="autocomplete_listItem" CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                                ShowOnlyCurrentWordInCompletionListItem="true">
                                            </asp:AutoCompleteExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="CStock">
                                        <ItemTemplate>
                                            <asp:TextBox ID="currentStockTextBox" runat="server" CssClass="TextBoxMicroMini"
                                                Text='<%# Eval("StockQty")%>' ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fcurrentStockTextBox" runat="server" TargetControlID="currentStockTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="UP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="unitPriceTextBox" runat="server" CssClass="TextBoxMicroMini" Text='<%# Eval("UnitPrice")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="funitPriceTextBox" runat="server" TargetControlID="unitPriceTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="UVAT">
                                        <ItemTemplate>
                                            <asp:TextBox ID="upVatTextBox" runat="server" CssClass="TextBoxMicroMini" Text='<%# Eval("UnitVAT")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fupVatTextBox" runat="server" TargetControlID="upVatTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="qtyTextBox" runat="server" CssClass="TextBoxMicroMini" ReadOnly="True"
                                                Text='<%# Eval("Quantity")%>' AutoPostBack="True" OnTextChanged="qtyTextBox_TextChanged"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fqtyTextBox" runat="server" TargetControlID="qtyTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="TP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="tpTextBox" runat="server" CssClass="TextBoxMicroMini" Text='<%# Eval("TotalPrice")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="ftpTextBox" runat="server" TargetControlID="tpTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="DP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="dpTextBox" runat="server" CssClass="TextBoxMicroMini" Text='<%# Eval("DiscountPercentage")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fdpTextBox" runat="server" TargetControlID="dpTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="DAmt">
                                        <ItemTemplate>
                                            <asp:TextBox ID="dpAmtTextBox" runat="server" CssClass="TextBoxMicroMini" Text='<%# Eval("DiscountAmount")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fdpAmtTextBox" runat="server" TargetControlID="dpAmtTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="SD">
                                        <ItemTemplate>
                                            <asp:TextBox ID="sdTextBox" runat="server" CssClass="TextBoxMicroMini" Text='<%# Eval("SpecialAmount")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fsdTextBox" runat="server" TargetControlID="sdTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="TPVAT">
                                        <ItemTemplate>
                                            <asp:TextBox ID="tpVatTextBox" runat="server" CssClass="TextBoxMicroMini" Text='<%# Eval("VAT")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="ftpVatTextBox" runat="server" TargetControlID="tpVatTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="NP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="npTextBox" runat="server" CssClass="TextBoxMicroMini" Text='<%# Eval("NetPrice")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fnpTextBox" runat="server" TargetControlID="npTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="BQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="bQtyTextBox" runat="server" CssClass="TextBoxMicroMini" Text='<%# Eval("BonusQty")%>'
                                                AutoPostBack="True" OnTextChanged="bQtyTextBox_TextChanged" ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fbQtyTextBox" runat="server" TargetControlID="bQtyTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="TQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="tQtyTextBox" runat="server" CssClass="TextBoxMicroMini" Text='<%# Eval("TotalQty")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <%--   <asp:FilteredTextBoxExtender ID="ftQtyTextBox" runat="server"
                                                        TargetControlID="tQtyTextBox"         
                                                        FilterType="Custom, Numbers"  ReadOnly="True"
                                                        ValidChars="." />--%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Expairy Date">
                                        <ItemTemplate>
                                            <asp:TextBox ID="expDateTextBox" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                                            <asp:CalendarExtender ID="fromDate" runat="server" Format="dd-MMM-yyyy" PopupButtonID="imgoDate"
                                                TargetControlID="expDateTextBox">
                                            </asp:CalendarExtender>
                                            <asp:ImageButton ID="imgoDate" runat="server" AlternateText="Click to show calendar"
                                                ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="4" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Batch No">
                                        <ItemTemplate>
                                            <asp:TextBox ID="batchNoTextBox" runat="server" CssClass="TextBox" Height="21px"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="add" runat="server" Visible="False">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="addImageButton2" runat="server" ImageUrl="~/images/lineAdd.png"
                                                OnClick="addImageButton_Click" />
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
                                                <div class="col-2">&nbsp;</div>
                                                <div class="col-8">

                                                    <div class="form-group row">
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label">TP Total:</label>
                                                        <div class="col-sm-8">
                                                               <asp:TextBox ID="tpTptalTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>
                                                        </div>
                                                    </div>


                                                      <div class="form-group row">
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label">Discount Total:</label>
                                                        <div class="col-sm-8">
                                                             <asp:TextBox ID="disTotalTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>
                                                        </div>
                                                    </div>


                                                       <div class="form-group row">
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"> Special Discount:</label>
                                                        <div class="col-sm-8">
                                                            
                            <asp:TextBox ID="pdTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>

                                                        </div>
                                                    </div>


                                                      <div class="form-group row">
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label">  	VAT Total :</label>
                                                        <div class="col-sm-8">
                                                           
                            <asp:TextBox ID="vatTotalTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>

                                                        </div>
                                                    </div>


                                                     <div class="form-group row">
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label">  	 	Grand Total :</label>
                                                        <div class="col-sm-8">
                                                             
                            <asp:TextBox ID="grandTotalTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>

                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="col-2">&nbsp;</div>
                                            </div>


                                <br />
                                            <div class="row">
                                                <div class="col-2">&nbsp;</div>
                                                <div class="col-8">

                                                    <div class="form-group row">
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                        <div class="col-sm-8">

                                                                
                                                              <asp:LinkButton  OnClick="submitButton_Click" OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                           
                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="col-2">&nbsp;</div>
                                            </div>


                           <br />
                                            <div class="row">
                                                <div class="col-1">&nbsp;</div>
                                                <div class="col-8">

                                                    <div class="form-group row">
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label">Print InvNo :</label>
                                                        <div class="col-sm-6">
                                                            <asp:TextBox ID="invTextBox" runat="server" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                                                             
                                                        </div>
                                                          <div class="col-sm-2"> 
                                                                <asp:LinkButton ID="printButton" CssClass="btn btn-sm btn-success mb-2  pull-right" runat="server" OnClick="printButton_Click" >   <i class="fa fa-print"></i>&nbsp; Print</asp:LinkButton>
                                                              </div>
                                                    </div>
                                                    </div>
                                                    </div>
                           </div>
                           </div>
                           </div>
                           </div>
                           </div>
                 </ContentTemplate>
          </asp:UpdatePanel>
 
</asp:Content>
