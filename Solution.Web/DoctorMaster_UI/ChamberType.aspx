<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ChamberType.aspx.cs" Inherits="DoctorMaster_UI_ChamberType" %>

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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Doctor's Chamber Type Entry</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorMaster_UI/ChamberTypeView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                    <label for="mainName" class="col-sm-3 col-form-label">Chamber Type:  </label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                        <input type="text" class="form-control form-control-sm mb-3 " required="true" id="mainName" placeholder="Chamber Type">

                                        <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                          <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
    
                                 
                                </div>
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
 

     <asp:TextBox runat="server" id="masterId" style="display:none"></asp:TextBox>

   <script type="text/javascript">

       $(function () {

           var id = $('#ContentPlaceHolder1_masterId').val();




           $('.datepicker').pickadate({
               selectMonths: true,
               selectYears: true
           });


           if (id > 0) {
            //   $('#acDate').datepicker();

               GetData(id);
           } else {

              // $('#acDate').datepicker("update", new Date());

           }
       });



       function ConfirmationClick(parameters) {
           location.reload();
       }


       $('#customSwitch1').on("change", function (e) {
           var isActive = $('#customSwitch1').is(':checked');
           $('#acttxt').text("");
           if (isActive) {
               $('#acttxt').text("Active Date:");
           } else {
               $('#acttxt').text("Inactive  Date:");
           }
       });


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
               //                FinalSave();
               //            }
               //        },
               //        Cancel: function () {
               //        }
               //    }
               //});
               FinalSave();
           }
       }

       function FinalSave() {
           var jsonData = {};
           jsonData["ChamberId"] = $('#ContentPlaceHolder1_masterId').val();
           jsonData["ChamberName"] = $('#mainName').val().trim();
           jsonData["IsActive"] = $('#customSwitch1').is(':checked');
           jsonData["Activedate"] = $('#acDate').val();
           $.ajax({
               url: 'ChamberType.aspx/Save_DoctorChamber',
               data: '{chamber: ' + JSON.stringify(jsonData) + '}',
               dataType: 'json',
               type: "POST",
               contentType: "application/json;charset=utf-8",
               async: true,
               success: function (result) {
                   if (result.d.isSuccess == true) {
                       //alert("Operation successfully done!!");
                       //var url = '../DoctorMaster_UI/ChamberTypeView.aspx';
                       //window.location.href = url;

                       successalert('Operation successful!', 'Success', 'ChamberTypeView.aspx');

                   } else {
                       
                       faildalert('lready Exits!', 'Faild');
                   }
               },

               error: function (result) {

                   faildalert('Operation Faild!', 'Faild');

               }
           });
       }

       function GetData(id) {
           $.ajax({
               url: 'ChamberType.aspx/GetDoctorDegreeEditDataa',
               type: 'post',
               contentType: 'application/json;charset=utf-8',
               dataType: 'json',
               data: "{id : '" + id + "'}",
               async: true,
               success: function (data) {
                   $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");
                   $('#mainName').val(data.d.ChamberName);
                   $('#acDate').val(ToJavaScriptDate_Formater(data.d.Activedate));
                   if (data.d.IsActive) {
                       $('#customSwitch1').prop('checked', true);
                       $('#acttxt').text("Active Date:");
                   } else {
                       $('#customSwitch1').prop('checked', false);
                       $('#acttxt').text("Inactive  Date:");
                   }
               },
               complete: function () {
               }
           });
       }


   </script>

}
</asp:Content>

