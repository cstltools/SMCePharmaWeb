<%@ Page Title="Doctor Daily Visit List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DoctorDailyVisit.aspx.cs" Inherits="DoctorVisit_UI_DoctorDailyVisit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Doctor Daily Visit List</div>

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
                                    <label for="FromDate" class="col-sm-4 col-form-label">From Date:  </label>

                                    <div class="col-sm-8">
                                        <input id="FromDate" type="text" class="form-control form-control-sm mb-3 datepicker"   autocomplete="off" placeholder="Select Date">

                                    </div>

                                </div>

                            </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="UserSelect" class="col-sm-4 col-form-label">Employee:  </label>

                                    <div class="col-sm-8">

                                        <select id="EmployeeIdSelect" name="EmployeeIdSelect" class="form-select form-select-sm mb-3 mySelect2"></select>

                                      
                                    </div>

                                </div>

                            </div>
                        </div>

              
                        <div class="row">

                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="ToDate" class="col-sm-4 col-form-label">To Date:  </label>

                                    <div class="col-sm-8">
                                        <input id="ToDate" type="text" class="form-control form-control-sm mb-3 datepicker"   autocomplete="off" placeholder="Select Date">

                                    </div>

                                </div>

                            </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="UserRoleSelect" class="col-sm-4 col-form-label">User Role:  </label>

                                    <div class="col-sm-8">


                                        <select id="UserRoleSelect" name="UserRoleSelect" class="form-select form-select-sm mb-3 mySelect2">   </select>
                                    </div>

                                </div>

                            </div>
                        </div>




         
                  

                        <div class="row" style="display:none">


                            <div class="col-md-2">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text" style="color:black!important;font-weight:bold" id="">
                                            Year:
                                        </span>
                                    </div>

                                    <select id="FiscalYearSelect" name="FiscalYearSelect" class="form-control">
                                        <option value="">Select Year</option>
                                        <option value="2020">2020</option>
                                        <option value="2021">2021</option>
                                        <option value="2022">2022</option>
                                        <option selected value="2023">2023</option>
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

                            <div class="col-md-2">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text" style="color:black!important;font-weight:bold" id="">
                                            Month:
                                        </span>
                                    </div>

                                    <select id="MonthSelect" name="MonthSelect" class="form-control">
                                        <option value="">Select Month</option>
                                        <option    value="1">January</option>
                                        <option     value="2">February</option>
                                        <option    value="3">March</option>
                                        <option selected  value="4">April</option>
                                        <option value="5">May</option>
                                        <option value="6">June</option>
                                        <option value="7">July</option>
                                        <option value="8">August</option>
                                        <option     value="9">September</option>
                                        <option value="10">October</option>
                                        <option   value="11">November</option>
                                        <option      value="12">December</option>

                                    </select>
                                </div>




                            </div>


                            <div class="col-md-2">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text" style="color:black!important;font-weight:bold" id="">From Date:</span>
                                    </div>
                                   
                                </div>




                            </div>
                            <div class="col-md-2">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text" style="color:black!important;font-weight:bold" id="">
                                            To Date:
                                        </span>
                                    </div>
                                 
                                </div>




                            </div>
                            <div class="col-md-2">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text" style="color:black!important;font-weight:bold" id="">
                                            Approval Status:
                                        </span>
                                    </div>

                                    <select id="ApprovalStatusSelect" name="ApprovalStatusSelect" class="form-control">



                                        <option value="">All</option>
                                        <option value="0">Pending</option>
                                        <option value="1">Approved</option>
                                       
                                    </select>
                                </div>




                            </div>

                            <div class="col-md-2">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text" style="color:black!important;font-weight:bold" id="">
                                            User:
                                        </span>
                                    </div>

                                    <select id="UserSelect" name="UserSelect" class="form-control">   </select>
                                </div>




                            </div>




                        </div>

                        <div class="row" style="display:none">
                            <div class="col-md-2">
                                 




                            </div>

                            <div class="col-md-2">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text" style="color:black!important;font-weight:bold" id="">
                                            Employee:
                                        </span>
                                    </div>

                                  
                                </div>




                            </div>



                            <div class="col-md-2">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text" style="color:black!important;font-weight:bold" id="">
                                            Group:
                                        </span>
                                    </div>

                                    <select id="GroupSelect" name="GroupSelect" class="form-control">   </select>
                                </div>




                            </div>


                            <div class="col-md-2">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text" style="color:black!important;font-weight:bold" id="">
                                            Zone:
                                        </span>
                                    </div>

                                    <select id="ZoneSelect" name="ZoneSelect" class="form-control">   </select>
                                </div>




                            </div>


                            <div class="col-md-2">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text" style="color:black!important;font-weight:bold" id="">
                                            Area:
                                        </span>
                                    </div>

                                    <select id="AreaSelect" name="AreaSelect" class="form-control">   </select>
                                </div>




                            </div>


                            <div class="col-md-2">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text" style="color:black!important;font-weight:bold" id="">
                                            Territory:
                                        </span>
                                    </div>

                                    <select id="TeritorySelect" name="TeritorySelect" class="form-control">   </select>
                                </div>




                            </div>


                        </div>



                        <div class="row" style="display:none">

                            <div class="col-md-2">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text" style="color:black!important;font-weight:bold" id="">
                                            Market:
                                        </span>
                                    </div>

                                    <select id="MarketSelect" name="MarketSelect" class="form-control">   </select>
                                </div>




                            </div>

                        </div>
                      
                        <div class="row">
                            <div class="col-md-5">
                            </div>
                            <div class="col-md-4" style="align-content:center">

                                 <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm "  onclick="GetDegree()">
                                    <i class="fa fa-search-plus"></i>&nbsp; Search
                                </button>
                                <button type="button" class="btn btnMyDesignReset   btn-sm"   onclick="ResetClick()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </button>
                                 
                            </div>
                        </div>
                        <div style="padding-top:4px;"></div>


                            <div class="table-responsive" id="MainGradeDiv">


                                <table id="dtTb"  class="table table-striped table-bordered table-hover">
                                    <thead>
                                        <tr>
                                            <th>SL</th>
                                            <th>Employee ID</th>
                                            <th>Employee Name</th>
                                            <th>Designation</th>
                                            <th>User Role</th>
                                            <th>Doctor Name</th>
                                            <th>Visited With</th>
                                            <th>Market</th>
                                            <th>Territory</th>
                                            <th>Visit Date</th>
                                            <th>Chamber</th>
                                            <th>Planned/Unplanned</th>


                                          
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

    
     













     

    <script type="text/javascript">




         function ResetClick() {
            location.href = '@Url.Action("DoctorDailyVisit", "DoctorVisit")';

        }

        function un(o) {
            return o != null ? o : '';
        }


        $(function () {
            $('.datepicker').pickadate({
                selectMonths: true,
                selectYears: true
            })

            GetUserRoleInfo(0);
            GetEmpList(0);

    });


        function GetEmpList(SetId) {
            _getEmployeeList_Active($('#EmployeeIdSelect'), 'EmpInfoId', 'EmpName', SetId);
        }
        function GetUserRoleInfo(id) {
            var urlpath = '../DoctorModule_UI/Setup.aspx/Get_UserRoleInfo';
            SelectOption_DtTable_Async_True(urlpath, $('#UserRoleSelect'), 'UserRoleID', 'RoleName', id);
            $('#UserRoleSelect').select2();
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
                                    param = param + " AND CONVERT(date,DCR.EntryDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + $('#ToDate').val() + "' ";
                                }
                                if ($('#FromDate').val() != "" && $('#ToDate').val() == "") {
                                    param = param + " AND CONVERT(date,DCR.EntryDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + formatted + "' ";
                                }

                                if ($('#ToDate').val() != "" && $('#FromDate').val() == "") {
                                    param = param + " AND CONVERT(date,DCR.EntryDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + formatted + "' ";
                                }
                                if ($('#ApprovalStatusSelect').val() != "") {

                                    param = param + " AND DCR.IsApproved='" + $('#ApprovalStatusSelect').val() + "'";


                                }

                                if ($('#UserSelect').val() != "" && $('#UserSelect').val() != null && $('#UserSelect').val() != "0") {

                                    param = param + " AND tpdtl.CreatedBy='" + $('#UserSelect').val() + "'";

                                }

                                if ($('#UserRoleSelect').val() != "" && $('#UserRoleSelect').val() != null && $('#UserRoleSelect').val() != "0") {

                                    param = param + " AND us.UserRoleID='" + $('#UserRoleSelect').val() + "'";

                                }

                                if ($('#EmployeeIdSelect').val() != "" && $('#EmployeeIdSelect').val() != null && $('#EmployeeIdSelect').val() != "0") {

                                    param = param + " AND dtl.EmpInfoId='" + $('#EmployeeIdSelect').val() + "'";

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


            var urlpath = 'DoctorDailyVisit.aspx/GetDoctorDailyVisitList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({
                    "param": param
                }),
                type: "POST",
                contentType: "application/json;charset=utf-8",
                async: true,
                beforeSend: function() {
                },
                success: function(data) {
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
                        row += "<td class='baseTxtWeight'>" + un(result[i].DoctorName) + "</td>";
                        row += "<td class='baseTxtWeight'>" + un(result[i].empVisit) + "</td>";

                        row += "<td class='baseTxtWeight'>" + un(result[i].MarketName) + "</td>";
                        row += "<td class='baseTxtWeight'>" + un(result[i].TerritoryName) + "</td>";
                        row += "<td class='baseTxtWeight'>" + un(result[i].DcrDate) + "</td>";
                        row += "<td class='baseTxtWeight'>" + un(result[i].ChamberName) + "</td>";
                        row += "<td class='baseTxtWeight'>" + un(result[i].Planned) + "</td>";






                    /*    row += "<td><button class='btn-outline-warning  btn-xs mb-1 mb-md-0' onclick='editClick(" + result[i].DocTPMaster + ")'><i class='fas fa-pen' aria-hidden='true'></i></button> <button class='btn-outline-success  btn-xs mb-1 mb-md-0' onclick='editClick(" + result[i].DocTPMaster + ")'><i class='fas fa-eye' aria-hidden='true'></i></button>   </td>";*/


                        row += "</tr>";
                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    if ($.fn.dataTable.isDataTable('#dtTble')) {
                        table = $('#dtTble').DataTable();
                    }
                    else {
                        $('#dtTble').dataTable({
                            "bInfo": true,
                            "bFilter": true,
                            lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                            pageLength: 10,
                            dom: 'lBfrtip',


                            buttons: ['copy', 'excel', 'pdf', 'print']
                        });

                    }

                }
            });
    }
 

                            function GetGroupInfo(id) {
                                _GetGroupInfo_Active($('#GroupSelect'), 'GroupId', 'GroupName', id);
                            }

                            //function GetEmpList() {
                            //    _getEmployeeList_Active($('#EmployeeIdSelect'), 'EmpInfoId', 'EmpName');
                            //}


                            function GetUserList() {
                                _getUserList_Active($('#UserSelect'), 'UserId', 'UserName');
                            }


                            //function FiscalYearInfo(id) {
                            //    _GetFiscalYearInfo_Active($('#FiscalYearSelect'), 'FiscalYearId', 'FiscalYearDesc', id);
                            //}


                            $("#GroupSelect").on("change", function (e) {
                                var GroupId = $("#GroupSelect").val();
                                if (GroupId > 0) {
                                    GetZone(GroupId);

                                }
                            });

                            function GetZone(id) {
                                _Zone_Active($('#ZoneSelect'), 'ZoneId', 'ZoneName', id);
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



            function editClick(id) {
            location.href = '@Url.Action("DoctorPlanDetailsView", "DoctorVisit")?id=' + id + '';

        }



    $(function () {


        //$("#myBtn").click(function () {
        //    alert("Hello!");
        //    $('#myModal').modal('show');
        //});


        $('#myBtn').on('click', function () {
            $('#openModal').show();
        });


    //   GetMonth();

    //let id = $('#masterId').val();
    //if (id > 0) {
    //    $('#acDate').datepicker();
    //    $('#hRemarkDiv').show();
    //    GetData(id);
    //} else {
    //    $('#acDate').datepicker("update", new Date());
    //    GetZone(0);
    //    GetThana(0);
    //    GetDesignation();
    //    GetDegree();
    //    GetDoctorSpeciality();
    //    GetDoctorProgramType();
    //    GetDoctorCustomer();
    //    LoadInstitution();
    //}
    });



    function PopUp() {
        alert("Check");
        $("#myBtn").click(function () {
            alert("Hello!");
            $('#myModal').modal('show');
        });
    }

    function GetMonth() {
    _getYear_Active($('#YearSelect'), 'TPMaster', 'YearValue');
    }

    //


    function _getYear_Active(setControlId, bindId, bindName) {
    $.ajax({
    url: '/TourPlan/GetYear_Active',
    dataType: 'json',
    type: "Get",
    async: true,
    success: function (data) {
    var result = JSON.parse(data);
    setControlId.empty();
    setControlId.append($("<option>--- Select Year ---</option>").val(0));
    for (var i = 0; i < result.length; i++) {
    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

    }
    },
    complete: function () {
    setControlId.select2();
    }
    });

}


        function _getMonth_Active(setControlId, bindId, bindName) {
            $.ajax({
                url: '/CommonDataLoad/GetDesignation_Active',
                dataType: 'json',
                type: "Get",
                async: true,
                success: function (data) {
                    var result = JSON.parse(data);
                    setControlId.empty();
                    setControlId.append($("<option>--- Select Month ---</option>").val(0));
                    for (var i = 0; i < result.length; i++) {
                        setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                    }
                },
                complete: function () {
                    setControlId.select2();
                }
            });

        }
        //







        function Validation() {
        debugger;
        var isValid = true;
        var sad = $('#multiSelectId').val();
        if ($('#mainName').val() == "") isValid = false;
        if ($('#upperSelect').val() == 0) isValid = false;
        if ($('#multiSelectId').val() == "") isValid = false;
        if ($('#acDate').val() == "") isValid = false;
        if ($('#masterId').val() > 0) {
        if ($('#remarksTxt').val() == "") isValid = false;
        }

        if (isValid == false) {
        $.confirm({
        icon: 'fas fa-exclamation-triangle',
        title: 'Validation Error!',
        content: 'Please enter mandatory data',
        type: 'red',
        typeAnimated: true

        });
        }

        return isValid;
        }





    </script>
 

</asp:Content>

