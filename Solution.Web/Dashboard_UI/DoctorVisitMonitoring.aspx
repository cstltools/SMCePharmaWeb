<%@ Page Title="6/10 Project Monitoring Report" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DoctorVisitMonitoring.aspx.cs" Inherits="Dashboard_UI_DoctorVisitMonitoring" %>

<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>
<%@ Register Src="~/SInventory_UI/IVMarketSTForZone.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <style>
        .modalBackground {
    background-color: #262626 !important;
    opacity: 0.5 !important;
}

.modalPopup {
    background-color: #fff !important;
    width: 90%;
    border-left: 3px solid #4D97C2 !important;
    border-radius: 12px;
    box-shadow: 1px 1px 4px 1px rgba(0,0,0,0.41) !important;
}

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>6/10 Project Monitoring Report</div>

                <div class="ms-auto">
                    <div class="btn-group">

                        <%--<asp:LinkButton ID="EmpCetegoryAddImageButton" Visible="false" CssClass="btn btn-sm btn-outline-info " runat="server" OnClick="EmpCetegoryAddImageButton_Click"><i class="fa fa-plus" aria-hidden="true"></i> New Entry </asp:LinkButton>--%>
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                        <%--    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                    <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                                        <ProgressTemplate>

                                            <div class="divWaiting">
                                                <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                                            </div>
                                        </ProgressTemplate>
                                    </asp:UpdateProgress>--%>
                                    <script type="text/javascript">


                                        function pageLoad() {


                                            $('.datepicker').pickadate({
                                                selectMonths: true,
                                                selectYears: true
                                            })
                                            $('.multiple-select').select2({
                                                includeSelectAllOption: true,
                                                theme: 'bootstrap4',
                                                width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                placeholder: $(this).data('placeholder'),
                                                allowClear: Boolean($(this).data('allow-clear')),
                                            });
                                            $('.mySelect2').select2({
                                                theme: 'bootstrap4',
                                                width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                placeholder: $(this).data('placeholder'),
                                                allowClear: Boolean($(this).data('allow-clear')),
                                            });
                                        }
                                    </script>


                                    <div style="padding: 2px!important"></div>

                                    <div class="row">
                                    
                                            <div class="col-4">
                                                  
      <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />

 
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

     </div>

 </div>
                                        </div>
                                      

                                           
                                        </div>

                                        <div class="col-4" style="display:none">

                                            <div class="form-group row">

                                                <label for="UserRoleSelect" class="col-sm-4 col-form-label">Approval Status:  </label>

                                                <div class="col-sm-8">

                                                    <asp:DropDownList runat="server" ID="ApprovalStatusSelect" name="ApprovalStatusSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                
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
                                    <br />


                                    <div class="table-responsive" id="MainGradeDiv">



                                        <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                            DataKeyNames="" OnRowCommand="loadGridView_RowCommand" OnRowDataBound="loadGridView_RowDataBound"
                                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                            <Columns>
                                                <asp:TemplateField HeaderText="SL">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                                          <asp:HiddenField runat="server" ID="hfEmpInfoId" Value='<%#Eval("EmpInfoId")%>' />
<asp:HiddenField runat="server" ID="hfRoleType" Value='<%#Eval("RoleType")%>' />
                                                          
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="ID" HeaderText="ID" />
                                              
                                                                                                   <asp:TemplateField HeaderText="Territory">
        <ItemTemplate>
               <asp:Label runat="server" ID="lblTerritory" Text='<%#Eval("Territory")%>' />
                </ItemTemplate>
</asp:TemplateField>

                                                <asp:BoundField DataField="EmployeeName" HeaderText="Name Of the Employee" />
                                                <asp:BoundField DataField="RoleType" HeaderText="User Role" />
                                                                                                <asp:TemplateField HeaderText="Base HQ">
        <ItemTemplate>
              <asp:Label runat="server" ID="hfTerritoryCode" Text='<%#Eval("TerritoryCode")%>' />
                </ItemTemplate>
