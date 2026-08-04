<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DZSMSetup.aspx.cs" Inherits="DoctorModule_UI_DZSMSetup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>DZSM Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/DZSMRecords.aspx"  id="btnBTL" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                        <label for="DoctorName" class="col-sm-3 col-form-label">Group </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <select class="form-select form-select-sm mb-3 mySelect2" id="ddlGroup"></select>
                                                <span id="v-ddlGroup" class="invalid-tooltip fade hide" data-delay="2000"></span>
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
                                                <span id="v-zoneSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
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
                                                <label class="custom-control-label" for="isVacent"> Is Vacant </label>
                                             
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>--%>

                            <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="areaSelect" class="col-sm-3 col-form-label">DZSM Name </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <select id="ddlEmployee" name="ddlEmployee" class="form-select form-select-sm mb-3 mySelect2"></select>
                                                <span id="v-areaSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
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
                                    <label for="customSwitch1" class="col-sm-3 col-form-label"> &nbsp; </label>
                                    <div class="col-sm-7">
                                        <div class="custom-control custom-switch mt-2">
                                            <input type="checkbox" class="custom-control-input" id="customSwitch1" checked onchange="IsActiveChange()">
                                            <label class="custom-control-label" for="customSwitch1"> Is Active</label>
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
                                            <button type="button" class="btn btnMyDesignReset   btn-sm" onclick="ConfirmationClick()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </button>


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

  <script >
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

      function GetGroupInfo(id) {
          _GetGroupInfo_Active($('#ddlGroup'), 'GroupId', 'GroupName', id);
      }
      $(document).ready(function () {


          var masterid = getUrlVars()["id"];
          var EMPMID = getUrlVars()["EMPMID"];
          if (masterid) {
              $("#masterId").val(getUrlVars()["id"]);
              GetData(masterid);
          }

          else if (EMPMID) {
              $("#hfEMPMID").val(getUrlVars()["EMPMID"]);
              GetDZSMMAsterData(EMPMID);
              btnBTL.href = "../MasterSetup_UI/EmployeeRecords.aspx";
              //  GetData($('#masterId').val());

          }
          else {
              GetGroupInfo(0);
              GetEmployee(0);
          }


          $('.datepicker').pickadate({
              selectMonths: true,
              selectYears: true
          })
          

         
          //$('#acDate').datepicker();

          $("#ddlGroup").on("change", function (e) {

              var groupId = $("#ddlGroup").val();

              if (groupId > 0) {
                  GetZone_ByGroup(groupId);

              }
          });

      });
      function GetZone_ByGroup(id) {

          _getZone_ByGroupId_Active($('#zoneSelect'), 'RegionId', 'RegionName', id);
      }
     

      function IsVacantChange() {

          var isActive = $('#isVacent').is(':checked');

          if (isActive) {

              $('#ddlEmployee').val(1).change();
          }
          else {
              $('#ddlEmployee').val(0).change();
          }
      }


      function GetGroupAllInfo(id) {
          _GetGroupInfo_All($('#ddlGroup'), 'GroupId', 'GroupName', id);
      }

      function GetZone_All(id, SetId) {



          _getZone_ByGroupId_All_SetValue($('#zoneSelect'), 'RegionId', 'RegionName', id, SetId)
      }


      function GetDZSMMAsterData(id) {

          var urlpath = 'FieldForce.aspx/GeDZSMSetupEditDataByEMPID';
          $.ajax({
              url: urlpath,
              dataType: 'json',
              data: JSON.stringify({ 'id': id }),
              type: "POST", contentType: "application/json; charset=utf-8",
              async: true,
              success: function (data) {
                  data = data.d;

                  $("#masterId").val(data.RSMId);
                  GetData(data.RSMId);
              },
              complete: function () {
              }
          });
      }

      function GetData(id) {

          var urlpath = 'FieldForce.aspx/GeDZSMSetupEditData';
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
                  GetZone_All(data.GroupId, data.RegionId);

                  $("#ddlGroup").prop("disabled", true);
                  $("#zoneSelect").prop("disabled", true);
                  GetDZSMEmployee_All(id, data.EmployeeId);

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

      function GetDZSMEmployee_All(id, SetId) {



          _getDZSMSMEmployee_All($('#ddlEmployee'), 'EmpInfoId', 'EmployeeName', id, SetId)
      }

      function GetGroup(id) {
          var urlpath = 'SeedData.aspx/GetGroupList';
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


                      if ($("#hfEMPMID").val() == "0") {
                          successalert('Operation successful!', 'Success', 'DZSMRecords.aspx');

                      }
                      else {
                          successalert('Operation successful!', 'Success', '../MasterSetup_UI/EmployeeRecords.aspx');

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




