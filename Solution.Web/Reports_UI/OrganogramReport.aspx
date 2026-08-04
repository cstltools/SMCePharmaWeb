<%@ Page Title="Organogram Report" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="OrganogramReport.aspx.cs" Inherits="Reports_UI_OrganogramReport" %>
<%@ Register Src="~/Reports_UI/IVMarketStructureMarket.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
 
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Organogram Report</div>
                
                <div class="ms-auto">
                    <div class="btn-group">

                        <asp:LinkButton ID="EmpCetegoryAddImageButton" Visible="false" CssClass="btn btn-sm btn-outline-info " runat="server" OnClick="EmpCetegoryAddImageButton_Click"><i class="fa fa-plus" aria-hidden="true"></i> New Entry </asp:LinkButton>


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
                                    <div class="row" style="margin-left:-200px;">
                                         <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
                                    </div>

                                         <div class="row">
         <div class="col-2">&nbsp;</div>
         <div class="col-8">

             <div class="form-group row">
                 <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                 <div class="col-sm-8">

                       <asp:LinkButton  OnClick="SearchButton_Click"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"   >
             <i class="fa fa-print" aria-hidden="true"></i>&nbsp; Search
         </asp:LinkButton>
         <asp:LinkButton  runat="server"    class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                   


                 </div>
             </div>

         </div>
         <div class="col-2">
                 
         </div>
     </div>


                                            <div class="table-responsive" id="MainGradeDiv">

                                               

                                                 <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                            
                                onrowcommand="loadGridView_RowCommand" CssClass="table table-striped table-bordered table-hover" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                    <asp:BoundField DataField="GroupName" HeaderText="Group" />
                                    <asp:BoundField DataField="NSMName" HeaderText="NSM Emp." />
                                    <asp:BoundField DataField="RegionName" HeaderText="Zone" />
                                    <asp:BoundField DataField="RSMName" HeaderText="DSM Emp." />
                                    <asp:BoundField DataField="AreaName" HeaderText="Area" />
                                    <asp:BoundField DataField="ASMName" HeaderText="AM Emp." />

                                    <asp:BoundField DataField="TerritoryName" HeaderText="Territory" />
                                     <asp:BoundField DataField="MIOName" HeaderText="MIO Emp." />
                                    <asp:BoundField DataField="SubTerritoryName" HeaderText="Sub-Territory" />
                                    <asp:BoundField DataField="MarketName" HeaderText="Market" />

                                    <asp:BoundField DataField="CustCount" HeaderText="Customer Count" />
                              
                                    <asp:BoundField DataField="DocCount" HeaderText="Doctor Count" />
                                    <asp:BoundField DataField="RouteCount" HeaderText="Distribution Route" />
                                 
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
                    deferRender: true,
                    scrollY: 300,
                    scrollCollapse: true,
                    scroller: true,
                    "bInfo": true,
                    "bFilter": true,
                    lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    pageLength: 10,
                    dom: 'lBfrtip',


                    //ordering: false,
                    //info: false,
                    buttons: ['copy', 'excel', 'pdf', 'print']
                }
            );

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            if (prm != null) {
                prm.add_endRequest(function (sender, e) {
                    if (sender._postBackSettings.panelsToUpdate != null) {
                        table = $('#ContentPlaceHolder1_loadGridView').DataTable(
                            {
                                deferRender: true,
                                scrollY: 300,
                                scrollCollapse: true,
                                scroller: true,
                                "bInfo": true,
                                "bFilter": true,
                                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                                pageLength: 10,
                                dom: 'lBfrtip',


                                //ordering: false,
                                //info: false,
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

