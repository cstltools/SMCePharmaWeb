<%@ Page Title="DA Information List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TADAClaimView.aspx.cs" Inherits="DoctorModule_UI_TADAClaimView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    <div id="popDiv"></div>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>DA Information List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">

                      
                         <a href="../DoctorModule_UI/TADAClaimEdit.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                           
                                 <asp:HiddenField ID="hfEmpTerrId" runat="server" />
     <asp:HiddenField ID="hfEmpAreaId" runat="server" />
     <asp:HiddenField ID="hfEmpRegionId" runat="server" />
     <asp:HiddenField ID="hfEmpGroupId" runat="server" />

                                   <%-- <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                                  <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>--%>
                                              <div class="row">
                                                           <div class="col-1">
                                                               </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="FromDate" class="col-sm-4 col-form-label">From Date:  </label>

                                    <div class="col-sm-8">
                                         <asp:TextBox  runat="server"  id="FromDate" type="text" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Date" ></asp:TextBox>
                                        
                                                  <script type="text/javascript">
                                                      function pageLoad() {

                                                          $('.multiple-select').select2({
                                                              includeSelectAllOption: true,
                                                              theme: 'bootstrap4',
                                                              width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                              placeholder: $(this).data('placeholder'),
                                                              allowClear: Boolean($(this).data('allow-clear')),
                                                          });
                                                          $('.datepicker').pickadate({
                                                              selectMonths: true,
                                                              selectYears: true
                                                          });
                                                          $('.mySelect2').select2({
                                                              theme: 'bootstrap4',
                                                              width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                              placeholder: $(this).data('placeholder'),
                                                              allowClear: Boolean($(this).data('allow-clear')),
                                                          });

                                                          $(".fancybox").fancybox({
                                                              openEffect: "none",
                                                              closeEffect: "none"
                                                          });

                                                          $(".zoom").hover(function () {

                                                              $(this).addClass('transition');
                                                          }, function () {

                                                              $(this).removeClass('transition');
                                                          });
                                                      }

                                                  </script>
                                    </div>

                                </div>

                            </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="EmployeeIdSelect" class="col-sm-4 col-form-label">Employee:  </label>

                                    <div class="col-sm-8">


                                        <asp:DropDownList  runat="server"   id="EmployeeIdSelect" name="EmployeeIdSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                    </div>

                                </div>

                            </div>
                        </div>

                      
                        <div class="row">
                             <div class="col-1">
                                                               </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="ToDate" class="col-sm-4 col-form-label">To Date:  </label>

                                    <div class="col-sm-8">
                                         <asp:TextBox  runat="server"  id="ToDate" type="text" class="form-control form-control-sm mb-3 datepicker"   autocomplete="off" placeholder="Select Date"></asp:TextBox>

                                    </div>

                                </div>

                            </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="UserRoleSelect" class="col-sm-4 col-form-label">User Role:  </label>

                                    <div class="col-sm-8">


                                        <asp:DropDownList  runat="server"   id="UserRoleSelect" name="UserRoleSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                    </div>

                                </div>

                            </div>
                        </div>

                      
                        <div class="row">

                             <div class="col-1">
                                                               </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="UserRoleSelect" class="col-sm-4 col-form-label">Approval Status:  </label>

                                    <div class="col-sm-8">


                                              <asp:DropDownList  runat="server"   id="ApprovalStatusSelect" name="ApprovalStatusSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                    </div>

                                </div>

                            </div>
                        </div>

 
