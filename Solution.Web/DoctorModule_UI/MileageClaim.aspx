<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="MileageClaim.aspx.cs" Inherits="DoctorModule_UI_MileageClaim" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    

 <style>
        .imgshadow{

            width:100%;
            height:300px;
        
/* border: 1px solid #ddd;*/
  border-radius: 4px;
  padding: 5px;
 box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
 border: 3px #1c87c9;
        border-style: dashed;
        }
         .imgshadow:hover {
  box-shadow: 0 0 2px 1px rgba(0, 140, 186, 0.5);
}
    </style>

<div id="popDiv">

</div>

    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Mileage Claim Information</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/MileageClaimView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                                <div class="row">&nbsp;</div>
                        <div class="row">
                            <div class="col-1">&nbsp;</div>
                            <div class="col-9">
                                <div class="form-group row">
                                    <label for="txtMileage" class="col-sm-3 col-form-label"> Mileage:  </label>

                                    <div class="col-sm-8">
                                           <div class="input-group">
                                        <input type="text" class="form-control form-control-sm mb-3" id="txtMileage" name="txtMileage" required>

                                        <span id="v-txtMileage" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
   <span class="input-group-text text-c-red">*</span>
                                               </div>

                                    </div>
                                  
                                </div>


                                <div class="form-group row">
                                    <label for="EntryBySelect" class="col-sm-3 col-form-label"> Entry By:  </label>

                                    <div class="col-sm-8">

                                        <div class="input-group">
                                        <select id="EntryBySelect" class="form-select form-select-sm mb-3 mySelect2"></select>

                                        <span id="v-EntryBySelect" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                               <span class="input-group-text text-c-red">*</span>
                                </div>

                                    </div>
                                   
                                </div>
                              

                                <div class="form-group row">
                                    <label for="txtNote" class="col-sm-3 col-form-label">  Note:  </label>

                                    <div class="col-sm-8">
                                        <textarea type="text" id="txtNote" class="form-control form-control-sm mb-3" rows="2"></textarea>

                                        <span id="v-txtNote" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>

                                </div>

                           
                                <div class="form-group row">
                                    <div style="display:none">
                                        <label for="ddlTourType" class="col-sm-3 col-form-label">  Tour Type:  </label>

                                    <div class="col-sm-3">
                                        <select id="ddlTourType" name="ddlTourType" class="form-select form-select-sm mb-3 mySelect2"> </select>
                                        <span id="v-ddlTourType" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    </div>


                                    <label for="txtClaimDate" class="col-sm-3 col-form-label">  Mileage Date:  </label>

                                    <div class="col-sm-3">
                                        <input id="txtClaimDate" type="text" class="form-control form-control-sm mb-3 datepicker " required autocomplete="off" placeholder="Select Date"  >
                                        <span id="v-txtClaimDate" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>

                                </div>


                                <div class="form-group row">
                                    <label for="ddlTransport" class="col-sm-3 col-form-label">  Transport:  </label>

                                    <div class="col-sm-8">
                                        <select id="ddlTransport" name="ddlTransport" class="form-select form-select-sm mb-3 mySelect2">
                                        </select>

                                        <span id="v-ddlTransport" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>

                                </div>
                                <div style="padding-top:6px;"></div>
                                <br />
                                   <div class="form-group row">
                                   <h4 class="col-sm-3">Market Structure</h4>   
                              
                                       </div>
                                <hr />
                                <div class="form-group row">
                                    <label for="GroupSelect" class="col-sm-3 col-form-label">  Group:  </label>

                                    <div class="col-sm-3">
                                        <select id="GroupSelect" name="GroupSelect" class="form-select form-select-sm mb-3 mySelect2">   </select>

                                        <span id="v-GroupSelect" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>

                                    </div>


                                    <label for="ZoneSelect" class="col-sm-2 col-form-label"> Zone:  </label>

                                    <div class="col-sm-3">
                                        <select id="ZoneSelect" name="ZoneSelect" class="form-select form-select-sm mb-3 mySelect2">   </select>

                                        <span id="v-ZoneSelect" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>

                                </div>





                                <div class="form-group row" style="margin-top:6px;">
                                    <label class="col-sm-3 col-form-label">Area:  </label>

                                    <div class="col-sm-3">
                                                <div class="input-group">
                                        <select id="AreaSelect" name="AreaSelect" class="form-select form-select-sm mb-3 mySelect2">   </select>

                                        <span id="v-AreaSelect" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                                       <span class="input-group-text text-c-red">*</span>
                                                    </div>
                                    </div>


                                   

                                    <label for="AreaSelect" class="col-sm-2 col-form-label">Territory:  </label>

                                    <div class="col-sm-3">

                                         <div class="input-group">
                                        <select id="TeritorySelect" name="TeritorySelect" class="form-select form-select-sm mb-3 mySelect2">   </select>

                                        <span id="v-TeritorySelect" class="invalid-tooltip fade hide" data-delay="2000"></span>

                                              <span class="input-group-text text-c-red">*</span>
                                                    </div>
                                    </div>
                                    
                                </div>



                                <div class="form-group row" style="margin-top:6px;">

                                    <label for="SubterritorySelect" class="col-sm-3 col-form-label">Sub-Territory:  </label>

                                    <div class="col-sm-3">
                                        <div class="input-group">
                                         <select id="SubterritorySelect" class="form-select form-select-sm mb-3 mySelect2"></select>
                                                <span id="v-SubterritorySelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                                    </div>


                                    </div>
                                    <label for="MarketSelect" class="col-sm-2 col-form-label">Market:  </label>

                                    <div class="col-sm-3">

                                         <div class="input-group">
                                        <select id="MarketSelect" name="MarketSelect" class="form-select form-select-sm mb-3 mySelect2">   </select>

                                        <span id="v-MarketSelect" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                              <span class="input-group-text text-c-red">*</span>
                                                    </div>

                                    </div>
                                  

                                    
                                    
                                </div>


                                <div class="form-group row" style="margin-top:6px;">


                                    <label for="MarketSelect" class="col-sm-3 col-form-label">Meter Readding:  </label>

                                    <div class="col-sm-3">

                                         <div class="input-group">
                                         <input type="text" class="form-control form-control-sm mb-3 " id="txtMeterReadding" name="txtMeterReadding" required>

                                        <span id="v-txtMeterReadding" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>

                                             <span class="input-group-text text-c-red">*</span>
                                                  
                                                    </div>
                                                    </div>

                                    </div>
                                  

                                    <label for="txtMeterReadding" class="col-sm-2 col-form-label">   </label>

                                    <div class="col-sm-3">
                                        <div class="input-group">
                                      
                                                    </div>


                                    </div>
                                    
                                </div>
                              <br />
                                   <div class="form-group row">
                                       <label for="MeterImage" class="col-sm-1 col-form-label"></label>
                                   <h4 class="col-sm-3">Upload Image</h4>   
                              
                                       </div>
                                <hr />
                                <div class="form-group row" style="margin-top:6px;">


                                    <label for="MeterImage" class="col-sm-3 col-form-label">Upload Meter Image:  </label>

                                    <div class="col-sm-8">
                                         <div class="input-group">

                                        <input type="file" id="imageUploadForm" name="image" accept="image/*" class="form-control form-control-sm mb-3 " onchange="ImageToBase64(this)" />

                                        <span id="v-MeterImage" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                               <span class="input-group-text text-c-red">*</span>
                                                    </div>



                                    </div>
                                   






                                </div>




                            </div>

                        </div>
                       
                        <div class="row">
                            <div class="col-sm-2">&nbsp;</div>
                            <div class="col-8">
                                <img id="output-image" class="imgshadow"  />
                            </div>
                            </div>
                             <br />
                             <br />
                                <div class="row" style="margin-top:20px;">
                                    <div class="col-2">&nbsp;</div>
                                    <div class="col-8 text-center">

                                        <div class="form-group row">
                                            
                                            <div class="col-sm-12">

                                                    <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm"   onclick="Save()">
                                            <i class="fa fa-check"></i>Submit
                                        </button>
                                        <button type="button" class="btn btnMyDesignReset   btn-sm"  onclick="ResetClick()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </button>
                                                
                                            </div>
                                        </div>

                                    </div>
                                    <div class="col-2">&nbsp;</div>
                                </div>
                        <div style="padding-top:10px"></div>
                          <br />
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                           

 

