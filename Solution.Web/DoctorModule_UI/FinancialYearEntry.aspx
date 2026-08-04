<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="FinancialYearEntry.aspx.cs" Inherits="DoctorModule_UI_FinancialYearEntry" %>

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
     <div id="popDiv">

</div>
    
     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Financial Year Entry</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="FinancialYearView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
 
                        <br />
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row" style="display:none">
                                    <label for="DoctorName" class="col-sm-3 col-form-label">Financial Year: </label>

                                    <div class="col-sm-7">
                                        <input type="text" class="form-select form-select-sm mb-3 mySelect2 " required id="FinancialYear" placeholder="Financial Year">

                                        <span id="v-FinancialYear" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>

                                </div>

                            </div>
                        </div>

                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="FromDate" class="col-sm-3 col-form-label">From Date: </label>

                                    <div class="col-sm-7">
                                        <input type="date" class="form-control form-control-sm mb-3 datepicker" required id="FromDate" placeholder="From Date">

                                        <span id="v-FromDate" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>

                                </div>

                            </div>
                        </div>

                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="DoctorName" class="col-sm-3 col-form-label">To Date: </label>
                                    <div class="col-sm-7">
                                        <input type="date" class="form-control form-control-sm mb-3 datepicker" required id="ToDate" placeholder="To Date">

                                        <span id="v-ToDate" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="DoctorName" class="col-sm-3 col-form-label"> &nbsp; </label>

                                    <div class="col-sm-7">
                                        <div class="custom-control custom-switch mt-3">
                                            <input type="checkbox" class="custom-control-input" id="customSwitch1" checked onchange="IsActiveChange()">
                                            <label class="custom-control-label" id="acttxt" for="customSwitch1"> Active</label>
                                        </div>

                                        <span id="v-DoctorName" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


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
        }


        let id = $('#masterId').val();

        if (id > 0) {
            GetData(id);
        } else {

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

                function ResetClick() {
                    location.href = '../DoctorModule_UI/FinancialYearEntry.aspx';

        }
        function GetCompanyList(SetId) {
            _getCompanyList_Active($('#ddlCompany'), 'EmpInfoId', 'EmpName', SetId);
        }

    function IsActiveChange() {
        var isActive = $('#customSwitch1').is(':checked');

        if (isActive) {
            $('#acttxt').text("Active");

        } else {
            $('#acttxt').text("Inactive");
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

           // $('#FinancialYear').removeClass('is-invalid');
            $('#FromDate').removeClass('is-invalid');
            $('#ToDate').removeClass('is-invalid');

         //   RemoveValidationTooltip("#v-mainName");
            RemoveValidationTooltip("#v-Days");
            RemoveValidationTooltip("#v-Days");

             isValid = true;
            //if ($('#FinancialYear').val() == "") {

            //    $('#FinancialYear').addClass("is-invalid");
            //    ValidationTooltip("#v-FinancialYear", "Please fill out of this field!");
            //    isValid = false;
            //}

            if ($('#FromDate').val() == "") {

                $('#FromDate').addClass("is-invalid");
                ValidationTooltip("#v-FromDate", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#ToDate').val() == "") {

                $('#ToDate').addClass("is-invalid");
                ValidationTooltip("#v-ToDate", "Please fill out of this field!");
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



        var jsonData = {};
            jsonData["FiscalYearId"] = $('#masterId').val();
           // jsonData["FiscalYearDesc"] = $.trim($('#FinancialYear').val());
            jsonData["YearFromDate"] = $.trim($('#FromDate').val());
            jsonData["YearTodate"] = $.trim($('#ToDate').val());
            jsonData["IsActive"] = $('#customSwitch1').is(':checked');


            var urlpath = 'FinancialYearEntry.aspx/Save_FinancialYearInfo';
            $.ajax({
                //data: jsonData,
                data: JSON.stringify({ 'department': jsonData }),
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

                        successalert('Operation successful!', 'Success', 'FinancialYearView.aspx');
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

            var urlpath = 'FinancialYearEntry.aspx/GetFinancialYeaEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;
                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update ");
                    $('#FinancialYear').val(data.FiscalYearDesc);

                    

                    $('#FromDate').val(data.YearFromDateStr);

                    $('#ToDate').val(data.YearTodateStr);
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

