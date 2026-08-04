<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ApprovalStepMap.aspx.cs" Inherits="UserPermission_ApprovalStepMap" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Approval Setup</div>
                
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

                   <div class="row" style="display:none;">
                <div class="col-2">&nbsp;</div>
                
                <div class="col-8">
                    <div class="form-group row">
                        <label for="typeSelect" class="col-sm-3 col-form-label">Type </label>
                        <div class="col-sm-5">
                            <select id="typeSelect" name="typeSelect" class="form-select form-select-sm mb-3 mySelect2 " >
                                <option value="0">Select One</option>
                                <option value="1">Web</option>
                                <option selected value="2">App</option>
                            </select>
                            <span id="v-typeSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
                        </div>
                    </div>
                </div>
           </div>
            <div class="row">
                <div class="col-2">&nbsp;</div>
                <div class="col-8">
                    <div class="form-group row">
                        <label for="menuSelect" class="col-sm-3 col-form-label">Menu </label>
                        <div class="col-sm-5">

                             <div class="input-group">
                            <select id="menuSelect" name="menuSelect" class="form-select form-select-sm mb-3 mySelect2 " >
                                
                            </select>
                            <span id="v-menuSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
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
                        <label for="roleSelect" class="col-sm-3 col-form-label"> Role Type  </label>
                        <div class="col-sm-5">
                             <div class="input-group">
                            <select id="roleSelect" name="roleSelect" class="form-select form-select-sm mb-3 mySelect2 "  ></select>
                            <span id="v-roleSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
                      
                            <%--  <span class="text_Link"> <button type="button" id="btnrefresh2"    onclick="ReloadUserRole()">
                                            <i class="fa fa-refresh"></i>
                                        </button></span>    --%>
                                  <span class="input-group-text text-c-red">*</span>
                             </div>
                        </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-2">&nbsp;</div>
                <div class="col-8">
                    <div class="form-group row">
                        <label for="roleFSelect" class="col-sm-3 col-form-label"> Role Type Froward  </label>
                        <div class="col-sm-5">
                              <div class="input-group">
                            <select id="roleFSelect" name="roleSelect" class="form-select form-select-sm mb-3 mySelect2 " ></select>
                            <span id="v-roleFSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                     <%-- <span class="text_Link"> <button type="button" id="btnrefresh"    onclick="ToReloadUserRole()">
                                            <i class="fa fa-refresh"></i>
                                        </button></span>    --%>
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
                        <label for="ordertxt" class="col-sm-3 col-form-label">Order</label>
                        <div class="col-sm-5">
                              <div class="input-group">
                            <input type="text" id="ordertxt" class="form-control form-control-sm clsDecimal" />
                            <span id="v-ordertxt" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                  <span class="input-group-text text-c-red">*</span>
                        </div>
                        </div>
                    </div>
                </div>
            </div>
                        <br />
            <div class="row">
                <div class="col-2">&nbsp;</div>
                <div class="col-8">
                    <div class="form-group row">
                        <label for="ordertxt" class="col-sm-3 col-form-label"> </label>
                          <div class="col-sm-5">
                        <button type="button" id="addtolistbtn" class="btn btn-sm btn-success  pull-right"  ><i class="fa fa-plus-circle"></i> Add to list</button>
                        
                    </div>
                    </div>
                </div>
            </div>
            <br />
            
                        <br />
                        
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <table id="dtTble" class="table table-striped table-bordered table-hover">
                                    <thead>
                                    <tr>
                                        
                                        <th>Role Type</th>
                                        <th>Order</th>
                                        
                                        <th>Delete</th>

                                    </tr>
                                    </thead>
                                    <tbody id="dtTableBody">
                                    </tbody>
                                </table>


                            </div>
                            
                        </div>
            <div class="row">
                <div class="col-2">&nbsp;</div>
                <div class="col-8">

                    <div class="form-group row">
                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                        <div class="col-sm-9">
                            <button type="button"  id="btnSave" class="btn btnMyDesignSearch   btn-sm"   onclick="Save()">
                                            <i class="fa fa-check"></i>Submit
                                        </button>
                                        <button type="button" class="btn btnMyDesignReset   btn-sm"  onclick="ResetLink()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </button>
                            
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
<input id="masterId" value="0" style="display:none" />
     

    <script>


        $(function () {
            $(".clsDecimal").keypress(function (event) {

                $(this).val($(this).val().replace(/[^0-9\.]/g, ''));
                if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                    /* if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {*/
                    $("#v-ordertxt").html("Number Only").stop().show().fadeOut("slow");

                    return false;
                }
            });
        });

        function ResetLink() {
            location.reload();
        }
        var MaltiThana = "";

        var thana = "";



    $(function () {

        GetFromRole(0);
        GetToRole(0);
        GetMenu(0);
        $("#addtolistbtn").click(function () {
            var roleid = $('#roleFSelect option:selected').val();
            var rolename = $('#roleFSelect option:selected').html();
            var order = $('#ordertxt').val();

            if (roleid != "0") {
                if (order != "") {



                    if (validationForOrder(order, roleid)) {
                        AddData(rolename, roleid, order);
                    }
                }
                else {
                    alert("Please Select Order!")
                }
            }
            else {
                alert("Please Select Role Froward!")
            }
        });

        $("#roleSelect").change(function () {
            

            GetAppMapData();
        });

        $("#menuSelect").change(function () {

            $('#dtTableBody').html("");
            GetFromRole(0);

        });

        $("#typeSelect").change(function () {
            
            var id = $('#typeSelect').val();
            
            GetMenu(0);
        });

        
        //$("input[type='checkbox']").change(function () {
        //    this.attr("checked", "checked");
        //});

    });


        function ReloadUserRole() {
            GetFromRole(0);

        }


        function ToReloadUserRole() {
            GetToRole(0);

        }

    function GetFromRole(id) {
        var urlpath = 'ApprovalStepMap.aspx/GetUserRole';
        SelectOption_ListObjectReturns_Async_True(urlpath, $('#roleSelect'), 'RoleTypeId', 'RoleType', id);
        $('#roleSelect').select2();
        }
    function GetToRole(id) {
        var urlpath = 'ApprovalStepMap.aspx/GetUserRole';
        SelectOption_ListObjectReturns_Async_True(urlpath, $('#roleFSelect'), 'RoleTypeId', 'RoleType', id);
        $('#roleFSelect').select2();
        }
        function GetMenu(id) {
            var urlpath = 'ApprovalStepMap.aspx/GetMenu';
            SelectOption_ListObjectReturns_Async_True(urlpath, $('#menuSelect'), 'SL', 'ManuName', id);
            $('#menuSelect').select2();
           
            

        }



        function validationForOrder(order, roleid) {

            debugger;
            var Isvalid = true;
            var NotValid = false;

            var countCh = 0;
            var countRole = 0;

            $('#dtTble > tbody > tr').each(function (i) {
                RowId = i;
                RowId++;
                //<input type="hidden" value="'+roleId+'" id="roleid' + (i + 1) + '" name="roleid">
                //<input type="hidden" value="'+roleId+'" id="roleid' + (i + 1) + '" name="roleid"
                /* {*//*var Cb = $("input[name='CheckBox[" + RowId + "].rowCount']").is(':checked');*//*}*/
              
                var Cb = $('#order' + i).html()
 
                 

                var Role = $('#roleid' + i).val();
              

                if (Cb == order) {
                    countCh++;
               
                }
                if (Role == roleid) {
                    countRole++;
                }

            })

            if (countCh != 0) {

                alert("Order Already Exist!!!")
                return NotValid;
            }
            if (countRole != 0) {

                alert("Role Already Exist!!!")
                return NotValid;
            }
            return Isvalid;
        }

    function AddData(rolename,roleId,order) {
        var i = $('#dtTble > tbody > tr:last').index();


        var html = '<tr id="addru' + (i + 1) + '">' +
            '<td><input type="hidden" value="'+roleId+'" id="roleid' + (i + 1) + '" name="roleid"> '+rolename+'</td>' +
            '<td id="order'+(i+1)+'">'+order+'</td>' +
            '<td><button class="btn btn-primary mr-2" onclick="DelU(' + (i + 1) + ')">Remove</button></td>' +
            '</tr>';
        $('#dtTableBody').append(html);


    }

    function DelU(id) {
        debugger;
        
        $('#addru' + id).remove();


        
    }

        function GetAppMapData() {
            var menuId = $('#menuSelect').val();
            var id = $('#roleSelect').val();
            

            var urlpath = 'ApprovalStepMap.aspx/LoadApprovalMap';
            $.ajax({
                url: urlpath,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ 'roleId': id, 'typeId': menuId }),
                //data: { roleId:id},
                async: true,
                beforeSend: function () {
                },
                success: function (data) {
                    data = data.d;
                    $('#tabH').show();
                    var result = (data);
                    var row = "";
                    $('#dtTableBody').html("");
                    if (result.length > 0) {
                        for (var i = 0; i < result.length; i++) {
                            AddData(result[i].RoleType, result[i].RoleTypeId, result[i].Order);

                            //<button class='btn-outline-danger btn-xs mb-1 mb-md-0' onclick='DeleteClick(" + result[i].EmpInfoId + ")'><i class='fas fa-trash' aria-hidden='true'></i></button>
                        }
                    }
                    else {
                        $("dtTableBody").empty();
                        var roleid = $('#roleSelect option:selected').val();
                        var rolename = $('#roleSelect option:selected').html();
                        var order = '1';
                        AddData(rolename, roleid, order);
                    }
                   

                    //$('#dtTableBody').html(row);
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
                beforeSend: function() {
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
                            row += "<td>" + (result[i].ParentName) + "</td>";
                        } else {
                            if (result[i].ParentName != result[i - 1].ParentName) {
                                row += "<td>" + (result[i].ParentName) + "</td>";
                            } else {
                                row += "<td></td>";
                            }                         
                        }
                        
                        row += "<td>" +  (result[i].ManuName) + "</td>";
                        

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
            
                            FinalSave();
            

        }

    }
    function FinalSave() {
     
        var fromrole = $('#roleSelect').val();
        var menuid = $('#menuSelect').val();
        
        var jsonData = {};
        var jsonObjs = [];
        jsonData["MenuId"] = menuid;
        jsonData["FromRoleId"] = fromrole;


        $('#dtTble > tbody > tr').each(function (i) {

            var theObj = {};
            theObj["ToRoleId"] = $('#roleid' + i).val();
            theObj["Order"] = $('#order'+i).html();
            jsonObjs.push(theObj);    
            

            

        });
        jsonData["ApprovalMapDetails"] = jsonObjs;
        

        var urlpath = 'ApprovalStepMap.aspx/SaveMenu';
        $.ajax({
            data: JSON.stringify({ 'approvalMapMaster':jsonData }),
                //data: jsonData,
                url: urlpath,
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
                beforeSend: function () {

                },
            success: function (result) {

                //result = result.d;
                //if (result.isSuccess == true) {

                    successalert('Operation successful!', 'Success', 'ApprovalStepMap.aspx');
                //}
                

                //else {
                //    faildalert('Operation Faild!', 'Faild');
                //}
                    
                    

                },
                error: function (data) {
                    
                }


            });
    }


    </script>


</asp:Content>