<input id="masterId" value="0" style="display:none" />
<input id="imgeBase64Str" style="display:none" />


    <script>

        $("#TeritorySelect").on("change", function (e) {

            var id = $("#TeritorySelect").val();
            if (id > 0) {
                GetSubTerritory_ByTerritoryId(id);

            }
        });

        function GetSubTerritory_ByTerritoryId_All_new(id, SetId) {
            _GetSubTerritory_ByTerritoryId_All($('#SubterritorySelect'), 'SubTerritoryId', 'SubTerritoryName', id, SetId);
        }


        function GetMarket_ByTerritoryId_All(id, SetId) {
            _getMarket_ByTerritoryId_All($('#MarketSelect'), 'MarketId', 'MarketName', id, SetId);
        }

        function GetSubTerritory_ByTerritoryId(id) {
            _GetSubTerritory_ByTerritoryId_Active($('#SubterritorySelect'), 'SubTerritoryId', 'SubTerritoryName', id);
        }

        function GetMarket_BySubTerritoryId_All(id, SetId) {
            _GetMarket_BySubTerritoryId_All($('#MarketSelect'), 'MarketId', 'MarketName', id, SetId);
        }

        function GetMarket_BySubTerritoryIdNew(id) {
            _GetMarket_BySubTerritoryId_Active($('#MarketSelect'), 'MarketId', 'MarketName', id);
        }

        function GetMarket_BySubTerritoryIdNew_All(id, SetId) {
            _GetMarket_BySubTerritoryId_All_new($('#MarketSelect'), 'MarketId', 'MarketName', id, SetId);
        }

        $(function () {

            $('.datepicker').pickadate({
                selectMonths: true,
                selectYears: true
            })

            var masterid = getUrlVars()["id"];
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);
                GetData(masterid);
            }
             else {
            //$('#txtClaimDate').datepicker("update", new Date());
            GetEmpList(0);
            GetTourTypeList(0);
            GetTransportList(0);
            GetGroupInfo(0);
        }



          
        $("#txtMileage").keypress(function (event) {

            $(this).val($(this).val().replace(/[^0-9\.]/g, ''));
            if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                /* if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {*/
                /*  $("#v-AllowedMilagePerKM").html("Number Only").stop().show().fadeOut("slow");*/
                ValidationTooltip("#v-txtMileage", "Number Only!");
                return false;
            }
        });


        $("#txtMeterReadding").keypress(function (event) {

            $(this).val($(this).val().replace(/[^0-9\.]/g, ''));
            if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                /* if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {*/
                /*  $("#v-AllowedMilagePerKM").html("Number Only").stop().show().fadeOut("slow");*/
                ValidationTooltip("#v-txtMeterReadding", "Number Only!");
                return false;
            }
        });

    });
        function getUrlVars() {
            var vars = [], hash;
            var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
            for (var i = 0; i < hashes.length; i++) {
                hash = hashes[i].split('=');
                vars.push(hash[0]);
                vars[hash[0]] = hash[1];
            }
            return vars;
        }
                function ResetClick() {
                    location.reload();


        }


        function ImageToBase64(image) {
            var img = image.files[0];
            var reader = new FileReader();
            reader.onloadend = function () {
                 
                $("#imgeBase64Str").val("");
                var base64result = reader.result.split(',')[1];
                $("#imgeBase64Str").val(base64result);

                $("#output-image").attr("src", reader.result);
                
                /* $("#fID").attr("href", img);*/
            }



            reader.readAsDataURL(img);

            //  UploadImage();
        }

        function GetGroupInfo(id) {
            _GetGroupInfo_Active($('#GroupSelect'), 'GroupId', 'GroupName', id);
        }
        function GetGroupAllInfo(id) {
            _GetGroupInfo_All($('#GroupSelect'), 'GroupId', 'GroupName', id);
        }

        $("#GroupSelect").on("change", function (e) {
            var GroupId = $("#GroupSelect").val();
            if (GroupId > 0) {
                GetZone(GroupId,0);

            }
            else {
                GetZone(0,0);
            }
        });


        function GetZone(id, SetId) {

            //   _getZone_ByGroupId_Active($('#upperSelect'), 'RegionId', 'RegionName', id);

            _getZone_ByGroupId_Active_SetValue($('#ZoneSelect'), 'RegionId', 'RegionName', id, SetId)
        }

        function GetZone_All(id, SetId) {

            //   _getZone_ByGroupId_Active($('#upperSelect'), 'RegionId', 'RegionName', id);

            _getZone_ByGroupId_All_SetValue($('#ZoneSelect'), 'RegionId', 'RegionName', id, SetId)
        }



        function GetArea_ByZone(id) {
            _getArea_ByZoneId_Active($('#AreaSelect'), 'AreaId', 'AreaName', id);
            
        }

        function GetArea_All_ByZone(id, SetId) {
            _getArea_ByZoneId_All($('#AreaSelect'), 'AreaId', 'AreaName', id, SetId);
        }

        function GetTerritory_ByAreaId(id) {
            _getTerritory_ByAreaId_Active($('#TeritorySelect'), 'TerritoryId', 'TerritoryName', id);
        }

        function GetTerritory_ByAreaId_All(id, SetId) {
            _getTerritory_ByAreaId_All($('#TeritorySelect'), 'TerritoryId', 'TerritoryName', id, SetId);
        }

        //function GetMarket_ByTerritoryId(id) {
        //    _getMarket_ByTerritoryId_Active($('#MarketSelect'), 'MarketId', 'MarketName', id);
        //}

        //function GetMarket_ByTerritoryId_All(id, SetId) {
        //    _getMarket_ByTerritoryId_All($('#MarketSelect'), 'MarketId', 'MarketName', id, SetId);
        //}

        $("#ZoneSelect").on("change", function (e) {
            var zoneId = $("#ZoneSelect").val();
            if (zoneId > 0) {
                GetArea_ByZone(zoneId);

            }
        });

        function GetGroupInfo(id) {
            _GetGroupInfo_Active($('#GroupSelect'), 'GroupId', 'GroupName', id);
        }


        $("#AreaSelect").on("change", function (e) {
             
            var id = $("#AreaSelect").val();
            if (id > 0) {
                GetTerritory_ByAreaId(id);

            }
        });

        $("#SubterritorySelect").on("change", function (e) {
            debugger;
            var id = $("#SubterritorySelect").val();
            if (id > 0) {
                //GetMarket_BySubTerritoryIdNew(id);
                _GetMarket_BySubTerritoryId_Active($('#MarketSelect'), 'MarketId', 'MarketName', id);
            }
        });




        function GetEmpList(SetId) {
            _getEmployeeList_Active($('#EntryBySelect'), 'EmpInfoId', 'EmpName', SetId);
        }
        function GetEmpList_All(SetId) {
            _getEmployeeList_All($('#EntryBySelect'), 'EmpInfoId', 'EmpName', SetId);
        }

        function GetTourTypeList(SetId) {
            _getTourTypeList_Active($('#ddlTourType'), 'TourTypeId', 'TourTypeName', SetId);
    }

    function GetTourTypeList_all(SetId) {
        _getTourTypeList_All($('#ddlTourType'), 'TourTypeId', 'TourTypeName', SetId);
    }

        function GetTransportList(SetId) {
            _getTransportList_Active($('#ddlTransport'), 'TransportId', 'TransportName', SetId);
        }

    function GetTransportList_All(SetId) {
        _getTransportList_All($('#ddlTransport'), 'TransportId', 'TransportName', SetId);
    }


        function Validation() {

            $('#txtMileage').removeClass('is-invalid');
            RemoveValidationTooltip("#v-txtMileage");

            $('#EntryBySelect').removeClass('is-invalid');
            RemoveValidationTooltip("#v-EntryBySelect");

            //$('#ddlTourType').removeClass('is-invalid');
            //RemoveValidationTooltip("#v-ddlTourType");

            $('#txtClaimDate').removeClass('is-invalid');
            RemoveValidationTooltip("#v-txtClaimDate");



            //$('#ddlTourType').removeClass('is-invalid');
            //RemoveValidationTooltip("#v-ddlTourType");

            $('#ddlTransport').removeClass('is-invalid');
            RemoveValidationTooltip("#v-ddlTransport");

            $('#GroupSelect').removeClass('is-invalid');
            RemoveValidationTooltip("#v-GroupSelect");

            $('#ZoneSelect').removeClass('is-invalid');
            RemoveValidationTooltip("#v-ZoneSelect");

            $('#AreaSelect').removeClass('is-invalid');
            RemoveValidationTooltip("#v-AreaSelect");

            //$('#TeritorySelect').removeClass('is-invalid');
            //RemoveValidationTooltip("#v-TeritorySelect");


            //$('#MarketSelect').removeClass('is-invalid');
            //RemoveValidationTooltip("#v-MarketSelect");


            $('#txtMeterReadding').removeClass('is-invalid');
            RemoveValidationTooltip("#v-txtMeterReadding");

            isValid = true;
            if ($('#txtMileage').val() == "") {


                $('#txtMileage').addClass("is-invalid");
                ValidationTooltip("#v-txtMileage", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#EntryBySelect').val() == "" || $('#EntryBySelect').val() == null || $('#EntryBySelect').val() == "0") {


                $('#EntryBySelect').addClass("is-invalid");
                ValidationTooltip("#v-EntryBySelect", "Please fill out of this field!");
                isValid = false;
            }

            //if ($('#ddlTourType').val() == "" || $('#ddlTourType').val() == null || $('#ddlTourType').val() == "0") {


            //    $('#ddlTourType').addClass("is-invalid");
            //    ValidationTooltip("#v-ddlTourType", "Please fill out of this field!");
            //    isValid = false;
            //}
            //if ($('#ddlTourType').val() == "" || $('#ddlTourType').val() == "0" || $('#ddlTourType').val() == null) {


            //    $('#ddlTourType').addClass("is-invalid");
            //    ValidationTooltip("#v-ddlTourType", "Please fill out of this field!");
            //    isValid = false;
            //}
            if ($('#txtClaimDate').val() == "") {


                $('#txtClaimDate').addClass("is-invalid");
                ValidationTooltip("#v-txtClaimDate", "Please fill out of this field!");
                isValid = false;
            }
        

            if ($('#ddlTransport').val() == "" || $('#ddlTransport').val() == "0" || $('#ddlTransport').val() == null){


                $('#ddlTransport').addClass("is-invalid");
                ValidationTooltip("#v-ddlTransport", "Please fill out of this field!");
                isValid = false;
            }


            if ($('#GroupSelect').val() == "" || $('#GroupSelect').val() == "0" || $('#GroupSelect').val() == null) {


                $('#GroupSelect').addClass("is-invalid");
                ValidationTooltip("#v-GroupSelect", "Please fill out of this field!");
                isValid = false;
            }



            if ($('#ZoneSelect').val() == "" || $('#ZoneSelect').val() == "0" || $('#ZoneSelect').val() == null) {


                $('#ZoneSelect').addClass("is-invalid");
                ValidationTooltip("#v-ZoneSelect", "Please fill out of this field!");
                isValid = false;
            }
            if ($('#AreaSelect').val() == "" || $('#AreaSelect').val() == "0" || $('#AreaSelect').val() == null) {


                $('#AreaSelect').addClass("is-invalid");
                ValidationTooltip("#v-AreaSelect", "Please fill out of this field!");
                isValid = false;
            }

            //if ($('#TeritorySelect').val() == "") {


            //    $('#TeritorySelect').addClass("is-invalid");
            //    ValidationTooltip("#v-TeritorySelect", "Please fill out of this field!");
            //    isValid = false;
            //}

            //if ($('#MarketSelect').val() == "") {


            //    $('#MarketSelect').addClass("is-invalid");
            //    ValidationTooltip("#v-MarketSelect", "Please fill out of this field!");
            //    isValid = false;
            //}
            if ($('#txtMeterReadding').val() == "") {


                $('#txtMeterReadding').addClass("is-invalid");
                ValidationTooltip("#v-txtMeterReadding", "Please fill out of this field!");
                isValid = false;
            }


            return isValid;
        }


        function ValidationTooltip(id, message) {

            $(id).empty();

            if ($(id).empty()) {
                $(id).append(message);
            }
            $(id).toast('show');
            $(id).css("display", "block");

        }
        function RemoveValidationTooltip(id) {
            $(id).css("display", "none");
        }


    function Save() {

        if (Validation()) {
            //$.confirm({
            //    icon: 'fas fa-question-circle',
            //    title: 'Are You Sure ?',
            //    content: 'You are about to save the data!',
            //    theme: 'Supervan',
            //    type: 'green',
            //    buttons: {
            //        Confirm: {
            //            text: 'Confirm',
            //            action: function () {
                            FinalSave();
            //            }
            //        },
            //        Cancel: function () {
            //        }
            //    }
            //});

        }

    }
    function FinalSave() {
        var jsonData = {};
        jsonData["MileageClaimId"] = $('#masterId').val();
        jsonData["MileageInKM"] = $('#txtMileage').val();
        jsonData["EmpInfoId"] = $('#EntryBySelect').val();
        jsonData["Remarks"] = $('#txtNote').val();

        jsonData["TourTypeId"] = $('#ddlTourType').val();
        jsonData["MileageDate"] = $('#txtClaimDate').val();

        jsonData["TransportId"] = $('#ddlTransport').val();
        jsonData["MileageDate"] = $('#txtClaimDate').val();
        jsonData["GroupId"] = $('#GroupSelect').val();
        jsonData["RegionId"] = $('#ZoneSelect').val();
        jsonData["AreaId"] = $('#AreaSelect').val();
        jsonData["TerritoryId"] = $('#TeritorySelect').val();
        jsonData["SubTerritoryId"] = $('#SubterritorySelect').val();
       
        jsonData["MarketId"] = $('#MarketSelect').val();
        jsonData["MeterReading"] = $('#txtMeterReadding').val();

        jsonData["MileageImage"] = $('#imgeBase64Str').val();
         



        var urlpath = 'MileageClaim.aspx/Save_MileageClaim';
            $.ajax({
                data: JSON.stringify({ 'degree': jsonData }),
                url: urlpath,
                type: "POST", contentType: "application/json; charset=utf-8",
                beforeSend: function () {
                    
                },
                success: function (result) {
                    var result = result.d;
                    if (result.isSuccess == true) {
                        successalert('Operation successful!', 'Success', 'MileageClaimView.aspx');
                    }
                    else {
                        faildalert('Operation Faild!', 'Faild');
                    }
                    

                },
                error: function (data) {
                    faildalert('Operation Faild!', 'Faild');
                },

            });
        }



           function GetData(id) {


               var urlpath = 'MileageClaim.aspx/GetMileageClaimEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;

                    console.log(data);
                    if (data.ApprovalStatus == "2") {

                        $("#btnSave").hide()
                    }
                    else {
                        $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");
                    }
                    $('#txtMileage').val(data.MileageInKM);
                  //  GetEmpList(data.EmpInfoId);
                  
                    GetEmpList_All(data.EmpInfoId);

                    
                    GetTourTypeList_all(data.TourTypeId);
                    GetTransportList_All(data.TransportId);
                    GetGroupAllInfo(data.GroupId);
                    GetZone_All(data.GroupId, data.RegionId);
                    GetArea_All_ByZone(data.RegionId, data.AreaId);
                    
                    var arrr = data.AreaId;
                    GetTerritory_ByAreaId_All(arrr, data.TerritoryId);
                 
                    GetSubTerritory_ByTerritoryId_All_new(data.TerritoryId, data.SubTerritoryId);
                   // alert(data.MarketId);
                    GetMarket_BySubTerritoryIdNew_All(data.SubTerritoryId, data.MarketId);
                    
                 //   GetMarket_BySubTerritoryId_All(data.SubTerritoryId, data.MarketId);
              //      GetMarket_BySubTerritoryId_All(data.SubTerritoryId,data.MarketId);
                 //   GetSubTerritory_ByTerritoryId_All(data.TerritoryId, data.SubTerritoryId)
                   // GetMarket_ByTerritoryId_All(data.TerritoryId, data.MarketId)
                    $('#txtMeterReadding').val(data.MeterReading);
                    $('#txtClaimDate').val(ToJavaScriptDate_Formater(data.MileageDate));
                    //$('#imgeBase64Str').val(data.MileageImage);
                    $('#txtNote').val(data.Remarks);
                    var src = "data:image/jpeg;base64,";
                    src += data.ImageString;
                    $("#output-image").attr("src", src);
                    $("#output-image").show();
                    $("#imgeBase64Str").val(data.ImageString);

                },
                complete: function() {
                }
            });
        }
 

      function GetThana_ET(id,parameterId) {
          var urlpath = 'MileageClaim.aspx/GetThana_WitTagDetails_forEditPage';
          _Selec2_Multiple_DisableOption_WithAjaxParameter(urlpath, $('#multiSelectId'), 'ThanaId', 'ThanaName', id, parameterId);
    }

    </script>












</asp:Content>

