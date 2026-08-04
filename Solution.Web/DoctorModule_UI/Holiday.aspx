<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="Holiday.aspx.cs" Inherits="DoctorModule_UI_Holiday" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    
<div id="popDiv">

</div>

    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Holiday Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">

                        <a href="HolidayView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>

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

                                <div class="form-group row" runat="server" visible="false">
                                    <label for="FinancialSelect" class="col-sm-3 col-form-label">Financial Year  </label>

                                    <div class="col-sm-5">

                                        <select id="FinancialSelect" name="FinancialSelect" class="form-select form-select-sm mb-3 mySelect2" required="true" >
                                        </select>

                                        <span id="v-FinancialSelect" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>

                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>
                               
                                    <div class="form-group row">
                                    <label for="Days" class="col-sm-3 col-form-label"> Holiday Name </label>
                                    <div class="col-sm-5">
                                        <input type="text" class="form-control form-control-sm mb-3" required="true" id="txtHoliday" placeholder="Holiday Name">

                                        <span id="v-txtHoliday" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>

                                </div>
                                <div class="form-group row">
                                    <label for="Days" class="col-sm-3 col-form-label"> From Date </label>
                                    <div class="col-sm-5">

                                        <input id="txtDate" type="text" class="datepicker form-control form-control-sm" autocomplete="off" placeholder="Select date" data-date-autoclose="true" >

                                        <span id="v-txtDate" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>

                                </div>

                               
                                   <div class="form-group row">
                                    <label for="Days" class="col-sm-3 col-form-label"> To Date </label>
                                    <div class="col-sm-5">

                                        <input id="txtToDate" type="text" class="datepicker form-control form-control-sm" autocomplete="off" placeholder="Select date" data-date-autoclose="true" >

                                        <span id="v-txtToDate" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>

                                </div>

                            

                                 <div class="form-group row" runat="server" visible="false">
                                   <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label><br />
                                        <div class="col-sm-7">
                                            <div  class="form-check form-switch">
                                                <input type="checkbox" class="form-check-input" id="customSwitch1" checked onchange="IsActiveChange()">
                                               <label  class="custom-control-label" for="customSwitch1">Active</label>
                                            </div>
                                        </div>
                                    </div>
                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                        
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">
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
        function ResetLink() {
            location.reload();
        }
        $('.datepicker').pickadate({
            selectMonths: true,
            selectYears: true
        })
        $(function () {
            var masterid = getUrlVars()["id"];
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);
                GetData(masterid);
            }
            else {
                GetZone(0);
            }

        
 


    });

       
        function GetZone(id) {

            var urlpath = 'Holiday.aspx/GetFinanCialyear';
            SelectOption_DtTable_Async_false(urlpath, $('#FinancialSelect'), 'FiscalYearId', 'FiscalYearDesc', id);
            $('#FinancialSelect').select2();
    }


         function ResetClick() {
             location.href = '../DoctorModule_UI/Holiday.aspx';

        }

    function IsActiveChange() {
        var isActive = $('#customSwitch1').is(':checked');
        $('#acttxt').text("");
        if (isActive) {
            $('#acttxt').text("Active Date:");

        } else {
            $('#acttxt').text("Inactive  Date:");
        }
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



            $('#FinancialSelect').removeClass('is-invalid');
            $('#txtDate').removeClass('is-invalid');
            $('#txtHoliday').removeClass('is-invalid');
            RemoveValidationTooltip("#v-FinancialSelect");
            RemoveValidationTooltip("#v-txtDate");
            RemoveValidationTooltip("#v-txtHoliday");

             isValid = true;
            //if ($('#FinancialSelect').val() == 0) {

            //    $('#FinancialSelect').addClass("is-invalid");
            //    ValidationTooltip("#v-FinancialSelect", "Please fill out of this field!");
            //    isValid = false;
            //}

            if ($('#txtHoliday').val() == "") {

                $('#txtHoliday').addClass("is-invalid");
                ValidationTooltip("#v-txtHoliday", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#txtDate').val() == "") {

                $('#txtDate').addClass("is-invalid");
                ValidationTooltip("#v-txtDate", "Please fill out of this field!");
                isValid = false;
            }


            if ($('#txtToDate').val() == "") {

                $('#txtToDate').addClass("is-invalid");
                ValidationTooltip("#v-txtToDate", "Please fill out of this field!");
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

            jsonData["HolidayId"] = $('#masterId').val();
            jsonData["FiscalYear"] = 0;
            jsonData["HolidayDate"] = $.trim($('#txtDate').val());
            jsonData["HolidayToDate"] = $.trim($('#txtToDate').val());
            jsonData["DayName"] = $.trim($('#txtHoliday').val());
            jsonData["IsActive"] = $('#customSwitch1').is(':checked');


            var urlpath = 'Holiday.aspx/Save_Holiday';
            $.ajax({
                data: JSON.stringify({ 'holiday': jsonData }),
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

                        successalert('Operation successful!', 'Success', 'HolidayView.aspx');
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

            var urlpath = 'Holiday.aspx/GetHoliEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;

                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");

                     GetZone(data.FiscalYear);

                    $('#txtDate').val(ToJavaScriptDate_Formater(data.HolidayDate));
                    $('#txtToDate').val(ToJavaScriptDate_Formater(data.HolidayToDate));
                    $('#txtHoliday').val(data.DayName);
            
                    if (data.IsActive) {
                        $('#customSwitch1').prop('checked', true);

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

