<%@ Page Title="National List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="NationalSetupView.aspx.cs" Inherits="DoctorModule_UI_NationalSetupView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  National List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                      

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
                              <thead class="table-light">
                                    <tr>
                                        <th>SL</th>
                                        <th>National Code</th>
                                        <th>National Name</th>
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
                                </div>
  
      <div id="coverScreen" class="divWaitingJquery ">
        <img src="../images/Spinner.gif" style="width:180px" class="position-set" />
                </div>
    <script type="text/javascript">

        function un(o) {
            return o != null ? o : '';
        }
        $(function () {

            GetDegree();

        });

        function GetDegree() {
            var urlpath = 'NationalSetupView.aspx/GetNationalSetupList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                beforeSend: function () {
                    $("#coverScreen").show();
                },
                success: function(data) {

                    $('#tabH').show();
                    var result = JSON.parse(data.d);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {

                        row += "<tr>";
                        row += "<td>" + (i + 1) + "</td>";
                        row += "<td>" + un(result[i].NationalCode)+ "</td>";
                        row += "<td>" + un(result[i].NationalName) + "</td>";

                        row += "<td>" + un(result[i].EntryBy) + "</td>";
                        row += "<td>" + un(result[i].EntryDate) + "</td>";

                        row += "<td>" + un(result[i].UpdateBy) + "</td>";
                        row += "<td>" + un(result[i].UpdateDate) + "</td>";

                        //row += "<td>" + result[i].ApproveBy + "</td>";
                        //row += "<td>" + result[i].ApproveDate + "</td>";

                        //row += "<td>" + result[i].ActiveBy + "</td>";
                        //row += "<td>" + result[i].InactiveDate + "</td>";


                        if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                            row += "<td><span class='badge bg-warning'>Inactive</span></td>";
                        }
                        row += "<td> </td>";

                      //  row += "<td><button class='btn-outline-warning btn-sm' onclick='editClick(" + result[i].GroupId + ")'><i class='fas fa-pen' aria-hidden='true'></i></button> <button class='btn-outline-Info btn-sm'  onclick='ActiveInactiveClick(" + result[i].GroupId + ")'><i class='fa fa-toggle-on'></i></button> <button class='btn-outline-danger btn-sm' onclick='DeleteClick(" + result[i].GroupId + ") " + result[i].DeleteStatus + " '><i class='fa fa-trash' aria-hidden='true'></i>   </button> </td>";
                        row += "</tr>";
                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    $("#coverScreen").hide();

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

            location.href = '../DoctorModule_UI/GroupSetupEntry.aspx?id=' + id + '';

        }


        function Final_Click(id) {
            var Id = id;
            $.ajax({
                url: '/GroupSetupView.aspx/ActiveInactive_GroupSetupInfo',
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
            url: '/GroupSetup/Delete_GroupSetup',
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

