<%@ Page Title="Sub-Territory List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SubTerritoryRecords.aspx.cs" Inherits="DoctorModule_UI_SubTerritoryRecords" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

       
 <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Sub-Territory List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="../DoctorModule_UI/SubTerritorySetup.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                      
                         
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
                                        <th>Group </th>
                                        <th>Zone </th>
                                        <th>Area </th>
                                 
                                        <th>Territory Name</th>
                                          <th>Sub-Territory Code</th>
                                        <th>Sub-Territory Name</th>
                                        <th>Entry By </th>
                                        <th>Entry Date </th>
                                        <th>Update By </th>
                                        <th>Update Date </th>
                                       

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

      <div id="coverScreen" class="divWaitingJquery ">
        <img src="../images/Spinner.gif" style="width:180px" class="position-set" />
                </div>

    
    <script>

        function un(o) {
            return o != null ? o : '';
        }
        $(function () {

        GetTerritory();
    });

    function GetTerritory() {
        var urlpath = 'Setup.aspx/GetSubTerritoryList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                beforeSend: function () {
                    $("#coverScreen").show();

                },
                success: function(data) {
                    data = data.d;
                    $('#tabH').show();
                    var result = JSON.parse(data);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {
                        row += "<tr>";
                        row += "<td>" + (i + 1) + "</td>";
                        row += "<td>" + un(result[i].GroupName) + "</td>";
                        row += "<td>" + un(result[i].RegionName) + "</td>";
                        row += "<td>" + un(result[i].AreaName) + "</td>";
                       
                        row += "<td> " + un(result[i].TerritoryName) + "</td>";
                      
                        row += "<td>" + un(result[i].SubTerritoryCode) + "</td>";
                        row += "<td >" + un(result[i].SubTerritoryName) + "</td>";
                        //row += "<td>" + un(result[i].ThanaName) + "</td>";
                        row += "<td>" + un(result[i].EMPEntryBy) + "</td>";
                        row += "<td>" + un(result[i].EntryDatee) + "</td>";
                        row += "<td>" + un(result[i].EMPUpdateBy) + "</td>";
                        row += "<td>" + un(result[i].UpdateDatee) + "</td>";

                        //row += "<td>" + result[i].EMPActiveInactiveBy + "</td>";
                        //row += "<td>" + result[i].InactiveDatee + "</td>";


                        if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                            row += "<td><span class='badge bg-warning'>Inactive</span></td>";
                        }
                        row += "<td><button class='btn-outline-warning  btn-xs mb-1 mb-md-0'   type='button'   onclick='editClick(" + result[i].SubTerritoryId + ")' " + result[i].DeleteStatus +"><i class='bx bxs-edit' aria-hidden='true'></i></button></td>";
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
            location.href = '../DoctorModule_UI/SubTerritorySetup.aspx?id=' + id + '';

        }
    </script>




</asp:Content>

