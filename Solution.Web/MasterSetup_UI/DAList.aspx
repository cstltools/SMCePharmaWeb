<%@ Page Title="DA List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DAList.aspx.cs" Inherits="MasterSetup_UI_DAList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>DA List</div>

                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="../MasterSetup_UI/DASetup.aspx" class="btn btn-sm btn-outline-info "><i class="fa fa-plus" aria-hidden="true"></i>New Entry</a>


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
                            <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" class="table table-striped table-bordered table-hover"
                                DataKeyNames="DAId" OnRowCommand="loadGridView_RowCommand" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                    <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                            <asp:HiddenField runat="server" ID="hfGatePassMasterId" Value='<%#Eval("DAId") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="DACode" HeaderText="DA Code" />
                                    <asp:BoundField DataField="Name" HeaderText="Name" />
                                    <asp:BoundField DataField="NID" HeaderText="NID" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="Depot Name" />
                                    <asp:BoundField DataField="JoiningDate" HeaderText="Joining Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="Address" HeaderText="Permanent Address" />
                                    <asp:BoundField DataField="PhoneNo" HeaderText="Phone No" />
                                    <asp:BoundField DataField="EmergencyContactNo" HeaderText="Emergency Contact No" />
                                    <asp:BoundField DataField="ReferenceName" HeaderText="Reference Name" />
                                    <asp:BoundField DataField="ReferencePhone" HeaderText="Reference Phone" />
                                    <asp:BoundField DataField="StatusText" HeaderText="Status" />
                                    <asp:BoundField DataField="ActiveInActiveDate" HeaderText="Active/Inactive Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                                    <asp:BoundField DataField="EntryBy" HeaderText="Entry By" />
                                    <asp:BoundField DataField="EntryDate" HeaderText="Entry Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="UpdateBy" HeaderText="Update By" />
                                    <asp:BoundField DataField="UpdateDate" HeaderText="Update Date"  DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:TemplateField HeaderText="Edit">
                                        <ItemTemplate>
                                            

                                              <asp:LinkButton ID="LinkButton1" runat="server" class="btn-warning  btn-sm mb-1 mb-md-0"
                                                                   CommandArgument='<%#Eval("DAId") %>' CommandName="EditData"><i class='bx bxs-edit' aria-hidden='true'></i></asp:LinkButton>
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

