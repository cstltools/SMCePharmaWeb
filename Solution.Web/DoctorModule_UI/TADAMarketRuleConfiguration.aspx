<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TADAMarketRuleConfiguration.aspx.cs" Inherits="DoctorModule_UI_TADAMarketRuleConfiguration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   
                    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>   DA Market Rule Configuration</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="TADAMarketRuleConfigurationView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
   
                        <div class="row">
                            <div class="col-1">&nbsp;</div>
                            <div class="col-10">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">Tour Type:  </label>

                                    <div class="col-sm-7">
                                        <select id="TourTypeSelect" name="TourTypeSelect" class="form-control form-control-sm">   </select>

                                        <span id="v-TourTypeSelect" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>


                                <div class="form-group row" style="margin-top:12px;">
                                    <label for="mainName" class="col-sm-3 col-form-label">   </label>

                                    <div class="col-sm-7">
                                        <input type="radio" checked id="RoleWise" name="rbWise" value="RoleWise">
                                        <label for="RoleWise">Role Wise</label>
                                        <input type="radio" id="MarketWise" name="rbWise"   style="display:none"  value="MarketWise">
                                        <label for="MarketWise"   style="display:none" >Market Wise</label>

                                        <input type="radio"  style="display:none"  id="Both" name="rbWise" value="Both">
                                        <label style="display:none" for="Both">Both</label>

                                        <span id="v-rbWise"  class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>

                                <div class="form-group row" style="margin-top:12px;">
                                    <label for="UserRoleSelect" class="col-sm-3 col-form-label">Role Type:  </label>

                                    <div class="col-sm-2">
                                        <select id="UserRoleSelect" name="UserRoleSelect" class="form-control form-control-sm">   </select>

                                        <span id="v-UserRoleSelect" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>


                                    <div style="display:none">
                                        <label for="GroupSelect" class="col-sm-2 col-form-label">Group:  </label>

                                        <div class="col-sm-3">
                                            <select id="GroupSelect" name="GroupSelect" disabled class="form-control form-control-sm">   </select>

                                            <span id="v-GroupSelect" class="invalid-tooltip fade hide" data-delay="2000">
                                            </span>


                                        </div>
                                        <span class="text-sm-left text-c-red">*</span>
                                    </div>
                                </div>



                                <div class="form-group row" style="margin-top:6px;display:none;" >
                                    <label class="col-sm-3 col-form-label">  </label>

                                    <div class="col-sm-2">



                                    </div>


                                    &nbsp;

                                    <label for="ZoneSelect" class="col-sm-2 col-form-label">Zone:  </label>

                                    <div class="col-sm-3">
                                        <select id="ZoneSelect" name="ZoneSelect" disabled class="form-control form-control-sm">   </select>

                                        <span id="v-ZoneSelect" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>


                                <div class="form-group row" style="margin-top: 6px; display: none; ">
                                    <label class="col-sm-3 col-form-label">  </label>

                                    <div class="col-sm-2">



                                    </div>


                                    &nbsp;

                                    <label for="AreaSelect" class="col-sm-2 col-form-label">Area:  </label>

                                    <div class="col-sm-3">
                                        <select id="AreaSelect" name="AreaSelect" disabled class="form-control form-control-sm">   </select>

                                        <span id="v-AreaSelect" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>

                                <div class="form-group row" style="margin-top: 6px; display: none;">
                                    <label class="col-sm-3 col-form-label">  </label>

                                    <div class="col-sm-2">



                                    </div>


                                    &nbsp;

                                    <label for="TeritorySelect" class="col-sm-2 col-form-label">Territory:  </label>

                                    <div class="col-sm-3">
                                        <select id="TeritorySelect" name="TeritorySelect" disabled class="form-control form-control-sm">   </select>

                                        <span id="v-TeritorySelect" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>

                                <div class="form-group row" style="margin-top: 6px; display: none;">
                                    <label class="col-sm-3 col-form-label">  </label>

                                    <div class="col-sm-2">



                                    </div>


                                    &nbsp;

                                    <label for="MarketSelect" class="col-sm-2 col-form-label">Market:  </label>

                                    <div class="col-sm-3">
                                        <select id="MarketSelect" name="MarketSelect" disabled class="form-control form-control-sm">   </select>

                                        <span id="v-MarketSelect" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>


                                <div class="form-group row" style="margin-top:6px;">
                                    <label for="TAAmount" class="col-sm-3 col-form-label"> DA Amount: </label>

                                    <div class="col-sm-3">
                                        <input id="DAAmount" name="DAAmount" type="text" required="required" class="form-control form-control-sm">

                                        <span id="v-DAAmount" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>


                                    <label for="DAAmount" class="col-sm-2 col-form-label">   </label>

                                    <div class="col-sm-2" style="display:none">
                                       
                                         <input id="TAAmount" name="TAAmount" type="text" required="required" class="form-control form-control-sm">


                                        <span id="v-TAAmount" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>

                                    </div>
                                    
                                </div>


                                <div class="form-group row">

                                </div>



                                <div class="form-group row">
                                    <label for="AllowedMilagePerKM" class="col-sm-3 col-form-label">Active Status:  </label>

                                    <div class="col-sm-7" style="padding-top:6px;">

                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="customSwitch1" checked onchange="IsActiveChange()">
                                            <label style="padding-top:4px;" id="acttxt" class="custom-control-label" for="customSwitch1"> Active</label>
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
    </div>
