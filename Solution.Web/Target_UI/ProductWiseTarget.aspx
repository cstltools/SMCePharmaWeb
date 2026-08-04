<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ProductWiseTarget.aspx.cs" Inherits="Target_UI_ProductWiseTarget" %>

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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Product Wise Target Entry</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../Target_UI/ProductWiseTargetList.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                            <div class="row mt-1">
                                    <div class="col-2">&nbsp;</div>
                                    <div class="col-7">
                                        <div class="form-group row">
                                            <label for="DoctorName" class="col-sm-3 col-form-label">Group </label>
                                            <div class="col-sm-7">
                                                <div class="input-group">
                                                    <select class="form-select form-select-sm mb-3 mySelect2" id="ddlGroup"></select>
                                                    <span id="v-ddlGroup" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                    <span class="input-group-text text-c-red">*</span>
                                                </div>
                                            </div>


                                        </div>

                                    </div>
                                </div>



                                <div class="row mt-1">
                                    <div class="col-2">&nbsp;</div>
                                    <div class="col-7">
                                        <div class="form-group row">
                                            <label for="zoneSelect" class="col-sm-3 col-form-label">Zone </label>
                                            <div class="col-sm-7">
                                                <div class="input-group">
                                                    <select id="zoneSelect" name="zoneSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
                                                    <span id="v-zoneSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                    <span class="input-group-text text-c-red">*</span>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>

                                <div class="row mt-1">
                                    <div class="col-2">&nbsp;</div>
                                    <div class="col-7">
                                        <div class="form-group row">
                                            <label for="zoneSelect" class="col-sm-3 col-form-label">Area </label>
                                            <div class="col-sm-7">
                                                <div class="input-group">

                                                    <select id="areaSelect" name="areaSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
                                                    <span id="v-areaSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                    <span class="input-group-text text-c-red">*</span>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>

                                <div class="row mt-1">
                                    <div class="col-2">&nbsp;</div>
                                    <div class="col-7">
                                        <div class="form-group row">
                                            <label for="territorySelect" class="col-sm-3 col-form-label">Territory </label>
                                            <div class="col-sm-7">
                                                <div class="input-group">
                                                    <select id="territorySelect" name="territorySelect" class="form-select form-select-sm mb-3 mySelect2"></select>
                                                    <span id="v-territorySelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                    <span class="input-group-text text-c-red">*</span>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            
                            <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Product:  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <select id="product" class="form-select form-select-sm mb-3 mySelect2" >
                                                </select>

                                                <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000">
                                                </span>
                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div> 
    
                                 
                                    </div>
                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>

                            <div class="row mt-1">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-7">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">Month:  </label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                        <select id="month" class="form-select form-select-sm mb-3 mySelect2">

                                        </select>

                                        <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                          <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
    
                                 
                                </div>
                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                            <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Year:  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <select id="year" class="form-select form-select-sm mb-3 mySelect2">

                                                </select>

                                                <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000">
                                                </span>
                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div> 
    
                                 
                                    </div>
                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>

                             <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="amount" class="col-sm-3 col-form-label">Amount:  </label>

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
                            <div class="row mt-1">
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

           GetGroupInfo(0);
           LoadProduct(0);

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


           Month();

           $('#year').yearselect({
               
               start: 2000,
               
               end: 2030
               
           });



           $("#ddlGroup").on("change", function (e) {
               var groupId = $("#ddlGroup").val();
               if (groupId > 0) {
                   GetZone_ByGroup(groupId);
               }
           });

           $("#zoneSelect").on("change", function (e) {
               var zoneId = $("#zoneSelect").val();



               if (zoneId > 0) {
                   GetArea_ByZone(zoneId);
               }
           });

           $("#areaSelect").on("change", function (e) {
               debugger;
               var id = $("#areaSelect").val();
               if (id > 0) {
                   GetTerritory_ByAreaId(id);

               }
           });



       });


       function GetTerritory_ByAreaId(id) {
           _getTerritory_ByAreaId_Active($('#territorySelect'), 'TerritoryId', 'TerritoryName', id);
       }

       function GetArea_ByZone(id) {
           _getArea_ByZoneId_Active($('#areaSelect'), 'AreaId', 'AreaName', id);
       }
       function GetTerritory_ByAreaId_All(id, SetId) {
           _getTerritory_ByAreaId_All($('#territorySelect'), 'TerritoryId', 'TerritoryName', id, SetId);
       }

       function GetArea_All_ByZone(id, SetId) {
           _getArea_ByZoneId_All($('#areaSelect'), 'AreaId', 'AreaName', id, SetId);
       }
       function GetGroupInfo(id) {
           _GetGroupInfo_Active($('#ddlGroup'), 'GroupId', 'GroupName', id);
       }

       function GetGroupAllInfo(id) {
           _GetGroupInfo_All($('#ddlGroup'), 'GroupId', 'GroupName', id);
       }

       function GetZone_ByGroup(id) {

           _getZone_ByGroupId_Active($('#zoneSelect'), 'RegionId', 'RegionName', id);
       }
       function GetZone_All(id, SetId) {



           _getZone_ByGroupId_All_SetValue($('#zoneSelect'), 'RegionId', 'RegionName', id, SetId)
       }




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


           $('#territorySelect').removeClass('is-invalid');

           RemoveValidationTooltip("#v-territorySelect");
           isValid = true;
           if ($('#territorySelect').val() == "" || $('#territorySelect').val() == null || $('#territorySelect').val() == "") {
               $('#territorySelect').addClass("is-invalid");
               ValidationTooltip("#v-territorySelect", "Please fill out of this field!");
               isValid = false;
           }


           $('#product').removeClass('is-invalid');

           RemoveValidationTooltip("#v-product");
           isValid = true;
           if ($('#product').val() == "" || $('#product').val() == null || $('#product').val() == "") {
               $('#product').addClass("is-invalid");
               ValidationTooltip("#v-product", "Please fill out of this field!");
               isValid = false;
           }


           $('#amount').removeClass('is-invalid');
            
           RemoveValidationTooltip("#v-amount");
           isValid = true;
           if ($('#amount').val() == "") {
               $('#amount').addClass("is-invalid");
               ValidationTooltip("#v-amount", "Please fill out of this field!");
               isValid = false;
           }
           return isValid;
       }

       function LoadProduct() {
           SelectOption_DtTable_Async_false("ProductWiseTarget.aspx/LoadProduct", $('#product'), "ProductId", "ProductName", 0);
           $('#product').select2();


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

           jsonData["ProductSalesTargetId"] = $('#masterId').val();
           jsonData["Year"] = $('#year').val();
           jsonData["Month"] = $('#month').val();
           jsonData["GroupId"] = $('#ddlGroup').val();
           jsonData["RegionId"] = $('#zoneSelect').val();
           jsonData["AreaId"] = $('#areaSelect').val();
           jsonData["TerritoryId"] = $('#territorySelect').val();
           jsonData["ProductId"] = $('#product').val();
           jsonData["Amount"] = $('#amount').val();
           
           $.ajax({
               url: 'ProductWiseTarget.aspx/SaveTarget',
               data: '{aTargetDao: ' + JSON.stringify(jsonData) + '}',
               dataType: 'json',
               type: "POST",
               contentType: "application/json;charset=utf-8",
               async: true,
               success: function (result) {
                   
                       //alert("Operation successfully done!!");
                       //var url = '../DoctorMaster_UI/ChamberTypeView.aspx';
                       //window.location.href = url;

                   successalert('Operation successful!', 'Success', 'ProductWiseTarget.aspx');

                   
               },

               error: function (result) {

                   faildalert('Operation Faild!', 'Faild');

               }
           });
       }

       function GetData(id) {
           $.ajax({
               url: 'ProductWiseTarget.aspx/LoadMonthlyTargetById',
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
                   //GetGroupInfo(0);
                   $('#ddlGroup').val(result[0].GroupId).trigger('change');
                   GetZone_ByGroup(result[0].GroupId);

                   $('#zoneSelect').val(result[0].RegionId).trigger('change');
                   GetArea_ByZone(result[0].RegionId);
                   $('#areaSelect').val(result[0].AreaId).trigger('change');
                   GetTerritory_ByAreaId(result[0].AreaId);
                  $('#territorySelect').val(result[0].TerritoryId).trigger('change');
                   LoadProduct(result[0].ProductId);
                   $('#product').val(result[0].ProductId).trigger('change');

               },
               complete: function () {
               }
           });
       }


   </script>

}
</asp:Content>

