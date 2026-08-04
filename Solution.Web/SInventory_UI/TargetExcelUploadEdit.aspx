<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TargetExcelUploadEdit.aspx.cs" Inherits="SInventory_UI_TargetExcelUploadEdit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">



    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Monthly Target Edit</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="TargetExcelUploadList.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
 <asp:HiddenField runat="server" ID="id_mastetID"/>

                                        <div class="row">

                                            <div class="col-6">
                                                <div class="form-group row">
                                                     <asp:HiddenField runat="server" ID="HiddenField1"/>
                                                    <label for="mainName" class="col-sm-4 col-form-label">Financial Year: </label>

                                                    <div class="col-sm-8">
                                                        <div class="input-group">
                                                     <asp:DropDownList  runat="server"  ID="ddlFinancialYear"  Enabled="false"   CssClass="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>
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
                                                        <span id="v-ddlFinancialYear" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>

<span class="input-group-text text-c-red">*</span>

                                              </div>
                                                    </div>
                                                   
                                                </div>

                                                   <div style="padding:5px"></div>
                                                    <div class="form-group row">

                                                    <label for="mainName" class="col-sm-4 col-form-label">Year: </label>

                                                    <div class="col-sm-8">
                                                        <div class="input-group">
                                                     <asp:DropDownList  runat="server"  ID="ddlYear" Enabled="false"  CssClass="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>

                                                        <span id="v-txtCampaignName" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>

<span class="input-group-text text-c-red">*</span>

                                              </div>
                                                    </div>
                                                   
                                                </div>
                                                   <div style="padding:5px"></div>
                                                
                                                    <div class="form-group row">

                                                    <label for="mainName" class="col-sm-4 col-form-label">Month: </label>

                                                    <div class="col-sm-8">
                                                        <div class="input-group">
                                                     <asp:DropDownList  runat="server"   Enabled="false"  ID="ddlMonth"  CssClass="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>

                                                        <span id="v-ddlMonth" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>

<span class="input-group-text text-c-red">*</span>

                                              </div>
                                                    </div>
                                                   
                                                </div>
                                                   <div style="padding:5px"></div>
                                                    <div class="form-group row">

                                                    <label for="mainName" class="col-sm-4 col-form-label">Employee Name: </label>

                                                    <div class="col-sm-8">
                                                        <div class="input-group">
                                                     <asp:DropDownList  runat="server"   Enabled="false"  ID="ddlEmployeeName"  CssClass="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>

                                                        <span id="v-ddlEmployeeName" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>

<span class="input-group-text text-c-red">*</span>

                                              </div>
                                                    </div>
                                                   
                                                </div> 
                                                <div style="padding:5px"></div>
                                                <div class="form-group row">

                                                    <label for="mainName" class="col-sm-4 col-form-label">Target Value: </label>

                                                    <div class="col-sm-8">
                                                        <div class="input-group">
                                                            
                                                       <asp:TextBox   runat="server"   CssClass="form-control form-control-sm mb-3 "   id="txtTargetValue" placeholder="Target Value"></asp:TextBox>
                                                             <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderunitValue" runat="server"
                                                                                        Enabled="True" TargetControlID="txtTargetValue" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>

                                                        <span id="v-txtTargetValue" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>

<span class="input-group-text text-c-red">*</span>

                                              </div>
                                                    </div>
                                                   
                                                </div>
                                                 <div style="padding:5px"></div>

                                                        <div class="form-group row">

                                                    <label for="mainName" class="col-sm-4 col-form-label">  </label>

                                                    <div class="col-sm-8">
                                                        <div class="input-group">

                                                   <asp:LinkButton  OnClick="btnSave_Click"   OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i> Update
                                        </asp:LinkButton>
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


</asp:Content>

