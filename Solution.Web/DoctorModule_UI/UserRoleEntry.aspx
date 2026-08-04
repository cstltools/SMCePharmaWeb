<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="UserRoleEntry.aspx.cs" Inherits="DoctorModule_UI_UserRoleEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> User Role Setup </div>

                <div class="ms-auto">
                    <div class="btn-group">

                        <a href="../DoctorModule_UI/UserRoleRecords.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>

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
                                        <label for="acDate" class="col-sm-3 col-form-label">User Role </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <input id="userRole" type="text" class="form-control form-control-sm" placeholder="User Role">
                                                <span id="v-userRole" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>

                             <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                             <div class="col-7">
                                    <div class="form-group row">
                                        <label for="GroupNameSelect" class="col-sm-3 col-form-label">Role Type </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">

                                                <select id="RoleTypeSelect" name="RoleTypeSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
                                                <span id="v-RoleTypeSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
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
                                            <div class="form-check form-switch">
                                                <input type="checkbox"  class="form-check-input" id="customSwitch1" checked onchange="IsActiveChange()">
                                                <label class="custom-control-label" for="customSwitch1">Is Active</label>
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
                                                  <span id="v-acDate" class="invalid-tooltip fade hide" data-delay="2000"></span>
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


    <script>
        function ResetLink() {
            location.reload();
        }
        function IsActiveChange() {
            var isActive = $('#customSwitch1').is(':checked');
            $('#pacinTxt').text("");
            if (isActive) {
                $('#pacinTxt').text("Active Date");
            } else {
                $('#pacinTxt').text("Inactive Date");
            }
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

            var masterid = getUrlVars()["id"];
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);
                GetData(masterid);
            }
            else {
                GetRoleTypeInfo(0);
            }
 

   



          
            $('.datepicker').pickadate({
                selectMonths: true,
                selectYears: true
            })
            
        });


        function GetRoleTypeInfo(id) {
            _GetRoleTypeInfo($('#RoleTypeSelect'), 'RoleTypeId', 'RoleType', id);
        }

        function ValidationTooltip(id, message) {


            $(id).empty();

            if ($(id).empty()) {
                $(id).append(message);
            }
            $(id).toast('show');
            $(id).css("display", "block");



        }

        function RemoveValidationTooltip(id)
        {
            $(id).css("display", "none");
        }

        function Validation() {
            $('#userRole').removeClass('is-invalid');
            RemoveValidationTooltip("#v-userRole");

            $('#acDate').removeClass('is-invalid');
            RemoveValidationTooltip("#v-acDate");

            $('#RoleTypeSelect').removeClass('is-invalid');
            RemoveValidationTooltip("#v-RoleTypeSelect");
            isValid = true;

            if ($('#userRole').val() == "" || $('#userRole').val() == "0" || $('#userRole').val() == null) {

                $('#userRole').addClass("is-invalid");
                ValidationTooltip("#v-userRole", "Please fill out of this field!");
                isValid = false;
            }



            if ($('#RoleTypeSelect').val() == "" || $('#RoleTypeSelect').val() == "0" || $('#RoleTypeSelect').val() == null) {

                $('#RoleTypeSelect').addClass("is-invalid");
                ValidationTooltip("#v-RoleTypeSelect", "Please fill out of this field!");
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
            jsonData["UserRoleID"] = $('#masterId').val();
            //jsonData["CompanyId"] = $('#ddlGroup').val();
            jsonData["RoleName"] = $('#userRole').val();
            jsonData["RoleTypeId"] = $('#RoleTypeSelect').val();
            jsonData["IsActive"] = $('#customSwitch1').is(':checked');
            jsonData["Activedate"] = $('#acDate').val();

            console.log(jsonData);

            var urlpath = 'FieldForce.aspx/Save_UserRoleInfo';
            $.ajax({
                data: JSON.stringify({ 'aRoleInfo': jsonData }),
                url: urlpath,
                contentType: "application/json; charset=utf-8",
                type: "POST",
                beforeSend: function () {
                    //_open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    result = result.d;


                    if (result.isSuccess == true) {

                        successalert('Operation successful!', 'Success', 'UserRoleRecords.aspx');
                    }
                    else if (result.isValiCheck == true) {

                        faildalert('Data cannot be deactivated!', 'Faild');
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

            var urlpath = 'FieldForce.aspx/GetUserRoleEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;
                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");
                    $('#userRole').val(data.RoleName);
                    GetRoleTypeInfo(data.RoleTypeId);
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

    </script>


</asp:Content>

