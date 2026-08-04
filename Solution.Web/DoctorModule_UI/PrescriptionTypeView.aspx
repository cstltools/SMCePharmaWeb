<%@ Page Title="Prescription Type List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="PrescriptionTypeView.aspx.cs" Inherits="DoctorModule_UI_PrescriptionTypeView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

 



    
     <div id="popDiv"></div>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Prescription Type List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="../DoctorModule_UI/PrescriptionType.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                      

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <div class="table-responsive" id="MainGradeDiv">
                               <table id="dtTb"  class="table table-striped table-bordered table-hover">
                                                <thead>
                                                    <tr >
                                                        <th>SL</th>
                                                        <th>PrescriptionType </th>
                                                        <th>Active/Inactive Date</th>
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
                         

 
                        <script>
        $(function () {

            GetPrescription();
    });

        function GetPrescription() {

           
            $.ajax({

                url: "PrescriptionTypeView.aspx/GetPrescriptiontTypeList",
                dataType: 'json',
                type: "POST",
                contentType: "application/json;charset=utf-8",
                async: false,
                beforeSend: function() {
                },
                success: function(data) {

                    $('#tabH').show();

                    console.log(data.d);
                    
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < data.d.length; i++) {
                        row += "<tr>";
                        row += "<td>" + (i + 1) + "</td>";
                        row += "<td>" + data.d[i].PrescriptionType + "</td>";
                        row += "<td>" + data.d[i].ActivedateString + "</td>";
                        if (data.d[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                            row += "<td><span class='badge bg-danger'>Inactive</span></td>";
                        }
                        row += "<td><button class='btn-outline-warning  btn-xs mb-1 mb-md-0'  type='button'  onclick='editClick(" + data.d[i].PrescriptionTypeId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button></td>";
                        row += "</tr>";
                        //<button class='btn-outline-danger   btn-xs mb-1 mb-md-0' onclick='DeleteClick(" + result[i].PrescriptionTypeId + ")'><i class='fas fa-trash' aria-hidden='true'></i></button>
                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    if ($.fn.dataTable.isDataTable('#dtTb')) {
                        table = $('#dtTb').DataTable({
                            "ordering": false,
                            dom: 'lBfrtip',


                            buttons: ['copy', 'excel', 'pdf', 'print']
                        });
                    }
                    else {
                        table = $('#dtTb').DataTable({
                            "ordering": false,
                            dom: 'lBfrtip',


                            buttons: ['copy', 'excel', 'pdf', 'print']
                        });
                    }
                }
            });
    }

        function editClick(id)
        {
            window.location.replace('PrescriptionType.aspx?id=' + id + '');
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
                url: '/Setup/Delete_PrescriptionType',
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

