<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DoctorUpdationApprove.aspx.cs" Inherits="TransferUI_DoctorUpdationApprove" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Doctor Updation Approval</div>
                
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
                                    



                                            <div class="table-responsive" id="MainGradeDiv">

                                               

                                                 <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                            
                                onrowcommand="loadGridView_RowCommand" CssClass="table table-striped table-bordered table-hover" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                    <asp:BoundField DataField="ConvertType" HeaderText="Transfer Type" />
                                    <asp:BoundField DataField="EmpEntryBy" HeaderText="Entry By" />
                                    <asp:BoundField DataField="EntryDate" HeaderText="Entry Date" />
                                    
                               
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                              <asp:HiddenField runat="server" ID="hfCustPropMasterId" Value='<%#Eval("CustPropMasterId")%>' />
                                              
                                           
                                           <asp:LinkButton ID="lbApprove" runat="server" class="btn-info  btn-sm mb-1 mb-md-0"
                                                                     CommandArgument="<%# Container.DataItemIndex %>" CommandName="ApproveData"><i class='fa fa-check' aria-hidden='true'></i> Transfer</asp:LinkButton>
                                              
                                             
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

