<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TADAClaimEdit.aspx.cs" Inherits="DoctorModule_UI_TADAClaimEdit" %>
 
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    

      <div id="popDiv">

</div>


    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> DA  Entry</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/TADAClaimView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>

     
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
                                    <label for="MonthlyAllowanceName" class="col-sm-3 col-form-label">Employee Name:  </label>

                                    <div class="col-sm-7">
                                     <asp:DropDownList  runat="server"   id="EmployeeIdSelect" name="EmployeeIdSelect" AutoPostBack="true" OnSelectedIndexChanged="EmployeeIdSelect_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

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
                                      

                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>
                                <div class="form-group row">
                                    <label for="MonthlyAllowanceName" class="col-sm-3 col-form-label">DA Date:  </label>

                                    <div class="col-sm-7">
                                      <asp:TextBox  runat="server"  id="TadaDate"  class="form-control form-control-sm mb-3 datepicker" AutoPostBack="true" OnTextChanged="TadaDate_TextChanged"   autocomplete="off" placeholder="Select Date" 
                                                       ></asp:TextBox>

                                        <span id="v-TadaDate" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>


                                <div class="form-group row">
                                    <label for="Allowance" class="col-sm-3 col-form-label">DA Amount:  </label>

                                    <div class="col-sm-7">
                                      <asp:TextBox  runat="server" class="form-control form-control-sm clsDecimal "   id="txtDAAmount" placeholder="Amount"></asp:TextBox>

                                        <span id="v-Allowance" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>
                                
                                <div class="form-group row">
                                    <label for="Allowance" class="col-sm-3 col-form-label">Tour Type:  </label>

                                    <div class="col-sm-7">
                                       <asp:DropDownList  class="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlTourType"   ></asp:DropDownList>

                                         
                                        
                                          <span class="text-sm-left text-c-red">*</span>

                                    </div>
                                   
                                </div>
                                
                                
                                <div class="form-group row">
                                    <label for="Allowance" class="col-sm-3 col-form-label">Tour Purpose:  </label>

                                    <div class="col-sm-7">
                                       <asp:DropDownList  class="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlTourPurpose"   ></asp:DropDownList>

                                         
                                        
                                          <span class="text-sm-left text-c-red">*</span>

                                    </div>
                                   
                                </div>
                                

                                 <div class="form-group row">
                                    <label for="Allowance" class="col-sm-3 col-form-label">Hotel Name:  </label>

                                    <div class="col-sm-7">
                                      <asp:TextBox  runat="server" class="form-control form-control-sm "   id="txtHotelName" placeholder="Hotel Name"></asp:TextBox>

                                         
                                      


                                    </div>
                                   
                                </div>

                                   <div class="form-group row">
                                    <label for="Allowance" class="col-sm-3 col-form-label">Hotel Phone:  </label>

                                    <div class="col-sm-7">
                                      <asp:TextBox  runat="server" class="form-control form-control-sm "   id="txtHotelPhone" placeholder="Hotel Phone"></asp:TextBox>

                                         
                                        


                                    </div>
                                   
                                </div>
                                   
                                   <div class="form-group row">
                                    <label for="Allowance" class="col-sm-3 col-form-label">Remarks:  </label>

                                    <div class="col-sm-7">
                                      <asp:TextBox  runat="server" class="form-control form-control-sm "   id="txtRemarks" placeholder="Remarks"></asp:TextBox>

                                         
                                         

                                    </div>
                                   
                                </div>

                                 

                                <br />

                               

                                
                            </div>


                                    <br />
                                      <h4>Market Structure</h4>
                                    <hr /> 
                                          <div class="form-group row">
                                    <label for="GroupSelect" class="col-sm-2 col-form-label">  Group:  </label>

                                    <div class="col-sm-3">
                                           <div class="input-group">
                                        <asp:DropDownList runat="server" id="GroupSelect" AutoPostBack="true" OnSelectedIndexChanged="GroupSelect_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2" >   </asp:DropDownList>
                                    

                                        <span class="input-group-text text-c-red">*</span>
   
                                                    </div>
                                    </div>


                                    <label for="ZoneSelect" class="col-sm-2 col-form-label"> Zone:  </label>

                                    <div class="col-sm-3">
                                           <div class="input-group">
                                      <asp:DropDownList runat="server"  id="ZoneSelect" AutoPostBack="true" OnSelectedIndexChanged="ZoneSelect_SelectedIndexChanged"  class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>   

                                        <span class="input-group-text text-c-red">*</span>
                                       
                                     
  
                                                    </div>

                                    </div>

                                </div>





                                <div class="form-group row" style="margin-top:6px;">
                                    <label class="col-sm-2 col-form-label">Area:  </label>

                                    <div class="col-sm-3">
                                                <div class="input-group">
                                        <asp:DropDownList runat="server"   id="AreaSelect"  AutoPostBack="true" OnSelectedIndexChanged="AreaSelect_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                        <span class="input-group-text text-c-red">*</span>
                                        
                                                        
                                                    </div>
                                    </div>


                                   

                                    <label for="AreaSelect" class="col-sm-2 col-form-label">Territory:  </label>

                                    <div class="col-sm-3">

                                         <div class="input-group">
                                           <asp:DropDownList runat="server"    id="TeritorySelect"   AutoPostBack="true" OnSelectedIndexChanged="TeritorySelect_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2">   </asp:DropDownList>
                                        <span class="input-group-text text-c-red">*</span>

                                        <span id="v-TeritorySelect" class="invalid-tooltip fade hide" data-delay="2000"></span>

                                               
                                                    </div>
                                    </div>
                                    
                                </div>



                                <div class="form-group row" style="margin-top:6px;">

                                       <label for="MarketSelect" class="col-sm-2 col-form-label">Sub-Territory:  </label>

                                    <div class="col-sm-3">

                                         <div class="input-group">
                                          <asp:DropDownList runat="server"     AutoPostBack="true" OnSelectedIndexChanged="SubTeritory_SelectedIndexChanged" id="SubTeritory"  class="form-select form-select-sm mb-3 mySelect2">  </asp:DropDownList>

                                        <span class="input-group-text text-c-red">*</span>
                                       
                                               
                                                    </div>

                                    </div>      
                                    <label for="MarketSelect" class="col-sm-2 col-form-label">Market:  </label>

                                    <div class="col-sm-3">

                                         <div class="input-group">
                                       <asp:DropDownList runat="server"    id="MarketSelect"  class="form-select form-select-sm mb-3 mySelect2">  </asp:DropDownList>
                                        <span class="input-group-text text-c-red">*</span>

                                    
                                               
                                                    </div>

                                    </div>                                    </div>
                                      <br />
                              
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

