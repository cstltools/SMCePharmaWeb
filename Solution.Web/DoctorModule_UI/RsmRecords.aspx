<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="RsmRecords.aspx.cs" Inherits="DoctorModule_UI_RsmRecords" %>

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

    <div class="page-body m-t-20">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="card main-card  pb-4">
                    <div class="card-header main-card-head">
                        <h5 class=""> <i class="fas fa-1x fa-th-large "></i> DZSM View </h5>
                        <a href="RsmSetup.aspx" class="btn btn-sm btn-info">
                            <i data-feather="plus" style="width: 16px !important; height: 16px !important;"></i>&nbsp;New Entry
                            <%--@*<i data-feather="corner-up-right" style="width: 16px !important; height: 16px !important;"></i> Back to list*@--%>
                        </a>
                    </div>




                    <div class="card-body" id="custom_table">

                        <table id="dtTble" width="100%">
                            <thead>
                                <tr>
                                    <th class="text-center"># SL No</th>
                                    <th> Region Name </th>
                                    <th> Employee Name </th>
                                    <th> Designation </th>
                                    <th class='text-center'> Status </th>
                                    <th class='text-center'> Active Or Inactive Date </th>
                                    <th class="text-center">Actions</th>
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
    <script src="../assets/js/jquery-3.6.0.min.js"></script>
    <script src="../assets/js/select2.js"></script>        
    <script src="~/assets/jquery-ui.min.js"></script>
    <link href="~/assets/jquery-ui.min.css" rel="stylesheet" />
    <script src="~/assets/vendors/core/core.js"></script>
    <script src="../assets/vendors/datatables.net/jquery.dataTables.js"></script>
    <script src="../assets/vendors/datatables.net/dataTables.buttons.min.js"></script>

    <script>

        $(function ()
        {
           LoadRSMInfo();
        });

        function LoadRSMInfo() {

            var urlpath = 'FieldForce.aspx/GetRSMList';
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
                        row += "<td>" + result[i].Region + "</td>";
                        row += "<td>" + result[i].EmployeeName + "</td>";
                        row += "<td> Regional Sales Manager </td>";

                        if (result[i].IsActive) {
                            row += "<td class='text-center'> <i class='fa fa-1x fa-toggle-on  text-success'> Active </i></td>";
                        } else {
                            row += "<td class='text-center'><i class='fa fa-1x fa-toggle-off text-danger'> Inactive </i></td>";
                        }

                        row += "<td class='text-center'>" + result[i].ActiveInActiveDate + "</td>";

                       /* if (result[i].IsActive)*/ {
                            row += '<td class="text-left mb-2" style="width: 50px !importent;">  <a style="padding: .3em .5em .4em .5em!important;" data-toggle="tooltip" data-placement="top" title="Inactive" class="btn btn-sm btn-danger" href="javascript:void(0);" onclick="InactiveRsmInfo(' + result[i].RSMId + ')"><i class="fa fa-toggle-off" > Inactive </i></a> </td>';
                        }
                     //   else {
                           /* row += "<td class='text-left mb-2'> <a style='padding: .3em .5em .4em .5em !important;' data-toggle='tooltip' data-placement='top' title='View' class='btn btn-sm btn-info' href='/LeaveApplication/LeaveApplicationDetail?id=" + result[i].RSMId + "'><i class='fa fa-eye' ></i></a>  </td>";*/
                     //   }
                        row += "</tr>";

                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    //$('#dtTble').dataTable({
                    //    "ordering": false
                    //});
                }
            });
    }

        function editClick(id) {
            location.href = '../DoctorModule_UI/RsmSetup.aspx?id=' + id + '';
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

