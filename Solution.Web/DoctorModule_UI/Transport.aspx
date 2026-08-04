<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="Transport.aspx.cs" Inherits="DoctorModule_UI_Transport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


   
<div id="popDiv">

</div>

    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Transport Information</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/TransportView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                    <label for="mainName" class="col-sm-4 col-form-label">Name:  </label>

                                    <div class="col-sm-7">

                                           <div class="input-group">
                                        <input type="text" class="form-control form-control-sm " required id="mainName" placeholder="Name">

                                        <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                                 <span class="input-group-text text-c-red">*</span>
                                               </div>
                                    </div>
                                    
                                </div>


                                <div class="form-group row">
                                    <label for="AllowedMilagePerKM" class="col-sm-4 col-form-label">Allowance Per Mileage(KM):  </label>

                                    <div class="col-sm-7">

                                           <div class="input-group">
                                        <input type="text" class="form-control form-control-sm " required id="AllowedMilagePerKM" placeholder="Allowance Per Mileage(KM)">

                                        <span id="v-AllowedMilagePerKM" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                                 <span class="input-group-text text-c-red">*</span>
                                               </div>

                                    </div>
                                    
                                </div>



                                <div class="form-group row">
                                    <label for="AllowedMilagePerKM" class="col-sm-4 col-form-label">Active Status:  </label>

                                    <div class="col-sm-7"  >
                                         
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="customSwitch1" checked   onchange="IsActiveChange()">
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

 
    <script>
        function ResetLink() {
            location.reload();
        }

    $(function () {

        var masterid = getUrlVars()["id"];
        if (masterid) {
            $("#masterId").val(getUrlVars()["id"]);
            GetData(masterid);
        }
        else {
            
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
                $('#acttxt').text("Active");

            } else {
                $('#acttxt').text("Inactive");
            }
        }


        $(function () {
            $("#AllowedMilagePerKM").keypress(function (event) {

                $(this).val($(this).val().replace(/[^0-9\.]/g, ''));
                if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
               /* if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {*/
                  /*  $("#v-AllowedMilagePerKM").html("Number Only").stop().show().fadeOut("slow");*/
                    ValidationTooltip("#v-AllowedMilagePerKM", "Number Only!");
                    return false;
                }
            });
        });
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
            var isValid = true;


            $('#mainName').removeClass('is-invalid');
            $('#AllowedMilagePerKM').removeClass('is-invalid');
            $('#acDate').removeClass('is-invalid');
            RemoveValidationTooltip("#v-mainName");
            RemoveValidationTooltip("#v-AllowedMilagePerKM");
            RemoveValidationTooltip("#v-acDate");
            isValid = true;
            if ($('#mainName').val() == "") {


                $('#mainName').addClass("is-invalid");
                ValidationTooltip("#v-mainName", "Please fill out of this field!");
                isValid = false;
            }
            if ($('#AllowedMilagePerKM').val() == "") {


                $('#AllowedMilagePerKM').addClass("is-invalid");
                ValidationTooltip("#v-AllowedMilagePerKM", "Please fill out of this field!");
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
        jsonData["TransportId"] = $('#masterId').val();
            jsonData["AllowedMilagePerKM"] = $('#AllowedMilagePerKM').val();
        jsonData["TransportName"] = $('#mainName').val();
        jsonData["IsActive"] = $('#customSwitch1').is(':checked');
        jsonData["Activedate"] = $('#acDate').val();

            var urlpath = 'Transport.aspx/Save_Transport';
            $.ajax({
                data: JSON.stringify({ 'Transport': jsonData }),


                url: urlpath,
                type: "POST", contentType: "application/json; charset=utf-8",
                beforeSend: function () {
                    _open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    result = result.d;

                    if (result.isSuccess == true) {

                        successalert('Operation successful!', 'Success', 'TransportView.aspx');
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

    function GetData(id) {
        var urlpath = 'Transport.aspx/GetTransportEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;
                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");
                    $('#mainName').val(data.TransportName);
                    $('#AllowedMilagePerKM').val(data.AllowedMilagePerKM);
                  //  $('#acDate').val(ToJavaScriptDate_Formater(data.Activedate));
                    
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
 




</asp:Content>

