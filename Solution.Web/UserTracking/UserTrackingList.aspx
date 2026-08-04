<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="UserTrackingList.aspx.cs" Inherits="UserTracking_UserTrackingList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Location Tracking </div>

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
                        
                          
                        <div class="row mt-1">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-9">
                                <div class="form-group row">
                                    <label for="exampleInputUsername2" id="acttxt" class="col-sm-3 col-form-label"> Employee Name: </label>
                                    <div class="col-sm-5">
                                        <select id="ddlEmpName" name="UserSelect" class="form-select form-select-sm mb-3 mySelect2   mb-3">
                                        </select>


                                        <span id="v-acDate" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>

                                <div style="padding:4px;"></div>
                                <div class="form-group row">
                                    <label for="exampleInputUsername2" id="acttxt" class="col-sm-3 col-form-label"> Date: </label>
                                    <div class="col-sm-5">

                                        <input type="text" id="dashboardDate2" autocomplete="off" placeholder="Select Date"  class="datepicker form-control form-control-sm">

                                    </div>


                                </div>
                            </div>



                        </div>

                        <div style="padding-top:16px;"></div>
                        <div class="row">
                            <div class="col-md-5">
                            </div>
                            <div class="col-md-4" style="align-content:center">
                                <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm" onclick="GetUserLocation()">
                                    <i class="fa fa-search-plus"></i>&nbsp; Search
                                </button>
                                <button type="button" class="btn btnMyDesignReset   btn-sm"   onclick="ResetClick()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </button>
                            </div>
                        </div>
                        <div style="padding-top:4px;"></div>
                        <div id="mapid" style="width: 100%; height: 400px;z-index:1"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>


<link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" integrity="sha512-xodZBNTC5n17Xt2atTPuE1HxjVMSvLVW9ocqUKLsCC5CXdbqCmblAshOMAS6/keqq/sMZMZ19scR4PsZChSR7A==" crossorigin="" />
<script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js" integrity="sha512-XQoYMqMTK8LvdxXYG3nZ448hOEQiglfqkJs1NOQV44cWnUrBc8PkAOcXy20w0vlaXaVUearIOBhiXZ5V3ynxwA==" crossorigin=""></script>

    <script>

        var mymap;

        $('document').ready(function () {
            GetEmpList(0);

            $('.datepicker').pickadate({
                selectMonths: true,
                selectYears: true
            })

        });


        function GetEmpList(id) {
            _getEmployeeList_Active($('#ddlEmpName'), 'EmpInfoId', 'EmpName', id);
        }


        function ResetClick() {
            window.location.reload();
        }

        function GetUserLocation() {

            var empId = $('#ddlEmpName').val();
            var trackDate = $('#dashboardDate2').val();
            if (empId != 0) {

                if (trackDate != "") {
                    $.ajax({
                        url: 'UserTrackingList.aspx/GetUserLocationTrackig',
                        type: "POST", contentType: "application/json; charset=utf-8",
                        async: true,
                        data: JSON.stringify({ 'empId': empId, 'trackDate': trackDate }),

                        dataType: 'json',
                        success: function (data) {
                            var result = JSON.parse(data.d);
                            console.log(result);
                            LoadMap(result);

                        },
                        complete: function () {
                        }
                    });
                }
                else {

                }
            }


        }


        function LoadMap(result) {
            if (mymap != undefined || mymap != null) {
                mymap.off();
                mymap.remove();

            }
            mymap = L.map('mapid').setView([23.810331, 90.412521], 10);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 18,
                attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">StreetMap</a> contributors, ' +
                    'Imagery © <a>Leaflet</a>',
                tileSize: 512,
                zoomOffset: -1
            }).addTo(mymap);

            var popup = L.popup();
            var polylinePoints = [
            ];

            // for indicating start position
            var startObject = result[0];

            L.marker(lngLatToLatLng(parseFloat(startObject.LatValue), parseFloat(startObject.LongValue))).addTo(mymap).bindPopup("Started at : " + startObject.Time + ": " + startObject.AddressName, { closeOnClick: false, autoClose: false }).openPopup();

            result.forEach(function (lngLat, i) {
                var latlngsd = lngLatToLatLng(parseFloat(lngLat.LatValue), parseFloat(lngLat.LongValue));
                polylinePoints[i] = latlngsd;

                if (result.length > 1) {
                    if (i > 0 && i < result.length - 1) {
                        /*    L.marker(latlngsd).on('click', markerClick).addTo(mymap)*/

                        L.marker(lngLatToLatLng(parseFloat(lngLat.LatValue), parseFloat(lngLat.LongValue))).addTo(mymap)
                            .bindPopup(lngLat.Time + " :" + lngLat.AddressName, { closeOnClick: false, autoClose: false }).openPopup();
                    }
                }
            });

            L.polyline(polylinePoints).addTo(mymap);
            if (result.length > 1) {
                var endObject = result[result.length - 1];
                L.marker(lngLatToLatLng(parseFloat(endObject.LatValue), parseFloat(endObject.LongValue))).addTo(mymap)
                    .bindPopup("Ended at : " + endObject.Time + " :" + endObject.AddressName, { closeOnClick: false, autoClose: false }).openPopup();
            }

        }
        function markerClick(e) {
            console.log(e);

        }





        function lngLatToLatLng(lat, lng) {
            return [lat, lng];
        }

    </script>
</asp:Content>

