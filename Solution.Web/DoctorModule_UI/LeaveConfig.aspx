<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="LeaveConfig.aspx.cs" Inherits="DoctorModule_UI_LeaveConfig" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style>
        .radioChoice label {
            padding-left: 5px;
            padding-right: 8px;
            font-weight: bold;
        }
    </style>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Leave Configuration Information</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/LeaveConfigList.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                        <div class="col-1">&nbsp;</div>
                                        <div class="col-11">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-4 col-form-label">Leave Name:  </label>

                                                <div class="col-sm-5">
                                                    <asp:TextBox   runat="server"   class="form-control form-control-sm "  id="txtLeaveName" placeholder="Leave Name"></asp:TextBox>
                                                    <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>




                                            <div class="form-group row">
                                                <label for="Days" class="col-sm-4 col-form-label">Count Govt. Leave: </label>
                                                <div class="col-sm-5">
                                                    <asp:RadioButtonList runat="server" ID="rbCountGovtLeave" RepeatDirection="Horizontal" CssClass="radioChoice" RepeatLayout="Flow">
                                                        <asp:ListItem>Yes</asp:ListItem>
                                                        <asp:ListItem>No</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>

                                                <span class="text-sm-left text-c-red">*</span>

                                            </div>




                                            <div class="form-group row">
                                                <label for="Days" class="col-sm-4 col-form-label">Count Employee Holiday: </label>
                                                <div class="col-sm-5">
                                                    <asp:RadioButtonList runat="server" ID="rbEmployeeWeeklyHoliday" CssClass="radioChoice" AutoPostBack="true" OnSelectedIndexChanged="rbEmployeeWeeklyHoliday_SelectedIndexChanged" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                                        <asp:ListItem>Yes</asp:ListItem>
                                                        <asp:ListItem>No</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>

                                                <span class="text-sm-left text-c-red">*</span>

                                            </div>

                                            <div class="form-group row" runat="server" id="divDay" visible="false">
                                                <label for="Days" class="col-sm-4 col-form-label">Day: </label>
                                                <div class="col-sm-5">
                                                    <asp:DropDownList runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" ID="ddlDayName">
                                                    </asp:DropDownList>
                                                </div>

                                                <span class="text-sm-left text-c-red">*</span>

                                            </div>

                                            <div class="form-group row">
                                                <label for="Days" class="col-sm-4 col-form-label">Eligible for Probation Employee: </label>
                                                <div class="col-sm-5">
                                                    <asp:RadioButtonList runat="server" ID="rbEligbleforProbationEmployee" RepeatDirection="Horizontal" CssClass="radioChoice" RepeatLayout="Flow">
                                                        <asp:ListItem>Yes</asp:ListItem>
                                                        <asp:ListItem>No</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>

                                                <span class="text-sm-left text-c-red">*</span>

                                            </div>


                                            <div class="form-group row">
                                                <label for="Days" class="col-sm-4 col-form-label">Leave Type: </label>
                                                <div class="col-sm-5">
                                                    <asp:DropDownList runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlLeaveConType_SelectedIndexChanged" ID="ddlLeaveConType" CssClass="form-select form-select-sm mb-3 mySelect2">
                                                    </asp:DropDownList>
                                                </div>

                                                <span class="text-sm-left text-c-red">*</span>

                                            </div>


                                            <div class="form-group row" runat="server" visible="false" id="divEmp" >
                                                <label for="Days" class="col-sm-4 col-form-label">Employee: </label>
                                                <div class="col-sm-5">
                                                  

                                                    <asp:ListBox runat="server" ID="EmployeeIdSelect" SelectionMode="Multiple" class="form-select form-select-sm mb-3 multiple-select" name="BrandSelect"></asp:ListBox>
                                                </div>

                                                <span class="text-sm-left text-c-red">*</span>

                                            </div>


                                            <div class="form-group row" runat="server" visible="false" id="divList">
                                                <label for="Days" class="col-sm-4 col-form-label">Leave Count: </label>
                                                <div class="col-sm-7">

                                                    <asp:GridView ID="itemGridView" runat="server" AutoGenerateColumns="False"  
                                                        CssClass="table table-bordered table-striped datatable">
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="SL">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>



                                                            <asp:TemplateField HeaderText="Joining Date Count">

                                                                
                                                                <ItemTemplate>

                                                                    <asp:HiddenField ID="hfJoiningDateCount" Value='<%# Eval("JoiningDateCountId")%>' runat="server" />
                                                                      <asp:DropDownList CssClass="form-select form-select-sm mb-3 mySelect2" runat="server" ID="ddlJoiningDateCount">
                                                                </asp:DropDownList>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                            <asp:TemplateField HeaderText="Monthly Leave">
                                                                <ItemTemplate>
                                                                   
                                                                        <asp:TextBox runat="server" Text='<%# Eval("CountDays")%>' ID="txtCountDays" CssClass="form-control form-control-sm mb-3"></asp:TextBox> <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server"
                                                                                        Enabled="True" TargetControlID="txtCountDays" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>  </td>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                         



                                                            <asp:TemplateField HeaderText="Actions">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnAdd" runat="server" OnClick="btnAdd_Click" CssClass="btn-info  btn-sm mb-1 mb-md-0"
                                                                                    ><i class="fa fa-plus" aria-hidden="true"></i>
</asp:LinkButton> &nbsp;&nbsp;

                                                                      <asp:LinkButton ID="btnDel" runat="server" OnClick="btnDel_Click" CssClass="btn-danger  btn-sm mb-1 mb-md-0"
                                                                                    ><i class='fa fa-minus' aria-hidden='true'></i></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>


                                                    </asp:GridView>

                                                     
                                                </div>

                                                
                                            </div>


                                             <asp:HiddenField runat="server" ID="id_mastetID"/>

                                            <div class="form-group row">
                                                <label for="exampleInputUsername2" class="col-sm-4 col-form-label">&nbsp; </label>
                                                <br />
                                                <div class="col-sm-5">
                                                        <div class="form-check form-switch">
													<input class="form-check-input" runat="server" type="checkbox" ID="chkIsActive" checked>
												 <label  class="custom-control-label" for="chkIsActive"> Is Active</label>
												</div>
                                                </div>



                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="form-group row">
                                                <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-8">
                                                  <asp:LinkButton  OnClick="btnSave_Click" Visible="false" OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                             <asp:LinkButton  OnClick="btnSave_Click"  Visible="false"   runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm" OnClientClick="return sweetAlertConfirm_Update(this);"   >
                                            <i class="fa fa-check"></i>Update
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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

