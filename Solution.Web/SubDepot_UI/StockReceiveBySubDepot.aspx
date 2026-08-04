<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="StockReceiveBySubDepot.aspx.cs" Inherits="SubDepot_UI_StockReceiveBySubDepot" %>

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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Stock Received By Sub-Depot </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        
<%-- <asp:LinkButton ID="viewLinkButton"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="viewLinkButton_OnClick" runat="server"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>--%>

                    
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
             
    
                              <div id="hiddiv" runat="server" Visible="false">
                    
                      
                            
                        
                            <asp:DropDownList ID="TERRITORYDropDownList1" Visible="false" runat="server" AutoPostBack="True"
                                CssClass="DropDown" 
                               >
                            </asp:DropDownList>
                        
                    </div>

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
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                               
                                       <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Distribution Center :</label>

                                    <div class="col-sm-5">

                                                  
                                        <asp:DropDownList ID="dcDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2"  
                        AutoPostBack="True" 
                        onselectedindexchanged="dcDropDownList_SelectedIndexChanged"></asp:DropDownList>
                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                   
                 
                                  

                                   <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">    	Sub-Depot :</label>

                                    <div class="col-sm-5">
                                     
   <asp:DropDownList ID="subdeportDropDownList1" runat="server" 
                        CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="True" onselectedindexchanged="subdeportDropDownList1_SelectedIndexChanged"
                         ></asp:DropDownList> 
                           
                           
                                    
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
                                          
                                  <asp:LinkButton ID="searchButton" CssClass="btn btn-sm btn-info mb-2" runat="server" OnClick="searchButton_Click" >   <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                          
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>

                       

                        <br/>
                     <div class="row">
           <div class="table-responsive" id="MainGradeDiv">
       
                      <asp:GridView ID="stockInTraGridView" runat="server" 
                                    AutoGenerateColumns="False" CssClass="table table-bordered  text-center thead-dark" DataKeyNames="SChalanId">
                                    <Columns>
                                        <asp:BoundField DataField="ChalanNo" HeaderText="ChalanNo" />
                                        <asp:BoundField DataField="ChalanDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                            HeaderText="ChalanDate" />
                                        <asp:BoundField DataField="TrackNo" HeaderText="TruckNo" />
                                        <asp:BoundField DataField="DriverName" HeaderText="DriverName" />
                                        <asp:HyperLinkField HeaderText="Receive Product" DataNavigateUrlFields="SChalanId" 
                                        DataNavigateUrlFormatString="ProductReceiveBySubDeport.aspx?ChalanId={0}"
                                            Text="Receive Product&gt;&gt;" />
                                    </Columns>
                                </asp:GridView>

          </div>
          </div>



                   

                        <br />
                   

                 
                        

                                </div>  
                              
                                </div>  
                                </div>  
              
                                </div>  
                                </div>  

                  </div>
     </ContentTemplate>
    </asp:UpdatePanel> 
</asp:Content>

