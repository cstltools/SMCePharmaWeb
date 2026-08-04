<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="RouterSetupView.aspx.cs" Inherits="DoctorModule_UI_RouterSetupView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    
 <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Router  List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="../DoctorModule_UI/RouterSetupEntry.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                      

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <div class="table-responsive" id="MainGradeDiv">

                                    <table id="dtTb"    class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                        <th>Router Name</th>
                                        <th>Router Code</th>
                                        <th>Entry By</th>
                                        <th>Entry Date</th>
                                        
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody id="dtTableBody" class="txtCenter">
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
        $(function () {
          
            $("#btnShow").click(function () {
                $('#dialog').dialog('open');
            });
        });

        $(function () {

           

        GetDegree();
    });

        function un(o) {
            return o != null ? o : '';
        }

        function GetDegree() {
            var urlpath = 'RouterSetupView.aspx/GetRouterMasterList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "POST", contentType: "application/json; charset=utf-8",
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
                        row += "<td>" + un(result[i].RouterName) + "</td>";
                        row += "<td>" + un(result[i].RouterCode) + "</td>";
                        row += "<td>" + un(result[i].EMPEntryBy) + "</td>";
                        row += "<td>" + un(result[i].EntryDatee) + "</td>";
                        //row += "<td>" + un(result[i].EMPUpdateBy) + "</td>";
                        //row += "<td>" + un(result[i].UpdateDatee) + "</td>";
                        
                       if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                           row += "<td><span class='badge bg-danger'>Inactive</span></td>";
                        }

                        row += "<td><button class='btn-outline-warning btn-xs mb-1 mb-md-0'   type='button'  onclick='editClick(" + result[i].RouterMasterId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> <button   type='button'  class='btn-outline-success btn-xs mb-1 mb-md-0' onclick='viewClick(" + result[i].RouterMasterId + ")'><i class='fa fa-eye' aria-hidden='true'></i></button> </td>";

                      //  row += "<td><button class='btn-outline-warning btn-sm' onclick='editClick(" + result[i].LeaveTypeId + ")'><i class='fas fa-pen' aria-hidden='true'></i></button> <button class='btn-outline-success btn-sm' onclick='viewClick(" + result[i].LeaveTypeId + ")'><i class='fas fa-eye' aria-hidden='true'></i></button><button class='btn-outline-Info btn-sm'  onclick='ActiveInactiveClick(" + result[i].LeaveTypeId + ")'><i class='fa fa-toggle-on'></i></button> <button class='btn-outline-danger btn-sm' onclick='DeleteClick(" + result[i].LeaveTypeId + ") " + result[i].DelateStatus + " '><i class='fa fa-trash' aria-hidden='true'></i>   </button> </td>";
                        row += "</tr>";
                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    //$('#dtTb').dataTable({
                    //    "ordering": false
                    //});
                }
            });
    }



        function editClick(id) {

            location.href = '../DoctorModule_UI/RouterSetupEntry.aspx?id=' + id + '';

        }



         function viewClick(id) {

             location.href = '../DoctorModule_UI/RouterDetailsView.aspx?id=' + id + '';

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
                url: '/Leave/ActiveInactive_EmployeeLeave',
                dataType: 'json',
                type: "POST",
                data: { Id: Id },
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
            url: '/Leave/Delete_EmployeeLeave',
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
                Cancel: function (ID) {
                }
            }
        });
    }


















    </script>
}


</asp:Content>

