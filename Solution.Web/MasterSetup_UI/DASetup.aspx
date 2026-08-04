<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DASetup.aspx.cs" Inherits="MasterSetup_UI_DASetup" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <div id="popDiv">
    </div>

    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>DA Information</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../MasterSetup_UI/DAList.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                    <script type="text/javascript">
                                        function pageLoad() {
                                            $('.mySelect2').select2({
                                                theme: 'bootstrap4',
                                                width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                placeholder: $(this).data('placeholder'),
                                                allowClear: Boolean($(this).data('allow-clear')),
                                            });
                                            $('.datepicker').pickadate({
                                                selectMonths: true,
                                                selectYears: true
                                            });
                                        }

                                        function IsActiveChange() {
                                            var isActive = $('#chkIsActive').is(':checked');
                                            if (isActive) {
                                                $('#pacinTxt').text("Active Date:");
                                            } else {
                                                $('#pacinTxt').text("Inactive Date:");
                                            }
                                        }
                                    </script>
                                      <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
                            <div class="row">
                                <div class="col-2">&nbsp;</div>

                                
                                <div class="col-8">

                                                                    <div class="form-group row">
    <label for="ddlDepotName" class="col-sm-3 col-form-label">Depot Name: </label>

    <div class="col-sm-7">
        <div class="input-group">
            <asp:DropDownList ID="ddlDepotName" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
            </asp:DropDownList>
            <span class="input-group-text text-c-red">*</span>
        </div>
    </div>
</div>
                                    <div class="form-group row">
                                        <label for="txtNID" class="col-sm-3 col-form-label">Delivery Man NID:</label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox class="form-control form-control-sm mb-3 " runat="server" ID="txtNID" placeholder="Delivery Man NID" MaxLength="17" ></asp:TextBox>
                                               <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderunitValue" runat="server"
                                                                                        Enabled="True" TargetControlID="txtNID" FilterType="Custom" ValidChars="0123456789"></asp:FilteredTextBoxExtender>
                                                <asp:HiddenField ID="hiddenField" runat="server" />

                                            </div>

                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Delivery Man Name: </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox class="form-control form-control-sm mb-3 " runat="server" ID="txtName" placeholder="Delivery Man Name"></asp:TextBox>


                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div>
                                    </div>

                                 

                                    <div class="form-group row">
                                        <label for="txtJoiningDate" class="col-sm-3 col-form-label">Date of Joining: </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox class="form-control form-control-sm mb-3 datepicker" runat="server" ID="txtJoiningDate" autocomplete="off" placeholder="Select Date of Joining"></asp:TextBox>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>
                                    </div>



                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Permanent Address: </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox class="form-control form-control-sm mb-3 " TextMode="MultiLine" Rows="2" runat="server" ID="txtAddress" placeholder="Permanent Address"></asp:TextBox>


                                                <span class="input-group-text text-c-red">&nbsp</span>


                                            </div>

                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Phone No: </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox class="form-control form-control-sm mb-3 " runat="server" ID="txtPhone" placeholder="Delivery Man Phone"  MaxLength="11"></asp:TextBox>
                                                <asp:FilteredTextBoxExtender ID="FilteredTssextBoxExtender1" runat="server"
                                                                                        Enabled="True" TargetControlID="txtPhone" FilterType="Custom" ValidChars="0123456789"></asp:FilteredTextBoxExtender>
                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Emergency Contact No: </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox class="form-control form-control-sm mb-3 " runat="server" ID="txtEmergencyContactNo"  MaxLength="11" placeholder="Emergency Contact No"></asp:TextBox>
                                                 <asp:FilteredTextBoxExtender ID="FilteresssdTextBoxExtender1" runat="server"
                                                                                        Enabled="True" TargetControlID="txtEmergencyContactNo" FilterType="Custom" ValidChars="0123456789"></asp:FilteredTextBoxExtender>

                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Reference Name: </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox class="form-control form-control-sm mb-3 " runat="server" ID="txtReferenceName" placeholder="Reference Name"></asp:TextBox>


                                             
                                            </div>

                                        </div>
                                    </div>


                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Reference Phone: </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox class="form-control form-control-sm mb-3 " runat="server" ID="txtReferencePhone"  MaxLength="11"  placeholder="Reference Phone"></asp:TextBox>

                                                 <asp:FilteredTextBoxExtender ID="FiltertxtReferencePhoneedTextBoxExtender1" runat="server"
                                                                                        Enabled="True" TargetControlID="txtReferencePhone" FilterType="Custom" ValidChars="0123456789"></asp:FilteredTextBoxExtender>
                                                

                                            </div>

                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label for="customSwitch1" class="col-sm-3 col-form-label">&nbsp; </label>
                                        <div class="col-sm-7">
                                            <div class="form-check form-switch">
                                                <asp:CheckBox ID="chkIsActive" runat="server" ClientIDMode="Static" CssClass="form-check-input" Checked="true" onclick="IsActiveChange()" />
                                                <label class="custom-control-label" for="chkIsActive">Active</label>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label for="txtActiveDate" runat="server" id="pacinTxt" ClientIDMode="Static" class="col-sm-3 col-form-label">Active Date: </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox class="form-control form-control-sm mb-3 datepicker" runat="server" ID="txtActiveDate" autocomplete="off" placeholder="Select Date"></asp:TextBox>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Remarks: </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox class="form-control form-control-sm mb-3 " TextMode="MultiLine" Rows="2" runat="server" ID="txtRemarks" placeholder="Remarks"></asp:TextBox>
                                               
                                                <span class="input-group-text text-c-red">&nbsp</span>



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

