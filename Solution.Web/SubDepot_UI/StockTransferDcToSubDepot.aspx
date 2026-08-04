<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="StockTransferDcToSubDepot.aspx.cs" Inherits="SubDepot_UI_StockTransferDcToSubDepot" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    

      <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Stock Transfer DC to Sub-Depot  </div>

                <div class="ms-auto">
                    <div class="btn-group">


                     
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
                           
                           <div class="col-md-6">
                                   <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  From</label>

                                    <div class="col-sm-7">
                                     
                          
                                    
                                    </div>
                                  
                                </div> 

                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  Chalan Date :</label>

                                    <div class="col-sm-7">
                                      <asp:TextBox ID="chalanDateTextBox" runat="server" CssClass="form-control form-control-sm mb-3" 
                                ReadOnly="True"></asp:TextBox>
                      
                               
                                    
                                    </div>
                                  
                                </div> 


                                  <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label"> Sales Center :</label>

                                    <div class="col-sm-7">
                                      <asp:DropDownList ID="salescenterDropDownList1" runat="server" AutoPostBack="True"
                           CssClass="form-select form-select-sm mb-3 mySelect2"     onselectedindexchanged="salescenterDropDownList1_SelectedIndexChanged">
                            </asp:DropDownList>
                               
                                    
                                    </div>
                                  
                                </div> 


                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label"> Sales Center Code:</label>

                                    <div class="col-sm-7">
                                     
                                 
                               
                                      <asp:TextBox ID="fromComUnitCodeTextBox" runat="server" AutoPostBack="True" 
                                CssClass="form-control form-control-sm mb-3" ontextchanged="fromComUnitCodeTextBox_TextChanged" ReadOnly="True"></asp:TextBox>
                                    </div>
                                  
                                </div> 

                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label"> Name:</label>

                                    <div class="col-sm-7">
                                       <asp:TextBox ID="fromComUnitNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"
                                ></asp:TextBox>
                           
                               
                                    
                                    </div>
                                  
                                </div> 


                                 <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  Address:</label>

                                    <div class="col-sm-7">
                                      <asp:TextBox ID="fromComUnitAddressTextBox" runat="server" CssClass="form-control form-control-sm mb-3" 
                                ReadOnly="True" TextMode="MultiLine"></asp:TextBox>
                               
                               
                                    
                                    </div>
                                  
                                </div> 


                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">   Truck Number:</label>

                                    <div class="col-sm-7">
                                     
                              
                                <asp:TextBox ID="truckNoTextBox" runat="server" CssClass="form-control form-control-sm mb-3" 
                                ></asp:TextBox>
                                    
                                    </div>
                                  
                                </div> 

                                 <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  Product:</label>

                                    <div class="col-sm-7">
                                     
                          <asp:DropDownList ID="productDropDownList" runat="server" AutoPostBack="True" 
                                CssClass="form-select form-select-sm mb-3 mySelect2" 
                                onselectedindexchanged="salescenterDropDownList1_SelectedIndexChanged">
                            </asp:DropDownList>
                                    
                                    </div>
                                  
                                </div> 


                                  <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  </label>

                                    <div class="col-sm-7">
                                       
                          <asp:LinkButton ID="Button1" CssClass="btn btn-sm btn-info mb-2" runat="server" OnClick="Button1_Click" >   <i class="fa fa-search-plus"></i>&nbsp; Search Product</asp:LinkButton>
                          
                                    
                                    </div>
                                  
                                </div> 


                                </div> 


                           <div class="col-md-6">
                                   <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  To</label>

                                    <div class="col-sm-7">
                                     
                                
                               
                                    
                                    </div>
                                  
                                </div> 


                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  Chalan No:</label>

                                    <div class="col-sm-7">
                                         
                               
                                 <asp:TextBox ID="chalanNoTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>
                                    
                                    </div>
                                  
                                </div> 

                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  Sub-Depot :</label>

                                    <div class="col-sm-7">
                                     
                                  <asp:DropDownList ID="subdeportDropDownList2" runat="server" AutoPostBack="True"
                               CssClass="form-select form-select-sm mb-3 mySelect2"   onselectedindexchanged="subdeportDropDownList2_SelectedIndexChanged">
                            </asp:DropDownList>
                               
                                    
                                    </div>
                                  
                                </div> 

                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  	Sub-Depot Code:</label>

                                    <div class="col-sm-7">
                                     
                                
                                     <asp:TextBox ID="toComUnitCodeTextBox" runat="server" CssClass="form-control form-control-sm mb-3" 
                                ontextchanged="toComUnitCodeTextBox_TextChanged" AutoPostBack="True" ReadOnly="True"></asp:TextBox>
                                    
                                    </div>
                                  
                                </div> 


                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label"> Name:</label>

                                    <div class="col-sm-7">
                                     
                              
                               
                                      <asp:TextBox ID="toComUnitNameTextBox" runat="server" ReadOnly="True" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                                    </div>
                                  
                                </div> 


                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  Address:</label>

                                    <div class="col-sm-7">
                                     
                            
                                <asp:TextBox ID="toComUnitAddressTextBox" runat="server" CssClass="form-control form-control-sm mb-3" 
                             ReadOnly="True"   TextMode="MultiLine"></asp:TextBox>
                                    
                                    </div>
                                  
                                </div> 


                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  Driver Name:</label>

                                    <div class="col-sm-7">
                            <asp:TextBox ID="driverNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                                     
                             
                               
                                    
                                    </div>
                                  
                                </div> 

                                <div class="form-group row" >
                                    <label for="" class="col-sm-5 col-form-label">  Manufacturer:</label>

                                    <div class="col-sm-7">
                                     
                                 
                               
                                    <asp:DropDownList ID="manufacDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                            </asp:DropDownList>
                                    </div>
                                  
                                </div> 

                                

                                </div> 
                                </div> 


                             <div class="row">
                              <div class="table-responsive" id="MainGradeDiv">
                                  <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False" 
                                 DataKeyNames="DCStoreId,VATAmountPerUnit,UnitPrice" CssClass="table table-bordered  text-center thead-dark" >
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
                              <div class="table-responsive" id="MainGrssadeDiv">
                                      <asp:GridView ID="chalanGridView" runat="server" AutoGenerateColumns="False" 
                                DataKeyNames="DCStoreId,VATAmountPerUnit,UnitPrice"  CssClass="table table-bordered  text-center thead-dark">
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

                                  </div>
                                  </div>

                        
                                <br />
                                            <div class="row">
                                                <div class="col-2">&nbsp;</div>
                                                <div class="col-8">

                                                    <div class="form-group row">
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                        <div class="col-sm-8">

                                                             
                                                              <asp:LinkButton  OnClick="submitButton_Click1" OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"  >
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
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"> 	Chalan No :</label>
                                                        <div class="col-sm-6">
                                                           
                                                             <asp:TextBox ID="printChalanNoTextBox" runat="server" AutoPostBack="True" 
                                CssClass="form-control form-control-sm mb-3" ontextchanged="fromComUnitCodeTextBox_TextChanged"></asp:TextBox>
                                                             
                                                        </div>
                                                          <div class="col-sm-2"> 
                                                         
                                                                <asp:LinkButton ID="Button2" CssClass="btn btn-sm btn-success mb-2  pull-right" runat="server" OnClick="Button2_Click" >   <i class="fa fa-print"></i>&nbsp; Print</asp:LinkButton>
                                                              </div>
                                                    </div>
                                                    </div>
                                                    </div>
                                </div> 
                          <asp:TextBox ID="prodctCodeTextBox" runat="server" Visible="false" CssClass="TextBox" 
                                Height="21px"></asp:TextBox>
                        </div>
                        </div>
                        </div>
                        </div>
                        </div>
            </ContentTemplate>
          </asp:UpdatePanel>

     
</asp:Content>

