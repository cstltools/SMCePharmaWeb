<%@ Page Title="Target Achievement Report" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TargetAChivementReportNew.aspx.cs" Inherits="Reports_UI_TargetAChivementReportNew" %>
<%@ Register Src="~/Reports_UI/IVMarketSTForZoneReport.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

     <style>
     .radioChoice label {
         padding-left: 5px;
         padding-right: 30px;
         font-size: 20px;
         font-weight: bold;
     }

          .radioChoice2 label {
         padding-left: 5px;
         padding-right: 30px;
         font-size: 16px;
         font-weight: bold;
     }


          
     .Label_Title {
         background-color: #C7C7C7;
         width: 100%;
         text-align: center;
         margin: 0px;
         padding: 3px;
         text-align: center;
         color: #000;
         margin-right: 5%;
         font-weight: bold;
         font-size: 13px;
     }
 </style>

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

         
                    <div class="col-sm-2" >
                   
                        <div class="Label_Title  ">Report Type </div>
                            
                                <div class="form-group">
                        
                    <asp:RadioButtonList runat="server" ID="rbReportTypeName" CssClass="radioChoice2" AutoPostBack="True" OnSelectedIndexChanged="rbReportTypeName_SelectedIndexChanged"   RepeatDirection="Horizontal" RepeatColumns="1" RepeatLayout="Flow">
                     <%--   <asp:ListItem Value="1">User Wise</asp:ListItem>--%>

                   
                        <asp:ListItem  Selected="True" Value="1">Zone</asp:ListItem> 
                        <asp:ListItem Value="2">Area</asp:ListItem> 
                        <asp:ListItem Value="3">Territory</asp:ListItem> 

                    </asp:RadioButtonList>
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

         <div class="col-3" id="divMrk"  runat="server" visible="false">
           <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />

    </div>

        <div class="col-3">


            <div class="form-group row" runat="server">
                <label for="mainName" class="col-sm-5 col-form-label">From Date:  <span style="color: red">*</span></label>

                <div class="col-sm-7">
                    <asp:TextBox ID="fromDateTextBox" runat="server" AutoPostBack="true"   OnTextChanged="fromDateTextBox_TextChanged" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select  From Date"></asp:TextBox>





                </div>

            </div>

            <div class="form-group row" runat="server">
                <label for="mainName" class="col-sm-5 col-form-label">To Date:  <span style="color: red">*</span></label>

                <div class="col-sm-7">

                    <asp:TextBox ID="toDateTextBox" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select To Date"></asp:TextBox>




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



                                <asp:GridView ID="gv_Zone" runat="server" AutoGenerateColumns="False"
                                    CssClass="table table-striped table-bordered" OnRowCommand="loadGridView_RowCommand" ShowFooter="true" OnPreRender="gv_DocumentUpload_PreRender">
                                    <Columns>



                                        <asp:BoundField DataField="SerialNo" HeaderText="SL#" />
                                        <asp:BoundField DataField="RegionName" HeaderText="Zone Code/Name" />

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

                <asp:GridView ID="gv_Area" runat="server" AutoGenerateColumns="False" ShowFooter="true"
                                    CssClass="table table-striped table-bordered" OnRowCommand="loadGridView_RowCommand" OnPreRender="gv_DocumentUpload_PreRender" >
                                    <Columns>



                                        <asp:BoundField DataField="SerialNo" HeaderText="SL#" />
                                           <asp:BoundField DataField="RegionName" HeaderText="Zone Code/Name" />
                                        <asp:BoundField DataField="AreaName" HeaderText="Area Code/Name" />

                                        <asp:BoundField DataField="TargetValue" HeaderText="Target" />
                                        <asp:BoundField DataField="OrderValue" HeaderText="Order" />

                                        <asp:BoundField DataField="OrderAchiv" HeaderText="Ach%" />
                                        <asp:BoundField DataField="InvoiceValue" HeaderText="Invoice" />

                                        <asp:BoundField DataField="InvoiceAchiv" HeaderText="Ach%" />

                                        <asp:BoundField DataField="SalesValue" HeaderText="Sales" />

                                        <asp:BoundField DataField="SalesAchiv" HeaderText="Ach%" />



                                    </Columns>
                                
                                </asp:GridView>

                <asp:GridView ID="gv_Territory" runat="server" AutoGenerateColumns="False" ShowFooter="true"
                                    CssClass="table table-striped table-bordered" OnRowCommand="loadGridView_RowCommand" OnPreRender="gv_DocumentUpload_PreRender" >
                                    <Columns>



                                        <asp:BoundField DataField="SerialNo" HeaderText="SL#" />
                                       <asp:BoundField DataField="RegionName" HeaderText="Zone Code/Name" />
 <asp:BoundField DataField="AreaName" HeaderText="Area Code/Name" />

                                        <asp:BoundField DataField="TerritoryName" HeaderText="Territory Code/Name" />

                                        <asp:BoundField DataField="TargetValue" HeaderText="Target" />
                                        <asp:BoundField DataField="OrderValue" HeaderText="Order" />

                                        <asp:BoundField DataField="OrderAchiv" HeaderText="Ach%" />
                                        <asp:BoundField DataField="InvoiceValue" HeaderText="Invoice" />

                                        <asp:BoundField DataField="InvoiceAchiv" HeaderText="Ach%" />

                                        <asp:BoundField DataField="SalesValue" HeaderText="Sales" />

                                        <asp:BoundField DataField="SalesAchiv" HeaderText="Ach%" />



                                    </Columns>
                                 
                                </asp:GridView>


                    
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

