<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="MonthlyAllowance.aspx.cs" Inherits="DoctorModule_UI_MonthlyAllowance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    

      <div id="popDiv">

</div>


    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Monthly Allowances  Entry</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/MonthlyAllowanceView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>

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

                      $(function () {
                          $(".clsDecimal").keypress(function (event) {

                              $(this).val($(this).val().replace(/[^0-9\.]/g, ''));
                              if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                                  /* if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {*/
                                  /*  $("#v-AllowedMilagePerKM").html("Number Only").stop().show().fadeOut("slow");*/

                                  return false;
                              }
                          });
                      });
                  }

              </script>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">
                          <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                                  <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">

                              <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="MonthlyAllowanceName" class="col-sm-3 col-form-label">Allowance Name:  </label>

                                    <div class="col-sm-7">
                                         <asp:TextBox  runat="server" class="form-control form-control-sm "   ID="MonthlyAllowanceName" placeholder="Monthly Allowance Name"></asp:TextBox>

                                        <span id="v-MonthlyAllowanceName" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>


                                <div class="form-group row">
                                    <label for="Allowance" class="col-sm-3 col-form-label">Amount:  </label>

                                    <div class="col-sm-7">
                                      <asp:TextBox  runat="server" class="form-control form-control-sm clsDecimal "   id="Allowance" placeholder="Amount"></asp:TextBox>

                                        <span id="v-Allowance" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>


                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label> 

                                    <div class="col-sm-7" >

                                       
                                            <asp:CheckBox Text="Is Active"   runat="server"   Checked="true"    id="customSwitch1"     />
                                            
                                      


                                    </div>

                                </div>


                                <br />

                               

                                
                            </div>

                                     <div class="row">
                                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="UserRoleSelect" class="col-sm-4 col-form-label">User Role:  </label>

                                    <div class="col-sm-8">


                                        <asp:DropDownList  runat="server"  AutoPostBack="true" OnSelectedIndexChanged="UserRoleSelect_SelectedIndexChanged"  id="UserRoleSelect" name="UserRoleSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                    </div>

                                </div>

                            </div>
                                           <div class="col-12">
                                              <div style="padding-top:10px;"></div>
                                             <div class="table-responsive" id="MainGradeDiv">


                                                 
                                                    <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                          
                           CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>

                                     <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                          <asp:HiddenField runat="server" ID="hfUserRoleId" Value='<%#Eval("UserRoleId")%>' />
                                          <asp:HiddenField runat="server" ID="hfEmpInfoId" Value='<%#Eval("EmpInfoId")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    
                                                                        <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" CssClass="form-control-sm"       runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>


                                    <asp:BoundField DataField="EmpMasterCode" HeaderText="Employee Code" />
                                   
                                    <asp:BoundField DataField="EmpName" HeaderText="Employee Name" />
                               <asp:BoundField DataField="RoleName" HeaderText="Role" />

                                
 
                                
                                   
                                   
                                   
                                </Columns>
                            </asp:GridView>
                         
                        </div>

                                               </div>
                                         </div>

                                     <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                 <div class="form-group row">
                                    <label for="customSwitch1" class="col-sm-3 col-form-label">  </label>

                                    <div class="col-sm-7" style="padding-top:6px;">

                                  
                                        
                                                      <asp:LinkButton  OnClick="btnSave_Click" Visible="false" OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                             <asp:LinkButton  OnClick="btnSave_Click"  Visible="false"   runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm" OnClientClick="return sweetAlertConfirm_Update(this);"   >
                                            <i class="fa fa-check"></i>Update
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server" id="restbtn" OnClick="restbtn_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>

                                    </div>

                                </div>

                                </div>
                                </div>


                            </div>
                            </div>
                            </div>
                                     <asp:HiddenField runat="server" ID="id_mastetID"/>
                                    </ContentTemplate>
                              </asp:UpdatePanel>
                            </div>
                            </div>
                            </div>
                            </div>

     

    <%--<input id="masterId" value="0" style="display:none" />

    
        <script>


            function ResetLink() {
                location.reload();

            }
            $(function () {

                var masterid = getUrlVars()["id"];
                if (masterid) {
                    $("#masterId").val(getUrlVars()["id"]);
                }

                let id = $('#masterId').val();
                if (id > 0) {

                    GetData(id);
                } else {


                }
            });

            function getUrlVars() {
                var vars = [], hash;
                var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                for (var i = 0; i < hashes.length; i++) {
                    hash = hashes[i].split('=');
                    vars.push(hash[0]);
                    vars[hash[0]] = hash[1];
                }
                return vars;
            }

            function ResetClick() {
                window.location.href = '../DoctorModule_UI/MonthlyAllowance.aspx';

            }

            function IsActiveChange() {
                var isActive = $('#customSwitch1').is(':checked');
                $('#acttxt').text("");
                if (isActive) {
                    $('#acttxt').text("Active");

                } else {
                    $('#acttxt').text("Inactive");
                }
            }


            $(function () {
                $("#Allowance").keypress(function (event) {

                    $(this).val($(this).val().replace(/[^0-9\.]/g, ''));
                    if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                        /* if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {*/
                        /*  $("#v-AllowedMilagePerKM").html("Number Only").stop().show().fadeOut("slow");*/
                        ValidationTooltip("#v-Allowance", "Number Only!");
                        return false;
                    }
                });
            });
            function ValidationTooltip(id, message) {


                $(id).empty();

                if ($(id).empty()) {
                    $(id).append(message);
                }
                $(id).toast('show');
                $(id).css("display", "block");



            }

            function RemoveValidationTooltip(id) {
                $(id).css("display", "none");
            }

            function Validation() {
                var isValid = true;


                $('#MonthlyAllowanceName').removeClass('is-invalid');
                $('#Allowance').removeClass('is-invalid');

                RemoveValidationTooltip("#v-MonthlyAllowanceName");
                RemoveValidationTooltip("#v-Allowance");

                isValid = true;
                if ($('#MonthlyAllowanceName').val() == "") {


                    $('#MonthlyAllowanceName').addClass("is-invalid");
                    ValidationTooltip("#v-MonthlyAllowanceName", "Please fill out of this field!");
                    isValid = false;
                }
                if ($('#Allowance').val() == "") {


                    $('#Allowance').addClass("is-invalid");
                    ValidationTooltip("#v-Allowance", "Please fill out of this field!");
                    isValid = false;
                }


                return isValid;
            }

            function Save() {
                if (Validation()) {
                    
                                    FinalSave();
                    
                }
            }
            function FinalSave() {


                debugger;
                var jsonData = {};
                jsonData["MonthlyAllowanceId"] = $('#masterId').val();
                jsonData["MonthlyAllowanceName"] = $('#MonthlyAllowanceName').val();
                jsonData["Allowance"] = $('#Allowance').val();
                jsonData["IsActive"] = $('#customSwitch1').is(':checked');


                var urlpath = 'Setup.aspx/Save_MonthlyAllowance';
                $.ajax({
                    data: JSON.stringify({ 'monthly': jsonData }),
                    url: urlpath,
                    contentType: "application/json; charset=utf-8",
                    type: "POST",
                    beforeSend: function () {
                        //_open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                    },
                    success: function (result) {
                        //_close_LoadingPopUp_WithMsg();
                        result = result.d;



                        if (result.isSuccess == true) {

                            successalert('Operation successful!', 'Success', 'MonthlyAllowanceView.aspx');
                        }
                        else if (result.isValiCheck == true) {

                            faildalert('Data cannot be deactivated!', 'Faild');
                        }
                        else if (result.isDuplicateCheck == true) {

                            faildalert('Already Exist!', 'Faild');
                        }

                        else {
                            faildalert('Operation Faild!', 'Faild');
                        }
                         

                    },
                    error: function (data) {
                        faildalert('Operation Faild!', 'Faild');

                    },

                });
            }

            function GetData(id) {
                var urlpath = 'Setup.aspx/GetMonthlyAllowanceEditData';
                $.ajax({
                    url: urlpath,
                    dataType: 'json',
                    data: JSON.stringify({ 'id': id }),
                    type: "POST", contentType: "application/json; charset=utf-8",
                    async: true,
                    success: function (data) {
                        data = data.d;
                     //   GetAllowanceName(data.MonthlyAllowanceName);
                        $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");

                        $('#MonthlyAllowanceName').val(data.MonthlyAllowanceName);
                        $('#Allowance').val(data.Allowance);

                        if (data.IsActive) {
                            $('#customSwitch1').prop('checked', true);
                        } else {
                            $('#customSwitch1').prop('checked', false);
                        }
                    },
                    complete: function () {
                    }
                });
            }

        </script>--%>
    



</asp:Content>

