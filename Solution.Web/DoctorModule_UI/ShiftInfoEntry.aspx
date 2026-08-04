<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ShiftInfoEntry.aspx.cs" Inherits="DoctorModule_UI_ShiftInfoEntry" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="popDiv">

</div>


    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Shift Information Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/ShiftInfoList.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                    <label for="mainName" class="col-sm-3 col-form-label">Shift name:  </label>

                                    <div class="col-sm-7">
                                         <div class="input-group">
                                        <input type="text" class="form-control form-control-sm mb-3" required id="mainName" placeholder="Shift name">

                                        <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>

                                              <span class="input-group-text text-c-red">*</span>
                                    </div>
                                    </div>
                                    
                                </div>

                                <div class="form-group row">
                                    <label for="StartTime" class="col-sm-3 col-form-label">Start Time:  </label>

                                    <div class="col-sm-7">
                                         <div class="input-group">
                                        <input type="text" class="form-control form-control-sm mb-3 timepicker" required id="StartTime" min="09:00"  data-inputmask="'alias': 'datetime'" data-inputmask-inputformat="hh:mm tt" />

                                        <span id="v-StartTime" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>

                                              <span class="input-group-text text-c-red">*</span>
                                    </div>
                                    </div>
                                    
                                </div>


                                <div class="form-group row">
                                    <label for="EndTime" class="col-sm-3 col-form-label">End Time:  </label>

                                    <div class="col-sm-7">
                                         <div class="input-group">
                                        <input type="text" class="form-control form-control-sm mb-3 timepicker" required id="EndTime"  min="09:00"   data-inputmask="'alias': 'datetime'" data-inputmask-inputformat="hh:mm tt" />



                                        <span id="v-EndTime" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>

                                              <span class="input-group-text text-c-red">*</span>
                                    </div>
                                    </div>
                                    
                                </div>

                                <div class="form-group row" style="margin-top:7px;">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label><br />
                                    <div class="col-sm-7">
                                         
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="customSwitch1" checked onchange="IsActiveChange()">
                                            <label style="padding-top:4px;" class="custom-control-label" for="customSwitch1"> Active</label>
                                        </div>
                                    </div>

                                </div>

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" id="acttxt" class="col-sm-3 col-form-label"> Active Date: </label>
                                    <div class="col-sm-7">
                                         <div class="input-group">
                                        <input id="acDate" type="text" class="form-control form-control-sm mb-3 datepicker" required autocomplete="off" placeholder="Select Date" data-date-autoclose="true" data-date-today-highlight="true" data-date-format="dd-M-yyyy">

                                        <span id="v-acDate" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                              <span class="input-group-text text-c-red">*</span>
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
                                    <div class="col-sm-9">

                                        
                                             <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm"   onclick="Save()">
                                            <i class="fa fa-check"></i>Submit
                                        </button>
                                        <button type="button" class="btn btnMyDesignReset   btn-sm"  onclick="ConfirmationClick()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </button>
                                        
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

        $(function () {

            $('.datepicker').pickadate({
                selectMonths: true,
                selectYears: true
            })
            $('.timepicker').pickatime();

            var masterid = getUrlVars()["id"];
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);
                GetData(masterid);
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
            $('#mainName').removeClass('is-invalid');
            $('#acDate').removeClass('is-invalid');
            $('#StartTime').removeClass('is-invalid');
            $('#EndTime').removeClass('is-invalid');

            RemoveValidationTooltip("#v-mainName");
            RemoveValidationTooltip("#v-acDate");
            RemoveValidationTooltip("#v-StartTime");
            RemoveValidationTooltip("#v-EndTime");
             isValid = true;
            if ($('#mainName').val() == "") {


                $('#mainName').addClass("is-invalid");
                ValidationTooltip("#v-mainName", "Please fill out of this field!");
                isValid = false;
            }
            if ($('#StartTime').val() == "") {


                $('#StartTime').addClass("is-invalid");
                ValidationTooltip("#v-StartTime", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#EndTime').val() == "") {


                $('#EndTime').addClass("is-invalid");
                ValidationTooltip("#v-EndTime", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#acDate').val() == "") {

                $('#acDate').addClass("is-invalid");
                ValidationTooltip("#v-acDate", "Please fill out of this field!");
                isValid = false;
            }


        //if (isValid == false) {
        //    $.confirm({
        //        icon: 'fas fa-exclamation-triangle',
        //        title: 'Validation Error!',
        //        content: 'Please enter mandatory data',
        //        type: 'red',
        //        typeAnimated: true

        //    });
        //}

        return isValid;
    }

        function ConfirmationClick() {
            window.location.href = "ShiftInfoList.aspx";
        }

        function Save() {

            if (Validation()) {
            //$.confirm({
            //    icon: 'fas fa-question-circle',
            //    title: 'Are You Sure ?',
            //    content: 'You are about to save the data!',
            //    theme: 'Supervan',
            //    type: 'green',
            //    buttons: {
            //        Confirm: {
            //            text: 'Confirm',
            //            action: function () {
                            FinalSave();
            //            }
            //        },
            //        Cancel: function () {
            //        }
            //    }
            //});

        }

    }
        function FinalSave() {

        var jsonData = {};
            jsonData["ShiftId"] = $('#masterId').val();
            jsonData["ShiftText"] = $.trim($('#mainName').val());
            jsonData["ShiftInTime"] = ($('#StartTime').val());
            jsonData["ShiftOutTime"] =($('#EndTime').val());

        jsonData["IsActive"] = $('#customSwitch1').is(':checked');
        jsonData["Activedate"] = $('#acDate').val();

            var urlpath = 'ShiftInfoEntry.aspx/Save_ShiftInfo';
            $.ajax({
                data: JSON.stringify({ 'DAO': jsonData }),
                //data: jsonData,
                url: urlpath,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                beforeSend: function () {
                    
                },
                success: function (result) {
                    
                    result = result.d;
                    if (result.isSuccess == true) {

                        successalert('Operation successful!', 'Success', 'ShiftInfoList.aspx');
                    } else {
                        faildalert('Operation Faild!', 'Faild');
                    }
                },
                error: function (data) {
                    faildalert('Operation Faild!', 'Faild');
                },
            });
        }

    function GetData(id) {
        var urlpath = 'ShiftInfoEntry.aspx/GetShiftInfoEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                
                success: function (data) {
                    data = data.d;

                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");
                    $('#mainName').val(data.ShiftText);
                    $('#StartTime').val(data.ShiftInTime);
                    $('#EndTime').val(data.ShiftOutTime);
                    $('#acDate').val(ToJavaScriptDate_Formater(data.Activedate));
                    if (data.IsActive) {
                        $('#customSwitch1').prop('checked', true);
                        $('#acttxt').text("Active Date:");
                    } else {
                        $('#customSwitch1').prop('checked', false);
                        $('#acttxt').text("Inactive  Date:");
                    }
                },
                complete: function() {
                }
            });
        }
    </script>





</asp:Content>


