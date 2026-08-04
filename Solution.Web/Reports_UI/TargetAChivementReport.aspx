<%@ Page Title="Target Achievement Report" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TargetAChivementReport.aspx.cs" Inherits="Reports_UI_TargetAChivementReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <div id="popDiv"></div>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Target Achievement Report</div>

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

                                <div class="col-4" runat="server" visible="false">



                                    <div class="form-group row">
                                        <label for="UserRoleSelect" class="col-sm-4 col-form-label">Year:  </label>

                                        <div class="col-sm-8">

                                            <asp:DropDownList runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlmonth_SelectedIndexChanged" ID="ddlYear" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                           
                                            <asp:DropDownList runat="server" Visible="false" ID="UserRoleSelect" name="UserRoleSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                        </div>

                                    </div>

                                    <div class="form-group row">
                                        <label for="EmployeeIdSelect" class="col-sm-4 col-form-label">Month:  </label>

                                        <div class="col-sm-8">
                                            <asp:DropDownList runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlmonth_SelectedIndexChanged" ID="ddlmonth" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                            <asp:DropDownList Visible="false" runat="server" ID="EmployeeIdSelect" name="EmployeeIdSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                        </div>

                                    </div>


                                </div>
                                <div class="col-4">



                                    <div class="form-group row">


                                        <label for="FromDate" class="col-sm-4 col-form-label">From Date:  </label>

                                        <div class="col-sm-8">
                                            <asp:TextBox runat="server" ID="FromDate" type="text" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Date"></asp:TextBox>


                                        </div>

                                    </div>

                                    <div class="form-group row">
                                        <label for="ToDate" class="col-sm-4 col-form-label">To Date:  </label>

                                        <div class="col-sm-8">
                                            <asp:TextBox runat="server" ID="ToDate" type="text" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Date"></asp:TextBox>
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

                                <div class="col-4">

                                    <div class="form-group row">
                                        <label for="UserRoleSelect" class="col-sm-4 col-form-label">Zone:  </label>

                                        <div class="col-sm-8">

                                            <asp:DropDownList runat="server" ID="ZoneSelect"  AutoPostBack="true" OnSelectedIndexChanged="ZoneSelect_SelectedIndexChanged"  CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                        </div>

                                    </div>

                                    <div class="form-group row">
                                        <label for="UserRoleSelect" class="col-sm-4 col-form-label">Area:  </label>

                                        <div class="col-sm-8">

                                             <asp:DropDownList runat="server"   id="AreaSelect"  AutoPostBack="true" OnSelectedIndexChanged="AreaSelect_SelectedIndexChanged" CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                            </div>

                                    </div>

                                    <div class="form-group row">
                                        <label for="UserRoleSelect" class="col-sm-4 col-form-label">Territory:  </label>

                                        <div class="col-sm-8">

                                            <asp:DropDownList runat="server"    id="TeritorySelect"     CssClass="form-select form-select-sm mb-3 mySelect2">   </asp:DropDownList>

                                            </div>

                                    </div>

                                </div>
                            </div>


                            <div class="row">
                                <div class="col-1">
                                </div>


                                <div class="col-5">
                                </div>
                                <div class="col-5">
                                </div>
                            </div>


                            <div class="row" runat="server" visible="false">

                                <div class="col-1">
                                </div>
                                <div class="col-5">
                                    <div class="form-group row">
                                        <label for="UserRoleSelect" class="col-sm-4 col-form-label">Approval Status:  </label>

                                        <div class="col-sm-8">


                                            <asp:DropDownList runat="server" ID="ApprovalStatusSelect" name="ApprovalStatusSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                        </div>

                                    </div>

                                </div>
                            </div>


                            <br />

                            <div class="row">
                                <div class="col-md-5">
                                </div>
                                <div class="col-md-4" style="align-content: center">

                                    <asp:LinkButton runat="server" ID="btnSearch" class="btn btnMyDesignSearch   btn-sm " OnClick="btnSearch_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>


                                    <asp:LinkButton runat="server" class="btn btnMyDesignReset   btn-sm" ID="resetBtn" OnClick="resetBtn_Click"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>

                                </div>
                            </div>
                            <div style="padding-top: 10px;"></div>
                            <div class="row">
                                <div class="col-md-12">
                                    <label></label>
                                </div>


                                <div class="col-md-2">
                                </div>
                                <div class="col-md-2">
                                </div>
                                <div class="col-md-2">
                                </div>
                                <div class="col-md-1">
                                </div>

                                <div class="col-md-2" style="margin-top: 5px;">
                                </div>


                                <div class="col-md-3">
                                    <asp:LinkButton ID="btnExportToExcel" runat="server" CssClass="btn btn-success pull-right" OnClick="btnExportToExcel_Click"><span aria-hidden="true" class="fa fa-file-excel-o" ></span> &nbsp;Export To Excel</asp:LinkButton>




                                </div>
                            </div>
                            <br />


                            <div class="table-responsive" id="MainGrsadeDiv">



                                <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                    CssClass="table table-striped table-bordered" OnRowCommand="loadGridView_RowCommand" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging">
                                    <Columns>



                                        <asp:BoundField DataField="SerialNo" HeaderText="SL#" />
                                        <asp:BoundField DataField="TerritoryName" HeaderText="Territory Code/Name" />

                                        <asp:BoundField DataField="TargetValue" HeaderText="Target" />
                                        <asp:BoundField DataField="OrderValue" HeaderText="Order" />

                                        <asp:BoundField DataField="OrderAchiv" HeaderText="Ach%" />
                                        <asp:BoundField DataField="InvoiceValue" HeaderText="Invoice" />

                                        <asp:BoundField DataField="InvoiceAchiv" HeaderText="Ach%" />

                                        <asp:BoundField DataField="SalesValue" HeaderText="Sales" />

                                        <asp:BoundField DataField="SalesAchiv" HeaderText="Ach%" />



                                    </Columns>
                                    <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                                </asp:GridView>


                                <div style="display: none">
                                    <asp:GridView ID="gv_Export" runat="server" AutoGenerateColumns="False"
                                        CssClass="table table-striped table-bordered" OnRowCommand="loadGridView_RowCommand" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging">
                                        <Columns>


                                            <asp:BoundField DataField="TerritoryName" HeaderText="Territory Code/Name" />

                                            <asp:BoundField DataField="TargetValue" HeaderText="Target" />
                                            <asp:BoundField DataField="OrderValue" HeaderText="Order" />

                                            <asp:BoundField DataField="OrderAchiv" HeaderText="Ach%" />
                                            <asp:BoundField DataField="InvoiceValue" HeaderText="Invoice" />

                                            <asp:BoundField DataField="InvoiceAchiv" HeaderText="Ach%" />

                                            <asp:BoundField DataField="SalesValue" HeaderText="Sales" />

                                            <asp:BoundField DataField="SalesAchiv" HeaderText="Ach%" />


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

