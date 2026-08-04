<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SubDeportTransferStockReceiveByDC.aspx.cs" Inherits="SInventory_UI_SubDeportTransferStockReceiveByDC" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    

       <asp:UpdatePanel ID="UpdatePanel3" runat="server">
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Stock Received By DC </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        

                         

                                
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
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> DC Name:</label>

                                    <div class="col-sm-5">
                                      
                           
                                   
                            <asp:DropDownList ID="dcDropDownList" runat="server"  
                        CssClass="form-select form-select-sm mb-3 mySelect2 " 
                        >
                    </asp:DropDownList>

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
 
                                          <asp:LinkButton runat="server"  id="searchButton" class="btn btnMyDesignSearch   btn-sm "  onclick="searchButton_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                                  
                                
                               <asp:LinkButton  runat="server" class="btn btnMyDesignReset   btn-sm"   id="cancelButton" onclick="cancelButton_Click" ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>

  
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>

                                         <br/>
                        
                        <div class="row">
      <div class="table-responsive" id="MainGradeDiv">
            <asp:GridView ID="stockInTraGridView" runat="server" 
                                    AutoGenerateColumns="False"  DataKeyNames="SChalanId"  CssClass="table table-bordered  text-center thead-dark"  OnPreRender="gv_DocumentUpload_PreRender">
                                    <Columns>
                                        <asp:BoundField DataField="ChalanNo" HeaderText="Chalan No" />
                                        <asp:BoundField DataField="ChalanDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                            HeaderText="Chalan Date" />
                                        <asp:BoundField DataField="TrackNo" HeaderText="Truck No" />
                                        <asp:BoundField DataField="DriverName" HeaderText="Driver Name" />
                                        <asp:HyperLinkField HeaderText="Receive Product" DataNavigateUrlFields="SChalanId" 
                                        DataNavigateUrlFormatString="SubdeportTransferReceiveProductByChalanByDC.aspx?SChalanId={0}"
                                            Text="Receive Product&gt;&gt;" ><ControlStyle  CssClass="btn btn-sm  btn-info"></ControlStyle> </asp:HyperLinkField>
                                    </Columns>
                                </asp:GridView>
            
                
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

