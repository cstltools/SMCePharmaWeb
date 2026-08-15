<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="WHStockAdjustmentEntry.aspx.cs" Inherits="SInventory_UI_WHStockAdjustmentEntry" %>
<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>   Stock Adjustment </div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="WHStockAdjustmentView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>
                      
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
                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
                    
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
                    <div class="row">
                          <div class="col-2">
                              </div>
                        <div class="col-6">
                                            
                                             
                            

                                              <div class="form-group row"  runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">Transaction Date :<span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                          <asp:TextBox ID="transactionDateTextBox" runat="server"  class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Invoice To Date"></asp:TextBox>
                                                 
                                                    
                                                         

                                                    </div>
                                                  
                                                    </div>

                                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	Adjustment Type :<span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                                    <asp:DropDownList ID="adjustmentTypeDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" >
                            </asp:DropDownList>


                                                </div>
                                                
                                            </div>

                            
                                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	 From Store :<span style="color:red">*</span></label>

                                                <div class="col-sm-7">

                                                     <asp:DropDownList ID="fromstoreDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" >
                                <asp:ListItem></asp:ListItem>
                                <asp:ListItem Value="1">CWH</asp:ListItem>
                            </asp:DropDownList>
                                                                  


                                                </div>
                                                
                                            </div>


                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	 To Store :<span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                                    <asp:DropDownList ID="tostoreDropDownList1" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" >
                            </asp:DropDownList>


                                                </div>
                                                
                                            </div>

                            
                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	Remarks :<span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                                  
                                                      <asp:TextBox class="form-control form-control-sm mb-3 " TextMode="MultiLine" Rows="2" runat="server" ID="remarksTextBox" placeholder="Delivery Man Name"></asp:TextBox>


                                                </div>
                                                
                                            </div>


                             <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	Product :<span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                                    <asp:DropDownList ID="productDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" >
                            </asp:DropDownList>


                                                </div>
                                                
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

                                                      <asp:LinkButton  OnClick="Button2_Click"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-search-plus" aria-hidden="true"></i>&nbsp; Search
                                        </asp:LinkButton>
                                             


                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">
                                                
                                        </div>
                                    </div>

                    
                       
                    <hr />

                                 <div class="table-responsive" id="MainGradeDiv"  >
 <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False" OnPreRender="gv_DocumentUpload_PreRender"
                                class="table table-striped table-bordered table-hover" DataKeyNames="ReceiveId">
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" 
                                                oncheckedchanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" AutoPostBack="True" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="SL" HeaderText="SL" />
                                    <asp:TemplateField HeaderText="Code">
                                        <ItemTemplate>
                                            <asp:TextBox ID="productCodeTextBox" runat="server" AutoPostBack="True"  ReadOnly="True" 
                                                CssClass="form-control form-control-sm mb-3"  
                                                 Text='<%# Eval("ProductCode")%>' 
                                            ></asp:TextBox>
                                            <asp:HiddenField ID="productidHiddenField" runat="server" 
                                                Value='<%# Eval("ProductId")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Product Name">
                                        <ItemTemplate>
                                            <asp:TextBox ID="productNameTextBox" runat="server" AutoPostBack="True" 
                                                
                                                  Text='<%# Eval("ProductName")%>' CssClass="form-control form-control-sm mb-3"  ></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="PackSize">
                                        <ItemTemplate>
                                            <asp:TextBox ID="packSizeTextBox" runat="server" CssClass="form-control form-control-sm mb-3"  
                                                  ReadOnly="True" Text='<%# Eval("PackSize")%>'  ></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Batch">
                                        <ItemTemplate>
                                            <asp:TextBox ID="batchTextBox" runat="server" CssClass="form-control form-control-sm mb-3"  ReadOnly="True" Text='<%# Eval("BatchNo")%>'  ></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                    <asp:TemplateField HeaderText="Exp. Date">
                                        <ItemTemplate>
                                            <asp:TextBox ID="expDateDateTextBox" runat="server" AutoPostBack="True" 
                                              CssClass="form-control form-control-sm  mb-3  mb-3 datepicker"     ReadOnly="True" 
                                                 Text='<%# Eval("ExpDate")%>' 
                                                 ></asp:TextBox>
                                           
                                            </calendarextender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                    <asp:TemplateField HeaderText="Price">
                                        <ItemTemplate>
                                            <asp:TextBox ID="costPriceTextBox" runat="server" AutoPostBack="True" 
                                                CssClass="form-control form-control-sm  mb-3  mb-3 "   ReadOnly="True" 
                                                 Text='<%# Eval("UnitPrice")%>' 
                                                 ></asp:TextBox>
                                            <filteredtextboxextender id="FilteredTextBoxExtenderPrice" runat="server" 
                                                enabled="True" filtertype="Custom" targetcontrolid="costPriceTextBox" 
                                                validchars="0123456789.">
                                            </filteredtextboxextender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Vat">
                                        <ItemTemplate>
                                            <asp:TextBox ID="vatTextBox" runat="server" AutoPostBack="True" 
                                                CssClass="form-control form-control-sm  mb-3  "  ReadOnly="True" 
                                                 Text='<%# Eval("VATPerUnit")%>' ></asp:TextBox>
                                            <filteredtextboxextender id="FilteredTextBoxExtenderVat" runat="server" 
                                                enabled="True" filtertype="Custom" targetcontrolid="vatTextBox" 
                                                validchars="0123456789.">
                                            </filteredtextboxextender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total Amount">
                                        <ItemTemplate>
                                            <asp:TextBox ID="totalValueTextBox" runat="server" AutoPostBack="True" 
                                                CssClass="form-control form-control-sm  mb-3  " 
                                                 ReadOnly="True" 
                                                Text='<%# Eval("TotalPrice")%>' ></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="C.Stock">
                                        <ItemTemplate>
                                            <asp:TextBox ID="cStockTextBox" runat="server" AutoPostBack="True" 
                                                CssClass="form-control form-control-sm  mb-3  "   
                                                Text='<%# Eval("Quantity")%>'  ></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="reqQtyTextBox" runat="server" AutoPostBack="True" 
                                                CssClass="form-control form-control-sm  mb-3" Height="23px" OnTextChanged="reqQtyTextBox_OnTextChanged"
                                                 
                                                Width="60px"></asp:TextBox>
                                            <filteredtextboxextender id="FilteredTextBoxExtenderQuantity" runat="server" 
                                                enabled="True" filtertype="Custom" targetcontrolid="reqQtyTextBox" 
                                                validchars="0123456789.">
                                            </filteredtextboxextender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                    
                                    <%--<asp:TemplateField HeaderText="Add">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/images/lineAdd.png"
                                                OnClick="ImageButton1_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Remove">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/images/lineDelete.png"
                                                OnClick="ImageButton2_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                </Columns>
                            </asp:GridView> 
                            <asp:TextBox ID="stockeffectTextBox" Visible="false" runat="server" CssClass="TextBox"></asp:TextBox>

                                            </div>

                     <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-8">
                                    <br />

                                     <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label"> </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                 <asp:LinkButton  OnClick="Button1_Click"  runat="server" id="btnSave" class="btn btnMyDesignSearch    btn-sm" OnClientClick="return sweetAlertConfirm_Submit(this);"    >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                             
                                          <asp:LinkButton   runat="server" ID="btnReset"  class="btn btnMyDesignReset   btn-sm" OnClick="btnReset_Click"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>



                                            </div>

                                        </div>
                                    </div>

                                </div>
                                </div>

                    </ContentTemplate>
                     <Triggers>
                 
                  
             </Triggers>

                  
                </asp:UpdatePanel>
                            </div>

                            </div>
                            </div>
                            </div>
                            </div>
                            </div>  

   

</asp:Content>