<br />        
                    
                        <div class="row">
                            <div class="col-md-5">
                            </div>
                            <div class="col-md-4" style="align-content:center">

                                   <asp:LinkButton runat="server"  id="btnSearch" class="btn btnMyDesignSearch   btn-sm "  onclick="btnSearch_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                                  
                                
                               <asp:LinkButton  runat="server" class="btn btnMyDesignReset   btn-sm"   id="resetBtn" onclick="resetBtn_Click" ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                
                            </div>
                        </div>
                        <div style="padding-top:10px;"></div>
                    <div class="row">
                 <div class="col-md-12">
                                       <label>  </label>
                                       </div>
                                   
                                   
                                   <div class="col-md-2">
                                       
                                       
                                       </div>
                                   <div class="col-md-2">
                                       
                                       
                                       </div>
                                   <div class="col-md-2">
                                       
                                       
                                       </div>
                                     <div class="col-md-1">
                                       
                                       
                                       </div>
                              
                                   <div class="col-md-2"   style="margin-top: 5px;">
                                         
                                       
                                       </div>
                                  
                                  
                                     <div class="col-md-3">
                                         <asp:LinkButton ID="btnExportToExcel" runat="server" CssClass="btn btn-success pull-right" OnClick="btnExportToExcel_Click" ><span aria-hidden="true" class="fa fa-file-excel-o" ></span> &nbsp;Export To Excel</asp:LinkButton> 
                                       
                                      
                                       
        
  </div>
                     </div>
                                            <br />


                                            <div class="table-responsive" id="MainGrsadeDiv">
 


                                                                    <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                  DataKeyNames="TadaID" 
                                 CssClass="table table-striped table-bordered"  onrowcommand="loadGridView_RowCommand" OnPreRender="gv_DocumentUpload_PreRender"  AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging">
                                <Columns>

                                     <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="TadaDate" HeaderText="Claim Date" />
                                   
                                    <asp:BoundField DataField="EmpMasterCode" HeaderText="Employee ID" />
                               <asp:BoundField DataField="EmpName" HeaderText="Employee Name" />

                                       <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                    <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />

                                    <asp:BoundField DataField="DaAmt" HeaderText="DA Amount" />
                                 
                                    <asp:BoundField DataField="StationTypeName" HeaderText="Tour Type" />
                                    <asp:BoundField DataField="HotelName" HeaderText="Hotel Name" />
                                    <asp:BoundField DataField="HotelPhone" HeaderText="Hotel Phone No" />

                                     <asp:TemplateField HeaderText="Image">
                                        <ItemTemplate>
                                            <a href='<%#Eval("ImageString")%>'
             ID="hpImg"
             runat="server" class="fancybox "  >
                          
                                               <asp:Image ID="imgShow" runat="server" CssClass="imgCSS"   ImageUrl='<%#Eval("ImageString")%>'  Width="45" Height="45"  />
                                                </a>
                                            </ItemTemplate>
                                         </asp:TemplateField>
                                        <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status"  /> 
                                   
                                    <asp:BoundField DataField="CreateBy" HeaderText="Created By"  /> 
                                    <asp:BoundField DataField="EntryDate" HeaderText="Created At"  /> 
                                 
                                 

                                        <asp:BoundField DataField="UpdateBy" HeaderText="Updated By"  /> 
                                    <asp:BoundField DataField="UpdateDate" HeaderText="Updated At"  /> 

                                     <asp:BoundField DataField="" HeaderText="Forwarded By"  /> 
                                    <asp:BoundField DataField="" HeaderText="Forwarded At"  /> 

                                    
                                     <asp:BoundField DataField="ApprovalLog" HeaderText="Approved By"  /> 
                                    <asp:BoundField DataField="ApproveDate" HeaderText="Approved At"  /> 

                                    


                                    <asp:TemplateField HeaderText="Edit">
                                        <ItemTemplate>

                                               <a    target='_blank' style='font-size:20px' href='TADAClaimEdit.aspx?MID=<%# Eval("TadaID") %>'  class="btn-warning  btn-sm mb-1 mb-md-0"
                                                                     ><i class='bx bxs-edit' aria-hidden='true'></i></a>
                                             
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                  
                                </Columns>
                                                                         <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                            </asp:GridView>
                         
                     
                                                <div style="display:none">
                                                           <asp:GridView ID="gv_Export" runat="server" AutoGenerateColumns="False"
                                  DataKeyNames="TadaID" 
                                 CssClass="table table-striped table-bordered"  onrowcommand="loadGridView_RowCommand" OnPreRender="gv_DocumentUpload_PreRender"  AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging">
                                <Columns>

                                    
                                    <asp:BoundField DataField="TadaDate" HeaderText="Claim Date" />
                                   
                                    <asp:BoundField DataField="EmpMasterCode" HeaderText="Employee ID" />
                               <asp:BoundField DataField="EmpName" HeaderText="Employee Name" />

                                       <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                    <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />

                                    <asp:BoundField DataField="DaAmt" HeaderText="DA Amount" />
                                 
                                    <asp:BoundField DataField="StationTypeName" HeaderText="Tour Type" />
                                    <asp:BoundField DataField="HotelName" HeaderText="Hotel Name" />
                                    <asp:BoundField DataField="HotelPhone" HeaderText="Hotel Phone No" />
 
                                        <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status"  /> 
                                   
                                    <asp:BoundField DataField="CreateBy" HeaderText="Created By"  /> 
                                    <asp:BoundField DataField="EntryDate" HeaderText="Created At"  /> 
                                 
                                 

                                        <asp:BoundField DataField="UpdateBy" HeaderText="Updated By"  /> 
                                    <asp:BoundField DataField="UpdateDate" HeaderText="Updated At"  /> 

                                     <asp:BoundField DataField="" HeaderText="Forwarded By"  /> 
                                    <asp:BoundField DataField="" HeaderText="Forwarded At"  /> 

                                    
                                     <asp:BoundField DataField="ApprovalLog" HeaderText="Approved By"  /> 
                                    <asp:BoundField DataField="ApproveDate" HeaderText="Approved At"  /> 

                                    


                               
                                  
                                </Columns>
                                                                         <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                            </asp:GridView>
                         
                                                </div>
                                          
                                                </div>
                                                </div>
                                               
                                                </div>
                                                </div>
                                                </div>
                                                </div>
                                                </div>
                                               

  <%--  </ContentTemplate>
                                          </asp:UpdatePanel>
                                 --%>
                   
 
  
                    


    <%-- <script>

         $(document).ready(function () {

             var table = $('#ContentPlaceHolder1_loadGridView').DataTable(
                 {
                     "bInfo": true,
                     "bFilter": true,
                     lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                     pageLength: 10,
                     dom: 'lBfrtip',


                     buttons: ['copy', 'excel', 'pdf', 'print']
                 }
             );

             var prm = Sys.WebForms.PageRequestManager.getInstance();
             if (prm != null) {
                 prm.add_endRequest(function (sender, e) {
                     if (sender._postBackSettings.panelsToUpdate != null) {
                         table = $('#ContentPlaceHolder1_loadGridView').DataTable(
                             {
                                 "bInfo": true,
                                 "bFilter": true,
                                 lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                                 pageLength: 10,
                                 dom: 'lBfrtip',


                                 buttons: ['copy', 'excel', 'pdf', 'print']


                             }
                         );
                     }
                 });
             };


             table.columns().every(function () {
                 var that = this;


             });
         });


     </script>--%>




</asp:Content>

