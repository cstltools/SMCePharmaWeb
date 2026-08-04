<%@ Page Title="Doctor Call Plan List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DoctorVisit.aspx.cs" Inherits="DoctorVisit_UI_DoctorVisit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <div id="coverScreen" class="divWaitingJquery ">
        <img src="../images/Spinner.gif" style="width: 180px" class="position-set" />
    </div>

    <style>
        .export-button {
    background-color: #4caf50; /* Change the color as needed */
    color: #fff;
    border: none;
    padding: 5px 10px;
    cursor: pointer;

}

.export-button:hover {
    background-color: #45a049; /* Change the hover color as needed */
}
    </style>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Doctor Call Plan List</div>

                <div class="ms-auto">
                    <div class="btn-group">
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <div class="row">

                                <div class="col-5">
                                    <div class="form-group row">
                                        <label for="FiscalYearSelect" class="col-sm-4 col-form-label">Year:  </label>

                                        <div class="col-sm-8">
                                            <select id="FiscalYearSelect" name="FiscalYearSelect" class="form-select form-select-sm mb-3 mySelect2">
                                                <option value="">Select Year</option>
                                                <option value="2019">2019</option>
                                                <option value="2020">2020</option>
                                                <option value="2021">2021</option>
                                                <option value="2022">2022</option>
                                                <option    value="2023">2023</option>
                                                <option value="2024">2024</option>
                                                <option value="2025">2025</option>
                                                 <option value="2026">2026</option>
 <option value="2027">2027</option>
 <option value="2028">2028</option>
 <option value="2029">2029</option>
 <option value="2030">2030</option>
                                            </select>

                                        </div>

                                    </div>

                                </div>
                                <div class="col-5">
                                    <div class="form-group row">
                                        <label for="EmployeeIdSelect" class="col-sm-4 col-form-label">Employee:  </label>

                                        <div class="col-sm-8">


                                            <select id="EmployeeIdSelect" name="EmployeeIdSelect" class="form-select form-select-sm mb-3 mySelect2"></select>

                                        </div>


                                    </div>

                                </div>
                            </div>


                            <div class="row">

                                <div class="col-5">
                                    <div class="form-group row">
                                        <label for="MonthSelect" class="col-sm-4 col-form-label">Month:  </label>

                                        <div class="col-sm-8">
                                            <select id="MonthSelect" name="MonthSelect" class="form-select form-select-sm mb-3 mySelect2">
                                                <option value="">Select Month</option>
                                                <option   value="1">January</option>
                                                <option   value="2">February</option>
                                                <option    value="3">March</option>
                                                <option     value="4">April</option>
                                                <option value="5">May</option>
                                                <option value="6">June</option>
                                                <option value="7">July</option>
                                                <option value="8">August</option>
                                                <option value="9">September</option>
                                                <option   value="10">October</option>
                                                <option    value="11">November</option>
                                                <option  value="12">December</option>

                                            </select>

                                        </div>

                                    </div>

                                </div>
                                <div class="col-5">
                                    <div class="form-group row">
                                        <label for="UserRoleSelect" class="col-sm-4 col-form-label">User Role:  </label>

                                        <div class="col-sm-8">


                                            <select id="UserRoleSelect" name="UserRoleSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
                                        </div>

                                    </div>

                                </div>
                            </div>





                            <div class="row">

                                <div class="col-5">
                                    <div class="form-group row" style="display: none">
                                        <label for="FromDate" class="col-sm-4 col-form-label">From Date:  </label>

                                        <div class="col-sm-8">
                                            <input id="FromDate" type="text" class="form-control form-control-sm" required autocomplete="off" placeholder="Select Date" data-date-autoclose="true" data-date-today-highlight="true" data-date-format="dd-M-yyyy">
                                        </div>

                                    </div>

                                </div>
                                <div class="col-5">
                                    <div class="form-group row">
                                        <label for="ApprovalStatusSelect" class="col-sm-4 col-form-label">Approval Status:  </label>

                                        <div class="col-sm-8">


                                            <select id="ApprovalStatusSelect" name="ApprovalStatusSelect" class="form-select form-select-sm mb-3 mySelect2">
                                            </select>
                                        </div>

                                    </div>

                                </div>
                            </div>




                            <div class="row">

                                <div class="col-5">
                                    <div class="form-group row" style="display: none">
                                        <label for="ToDate" class="col-sm-4 col-form-label">To Date:  </label>

                                        <div class="col-sm-8">
                                            <input id="ToDate" type="text" class="form-control form-control-sm" required autocomplete="off" placeholder="Select Date" data-date-autoclose="true" data-date-today-highlight="true" data-date-format="dd-M-yyyy">
                                        </div>

                                    </div>

                                </div>
                                <div class="col-5">
                                    <div class="form-group row">
                                        <label for="ApprovalStatusSelect" class="col-sm-4 col-form-label"></label>

                                        <div class="col-sm-8">
                                        </div>

                                    </div>

                                </div>
                            </div>




                            <div class="row" style="display: none">
                                <div class="col-md-2">
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text" style="color: black!important; font-weight: bold" id="">User Role:
                                            </span>
                                        </div>


                                    </div>




                                </div>

                                <div class="col-md-2">
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text" style="color: black!important; font-weight: bold" id="">Employee:
                                            </span>
                                        </div>


                                    </div>




                                </div>



                                <div class="col-md-2">
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text" style="color: black!important; font-weight: bold" id="">Group:
                                            </span>
                                        </div>

                                        <select id="GroupSelect" name="GroupSelect" class="form-control form-control-sm"></select>
                                    </div>




                                </div>


                                <div class="col-md-2">
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text" style="color: black!important; font-weight: bold" id="">Zone:
                                            </span>
                                        </div>

                                        <select id="ZoneSelect" name="ZoneSelect" class="form-control form-control-sm"></select>
                                    </div>




                                </div>


                                <div class="col-md-2">
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text" style="color: black!important; font-weight: bold" id="">Area:
                                            </span>
                                        </div>

                                        <select id="AreaSelect" name="AreaSelect" class="form-control form-control-sm"></select>
                                    </div>




                                </div>


                                <div class="col-md-2">
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text" style="color: black!important; font-weight: bold" id="">Territory:
                                            </span>
                                        </div>

                                        <select id="TeritorySelect" name="TeritorySelect" class="form-control form-control-sm"></select>
                                    </div>




                                </div>


                            </div>



                            <div class="row" style="display: none">

                                <div class="col-md-2">
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text" style="color: black!important; font-weight: bold" id="">Market:
                                            </span>
                                        </div>

                                        <select id="MarketSelect" name="MarketSelect" class="form-control"></select>
                                    </div>




                                </div>

                            </div>

                            <div class="row">
                                <div class="col-md-5">
                                </div>
                                <div class="col-md-4" style="align-content: center">

                                    <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm " onclick="GetDegree()">
                                        <i class="fa fa-search-plus"></i>&nbsp; Search
                                    </button>
                                    <button type="button" class="btn btnMyDesignReset   btn-sm" onclick="ResetClick()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </button>

                                </div>
                            </div>
                           
                               <div class="row">
       <div class="col-md-5">
       </div>
                                       <div class="col-md-6">
    </div>
       <div class="col-md-1" style="align-content: center">

                                                           <button id="exportBtn"   class="export-button">
    <i class="fa fa-file-excel-o"></i> Export
