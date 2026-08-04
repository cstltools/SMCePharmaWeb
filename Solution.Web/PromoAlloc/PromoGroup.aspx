<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="PromoGroup.aspx.cs" Inherits="PromoAlloc_PromoGroup" %>

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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Promo Group Entry</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../PromoAlloc/PromoGroupList.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                    <label for="mainName" class="col-sm-3 col-form-label">Promo Group Name:  </label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                        <input id="groupname" type="text" class="form-control form-control-sm mb-3 "  placeholder=" Promo Group Name" />

                                        <span id="v-groupname" class="invalid-tooltip fade hide" data-delay="2000">
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
 

     <%--<asp:TextBox runat="server" id="masterId" style="display:none"></asp:TextBox>--%>
    <input type="hidden" id="masterId" value="0"/>
    <script src="../assets/year-select.js"></script>
   <script type="text/javascript">

       $(function () {

           var id = $('#ContentPlaceHolder1_masterId').val();

           var me = getUrlVars()["id"];
           if (me != null) {
               debugger;
               $('#masterId').val(me);
               GetData(me);
           }
           

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
           $('#groupname').removeClass('is-invalid');
           
           RemoveValidationTooltip("#v-groupname");
         
           isValid = true;
           if ($('#groupname').val() == "") {
               $('#groupname').addClass("is-invalid");
               ValidationTooltip("#v-groupname", "Please fill out of this field!");
               isValid = false;
           }

           //if ($('#acDate').val() == "") {
           //    $('#acDate').addClass("is-invalid");
           //    ValidationTooltip("#v-acDate", "Please fill out of this field!");
           //    isValid = false;
           //}
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

           jsonData["PromoGroupId"] = $('#masterId').val();
           jsonData["PromoGroupName"] = $('#groupname').val();
           
           
           $.ajax({
               url: 'PromoGroup.aspx/SaveGroup',
               data: '{aTargetDao: ' + JSON.stringify(jsonData) + '}',
               dataType: 'json',
               type: "POST",
               contentType: "application/json;charset=utf-8",
               async: true,
               success: function (result) {
                   
                       //alert("Operation successfully done!!");
                       //var url = '../DoctorMaster_UI/ChamberTypeView.aspx';
                       //window.location.href = url;

                   result = result.d;


                   if (result.isSuccess == true) {

                       successalert('Operation successful!', 'Success', 'PromoGroupList.aspx');
                   }
                   else if (result.isValiCheck == true) {

                       faildalert('Data cannot be deactivated!', 'Faild');
                   }
                   else if (result.isDuplicateCheck == true) {

                       faildalert('Already Exist!', 'Faild');
                   }

                   else {
                       faildalert('Operation Faild!', 'Faild');
                   }

               

                   
               },

               error: function (result) {

                   faildalert('Operation Faild!', 'Faild');

               }
           });
       }

       function GetData(id) {
           $.ajax({
               url: 'PromoGroup.aspx/LoadPromoGroupById',
               type: 'post',
               contentType: 'application/json;charset=utf-8',
               dataType: 'json',
               data: "{id : '" + id + "'}",
               async: true,
               success: function (data) {

                   var result = JSON.parse(data.d);

                   $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");


                   $('#groupname').val(result[0].PromoGroupName);
                   //$('#year').val(result[0].Year);
                   //$('#amount').val(result[0].Amount);
                   
               },
               complete: function () {
               }
           });
       }


   </script>

}
</asp:Content>

