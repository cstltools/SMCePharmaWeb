<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="UserPermission.aspx.cs" Inherits="UserPermission_UserPermission" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style>

    .form-switch {
        padding-left: 2.5em;
    }

    .form-check {
        display: block;
        min-height: 1.5rem;
        padding-left: 1.5em;
        margin-bottom: .125rem;
    }
</style>

<style>


/*    #custom_table, th, td {
        border: 0.1em solid #CFCFCF;
        border-collapse: collapse;
    }

        #custom_table td {
            padding: 0.1em 6px !important;
        }

        #custom_table th {
            padding: 3px !important;
            background-color: #3C8BCA ;
            color: white;
        }

        #custom_table tr:nth-child(even) {
            background-color: #eee;
        }

        #custom_table tr:nth-child(odd) {
            background-color: #fff;
        }
*/   

</style>
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Menu Permission</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <%--<a href="../DoctorModule_UI/ZoneSetup.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>--%>
                      

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
                        <label for="roleSelect" class="col-sm-3 col-form-label"> Role Type </label>
                        <div class="col-sm-5">
                            <div class="input-group">
                            <select id="roleSelect" name="roleSelect" class="form-select form-select-sm mb-3 mySelect2" onchange="GetRoleMenuData()"></select>
                            <span id="v-roleSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                 <span class="input-group-text text-c-red">*</span>
                             <%--  <a target="_blank" href="../DoctorModule_UI/UserRoleEntry.aspx">Role</a>  <span class="text_Link"> <button type="button" id="btnrefresh"    onclick="ReloadUserRole()">  <i class="fa fa-refresh"></i>
                                        </button></span>--%>
                        </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-2">&nbsp;</div>
                <div class="col-8">
                    <div class="form-group row">
                        <label for="typeSelect" class="col-sm-3 col-form-label">Type </label>
                        <div class="col-sm-5">
                             <div class="input-group">
                            <select  id="typeSelect" name="roleSelect" class="form-select form-select-sm mb-3 mySelect2 readonly-select" onchange="GetRoleMenuData()">
                                  <option value="0">Select One</option>
                                <option selected  value="1">Web</option>
                                <option value="2">App</option>
                            </select>
                            <span id="v-typeSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                  <span class="input-group-text text-c-red">*</span>
                        </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-9">

                                          <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm"   onclick="Save()">
                                            <i class="fa fa-check"></i>Submit
                                        </button>
                                        <button type="button" class="btn btnMyDesignReset   btn-sm"  onclick="ResetLink()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </button>
                                       
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                  
                        <br />
                        <div class="row">
                            <div class="col-1">&nbsp;</div>
                            <div class="col-10">

                                <table id="dtTble" class="table table-striped table-bordered table-hover">
                                    <thead>
                                    <tr>
                                        <th>#SL</th>
                                        <th>Permission</th>
                                        <th>Menu Parent Name</th>
                                        <th>Menu Name</th>
                                        <th>Add </th>
                                        <th>View</th>
                                        <th>Edit</th>
                                        <th>Delete</th>

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
        </div>
                                
  <div id="coverScreen" class="divWaitingJquery ">
        <img src="../images/Spinner.gif" style="width:180px" class="position-set" />
                </div>


<%--    <div class="container-fluid" style="width: 100% !important;">

    <div class="page-body m-t-20">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="card main-card  pb-4">
                    <div class="card-header main-card-head">
                        <h5 class=""> <i class="fas fa-1x fa-th-large "></i> Menu Permission </h5>
                        <!--<a href="@Url.Action("AreaView", "AreaSetup")" class="btn btn-sm btn-info">-->
                        <%--@*<i data-feather="plus" style="width: 16px !important; height: 16px !important;"></i>&nbsp;New Entry*@--%>
                        <!--<i data-feather="corner-up-right" style="width: 16px !important; height: 16px !important;"></i> Back to list
                        </a>-->
                    <%--</div>

                    <div class="card-body">
                        <br />--%>



                        <%--@*<div class="row mt-1">
            <div class="col-2">&nbsp;</div>
            <div class="col-8">
                <div class="form-group row">
                    <label for="mainName" class="col-sm-3 col-form-label">Area Name </label>
                    <div class="col-sm-7">
                        <input type="text" class="form-control" id="mainName" autocomplete="off" placeholder="Enter Area Name">
                        <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000"></span>
                    </div>
                    <span class="text-sm-left text-c-red">*</span>
                </div>

            </div>
        </div>*@--%>



