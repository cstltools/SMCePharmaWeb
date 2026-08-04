<%@ Page Title="Doctor's Designation list" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DoctorDesignationView.aspx.cs" Inherits="DoctorMaster_UI_DoctorDesignationView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <div class="page-wrapper">
         <asp:UpdatePanel ID="UpdatePanel1" runat="server">
             <ContentTemplate>
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Doctor's Designation list </div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="../DoctorMaster_UI/DoctorDesignation.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>

                    </div>
                </div>
            </div>

            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <div class="table-responsive" id="MainGradeDiv">
                                  <table id="dtTble"     class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                        <th>Designation </th>
                                        <th>Active/Inactive Date</th>
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
         </ContentTemplate>
         </asp:UpdatePanel>
                                </div>
    
    <script type="text/javascript">

        function un(o) {
            return o != null ? o : '';
        }


        $(function () {
            GetDoctorDesignation();
        });

        function locationChange() {
            window.location.href = '../DoctorMaster_UI/DoctorDesignation.aspx';
        }
        
        function GetDoctorDesignation() {
            $.ajax({
                url: 'DoctorDesignationView.aspx/Get_DoctorDesignation',
                type: 'post',
                contentType: 'application/json;charset=utf-8',
                dataType: 'json',
                data: "{}",
                async: true,
                success: function(data) {
                    $('#tabH').show();
                    var result = JSON.parse(data.d);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {            
                        row += "<tr>";
                        row += "<td>" + (i + 1) + "</td>";

                        row += "<td>" + un(result[i].DesignationName) + "</td>";
                        row += "<td>" + un(result[i].Activedate) + "</td>";
                        row += "<td>" + un(result[i].EntryBy) + "</td>";
                        row += "<td>" + un(result[i].EntryDate) + "</td>";
                        row += "<td>" + un(result[i].UpdateBy) + "</td>";
                        row += "<td>" + un(result[i].UpdateDate) + "</td>";

                        if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                            row += "<td><span class='badge bg-danger'>Inactive</span></td>";
                        }

                        //if (result[i].IsDel == "Yes") {
                        //    row += "<td><button class='btn-outline-warning btn-xs mb-1 mb-md-0' onclick='editClick(" + result[i].DesignationId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> <button class='btn-outline-danger btn-xs mb-1 mb-md-0' onclick='DeleteClick(" + result[i].DesignationId + ")'><i class='fa fa-minus-circle' aria-hidden='true'></i></button></td>";
                        //} else {                                                                                                                                                              
                        //    row += "<td><button class='btn-outline-warning btn-xs mb-1 mb-md-0' onclick='editClick(" + result[i].DesignationId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> <button class='btn-outline-danger btn-xs mb-1 mb-md-0' disabled data-toggle='tooltip' data-placement='top' title='Can not be deleted !!' onclick='DeleteClick(" + result[i].DesignationId + ")'><i class='fa fa-minus-circle' aria-hidden='true'></i></button></td>";
                        //}

                        
                            row += "<td><button class='btn-outline-warning btn-xs mb-1 mb-md-0' onclick='editClick(" + result[i].DesignationId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> </td>";
                        
                        row += "</tr>";
                    }
                    $('#dtTableBody').html(row);
                },
                complete: function () {

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
            window.location.href = '../DoctorMaster_UI/DoctorDesignation.aspx?id='+id;
        }
    
        function DeleteClick(id) {       
            //$.confirm({
            //    icon: 'fas fa-question-circle',
            //    title: 'Are You Sure ?',
            //    content: 'You are concern to delete the data!',
            //    theme: 'Supervan',
            //    type: 'green',
            //    buttons: {
            //        Confirm: {
            //            text: 'Confirm',
            //            action: function () {
            //                Final_DeleteClick(id);
            //            }
            //        },
            //        Cancel: function (ID) {
            //        }
            //    }
            //});
            Final_DeleteClick(id);
        }


        function Final_DeleteClick(id) {
            var Id = id;
            $.ajax({   
                url: 'DoctorDesignationView.aspx/Delete_DoctorDesignation',
                type: 'post',
                contentType: 'application/json;charset=utf-8',
                dataType: 'json',
                data: "{Id : '" + Id + "'}",
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

