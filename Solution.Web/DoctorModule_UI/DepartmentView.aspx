<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DepartmentView.aspx.cs" Inherits="DoctorModule_UI_DepartmentView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    
 <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>   Department List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="Department.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                      

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <div class="table-responsive" id="MainGradeDiv">

                                <table id="dtTb"   class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                      
                                        <th>Department Name</th>

                                        <th>Entry By</th>
                                        <th>Entry Date</th>
                                        <th>Update By</th>
                                        <th>Update Date</th>
                                     
                                        <th>Status</th>
                                        <th>Actions</th>
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

        function un(o) {
            return o != null ? o : '';
        }
        $(function () {

            GetDegree();

        });

        function GetDegree() {
            var urlpath = 'DepartmentView.aspx/GetDepartmentList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                beforeSend: function () {
                },
                success: function (data) {

                    $('#tabH').show();
                    var result = JSON.parse(data.d);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {

                        row += "<tr>";
                        row += "<td>" + (i + 1) + "</td>";
                       
                        row += "<td>" + un(result[i].DeptName) + "</td>";

                        row += "<td>" + un(result[i].EMPEntryBy) + "</td>";
                        row += "<td>" + un(result[i].EntryDatee) + "</td>";

                        row += "<td>" + un(result[i].EMPUpdateBy) + "</td>";
                        row += "<td>" + un(result[i].UpdateDatee) + "</td>";

                        //row += "<td>" + result[i].EMPActiveInactiveBy + "</td>";
                        //row += "<td>" + result[i].InactiveDatee + "</td>";


                        if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                            row += "<td><span class='badge bg-danger'>Inactive</span></td>";
                        }
                        row += "<td><button  class='btn-outline-warning    btn-xs mb-1 mb-md-0 '  type='button'   onclick='editClick(" + result[i].DeptId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button></td>";
                        //   row += "<td><button class='btn-outline-warning btn-sm' onclick='editClick(" + result[i].DeptId + ")'><i class='fas fa-pen' aria-hidden='true'></i></button> <button class='btn-outline-Info btn-sm'  onclick='ActiveInactiveClick(" + result[i].DeptId + ")'><i class='fa fa-toggle-on'></i></button> <button class='btn-outline-danger btn-sm' onclick='DeleteClick(" + result[i].DeptId + ") " + result[i].DeleteStatus + " '><i class='fa fa-trash' aria-hidden='true'></i>   </button> </td>";
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

            location.href = '../DoctorModule_UI/Department.aspx?id=' + id + '';

        }


        function Final_Click(id) {
            var Id = id;
            $.ajax({
                url: '/DepartmentView.aspx/ActiveInactive_departmentInfo',
                dataType: 'json',
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
                url: '/DepartmentView.aspx/Delete_EmployeeDepartment',
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