<%--                        <div class="row mt-1">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="roleSelect" class="col-sm-3 col-form-label">Role </label>
                                    <div class="col-sm-5">
                                        <select id="roleSelect" name="roleSelect" class="form-control" onchange="GetRoleMenuData()"></select>
                                        <span id="v-roleSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-1">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="typeSelect" class="col-sm-3 col-form-label">Type </label>
                                    <div class="col-sm-5">
                                        <select id="typeSelect" name="roleSelect" class="form-control" onchange="GetRoleMenuData()">
                                            <option value="1">Web</option>
                                            <option value="2">App</option>
                                        </select>
                                        <span id="v-typeSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <br />
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-9">
                                        <button type="button" id="btnSave" class="btn btn-sm btn-primary mb-2" style="background-color: #00bcd4;color: #fff;" onclick="Save()">
                                            <i class="fas fa-check-square"></i>&nbsp; Save Information
                                        </button>
                                        <button type="button" class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" onclick="ConfirmationClick()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset Information </button>
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                        
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <table id="dtTble" class="table table-striped table-bordered table-hover">
                                    <thead>
                                    <tr>
                                        <th>#SL</th>
                                        <th>Permission</th>
                                        <th>Menu Parent Name</th>
                                        <th>Menu Name</th>
                                        <th>Add </th>
                                        <th>View</th>
                                        <th>Edit</th>
                                        <th>Delete</th>

                                    </tr>
                                    </thead>
                                    <tbody id="dtTableBody">
                                    </tbody>
                                </table>


                            </div>
                            
                        </div>

                        <br />
                        


                    </div>
                </div>
            </div>
        </div>
    </div>
</div>--%>

    <style>
.readonly-select {
    pointer-events: none;
    background-color: #e9ecef;
    opacity: 1;
}
</style>
<input id="masterId" value="0" style="display:none" />

