<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="RsmSetup.aspx.cs" Inherits="DoctorModule_UI_RsmSetup" %>

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
</style>

<div class="container-fluid" style="width: 100% !important;">

    <div class="page-body m-t-20">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="card main-card  pb-4">
                    <div class="card-header main-card-head">
                        <h5 class=""> <i class="fas fa-1x fa-th-large "></i> DZSM Setup </h5>
                        <a href="RsmRecords.aspx" class="btn btn-sm btn-info">
                            <%--@*<i data-feather="plus" style="width: 16px !important; height: 16px !important;"></i>&nbsp;New Entry*@--%>
                            <i data-feather="corner-up-right" style="width: 16px !important; height: 16px !important;"></i> Back to list
                        </a>
                    </div>

                    <div class="card-body">
                        <br />
                        <div class="row mt-1">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="DoctorName" class="col-sm-3 col-form-label"> Group Name: <span class="text-sm-left text-c-red">[ * ]</span> </label>
                                    <div class="col-sm-7">
                                        <select class="form-control" id="ddlGroup"></select>
                                        <span id="v-ddlGroup" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                    </div>
                                </div>

                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="DoctorName" class="col-sm-3 col-form-label">Zone Name: <span class="text-sm-left text-c-red">[ * ]</span> </label>
                                    <div class="col-sm-7">
                                        <select id="zoneSelect" name="zoneSelect" class="form-control">
                                           
                                        </select>
                                        <span id="v-zoneSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                    </div>
                                </div>

                            </div>
                        </div>

                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="DoctorName" class="col-sm-3 col-form-label"> &nbsp; </label>
                                    <div class="col-sm-7">
                                        <div class="custom-control custom-switch mt-2">
                                            <div class="custom-control custom-switch pl-0">
                                                <input type="checkbox" class="custom-control-input" id="isVacent" checked onchange="IsVacantChange()">
                                                <label class="custom-control-label" for="isVacent"> Is Vacant </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="DoctorName" class="col-sm-3 col-form-label">RSM / DZSM Name: <span class="text-sm-left text-c-red">[ * ]</span> </label>
                                    <div class="col-sm-7">
                                        <select id="ddlEmployee" name="ddlEmployee" class="form-control"></select>
                                        <span id="v-ddlEmployee" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                    </div>
                                </div>

                            </div>
                        </div>

                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="DoctorName" class="col-sm-3 col-form-label"> &nbsp; </label>
                                    <div class="col-sm-7">
                                        <div class="custom-control custom-switch mt-2">
                                            <input type="checkbox" class="custom-control-input" id="customSwitch1" checked onchange="IsActiveChange()">
                                            <label class="custom-control-label" for="customSwitch1"> Is Active </label>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="DoctorName" id="pacinTxt" class="col-sm-3 col-form-label"> Active Date:<span class="text-sm-left text-c-red">[ * ]</span> </label>
                                    <div class="col-sm-7">
                                        <input id="acDate" type="text" class="datepicker form-control" autocomplete="off" placeholder="Select Date" data-date-autoclose="true" data-date-today-highlight="true" data-date-format="dd-M-yyyy">
                                        <span id="v-acDate" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                    </div>
                                </div>

                            </div>
                        </div>


                        <br />
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-9">
                                        <button type="button" id="btnSave" class="btn btn-sm btn-primary mb-2" style="background-color: #00bcd4;color: #fff;" onclick="Save()">
                                            <i class="fas fa-check-square"></i>&nbsp; Save Information
                                        </button>
                                        <button type="button" class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" onclick="ConfirmationClick()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset Information </button>
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
    
<%--    <script src="../assets/js/jquery-3.6.0.min.js"></script>
    <script src="../assets/js/select2.js"></script>        
    <script src="../assets/jquery-ui.min.js"></script>
    <link href="../assets/jquery-ui.min.css" rel="stylesheet" />
    <script src="../assets/vendors/core/core.js"></script>
    <script src="../assets/vendors/datatables.net/jquery.dataTables.js"></script>
    <script src="../assets/vendors/datatables.net/dataTables.buttons.min.js"></script>

