<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SubdeportTransferReceiveProductByChalanByDC.aspx.cs" Inherits="SInventory_UI_SubdeportTransferReceiveProductByChalanByDC" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
       <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>

                     <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>

             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>   Receive Product from Chalan By DC </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        
                         <a href="SubDeportTransferStockReceiveByDC.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>

                         

                                
                    </div>
                
                    
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
                            <div class="row">
                                
                           
                            <div class="col-6">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label"> Chalan No:</label>

                                    <div class="col-sm-7">
                                      
                        <asp:TextBox ID="clnNoTextBox" CssClass="form-control form-control-sm mb-3 " runat="server"></asp:TextBox>

                                    </div>
                                 
                                </div> 
                            </div>

                                 <div class="col-6">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">Chalan Date:</label>

                                    <div class="col-sm-7">
                           <asp:TextBox ID="clnDateTextBox" CssClass="form-control form-control-sm mb-3 " runat="server"></asp:TextBox>

                                    </div>
                                    
                                </div> 
                            </div>
                            
                                </div>

                                     <div class="row">
                                
                           
                            <div class="col-6">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  	Receive Date:</label>

                                    <div class="col-sm-7">
                                       <asp:TextBox ID="rcvDateTextBox"  CssClass="form-control form-control-sm mb-3 "  runat="server"></asp:TextBox>
                        

                                    </div>
                                 
                                </div> 
                            </div>

                                 <div class="col-6">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">Truck No:</label>

                                    <div class="col-sm-7"> 
                                          <asp:TextBox ID="truckTextBox"  CssClass="form-control form-control-sm mb-3 "  runat="server"></asp:TextBox>
                                    </div>
                                    
                                </div> 
                            </div>
                            
                                </div>


                            
                                     <div class="row">
                                
                           
                            <div class="col-6">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  	 	Driver Name:</label>

                                    <div class="col-sm-7">
                                       <asp:TextBox ID="driverNameTextBox"  CssClass="form-control form-control-sm mb-3 "  runat="server"></asp:TextBox>
                          

                                    </div>
                                 
                                </div> 
                            </div>

                                 <div class="col-6">
                                <div class="form-group row">
                                     
                                    
                                </div> 
                            </div>
                            
                                </div>

                                <br/>
                        
                        <div class="row">
      <div class="table-responsive" id="MainGradeDiv">
      <asp:GridView ID="rcvGridView" runat="server" AutoGenerateColumns="False" 
                              DataKeyNames="SChalanId,SChalanDetailsId,DCStoreId" CssClass="table table-bordered  text-center thead-dark" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />
                                    <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="Receive Date" />
                                    <asp:TemplateField HeaderText="Rcv Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="rcvQtyTextBox" runat="server" CssClass="form-control form-control-sm mb-3 "  Text= <%# Eval("Quantity")%> 
                                                AutoPostBack="True" ontextchanged="rcvQtyTextBox_TextChanged"></asp:TextBox>
                                             <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server"
                                                                                        Enabled="True" TargetControlID="rcvQtyTextBox" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Un Rcv Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="damageTextBox" runat="server" AutoPostBack="True"  CssClass="form-control form-control-sm mb-3 "
                                                ontextchanged="damageTextBox_TextChanged">0</asp:TextBox>
                                             <asp:FilteredTextBoxExtender ID="FilteredTextBsoxExtender2" runat="server"
                                                                                        Enabled="True" TargetControlID="damageTextBox" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="mfgdate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="Mfg date"/>
                                </Columns>
                            </asp:GridView>
          </div>
          </div>



                                   
                                    <br />
                                            <div class="row">
                                                <div class="col-2">&nbsp;</div>
                                                <div class="col-8">

                                                    <div class="form-group row" style="text-align:center">
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                        <div class="col-sm-5">

                                                           
                                                              <asp:LinkButton   OnClientClick="return sweetAlertConfirm_Submit(this);"  OnClick="submitButton_Click"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>
                            <asp:HiddenField ID="hdComUnitId" runat="server" />
                            <asp:HiddenField ID="hdReqId" runat="server" />

                                        
                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="col-2">&nbsp;</div>
                                            </div>



                                </div>
                                </div>
                                </div>
                                </div>
                                </div>
                              </ContentTemplate>
           </asp:UpdatePanel> 
</asp:Content>

