<%@ Page Title="Market List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="MarketRecords.aspx.cs" Inherits="DoctorModule_UI_MarketRecords" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Market List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="../DoctorModule_UI/MarketSetup.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                      

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
                                        <th>Territory </th> 
                                        <th>Sub-Territory </th> 
                                        <th>Market Code</th>
                                        <th>Market Name</th>
                                        <th>Route Name</th>
                                        <th>Division</th>
                                        <th>District</th>
                                        <th>Thana</th>
                                       
                                        <th>For Regional Head</th>
                                        <th>For DZSM</th>
                                        <th>For AM</th>
                                        <th>For MIO</th>
                                        <th>For Sales Assistance</th>

                                       
                                        <th>Entry By </th>
                                        <th>Entry Date </th>
                                        <th>Update By </th>
                                        <th>Update Date </th>
                                        <th>Inactive  By </th>
                                        <th>Active/Inactive  Date </th>


                                       
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
    
 
 <style>
            

    </style>
    <div id="coverScreen" class="divWaitingJquery ">
        <img src="../images/Spinner.gif" style="width:180px" class="position-set" />
                </div>

    <script>

        function un(o) {
            return o != null ? o : '';
        }
        $(function () {

        Getdata();
    });
        function Getdata() {
            var urlpath = 'MarketRecords.aspx/GetMarketList';
            $.ajax({
                url: urlpath,
                //url: urlpath,
                dataType: 'json',
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                beforeSend: function () {
                    $("#coverScreen").show();
                },
                success: function (data) {

                    $('#tabH').show();

                    var result = JSON.parse(data.d);

                    if ($.fn.DataTable.isDataTable('#dtTb')) {
                        $('#dtTb').DataTable().destroy();
                    }

                    $('#dtTb').dataTable({
                        data: result,
                        deferRender: true,
                        "bInfo": true,
                        "bFilter": true,
                        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                        pageLength: 10,
                        dom: 'lBfrtip',
                        buttons: ['copy', 'excel', 'pdf', 'print'],
                        columns: [
                            { data: null, render: function (data, type, row, meta) { return meta.row + 1; } },
                            { data: 'GroupName', render: un },
                            { data: 'RegionName', render: un },
                            { data: 'AreaName', render: un },
                            { data: 'TerritoryName', render: un },
                            { data: 'SubTerritoryName', render: un },
                            { data: 'MarketCode', render: un },
                            { data: 'MarketName', render: un },
                            { data: 'RouteName', render: un },
                            { data: 'DivisionName', render: un },
                            { data: 'DistrictName', render: un },
                            { data: 'ThanaName', render: un },
                            { data: 'NSMStationType', render: un },
                            { data: 'DZSMtationType', render: un },
                            { data: 'AMStationType', render: un },
                            { data: 'MIOStationType', render: un },
                            { data: 'SalesAssistanceStationType', render: un },
                            { data: 'EMPEntryBy', render: un },
                            { data: 'EntryDatee', render: un },
                            { data: 'EMPUpdateBy', render: un },
                            { data: 'UpdateDatee', render: un },
                            { data: 'EMPActiveInactiveBy', render: un },
                            { data: 'InactiveDatee', render: un },
                            { 
                                data: 'IsActive', 
                                render: function (data, type, row) { 
                                    if (data) {
                                        return "<span class='badge bg-success'>Active</span>";
                                    } else {
                                        return "<span class='badge bg-warning'>Inactive</span>";
                                    }
                                } 
                            },
                            { 
                                data: 'MarketId', 
                                render: function (data, type, row) { 
                                    return "<button class='btn-outline-warning btn-xs mb-1 mb-md-0' type='button' onclick='editClick(" + data + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button>";
                                } 
                            }
                        ]
                    });

                },
                complete: function () {

                    $("#coverScreen").hide();
                }
            });
        }

        function editClick(id) {
            window.location.href = '../DoctorModule_UI/MarketSetup.aspx?id=' + id + '';

        }
    </script>




</asp:Content>


 

