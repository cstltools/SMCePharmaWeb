<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TransportView.aspx.cs" Inherits="DoctorModule_UI_TransportView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    

     <div id="popDiv"></div>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Transport  List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">

                            <a href="../DoctorModule_UI/Transport.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                      


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                           
                                   
                                    <div class="table-responsive" id="MainGradeDiv">
                            <table id="dtTb" class="table table-striped table-bordered table-hover" >
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                        <th>Transport</th>
                                        <th>Allowance Per Mileage(KM)</th>
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

        function un(o) {
            return o != null ? o : '';
        }
        $(function () {

            GetTransport();
        });

        function GetTransport() {

            var urlpath = 'Setup.aspx/GetTransportList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({  }),
                contentType: "application/json; charset=utf-8",
                type: "POST",
                async: true,
                beforeSend: function () {
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
                        row += "<td>" + un(result[i].TransportName) + "</td>";
                        row += "<td>" + un(result[i].AllowedMilagePerKM) + "</td>";

                        if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                            row += "<td><span class='badge bg-danger'>Inactive</span></td>";
                        }
                        row += "<td>" + un(result[i].empName) + "</td>";
                        row += "<td>" + un(result[i].EntryDate) + "</td>";
                        row += "<td><button class='btn-outline-warning  btn-xs mb-1 mb-md-0'  type='button' onclick='editClick(" + result[i].TransportId + ")'><i class='bx bxs-edit ' aria-hidden='true'></i></button>  </td>";
                        row += "</tr>";
                        /* <button class='btn-outline-danger btn-sm' onclick='DeleteClick(" + result[i].TransportId + ")'><i class='fas fa-trash' aria-hidden='true'></i></button>*/

                    }
                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    $('#dtTb').dataTable({
                        "ordering": false
                    });
                }
            });
        }

        function editClick(id) {
            location.href = 'Transport.aspx?id=' + id + '';
        }

        function Final_DeleteClick(id) {
            var Id = id;
            $.ajax({
                url: '/Setup/Delete_Transport',
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