</asp:TemplateField>
                                   
                                      <asp:TemplateField HeaderText="DCP">
                                            <%-- CommandName="ShowModal"--%>
    <ItemTemplate>
        <asp:LinkButton ID="lnkDCP" runat="server"
            Text='<%#Eval("DCP")%>'
         
            CommandArgument='<%#Eval("ID") + "|DCP"%>' />
    </ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="DCR">
    <ItemTemplate>
        <asp:LinkButton ID="lnkDCR" runat="server"
            Text='<%#Eval("DCR")%>'
            
            CommandArgument='<%#Eval("ID") + "|DCR"%>' />
    </ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="RX">
    <ItemTemplate>
        <asp:LinkButton ID="lnkRX" runat="server"
            Text='<%#Eval("RX")%>'
            
            CommandArgument='<%#Eval("ID") + "|RX"%>' />
    </ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="Customer Coverage">
    <ItemTemplate>
        <asp:LinkButton ID="lnkCustomerCoveragenn" runat="server"
            Text='<%#Eval("CustomerCoverageNew")%>'
            
            CommandArgument='<%#Eval("ID") + "|CustomerCoverageNew"%>' />
    </ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="Customer Visit Plan (CVP)">
    <ItemTemplate>
        <asp:LinkButton ID="lnkCustomerCoverage" runat="server"
            Text='<%#Eval("CustomerCoverage")%>'
            
            CommandArgument='<%#Eval("ID") + "|CustomerCoverage"%>' />
    </ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="Customer Visit Report (CVR)">
    <ItemTemplate>
        <asp:LinkButton ID="lnkCustomerCoverage" runat="server"
            Text='<%#Eval("CVRCount")%>'
            
            CommandArgument='<%#Eval("ID") + "|CVRCount"%>' />
    </ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="GP Sales (Net TP)">
    <ItemTemplate>
        <asp:LinkButton ID="lnkGPSales" runat="server"
            Text='<%#Eval("GPSales")%>'
            
            CommandArgument='<%#Eval("ID") + "|GPSales"%>' />
    </ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="Total Sales (Net TP)">
    <ItemTemplate>
        <asp:LinkButton ID="lnkTSales" runat="server"
            Text='<%#Eval("TSalesNetTP")%>'
            
            CommandArgument='<%#Eval("ID") + "|TSalesNetTP"%>' />
    </ItemTemplate>
</asp:TemplateField>

                                         
                                            </Columns>
                                        </asp:GridView>
                                    </div>



                               <%-- </ContentTemplate>
                            </asp:UpdatePanel>--%>
                        </div>
                    </div>
                </div>
            </div>

         
        </div>
    </div>
                    <div>
    <!-- Hidden Trigger -->
<asp:HiddenField ID="hndModalTrigger" runat="server" />

<!-- Modal Popup Extender -->
<cc1:ModalPopupExtender ID="mpeCommonPopup" runat="server"
    TargetControlID="hndModalTrigger"
    PopupControlID="pnlCommonModal"
    BackgroundCssClass="modalBackground" />

<!-- Modal Panel -->
<asp:Panel ID="pnlCommonModal" runat="server" Style="display: none;" CssClass="modalPopup" Width="90%">
    <asp:UpdatePanel ID="updCommonModal" runat="server">
        <ContentTemplate>

            <!-- Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                <h3 style="margin: 0;" id="modalTitle" runat="server">Details</h3>
                <asp:Button ID="btnClosePopup" runat="server" Text="X" CssClass="btn btn-danger" OnClick="btnClosePopup_Click" />
            </div>

            <!-- Body -->
            <div style="padding: 15px; height: 600px; overflow-y: auto;">
                <asp:Label ID="lblModalContent" runat="server" Text="Details will load here..." />
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Panel>
         </div>
    <script>

        $(document).ready(function () {

            var table = $('#ContentPlaceHolder1_loadGridView').DataTable({
                "bInfo": false,
                "bFilter": false,
                "paging": false, // ✅ Paging off
                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                pageLength: -1,
                dom: 'lBfrtip',
                buttons: ['copy', 'excel', 'pdf', 'print']
            });

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            if (prm != null) {
                prm.add_endRequest(function (sender, e) {
                    if (sender._postBackSettings.panelsToUpdate != null) {
                        table = $('#ContentPlaceHolder1_loadGridView').DataTable({
                            "bInfo": false,
                            "bFilter": false,
                            "paging": false, // ✅ Paging off again after partial postback
                            lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                            pageLength: -1,
                            dom: 'lBfrtip',
                            buttons: ['copy', 'excel', 'pdf', 'print']
                        });
                    }
                });
            }

            table.columns().every(function () {
                var that = this;
                // You can add column-wise logic here if needed
            });
        });



    </script>
    >
     
</asp:Content>



