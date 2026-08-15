<%@ Page Title="Campaign List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="CampaignView.aspx.cs" Inherits="MasterSetup_UI_CampaignView" %>

<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <asp:HiddenField ID="hnd_Test4" runat="server" />

<!-- ModalPopupExtender -->
<cc1:ModalPopupExtender ID="NoofGSPPopupExtender" runat="server"
    TargetControlID="hnd_Test4"
    PopupControlID="pnl_4"
    BackgroundCssClass="modalBackground" />

<!-- Modal Panel -->
<asp:Panel ID="pnl_4" runat="server"
    Style="display: none; padding: 20px; background-color: white; border: 1px solid #ccc; border-radius: 10px;"
    Width="500px" CssClass="modalPopup">

    <asp:UpdatePanel ID="NoOfGspUpdatePanel1" runat="server">
        <ContentTemplate>
            <h3>Mobile Sync Required</h3>
            <p>Your mobile data is outdated. Please click the button below to sync.</p>

            <asp:Button ID="btnSyncNow" runat="server" Text="Sync Now" CssClass="btn btn-primary" OnClick="btnSyncNow_Click" /> 
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Panel>
    <style>
        .modalBackground {
    background-color: rgba(0, 0, 0, 0.5);
    filter: alpha(opacity=70);
}

    </style>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Campaign List</div>
                
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
                                         <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>

                                       <script type="text/javascript">
                                           function pageLoad() {
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

                                           var dateNow = new Date();
                                           $('.datepickess').datepicker("setDate", dateNow);
                                           minDate: new Date() // to disable privious dates 
                                       </script>
                                   
                                    <div class="row">
                                                           <div class="col-1">
                                                               </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="FromDate" class="col-sm-4 col-form-label">From Date:  </label>

                                    <div class="col-sm-8">
                                         <asp:TextBox  runat="server"  id="FromDate" type="text" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Date" ></asp:TextBox>

                                    </div>

                                </div>

                            </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="EmployeeIdSelect" class="col-sm-4 col-form-label"> Campaign Type  </label>

                                    <div class="col-sm-8">

    
  <asp:DropDownList  runat="server"  ID="ddlCampaignType"  class="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>


                                    </div>

                                </div>

                            </div>
                        </div>

                      
                        <div class="row">
                             <div class="col-1">
                                                               </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="ToDate" class="col-sm-4 col-form-label">To Date:  </label>

                                    <div class="col-sm-8">
                                         <asp:TextBox  runat="server"  id="ToDate" type="text" class="form-control form-control-sm mb-3 datepicker"   autocomplete="off" placeholder="Select Date"></asp:TextBox>

                                    </div>

                                </div>

                            </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="EmployeeIdSelect" class="col-sm-4 col-form-label">Active Status:  </label>

                                    <div class="col-sm-8">

          
  <asp:DropDownList  runat="server"  ID="ddlActive"  class="form-select form-select-sm mb-3 mySelect2 ">
      <asp:ListItem Value="">Select One</asp:ListItem>
      <asp:ListItem Value="1">Active</asp:ListItem>
      <asp:ListItem Value="0">Inactive</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>

                                </div>

                            </div>
                        </div>

                      
                        
 
<br />        
                    
                        <div class="row">
                            <div class="col-md-5">
                            </div>
                            <div class="col-md-4" style="align-content:center">

                                   <asp:LinkButton runat="server"  id="btnSearch" class="btn btnMyDesignSearch   btn-sm "  onclick="btnSearch_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                                  
                                
                               <asp:LinkButton  runat="server" class="btn btnMyDesignReset   btn-sm"   id="resetBtn" onclick="resetBtn_Click" ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                
                            </div>
                        </div>
                        <div style="padding-top:10px;"></div>



                                            <div class="table-responsive" id="MainGradeDiv">

                                              

                                                    <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="CampgainMasterId" 
                                onrowcommand="loadGridView_RowCommand"  CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>

                                     <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="CampaignName" HeaderText="Campaign Name " />
                                 
                                    <asp:BoundField DataField="TypeName" HeaderText="Campaign Type" />
                               <asp:BoundField DataField="CustomerType" HeaderText="Customer Type" />

                                    <asp:BoundField DataField="FromDate" HeaderText="Valid From Date" 
 />
                                    <asp:BoundField DataField="Todate" HeaderText="Valid To Date" 
/>

                                   
                                    <asp:TemplateField HeaderText="Edit">
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


