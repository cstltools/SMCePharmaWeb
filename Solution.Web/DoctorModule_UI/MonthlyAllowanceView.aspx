<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="MonthlyAllowanceView.aspx.cs" Inherits="DoctorModule_UI_MonthlyAllowanceView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">



    
    
 <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>   Monthly Allowances  List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="MonthlyAllowance.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                      

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
                                        <th>Allowance Name</th>
                                        <th>Allowance</th>

                                        <th>Active Status</th>
                                        <th>Create By</th>
                                        <th>Create Date</th>
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
 
    <script>
        $(function () {

            GetMonthlyAllowance();
    });

        function GetMonthlyAllowance() {

            var urlpath = 'Setup.aspx/GetMonthlyAllowanceList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "POST", contentType: "application/json; charset=utf-8",
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
                        row += "<td>" + result[i].MonthlyAllowanceName + "</td>";
                        row += "<td>" + result[i].MonthlyAllowance + "</td>";
                   
                        if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                            row += "<td><span class='badge bg-warning'>Inactive</span></td>";
                        }
                        row += "<td>" + result[i].empName + "</td>";
                        row += "<td>" + result[i].EntryDate + "</td>";
                        row += "<td><button class='btn-outline-warning  btn-xs mb-1 mb-md-0' type='button' onclick='editClick(" + result[i].MonthlyAllowanceId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> </td>";
                        row += "</tr>";
                      /*  <button class='btn-outline-danger btn-sm' onclick='DeleteClick(" + result[i].MonthlyAllowanceId + ")'><i class='fas fa-trash' aria-hidden='true'></i></button>*/
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
            location.href = '../DoctorModule_UI/MonthlyAllowance.aspx?id=' + id + '';
        }

        function Final_DeleteClick(id) {
                var Id = id;
                $.ajax({
                    url: '/Setup.aspx/Delete_MonthlyAllowance',
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

