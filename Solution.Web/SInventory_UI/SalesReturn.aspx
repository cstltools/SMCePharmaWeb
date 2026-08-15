<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"  AutoEventWireup="true" CodeFile="SalesReturn.aspx.cs" Inherits="SInventory_UI_SalesReturn" %>

<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
 </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <%--  <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>

                 <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>--%>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Sales Return </div>

                <div class="ms-auto">
                    <div class="btn-group">


                     <asp:LinkButton ID="viewLinkButton"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="ListImageButton_Click" runat="server"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>
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
                        <style>
                               .radioChoice label {
            padding-left: 3px;
            padding-right: 3px;
            font-size: 17px;
            font-weight: bold;
        }
                        </style>
               
                    <div class="card-body">
                        
                       <div class="row">
                           
                           <div class="col-md-6">

                                                                                    
                                   <div class="form-group row">
                                    <label for="mainName" class="col-sm-5 col-form-label">   Customer Code :</label>

                                    <div class="col-sm-5">

                                               
                         <asp:TextBox ID="custCodeTextBox" runat="server" AutoPostBack="True" CssClass="form-control form-control-sm"
                                    OnTextChanged="custCodeTextBox_TextChanged"></asp:TextBox>
                        
                                  <asp:HiddenField ID="hdCustomerMasterId" runat="server" />
                                <asp:HiddenField ID="orderIdHiddenField" runat="server" />
                                <asp:HiddenField ID="orderHiddenField" runat="server" />
                                <asp:HiddenField ID="hdComUnitId" runat="server" />
                                <asp:HiddenField ID="hdMiaId" runat="server" />

                                <asp:HiddenField ID="hfMIOId" runat="server" />
                                <asp:HiddenField ID="hfMioEmpId" runat="server" />
                                <asp:HiddenField ID="hfTerriId" runat="server" />
                                <asp:HiddenField ID="hfSapCode" runat="server" />

                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                   <div class="form-group row">
                                    <label for="mainName" class="col-sm-5 col-form-label">   Customer Name :</label>

                                    <div class="col-sm-5">
                                                           
                                <asp:TextBox ID="custNameTextBox" runat="server" CssClass="form-control form-control-sm" AutoPostBack="True"
                                    OnTextChanged="custNameTextBox_TextChanged"></asp:TextBox>
                                <asp:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server"
                                    DelimiterCharacters="" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                    CompletionSetCount="10" ServiceMethod="GetCustomer" ServicePath="SInventoryWebService.asmx"
                                    TargetControlID="custNameTextBox" UseContextKey="True" CompletionListCssClass="autocomplete_completionListElement"
                                    CompletionListItemCssClass="autocomplete_listItem" CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                    ShowOnlyCurrentWordInCompletionListItem="true">
                                </asp:AutoCompleteExtender>

                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                   <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  Customer Address :</label>

                                    <div class="col-sm-5">
                                     
                             
                                    <asp:TextBox ID="custAddressTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="True"></asp:TextBox>
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 
                     
                                 <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  MIO Name :</label>

                                    <div class="col-sm-5">
                                     
                             
                                    <asp:Label ID="lblMioInfo" runat="server" CssClass="form-control form-control-sm"  ></asp:Label>
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 


                     
                                  <div class="form-group row" runat="server" visible="false">
                                    <label for="mainName" class="col-sm-5 col-form-label">   Sales Center :</label>

                                    <div class="col-sm-5">
                                         
                                          <asp:TextBox ID="comUnitNameTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="True"></asp:TextBox>

                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                  <div class="form-group row" runat="server" visible="false">
                                    <label for="mainName" class="col-sm-5 col-form-label">   MIO Code :</label>

                                    <div class="col-sm-5">
                                                           
                                       <asp:TextBox ID="miaCodeTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="True"></asp:TextBox>

                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                  <div class="form-group row"  runat="server" visible="false">
                                    <label for="" class="col-sm-5 col-form-label">  MIO Name :</label>

                                    <div class="col-sm-5">
                                     
                                    <asp:TextBox ID="miaNameTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="True"></asp:TextBox>
                           
                           
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 


                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">Fixed Business Customer:</label>

                                    <div class="col-sm-5">
                                     
                                   
                         
                                      <asp:CheckBox ID="fixedcustomerCheckBox1" runat="server" />
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>

                     


                                </div>  

                           <div class="col-md-6">
                                                        
                                   <div class="form-group row" runat="server" visible="false">
                                    <label for="mainName" class="col-sm-5 col-form-label"> FE Name :</label>

                                    <div class="col-sm-5">

                                               <asp:TextBox ID="districtNameTextBox" runat="server" CssClass="form-control form-control-sm " ReadOnly="True"></asp:TextBox>
                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                   <div class="form-group row"  runat="server" visible="false">
                                    <label for="mainName" class="col-sm-5 col-form-label">   Territory Name :</label>

                                    <div class="col-sm-5">
                                                           
                                         <asp:TextBox ID="areaNameTextBox" runat="server" CssClass="form-control form-control-sm " ReadOnly="True"></asp:TextBox>

                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                   <div class="form-group row"  runat="server" visible="false">
                                    <label for="" class="col-sm-5 col-form-label"> Market :</label>

                                    <div class="col-sm-5">
                                     
                                          <asp:TextBox ID="marketNameTextBox" runat="server" CssClass="form-control form-control-sm " ReadOnly="True"></asp:TextBox>
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 
                     
                                   <div class="form-group row"  runat="server" visible="false">
                                    <label for="mainName" class="col-sm-5 col-form-label"> Customer Category Name :</label>

                                    <div class="col-sm-5">

                                         <asp:TextBox ID="custCategoryTextBox" runat="server" CssClass="form-control form-control-sm " ReadOnly="True"></asp:TextBox>
                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                   <div class="form-group row">
                                    <label for="mainName" class="col-sm-5 col-form-label">   Remarks  :</label>

                                    <div class="col-sm-5">
                                                           
                                         <asp:TextBox ID="orderNoTextBox" runat="server" CssClass="form-control form-control-sm " ReadOnly="True"></asp:TextBox>

                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                   <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label"> Invoice Date :</label>

                                    <div class="col-sm-5">
                                                         
                                       <asp:TextBox ID="orderDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker" ReadOnly="True"></asp:TextBox>
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 



                                      <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  </label>

                                    <div class="col-sm-5">
                                                         
                                    <asp:RadioButtonList RepeatLayout="Table"   ID="rbTypePrice" CssClass="radioChoice" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem>Old Price</asp:ListItem>
                                        <asp:ListItem Selected="True">New Price</asp:ListItem>

                                    </asp:RadioButtonList>
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 


                                                 
                                </div>  

                         </div>  
                                                                
                        <br />

                         <div class="Col-md-12">
                               <div class="table-responsive" id="MainGradeDiv">
                          <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered  text-center thead-dark" 
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
                                            <asp:TextBox ID="transferQtyTextBox" runat="server" CssClass="form-control form-control-sm mb-3 "   Height="21px"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderconvRate" runat="server"
                                                Enabled="True" TargetControlID="transferQtyTextBox" FilterType="Custom" ValidChars="0123456789">
                                            </asp:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>


                         </div>
                         </div>

                        <br />

                         <div class="row">
                            <div class="col-3">&nbsp;</div>
                            <div class="col-7">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">

                                  <asp:LinkButton ID="LinkButton5" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="addButton_Click" style="background-color: #00bcd4;color: #fff;">   <i class="fa fa-plus"></i>&nbsp; Add To List</asp:LinkButton>
                                                           
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>

                        <br />

                         <div class="row">
                               <div class="table-responsive" id="ssada">
                              <asp:GridView ID="gridLineItemGridView" runat="server" AutoGenerateColumns="False"
                                CssClass="table table-bordered  text-center thead-dark" >
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
                                            <asp:TextBox ID="codeTextBox" runat="server" Text='<%# Eval("ProductCode")%>' CssClass="form-control form-control-sm " 
                                                AutoPostBack="True" OnTextChanged="codeTextBox_TextChanged"></asp:TextBox>
                                            <asp:HiddenField ID="orderdetailIdHiddenField" runat="server" Value='<%# Eval("OrderDetailsId")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Name">
                                        <ItemTemplate>
                                            <asp:TextBox ID="nameTextBox" runat="server" CssClass="form-control form-control-sm "  Text='<%# Eval("ProductName")%>'
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
                                            <asp:TextBox ID="currentStockTextBox" runat="server" CssClass="form-control form-control-sm " 
                                                Text='<%# Eval("StockQty")%>' ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fcurrentStockTextBox" runat="server" TargetControlID="currentStockTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="UP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="unitPriceTextBox" runat="server" CssClass="form-control form-control-sm "  Text='<%# Eval("UnitPrice")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="funitPriceTextBox" runat="server" TargetControlID="unitPriceTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="UVAT">
                                        <ItemTemplate>
                                            <asp:TextBox ID="upVatTextBox" runat="server" CssClass="form-control form-control-sm "  Text='<%# Eval("UnitVAT")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fupVatTextBox" runat="server" TargetControlID="upVatTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="qtyTextBox" runat="server" CssClass="form-control form-control-sm "  ReadOnly="True"
                                                Text='<%# Eval("Quantity")%>' AutoPostBack="True" OnTextChanged="qtyTextBox_TextChanged"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fqtyTextBox" runat="server" TargetControlID="qtyTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="TP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="tpTextBox" runat="server" CssClass="form-control form-control-sm "  Text='<%# Eval("TotalPrice")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="ftpTextBox" runat="server" TargetControlID="tpTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="DP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="dpTextBox" runat="server" CssClass="form-control form-control-sm "  Text='<%# Eval("DiscountPercentage")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fdpTextBox" runat="server" TargetControlID="dpTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="DAmt">
                                        <ItemTemplate>
                                            <asp:TextBox ID="dpAmtTextBox" runat="server" CssClass="form-control form-control-sm "  Text='<%# Eval("DiscountAmount")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fdpAmtTextBox" runat="server" TargetControlID="dpAmtTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="SD">
                                        <ItemTemplate>
                                            <asp:TextBox ID="sdTextBox" runat="server" CssClass="form-control form-control-sm "  Text='<%# Eval("SpecialAmount")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fsdTextBox" runat="server" TargetControlID="sdTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="TPVAT">
                                        <ItemTemplate>
                                            <asp:TextBox ID="tpVatTextBox" runat="server" CssClass="form-control form-control-sm "  Text='<%# Eval("VAT")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="ftpVatTextBox" runat="server" TargetControlID="tpVatTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="NP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="npTextBox" runat="server" CssClass="form-control form-control-sm"  Text='<%# Eval("NetPrice")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fnpTextBox" runat="server" TargetControlID="npTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="BQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="bQtyTextBox" runat="server" CssClass="form-control form-control-sm "  Text='<%# Eval("BonusQty")%>'
                                                AutoPostBack="True" OnTextChanged="bQtyTextBox_TextChanged" ReadOnly="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="fbQtyTextBox" runat="server" TargetControlID="bQtyTextBox"
                                                FilterType="Custom, Numbers" ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="TQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="tQtyTextBox" runat="server" CssClass="form-control form-control-sm "  Text='<%# Eval("TotalQty")%>'
                                                ReadOnly="True"></asp:TextBox>
                                            <%--   <asp:FilteredTextBoxExtender ID="ftQtyTextBox" runat="server"
                                                        TargetControlID="tQtyTextBox"         
                                                        FilterType="Custom, Numbers"  ReadOnly="True"
                                                        ValidChars="." />--%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Expairy Date">
                                        <ItemTemplate>
                                            <asp:TextBox ID="expDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker" ></asp:TextBox>
                                             
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Batch No">
                                        <ItemTemplate>
                                            <asp:TextBox ID="batchNoTextBox" runat="server" CssClass="form-control form-control-sm " ></asp:TextBox>
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
                           

                           <div class="col-md-3"></div>

                            <div class="col-md-6">
                                                                                    
                               <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">   TP Total :</label>

                                    <div class="col-sm-5">                                             
                                       <asp:TextBox ID="tpTptalTextBox" runat="server" AutoPostBack="True" CssClass="form-control form-control-sm"></asp:TextBox>                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                               <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">    Discount Total :</label>

                                    <div class="col-sm-5">
                                                           
                                <asp:TextBox ID="disTotalTextBox" runat="server" CssClass="form-control form-control-sm" AutoPostBack="True"
                                    OnTextChanged="custNameTextBox_TextChanged"></asp:TextBox>
                              

                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                               <div class="form-group row" >
                                    <label for="" class="col-sm-3 col-form-label">  Special Discount :</label>

                                    <div class="col-sm-5">
                                     
                             
                                    <asp:TextBox ID="pdTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="True"></asp:TextBox>
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 
                     
                               <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">   Sales Center :</label>

                                    <div class="col-sm-5">
                                         
                                          <asp:TextBox ID="TextBox5" runat="server" CssClass="form-control form-control-sm" ReadOnly="True"></asp:TextBox>

                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                               <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">   VAT Total :</label>

                                    <div class="col-sm-5">
                                                           
                                       <asp:TextBox ID="vatTotalTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="True"></asp:TextBox>

                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                               <div class="form-group row" >
                                    <label for="" class="col-sm-3 col-form-label">  Grand Total :</label>

                                    <div class="col-sm-5">
                                     
                                    <asp:TextBox ID="grandTotalTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="True"></asp:TextBox>
                           
                           
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 

                                </div>  

                   

                         </div>  

                        <br />

                         <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">

 <asp:LinkButton ID="LinkButton3" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="submitButton_Click"  style="background-color: #00bcd4;color: #fff;"> <i class="fa fa-check-square"></i>&nbsp; Submit Information</asp:LinkButton>
                            <asp:LinkButton ID="LinkButton4"  class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" runat="server" OnClick="cancelButton_Click"
                                ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset Information </asp:LinkButton>
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>

                        <br />

                         <div class="row">
                           

                           <div class="col-md-3"></div>

                            <div class="col-md-5">
                                                                                    
                               <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label"> Print Invoice No:</label>

                                    <div class="col-sm-5">                                             
                                       <asp:TextBox ID="invTextBox" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>                                                                
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                             
                                </div>  

                            <div class="col-md-2"> 

                                   <asp:Button ID="Button1" runat="server" OnClick="printButton_Click" Text="Print" />
                               </div>
                   

                         </div>  


                                </div>  
                              
                                </div>  
                                </div>  
                
                                </div>  
                                </div>  
                  </div>  
                                </div>  
  <%--   </ContentTemplate>
    </asp:UpdatePanel>--%>



 <%--   <asp:UpdatePanel ID="UpdatePanel1" runat="server" Visible=" false" >
        <ContentTemplate>
            
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Sales Return
                        </td>
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
                                <asp:Label ID="msgLabel" runat="server"></asp:Label>
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
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="SalesReturnList.aspx">View List</asp:HyperLink>
                                &nbsp;
                            </td>
                            <td class="TDRight" width="20%">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td width="13%" class="TDLeft">
                                &nbsp;
                            </td>
                            <td width="20%" class="TDRight">
                                &nbsp;
                            </td>
                            <td width="13%" class="TDLeft">
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:Label ID="MessageLabel" runat="server" ForeColor="#009900"></asp:Label>
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
                                <asp:Label ID="Label2" runat="server"></asp:Label>
                            </td>
                            <td class="TDLeft" width="13%">
                                &nbsp;
                            </td>
                            <td class="TDRight" width="20%">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                                Customer Code
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="custCodeTextBox" runat="server" AutoPostBack="True" CssClass="TextBox"
                                    OnTextChanged="custCodeTextBox_TextChanged"></asp:TextBox>
                                <asp:HiddenField ID="hdCustomerMasterId" runat="server" />
                                <asp:HiddenField ID="orderIdHiddenField" runat="server" />
                                <asp:HiddenField ID="orderHiddenField" runat="server" />
                                <asp:HiddenField ID="hdComUnitId" runat="server" />
                                <asp:HiddenField ID="hdMiaId" runat="server" />
                            </td>
                            <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                                Customer Name
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="custNameTextBox" runat="server" CssClass="TextBox" AutoPostBack="True"
                                    OnTextChanged="custNameTextBox_TextChanged"></asp:TextBox>
                                <asp:AutoCompleteExtender ID="custNameTextBox_AutoCompleteExtender" runat="server"
                                    DelimiterCharacters="" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                    CompletionSetCount="10" ServiceMethod="GetCustomer" ServicePath="SInventoryWebService.asmx"
                                    TargetControlID="custNameTextBox" UseContextKey="True" CompletionListCssClass="autocomplete_completionListElement"
                                    CompletionListItemCssClass="autocomplete_listItem" CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                    ShowOnlyCurrentWordInCompletionListItem="true">
                                </asp:AutoCompleteExtender>
                            </td>
                            <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                                Customer Address
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="custAddressTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                                Salse Center
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="comUnitNameTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                            </td>
                            <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                                MIO Code
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="miaCodeTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                            </td>
                            <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                                MIO Name
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="miaNameTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                                FE Name
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="districtNameTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                            </td>
                            <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                                Territory Name
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="areaNameTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                            </td>
                            <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                                Merket
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="marketNameTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                                Customer Category
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="custCategoryTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                            </td>
                            <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                                Remarks
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="orderNoTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                            </td>
                            <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                                Invoice Date
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="orderDateTextBox" runat="server" CssClass="TextBoxCalander" ReadOnly="True"></asp:TextBox>
                                <asp:ImageButton ID="imgorderDate" runat="server"
                                    AlternateText="Click to show calendar"
                                    ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="4" />
                            </td>
                        </tr>
                        <tr>
                            <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                                Invoice No
                            </td>
                           <td width="20%" class="TDRight">
                                
                                <asp:TextBox ID="ddlInvoice" runat="server" CssClass="TextBox" 
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
                          
                            </td>
                            <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;" runat="server"
                                visible="true">
                                Fixed Business Customer ?
                            </td>
                            <td width="20%" class="TDRight">
                                
                                <asp:CheckBox ID="fixedcustomerCheckBox1" runat="server" />

                                <asp:TextBox ID="TextBox2" runat="server" Visible="False" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                            </td>
                            <td width="13%" runat="server" class="TDLeft" style="text-align: right; padding-right: 10px;"
                                visible="False">
                                Invoice Date
                            </td>
                            <td width="20%" class="TDRight">
                                <asp:TextBox ID="TextBox3" runat="server" Visible="False" CssClass="TextBoxCalander"
                                    ReadOnly="True"></asp:TextBox>
                                 <asp:ImageButton ID="imgorderDate" runat="server"
                                    AlternateText="Click to show calendar"
                                    ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="4" />
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
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%" colspan="6">
                            <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False" CssClass="gridview"
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
                                            <asp:TextBox ID="transferQtyTextBox" runat="server" CssClass="TextBox" Height="21px"></asp:TextBox>
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
                            <asp:Button ID="addButton" runat="server" Text="Add to List" OnClick="addButton_Click" />
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
                        <td class="TDLeft" width="13%" colspan="6">
                            <asp:GridView ID="gridLineItemGridView" runat="server" AutoGenerateColumns="False"
                                CssClass="gridview">
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
                                               <asp:FilteredTextBoxExtender ID="ftQtyTextBox" runat="server"
                                                        TargetControlID="tQtyTextBox"         
                                                        FilterType="Custom, Numbers"  ReadOnly="True"
                                                        ValidChars="." />
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
                                             <asp:ImageButton ID="removeImageButton" runat="server" 
                                                ImageUrl="~/images/lineDelete.png" onclick="removeImageButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <br />
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
                            TP Total
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="tpTptalTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
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
                            Discount Total
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="disTotalTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
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
                            Special Discount
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="pdTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
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
                            VAT Total
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="vatTotalTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
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
                            Grand Total
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="grandTotalTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    <tr runat="server" visible="False">
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            Credit Amount
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="crAmountTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    <tr runat="server" visible="False">
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            Receivable Amount
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="rcvAmountTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
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
                            <asp:Button ID="submitButton" runat="server" OnClick="submitButton_Click" Text="Submit" />
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
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            Print InvNo
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="invTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Button ID="printButton" runat="server" OnClick="printButton_Click" Text="Print" />
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
    </asp:UpdatePanel>--%>
</asp:Content>
