<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TourSetupForEmployee.aspx.cs" Inherits="MasterSetup_UI_TourSetupForEmployee" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

      <style>
          .radioChoice label {
            padding-left: 5px;
            padding-right: 5px;
                  font-size: 17px;
                  font-weight: bold;
        }

     
    </style>
    <div id="popDiv">
    </div>

    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Tour Type Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="TourSetupForEmployeeList.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                <div class="col-2">&nbsp;</div>
                                <div class="col-8">
                                    <div class="form-group row">
                                        <label for="txtNID" class="col-sm-3 col-form-label"></label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                 <asp:RadioButtonList runat="server" ID="rbType" CssClass="radioChoice" AutoPostBack="True" OnSelectedIndexChanged="rbType_SelectedIndexChanged" RepeatDirection="Horizontal" RepeatLayout="Flow">
                      <asp:ListItem Selected="True" Value="0">Role Wise</asp:ListItem>
                      <asp:ListItem Value="1"> Employee Wise</asp:ListItem>
                  </asp:RadioButtonList>
                                                
                                                <asp:HiddenField ID="hiddenField" runat="server" />

                                            </div>

                                        </div>
                                    </div>

                                        <div class="form-group row" runat="server" visible="false" id="divEmp">
                                        <label for="mainName" class="col-sm-3 col-form-label">Employee Name: </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                 <asp:DropDownList  runat="server"  ID="ddlEmployee" class="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>

                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div>
                                    </div>

                                     <div class="form-group row" runat="server" visible="false" id="divRoleType">
                                        <label for="mainName" class="col-sm-3 col-form-label">Role Type: </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                 <asp:DropDownList  runat="server"  ID="ddlRoleType" class="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>

                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Tour Type: </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                 <asp:DropDownList  runat="server"  ID="ddlTourType" class="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>

                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div>
                                    </div>




                                     
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label"> Count: </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox class="form-control form-control-sm mb-3 " runat="server" ID="txtCount" placeholder="Count"   ></asp:TextBox>
                                                <asp:FilteredTextBoxExtender ID="FilteredTssextBoxExtender1" runat="server"
                                                                                        Enabled="True" TargetControlID="txtCount" FilterType="Custom" ValidChars="0123456789"></asp:FilteredTextBoxExtender>
                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div>
                                    </div>
 
                                     <br />

                                     <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label"> </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                 <asp:LinkButton  OnClick="btnSave_Click" Visible="false" runat="server" id="btnSave" class="btn btnMyDesignSearch    btn-sm" OnClientClick="return sweetAlertConfirm_Submit(this);"    >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                             <asp:LinkButton  OnClick="btnSave_Click"  OnClientClick="return sweetAlertConfirm_Update(this);"  Visible="false"  runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Update
                                        </asp:LinkButton>
                                          <asp:LinkButton   runat="server" ID="btnReset"  class="btn btnMyDesignReset   btn-sm" OnClick="btnReset_Click"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>



                                            </div>

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

