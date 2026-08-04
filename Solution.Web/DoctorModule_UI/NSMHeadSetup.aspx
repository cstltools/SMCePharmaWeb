<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="NSMHeadSetup.aspx.cs" Inherits="DoctorModule_UI_NSMHeadSetup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>NSM Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">

                        <a href="../DoctorModule_UI/NSMHeadRecords.aspx"   id="btnBTL"  class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <br />
                            <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="DoctorName" class="col-sm-3 col-form-label">National </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <select class="form-select form-select-sm mb-3 mySelect2" id="NationalSelect"></select>
                                                <span id="v-NationalSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>


                                    </div>

                                </div>
                            </div>



                            <%--<div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="customSwitch1" class="col-sm-3 col-form-label">&nbsp; </label>
                                        <div class="col-sm-7">
                                            <div class="custom-control custom-switch mt-2">

                                                <input type="checkbox" class="custom-control-input" id="isVacent" checked onchange="IsVacantChange()">
                                                <label class="custom-control-label" for="isVacent">Is Vacant </label>

                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>--%>

                            <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="areaSelect" class="col-sm-3 col-form-label">NSM Name </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <select id="ddlEmployee" name="ddlEmployee" class="form-select form-select-sm mb-3 mySelect2"></select>
                                                <span id="v-ddlEmployee" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                   <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label><br />
                                        <div class="col-sm-7">
                                            <div  class="form-check form-switch">
                                                <input type="checkbox" class="form-check-input" id="customSwitch1" checked onchange="IsActiveChange()">
                                               <label  class="custom-control-label" for="customSwitch1">Active</label>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="acDate" id="pacinTxt" class="col-sm-3 col-form-label">Active Date </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <input id="acDate" type="text" class="datepicker form-control form-control-sm" autocomplete="off" placeholder="Select Date" data-date-autoclose="true" data-date-today-highlight="true" data-date-format="dd-M-yyyy">
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>


                            <br />
                            <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">

                                    <div class="form-group row">
                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                        <div class="col-sm-9">

                                            <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm" onclick="Save()">
                                                <i class="fa fa-check"></i>Submit
                                            </button>
                                            <button type="button" class="btn btnMyDesignReset   btn-sm" onclick="ResetLink()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </button>


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
<input id="hfEMPMID" value="0" style="display:none" />

    <script>
        function ResetLink() {
            location.reload();
        }
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
        $(function () {
            GetNationalInfo(0);
            var masterid = getUrlVars()["id"];
            var EMPMID = getUrlVars()["EMPMID"];
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);
                GetData(masterid);
            }

            else if (EMPMID) {
                $("#hfEMPMID").val(getUrlVars()["EMPMID"]);
                GetNSMMMAsterData(EMPMID);
                btnBTL.href = "../MasterSetup_UI/EmployeeRecords.aspx";
                //  GetData($('#masterId').val());

            }

            else {
                GetNationalInfo(0);
                GetEmployee(0);
            }
           

            $('.datepicker').pickadate({
                selectMonths: true,
                selectYears: true
            })
            function GetNationalInfo(id) {
                _GetNational_Active($('#NationalSelect'), 'NationalId', 'NationalName', id);
                $('#NationalSelect').val(1).trigger('change');

            }

            $("#ddlGroup").on("change", function (e) {
                var groupId = $("#ddlGroup").val();
                if (groupId > 0) {
                    GetZone_ByGroup(groupId);
                }
            });

            $("#zoneSelect").on("change", function (e) {
                var zoneId = $("#zoneSelect").val();



                if (zoneId > 0) {
                    GetArea_ByZone(zoneId);
                }
            });
        });


        function GetNSMEmployee_All(id, SetId) {



            _getNSMEmployee_All($('#ddlEmployee'), 'EmpInfoId', 'EmployeeName', id, SetId)
        }

        function GetGroupAllInfo(id) {
            _GetGroupInfo_All($('#ddlGroup'), 'GroupId', 'GroupName', id);
        }


        function GetNSMMMAsterData(id) {

            var urlpath = 'FieldForce.aspx/GetNSMSetupEditDataByEmpId';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;

                    $("#masterId").val(data.NSMId);
                    GetData(data.NSMId);
                },
                complete: function () {
                }
            });
        }


        function GetData(id) {

            var urlpath = 'FieldForce.aspx/GetNSMSetupEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;
                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");

                   
                    GetGroupAllInfo(data.GroupId);
         
                    //$('#ddlGroup').attr('disabled', false);
                    //$('#ddlGroup').prop('disabled', false);
                    $("#NationalSelect").prop("disabled", true);
                   // $("ddlGroup").attr('readonly', 'readonly');
                    GetNSMEmployee_All(id, data.EmployeeId);
                    //GetEmployee(data.EmployeeId);
                    $('#acDate').val((data.ActiveDateStr));

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

        function IsVacantChange() {

            var isActive = $('#isVacent').is(':checked');

            if (isActive) {
                $('#ddlEmployee').val(1);
            }
            else {
                $('#ddlEmployee').val(0);
            }
        }

        function GetArea_ByZone(id) {

            var urlpath = 'FieldForce.aspx/LoadVacentArea';

            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "POST", contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ 'zoneId': id }),
                async: true,
                success: function (data) {
                    data = data.d;
                    var result = JSON.parse(data);

                    console.log(result);

                    $('#areaSelect').empty();
                    $('#areaSelect').append("<option value='0'> Select From List</option>");
                    for (var i = 0; i < result.length; i++) {

                        $('#areaSelect').append($("<option></option>").val(result[i].AreaId).html(result[i].AreaName));
                    }

                    $("#areaSelect").select2();
                }
            });



            //_getZone_ByGroupId_Active($('#zoneSelect'), 'RegionId', 'RegionName', id);
        }

        function GetZone_ByGroup(id) {

            _getZone_ByGroupId_Active($('#zoneSelect'), 'RegionId', 'RegionName', id);
        }

        function GetGroup(id) {
            var urlpath = 'FieldForce.aspx/LoadVacentGroup';
            SelectOption_DtTable_Async_True(urlpath, $('#ddlGroup'), 'GroupId', 'GroupName', 0);
            //$('#ddlGroup').select2();
        }

        function GetEmployee(id) {
            var urlpath = 'SeedData.aspx/GetEmployee_AllFieldForceEmployeeList';
            SelectOption_DtTable_Async_True(urlpath, $('#ddlEmployee'), 'EmpInfoId', 'EmployeeName', id);
            $('#ddlEmployee').select2();
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
            $('#NationalSelect').removeClass('is-invalid');
            $('#ddlEmployee').removeClass('is-invalid');
           /* $('#areaSelect').removeClass('is-invalid');*/
            $('#acDate').removeClass('is-invalid');
            RemoveValidationTooltip("#v-NationalSelect");
            //RemoveValidationTooltip("#v-areaSelect");
            RemoveValidationTooltip("#v-acDate");
            isValid = true;

            if ($('#NationalSelect').val() == "" || $('#NationalSelect').val() == "0" || $('#NationalSelect').val() == null) {

                $('#NationalSelect').addClass("is-invalid");
                ValidationTooltip("#v-NationalSelect", "Please fill out of this field!");
                isValid = false;
            }

            //debugger;
            //if ($('#areaSelect').val() == "" || $('#areaSelect').val() == "0" || $('#areaSelect').val() == null) {
            //    $('#areaSelect').addClass("is-invalid");
            //    ValidationTooltip("#v-areaSelect", "Please fill out of this field!");
            //    isValid = false;
            //}

            if ($('#ddlEmployee').val() == "" || $('#ddlEmployee').val() == "0" || $('#ddlEmployee').val() == null) {
                $('#ddlEmployee').addClass("is-invalid");
                ValidationTooltip("#v-ddlEmployee", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#acDate').val() == "") {

                $('#acDate').addClass("is-invalid");
                ValidationTooltip("#v-acDate", "Please fill out of this field!");
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
            jsonData["NSMId"] = $('#masterId').val();
            //jsonData["CompanyId"] = $('#ddlGroup').val();
            jsonData["EmployeeId"] = $('#ddlEmployee').val();
            jsonData["GroupId"] = $('#NationalSelect').val();
            jsonData["IsActive"] = $('#customSwitch1').is(':checked');
            jsonData["Activedate"] = $('#acDate').val();

       

            var urlpath = 'FieldForce.aspx/Save_NSMHeadInfo';
            $.ajax({
                data: JSON.stringify({ 'aNSMInfo': jsonData }),
                url: urlpath,
                contentType: "application/json; charset=utf-8",
                type: "POST",
                beforeSend: function () {
                    //_open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    result = result.d;
                    //_close_LoadingPopUp_WithMsg();
                    /*alert(result.isSuccess);*/
                    if (result.isSuccess == true) {



                        if ($("#hfEMPMID").val() == "0") {
                            successalert('Operation successful!', 'Success', 'NSMRecords.aspx');

                        }
                        else {
                            successalert('Operation successful!', 'Success', '../MasterSetup_UI/NSMHeadRecords.aspx');

                        }
                     
                    }
                    else if (result.isValiCheck == true) {

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


    </script>

</asp:Content>

