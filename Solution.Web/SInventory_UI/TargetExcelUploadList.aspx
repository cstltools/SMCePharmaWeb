<%@ Page Title="Monthly Target List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TargetExcelUploadList.aspx.cs" Inherits="SInventory_UI_TargetExcelUploadList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">



    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Monthly Target List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">

                        <asp:LinkButton ID="EmpCetegoryAddImageButton" CssClass="btn btn-sm btn-outline-info " runat="server" OnClick="EmpCetegoryAddImageButton_Click"><i class="fa fa-plus" aria-hidden="true"></i> New Entry </asp:LinkButton>


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

                                           var dateNow = new Date();
                                           $('.datepickess').datepicker("setDate", dateNow);
                                           minDate: new Date() // to disable privious dates 
                                       </script>
                                   
                                    <div class="row">
                                                           <div class="col-1">
                                                               </div>
                            <div class="col-5"  style="display:none">
                                <div class="form-group row">
                                    <label for="FromDate" class="col-sm-4 col-form-label">From Date:  </label>

                                    <div class="col-sm-8">
                                         <asp:TextBox  runat="server"  id="FromDate" type="text" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Date" ></asp:TextBox>

                                    </div>

                                </div>

                            </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="EmployeeIdSelect" class="col-sm-4 col-form-label"> Financial Year  </label>

                                    <div class="col-sm-8">

    
  <asp:DropDownList  runat="server"  ID="ddlCampaignType"  class="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>
                                        <br />
                                           <asp:LinkButton runat="server"  id="btnSearch" class="btn btnMyDesignSearch   btn-sm "  onclick="btnSearch_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                                  

                                    </div>

                                </div>




                            </div>
                        </div>

                      
                        <div class="row" style="display:none">
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
                                    <label for="EmployeeIdSelect" class="col-sm-4 col-form-label">Active Status:  </label>

                                    <div class="col-sm-8">

          
  <asp:DropDownList  runat="server"  ID="ddlActive"  class="form-select form-select-sm mb-3 mySelect2 ">
      <asp:ListItem Value="">Select One</asp:ListItem>
      <asp:ListItem Value="1">Active</asp:ListItem>
      <asp:ListItem Value="0">Inactive</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>

                                </div>

                            </div>
                        </div>

                      
                        
 
                    
                        <div class="row"  style="display:none">
                            <div class="col-md-5">
                            </div>
                            <div class="col-md-4" style="align-content:center">

                                
                                
                               <asp:LinkButton  runat="server" class="btn btnMyDesignReset   btn-sm"   id="resetBtn" onclick="resetBtn_Click" ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                
                            </div>
                        </div>
                        <div style="padding-top:10px;"></div>



                                            <div class="table-responsive" id="MainGradeDiv">

                                              

                                                    <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="SL" 
                                onrowcommand="loadGridView_RowCommand"  CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>

                                     <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="EmpCode" HeaderText="Emp ID. " />
                                 
                                    <asp:BoundField DataField="EmpName" HeaderText="Emp Name" />
                                    <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                               <asp:BoundField DataField="TerritoryName" HeaderText="Territory Code/Name" />

                                    <asp:BoundField DataField="Value" HeaderText="Target Value" 
 />
                                    <asp:BoundField DataField="Month_Name" HeaderText="Month Name" />
                                    <asp:BoundField DataField="YearValue" HeaderText="Year" />
 

                                   
                                    <asp:TemplateField HeaderText="Edit">
                                        <ItemTemplate>

                                               <asp:LinkButton ID="lbEdit" runat="server" class="btn-warning  btn-sm mb-1 mb-md-0"
                                                                    CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData"><i class='bx bxs-edit' aria-hidden='true'></i></asp:LinkButton>
                                             
                                        </ItemTemplate>
                                    </asp:TemplateField>   



                                    <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>

                                               <asp:LinkButton ID="lbDelete" runat="server" class="btn-danger  btn-sm mb-1 mb-md-0"    OnClientClick="return sweetAlertConfirm_Delete(this);"  
                                                                    CommandArgument="<%# Container.DataItemIndex %>" CommandName="DeleteData"><i class='bx bxs-trash' aria-hidden='true'></i></asp:LinkButton>
                                             
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                                            </div>


                                    


                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
t>t>


    <script>

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


    </script>

</asp:Content>


