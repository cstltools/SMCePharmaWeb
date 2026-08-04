<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="GroupWisePromoQtyEntry.aspx.cs" Inherits="PromoAlloc_GroupWisePromoQtyEntry" %>

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

      .chkChoice label {
            padding-left: 2px;
            padding-right: 2px;
        }
</style>


        <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Group Wise Product Allocation </div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../PromoAlloc/GroupWisePromoQtyView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">

                                 <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                         <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
 <asp:HiddenField runat="server" ID="id_mastetID"/>
                                         
                                                 <script type="text/javascript">
                                                     function pageLoad() {
                                                         $('.datepicker').pickadate({
                                                             selectMonths: true,
                                                             selectYears: true
                                                         })
                                                         $('.mySelect2').select2({
                                                             theme: 'bootstrap4',
                                                             width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                             placeholder: $(this).data('placeholder'),
                                                             allowClear: Boolean($(this).data('allow-clear')),
                                                         });
                                                     }

                                                     var dateNow = new Date();
                                                     $('.datepickess').datepicker("setDate", dateNow);
                                                     minDate: new Date() // to disable privious dates 
                                                 </script>
                        <div class="row">&nbsp;</div>
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">Month:  </label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                       <asp:DropDownList  runat="server"   id="ddlmonth" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

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
                                                <asp:DropDownList  runat="server"   id="ddlYear" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

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
                                        <label for="mainName" class="col-sm-3 col-form-label">Group:  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                               <asp:DropDownList  runat="server" AutoPostBack="true" OnSelectedIndexChanged="groupname_SelectedIndexChanged"  id="groupname" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                <span id="v-groupname" class="invalid-tooltip fade hide" data-delay="2000">
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
                                        <label for="mainName" class="col-sm-3 col-form-label">Product:  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:DropDownList  runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlProduct_OnSelectedIndexChanged"  id="ddlProduct" class="form-select form-select-sm mb-3 mySelect2" ></asp:DropDownList>

                                                <span id="v-ddlProduct" class="invalid-tooltip fade hide" data-delay="2000">
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
                                            <label for="mainName" class="col-sm-3 col-form-label">Stock:  </label>

                                            <div class="col-sm-7">
                                                <div class="input-group">
                                                    <asp:TextBox runat="server" ID="stockTextBox" CssClass="form-select form-select-sm mb-3"></asp:TextBox>
                                                    <%--<asp:DropDownList  runat="server"   id="DropDownList1" class="form-select form-select-sm mb-3 mySelect2" ></asp:DropDownList>--%>

                                                    <span id="v-ddlProduct" class="invalid-tooltip fade hide" data-delay="2000">
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
                                        <label for="mainName" class="col-sm-3 col-form-label"><asp:CheckBox runat="server" ID="chkQty" CssClass="chkChoice" AutoPostBack="true" OnCheckedChanged="chkQty_CheckedChanged" Text=" Is Common QTY:" />  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox   runat="server"  AutoPostBack="true" OnTextChanged="amount_TextChanged"  id="amount" class=" form-control form-control-sm mb-3 clsDecimal" ></asp:TextBox>

                                                <span id="v-amount" class="invalid-tooltip fade hide" data-delay="2000">
                                                </span>
                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div> 
    
                                 
                                    </div>
                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>


                                      <div class="row">
                                
                                <div class="col-12">
                                    <div class="table-responsive" id="MainGradeDiv">

                                         

                                                            <asp:GridView ID="gv_List" runat="server" AutoGenerateColumns="False"
                                
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                                  <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfMIOId" Value='<%#Eval("MIOId")%>' />

                                              <asp:HiddenField runat="server" ID="hfEmpInfoId" Value='<%#Eval("EmpInfoId")%>' />

                                             <asp:HiddenField runat="server" ID="hfTerritoryId" Value='<%#Eval("TerritoryId")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                           <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" CssClass="form-control-sm"  AutoPostBack="true"  Checked= '<%# Convert.ToBoolean(Eval("CheckStatus"))%>'   OnCheckedChanged="chkSelect_CheckedChanged"  runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                    <asp:BoundField DataField="EmpMasterCode" HeaderText="Employee Code" />
                                    <asp:BoundField DataField="EmpName" HeaderText="Employee Name" />
                                    
                                    <asp:BoundField DataField="TerritoryName" HeaderText="Territory Name" />
                               
                              

                                                                            <asp:TemplateField HeaderText="QTY">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtQty" runat="server" Text='<%#Eval("Qty") %>' CssClass="form-control form-control-sm mb-3 clsDecimal"></asp:TextBox>
                                                           
                                                    </ItemTemplate>
                                                </asp:TemplateField>
 
                                    
                                </Columns>
                            </asp:GridView>

                                        

                                    </div>
                                    

                                </div>
                                
                            </div>
                        <br />
                            <br />
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-9">
                                         <asp:LinkButton  OnClick="btnSave_Click" Visible="false" OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                             <asp:LinkButton  OnClick="btnSave_Click"  Visible="false"   runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm" OnClientClick="return sweetAlertConfirm_Update(this);"   >
                                            <i class="fa fa-check"></i>Update
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                  
                        

      </ContentTemplate>
                                     </asp:UpdatePanel>
                       

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

           LoadGroup();
           LoadProduct();
           $(".clsDecimal").keypress(function (event) {

               $(this).val($(this).val().replace(/[^0-9\.]/g, ''));
               if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                   /* if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {*/
                   /*  $("#v-AllowedMilagePerKM").html("Number Only").stop().show().fadeOut("slow");*/

                   return false;
               }
           });
           var id = $('#ContentPlaceHolder1_masterId').val();
         
           var me = getUrlVars()["id"];
           if (me != null) {
               debugger;
               $('#masterId').val(me);
               GetData(me);
           }
           $('.mySelect2').select2({
               theme: 'bootstrap4',
               width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
               placeholder: $(this).data('placeholder'),
               allowClear: Boolean($(this).data('allow-clear')),
           });

           $('.datepicker').pickadate({
               selectMonths: true,
               selectYears: true
           });

           Month();

           $('#year').yearselect({

               start: 2000,

               end: 2030

           });
           $("#ddlProduct").change(function () {
               GetStockData($("#ddlProduct").val());
           });
           


       });
       function LoadGroup() {
           SelectOption_DtTable_Async_True("PromoMIOTag.aspx/LoadGroup", $('#groupname'), "PromoGroupId", "PromoGroupName", 0);

       }


       function LoadProduct() {
           SelectOption_DtTable_Async_True("PromoMIOTag.aspx/LoadProduct", $('#ddlProduct'), "ProductId", "ProductName", 0);

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
               html += '<option value="' + (m + 1) + '">' + monthNames[m] + '</option>'
               date.setMonth(date.getMonth() + 1);
           }
           select.html(html);

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

           $('#month').removeClass('is-invalid');
           RemoveValidationTooltip("#v-month");

           $('#year').removeClass('is-invalid');
           RemoveValidationTooltip("#v-year");

           $('#groupname').removeClass('is-invalid');
           RemoveValidationTooltip("#v-groupname");

           $('#ddlProduct').removeClass('is-invalid');
           RemoveValidationTooltip("#v-ddlProduct");

           $('#amount').removeClass('is-invalid');
           RemoveValidationTooltip("#v-amount");

           isValid = true;
           if ($('#month').val() == "" || $('#month').val() == "0" || $('#month').val() == null) {
               $('#month').addClass("is-invalid");
               ValidationTooltip("#v-month", "Please fill out of this field!");
               isValid = false;
           }
         
           if ($('#year').val() == "" || $('#year').val() == "0" || $('#year').val() == null) {
               $('#year').addClass("is-invalid");
               ValidationTooltip("#v-year", "Please fill out of this field!");
               isValid = false;
           }


           if ($('#groupname').val() == "" || $('#groupname').val() == "0" || $('#groupname').val() == null) {
               $('#groupname').addClass("is-invalid");
               ValidationTooltip("#v-groupname", "Please fill out of this field!");
               isValid = false;
           }

           if ($('#ddlProduct').val() == "" || $('#ddlProduct').val() == "0" || $('#ddlProduct').val() == null) {
               $('#ddlProduct').addClass("is-invalid");
               ValidationTooltip("#v-ddlProduct", "Please fill out of this field!");
               isValid = false;
           }

           
           if ($('#amount').val() == "") {
               $('#amount').addClass("is-invalid");
               ValidationTooltip("#v-amount", "Please fill out of this field!");
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

           jsonData["GWPromoQtyId"] = $('#masterId').val();
           jsonData["Year"] = $('#year').val();
           jsonData["Month"] = $('#month').val();
           jsonData["Qty"] = $('#amount').val();
           jsonData["PromoGroupId"] = $('#groupname').val();
           jsonData["ProductId"] = $('#ddlProduct').val();
           
           
           $.ajax({
               url: 'GroupWisePromoQtyEntry.aspx/SaveGroupWiseQty',
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

                       successalert('Operation successful!', 'Success', 'GroupWisePromoQtyList.aspx');
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
               url: 'GroupWisePromoQtyEntry.aspx/LoadGroupWiseQtyById',
               type: 'post',
               contentType: 'application/json;charset=utf-8',
               dataType: 'json',
               data: "{id : '" + id + "'}",
               async: true,
               success: function (data) {

                   var result = JSON.parse(data.d);

                   $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");

                 
                   $('#groupname').val(result[0].PromoGroupId).trigger('change');
                   $('#amount').val(result[0].Qty);
                   $('#year').val(result[0].Year).trigger('change');
                   $('#month').val(result[0].Month).trigger('change');
                   $('#ddlProduct').val(result[0].ProductId).trigger('change');

               },
               complete: function () {
               }
           });
       }
       function GetData(id) {
           $.ajax({
               url: 'GroupWisePromoQtyEntry.aspx/LoadGroupWiseQtyById',
               type: 'post',
               contentType: 'application/json;charset=utf-8',
               dataType: 'json',
               data: "{id : '" + id + "'}",
               async: true,
               success: function (data) {

                   var result = JSON.parse(data.d);

                   $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");


                   $('#groupname').val(result[0].PromoGroupId).trigger('change');
                   $('#amount').val(result[0].Qty);
                   $('#year').val(result[0].Year).trigger('change');
                   $('#month').val(result[0].Month).trigger('change');
                   $('#ddlProduct').val(result[0].ProductId).trigger('change');

               },
               complete: function () {
               }
           });
       }

       function GetStockData(id) {
           $.ajax({
               url: 'GroupWisePromoQtyEntry.aspx/LoadStockQty',
               type: 'post',
               contentType: 'application/json;charset=utf-8',
               dataType: 'json',
               data: "{id : '" + id + "'}",
               async: true,
               success: function (data) {

                   var result = JSON.parse(data.d);

                   
                   $('#stockTextBox').val(result[0].Qty);
                   

               },
               complete: function () {
               }
           });
       }


   </script>

}
</asp:Content>

