<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="StockOutSubDepot.aspx.cs" Inherits="SubDepot_UI_StockTransferDcToSubDepot" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


      <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Stock Adjustment
                        </div>
                
                <div class="ms-auto">
                    <div class="btn-group">

                      
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
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> DC:</label>

                                                <div class="col-sm-5">
                                            
                                                     <asp:DropDownList ID="salescenterDropDownList1" runat="server" 
                                AutoPostBack="True" CssClass="form-select form-select-sm mb-3 mySelect2 " 
                                onselectedindexchanged="salescenterDropDownList1_SelectedIndexChanged">
                            </asp:DropDownList>
                                              
                                                   
                                                   

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
                                                
                                            </div>
                                            
                                            <div class="form-group row" >
                                                <label for="mainName" class="col-sm-3 col-form-label">Sub-Depot:</label>

                                                <div class="col-sm-5">

 <asp:DropDownList ID="subdeportDropDownList2" runat="server" 
                                AutoPostBack="True" CssClass="form-select form-select-sm mb-3 mySelect2 " 
                                onselectedindexchanged="subdeportDropDownList2_SelectedIndexChanged">
                            </asp:DropDownList>
   
                                                </div>
                                                
                                            </div>

                                                     <div class="form-group row" >
                                                <label for="mainName" class="col-sm-3 col-form-label">Sub-Depot Code:</label>

                                                <div class="col-sm-5">

                                               
                                                 
                                                    <asp:TextBox ID="toComUnitCodeTextBox" runat="server" AutoPostBack="True" 
                                CssClass="form-control form-control-sm" ontextchanged="toComUnitCodeTextBox_TextChanged" 
                                ReadOnly="True"></asp:TextBox>


                                                </div>
                                                
                                            </div>


                                                 <div class="form-group row" >
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	Name:</label>

                                                <div class="col-sm-5">

                                                 <asp:TextBox ID="toComUnitNameTextBox" runat="server" CssClass="form-control form-control-sm" 
                                 ReadOnly="True"></asp:TextBox>
                                                 
                                                   


                                                </div>
                                                
                                            </div>

                                                  <div class="form-group row" >
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	Address:</label>

                                                <div class="col-sm-5">
  <asp:TextBox ID="toComUnitAddressTextBox" runat="server" CssClass="form-control form-control-sm" 
                                ReadOnly="True" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                                
                                                 
                                                   


                                                </div>
                                                
                                            </div>

                                                   <div class="form-group row" >
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	Product:</label>

                                                <div class="col-sm-5">
                                                      <asp:DropDownList ID="productDropDownList" runat="server" AutoPostBack="True" 
                                CssClass="form-select form-select-sm mb-3 mySelect2 " 
                                onselectedindexchanged="salescenterDropDownList1_SelectedIndexChanged">
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
                                                    
                                                     
                     

                                                            <asp:LinkButton  OnClick="Button1_Click"   runat="server" id="Button1" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-search"></i> Search
                                        </asp:LinkButton>

                                                    
 
                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>

                    
                                    <br />


                          <div class="row">
                                        <div class="table-responsive" id="MainGrasdeDiv">

                                                <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="table table-bordered  text-center thead-dark" DataKeyNames="DCStoreId,VATAmountPerUnit,UnitPrice" >
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
                    <br />

                    
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="form-group row">
                                                <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-8">
                                                    
                                                       

                                                            <asp:LinkButton  OnClick="addButton_Click"   runat="server" id="addButton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-plus"></i> Add to List
                                        </asp:LinkButton>

                                                    
                                                     

                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>

                      <div class="row">
                                        <div class="table-responsive" id="MaihjgjnGrasdeDiv">
                                              <asp:GridView ID="chalanGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="table table-bordered  text-center thead-dark" DataKeyNames="DCStoreId,VATAmountPerUnit,UnitPrice">
                                <Columns>
                                    
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="TransferQty" HeaderText="Transfer Qty" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />
                                        <asp:TemplateField HeaderText="Remove Item">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="DeleteImageButton" CssClass="btn-danger  btn-sm mb-1 mb-md-0" runat="server" 
                                                   onclick="DeleteImageButton_Click1" ><i class="bx bxs-trash " aria-hidden="true"></i></asp:LinkButton>
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
                                                    
                                                      

                                                            <asp:LinkButton  OnClick="submitButton_Click1"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-check"></i> Submit
                                        </asp:LinkButton>

                                                    
                                                     

                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>


     <asp:UpdatePanel ID="UpdatePanel1" runat="server" Visible="false">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Stock Adjustment
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="driverNameTextBox" runat="server" CssClass="TextBox" 
                                Visible="False"></asp:TextBox>
                        </td>
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
                            <asp:DropDownList ID="manufacDropDownList" runat="server" CssClass="DropDown" 
                                Visible="False">
                            </asp:DropDownList>
                        </td>
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
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="chalanDateTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True" Visible="False"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            DC</td>
                        <td class="TDRight" width="20%">
                           
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                    
                       <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                            Sub-Depot
                        </td>
                        <td width="20%" class="TDRight">
                            
                           </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    

                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="fromComUnitCodeTextBox" runat="server" AutoPostBack="True" 
                                CssClass="TextBox" ontextchanged="fromComUnitCodeTextBox_TextChanged" 
                                ReadOnly="True" Visible="False"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            Sub-Depot Code</td>
                        <td width="20%" class="TDRight">
                           
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                   
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                             <asp:TextBox ID="fromComUnitNameTextBox" runat="server" CssClass="TextBox" 
                                 ReadOnly="True" Visible="False"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                            Name</td>
                        <td width="20%" class="TDRight">
                           
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="fromComUnitAddressTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True" TextMode="MultiLine" Visible="False"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            Address</td>
                        <td class="TDRight" width="20%">
                          
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
                            <asp:TextBox ID="truckNoTextBox" runat="server" CssClass="TextBox" 
                                Height="21px" Visible="False"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            Product</td>
                        <td class="TDRight" width="20%">
                          
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
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                   
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="chalanNoTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True" Visible="False"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                           
                        </td>
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
                            <asp:TextBox ID="prodctCodeTextBox" runat="server" CssClass="TextBox" 
                                Height="21px" Visible="False"></asp:TextBox>
                           </td>
                              <td class="TDRight" width="20%">
                           </td>
                        <td class="TDLeft" width="13%" runat="server" Visible="False">
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
                        <td class="TDLeft" width="13%" colspan="6">
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
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" colspan="6">
                          
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
                    <tr runat="server" Visible="False">
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
                         
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr runat="server" Visible="False">
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Chalan No</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="printChalanNoTextBox" runat="server" AutoPostBack="True" 
                                CssClass="TextBox" ontextchanged="fromComUnitCodeTextBox_TextChanged"></asp:TextBox>
                        </td>                            

                        <td class="TDLeft" width="13%">
                            <asp:Button ID="Button2" runat="server" BackColor="#660033" 
                                onclick="Button2_Click" Text="Print" />
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
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

