<%@ Page Title=" Territory List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TerritoryRecords.aspx.cs" Inherits="DoctorModule_UI_TerritoryRecords" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

       
 <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Territory List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="../DoctorModule_UI/TerritorySetup.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                      

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">
                                            
                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">


                                                                            <div class="row">
                                                                            <div class="row mt-1">
<div class="col-3">&nbsp;</div>
<div class="col-4">
    <div class="form-group row">
        <label for="zoneSelect" class="col-sm-3 col-form-label">Zone: </label>
        <div class="col-sm-9">
            <div class="input-group">
                <select id="zoneSelect" name="zoneSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
                <span id="v-zoneSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
               
            </div>
        </div>

    </div>
</div>

                                                </div>
                                                    </div>

                                                                            <div class="row">
                                                                            <div class="row mt-1">
<div class="col-3">&nbsp;</div>
<div class="col-4">
    <div class="form-group row">
        <label for="zoneSelect" class="col-sm-3 col-form-label">Area: </label>
        <div class="col-sm-9">
            <div class="input-group">
                                                                             <select id="areaSelect" name="areaSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
<span id="v-areaSelect" class="invalid-tooltip fade hide" data-delay="2000"></span> 
               
            </div>
        </div>

    </div>
</div>

                                                </div>
                                                    </div>

                                                                 

                                                                                                                                <div class="row">
                                                                            <div class="row mt-1">
<div class="col-3">&nbsp;</div>
<div class="col-4">
    <div class="form-group row">
        <label for="zoneSelect" class="col-sm-3 col-form-label"> &nbsp; &nbsp; </label>
        <div class="col-sm-8">
            <div class="input-group" style="margin-left:2px!important">
                <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm" onclick="GetTerritory()">
    <i class="fa fa-search"></i> Search
</button>
               
            </div>
        </div>

    </div>
</div>

                                                </div>

                            
                         </div>
                            <br />
                            <div class="table-responsive" id="MainGradeDiv">
                                   <table id="dtTble"    class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                        <th>Group </th>
                                        <th>Zone </th>
                                        <th>Area </th>
                                        <th>Territory Code</th>
                                        <th>Territory Name</th>
                                        <%--<th>Thana Name</th>--%>
                                        <th>Entry By </th>
                                        <th>Entry Date </th>
                                        <th>Update By </th>
                                        <th>Update Date </th>
                                       

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
    
    <script>

        function un(o) {
            return o != null ? o : '';
        }
        $(function () {
            GetZone_ByGroup(1);
        GetTerritory();
        });
        $("#zoneSelect").on("change", function (e) {
            var zoneId = $("#zoneSelect").val();



            if (zoneId > 0) {
                GetArea_ByZone(zoneId);
            }
        });


        function GetArea_ByZone(id) {
            _getArea_ByZoneId_All($('#areaSelect'), 'AreaId', 'AreaName', id);
        }
        function GetZone_ByGroup(id) {
            _getZone_ByGroupId_all($('#zoneSelect'), 'RegionId', 'RegionName', id);
        }

        function GetTerritory() {

            var RegionId = $('#zoneSelect').val();

            // Check if RegionId is null, empty, or undefined and set it to a default value (e.g., 0)
            if (!RegionId) {
                RegionId = 0;
            }
            var areaId = $('#areaSelect').val();

            // Check if RegionId is null, empty, or undefined and set it to a default value (e.g., 0)
            if (!areaId) {
                areaId = 0;
            }
        var urlpath = 'Setup.aspx/GetTerritoryList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                data: JSON.stringify({ 'RegionId': RegionId, 'areaId': areaId }),
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
                        row += "<td>" + un(result[i].TerritoryCode) + "</td>";
                        row += "<td class='baseTxtWeight'>" + un(result[i].TerritoryName) + "</td>";
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
                       row += "<td><a class='btn-outline-warning  btn-xs mb-1 mb-md-0'    target='_blank'   href='../DoctorModule_UI/TerritorySetup.aspx?id=" + result[i].TerritoryId + "' " + result[i].DeleteStatus +"><i class='bx bxs-edit' aria-hidden='true'></i></a></td>";
                        row += "</tr>";
                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    $("#coverScreen").hide();

                    if ($.fn.dataTable.isDataTable('#dtTble')) {
                        table = $('#dtTble').DataTable();
                    }
                    else {
                        var table = $('#dtTble').DataTable(
                            {
                                "bInfo": true,
                                "bFilter": true,
                                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                                pageLength: 10,
                                dom: 'lBfrtip',


                                buttons: ['copy', 'excel', 'pdf', 'print']
                            }
                        );
                    }

                    var prm = Sys.WebForms.PageRequestManager.getInstance();
                    if (prm != null) {
                        prm.add_endRequest(function (sender, e) {
                            if (sender._postBackSettings.panelsToUpdate != null) {
                                table = $('#dtTble').DataTable(
                                    {
                                        "bInfo": true,
                                        "bFilter": true,
                                        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                                        pageLength: 10,
                                        dom: 'lBfrtip',


                                        buttons: ['copy', 'excel', 'pdf', 'print']


                                    }
                                );
                            }
                        });
                    };


                    table.columns().every(function () {



                    });


                }
            });
    }


        function editClick(id) {
            location.href = '../DoctorModule_UI/TerritorySetup.aspx?id=' + id + '';

        }
    </script>




</asp:Content>

