<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="DepoToWHTransfer.aspx.cs" Inherits="SInventory_UI_DepoToWHTransfer" %>

<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .font-bold
        {
            font-weight: bold;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


     <asp:UpdatePanel ID="UpdatePanel4" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Stock Transfer DC to Warehouse </div>

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
                        <div class="card-body">


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
                           <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">From</label>
                               </div>
                             <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	Chalan Date:</label>

                                                <div class="col-sm-5">

                                                      <asp:TextBox ID="chalanDateTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>
                                                 
                                              

                                                </div>
                                               
                                            </div>

                             <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	 	Sales Center:</label>

                                                <div class="col-sm-5">

                                                 <asp:DropDownList ID="salescenterDropDownList1" runat="server" AutoPostBack="True"
                                CssClass="form-control form-control-sm mySelect2" OnSelectedIndexChanged="salescenterDropDownList1_SelectedIndexChanged">
                            </asp:DropDownList>
                                                 
                                              

                                                </div>
                                               
                                            </div>

                             <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">  	Sales Center Code:</label>

                                                <div class="col-sm-5">

                                                    
                                                 
                                               <asp:TextBox ID="fromComUnitCodeTextBox" runat="server" AutoPostBack="True" CssClass="form-control form-control-sm mb-3"
                                OnTextChanged="fromComUnitCodeTextBox_TextChanged" ReadOnly="True"></asp:TextBox>

                                                </div>
                                               
                                            </div>


                             <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	 	Sales Center Name:</label>

                                                <div class="col-sm-5">

                                          
                                                 
                                              <asp:TextBox ID="fromComUnitNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>

                                                </div>
                                               
                                            </div>


                             <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	Address:</label>

                                                <div class="col-sm-5">
                                                     
                                                 <asp:TextBox ID="fromComUnitAddressTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"
                                TextMode="MultiLine"></asp:TextBox> 
                                              

                                                </div>
                                               
                                            </div>


                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	 Truck Number :</label>

                                                <div class="col-sm-5">
                                                        <asp:TextBox ID="truckNoTextBox" runat="server" CssClass="form-control form-control-sm mb-3"  ></asp:TextBox>
                                                 
                                              

                                                </div>
                                               
                                            </div>


                               <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	Product:</label>

                                                <div class="col-sm-5">
                                                     
                                                  <asp:DropDownList ID="productDropDownList" runat="server" AutoPostBack="True" CssClass="form-control form-control-sm mySelect2"
                                OnSelectedIndexChanged="salescenterDropDownList1_SelectedIndexChanged">
                            </asp:DropDownList>

                                                </div>
                                               
                                            </div>


                             <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">  </label>

                                                <div class="col-sm-5">
                                                     
                                                 <asp:LinkButton ID="Button1" runat="server" CssClass="btn btnMyDesignAddtoList   btn-sm" OnClick="Button1_Click" >Regular Stock </asp:LinkButton>

                                                </div>
                                               
                                            </div>
                           
                              <div class="table-responsive" id="MainGradeDiv"  > 

                              <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False"   CssClass="table table-bordered  text-center thead-dark"  
                                DataKeyNames="DCStoreId,VATAmountPerUnit,UnitPrice,DCStoreFreezeId">
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="PCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="PName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="StockQty" HeaderText="Stock Qty" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" HeaderText="ExpDate" />
                                    <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" HeaderText="ReceiveDate" />
                                    <asp:TemplateField HeaderText="Transfer Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="transferQtyTextBox" runat="server" CssClass="form-control form-control-sm mb-3"  
                                                OnTextChanged="dQtyTextBox_TextChanged" AutoPostBack="True"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderconvRate" runat="server"
                                                Enabled="True" TargetControlID="transferQtyTextBox" FilterType="Custom" ValidChars="0123456789">
                                            </asp:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                                 </div>
                           <br />

                             <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> Taka: </label>

                                                <div class="col-sm-5">
                                                     
                                                 <asp:Label ID="grandTotalWordLabel"    runat="server"></asp:Label>

                                                </div>
                                               
                                            </div>


                       </div>
                       <div class="col-md-6">

                                    <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">To</label>
                               </div>
                             <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	Chalan No:</label>

                                                <div class="col-sm-5">

                                                   
                                                 
                                                <asp:TextBox ID="chalanNoTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"></asp:TextBox>

                                                </div>
                                               
                                            </div>


                                <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	Warehouse :</label>

                                                <div class="col-sm-5">

                                                   
                                                 <asp:DropDownList ID="subdeportDropDownList2" runat="server"  
                                CssClass="form-control form-control-sm mySelect2">
                            </asp:DropDownList>

                                                </div>
                                               
                                            </div>


                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	WH Code :</label>

                                                <div class="col-sm-5">

                                                    <asp:TextBox ID="toComUnitCodeTextBox" runat="server" CssClass="form-control form-control-sm mb-3" OnTextChanged="toComUnitCodeTextBox_TextChanged"
                                AutoPostBack="True" ReadOnly="True"></asp:TextBox>
                                                 
                                                

                                                </div>
                                               
                                            </div>


                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">  	WH Name:</label>

                                                <div class="col-sm-5">

                                                   
                                                   <asp:TextBox ID="toComUnitNameTextBox" runat="server" ReadOnly="True" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                                               

                                                </div>
                                               
                                            </div>

                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	Address:</label>

                                                <div class="col-sm-5">

                                                    <asp:TextBox ID="toComUnitAddressTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"
                                TextMode="MultiLine"></asp:TextBox>
                                            

                                                </div>
                                               
                                            </div>


                             <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	 Driver Name :</label>

                                                <div class="col-sm-5">
                                                        <asp:TextBox ID="driverNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                                                    
                                            

                                                </div>
                                               
                                            </div>


                           <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	Manufacturer:</label>

                                                <div class="col-sm-5">

                                               
                                             <asp:DropDownList ID="manufacDropDownList" runat="server" CssClass="form-control form-control-sm mySelect2">
                            </asp:DropDownList>

                                                </div>
                                               
                                            </div>


                           
                           <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	 </label>

                                                <div class="col-sm-5">

                                               
                                             <asp:Button ID="Button3" CssClass="btn btnMyDesignAddtoList   btn-sm"  runat="server" Text="Freeze Stock" OnClick="Button3_Click" />

                                                </div>
                                               
                                            </div>

                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	  </label>

                                                <div class="col-sm-5">

                                                 <asp:Button ID="addButton" CssClass="btn btnMyDesignDraft   btn-sm"  runat="server" Text="Add" OnClick="addButton_Click" />
                                          

                                                </div>
                                               
                                            </div>
                             <div class="table-responsive" id="MadinGradeDiv"  > 

                                 <asp:GridView ID="chalanGridView" runat="server" AutoGenerateColumns="False"  CssClass="table table-bordered  text-center thead-dark"  
                                DataKeyNames="DCStoreId,VATAmountPerUnit,UnitPrice,DCStoreFreezeId">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="TransferQty" HeaderText="Transfer Qty" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" HeaderText="ExpDate" />
                                    
                                    <asp:TemplateField HeaderText="Purpose">
                                        <ItemTemplate>
                                            <asp:HiddenField ID="hfPurposeId" runat="server" />
                                            <asp:DropDownList ID="purposeDropDownList" runat="server" CssClass="form-control form-control-sm mySelect2" >
                                            </asp:DropDownList>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Remove Item">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="DeleteImageButton" runat="server" ImageUrl="~/images/lineDelete.png"
                                                OnClick="DeleteImageButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                                </div>

                           

                            <div class="form-group row"  id="Td1"  runat="server" visible="False">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	  </label>

                                                <div class="col-sm-5">
                         
                            <asp:TextBox ID="prodctCodeTextBox" runat="server" CssClass="form-control form-control-sm mb-3"  ></asp:TextBox>
                

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


                                         <asp:LinkButton    OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" ID="submitButton"  OnClick="submitButton_Click1"  class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                              
                                        <asp:LinkButton   ID="cancelButton"  runat="server"  OnClick="cancelButton_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>

 
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                         <div style="padding: 6px;"></div>

                          <div class="row">
                               <div class="col-2">&nbsp;</div>
                                                <div class="col-8">

                                                    <div class="form-group row">

                                                         <label for="mainName" class="col-sm-3 col-form-label"> 	 	Chalan No :</label>

                                                <div class="col-sm-5">

                                                     <asp:TextBox ID="printChalanNoTextBox" runat="server" AutoPostBack="True" CssClass="form-control form-control-sm mb-3"
                                OnTextChanged="fromComUnitCodeTextBox_TextChanged"></asp:TextBox>
                                                </div>
                                               <div class="col-sm-2">
                                                     <asp:LinkButton ID="Button2" runat="server"   CssClass="btn btn-sm btn-primary" 
                                onclick="Button2_Click" ><i class="fa fa-print"></i>&nbsp;Print</asp:LinkButton>
                                               </div>
                                                 
                                              

                                                </div>
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
