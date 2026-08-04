<%@ Page Title="User Role List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="UserRoleRecords.aspx.cs" Inherits="DoctorModule_UI_UserRoleRecords" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> User Role List </div>  

                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="../DoctorModule_UI/UserRoleEntry.aspx" class="btn btn-sm btn-outline-info "><i class="fa fa-plus" aria-hidden="true"></i>New Entry</a>
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
                                            <th class="text-center"># SL No</th>
                                            <th>User Role </th>
                                            <th> Role Type </th>
                                            <th class='text-center'>Status </th>
                                            <th class='text-center'>Active Or Inactive Date </th>
                                            <th class="text-center">Actions</th>


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


     <script>
         function un(o) {
             return o != null ? o : '';
         }
        $(function ()
        {
           LoadNSMInfo();
        });

        function LoadNSMInfo() {

            var urlpath = 'FieldForce.aspx/GetUserRoleList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                //data: JSON.stringify({ 'id': id }),
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
                        row += "<td class='text-center'>" + (i + 1) + "</td>";
                        row += "<td>" + un(result[i].RoleName) + "</td>";
                        row += "<td>" + un(result[i].RoleType) + "</td>";


                        if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                            row += "<td><span class='badge bg-warning'>Inactive</span></td>";
                        }

                        row += "<td class='text-center'>" + un(result[i].ActiveInActiveDate) + "</td>";
                        row += "<td><button class='btn-outline-warning    btn-xs mb-1 mb-md-0 '  type='button'  onclick='editClick(" + result[i].UserRoleID + ")'   ><i class='bx bxs-edit' aria-hidden='true'></i></button>  </td>";
                      
                     //   else {
                           /* row += "<td class='text-left mb-2'> <a style='padding: .3em .5em .4em .5em !important;' data-toggle='tooltip' data-placement='top' title='View' class='btn btn-sm btn-info' href='/LeaveApplication/LeaveApplicationDetail?id=" + result[i].RSMId + "'><i class='fa fa-eye' ></i></a>  </td>";*/
                     //   }
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
             location.href = 'UserRoleEntry.aspx?id=' + id + '';
        
        }

        function InactiveRsmInfo(id) {
            
                            Final_InactiveClick(id);
            

            return false;
        }

        function Final_InactiveClick(id) {
            var Id = id;
            $.ajax({
                url: '/FieldForce.aspx/RsmInactiveById',
                dataType: 'json',
                data: JSON.stringify({ 'rsmId': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: false,
                beforeSend: function () {
                },
                success: function (data) {
                    
                    alert("Inactivated Successfully !!!");
                    
                },
                complete: function () {
                    location.reload();
                }
            });

            return false;

        }


     </script>

</asp:Content>

