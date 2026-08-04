<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DepotStockAdjustmentsVoucherView.aspx.cs" Inherits="SInventory_UI_DirectStockOutView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Depot Stock Adjustments Voucher List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                         
                             <a href="DepotStockAdjustmentsVoucher.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                       
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

                        <div class="row">
                                        <div class="table-responsive" id="MainGradeDiv">

                                                

                                           <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                  DataKeyNames="DcStockOutMasterId,Status" 
                                onrowcommand="loadGridView_RowCommand"      CssClass="table table-striped table-bordered"  OnPreRender="gv_DocumentUpload_PreRender" >
                                <Columns>
                                    <asp:BoundField DataField="ComUnitName" HeaderText="ComUnit Name" />
                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" />
                                    <asp:BoundField DataField="Reason" HeaderText="Reason" />
                                    <asp:BoundField DataField="StockOutDate" HeaderText="StockOutDate " DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="Status" HeaderText="Status" />
                                    <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="DeleteData" ImageUrl="~/images/delete.png"
                                                             OnClientClick="return GetConfirmation();"/>
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
                                            <asp:ImageButton ID="reportImageButton" runat="server" 
                                                             CommandArgument="<%# Container.DataItemIndex %>" CommandName="ReportView" ImageUrl="~/images/report-disk-icon.png"
                                                           />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                                            </div>
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

