<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DoctorDesignation.aspx.cs" Inherits="DoctorMaster_UI_DoctorDesignation" %>

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


        <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Doctor's Designation Entry </div>

                <div class="ms-auto">
                    <div class="btn-group">

                        <a href="../DoctorMaster_UI/DoctorDesignationView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            

                    <div class="row">&nbsp;</div>
                        <div class="row">&nbsp;</div>
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">Designation name:  </label>

                                    
                                           <div class="col-sm-7">
                                          <div class="input-group">
                                        <input type="text" class="form-control form-control-sm mb-3 " required="true" id="mainName" placeholder="Designation name">

                                        <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                          <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                              <%--  <div class="form-group row" style="margin-top:7px;">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label><br />
                                    <div class="col-sm-7">
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="customSwitch1" checked="checked" onchange="IsActiveChange()" />
                                            <label style="padding-top:4px;" class="custom-control-label" for="customSwitch1"> Active</label>
                                        </div>
                                    </div>

                                </div>--%>

                                    <div class="form-group row" >
                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label>
                                        <br />
                                        <div class="col-sm-7">

                                            <div class="form-check form-switch">
													<input class="form-check-input" type="checkbox" id="customSwitch1" checked  onchange="IsActiveChange()">
												 <label  class="custom-control-label" for="customSwitch1">Active</label>
												</div>
                                          
                                          
                                        </div>

                                    </div>

                                       <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label" id="acttxt"> Active Date: </label>



                                       
                                    <div class="col-sm-7">
                                          <div class="input-group">
                                          <input id="acDate" type="text" class="datepicker form-control form-control-sm" autocomplete="off" placeholder="Select Date" >

                                        <span id="v-acDate" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                          <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 




                                 
         

                                </div>
                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                        <br />
                             <br />
                            

                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-9">
                                        <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm" style="background-color: #00bcd4;color: #fff;" onclick="Save()">
                                            <i class="fa fa-check"></i>&nbsp; Submit 
                                        </button>
                                        <button type="button" class="btn btnMyDesignReset   btn-sm" style="background-color: orangered; color: #fff;" onclick="ConfirmationClick()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset  </button>
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
    
    
    
    <asp:TextBox runat="server" ID="masterId" Style="display: none"></asp:TextBox>
     <script type="text/javascript">

    $(function () {     
        var id = $('#ContentPlaceHolder1_masterId').val();


        $('.datepicker').pickadate({
            selectMonths: true,
            selectYears: true
        });
        if (id > 0) {

           // $('#acDate').datepicker();

            $('#hRemarkDiv').show();
            GetDocDesignation(id);
        } else {
           // $('#acDate').datepicker("update", new Date());
        }     
    });


    function ConfirmationClick(parameters) {
        location.reload();
    }

    function newPage() {
        window.location.href = '../DoctorMaster_UI/DoctorDesignationView.aspx';
    }
    function IsActiveChange() {
        var isActive = $('#customSwitch1').is(':checked');
        $('#customSwitch1').text("");
        if (isActive) {
            $('#acttxt').text("Active Date: ");
        } else {
            $('#acttxt').text("Inactive Date: ");
        }
    }

    function Validation() {
            $('#mainName').removeClass('is-invalid');
            $('#acDate').removeClass('is-invalid');
            RemoveValidationTooltip("#v-mainName");
            RemoveValidationTooltip("#v-acDate");
            isValid = true;
            if ($('#mainName').val() == "") {
                $('#mainName').addClass("is-invalid");
                ValidationTooltip("#v-mainName", "Please fill out of this field!");
                isValid = false;
            }
            if ($('#acDate').val() == "") {
                $('#acDate').addClass("is-invalid");
                ValidationTooltip("#v-acDate", "Please fill out of this field!");
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

            FinalSave();
        }

    }
    function FinalSave() {

        var jsonData = {};
        jsonData["DesignationId"] = $('#ContentPlaceHolder1_masterId').val();
        jsonData["DesignationName"] = $.trim($('#mainName').val());
        jsonData["IsActive"] = $('#customSwitch1').is(':checked');
        jsonData["Activedate"] = $('#acDate').val();
    
        $.ajax({

            url: "DoctorDesignation.aspx/Save_DoctorDesignation",
            data: '{doctorDesignation: ' + JSON.stringify(jsonData) + '}',
            dataType: 'json',
            type: "POST",
            contentType: "application/json;charset=utf-8",
            async: true,   

                beforeSend: function () {
                    _open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    _close_LoadingPopUp_WithMsg();              
                    if (result.d.isSuccess == true) {
                        
                        //alert("Operation successfully done!!");
                        //var url = '../DoctorModule_UI/DoctorDesignationView.aspx';
                        //window.location.href = url;
                        successalert('Operation successful!', 'Success', 'DoctorDesignationView.aspx');

                    } else {                   
                        
                        faildalert('Already exists!', 'Faild');
                    }

                },
                error: function (result) {
                 // alert("Something went wrong...");
                 faildalert('Operation Faild!', 'Faild');
                }

            });
        }


    function GetDocDesignation(id) {
           
            $.ajax({
                url: 'DoctorDesignation.aspx/GetDoctorDesignationEditData',
                type: 'post',
                contentType: 'application/json;charset=utf-8',
                dataType: 'json',
                data: "{id : '" + id + "'}",
                async: true,              
                success: function (data) {
                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update ");
                             
                    $('#mainName').val(data.d.DesignationName);
                    $('#acDate').val(ToJavaScriptDate_Formater(data.d.Activedate));
          
                    if (data.d.IsActive) {
                        $('#customSwitch1').prop('checked', true);
                        $('#acttxt').text("Active Date: ");
                    } else {
                        $('#customSwitch1').prop('checked', false);
                        $('#acttxt').text("Inactive Date: ");
                    }
                   

                },
                complete: function() {

                }
            });
        }

    

     </script>
</asp:Content>

