<%@ Page Title="Shift Information List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ShiftInfoList.aspx.cs" Inherits="DoctorModule_UI_ShiftInfoList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


        
 <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Shift Information List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="../DoctorModule_UI/ShiftInfoEntry.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                      

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
                                        <th>Shift Name</th>
                                        <th>Start Time</th>
                                        <th>End Time</th>
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

        GetDegree();
    });

        function GetDegree() {
            var urlpath = 'ShiftInfoList.aspx/GetShiftList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                type: "POST",
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
                        row += "<td class='baseTxtWeight'>" + result[i].ShiftText + "</td>";
                        row += "<td class='baseTxtWeight'>" + result[i].ShiftInTime + "</td>";
                        row += "<td class='baseTxtWeight'>" + result[i].ShiftOutTime + "</td>";
                       
                        row += "<td>" + result[i].Activedate + "</td>";

                        if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                            row += "<td><span class='badge bg-danger'>Inactive</span></td>";
                        }



              
                        row += "<td><button class='btn-outline-warning btn-xs'   type='button'  onclick='editClick(" + result[i].ShiftId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button>  </td>";
                        

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
            location.href = '../DoctorModule_UI/ShiftInfoEntry.aspx?id=' + id + '';

        }

        function Final_DeleteClick(id) {
            var Id = id;
            $.ajax({
                url: 'ShiftInfoList/Delete_DoctorDegree',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                type: "POST",
                data: JSON.stringify({ 'Id': Id }),
                //data: { Id: Id },
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