</button>
               </div>
</div>

                             <div style="padding-top: 5px;"></div>
                            <div class="table-responsive" id="MainGradeDiv">

                          

                                <table id="dtTb" class="table table-striped table-bordered table-hover jdtDataTable">
                                    <thead>
                                        <tr>
                                            <th>SL</th>
                                            <th>Employee ID</th>
                                            <th>Employee Name</th>
                                            <th>Designation</th>
                                            <th>User Role</th>
                                            <th>Month</th>
                                            <th>Year</th>
                                            <th>Remarks</th>
                                            <th>Approval Status</th>

                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="dtTableBody">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>






    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.3/xlsx.full.min.js"></script>

    <script type="text/javascript">

        document.getElementById('exportBtn').addEventListener('click', function () {
            exportToExcel();
        });

        function exportToExcel() {
            // Get the table
            var table = document.getElementById('dtTb');

            // Create a new workbook
            var workbook = XLSX.utils.book_new();

            // Convert the table to worksheet and add to the workbook
            var ws = XLSX.utils.table_to_sheet(table);
            XLSX.utils.book_append_sheet(workbook, ws, 'Sheet1');

            // Save the workbook as an Excel file
            var fileName = 'Doctor Call Plan List.xlsx';
            XLSX.writeFile(workbook, fileName);
        }
        $(function () {

            var currentMonth = new Date().getMonth() + 1; // Get current month (1-12)
            $('#MonthSelect').val(currentMonth).trigger('change');

            var currentYear = new Date().getFullYear(); // Get current year
            $('#FiscalYearSelect').val(currentYear).trigger('change');
            GetUserRoleInfo(0);
            GetEmpList(0);
            GetApprovalStatusList("");
            GetDegree();
        });

        function GetApprovalStatusList(id) {
            _getApprovalList_Active($('#ApprovalStatusSelect'), 'SoftwareUseId', 'WebShow', id);
        }


        function GetEmpList(SetId) {
            _getEmployeeList_Active($('#EmployeeIdSelect'), 'EmpInfoId', 'EmpName', SetId);
        }
        function GetUserRoleInfo(id) {
            var urlpath = '../DoctorModule_UI/Setup.aspx/Get_UserRoleInfo';
            SelectOption_DtTable_Async_True(urlpath, $('#UserRoleSelect'), 'UserRoleID', 'RoleName', id);
            $('#UserRoleSelect').select2();
        }


        function ResetClick() {
            location.href = '@Url.Action("DoctorVisit", "DoctorVisit")';

        }

        function un(o) {
            return o != null ? o : '';
        }




        function GetDegree() {


            var d = new Date();

            var month = d.getMonth() + 1;
            var day = d.getDate();

            var formatted = d.getFullYear() + '/' +
                (('' + month).length < 2 ? '0' : '') + month + '/' +
                (('' + day).length < 2 ? '0' : '') + day;
            var param = "";


            if ($('#FiscalYearSelect').val() != "") {

                param = param + " AND  mas.YearValue='" + $('#FiscalYearSelect').val() + "'";


            }

            if ($('#MonthSelect').val() != "") {

                param = param + " AND  mas.MonthValue='" + $('#MonthSelect').val() + "'";


            }

            if ($('#FromDate').val() != "" && $('#ToDate').val() != "") {
                param = param + " AND CONVERT(date,tpdtl.CreatedDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + $('#ToDate').val() + "' ";
            }
            if ($('#FromDate').val() != "" && $('#ToDate').val() == "") {
                param = param + " AND CONVERT(date,tpdtl.CreatedDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + formatted + "' ";
            }

            if ($('#ToDate').val() != "" && $('#FromDate').val() == "") {
                param = param + " AND CONVERT(date,tpdtl.CreatedDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + formatted + "' ";
            }
            if ($('#ApprovalStatusSelect').val() != "" && $('#ApprovalStatusSelect').val() != null) {

                param = param + " AND mas.ApprovalStatus='" + $('#ApprovalStatusSelect').val() + "'";


            }

            if ($('#UserSelect').val() != "" && $('#UserSelect').val() != null && $('#UserSelect').val() != "0") {

                param = param + " AND tpdtl.CreatedBy='" + $('#UserSelect').val() + "'";

            }

            if ($('#UserRoleSelect').val() != "" && $('#UserRoleSelect').val() != null && $('#UserRoleSelect').val() != "0") {

                param = param + " AND us.UserRoleID='" + $('#UserRoleSelect').val() + "'";

            }

            if ($('#EmployeeIdSelect').val() != "" && $('#EmployeeIdSelect').val() != null && $('#EmployeeIdSelect').val() != "0") {

                param = param + " AND mas.EmpInfoId='" + $('#EmployeeIdSelect').val() + "'";

            }



            if ($('#GroupSelect').val() != "" && $('#GroupSelect').val() != null && $('#GroupSelect').val() != "0") {

                param = param + " AND gp.GroupId='" + $('#GroupSelect').val() + "'";

            }


            if ($('#ZoneSelect').val() != "" && $('#ZoneSelect').val() != null && $('#ZoneSelect').val() != "0") {

                param = param + " AND zn.ZoneId='" + $('#ZoneSelect').val() + "'";

            }
            if ($('#AreaSelect').val() != "" && $('#AreaSelect').val() != null && $('#AreaSelect').val() != "0") {

                param = param + " AND ar.AreaId='" + $('#AreaSelect').val() + "'";

            }

            if ($('#TeritorySelect').val() != "" && $('#TeritorySelect').val() != null && $('#TeritorySelect').val() != "0") {

                param = param + " AND tr.TerritoryId='" + $('#TeritorySelect').val() + "'";

            }


            if ($('#MarketSelect').val() != "" && $('#MarketSelect').val() != null && $('#MarketSelect').val() != "0") {

                param = param + " AND mr.MarketId='" + $('#MarketSelect').val() + "'";

            }

             
            var urlpath = 'DoctorVisit.aspx/GetDoctorVisitList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({
                    "param": param
                }),
                type: "POST",
                contentType: "application/json;charset=utf-8",
                async: true,
                beforeSend: function () {
                    $("#coverScreen").show();

                },
                success: function (data) {
                    data = data.d;
                    $('#tabH').show();
                    var result = JSON.parse(data);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {

                        row += "<tr>";
                        row += "<td>" + (i + 1) + "</td>";
                        row += "<td class='baseTxtWeight'>" + un(result[i].EmpMasterCode) + "</td>";
                        row += "<td class='baseTxtWeight'>" + un(result[i].EmpName) + "</td>";
                        row += "<td  >" + un(result[i].DesigName) + "</td>";
                        row += "<td  >" + un(result[i].RoleName) + "</td>";
                        row += "<td class='baseTxtWeight'>" + un(result[i].MonthName1) + "</td>";
                        row += "<td class='baseTxtWeight'>" + un(result[i].YearValue) + "</td>";
                        row += "<td  >" + un(result[i].FinalSubmitRemarks) + "</td>";
                        row += "<td>" + un(result[i].ApprovalStatus) + "</td>";





                        row += "<td><button class='btn-outline-info  btn-xs mb-1 mb-md-0' type='button' onclick='editClick(" + result[i].DocTPMaster + ")'><i class='fa fa-eye' aria-hidden='true'></i></button> </td>";



                        //<button class='btn-outline-success  btn-xs mb-1 mb-md-0' onclick='editClick(" + result[i].DocTPMaster + ")'><i class='fas fa-eye' aria-hidden='true'></i></button>

                        row += "</tr>";
                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    $("#coverScreen").hide();

                    if ($.fn.dataTable.isDataTable('#dtTb')) {
                        table = $('#dtTb').DataTable();
                    }
                    else {
                        $('#dtTb').dataTable({
                            "bInfo": true,
                            "bFilter": true,
                            lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                            "bPaginate": false
                        });

                    }
                }
            });
        }


        function GetGroupInfo(id) {
            _GetGroupInfo_Active($('#GroupSelect'), 'GroupId', 'GroupName', id);
        }


        function GetUser(setId) {
            var urlpath = 'Setup.aspx/Get_CapturedBy_For_ddl';
            SelectOption_DtTable_Async_True(urlpath, $('#EmployeeIdSelect'), 'EmpInfoId', 'EmpName', setId);
            $('#EmployeeIdSelect').select2();
        }

        function GetUserList() {
            _getUserList_Active($('#UserSelect'), 'UserId', 'UserName');
        }





        function editClick(id) {
            location.href = '../DoctorVisit_UI/DoctorPlanDetailsView.aspx?id=' + id + '';

        }






    </script>




</asp:Content>

