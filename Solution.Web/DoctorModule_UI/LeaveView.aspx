<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="LeaveView.aspx.cs" Inherits="DoctorModule_UI_LeaveView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="container-fluid" style="width: 100% !important;">
        
 <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Leave Information List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="../DoctorModule_UI/Leave.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                      

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <div class="table-responsive" id="MainGradeDiv">

                                  <table id="dtTb" class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                        <th>Leave Name</th>
                                        <th>Days </th>

                                        <th>Entry By</th>
                                        <th>Entry Date</th>
                                        <th>Update By</th>
                                        <th>Update Date</th>
                                        <th>Status</th>
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
  
</div>

 


      <div id="coverScreen" class="divWaitingJquery ">
        <img src="../images/Spinner.gif" style="width:180px" class="position-set" />
                </div>

<script type="text/javascript">
    function un(o) {
        return o != null ? o : '';
    }

        $(function () {

        GetDegree();
    });

        function GetDegree() {
            var urlpath = 'LeaveView.aspx/GetLeaveList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                beforeSend: function () {
                    $("#coverScreen").show();
                },
                success: function(data) {

                    $('#tabH').show();
                    var result = JSON.parse(data.d);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {

                        row += "<tr>";
                        row += "<td>" + (i + 1) + "</td>";
                        row += "<td>" + un(result[i].LeaveTypeName) + "</td>";
                        row += "<td>" + un(result[i].LeaveDays) + "</td>";
                        row += "<td>" + un(result[i].EnrtryBy) + "</td>";
                        row += "<td>" + un(result[i].EntryDatee) + "</td>";
                        row += "<td>" + un(result[i].UpdateBy) + "</td>";
                        row += "<td>" + un(result[i].UpdateDatee) + "</td>";



                        //if (result[i].IsActive) {
                        //    row += "<td><span class='badge badge-success'><i class='fas fa-check-circle' aria-hidden='true'></i></span></td>";
                        //} else {
                        //    row += "<td><span class='badge badge-warning'><i class='fas fa-ban' aria-hidden='true'></i></span></td>";
                        //}

                       if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                           row += "<td><span class='badge bg-danger'>Inactive</span></td>";
                        }


                        row += "<td><button class='btn-outline-warning btn-xs mb-1 mb-md-0'   type='button'  onclick='editClick(" + result[i].LeaveTypeId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> </td>";

                      //  row += "<td><button class='btn-outline-warning btn-sm' onclick='editClick(" + result[i].LeaveTypeId + ")'><i class='fas fa-pen' aria-hidden='true'></i></button> <button class='btn-outline-success btn-sm' onclick='viewClick(" + result[i].LeaveTypeId + ")'><i class='fas fa-eye' aria-hidden='true'></i></button><button class='btn-outline-Info btn-sm'  onclick='ActiveInactiveClick(" + result[i].LeaveTypeId + ")'><i class='fa fa-toggle-on'></i></button> <button class='btn-outline-danger btn-sm' onclick='DeleteClick(" + result[i].LeaveTypeId + ") " + result[i].DelateStatus + " '><i class='fa fa-trash' aria-hidden='true'></i>   </button> </td>";
                        row += "</tr>";
                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    $("#coverScreen").hide();

                    $('#dtTble').dataTable({
                        "bInfo": true,
                        "bFilter": true,
                        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                        pageLength: 10,
                        dom: 'lBfrtip',


                        buttons: ['copy', 'excel', 'pdf', 'print']
                    });
                }
            });
    }



        function editClick(id) {
        
            window.location.href = '../DoctorModule_UI/Leave.aspx?id=' + id + '';

        }



         function viewClick(id) {

             window.location.href = '../DoctorModule_UI/LeaveDetailsView.aspx?id=' + id + '';

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



        function Final_Click(id) {
            var Id = id;
            $.ajax({
                url: '/LeaveView.aspx/ActiveInactive_EmployeeLeave',
                dataType: 'json',
                //dataType: 'json',
                data: JSON.stringify({ 'Id': Id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: false,
                beforeSend: function () {
                },
                success: function (data) {

                    location.reload();
                },
                complete: function () {
                }
            });

            return false;
        }

        function ActiveInactiveClick(id) {
            
                            Final_Click(id);
            
        }







    function Final_DeleteClick(id) {
        var Id = id;
        $.ajax({
            url: '/LeaveView.aspx/Delete_EmployeeLeave',
            dataType: 'json',
            data: JSON.stringify({ 'Id': Id }),
            type: "POST", contentType: "application/json; charset=utf-8",
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

    function DeleteClick(id) {
        
                        Final_DeleteClick(id);
        
    }


















</script>







</asp:Content>

