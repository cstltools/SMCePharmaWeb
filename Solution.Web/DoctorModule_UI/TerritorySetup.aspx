<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TerritorySetup.aspx.cs" Inherits="DoctorModule_UI_TerritorySetup" %>

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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Territory Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/TerritoryRecords.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                    <label for="DoctorName" class="col-sm-3 col-form-label"> Group </label>
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
                                    <label for="zoneSelect" class="col-sm-3 col-form-label">Zone </label>
                                    <div class="col-sm-7">
                                          <div class="input-group">
                                        <select id="zoneSelect" name="zoneSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
                                        <span id="v-zoneSelect" class="invalid-tooltip fade hide" data-delay="1000"></span>
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
                                    <label for="areaSelect" class="col-sm-3 col-form-label">Area </label>
                                    <div class="col-sm-7">
                                          <div class="input-group">
                                        <select id="areaSelect" name="zoneSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
                                        <span id="v-areaSelect" class="invalid-tooltip fade hide" data-delay="1000"></span>
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
                                    <label for="mainName" class="col-sm-3 col-form-label">Territory Code </label>
                                    <div class="col-sm-7">
                                          <div class="input-group">
                                        <input type="text" class="form-control form-control-sm mb-3" id="TerritoryCode" autocomplete="off" placeholder="Enter Territory Code">
                                        <span id="v-TerritoryCode" class="invalid-tooltip fade hide" data-delay="1000"></span>
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
                                    <label for="mainName" class="col-sm-3 col-form-label">Territory Name </label>
                                    <div class="col-sm-7">
                                          <div class="input-group">
                                        <input type="text" class="form-control form-control-sm mb-3" id="mainName" autocomplete="off" placeholder="Enter Territory Name">
                                        <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="1000"></span>
                                                 <span class="input-group-text text-c-red">*</span>
                                    </div>
                                    </div>
                                   
                                </div>

                            </div>
                             <div class="col-2" id="divShowHide">
                                <div class="form-group row"   style="display:none">
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

                        <div class="row mt-1"  style="display:none;">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-7">
                                <div class="form-group row">
                                    <label for="multiSelectId" class="col-sm-3 col-form-label">Thana</label>
                                    <div class="col-sm-7">
                                          <div class="input-group">
                                        <select class="form-select form-select-sm mb-3 mySelect2" id="multiSelectId" multiple="multiple" autocomplete="off" data-width="100%"></select>
                                        <span id="v-multiSelectId" class="invalid-tooltip fade hide" data-delay="1000"></span>
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
                                            <input type="checkbox" class="form-check-input"  id="customSwitch1" checked onchange="IsActiveChange()">
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
        $(function () {

            $('.datepicker').pickadate({
                selectMonths: true,
                selectYears: true
            })
            var masterid = getUrlVars()["id"];
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);
                $("#divShowHide").show();
                GetData(masterid);

            }
            else {
                GetGroup(0);
                // GetZone(0);
                GetThana(0);
                $("#divShowHide").hide();
            }
 



        $("#GroupNameSelect").on("change", function (e) {
            debugger;
            var groupId = $("#GroupNameSelect").val();
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

    function GetGroup(id) {
        var urlpath = 'SeedData.aspx/GetGroupList';
        SelectOption_DtTable_Async_True(urlpath, $('#GroupNameSelect'), 'GroupId', 'GroupName', id);
        $('#GroupNameSelect').select2();
    }

    function GetZone_ByGroup(id) {

        _getZone_ByGroupId_Active($('#zoneSelect'), 'RegionId', 'RegionName', id);
        }


    function SetZone_ByGroup(id, setId) {

            _getZone_ByGroupId_Active_SetValue($('#zoneSelect'), 'RegionId', 'RegionName', id, setId);
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


    function GetArea_ByZone(id) {
        _getArea_ByZoneId_Active($('#areaSelect'), 'AreaId', 'AreaName', id);
        }


    function SetArea_ByZoneId(id, SetId) {
            _getArea_ByZoneId_Active_SetValue($('#areaSelect'), 'AreaId', 'AreaName', id, SetId);
        }



    function GetThana(id) {
        var urlpath = 'SeedData.aspx/GetThana_WitTagDetails';
        Selec2_Multiple_DisableOption(urlpath, $('#multiSelectId'), 'ThanaId', 'ThanaName', id);
     }


    function GetZone(id) {
        var urlpath = 'SeedData.aspx/GetZoneList_Active';
            SelectOption_DtTable_Async_True(urlpath, $('#zoneSelect'), 'ZoneId', 'ZoneName', id);
         $('#zoneSelect').select2();
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

            $('#GroupNameSelect').removeClass('is-invalid');
            $('#zoneSelect').removeClass('is-invalid');
            $('#areaSelect').removeClass('is-invalid');
            $('#mainName').removeClass('is-invalid');
           // $('#multiSelectId').removeClass('is-invalid');
            $('#acDate').removeClass('is-invalid');

            RemoveValidationTooltip("#v-GroupNameSelect");

            RemoveValidationTooltip("#v-zoneSelect");

            RemoveValidationTooltip("#v-areaSelect");

            RemoveValidationTooltip("#v-mainName");

           // RemoveValidationTooltip("#v-multiSelectId");

            RemoveValidationTooltip("#v-acDate");



            $('#TerritoryCode').removeClass('is-invalid');

            RemoveValidationTooltip("#v-TerritoryCode");

            isValid = true;

            if ($('#GroupNameSelect').val() == 0 || $('#GroupNameSelect').val() == null || $('#GroupNameSelect').val() == "") {

                $('#GroupNameSelect').addClass("is-invalid");
                ValidationTooltip("#v-GroupNameSelect", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#zoneSelect').val() == 0 || $('#zoneSelect').val() == null || $('#zoneSelect').val() == "") {

                $('#zoneSelect').addClass("is-invalid");
                ValidationTooltip("#v-zoneSelect", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#areaSelect').val() == 0 || $('#areaSelect').val() == null || $('#areaSelect').val() == "") {

                $('#areaSelect').addClass("is-invalid");
                ValidationTooltip("#v-areaSelect", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#mainName').val() == "") {

                $('#mainName').addClass("is-invalid");
                ValidationTooltip("#v-mainName", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#TerritoryCode').val() == "") {

                $('#TerritoryCode').addClass("is-invalid");
                ValidationTooltip("#v-TerritoryCode", "Please fill out of this field!");
                isValid = false;
            }

            //if ($('#multiSelectId').val() == "") {

            //    $('#multiSelectId').addClass("is-invalid");
            //    ValidationTooltip("#v-multiSelectId", "Please fill out of this field!");
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


        var dv = $('#multiSelectId').val();
        var multiId = dv.toString();

        var jsonData = {};
        jsonData["TerritoryId"] = $('#masterId').val();
        jsonData["AreaId"] = $('#areaSelect').val();
        jsonData["TerritoryName"] = $('#mainName').val();
        jsonData["ThanaId"] = multiId;
        jsonData["IsActive"] = $('#customSwitch1').is(':checked');
        jsonData["AcOrInAcDate"] = $('#acDate').val();
        jsonData["Remarks"] = $('#remarksTxt').val();

        jsonData["CodeStr"] = $.trim($('#TerritoryCode').val());


        var urlpath = 'Setup.aspx/SaveTerritory';
            $.ajax({
                data: JSON.stringify({ 'masterData': jsonData }),
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

                        successalert('Operation successful!', 'Success', 'TerritoryRecords.aspx');
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
        function GetGroupAllInfo(id) {
            _GetGroupInfo_All($('#GroupNameSelect'), 'GroupId', 'GroupName', id);
        }

        function GetZone_All(id, SetId) {



            _getZone_ByGroupId_All_SetValue($('#zoneSelect'), 'RegionId', 'RegionName', id, SetId)
        }

        function GetArea_All_ByZone(id, SetId) {
            _getArea_ByZoneId_All($('#areaSelect'), 'AreaId', 'AreaName', id, SetId);
        }

    function GetData(id) {
        var urlpath = 'Setup.aspx/GetTerrritoryEditData';
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
                    GetZone_All(data.GroupId, data.ZoneId);
                    GetArea_All_ByZone(data.ZoneId, data.AreaId);


                      //  $("#GroupNameSelect").prop("disabled", true);
                     //   $("#zoneSelect").prop("disabled", true);
                     //   $("#areaSelect").prop("disabled", true);
                  
                    $('#mainName').val(data.TerritoryName);
                    $('#TerritoryCode').val(data.TerritoryCode);
                    GetThana(data.ThanaId);
                    $('#remarksTxt').val(data.Remarks);
                    if (data.IsActive) {
                        $('#customSwitch1').prop('checked',true);
                    } else {
                        $('#customSwitch1').prop('checked', false);
                    }
                    $('#acDate').val(ToJavaScriptDate_Formater(data.AcOrInAcDate));

                  

                   // GetThanan_ET(data.ThanaId, id);
                  //  GetThana_ET(data.ThanaId);

                },
                complete: function() {

                }
            });
        }

        function GetThana_ET(divId) {
            var urlpath = 'Setup.aspx/GetThana_WitTagDetails_forEditPage';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                //data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {

                    var result = JSON.parse(data);
                    $('#multiSelectId').empty();
                    for (var i = 0; i < result.length; i++) {
                        $("#multiSelectId").append($("<option></option>").val(result[i].ThanaId).html(result[i].ThanaName));
                    }
                },
                complete: function () {
                    if (divId == 0) {

                    } else {
                        let arr = divId.split(',');
                        $('#multiSelectId').val(arr).change();
                    }
                    //$('.selectpicker').selectpicker('refresh');
                    $('#multiSelectId').select2();
                }
            });
    }



    function GetThanan_ET(id,parameterId) {
        var urlpath = 'Setup.aspx/GetThana_WitTagDetails_forEditPage';
          _Selec2_Multiple_DisableOption_WithAjaxParameter(urlpath, $('#multiSelectId'), 'ThanaId', 'ThanaName', id, parameterId);
    }


         function GetDivision(divId) {
             var urlpath = 'Setup.aspx/GetThana_WitTagDetails_forEditPage';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': divId }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;
                    var result = JSON.parse(data);
                    $('#multiSelectId').empty();
                    for (var i = 0; i < result.length; i++) {
                        $("#multiSelectId").append($("<option></option>").val(result[i].ThanaId).html(result[i].ThanaName));
                    }
                },
                complete: function () {
                    if (divId == 0) {

                    } else {
                        let arr = divId.split(',');
                        $('#multiSelectId').val(arr).change();
                    }
                    //$('.selectpicker').selectpicker('refresh');
                    $('#multiSelectId').select2();
                }
            });
    }






    </script>


</asp:Content>

