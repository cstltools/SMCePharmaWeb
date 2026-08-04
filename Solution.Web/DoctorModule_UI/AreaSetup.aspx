<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="AreaSetup.aspx.cs" Inherits="DoctorModule_UI_AreaSetup" %>

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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Area Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/AreaRecords.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                    <label for="GroupSelect" class="col-sm-3 col-form-label"> Group </label>

                                    <div class="col-sm-7">

                                         <div class="input-group">
                                        <select id="GroupSelect" name="GroupSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
                                        <span id="v-GroupSelect" class="invalid-tooltip fade hide" data-delay="1000"></span>
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
                                    <label for="upperSelect" class="col-sm-3 col-form-label">Zone </label>
                                    <div class="col-sm-7">
                                           <div class="input-group">
                                        <select id="upperSelect" name="upperSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
                                        <span id="v-upperSelect" class="invalid-tooltip fade hide" data-delay="1000"></span>
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
                                    <label for="mainName" class="col-sm-3 col-form-label">Area Code </label>
                                    <div class="col-sm-7">
                                         <div class="input-group">
                                        <input type="text" class="form-control form-control-sm mb-3" id="AreaCode" autocomplete="off" placeholder="Enter Area Code">
                                        <span id="v-AreaCode" class="invalid-tooltip fade hide" data-delay="1000"></span>
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
                                    <label for="mainName" class="col-sm-3 col-form-label">Area Name </label>
                                    <div class="col-sm-7">
                                         <div class="input-group">
                                        <input type="text" class="form-control form-control-sm mb-3" id="mainName" autocomplete="off" placeholder="Enter Area Name">
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

                        <div class="row mt-1" style="display:none;">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-7">
                                <div class="form-group row">
                                    <label for="multiSelectId" class="col-sm-3 col-form-label">District </label>
                                    <div class="col-sm-7">
                                         <div class="input-group">
                                        <select class="form-select form-select-sm mb-3 mySelect2" id="multiSelectId" multiple="multiple" autocomplete="off"></select>
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
													<input  class="form-check-input" type="checkbox" onchange="IsActiveChange()" id="customSwitch1" checked>
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
                                        <input id="acDate" type="text" class="datepicker form-control form-control-sm" autocomplete="off" placeholder="Select Date" >
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


        $(function () {

            $('.datepicker').pickadate({
                selectMonths: true,
                selectYears: true
            })
            var masterid = getUrlVars()["id"];
            if (masterid) {

                $("#divShowHide").show();
                $("#masterId").val(getUrlVars()["id"]);
                GetData(masterid);
            }
            else {
                GetGroup(0);
                $("#divShowHide").hide();
                $("#GroupSelect").on("change", function (e) {

                    var groupId = $("#GroupSelect").val();
                    if (groupId > 0) {
                        GetZone_ByGroup(groupId);
                    }
                });

                GetDistrict(0);
            }

      
        });

        function GetGroupAllInfo(id) {
            _GetGroupInfo_All($('#GroupSelect'), 'GroupId', 'GroupName', id);
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

    function IsActiveChange() {
        var isActive = $('#customSwitch1').is(':checked');
        $('#pacinTxt').text("");
        if (isActive) {
            $('#pacinTxt').text("Active Date");
        } else {
            $('#pacinTxt').text("Inactive Date");
        }
    }


    function GetGroup(id) {
        var urlpath = 'SeedData.aspx/GetGroupList';
        SelectOption_DtTable_Async_True(urlpath, $('#GroupSelect'), 'GroupId', 'GroupName', id);
       $('#GroupSelect').select2();
    }



        function GetZone_ByGroup(id) {

            _getZone_ByGroupId_Active($('#upperSelect'), 'RegionId', 'RegionName', id);
        }

        function SetZone_ByGroup(id, SetId) {

         //   _getZone_ByGroupId_Active($('#upperSelect'), 'RegionId', 'RegionName', id);

            _getZone_ByGroupId_Active_SetValue($('#upperSelect'), 'RegionId', 'RegionName', id, SetId)
        }



        function ResetLink() {
            location.reload();
        }



    function GetDistrict(id) {
        var urlpath = 'SeedData.aspx/GetDistrictList_Active';
        Multiple_DisableOption(urlpath, $('#multiSelectId'), 'DistrictId', 'DistrictName', id);
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

            $('#GroupSelect').removeClass('is-invalid');
            $('#upperSelect').removeClass('is-invalid');
            $('#mainName').removeClass('is-invalid');

            //$('#multiSelectId').removeClass('is-invalid');
            $('#acDate').removeClass('is-invalid');

            RemoveValidationTooltip("#v-GroupSelect");
            RemoveValidationTooltip("#v-upperSelect");
            RemoveValidationTooltip("#v-mainName");

            //RemoveValidationTooltip("#v-multiSelectId");
         RemoveValidationTooltip("#v-acDate");



         $('#AreaCode').removeClass('is-invalid');

         RemoveValidationTooltip("#v-AreaCode");



            isValid = true;

         if ($('#GroupSelect').val() == 0 || $('#GroupSelect').val() == null || $('#GroupSelect').val() == "") {

                $('#GroupSelect').addClass("is-invalid");
                ValidationTooltip("#v-GroupSelect", "Please fill out of this field!");
                isValid = false;
            }


         if ($('#upperSelect').val() == 0 || $('#upperSelect').val() == null || $('#upperSelect').val() == "") {

                $('#upperSelect').addClass("is-invalid");
                ValidationTooltip("#v-upperSelect", "Please fill out of this field!");
                isValid = false;
            }

         if ($('#mainName').val() == "" || $('#mainName').val() == null || $('#mainName').val() == "") {

                $('#mainName').addClass("is-invalid");
                ValidationTooltip("#v-mainName", "Please fill out of this field!");
                isValid = false;
            }
         if ($('#AreaCode').val() == "" || $('#AreaCode').val() == null || $('#AreaCode').val() == "") {

             $('#AreaCode').addClass("is-invalid");
             ValidationTooltip("#v-AreaCode", "Please fill out of this field!");
             isValid = false;
         }



         //if ($('#multiSelectId').val() == "" || $('#multiSelectId').val() == null || $('#multiSelectId').val() == "") {

         //       $('#multiSelectId').addClass("is-invalid");
         //       ValidationTooltip("#v-multiSelectId", "Please fill out of this field!");
         //       isValid = false;
         //   }

            if ($('#acDate').val() == "") {

                $('#acDate').addClass("is-invalid");
                ValidationTooltip("#v-acDate", "Please fill out of this field!");
                isValid = false;
            }


            return isValid;
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

       

        var dv = $('#multiSelectId').val();
        var multiId = dv.toString();

        var jsonData = {};
        jsonData["AreaId"] = $('#masterId').val();
        //here zoneid is regionId
        jsonData["ZoneId"] = $('#upperSelect').val();
        jsonData["AreaName"] = $('#mainName').val();
        jsonData["DistrictId"] = multiId;
        jsonData["IsActive"] = $('#customSwitch1').is(':checked');
        jsonData["AcOrInAcDate"] = $('#acDate').val();
        jsonData["Remarks"] = $('#remarksTxt').val();
        jsonData["CodeStr"] = $.trim($('#AreaCode').val());

        var urlpath = 'Setup.aspx/SaveArea';
            $.ajax({
                data: JSON.stringify({ 'masterData': jsonData }),
                url: urlpath,
                contentType: "application/json; charset=utf-8",
                type: "POST",
                beforeSend: function () {

                },
                success: function (result) {
                    result = result.d;


                    if (result.isSuccess == true) {

                        successalert('Operation successful!', 'Success', 'AreaRecords.aspx');
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

                     
                } ,
                error: function (data) {
                    faildalert('Operation Faild!', 'Faild');
                },

            });
    }



    function GetDivision(divId) {
        var urlpath = 'SeedData.aspx/GetDistrictList_Active';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                //data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;
                    var result = JSON.parse(data);
                    $('#multiSelectId').empty();
                    for (var i = 0; i < result.length; i++) {
                        $("#multiSelectId").append($("<option></option>").val(result[i].DistrictId).html(result[i].DistrictName));
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
        //function GetZone_All(id, SetId) {



        //    _getZone_ByGroupId_All_SetValue($('#upperSelect'), 'RegionId', 'RegionName', id, SetId)
        //}

        function GetZone_All(id, SetId) {



            _getZone_ByGroupId_All_SetValue($('#upperSelect'), 'RegionId', 'RegionName', id, SetId)
        }

    function GetData(id) {
        var urlpath = 'Setup.aspx/GetAreaEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;

                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update ");
                    $('#mainName').val(data.AreaName);
                    $('#AreaCode').val(data.AreaCode);
                    GetGroupAllInfo(data.GroupId);
                    $('#remarksTxt').val(data.Remarks);
                    if (data.IsActive) {
                        $('#customSwitch1').prop('checked',true);
                    } else {
                        $('#customSwitch1').prop('checked', false);
                    }
                    GetZone_All(data.GroupId, data.ZoneId);
                    //GetGroup(data.GroupId);
                  //  GetDistrict(data.DistrictId);
                  //  GetZone_All(data.GroupId, data.ZoneId);
                    // SetZone_ByGroup(data.GroupId, data.ZoneId);
                    // alert(data.DistrictId);
                  
                    //$("#GroupSelect").prop("disabled", true);
                    //$("#upperSelect").prop("disabled", true);
                   
                    if (data.DistrictId == null) {
                        GetDistrict(0);
                    }
                    else {
                        GetDistrict(data.DistrictId);
                    }
                   
                    $('#acDate').val(ToJavaScriptDate_Formater(data.AcOrInAcDate));

                  //  $('#upperSelect').val(data.ZoneId);

                },
                complete: function() {

                }
            });
    }
    </script>

}


</asp:Content>

