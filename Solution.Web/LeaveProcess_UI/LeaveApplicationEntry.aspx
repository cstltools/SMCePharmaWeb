<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="LeaveApplicationEntry.aspx.cs" Inherits="LeaveProcess_UI_LeaveApplicationEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Leave Application Entry</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="LeaveApplications.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
     
                        <div class="card-group">
                            <div class="card" style="border-right: 1px solid #3C8BCA">

                                <div class="card-body" style="height: 300px !important;">
                                    <h3 class="card-title text-success" style="text-transform: capitalize !important; font-size: 1.2em !important;">
                                        Employee Basic Info
                                        <hr />
                                    </h3>
                                    <p class="card-text">
                                        <div class="row mb-1">
                                            <div class="col-12">
                                                <div class="form-group row">
                                                    <label for="exampleInputUsername2" class="col-sm-4 col-form-label">Employee Code: <span class="text-c-red">[ * ]</span> </label>
                                                    <div class="col-sm-7">
                                                        <input type="text" class="form-control" id="employeeCode" onchange="SearchByEmployeeCode()" placeholder="Search by Employee Code">
                                                        <input type="text" id="empInfoId" hidden />
                                                        <span id="v-employeeCode" class="invalid-tooltip fade hide" data-delay="1000"></span>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>

                                        <div class="row mb-1">
                                            <div class="col-12">
                                                <div class="form-group row">
                                                    <label for="exampleInputUsername2" class="col-sm-4 col-form-label">Employee Name: </label>
                                                    <div class="col-sm-7">
                                                        <input type="text" class="form-control " disabled id="employeeName" placeholder="Name of the Employee">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <br />

                                        <h5 class="card-title text-success" style="text-transform: capitalize !important; font-size: 1.2em !important;">
                                            Employee Leave Balance
                                            <hr />
                                        </h5>

                                        <div class="row mb-1">
                                            <div class="col-12">
                                                <table width="94%" id="custom_table">
                                                    <thead>
                                                        <tr>
                                                            <th style="text-align: center !important;"> Leave Type </th>
                                                            <th style="text-align: center !important;"> Yearly Leave </th>
                                                            <th style="text-align: center !important;"> Leave Balance </th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="leaveBalance">
                                                        
                                                    </tbody>
                                                   

                                                 
                                                </table>
                                            </div>
                                        </div>
                                    </p>
                                </div>
                            </div>
                            <div class="card">

                                <div class="card-body">
                                    <h5 class="card-title text-success" style="text-transform: capitalize !important; font-size: 1.2em !important;">
                                        Leave Application Info
                                        <hr />
                                    </h5>
                                    <p class="card-text">

                                        <div class="row">
                                            <div class="col-12">
                                                <div class="form-group row">
                                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label">Leave Type: <span class="text-c-red">[ * ]</span></label>
                                                    <div class="col-sm-8">
                                                        <select id="ddlLeaveType" class="form-control form-control-sm"></select>
                                                        <span id="v-ddlLeaveType" class="invalid-tooltip fade hide" data-delay="1000"></span>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>

                                        <div class="row">
                                            <div class="col-12">
                                                <div class="form-group row">
                                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label">No of Days:<span class="text-c-red">[ * ]</span> </label>
                                                    <div class="col-sm-8">
                                                        <input type="number" id="dayQuantity" class="form-control form-control-sm clsDecimal" />
                                                        <span id="v-dayQuantity" class="invalid-tooltip fade hide" data-delay="1000"></span>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>

                                        <div class="row">
                                            <div class="col-12">
                                                <div class="form-group row">
                                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label">From Date:<span class="text-c-red">[ * ]</span> </label>
                                                    <div class="col-sm-8">
                                                        <input type="text" id="leaveFromDate" class="form-control form-control-sm datepicker" />
                                                        <span id="v-leaveFromDate" class="invalid-tooltip fade hide" data-delay="1000"></span>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>

                                        <div class="row">
                                            <div class="col-12">
                                                <div class="form-group row">
                                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label">To Date:<span class="text-c-red">[ * ]</span> </label>
                                                    <div class="col-sm-8">
                                                        <input type="text" id="leaveToDate" class="form-control form-control-sm datepicker" />
                                                        <span id="v-leaveToDate" class="invalid-tooltip fade hide" data-delay="1000"></span>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="form-group row">
                                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label">Reason: <span class="text-c-red">[ * ]</span></label>
                                                    <div class="col-sm-8">
                                                        <textarea id="leaveRemarks" rows="5" class="form-control"></textarea>
                                                        <span id="v-leaveRemarks" class="invalid-tooltip fade hide" data-delay="1000"></span>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>



                                    </p>

                                </div>
                            </div>

                        </div>
                        <hr />

                        <div class="row mt-3">

                            <div class="col-12 text-center">
                                <button class="btn btn-success"  type="button"  style="width: 205px !important; margin: 0 auto !important;" onclick="SaveLeaveApplication()">Submit Leave Application </button>
                            </div>

                        </div>
                        


                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
     

    <script>
        $(".clsDecimal").keypress(function (event) {

            $(this).val($(this).val().replace(/[^0-9\.]/g, ''));
            if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                /* if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {*/
                // $("#v-Days").html("Number Only").stop().show().fadeOut("slow");*/

                return false;
            }
        });
        $(function () {

            $('.datepicker').pickadate({
                selectMonths: true,
                selectYears: true
            })
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

        function FormValidation() {

            $('#ddlLeaveType').removeClass('is-invalid');
            $('#employeeCode').removeClass('is-invalid');
            $('#dayQuantity').removeClass('is-invalid');
            $('#leaveFromDate').removeClass('is-invalid');
            $('#leaveToDate').removeClass('is-invalid');
            $('#leaveRemarks').removeClass('is-invalid');
            RemoveValidationTooltip("#v-ddlLeaveType");
            RemoveValidationTooltip("#v-employeeCode");
            RemoveValidationTooltip("#v-dayQuantity");
            RemoveValidationTooltip("#v-leaveFromDate");
            RemoveValidationTooltip("#v-leaveToDate");
            RemoveValidationTooltip("#v-leaveRemarks");
            isValid = true;


            var isValid = true;

            if ($('#ddlLeaveType').val() == "") {

                debugger;
                $('#ddlLeaveType').addClass("is-invalid");
                ValidationTooltip("#v-ddlLeaveType", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#employeeCode').val() == "") {

                $('#employeeCode').addClass("is-invalid");
                ValidationTooltip("#v-employeeCode", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#dayQuantity').val() == "") {

                $('#dayQuantity').addClass("is-invalid");
                ValidationTooltip("#v-dayQuantity", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#leaveFromDate').val() == "") {

                $('#leaveFromDate').addClass("is-invalid");
                ValidationTooltip("#v-leaveFromDate", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#leaveToDate').val() == "") {

                $('#leaveToDate').addClass("is-invalid");
                ValidationTooltip("#v-leaveToDate", "Please fill out of this field!");
                isValid = false;
            }

            if ($.trim($('#leaveRemarks').val()) == "") {
                $('#leaveRemarks').addClass("is-invalid");
                ValidationTooltip("#v-leaveRemarks", "Please fill out of this field!");
                isValid = false;
            }

            return isValid;

        }

        function SaveLeaveApplication() {

            if (FormValidation()) {

                var jsonData = {};


                jsonData["LeaveBalanceId"] = $('#ddlLeaveType').val();
                jsonData["EmpId"] = $('#empInfoId').val();
                jsonData["Days"] = $('#dayQuantity').val();
                jsonData["LeaveFromDate"] = $('#leaveFromDate').val();
                jsonData["StartDate"] = $('#leaveToDate').val();
                jsonData["EndDate"] = $('#leaveToDate').val();
                jsonData["Reason"] = $('#leaveRemarks').val();

                var urlpath = 'LeaveApplicationCode.aspx/SaveLeaveApplication';

                $.ajax({


                    data: JSON.stringify({ 'leaveApplication': jsonData }),
                    url: urlpath,
                    contentType: "application/json; charset=utf-8",
                    type: "POST",
                    
                    success: function (result) {

                        result = result.d;


                        if (result.isSuccess == true) {

                            successalert('Operation successful!', 'Success', 'LeaveApplications.aspx');
                        }
                        

                        else {
                            faildalert('Operation Faild!', 'Faild');
                        }


                    },
                    error: function() {
                        faildalert('Operation Faild!', 'Faild');
                    }
                });

            }

        }

        function formatDate(date) {
            var d = new Date(date),
                month = '' + (d.getMonth() + 1),
                day = '' + d.getDate(),
                year = d.getFullYear();

            if (month.length < 2)
                month = '0' + month;
            if (day.length < 2)
                day = '0' + day;

            return [year, month, day].join('-');
        }

        function SearchByEmployeeCode() {


            if ($('#employeeCode').val() != "") {

                var employeeCode = $('#employeeCode').val();

                var urlpath = 'LeaveApplicationCode.aspx/GetEmployeeLeaveBalance';

                $.ajax({
                    url: urlpath,
                    dataType: 'json',
                    type: "POST", contentType: "application/json; charset=utf-8",
                    async: true,
                    data: JSON.stringify({ 'employeeCode': employeeCode }),
                   
                    success: function(data) {

                        var result = JSON.parse(data.d);

                        for (var i = 0; i < result.length; i++) {

                            $('#employeeCode').val(result[i].EmpMasterCode);
                            $('#employeeName').val(result[i].EmpName);
                            $('#empInfoId').val(result[i].EmpInfoId);

                        }

                        $('#ddlLeaveType').empty();
                        $('#ddlLeaveType').append("<option value='0'> Select from list </option>");

                        for (var i = 0; i < result.length; i++) {

                            $('#ddlLeaveType').append($("<option></option>").val(result[i].LeaveBalanceId).html(result[i].LeaveTypeName));
                        }

                        var html = "";
                        $('#leaveBalance').html();

                        for (var i = 0; i < result.length; i++) {

                            html += "<tr>";
                            html += "<td style='text-align: center!important; '>" + result[i].LeaveTypeName + "</td>";
                            html += "<td style='text-align: center!important; '>" + result[i].YearlyLeaveBalance + "</td>";
                            html += "<td style='text-align: center!important; '>" + result[i].LeaveBalance + "</td>";
                            html += "</tr>";
                        }
                        $('#leaveBalance').html(html);
                    }
                });
            }

        }

        function GetFinancialYear() {

            var urlpath = '@Url.Action("GetLeaveApplications", "LeaveApplication")';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "Get",
                async: true,
                beforeSend: function() {
                },
                success: function (result) {

                    $('#tabH').show();

                    var row = "";

                    //console.log(data);


                    $('#dtTableBody').html("");

                    for (var i = 0; i < result.length; i++) {

                        row += "<tr>";
                        row += "<td class='text-center'>" + (i + 1) + "</td>";
                        row += "<td>" + result[i].EmpName + "</td>";
                        row += "<td class='text-center'>" + result[i].LeaveTypeName + "</td>";
                        row += "<td class='text-center'>" + ToJavaScriptDate_Formater(result[i].LeaveFromDate) + "</td>";
                        row += "<td class='text-center'>" + ToJavaScriptDate_Formater(result[i].LeaveToDate) + "</td>";
                        row += "<td class='text-center'>" + result[i].Days + "</td>";

                        if (result[i].ApprovalStatus == 'Approved')
                        {
                            row += "<td class='text-center'> <i class='fa fa-1x fa-check-circle text-success'> Approved </i></td>";

                        }
                        else if (result[i].ApprovalStatus == 'Pending')
                        {
                            row += "<td class='text-center'> <i class='fa fa-1x fa-cog text-warning'> Pending </i></td>";

                        }
                        else {
                            row += "<td class='text-center'><i class='fa fa-1x fa-ban text-danger'> Rejected </i></td>";
                        }


                        row += "<td class='text-center'> <a data-toggle='tooltip' data-placement='top' title='View' class='btn btn-sm btn-info' href='/LeaveApplication/LeaveApplicationDetail?id = " + result[i].LeaveApplicationId + "'><i class='fa fa-eye' ></i></a> &nbsp;&nbsp; </td>";
                        row += "</tr>";

                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    $('#dtTble').dataTable({
                        "ordering": false
                    });
                }
            });
    }

        function editClick(id) {
            location.href = '@Url.Action("DoctorSetup", "Setup")?id=' + id + '';
        }

        function DeleteClick(id) {
            $.confirm({
                icon: 'fas fa-question-circle',
                title: 'Are You Sure ?',
                content: 'You are concern to delete the data!',
                theme: 'Supervan',
                type: 'green',
                buttons: {
                    Confirm: {
                        text: 'Confirm',
                        action: function () {
                            Final_DeleteClick(id);
                        }
                    },
                    Cancel: function () {
                    }
                }
            });

            return false;
        }

        function Final_DeleteClick(id) {
            var Id = id;
            $.ajax({
                url: '/Setup/Delete_Prescription',
                dataType: 'json',
                type: "POST",
                data: { Id: Id },
                async: false,
                beforeSend: function () {
                },
                success: function (data) {
                    alert("Data Deleted Successfully !!!");
                    location.reload();
                },
                complete: function () {
                }
            });

            return false;

        }


    </script>



</asp:Content>

