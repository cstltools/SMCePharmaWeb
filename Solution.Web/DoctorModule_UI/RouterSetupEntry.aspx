<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="RouterSetupEntry.aspx.cs" Inherits="DoctorModule_UI_RouterSetupEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    


      <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Router Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/RouterSetupView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                             <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Route Name </label>

                                    <div class="col-sm-5">
                                        <input type="text" class="form-control form-control-sm " required="true" id="mainName" placeholder="Type name">

                                        <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>
                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>




                        <br />



                        <div class="table-responsive" id="tableDetail" style="position: relative; min-height: 360px !important;">
                        </div>

                        <div class="table-responsive " id="MainGradeDiv">

                            <table class="table greyGridTable table-striped table-hover" id="dtTb">
                                <tbody id="dtTableBody">
                                </tbody>
                            </table>

                        </div>


                        <br />
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">

                                        
                                         <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm"   onclick="Save()">
                                            <i class="fa fa-check"></i>Submit
                                        </button>
                                        <button type="button" class="btn btnMyDesignReset   btn-sm"  onclick="ConfirmationClick()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </button>
                                          


                                        
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>

    <div class="container-fluid">

    <div class="page-body m-t-20">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="card main-card  pb-4">
                    <div class="card-header main-card-head">
                        <h5 class=""> <i class="fas fa-1x fa-th-large "></i> Router Entry </h5>
                        <a href="RouterSetupView.aspx" class="btn btn-sm btn-info">
                            <%--@*<i data-feather="plus" style="width: 16px !important; height: 16px !important;"></i>&nbsp;New Entry*@--%>
                            <i data-feather="corner-up-right" style="width: 16px !important; height: 16px !important;"></i> Back to list
                        </a>
                    </div>
                    <div class="card-body">

                       

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<input id="masterId" value="0" style="display:none" /><script src="../assets/js/jquery-3.6.0.min.js"></script>
    <script src="../assets/js/select2.js"></script>        
    <script src="~/assets/jquery-ui.min.js"></script>
    <link href="~/assets/jquery-ui.min.css" rel="stylesheet" />
    <script src="~/assets/vendors/core/core.js"></script>
    <script src="../assets/vendors/datatables.net/jquery.dataTables.js"></script>
    <script src="../assets/vendors/datatables.net/dataTables.buttons.min.js"></script>

    <script>


        var RowId = 0;
        var Rowcount = 0;

        $(function () {
            var masterid = getUrlVars()["id"];
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);
            }

        let id = $('#masterId').val();

        if (id > 0) {
            GetData(id);
        } else {
            GetDegree();
        }

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
    function IsActiveChange() {
        var isActive = $('#customSwitch1').is(':checked');
        $('#acttxt').text("");
        if (isActive) {
            $('#acttxt').text("Active Date:");

        } else {
            $('#acttxt').text("Inactive  Date:");
        }
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
        function Validation() {

            $('#mainName').removeClass('is-invalid');
     
             isValid = true;
            if ($('#mainName').val() == "") {

                $('#mainName').addClass("is-invalid");
                ValidationTooltip("#v-mainName", "Please fill out of this field!");
                isValid = false;
            }

            var count = 0;

            for (var c = 0; c < Rowcount; c++) {

                RowId = c;
                RowId++;

                var check = $("input[name='CheckBox[" + RowId + "].rowCount']").is(':checked');
                if (check != true) {
                    count++;
                }
            }

            if (count == c) {
                _errorWithMsg("Please!! Add Details");
                return false;
            }

        return isValid;
    }



        function Save() {

            if (Validation()) {
            
                            FinalSave();
            

        }


        }


        function GetDegree() {


            var urlpath = 'RouterSetupEntry.aspx/GetmarketByTerryTori';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                beforeSend: function() {
                },
                success: function (data) {
                    data = data.d;
                    $('#tabH').show();
                    var result = JSON.parse(data);


                    var html = "<table id='mytable' cellpadding='10'  class='table greyGridTable table-striped table-hover'>";
                    var dates = [];

                    for (var i = 0; i < result.length; i++) {

                        RowId++;
                        Rowcount++;

                        if (i == 0) {

                            dates.push(result[i].Name);

                            html += "<tr>";
                            html += "<td style='border-right: 5px solid #003842;border-bottom:5px solid white;font-size:22px;'> " + result[i].Name + "</td>";
                            html += "<td  style='border-bottom:5px solid white;'>";
                            html += "<h6>  <span style='font-weight:normal'> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount' /> <input type = 'hidden' name ='Territory[" + RowId + "].TId' value = " + result[i].TerritoryId + " />  <input type = 'hidden'  name ='Market[" + RowId + "].MId' value = " + result[i].MarketId + " /> " + result[i].MarketName + "</span></h6>";
                        }
                        else {

                            if (jQuery.inArray(result[i].Name, dates) == -1) {

                                html += " </td>";
                                dates.push(result[i].Name);
                                html += "<tr>";
                                html += "<td style='border-right: 5px solid #003842;border-bottom:5px solid white;font-size:22px;'> " + result[i].Name + "</td>";
                                html += "<td  style='border-bottom:5px solid white;'>";
                                html += "<h6>  <span style='font-weight:normal'> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount' /> <input type = 'hidden' name ='Territory[" + RowId + "].TId' value = " + result[i].TerritoryId + " />  <input type = 'hidden'  name ='Market[" + RowId + "].MId' value = " + result[i].MarketId + " /> " + result[i].MarketName + "</span></h6>";
                            }
                            else {
                                html += "<h6>  <span style='font-weight:normal'> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount' /> <input type = 'hidden' name ='Territory[" + RowId + "].TId' value = " + result[i].TerritoryId + " />  <input type = 'hidden'  name ='Market[" + RowId + "].MId' value = " + result[i].MarketId + " /> " + result[i].MarketName + "</span></h6>";
                           }
                        }

                    }

                    html += "</table>"

                    $('#tableDetail').html(html);



                    //    $('#tabH').show();
                    //    var result = JSON.parse(data);
                    //    var row = "";
                    //    $('#dtTableBody').html("");
                    //    for (var i = 0; i < result.length; i++) {
                    //        var TId = result[i].TerritoryId;
                    //        var MId = result[i].MarketId;
                    //        RowId++;
                    //        row += "<tr style=''>";
                    //        row += "<td style=' border-bottom: 10px solid white;pading:200px;'>" + (RowId) + ")" + result[i].Name +" </td>";
                    //        row += "<td  style='border-left: 6px solid #003842;border-bottom: 10px solid white;'><div style='pading:10px!important;'> <p> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount' /> " + result[i].MarketName + "</p> </div></td>";
                    //        row += "<td>" + '<input type = "hidden" style = "text-align:center" id = "HfFieldName"  name ="Territory[' + RowId + '].TId" value = "' + TId + '" />' + "</td>";
                    //        row += "<td>" + '<input type = "hidden" style = "text-align:center" id = "HfField"  name ="Market[' + RowId + '].MId" value = "' + MId + '" />' + "</td>";
                    //        row += "</tr>";
                    //    }

                    //    $('#dtTableBody').html(row);
                    //},

                },
                complete: function () {
                    //$('#dtTb').dataTable({
                    //    "ordering": false
                    //});
                }
            });
        }


           function GetDegree() {


               var urlpath = 'RouterSetupEntry.aspx/"GetmarketByTerryTori';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                beforeSend: function() {
                },
                success: function (data) {
                    data = data.d;
                    $('#tabH').show();
                    var result = JSON.parse(data);


                    var html = "<table id='mytable' cellpadding='10'  class='table greyGridTable table-striped table-hover'>";
                    var dates = [];

                    for (var i = 0; i < result.length; i++) {
                        debugger;
                        RowId++;
                        Rowcount++;

                        if (i == 0) {

                            dates.push(result[i].Name);

                            html += "<tr>";
                            html += "<td style='border-right: 5px solid #003842;border-bottom:5px solid white;font-size:22px;'> " + result[i].Name + "</td>";
                            html += "<td  style='border-bottom:5px solid white;'>";
                            html += "<h6>  <span style='font-weight:normal'> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount' /> <input type = 'hidden' name ='Territory[" + RowId + "].TId' value = " + result[i].TerritoryId + " />  <input type = 'hidden'  name ='Market[" + RowId + "].MId' value = " + result[i].MarketId + " /> " + result[i].MarketName + "</span></h6>";
                        }
                        else {

                            if (jQuery.inArray(result[i].Name, dates) == -1) {

                                html += " </td>";
                                dates.push(result[i].Name);
                                html += "<tr>";
                                html += "<td style='border-right: 5px solid #003842;border-bottom:5px solid white;font-size:22px;'> " + result[i].Name + "</td>";
                                html += "<td  style='border-bottom:5px solid white;'>";
                                html += "<h6>  <span style='font-weight:normal'> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount' /> <input type = 'hidden' name ='Territory[" + RowId + "].TId' value = " + result[i].TerritoryId + " />  <input type = 'hidden'  name ='Market[" + RowId + "].MId' value = " + result[i].MarketId + " /> " + result[i].MarketName + "</span></h6>";
                            }
                            else {
                                html += "<h6>  <span style='font-weight:normal'> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount' /> <input type = 'hidden' name ='Territory[" + RowId + "].TId' value = " + result[i].TerritoryId + " />  <input type = 'hidden'  name ='Market[" + RowId + "].MId' value = " + result[i].MarketId + " /> " + result[i].MarketName + "</span></h6>";
                           }
                        }

                    }

                    html += "</table>"

                    $('#tableDetail').html(html);



                    //    $('#tabH').show();
                    //    var result = JSON.parse(data);
                    //    var row = "";
                    //    $('#dtTableBody').html("");
                    //    for (var i = 0; i < result.length; i++) {
                    //        var TId = result[i].TerritoryId;
                    //        var MId = result[i].MarketId;
                    //        RowId++;
                    //        row += "<tr style=''>";
                    //        row += "<td style=' border-bottom: 10px solid white;pading:200px;'>" + (RowId) + ")" + result[i].Name +" </td>";
                    //        row += "<td  style='border-left: 6px solid #003842;border-bottom: 10px solid white;'><div style='pading:10px!important;'> <p> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount' /> " + result[i].MarketName + "</p> </div></td>";
                    //        row += "<td>" + '<input type = "hidden" style = "text-align:center" id = "HfFieldName"  name ="Territory[' + RowId + '].TId" value = "' + TId + '" />' + "</td>";
                    //        row += "<td>" + '<input type = "hidden" style = "text-align:center" id = "HfField"  name ="Market[' + RowId + '].MId" value = "' + MId + '" />' + "</td>";
                    //        row += "</tr>";
                    //    }

                    //    $('#dtTableBody').html(row);
                    //},

                },
                complete: function () {
                    //$('#dtTb').dataTable({
                    //    "ordering": false
                    //});
                }
            });
        }

        function FinalSave() {

            var jsonData = {};

            jsonData["RouterMasterId"] = $('#masterId').val();
            jsonData["RouterName"] = $('#mainName').val();

            var jsonObjs = [];

            //for (var i = 0; i < $('#dtTableBody tr').length; i++) {

            //    debugger;
            //    var theObj = {};
            //    RowId = i;
            //    RowId++;

            //    var TerritoryId = $("input[name='Territory[" + RowId + "].TId']").val();
            //    var MarketId = $("input[name='Market[" + RowId + "].MId']").val();
            //    var check = $("input[name='CheckBox[" + RowId + "].rowCount']").is(':checked');
            //    if (check == true) {
            //        theObj["TerritoryId"] = TerritoryId;
            //        theObj["MarketId"] = MarketId;
            //        jsonObjs.push(theObj);
            //        jsonData["RouterDetails"] = jsonObjs;
            //    }
            //}

      
            for (var i = 0; i < Rowcount; i++) {
                var theObj = {};
                RowId = i;
                RowId++;

                var TerritoryId = $("input[name='Territory[" + RowId + "].TId']").val();
                var MarketId = $("input[name='Market[" + RowId + "].MId']").val();
                var check = $("input[name='CheckBox[" + RowId + "].rowCount']").is(':checked');
                debugger;
                if (check == true) {
                    theObj["TerritoryId"] = TerritoryId;
                    theObj["MarketId"] = MarketId;
                    jsonObjs.push(theObj);
                    jsonData["RouterDetails"] = jsonObjs;
                }
            }

            var urlpath = 'RouterSetupEntry.aspx/Save_RouterSetup';
            $.ajax({
                //data: jsonData,
                data: JSON.stringify({ 'masterData': jsonData }),
                url: urlpath,
                contentType: "application/json; charset=utf-8",
                type: "POST",
                beforeSend: function () {
                    //_open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    result = result.d;
                    //_close_LoadingPopUp_WithMsg();

                    if (result.isSuccess == true) {
                        alert('Data saved successfully');
                        var url = '../DoctorModule_UI/RouterSetupView.aspx';
                                window.location.href = url;
                        
                    } else {
                        //_saveErrorDuplicate();
                    }
                },
                error: function (data) {
                    //_close_LoadingPopUp_WithMsg();
                    //_saveError();
                },
            });
        }

        function GetData(id) {

            var urlpath = 'RouterSetupEntry.aspx/GetRouterEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {

                    $("#btnSave").html(" <i class='fas fa-check-square'></i>&nbsp;Update Information");
                    $('#mainName').val(data.RouterName);

                    GetRouterDetails(data.RouterMasterId);
                    //if (data.IsActive) {
                    //    $('#customSwitch1').prop('checked', true);

                    //} else {
                    //    $('#customSwitch1').prop('checked', false);

                    //}
                },
                complete: function() {
                }
            });
        }

        function GetRouterDetails(id) {

            var urlpath = 'RouterSetupEntry.aspx/GetmarketByTerryTori_ById';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'Id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                beforeSend: function() {
                },
                success: function (data) {
                    data = data.d;
                    $('#tabH').show();
                    var result = JSON.parse(data);


                    var html = "<table id='mytable' cellpadding='10'  class='table greyGridTable table-striped table-hover'>";
                    var dates = [];

                    for (var i = 0; i < result.length; i++) {
                        debugger;
                        RowId++;
                        Rowcount++;

                        if (i == 0) {

                            dates.push(result[i].Name);

                            html += "<tr>";
                            html += "<td style='border-right: 5px solid #003842;border-bottom:5px solid white;font-size:22px;'> " + result[i].Name + "</td>";
                            html += "<td  style='border-bottom:5px solid white;'>";
                            html += "<h6>  <span style='font-weight:normal'> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount'  /> <input type = 'hidden' name ='Territory[" + RowId + "].TId' value = " + result[i].TerritoryId + " />  <input type = 'hidden'  name ='Market[" + RowId + "].MId' value = " + result[i].MarketId + " /> " + result[i].MarketName + result[i].IactiveInactive + "</span></h6>";
                            //if (result[i].disabled == 'disabled') {

                            //    html += "<h6>  <span style='font-weight:normal'> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount' " + result[i].disabled + " /> <input type = 'hidden' name ='Territory[" + RowId + "].TId' value = " + result[i].TerritoryId + " />  <input type = 'hidden'  name ='Market[" + RowId + "].MId' value = " + result[i].MarketId + " /> " + result[i].MarketName + result[i].IactiveInactive + "</span></h6>";
                               
                            //}
                            //else {

                            //    html += "<h6>  <span style='font-weight:normal'> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount' 'checked'  /> <input type = 'hidden' name ='Territory[" + RowId + "].TId' value = " + result[i].TerritoryId + " />  <input type = 'hidden'  name ='Market[" + RowId + "].MId' value = " + result[i].MarketId + " /> " + result[i].MarketName + result[i].IactiveInactive + "</span></h6>";
                             
                            //}
                        }
                        else {

                            if (jQuery.inArray(result[i].Name, dates) == -1) {

                                html += " </td>";
                                dates.push(result[i].Name);
                                html += "<tr>";
                                html += "<td style='border-right: 5px solid #003842;border-bottom:5px solid white;font-size:22px;'> " + result[i].Name + "</td>";
                                html += "<td  style='border-bottom:5px solid white;'>";

                                html += "<h6>  <span style='font-weight:normal'> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount'  /> <input type = 'hidden' name ='Territory[" + RowId + "].TId' value = " + result[i].TerritoryId + " />  <input type = 'hidden'  name ='Market[" + RowId + "].MId' value = " + result[i].MarketId + " /> " + result[i].MarketName + result[i].IactiveInactive + "</span></h6>";

                                //if (result[i].disabled == 'disabled') {
                                    
                                //    html += "<h6>  <span style='font-weight:normal'> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount' " + result[i].disabled + " /> <input type = 'hidden' name ='Territory[" + RowId + "].TId' value = " + result[i].TerritoryId + " />  <input type = 'hidden'  name ='Market[" + RowId + "].MId' value = " + result[i].MarketId + " /> " + result[i].MarketName + result[i].IactiveInactive + "</span></h6>";
                           
                                //}
                                //else {
                                    
                                //    html += "<h6>  <span style='font-weight:normal'> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount' 'checked' /> <input type = 'hidden' name ='Territory[" + RowId + "].TId' value = " + result[i].TerritoryId + " />  <input type = 'hidden'  name ='Market[" + RowId + "].MId' value = " + result[i].MarketId + " /> " + result[i].MarketName + result[i].IactiveInactive + "</span></h6>";
                              
                                //}
                               
                            }
                            else {
                                html += "<h6>  <span style='font-weight:normal'> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount'  /> <input type = 'hidden' name ='Territory[" + RowId + "].TId' value = " + result[i].TerritoryId + " />  <input type = 'hidden'  name ='Market[" + RowId + "].MId' value = " + result[i].MarketId + " /> " + result[i].MarketName + result[i].IactiveInactive + "</span></h6>";
                                //if (result[i].disabled == 'disabled') {

                                //    html += "<h6>  <span style='font-weight:normal'> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount' " + result[i].disabled + " /> <input type = 'hidden' name ='Territory[" + RowId + "].TId' value = " + result[i].TerritoryId + " />  <input type = 'hidden'  name ='Market[" + RowId + "].MId' value = " + result[i].MarketId + " /> " + result[i].MarketName + result[i].IactiveInactive + "</span></h6>";
                           
                                //}
                                //else {

                                //    html += "<h6>  <span style='font-weight:normal'> <input type='checkbox' id='CheckBox'  name='CheckBox[" + RowId + "].rowCount'  'checked'  /> <input type = 'hidden' name ='Territory[" + RowId + "].TId' value = " + result[i].TerritoryId + " />  <input type = 'hidden'  name ='Market[" + RowId + "].MId' value = " + result[i].MarketId + " /> " + result[i].MarketName + result[i].IactiveInactive + "</span></h6>";
                          
                                //}
                            }
                        }

                    }

                    html += "</table>"

                    $('#tableDetail').html(html);


                },
                complete: function () {
                    check();
                }
            });
        }

        function check () {
            for (var i = 0; i < Rowcount; i++) {
              
                RowId = i;
                RowId++;      
                $("input[name='CheckBox[" + RowId + "].rowCount']").prop('checked', true)             
            }
        }

    </script>

}

</asp:Content>

