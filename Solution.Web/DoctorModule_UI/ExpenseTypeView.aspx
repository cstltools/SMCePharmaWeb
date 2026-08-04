<%@ Page Title="Expense Type List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ExpenseTypeView.aspx.cs" Inherits="DoctorModule_UI_ExpenseTypeView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


     
    
     <div id="popDiv"></div>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Expense Type List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="../DoctorModule_UI/ExpenseType.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                      

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">


                              <div class="table-responsive" id="MainGradeDiv">

                            <table id="dtTble"  class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                        <th>Name</th>
                                        <th>Role Type</th>
                                        <th>Role Type</th>
                                        <th>Employee Name</th>
                                     
                                     
                                        <th>is Fixed Amount</th>
                                        <th>Amount</th> 
                                        <th>Image Required</th> 
                                        <th>Active Status</th>
                                        <th>Create By</th>
                                        <th>Create Date</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody id="dtTableBody"></tbody>
                            </table>
                        </div>


</div>
</div>
</div>
</div>
</div>
</div>
     

    <script>

        function un(o) {
            return o != null ? o : '';
        }
        $(function () {

            GetPrescription();
    });

        function GetPrescription() {

            var urlpath = 'ExpenseTypeView.aspx/GetExpensemasterList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "POST",
                contentType: "application/json; charset=utf-8",
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
                        row += "<td>" + un( result[i].ExpenseTypeName) + "</td>";
                        row += "<td>" + un(result[i].RoleTypeName) + "</td>";
                        row += "<td>" + un(result[i].RoleTypeMult) + "</td>";
                        row += "<td>" + un(result[i].EmpNameMult) + "</td>";
                       
                        if (result[i].isFixed) {
                            row += "<td><span class='badge bg-success'>Yes</span></td>";
                        } else {
                            row += "<td><span class='badge bg-danger'>No</span></td>";
                        }
                        row += "<td>" + result[i].ExpenseAmount + "</td>";
                        

                        if (result[i].ImageRequired) {
                            row += "<td><span class='badge bg-success'>Yes</span></td>";
                        } else {
                            row += "<td><span class='badge bg-danger'>No</span></td>";
                        }

                        if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                            row += "<td><span class='badge bg-danger'>Inactive</span></td>";
                        }
                        row += "<td>" + result[i].empName + "</td>";
                        row += "<td>" + result[i].EntryDate + "</td>";

                        row += "<td><button class='btn-outline-warning  btn-xs mb-1 mb-md-0' type='button' onclick='editClick(" + result[i].ExpenseTypeId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> </td>";
                        row += "</tr>";


                       /* <button class='btn-outline-danger btn-sm' onclick='DeleteClick(" + result[i].ExpenseTypeId + ")'><i class='fas fa-trash' aria-hidden='true'></i></button>*/
                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    $('#dtTble').dataTable({
                        "ordering": false,
                        dom: 'lBfrtip',


                        buttons: ['copy', 'excel', 'pdf', 'print']
                    });
                }
            });
    }

        function editClick(id) {
            debugger;
            window.location.href = '../DoctorModule_UI/ExpenseType.aspx?id=' + id + '';
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
                url: 'ExpenseTypeView.aspx/Delete_ExpenseType',
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