</div>

<input id="masterId" value="0" style="display:none" />



 
<%--@section Scripts{--%> 
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
        }
        else {
            GetTourType(0);
            GetUserRoleInfo(0);
            GetGroupInfo(0);
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

        $(function () {
            $("#TAAmount").keypress(function (event) {

                $(this).val($(this).val().replace(/[^0-9\.]/g, ''));
                if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                    /* if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {*/
                    /*  $("#v-AllowedMilagePerKM").html("Number Only").stop().show().fadeOut("slow");*/
                    ValidationTooltip("#v-TAAmount", "Number Only!");
                    return false;
                }
            });
        });

        $(function () {
            $("#DAAmount").keypress(function (event) {

                $(this).val($(this).val().replace(/[^0-9\.]/g, ''));
                if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                    /* if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {*/
                    /*  $("#v-AllowedMilagePerKM").html("Number Only").stop().show().fadeOut("slow");*/
                    ValidationTooltip("#v-DAAmount", "Number Only!");
                    return false;
                }
            });
        });

            $('input:radio[name=rbWise]').change(function () {

                $("UserRoleSelect").prop("disabled", false);
                $("#GroupSelect").prop("disabled", false);
                $("#ZoneSelect").prop("disabled", false);
                $("#AreaSelect").prop("disabled", false);
                $("#TeritorySelect").prop("disabled", false);
                $("#MarketSelect").prop("disabled", false);

                if (this.value == 'RoleWise') {
                    $("#UserRoleSelect").prop("disabled", false);
                    $("#GroupSelect").prop("disabled", true);
                    $("#ZoneSelect").prop("disabled", true);
                    $("#AreaSelect").prop("disabled", true);
                    $("#TeritorySelect").prop("disabled", true);
                    $("#MarketSelect").prop("disabled", true);

                }
                else if (this.value == 'MarketWise') {
                    $("#UserRoleSelect").prop("disabled", true);


                }

                else if (this.value == 'Both') {
                    $("#UserRoleSelect").prop("disabled", false);
                    $("#GroupSelect").prop("disabled", false);
                    $("#ZoneSelect").prop("disabled", false);
                    $("#AreaSelect").prop("disabled", false);
                    $("#TeritorySelect").prop("disabled", false);
                    $("#MarketSelect").prop("disabled", false);


                }



            });



        function IsActiveChange() {
            var isActive = $('#customSwitch1').is(':checked');
            $('#acttxt').text("");
            if (isActive) {
                $('#acttxt').text("Active");

            } else {
                $('#acttxt').text("Inactive");
            }
        }
    function GetTourType(id) {
        var urlpath = 'Setup.aspx/Get_TADAMarketRuleConfiguration_For_ddl';
        SelectOption_DtTable_Async_True(urlpath, $('#TourTypeSelect'), 'TourTypeId', 'TourTypeName', id);
        $('#TourTypeSelect').select2();
        }


        function GetUserRoleInfo(id) {
            var urlpath = 'Setup.aspx/Get_UserTypeInfo';
            SelectOption_DtTable_Async_True(urlpath, $('#UserRoleSelect'), 'RoleTypeId', 'RoleType', id);
           $('#UserRoleSelect').select2();
    }



        //Market Info

        function GetGroupInfo(id) {
            _GetGroupInfo_Active($('#GroupSelect'), 'GroupId', 'GroupName', id);
    }


        $("#GroupSelect").on("change", function (e) {
            var GroupId = $("#GroupSelect").val();
            if (GroupId > 0) {
                GetZone(GroupId);

            }
            else {
                GetZone(0);
            }
        });

        function GetZone(id, SetId) {

            //   _getZone_ByGroupId_Active($('#upperSelect'), 'RegionId', 'RegionName', id);

            _getZone_ByGroupId_Active_SetValue($('#ZoneSelect'), 'RegionId', 'RegionName', id, SetId)
        }

        function GetZoneAll(id, GroupId) {
            _Zone_ActiveAll($('#ZoneSelect'), 'ZoneId', 'ZoneName', id, GroupId);
        }


        $("#ZoneSelect").on("change", function (e) {
            var zoneId = $("#ZoneSelect").val();
            if (zoneId > 0) {
                GetArea_ByZone(zoneId);

            }
        });

        $("#AreaSelect").on("change", function (e) {
            debugger;
            var id = $("#AreaSelect").val();
            if (id > 0) {
                GetTerritory_ByAreaId(id);

            }
        });

        $("#TeritorySelect").on("change", function (e) {
            debugger;
            var id = $("#TeritorySelect").val();
            if (id > 0) {
                GetMarket_ByTerritoryId(id);

            }
        });



        function GetArea_ByZone(id) {
            _getArea_ByZoneId_Active($('#AreaSelect'), 'AreaId', 'AreaName', id);
        }

        function GetTerritory_ByAreaId(id) {
            _getTerritory_ByAreaId_Active($('#TeritorySelect'), 'TerritoryId', 'TerritoryName', id);
        }

        function GetMarket_ByTerritoryId(id) {
            _getMarket_ByTerritoryId_Active($('#MarketSelect'), 'MarketId', 'MarketName', id);
        }
    function Validation() {
        var isValid = true;
            if ($('#TourTypeSelect').val() == 0) isValid = false;
            //if ($('#TAAmount').val() == "") isValid = false;
            if ($('#DAAmount').val() == "") isValid = false;

        if (isValid == false) {
            alert("Please enter mandatory data");
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

        var jsonData = {};
            jsonData["TADAMarketRuleConfigId"] = $('#masterId').val();
            jsonData["TourType"] = $('#TourTypeSelect :Selected').val();

            jsonData["IsRoleWise"] = false;
            jsonData["IsMarketWise"] = false;
            jsonData["IsBoth"] = false;


            jsonData["UserRoleID"] = null;
            jsonData["GroupId"] = null;
            jsonData["ZoneId"] = null;
            jsonData["AreaId"] = null;
            jsonData["TerritoryId"] = null;
            jsonData["MarketId"] = null;

            var radioValue = $("input[name='rbWise']:checked").val();


            if (radioValue == 'RoleWise') {

                jsonData["IsRoleWise"] = true;
                jsonData["UserRoleID"] = $('#UserRoleSelect :Selected').val();


            }
            else if (radioValue == 'MarketWise') {
                jsonData["IsMarketWise"] = true;
                jsonData["GroupId"] = $('#GroupSelect :Selected').val();
                jsonData["ZoneId"] = $('#ZoneSelect :Selected').val();
                jsonData["AreaId"] = $('#AreaSelect :Selected').val();
                jsonData["TerritoryId"] = $('#TeritorySelect :Selected').val();
                jsonData["MarketId"] = $('#MarketSelect :Selected').val();



            }

            else if (radioValue == 'Both') {
                jsonData["IsBoth"] = true;
                jsonData["UserRoleID"] = $('#UserRoleSelect :Selected').val();
                jsonData["GroupId"] = $('#GroupSelect :Selected').val();
                jsonData["ZoneId"] = $('#ZoneSelect :Selected').val();
                jsonData["AreaId"] = $('#AreaSelect :Selected').val();
                jsonData["TerritoryId"] = $('#TeritorySelect :Selected').val();
                jsonData["MarketId"] = $('#MarketSelect :Selected').val();


            }


            jsonData["TAAmount"] = $('#TAAmount').val();
            jsonData["DAAmount"] = $('#DAAmount').val();
            jsonData["IsActive"] = $('#customSwitch1').is(':checked');


            var urlpath = 'Setup.aspx/Save_TADAMarketRuleConfiguration';
            $.ajax({
                //data: jsonData,
                url: urlpath,
                type: "POST",
                data: JSON.stringify({ 'tADAMarketrule': jsonData }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                beforeSend: function () {
                    //_open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {

                    result = result.d;
                    if (result.isSuccess == true) {

                        successalert('Operation successful!', 'Success', 'TADAMarketRuleConfigurationView.aspx');
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

                    //_saveError();
                },

            });
        }

        function GetGroupAllInfo(id) {
            _GetGroupInfo_All($('#GroupSelect'), 'GroupId', 'GroupName', id);
        }

        function GetZone_All(id, SetId) {

            //   _getZone_ByGroupId_Active($('#upperSelect'), 'RegionId', 'RegionName', id);

            _getZone_ByGroupId_All_SetValue($('#ZoneSelect'), 'RegionId', 'RegionName', id, SetId)
        }

        function GetArea_All_ByZone(id, SetId) {
            _getArea_ByZoneId_All($('#AreaSelect'), 'AreaId', 'AreaName', id, SetId);
        }
        function GetTerritory_ByAreaId_All(id, SetId) {
            _getTerritory_ByAreaId_All($('#TeritorySelect'), 'TerritoryId', 'TerritoryName', id, SetId);
        }

        function GetMarket_ByTerritoryId_All(id, SetId) {
            _getMarket_ByTerritoryId_All($('#MarketSelect'), 'MarketId', 'MarketName', id, SetId);
        }

    function GetData(id) {
        var urlpath = 'Setup.aspx/GetTADAMarketRuleConfigurationDataById';
            $.ajax({
                url: urlpath,
                type: "POST",
                data: JSON.stringify({ 'id': id }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                //data: {id : id},
                
                async: true,
                success: function (data) {
                    data = data.d;
                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");
                    GetTourType(data.TourType);
                    $('#TAAmount').val(data.TAAmount);
                    $('#DAAmount').val(data.DAAmount);

                    $("UserRoleSelect").prop("disabled", false);
                    $("#GroupSelect").prop("disabled", false);
                    $("#ZoneSelect").prop("disabled", false);
                    $("#AreaSelect").prop("disabled", false);
                    $("#TeritorySelect").prop("disabled", false);
                    $("#MarketSelect").prop("disabled", false);
                  
                    if (data.IsRoleWise == true) {

                        $("#UserRoleSelect").prop("disabled", false);
                        $("#GroupSelect").prop("disabled", true);
                        $("#ZoneSelect").prop("disabled", true);
                        $("#AreaSelect").prop("disabled", true);
                        $("#TeritorySelect").prop("disabled", true);
                        $("#MarketSelect").prop("disabled", true);
                        $('#RoleWise').prop('checked', true);
                        GetUserRoleInfo(data.UserRoleID);
                     

                    }

                    if (data.IsMarketWise == true) {

                        $("#UserRoleSelect").prop("disabled", true);
                        $('#MarketWise').prop('checked', true);


                      
                        GetGroupAllInfo(data.GroupId);
                        GetZone_All(data.GroupId, data.RegionId);
                        GetArea_All_ByZone(data.RegionId, data.AreaId);

                        GetTerritory_ByAreaId_All(data.TerritoryId, data.RegionId);

                        GetMarket_ByTerritoryId_All(data.MarketId, data.TerritoryId)

                        



                    }

                    if (data.IsBoth == true) {
                        $("#UserRoleSelect").prop("disabled", false);
                        $("#GroupSelect").prop("disabled", false);
                        $("#ZoneSelect").prop("disabled", false);
                        $("#AreaSelect").prop("disabled", false);
                        $("#TeritorySelect").prop("disabled", false);
                        $("#MarketSelect").prop("disabled", false);
                        $('#Both').prop('checked', true);
                     

                        GetUserRoleInfo(data.UserRoleID);
                        GetGroupAllInfo(data.GroupId);
                        
                        GetZone_All(data.GroupId, data.ZoneId);
                        GetArea_All_ByZone(data.ZoneId, data.AreaId);

                        GetTerritory_ByAreaId_All(data.AreaId, data.TerritoryId);

                        GetMarket_ByTerritoryId_All(data.MarketId, data.TerritoryId)
                    }

                    $("#MarketWise").prop("disabled", true);
                    $("#RoleWise").prop("disabled", true);
                    $("#Both").prop("disabled", true);

                    if (data.IsActive) {
                        $('#customSwitch1').prop('checked',true);
                    } else {
                        $('#customSwitch1').prop('checked', false);
                    }


                },
                complete: function() {
                }
            });
        }

    </script>
}






</asp:Content>