<script type="text/javascript" src="~/CustomScript/_myCusGen_Func.js"></script>--%>

    <script type="text/javascript">

        $(function ()
        {
            GetGroup(0);
            GetEmployee(0);
            $('#acDate').datepicker();

            alert('Hi');


            $("#ddlGroup").on("change", function (e) {
                var groupId = $("#ddlGroup").val();
                if (groupId > 0)
                {
                   
                    GetZone_ByGroup(groupId);
                }
            });
        });

        function IsVacantChange() {

            var isActive = $('#isVacent').is(':checked');

            if (isActive)
            {

                $('#ddlEmployee').val(1).change();
            }
            else
            {
                $('#ddlEmployee').val(0).change();
            }
        }


        function GetZone_ByGroup(id) {
           
            var urlpath = 'FieldForce.aspx/LoadVacentRegion';

            console.log(id);

            $.ajax({
                //url: urlpath,
                data: JSON.stringify({ 'groupId': id }),
                url: urlpath,
                contentType: "application/json; charset=utf-8",
                type: "POST",
                async: false,
                success: function (data) {
                    data = data.d;
                    var result = JSON.parse(data);


                   

                    $('#zoneSelect').empty();
                    $('#zoneSelect').append("<option value='0'> Select From List</option>");
                    for (var i = 0; i < result.length; i++) {
                        
                        $('#zoneSelect').append($("<option></option>").val(result[i].RegionId).html(result[i].RegionName));
                    }

                    //data=data.d;
                    $("#zoneSelect").select2();
                }
            });



            //_getZone_ByGroupId_Active($('#zoneSelect'), 'RegionId', 'RegionName', id);
        }



        function GetGroup(id)
        {
            var urlpath = 'SeedData.aspx/GetGroupList';
            SelectOption_DtTable_Async_True(urlpath, $('#ddlGroup'), 'GroupId', 'GroupName', 0);
            //$('#ddlGroup').select2();
        }

        function GetEmployee(id)
        {
            var urlpath = 'SeedData.aspx/GetEmployeeList';
            SelectOption_DtTable_Async_True(urlpath, $('#ddlEmployee'), 'EmpInfoId', 'EmployeeName', id);
            //$('#ddlEmployee').select2();
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

        function Validation()
        {
            $('#ddlGroup').removeClass('is-invalid');
            $('#ddlEmployee').removeClass('is-invalid');
            $('#zoneSelect').removeClass('is-invalid');
            $('#acDate').removeClass('is-invalid');
            RemoveValidationTooltip("#v-ddlGroup");
            RemoveValidationTooltip("#v-zoneSelect");
            RemoveValidationTooltip("#v-ddlEmployee");
            RemoveValidationTooltip("#v-acDate");
            isValid = true;

            if ($('#ddlGroup').val() == "") {

                $('#ddlGroup').addClass("is-invalid");
                ValidationTooltip("#v-ddlGroup", "Please fill out of this field!");
                isValid = false;
            }

            debugger;
            if ($('#zoneSelect').val() == "") {

                $('#zoneSelect').addClass("is-invalid");
                ValidationTooltip("#v-zoneSelect", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#ddlEmployee').val() == "") {
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

            debugger;

        var jsonData = {};
            jsonData["RSMId"] = $('#masterId').val();
            jsonData["CompanyId"] = $('#ddlGroup').val();
            jsonData["EmployeeId"] = $('#ddlEmployee').val();
            jsonData["RegionId"] = $('#zoneSelect').val();
            jsonData["IsActive"] = $('#customSwitch1').is(':checked');
            jsonData["Activedate"] = $('#acDate').val();

          var urlpath = 'FieldForce.aspx/Save_RSMInfo';
            $.ajax({
                data: JSON.stringify({ 'aRSMInfo': jsonData }),
                url: urlpath,
                contentType: "application/json; charset=utf-8",
                type: "POST",
                beforeSend: function () {
                    //_open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    //_close_LoadingPopUp_WithMsg();
                    result = result.d;
                    /*alert(result.isSuccess);*/
                    if (result.isSuccess == true) {
                        alert('Data saved successfully');
                        var url = '../DoctorModule_UI/RsmRecords.aspx';
                                window.location.href = url;
                           
                    } else {
                        //_saveErrorDuplicate();
                    }
                },
                error: function (data) {
                    //_close_LoadingPopUp_WithMsg();
                    //_saveError();
                },
            });
        }


    </script>


</asp:Content>

