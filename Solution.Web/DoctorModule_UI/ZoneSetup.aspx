<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ZoneSetup.aspx.cs" Inherits="DoctorModule_UI_ZoneSetup" %>

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

    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Zone Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/ZoneRecords.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <div class="row mt-1">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-7">
                                <div class="form-group row">
                                    <label for="GroupNameSelect" class="col-sm-3 col-form-label"> Group  </label>
                                    <div class="col-sm-7">
                                           <div class="input-group">
                                        <select id="GroupNameSelect" name="GroupNameSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
                                        <span id="v-GroupNameSelect" class="invalid-tooltip fade hide" data-delay="1000"></span>
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
                                    <label for="zoneName" class="col-sm-3 col-form-label">Zone Code:  </label>
                                    <div class="col-sm-7">

                                             <div class="input-group">
                                        <input type="text" class="form-control form-control-sm mb-3" id="zoneCode" autocomplete="off" placeholder="Enter Zone Code">
                                        <span id="v-zoneCode" class="invalid-tooltip fade hide" data-delay="1000"></span>
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
                                    <label for="zoneName" class="col-sm-3 col-form-label">Zone Name:  </label>
                                    <div class="col-sm-7">

                                             <div class="input-group">
                                        <input type="text" class="form-control form-control-sm mb-3" id="zoneName" autocomplete="off" placeholder="Enter Zone Name">
                                        <span id="v-zoneName" class="invalid-tooltip fade hide" data-delay="1000"></span>
                                                 <span class="input-group-text text-c-red">*</span>
                                    </div>
                                    </div>
                                    
                                </div>

                            </div>
                             <div class="col-2" id="divShowHide">
                                <div class="form-group row"  style="display:none">
                                  <br />
                                    <div class="col-sm-12">
                                        <div class="form-check form-switch">
                                            <input type="checkbox" class="form-check-input" id="isStrucChange" checked  >
                                             
                                             <label  class="custom-control-label" for="isStrucChange">Is Structure Change</label>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>

                        <div class="row mt-1" style="display:none">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-7">
                                <div class="form-group row">

                                    <label for="divisionSelect" class="col-sm-3 col-form-label">Division:  </label>
                                    <div class="col-sm-7">

                                         <div class="input-group">
                                        <select class="form-select form-select-sm mb-3 mySelect2" id="divisionSelect" multiple="multiple" autocomplete="off" data-width="100%"></select>
                                        <span id="v-divisionSelect" class="invalid-tooltip fade hide" data-delay="1000"></span>
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
                                    <label for="acDate" id="pacinTxt" class="col-sm-3 col-form-label"> Active Date </label>
                                    <div class="col-sm-7">
                                          <div class="input-group">
                                        <input id="acDate" type="text" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Date" >
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
        //$('#acDate').datepicker();
        $(function () {
            $('.datepicker').pickadate({
                selectMonths: true,
                selectYears: true
            })
            var masterid = getUrlVars()["id"];
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);

                GetData(masterid);
                $("#divShowHide").show();


            }
            else {
                GetGroupInfo(0);

                GetDivision(0);
                $("#divShowHide").hide();
            }
      

        });
        function GetGroupInfo(id) {
            _GetGroupInfo_Active($('#GroupNameSelect'), 'GroupId', 'GroupName', id);
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


        function GetZone_ByGroup(id) {

            _getZone_ByGroupId_Active($('#zoneSelect'), 'ZoneId', 'ZoneName', id);
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


 



        function GetDivision(id) {
            var urlpath = 'SeedData.aspx/GetDivisionList';
            Multiple_DisableOption(urlpath, $('#divisionSelect'), 'DivisionId', 'DivisionName', id);
         }




        function Multiple_DisableOption(urlpath, setControlId, bindId, bindName, setId) {
            var IsDisable = 'IsDisable';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    var result = JSON.parse(data.d);
                    setControlId.empty();
                    debugger;
                    for (var i = 0; i < result.length; i++) {
                        if (result[i][IsDisable] == 1) {
                            setControlId.append($("<option disabled='disabled'></option>").val(result[i][bindId]).html(result[i][bindName]));
                        } else {
                            setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));
                        }
                    }
                },
                complete: function () {
                    if (setId == 0) {

                    } else {
                        let arr = setId.split(',');
                        setControlId.val(arr).change();
                    }

                    setControlId.select2();
                    setControlId.val(setId);
                }
            });
        }


    //@*function GetDivision(divId) {
    //        var urlpath = '@Url.Action("GetDivisionList", "SeedData")';
    //        $.ajax({
    //            url: urlpath,
    //            dataType: 'json',
    //            type: "Get",
    //            async: true,
    //            success: function (data) {

    //                var result = JSON.parse(data);
    //                $('#divisionSelect').empty();
    //                for (var i = 0; i < result.length; i++) {
    //                    $("#divisionSelect").append($("<option></option>").val(result[i].DivisionId).html(result[i].DivisionName));
    //                }
    //            },
    //            complete: function () {
    //                if (divId == 0) {

    //                } else {
    //                    let arr = divId.split(',');
    //                    $('#divisionSelect').val(arr).change();
    //                }
    //                //$('.selectpicker').selectpicker('refresh');
    //                $('#divisionSelect').select2();
    //            }
    //        });
    //}*@





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


            $('#GroupNameSelect').removeClass('is-invalid');

            $('#zoneName').removeClass('is-invalid');

            //$('#divisionSelect').removeClass('is-invalid');
            $('#acDate').removeClass('is-invalid');

            RemoveValidationTooltip("#v-GroupNameSelect");

            RemoveValidationTooltip("#v-zoneName");

            //RemoveValidationTooltip("#v-divisionSelect");

            RemoveValidationTooltip("#v-acDate");



            $('#zoneCode').removeClass('is-invalid');

            RemoveValidationTooltip("#v-zoneCode");

            isValid = true;


            if ($('#GroupNameSelect').val() == 0 || $('#GroupNameSelect').val() == null || $('#GroupNameSelect').val() == "") {

                $('#GroupNameSelect').addClass("is-invalid");
                ValidationTooltip("#v-GroupNameSelect", "Please fill out of this field!");
                isValid = false;
            }


            if ($('#zoneCode').val() == "") {


                $('#zoneCode').addClass("is-invalid");
                ValidationTooltip("#v-zoneCode", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#zoneName').val() == 0 || $('#zoneName').val() == null || $('#zoneName').val() == "") {

                $('#zoneName').addClass("is-invalid");
                ValidationTooltip("#v-zoneName", "Please fill out of this field!");
                isValid = false;
            }

            //if ($('#divisionSelect').val() == "") {

            //    $('#divisionSelect').addClass("is-invalid");
            //    ValidationTooltip("#v-divisionSelect", "Please fill out of this field!");
            //    isValid = false;
            //}

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


            var zoneId = $('#masterId').val();

        var ZoneName = $('#zoneName').val();
        var dv = $('#divisionSelect').val();
        var isActive = $('#customSwitch1').is(':checked');
        var acDate = $('#acDate').val();
        //var remarksTxt = $('#remarksTxt').val();
        var divisionSelect = dv.toString();
        var groupId = $('#GroupNameSelect').val();
        var jsonData = {};
            jsonData["RegionId"] = zoneId;
            jsonData["RegionName"] = ZoneName;
        jsonData["DivisionId"] = divisionSelect;
            jsonData["IsActive"] = isActive;
            jsonData["AcOrInAcDate"] = acDate;
        //jsonData["Remarks"] = remarksTxt;
            jsonData["GroupId"] = groupId;

            jsonData["CodeStr"] = $.trim($('#zoneCode').val());


            var urlpath = 'Setup.aspx/SaveZone';
            $.ajax({
                data: JSON.stringify({ 'Zone': jsonData }),
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

                        successalert('Operation successful!', 'Success', 'ZoneRecords.aspx');
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



            //
            //@*$.ajax({
            //    data: jsonData,
            //    url: urlpath,
            //    type: "POST",
            //    beforeSend: function () {
            //        _open_LoadingPopUp_WithMsg("popDIv", "Please wait. Data is Saving...");
            //    },
            //    success: function (result) {
            //        _close_LoadingPopUp_WithMsg();
            //        if (result.isSuccess == true) {
            //              $.confirm({
            //                icon: 'fas fa-check-circle',
            //                title: 'Success !',
            //                content: 'Saving data has been successful',
            //                type: 'green',
            //                buttons: {
            //                    OK: {
            //                        text: 'OK',
            //                        action: function () {
            //                    var url = '@Url.Action("ZoneRecords", "Setup")';
            //                    window.location.href = url;
            //                        }
            //                    }
            //                }
            //            });
            //        }

            //    },
            //    error: function (data) {
            //        _close_LoadingPopUp_WithMsg();
            //    },

            //});*@
    }

        
        function GetGroupAllInfo(id) {
            _GetGroupInfo_All($('#GroupNameSelect'), 'GroupId', 'GroupName', id);
        }
    function GetData(id) {
        var urlpath = 'Setup.aspx/GetZoneEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                //dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;

                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");

                    GetGroupAllInfo(data.GroupId);

                    $('#zoneName').val(data.RegionName);
                    $('#zoneCode').val(data.RegionCode);
                    $('#acDate').val(ToJavaScriptDate_Formater(data.AcOrInAcDate));
                    $('#remarksTxt').val(data.Remarks);
                    if (data.IsActive) {
                        $('#customSwitch1').prop('checked',true);
                    } else {
                        $('#customSwitch1').prop('checked', false);
                    }
                    GetDivision(data.DivisionId);
                   // GetGroup(data.GroupId);


                 //   $("#GroupNameSelect").prop("disabled", true);
                   

                },
                complete: function() {

                }
            });
    }
    </script>



</asp:Content>

