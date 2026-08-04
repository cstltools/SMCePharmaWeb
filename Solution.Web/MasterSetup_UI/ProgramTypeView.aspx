<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ProgramTypeView.aspx.cs" Inherits="MasterSetup_UI_ProgramTypeView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

      
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>   Provider Type  List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">

                          <a href="../MasterSetup_UI/ProgramType.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            
                                   
                                    <div class="p-4 border rounded">
                                        <div class="row g-3 needs-validation">



                                            <div class="table-responsive" id="MainGradeDiv">


                                                 <table id="dtTb" class="table table-striped table-bordered" >
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                        <th>Provider Type Code</th>
                                        <th>Provider Type Name</th>
                                       <th>For Customer </th>
                                        <th>For Doctor </th>
                                        <th>Is Default </th>
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
           
            $.ajax({
                url: 'ProgramTypeView.aspx/GetDepartmentList',
                type: 'post',
                contentType: 'application/json;charset=utf-8',
                dataType: 'json',
                data: "{}",
                async: true,
                beforeSend: function() {
                },
                success: function(data) {

                    $('#tabH').show();
                    var result = JSON.parse(data.d);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {

                        row += "<tr>";
                        row += "<td>" + (i + 1) + "</td>";
                     row += "<td>" + result[i].PrgmTypeCode + "</td>";

                        row += "<td>" + un(result[i].ProgramTypeName) + "</td>";

                        if (result[i].IsCustomer) {
                            row += "<td><span class='badge bg-success'>Yes</span></td>";
                        } else {
                            row += "<td><span class='badge bg-danger'>No</span></td>";
                        }

                        if (result[i].IsDoctor) {
                            row += "<td><span class='badge bg-success'>Yes</span></td>";
                        } else {
                            row += "<td><span class='badge bg-danger'>No</span></td>";
                        }
                        if (result[i].IsDefault) {
                            row += "<td><span class='badge bg-success'>Yes</span></td>";
                        } else {
                            row += "<td><span class='badge bg-danger'>No</span></td>";
                        }


                        row += "<td>" + un(result[i].EMPEntryBy)  + "</td>";
                        row += "<td>" + un(result[i].EntryDatee)  + "</td>";

                        row += "<td>" + un(result[i].EMPUpdateBy)  + "</td>";
                        row += "<td>" + un(result[i].UpdateDatee)  + "</td>";

                        //row += "<td>" + result[i].EMPActiveInactiveBy + "</td>";
                        //row += "<td>" + result[i].InactiveDatee + "</td>";


                        if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                            row += "<td><span class='badge bg-danger'>Inactive</span></td>";
                        }
                        row += "<td><button  class='btn-outline-warning  btn-xs mb-1 mb-md-0' type='button'   onclick='editClick(" + result[i].ProgramTypeId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> </td>";
                       // row += "<td><button class='btn-outline-warning btn-sm' onclick='editClick(" + result[i].ProgramTypeId + ")'><i class='fas fa-pen' aria-hidden='true'></i></button> <button class='btn-outline-Info btn-sm'  onclick='ActiveInactiveClick(" + result[i].ProgramTypeId + ")'><i class='fa fa-toggle-on'></i></button> </td>";
                        row += "</tr>";
                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    $('#dtTb').dataTable({
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

            location.href = 'ProgramType.aspx?id=' + id + '';

        }


        function Final_Click(id) {
            var Id = id;
            $.ajax({
                url: '/ProgramType/ActiveInactive_departmentInfo',
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
            $.confirm({
                icon: 'fas fa-question-circle',
                title: 'Are You Sure ?',
                content: 'You are concern to ActiveInactive the data!',
                theme: 'Supervan',
                type: 'green',
                buttons: {
                    Confirm: {
                        text: 'Confirm',
                        action: function () {
                            Final_Click(id);
                        }
                    },
                    Cancel: function (ID) {
                    }
                }
            });
        }



    function Final_DeleteClick(id) {
        var Id = id;
        $.ajax({
            url: '/Department/Delete_EmployeeDepartment',
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
</asp:Content>

