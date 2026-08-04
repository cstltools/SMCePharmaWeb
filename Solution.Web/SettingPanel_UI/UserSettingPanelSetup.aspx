<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="UserSettingPanelSetup.aspx.cs" Inherits="SettingPanel_UI_UserSettingPanelSetup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    
       <style>

    .form-switch {
        padding-left: 2.5em;
    }

    .form-check {
        display: block;
        min-height: 1.5rem;
        padding-left: 1.5em;
        margin-bottom: .125rem;
    }

      .chkChoice label {
            padding-left: 2px;
            padding-right: 2px;
        }
</style>


        <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Basic info update setting  </div>

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

                                 <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                    <asp:HiddenField runat="server" ID="id_mastetID"/>

                         
                                    
                                    
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

                                    

                                      <div class="row">
                                
                                <div class="col-12">
                                    <div class="table-responsive" id="MainGradeDiv">
                                        <asp:GridView ID="gv_List" runat="server" AutoGenerateColumns="False" ShowFooter="True"
                                                      onrowcommand="loadGridView_RowCommand" DataKeyNames="UserSettingPanelId"
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                                 

                                <%--    <HeaderTemplate>
                                        <asp:CheckBox ID="menuAllCheckBox" runat="server" OnCheckedChanged="menuAllCheckBox_CheckedChanged" AutoPostBack="True" />
                                    </HeaderTemplate>--%>

                                    <asp:TemplateField HeaderText="Select">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="ckCheckBox" runat="server" />
                                        </ItemTemplate>
                                        
                                            <HeaderTemplate>
                                        <asp:CheckBox ID="ckAllCheckBox" runat="server" OnCheckedChanged="ckAllCheckBox_OnCheckedChanged" AutoPostBack="True" />
                                    </HeaderTemplate>
                                      
                                    </asp:TemplateField>
                                    

                                    <asp:BoundField DataField="Criteria" HeaderText="Criteria" />

                                    <asp:TemplateField HeaderText="Active From Date">
                                        <ItemTemplate>

                                            <asp:TextBox ID="txtFromDate"  type="datetime-local"   runat="server" Text='<%#Eval("FromDate") %>'   CssClass="form-control form-control-sm mb-3 "></asp:TextBox>

                                        </ItemTemplate>

                                    </asp:TemplateField>
                                    

                                    <asp:TemplateField HeaderText="Active To Date">
                                        <ItemTemplate>

                                            <asp:TextBox ID="txtToDate"  type="datetime-local"   runat="server" Text='<%#Eval("Todate") %>'  
                                                         CssClass="form-control form-control-sm mb-3"></asp:TextBox>

                                        </ItemTemplate>

                                    </asp:TemplateField>
                                    

                                </Columns>
                            </asp:GridView>

                                        

                                    </div>
                                    

                                </div>
                                
                            </div>
                                    

                        <br />
                            <br />
                                
                                    
                                    
                                    
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="form-group row">
                                                <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-9">

                                                    <asp:LinkButton  OnClick="btnUpdate_OnClick" runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm" OnClientClick="return sweetAlertConfirm_Update(this);"   >
                                                        <i class="fa fa-check"></i>Update
                                                    </asp:LinkButton>
                                                    <asp:LinkButton  runat="server"  ID="btn_Reset" OnClick="btn_Reset_OnClick"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>
                                    

                        

      </ContentTemplate>
                                     </asp:UpdatePanel>
                       

                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
</asp:Content>

