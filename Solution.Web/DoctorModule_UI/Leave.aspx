<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="Leave.aspx.cs" Inherits="DoctorModule_UI_Leave" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Leave Information</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/LeaveView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
     <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">Leave Name:  </label>

                                    <div class="col-sm-5">
                                        <input type="text" class="form-control form-control-sm mb-3 " required="true" id="mainName" placeholder="Leave Name">

                                        <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>


                                <div class="form-group row">
                                    <label for="Days"  class="col-sm-3 col-form-label"> Number Of Days: </label>
                                    <div class="col-sm-5">
                                        <input type="text" class="form-control form-control-sm mb-3 clsDecimal" required="true" id="Days" placeholder="Number Of Days">

                                        <span id="v-Days" class="invalid-tooltip fade hide" data-delay="1000">
                                        </span>
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>

                                </div>


                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label><br />
                                    <div class="col-sm-5">
                                      <div class="form-check form-switch">
                                            <input type="checkbox" class="form-check-input" id="customSwitch1" checked onchange="IsActiveChange()">
                                             
                                             <label  class="custom-control-label" for="customSwitch1">Active</label>
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
                                        <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm"   onclick="Save()">
                                            <i class="fa fa-check"></i>Submit
                                        </button>
                                        <button type="button" class="btn btnMyDesignReset   btn-sm"  onclick="ResetLink()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </button>
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>

                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>

<input id="masterId" value="0" style="display:none" />


    <script>

        function ResetLink() {
            location.reload();
        }

        $(".clsDecimal").keypress(function (event) {

            $(this).val($(this).val().replace(/[^0-9\.]/g, ''));
            if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                /* if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {*/
                // $("#v-Days").html("Number Only").stop().show().fadeOut("slow");*/

                return false;
            }
        });
        $(function () {
       
        var masterid = getUrlVars()["id"];
        if (masterid) {
            $("#masterId").val(getUrlVars()["id"]);
        }
        let id = $('#masterId').val();



        if (id > 0) {
            $('#acDate').datepicker();
           // $('#hRemarkDiv').show();
            GetData(id);

        } else {
            $('#acDate').datepicker("update", new Date());
            //GetZone(0);
            //GetThana(0);
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
             location.href = '../DoctorModule_UI/Leave.aspx';

        }

    function IsActiveChange() {
        var isActive = $('#customSwitch1').is(':checked');
        $('#acttxt').text("");
        if (isActive) {
            $('#acttxt').text("Active Date:");

        } else {
            $('#acttxt').text("Inactive  Date:");
        }
    }

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

            debugger;

            $('#mainName').removeClass('is-invalid');
            $('#Days').removeClass('is-invalid');
            RemoveValidationTooltip("#v-mainName");
            RemoveValidationTooltip("#v-Days");
             isValid = true;
            if ($('#mainName').val() == "") {


                $('#mainName').addClass("is-invalid");
                ValidationTooltip("#v-mainName", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#Days').val() == "") {

                $('#Days').addClass("is-invalid");
                ValidationTooltip("#v-Days", "Please fill out of this field!");
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



        var jsonData = {};
            jsonData["LeaveTypeId"] = $('#masterId').val();
            jsonData["LeaveTypeName"] = $.trim($('#mainName').val());
            jsonData["LeaveDays"] = $.trim($('#Days').val());
            jsonData["IsActive"] = $('#customSwitch1').is(':checked');


            var urlpath = 'Leave.aspx/Save_Leaveinfo';
            $.ajax({
                data: JSON.stringify({ 'employee': jsonData }),
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

                        successalert('Operation successful!', 'Success', 'LeaveView.aspx');
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

            var urlpath = 'Leave.aspx/GetEmployeeEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;
                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");
                    $('#mainName').val(data.LeaveTypeName);

                    $('#Days').val((data.LeaveDays));
                    if (data.IsActive) {
                        $('#customSwitch1').prop('checked', true);

                    } else {
                        $('#customSwitch1').prop('checked', false);

                    }
                },
                complete: function() {
                }
            });
        }
    </script>







    

</asp:Content>

