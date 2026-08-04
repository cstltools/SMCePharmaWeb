<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SalesReturnListSubdeport.aspx.cs" Inherits="SInventory_UI_SalesReturnListSubdeport" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    

     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Sales Return (Sub-Depot) List</div>
                
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
                                    
                                    
                                    
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">From Date:</label>

                                                <div class="col-sm-5">

                                                                           <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="form-control form-control-sm datepicker"></asp:TextBox>

                                                   

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
                                                <label for="mainName" class="col-sm-3 col-form-label">To Date:</label>

                                                <div class="col-sm-5">


                                                                         <asp:TextBox ID="toDateTextBox" runat="server" CssClass="form-control form-control-sm datepicker"></asp:TextBox>


                                                </div>
                                                
                                            </div>

                                                     <div class="form-group row" >
                                                <label for="mainName" class="col-sm-3 col-form-label">DC:</label>

                                                <div class="col-sm-5">

 <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                  CssClass="form-select form-select-sm mb-3 mySelect2">
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

                                                     
                          

                                                            <asp:LinkButton  OnClick="Button1_Click"   runat="server" id="SearchButton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-search"></i> Search
                                        </asp:LinkButton>

                                                      

                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                  

                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>

                                    <br />

                                   


                                            <div class="table-responsive" id="MainGradeDiv">
                                                  <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                 CssClass="table table-striped table-bordered table-hover" OnPreRender="gv_DocumentUpload_PreRender"  DataKeyNames="ReturnInvoiceId" 
                                onrowcommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="ReturnInvoiceNo" HeaderText="ReturnInvoiceNo" />
                                    <asp:BoundField DataField="CustomerCode" HeaderText="CustomerCode" />
                                    <asp:BoundField DataField="TpTotal" HeaderText="TpTotal" />
                                
                                    <asp:TemplateField HeaderText="Report">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="rptImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="reportData" 
                                                ImageUrl="~/images/viewlists.png" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                                               <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                                 CssClass="table table-striped table-bordered table-hover" OnPreRender="gv_DocumentUpload_PreRender" DataKeyNames="SubDcStockOutMasterId,Status" 
                                onrowcommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="ComUnitName" HeaderText="Com Unit Name" />
                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" />
                                    <asp:BoundField DataField="Reason" HeaderText="Reason" />
                                    <asp:BoundField DataField="StockOutDate" HeaderText="StockOut Date " DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="Status" HeaderText="Status" />
                                    <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="DeleteData"  CssClass="btn-danger  btn-sm mb-1 mb-md-0"
                                                             OnClientClick="return GetConfirmation();"> <i class="bx bxs-trash " aria-hidden="true"></i> </asp:LinkButton>
                                            <script type="text/javascript">
                                                function GetConfirmation() {
                                                    var reply = confirm("Ary you sure you want to delete this?");
                                                    if (reply) {
                                                        return true;
                                                    }
                                                    else {
                                                        return false;
                                                    }
                                                }
                                            </script>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Report">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="reportImageButton" runat="server" 
                                                             CommandArgument="<%# Container.DataItemIndex %>"  CssClass="btn-success  btn-sm mb-1 mb-md-0" CommandName="ReportView" 
                                                           ><i class="bx bxs-report " aria-hidden="true"></i></asp:LinkButton>
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

