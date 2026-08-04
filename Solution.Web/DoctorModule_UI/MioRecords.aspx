<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="MioRecords.aspx.cs" Inherits="DoctorModule_UI_MioRecords" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style>

    table, th, td {
        border: 0.1em solid #CFCFCF;
        border-collapse: collapse;
    }

    #custom_table td {
        padding: 0.1em 6px !important;
    }

    #custom_table th {
        padding: 4px;
        background-color: #3C8BCA;
        color: white;
    }

    #custom_table tr:nth-child(even) {
        background-color: #eee;
    }

    #custom_table tr:nth-child(odd) {
        background-color: #fff;
    }
</style>
<div class="container-fluid" style="width: 100% !important;">

      <div id="coverScreen" class="divWaitingJquery ">
        <img src="../images/Spinner.gif" style="width:180px" class="position-set" />
                </div>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> MIO List</div>

                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="../DoctorModule_UI/MioSetup.aspx" class="btn btn-sm btn-outline-info "><i class="fa fa-plus" aria-hidden="true"></i>New Entry</a>


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
                                            <th>Zone  </th>
                                            <th>Zone SAP Code </th>
                                            <th>Area  </th>
                                            <th>Area   SAP Code</th>
                                            <th>Territory  </th>
                                            <th>Territory   SAP Code</th>
                                            <th>Employee Name </th>
                                            
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


    <%--<div class="page-body m-t-20">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="card main-card  pb-4">
                    <div class="card-header main-card-head">
                        <h5 class=""> <i class="fas fa-1x fa-th-large "></i>  MIO View </h5>
                        <a href="FieldForce.aspx/MioSetup" class="btn btn-sm btn-info">
                            <i data-feather="plus" style="width: 16px !important; height: 16px !important;"></i>&nbsp; New Entry
                            @*<i data-feather="corner-up-right" style="width: 16px !important; height: 16px !important;"></i> Back to list*@
                        </a>
                    </div>

                    <div class="card-body" id="custom_table">

                        <table id="dtTble" width="100%">
                            <thead>
                                <tr>
                                    <th class="text-center"># SL No</th>
                                    <th> Region  </th>
                                    <th> Area  </th>
                                    <th> Territory  </th>
                                    <th> Employee Name </th>
                                    <th> Designation </th>
                                    <th class='text-center'> Status </th>
                                    <th class='text-center'> Active / Inactive Date </th>
                                    <th class="text-center" style="width: 15% !important">Actions</th>
                                </tr>
                            </thead>
                            <tbody id="dtTableBody">
                            </tbody>
                        </table>



                    </div>
                </div>
            </div>
        </div>
    </div>--%>
</div>


    <script>
        function un(o) {
            return o != null ? o : '';
        }
        $(function ()
        {
           LoadRSMInfo();
        });

        function LoadRSMInfo() {

            var urlpath = 'FieldForce.aspx/GetMIOList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                //data: JSON.stringify({ 'id': id }),
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
                        row += "<td class='text-center'>" + (i + 1) + "</td>";
                        row += "<td>" + un(result[i].Region) + "</td>";
                        row += "<td>" + un(result[i].RegionSap_Code) + "</td>";
                        row += "<td> " + un( result[i].Area) + " </td>";
                        row += "<td> " + un(result[i].AreaSap_Code) + " </td>";
                        row += "<td>" + un(result[i].Territory) + " </td>";
                        row += "<td>" + un(result[i].TerritorySap_Code) + " </td>";
                        row += "<td>" + un(result[i].EmployeeName) + "</td>";
                      

                        if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                            row += "<td><span class='badge bg-warning'>Inactive</span></td>";
                        }
                        row += "<td class='text-center'>" + un(result[i].ActiveInActiveDate) + "</td>";


                        if (result[i].IsActive) {
                            row += "<td><button class='btn-outline-warning    btn-xs mb-1 mb-md-0 '  type='button'  onclick='editClick(" + result[i].MIOId + ")'   ><i class='bx bxs-edit' aria-hidden='true'></i></button>  </td>";
                        }
                        else {
                            row += "<td> </td>";

                           /* <button class='btn-outline-warning    btn-xs mb-1 mb-md-0 ' disabled title='Cannot be edited' type='button' onclick='editClick(" + result[i].MIOId + ")'   ><i class='bx bxs-edit' aria-hidden='true'></i></button>*/ 
                        }

                   
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
            location.href = 'MioSetup.aspx?id=' + id + '';
        }

        function InactiveMIOInfo(id) {
            
                            Final_InactiveClick(id);
            

            return false;
        }

        function Final_InactiveClick(id) {
            var Id = id;
            $.ajax({
                url: '/FieldForce.aspx/MioInactiveById',
                dataType: 'json',
                data: JSON.stringify({ 'mioId': id }),
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

