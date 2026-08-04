<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DoctorApprovalList.aspx.cs" Inherits="Approval_UI_DoctorApprovalList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Doctor Approval List</div>
                
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
                                   
                                    <div class="p-4 border rounded">
                                        <div class="row g-3 needs-validation">
                                             
                                            <asp:HiddenField ID="hfEmpTerrId" runat="server" />
                                            <asp:HiddenField ID="hfEmpAreaId" runat="server" />
                                            <asp:HiddenField ID="hfEmpRegionId" runat="server" />
                                            <asp:HiddenField ID="hfEmpGroupId" runat="server" />

                                            <div class="table-responsive" id="MainGradeDiv">

                                           

                                                    <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="DoctorId,DoctorApprovalId,FromEmpId,ToEmpId,Step,RoleTypeId,ToRoleTypeId,MaxStep"   onrowcommand="loadGridView_RowCommand"    
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>

                                        <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                                </asp:TemplateField>
                                    <asp:BoundField DataField="DoctorCode" HeaderText="Doctor Code" />
                                    <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />
                                      
                                    <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                                    <asp:BoundField DataField="DegreeName" HeaderText="Degree" />
                                    <asp:BoundField DataField="DoctorSpeciality" HeaderText="Doctor Speciality" />
                                      <asp:BoundField DataField="SMCType" HeaderText="Pharma Platform" />

                                    <asp:BoundField DataField="ProgramTypeName" HeaderText="Provider Type" />

                                        <asp:BoundField DataField="RegionCode" HeaderText="Zone" />

                                      <asp:BoundField DataField="AreaCode" HeaderText="Area" />

                                    
                                      <asp:BoundField DataField="TerritoryCode" HeaderText="Territory" />
                                     <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />
                                      <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                    
                                    
                                  

                                    <asp:BoundField DataField="ApprovalStatusWeb" HeaderText="Approval Status" />

                                       <asp:BoundField DataField="WaitingForRole" HeaderText="Waiting For" />
                                    <asp:BoundField DataField="EmpMasterCode" HeaderText="Entry By" />
                                    <asp:BoundField DataField="EntryDate" HeaderText="Entry Date" />

                                    
                                  <%--  <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                                    <asp:BoundField DataField="DegreeName" HeaderText="Degree" />
                                    <asp:BoundField DataField="DoctorSpeciality" HeaderText="Doctor Speciality" />--%>
                                
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                              <asp:HiddenField runat="server" ID="hfDoctorId" Value='<%#Eval("DoctorId")%>' />
                                              <asp:HiddenField runat="server" ID="hfFromEmpId" Value='<%#Eval("FromEmpId")%>' />
                                              <asp:HiddenField runat="server" ID="hfToEmpId" Value='<%#Eval("ToEmpId")%>' />
                                              <asp:HiddenField runat="server" ID="hfStep" Value='<%#Eval("Step")%>' />
                                              <asp:HiddenField runat="server" ID="hfRoleTypeId" Value='<%#Eval("RoleTypeId")%>' />
                                              <asp:HiddenField runat="server" ID="hfDoctorApprovalId" Value='<%#Eval("DoctorApprovalId")%>' />
                                             <asp:HiddenField runat="server" ID="hfToRoleTypeId" Value='<%#Eval("ToRoleTypeId")%>' />

                                             <asp:Label runat="server" ID="lbMsg"   />
                                                <asp:LinkButton ID="lbEdit" runat="server" class="btn-warning  btn-sm mb-1 mb-md-0"
                                                                    CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData"><i class='bx bxs-edit' aria-hidden='true'></i></asp:LinkButton>
                                             
                                               <asp:LinkButton ID="lbApprove" runat="server" class="btn-info  btn-sm mb-1 mb-md-0"
                                                                     OnClientClick="showLoading(this);" CommandArgument="<%# Container.DataItemIndex %>" CommandName="ApproveData"><i class='fa fa-check' aria-hidden='true'></i></asp:LinkButton>

                                            
                                               <asp:LinkButton ID="lbReject" runat="server" class="btn-danger  btn-sm mb-1 mb-md-0"
                                                                     OnClientClick="showLoading(this);" CommandArgument="<%# Container.DataItemIndex %>" CommandName="RejectData"><i class='fadeIn animated bx bx-x' aria-hidden='true'></i></asp:LinkButton>
                                             
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                                            </div>


                                          
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
                    "bStateSave": true,
                    "bDestroy": true,
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
                                "bStateSave": true,
                                "bDestroy": true,
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


        function showLoading(element) {
            // Add a spinner icon and disable pointer events
            element.innerHTML = '<i class="fa fa-spinner fa-spin"></i>';
            element.style.pointerEvents = 'none';
        }
    </script>
</asp:Content>

