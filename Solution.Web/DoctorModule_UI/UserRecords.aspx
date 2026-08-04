<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="UserRecords.aspx.cs" Inherits="DoctorModule_UI_UserRecords" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> User  List </div>  

                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="../DoctorModule_UI/UserSetup.aspx" runat="server" id="btnEntry" class="btn btn-sm btn-outline-info "><i class="fa fa-plus" aria-hidden="true"></i>New Entry</a>
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
                                                 })
                                                 $('.mySelect2').select2({
                                                     theme: 'bootstrap4',
                                                     width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                     placeholder: $(this).data('placeholder'),
                                                     allowClear: Boolean($(this).data('allow-clear')),
                                                 });
                                             }
                                         </script>
                                        <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="acDate" class="col-sm-3 col-form-label"> User Role:</label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                              <asp:DropDownList  runat="server"  class="form-select form-select-sm mb-3 mySelect2" id="ddlUserRole">
                                                 
                                                </asp:DropDownList>
                                                 
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>

                                        <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="acDate" class="col-sm-3 col-form-label">Active Status:</label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                              <asp:DropDownList  runat="server"  class="form-select form-select-sm mb-3 mySelect2" id="ddlActiveStatus">
                                                   <asp:ListItem Value="">All</asp:ListItem>
                                                   <asp:ListItem Value="Active">Active</asp:ListItem>
                                                  <asp:ListItem Value="Inactive">Inactive</asp:ListItem>
                                              </asp:DropDownList>
                                                 
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>

                                       <div style="padding-top:16px;"></div>
                        <div class="row">
                            <div class="col-md-5">
                            </div>
                            <div class="col-md-4" style="align-content:center">
                                <asp:LinkButton runat="server"  id="btnSearch" class="btn btnMyDesignSearch   btn-sm "  onclick="btnSearch_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                                  
                                
                               <asp:LinkButton  runat="server" class="btn btnMyDesignReset   btn-sm"   id="resetBtn" onclick="resetBtn_Click" ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                            </div>
                        </div>
                                    <br />
                            <div class="table-responsive" id="MainGradeDiv">


                                   <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="UserId" 
                                onrowcommand="loadGridView_RowCommand"  CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>

                                             <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                           

                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <%--<asp:BoundField DataField="UserName" HeaderText="User Name " />--%>
                                        <asp:BoundField DataField="EmpName" HeaderText="Employee Name" />
                                    <asp:BoundField DataField="LoginName" HeaderText="Login ID" />
                                
                                   <%-- <asp:BoundField DataField="Password" HeaderText="Password" />--%>
                                    <asp:BoundField DataField="RoleName" HeaderText="Role" />
                                    <asp:BoundField DataField="UserType" HeaderText="User Type" />
                                    <asp:BoundField DataField="UserStatus" HeaderText="Status" />
                                    <asp:BoundField DataField="ActiveInActiveDate" HeaderText="Active Or Inactive Date" />
                            
 
 

                                   
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>

                                               <asp:LinkButton ID="LinkButton1" runat="server" class="btn-warning  btn-sm mb-1 mb-md-0"
                                                                    CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData"><i class='bx bxs-edit' aria-hidden='true'></i></asp:LinkButton>
                                             
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

