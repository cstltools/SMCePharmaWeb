<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="MonthlyTarget.aspx.cs" Inherits="Target_UI_MonthlyTarget" %>

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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Monthly Target Entry</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../Target_UI/MonthlyTargetView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                    <label for="mainName" class="col-sm-3 col-form-label">Month:  </label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                        <select id="month" class="form-select form-select-sm mb-3 mySelect2">

                                        </select>

                                        <span id="v-month" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                          <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
    
                                 
                                </div>
                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                            <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-8">
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Year:  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <select id="year" class="form-select form-select-sm mb-3 mySelect2">

                                                </select>

                                                <span id="v-year" class="invalid-tooltip fade hide" data-delay="2000">
                                                </span>
                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div> 
    
                                 
                                    </div>
                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>
                            <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-8">
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Amount:  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <input id="amount" class="form-control form-control-sm mb-3" />

                                                <span id="v-amount" class="invalid-tooltip fade hide" data-delay="2000">
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
       $('.mySelect2').select2({
           theme: 'bootstrap4',
           width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
           placeholder: $(this).data('placeholder'),
           allowClear: Boolean($(this).data('allow-clear')),
       });
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
           Month();

           $('#year').yearselect({
               
               start: 2000,
               
               end: 2030
               
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

       function Month() {

           var date = new Date();
           date.setMonth(date.getMonth() + 1);
           var months = 12;
           var monthNames = ["January", "February", "March", "April", "May", "June",
               "July", "August", "September", "October", "November", "December"
           ];
           var select = $('#month');
           var html = '';
           for (var i = 0; i < months; i++) {
               var m = date.getMonth();
               html += '<option value="' + (m+1) + '">' + monthNames[m] + '</option>'
               date.setMonth(date.getMonth() + 1);
           }
           select.html(html);

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
           $('#amount').removeClass('is-invalid');
           //$('#acDate').removeClass('is-invalid');
           //RemoveValidationTooltip("#v-mainName");
           RemoveValidationTooltip("#v-amount");
           isValid = true;
           if ($('#amount').val() == "") {
               $('#amount').addClass("is-invalid");
               ValidationTooltip("#v-amount", "Please fill out of this field!");
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

           jsonData["MTargetId"] = $('#masterId').val();
           jsonData["Year"] = $('#year').val();
           jsonData["Month"] = $('#month').val();
           jsonData["Amount"] = $('#amount').val();
           
           $.ajax({
               url: 'MonthlyTarget.aspx/SaveTarget',
               data: '{aTargetDao: ' + JSON.stringify(jsonData) + '}',
               dataType: 'json',
               type: "POST",
               contentType: "application/json;charset=utf-8",
               async: true,
               success: function (result) {
                   
                   result = result.d;
                   //_close_LoadingPopUp_WithMsg();
                   /*alert(result.isSuccess);*/
                   if (result == "True") {
                       successalert('Operation successful!', 'Success', 'MonthlyTargetView.aspx');
                   }
                 
                   else {
                       faildalert('Already Exist!', 'Faild');

                   }


              

                   
               },

               error: function (result) {

                   faildalert('Operation Faild!', 'Faild');

               }
           });
       }

       function GetData(id) {
           $.ajax({
               url: 'MonthlyTarget.aspx/LoadMonthlyTargetById',
               type: 'post',
               contentType: 'application/json;charset=utf-8',
               dataType: 'json',
               data: "{id : '" + id + "'}",
               async: true,
               success: function (data) {

                   var result = JSON.parse(data.d);

                   $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");


                   $('#month').val(result[0].Month);
                   $('#year').val(result[0].Year);
                   $('#amount').val(result[0].Amount);
                   
               },
               complete: function () {
               }
           });
       }


   </script>

}
</asp:Content>

