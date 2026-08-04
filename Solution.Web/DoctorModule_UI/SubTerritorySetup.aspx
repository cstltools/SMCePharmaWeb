<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SubTerritorySetup.aspx.cs" Inherits="DoctorModule_UI_SubTerritorySetup" %>
<%@ Register Src="~/MasterSetup_UI/IVMarketStructureMarketForSubTeriSetup.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Sub-Territory Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/SubTerritoryRecords.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                              <br />
                         <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                         <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
 <asp:HiddenField runat="server" ID="id_mastetID"/>

                            <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                     <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
                                       <script type="text/javascript">
                                           function pageLoad() {
                                               $('.datepicker').pickadate({
                                                   selectMonths: true,
                                                   selectYears: true
                                               })
                                               $('.mySelect2').select2({
                                                   theme: 'bootstrap4',
                                                   width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                   placeholder: $(this).data('placeholder'),
                                                   allowClear: Boolean($(this).data('allow-clear')),
                                               });
                                           }

                                           var dateNow = new Date();
                                           $('.datepickess').datepicker("setDate", dateNow);
                                           minDate: new Date() // to disable privious dates 
                                       </script>
                                </div>
                            </div>
                        <div class="row mt-1">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-7">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">Sub-Territory Name </label>
                                    <div class="col-sm-8">
                                          <div class="input-group">
                                        <asp:TextBox   runat="server"   class="form-control form-control-sm" id="mainName" autocomplete="off" placeholder="Enter Sub-Territory Name"></asp:TextBox>
                                        <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                 <span class="input-group-text text-c-red">*</span>
                                    </div>
                                    </div>
                                   
                                </div>

                            </div>

                              <div class="col-2" runat="server" id="divShowHide" visible="false">
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

                

                      <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                       <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label><br />
                                        <div class="col-sm-8">
                                            <div class="form-check form-switch">
                                               	<input class="form-check-input" type="checkbox" runat="server" onchange="IsActiveChange()" id="chkIsActive" checked>
												 <label  class="custom-control-label" for="chkIsActive">Active</label>
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
                                        <div class="col-sm-8">
                                            <div class="input-group">
                                                <asp:TextBox   runat="server"   id="acDate"  class="datepicker form-control form-control-sm mb-3" autocomplete="off" placeholder="Select Date"></asp:TextBox>
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
                                <div class="col-2">&nbsp;</div>
                            </div>

                                         </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            
 

<%--<input id="masterId" value="0" style="display:none" />


    <script>

        function ConfirmationClick() {
            window.location.href = "SubTerritoryRecords.aspx";
        }
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
                $("#divShowHide").hide();

                GetGroup(0);
                // GetZone(0);
              //  GetThana(0);
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


            $("#areaSelect").on("change", function (e) {
                debugger;
                var id = $("#areaSelect").val();
                if (id > 0) {
                    GetTerritory_ByAreaId(id);

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

        function GetTerritory_ByAreaId(id) {
            _getTerritory_ByAreaId_Active($('#territorySelect'), 'TerritoryId', 'TerritoryName', id);
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
            //$('#multiSelectId').removeClass('is-invalid');
            $('#acDate').removeClass('is-invalid');

            RemoveValidationTooltip("#v-GroupNameSelect");

            RemoveValidationTooltip("#v-zoneSelect");

            RemoveValidationTooltip("#v-areaSelect");
            RemoveValidationTooltip("#v-territorySelect");

            RemoveValidationTooltip("#v-mainName");

            //RemoveValidationTooltip("#v-multiSelectId");

            RemoveValidationTooltip("#v-acDate");

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


            if ($('#territorySelect').val() == 0 || $('#territorySelect').val() == null || $('#territorySelect').val() == "") {

                $('#territorySelect').addClass("is-invalid");
                ValidationTooltip("#v-territorySelect", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#mainName').val() == "") {

                $('#mainName').addClass("is-invalid");
                ValidationTooltip("#v-mainName", "Please fill out of this field!");
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


        //var dv = $('#multiSelectId').val();
        //var multiId = dv.toString();

        var jsonData = {};
        jsonData["SubTerritoryId"] = $('#masterId').val();
       /* jsonData["AreaId"] = $('#areaSelect').val();*/
        jsonData["TerritoryId"] = $('#territorySelect').val();
        jsonData["SubTerritoryName"] = $('#mainName').val();
        //jsonData["ThanaId"] = multiId;
        jsonData["IsActive"] = $('#customSwitch1').is(':checked');
        jsonData["AcOrInAcDate"] = $('#acDate').val();
      //  jsonData["Remarks"] = $('#remarksTxt').val();



        var urlpath = 'Setup.aspx/SaveSubTerritory';
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

                        successalert('Operation successful!', 'Success', 'SubTerritoryRecords.aspx');
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
        function GetTerritory_ByAreaId_All(id, SetId) {
            _getTerritory_ByAreaId_All($('#territorySelect'), 'TerritoryId', 'TerritoryName', id, SetId);
        }

    function GetData(id) {
        var urlpath = 'Setup.aspx/GetSubTerrritoryEditData';
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
                    GetTerritory_ByAreaId_All(data.AreaId, data.TerritoryId);
                    $('#mainName').val(data.SubTerritoryName);
                    $('#acDate').val(ToJavaScriptDate_Formater(data.AcOrInAcDate));
                    $('#remarksTxt').val(data.Remarks);


                     //   $("#GroupNameSelect").prop("disabled", true);
                     //   $("#zoneSelect").prop("disabled", true);
                     //   $("#areaSelect").prop("disabled", true);
                     //   $("#territorySelect").prop("disabled", true);
                    if (data.IsActive) {
                        $('#customSwitch1').prop('checked',true);
                    } else {
                        $('#customSwitch1').prop('checked', false);
                    }

                 //   GetDivision(data.ThanaId);

                   // GetThanan_ET(data.ThanaId, id);
                  //  GetThana_ET(data.ThanaId);

                },
                complete: function() {

                }
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

        function GetTerritory_ByAreaId_All(id, SetId) {
            _getTerritory_ByAreaId_All($('#territorySelect'), 'TerritoryId', 'TerritoryName', id, SetId);
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
                    //$('#multiSelectId').select2();
                }
            });
    }






    </script>--%>


</asp:Content>