<script src="~/CustomScript/_myCusGen_Func.js"></script>

    <script>
        function ResetLink() {
            location.reload();
        }

        var MaltiThana = "";

        var thana = "";

        function ReloadUserRole() {
            GetRole(0);

        }

    $(function () {
        $("#coverScreen").hide();
        GetRole(0);

        
        //$("input[type='checkbox']").change(function () {
        //    this.attr("checked", "checked");
        //});

    });





    function GetRole(id) {
        var urlpath = 'UserPermission.aspx/GetUserRole';
        SelectOption_ListObjectReturns_Async_True(urlpath, $('#roleSelect'), 'UserRoleID', 'RoleName', id);
        $('#roleSelect').select2();
    }
        function CheckRowCheck(i) {
            if ($('#permission' + i).is(":checked")) {

                debugger;
                var disabled = $('#permission' + i).prop("disabled");

                if (!$('#add' + i).prop("disabled")) {
                    $('#add' + i).prop('checked', true);
                }
                if (!$('#view' + i).prop("disabled")) {
                    $('#view' + i).prop('checked', true);
                }
                if (!$('#delete' + i).prop("disabled")) {
                    $('#delete' + i).prop('checked', true);
                }
                if (!$('#edit' + i).prop("disabled")) {
                    $('#edit' + i).prop('checked', true);
                }
                
                
            } else {
                $('#add' + i).prop('checked', false);
                $('#view' + i).prop('checked', false);
                $('#delete' + i).prop('checked', false);
                $('#edit' + i).prop('checked', false);
            }
            
        }

        function GetRoleMenuData() {
            debugger;
            var id = $('#typeSelect').val();
            if (id == "1") {
                GetRoleMenuWebData();
            } if (id == "2")  {
                GetRoleMenuAppData();
            }



        }
        function un(o) {
            return o != null ? o : '';
        }
        function GetRoleMenuAppData() {
            var type = $('#typeSelect').val();
            var id = $('#roleSelect').val();

            var urlpath = 'UserPermission.aspx/LoadMenuIsApp';
            $.ajax({
                url: urlpath,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ 'roleId': id, 'typeId': type }),
                //data: { roleId:id},
                async: true,
                beforeSend: function () {
                    $("#coverScreen").show();
                },
                success: function (data) {
                    data = data.d;
                    $('#tabH').show();
                    var result = (data);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {
                        var discheck = '';
                        row += "<tr>";

                        row += "<td>" + (i + 1) + "<input type='hidden' id='slid" + i + "' value='" + result[i].SL + "'></td>";

                        if (result[i].Permission == "1") {
                            discheck = discheck + ' checked';
                        }
                        row += "<td><input type='checkbox'  id='permission" + i + "' value='" + i + "' " + discheck + " onchange='CheckRowCheck(" + i + ")'></td>";

                        if (i == 0) {
                            row += "<td>" + un(result[i].ParentName) + "</td>";
                        } else {
                            if (result[i].ParentName != result[i - 1].ParentName) {
                                row += "<td>" + un(result[i].ParentName) + "</td>";
                            } else {
                                row += "<td></td>";
                            }
                        }

                        row += "<td>" + un(result[i].ManuName) + "</td>";


                        if (result[i].Add == "0") {
                            discheck = ' disabled';
                        }
                        if (result[i].RAdd == "1") {
                            discheck = discheck + ' checked';
                        }
                        row += "<td><input type='checkbox' style='display:none;'  id='add" + i + "' value='1' " + discheck + "></td>";
                        discheck = '';
                        if (result[i].View == "0") {
                            discheck = ' disabled';
                        }
                        if (result[i].RView == "1") {
                            discheck = discheck + ' checked';
                        }
                        row += "<td><input type='checkbox' id='view" + i + "'  style='display:none;'  value='1' " + discheck + "></td>";


                        discheck = '';

                        if (result[i].Edit == "0") {
                            discheck = ' disabled';
                        }
                        if (result[i].REdit == "1") {
                            discheck = discheck + ' checked';
                        }
                        row += "<td><input type='checkbox' style='display:none;' id='edit" + i + "' value='1' " + discheck + "></td>";

                        discheck = '';

                        if (result[i].Delete == "0") {
                            discheck = ' disabled';
                        }
                        if (result[i].RDelete == "1") {
                            discheck = discheck + ' checked';
                        }
                        row += "<td><input type='checkbox' style='display:none;' id='delete" + i + "' value='1' " + discheck + "></td>";

                        row += "</tr>";

                        //<button class='btn-outline-danger btn-xs mb-1 mb-md-0' onclick='DeleteClick(" + result[i].EmpInfoId + ")'><i class='fas fa-trash' aria-hidden='true'></i></button>
                    }

                    $('#dtTableBody').html(row);
                }, complete: function() {
                    $("#coverScreen").hide();

                }

            });
        }

        function GetRoleMenuWebData() {
          
            var id=$('#roleSelect').val();
            var type = $('#typeSelect').val();
            var urlpath = 'UserPermission.aspx/LoadMenu';
            $.ajax({
                url: urlpath,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ 'roleId': id,'typeId':type }),
                //data: { roleId:id},
                async: true,
                beforeSend: function () {
                    $("#coverScreen").show();
                },
                success: function(data) {
                    data = data.d;
                    $('#tabH').show();
                    var result = (data);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {
                        var discheck = '';
                        row += "<tr>";

                        row += "<td>" + (i + 1) + "<input type='hidden' id='slid" + i + "' value='" + result[i].SL + "'></td>";
                    
                        if (result[i].Permission == "1") {
                            discheck = discheck + ' checked';
                        }
                        row += "<td><input type='checkbox'  id='permission" + i + "' value='" + i + "' " + discheck + " onchange='CheckRowCheck("+i+")'></td>";

                        if (i == 0) {
                            row += "<td>" + un(result[i].ParentName) + "</td>";
                        } else {
                            if (result[i].ParentName != result[i - 1].ParentName) {
                                row += "<td>" + un (result[i].ParentName) + "</td>";
                            } else {
                                row += "<td></td>";
                            }                         
                        }
                        
                        row += "<td>" +  (result[i].ManuName) + "</td>";
                        
                        discheck = '';
                        if (result[i].Add == "0") {
                            discheck = ' disabled';
                        }
                        if (result[i].RAdd == "1") {
                            discheck = discheck + ' checked';
                        }
                        row += "<td><input type='checkbox'  id='add" + i + "' value='1' " + discheck + "></td>";


                        discheck = '';
                        if (result[i].View == "0") {
                            discheck = ' disabled';
                        }
                        if (result[i].RView == "1") {
                            discheck = discheck + ' checked';
                        }
                        row += "<td><input type='checkbox' id='view" + i + "' value='1' " + discheck + "></td>";
                  

                        discheck = '';

                        if (result[i].Edit == "0") {
                            discheck = ' disabled';
                        }
                        if (result[i].REdit == "1") {
                            discheck = discheck + ' checked';
                        }
                        row += "<td><input type='checkbox' id='edit" + i + "' value='1' " + discheck + "></td>";

                        discheck = '';

                        if (result[i].Delete == "0") {
                            discheck = ' disabled';
                        }
                        if (result[i].RDelete == "1") {
                            discheck = discheck + ' checked';
                        }
                        row += "<td><input type='checkbox' id='delete" + i + "' value='1' " + discheck + "></td>";
                                                                
                        row += "</tr>";

                        //<button class='btn-outline-danger btn-xs mb-1 mb-md-0' onclick='DeleteClick(" + result[i].EmpInfoId + ")'><i class='fas fa-trash' aria-hidden='true'></i></button>
                    }

                    $('#dtTableBody').html(row);
                }, complete: function () {
                    $("#coverScreen").hide();

                }
                
            });
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

         $('#roleSelect').removeClass('is-invalid');
         RemoveValidationTooltip("#v-roleSelect");
         var isValid = true;
         if ($('#roleSelect').val() == 0) {
             $('#roleSelect').addClass("is-invalid");
             ValidationTooltip("#v-roleSelect", "Please fill out of this field!");
                isValid = false;
            }
            return isValid;
        }



    function Save() {

        if (Validation()) {

            if ($('#btnSave').prop('disabled')) {
                return; // already saving; ignore duplicate click
            }
            FinalSave();

        }

    }
    function FinalSave() {
        $('#btnSave').prop('disabled', true);

        var dv = $('#roleSelect').val();
        var roleId = dv.toString();
        var jsonData = {};
        var jsonObjs = [];
        jsonData["Id"] = 0;

        debugger;
        var roleSelectid = $('#roleSelect').val();
        var typeSelectId = $('#typeSelect').val();


        $('#dtTble > tbody > tr').each(function (i) {
            var theObj = {};
            theObj["RoleId"] = $('#roleSelect').val();
            theObj["SL"] = $('#slid'+i).val();

            //var addc = $('#add'+i).prop('checked');
            //var viewc = $('#view' + i).is(":checked");
            //var delc = $('#delete' + i).is(":checked");
            //var editc = $('#edit' + i).is(":checked");

            theObj["Add"] = $('#add'+i).is(":checked");
            theObj["View"] = $('#view' + i).is(":checked");
            theObj["Delete"] = $('#delete' + i).is(":checked");
            theObj["Edit"] = $('#edit' + i).is(":checked");
            theObj["Permission"] = $('#permission' + i).is(":checked");

            // Send the row if ANY checkbox is checked, not just the master
            // "Permission" checkbox. The server deletes all existing rows
            // for this Role+Type and re-inserts only what is submitted here,
            // so excluding a row that has Add/View/Edit/Delete checked (but
            // not Permission) silently drops that permission on save.
            if ($('#permission' + i).is(":checked") || $('#add' + i).is(":checked")
                || $('#view' + i).is(":checked") || $('#delete' + i).is(":checked")
                || $('#edit' + i).is(":checked")) {
                jsonObjs.push(theObj);
            }

            

        });
        jsonData["MenuRoles"] = jsonObjs;
        var datas = jsonData;

        var urlpath = 'UserPermission.aspx/SaveMenu';
        $.ajax({
            data: JSON.stringify({ 'arole': jsonData, 'roleSelectid': roleSelectid, 'typeSelectId': typeSelectId }),
                //data: jsonData,
                url: urlpath,
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
                beforeSend: function () {
                    $("#coverScreen").show();

                },
                success: function (result) {
                    //debugger;
                    //alert('Data saved successfully');
                    //var url = '../UserPermission/UserPermission.aspx';
                    //            window.location.href = url;
                    
                    successalert('Operation successful!', 'Success', 'UserPermission.aspx');
            }
            , complete: function () {
                $("#coverScreen").hide();
                $('#btnSave').prop('disabled', false);

            }
            ,
                error: function (data) {

                }


            });
    }


    </script>



</asp:Content>

