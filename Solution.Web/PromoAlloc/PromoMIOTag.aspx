<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="PromoMIOTag.aspx.cs" Inherits="PromoAlloc_PromoMIOTag" %>

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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> MIO Tagging Entry</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <%--<a href="../PromoAlloc/PromoGroupList.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>--%>


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
                                    <label for="mainName" class="col-sm-3 col-form-label">Promo Group:  </label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                        <asp:DropDownList  runat="server"  id="groupname" class="form-select form-select-sm mb-3 mySelect2" AutoPostBack="true" OnSelectedIndexChanged="groupname_SelectedIndexChanged"></asp:DropDownList>

                                        <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                          <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
    
                                 
                                </div>
                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                        <br />
                            
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-9">
                                       <asp:LinkButton  OnClick="btnSave_Click"  OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
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
                                 <br />
                            
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
                               
                              
 
                                    
                                </Columns>
                            </asp:GridView>

                                        

                                    </div>
                                    

                                </div>
                                
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
  <%-- <script type="text/javascript">


       $("#CheckAll").click(function () {

           for (var i = 0; i < $('#dtTableBody tr').length; i++) {
               RowId = i;
               RowId++;

               $('#check' + RowId).not(this).prop('checked', this.checked);
               //'check" + i + "'
               //$("input[name='CheckBox[" + RowId + "].rowCount']").not(this).prop('checked', this.checked);
           }


       });
       $(function () {
           $('.mySelect2').select2({
               theme: 'bootstrap4',
               width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
               placeholder: $(this).data('placeholder'),
               allowClear: Boolean($(this).data('allow-clear')),
           });
           var id = $('#ContentPlaceHolder1_masterId').val();
           //LoadGroup();
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
           //$('#mainName').removeClass('is-invalid');
           //$('#acDate').removeClass('is-invalid');
           //RemoveValidationTooltip("#v-mainName");
           //RemoveValidationTooltip("#v-acDate");
           isValid = true;
           //if ($('#mainName').val() == "") {
           //    $('#mainName').addClass("is-invalid");
           //    ValidationTooltip("#v-mainName", "Please fill out of this field!");
           //    isValid = false;
           //}

           //if ($('#acDate').val() == "") {
           //    $('#acDate').addClass("is-invalid");
           //    ValidationTooltip("#v-acDate", "Please fill out of this field!");
           //    isValid = false;
           //}
           return isValid;
       }

       function LoadGroup() {
           SelectOption_DtTable_Async_True("PromoMIOTag.aspx/LoadGroup", $('#groupname'), "PromoGroupId", "PromoGroupName", 0);

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

           jsonData["PromoGroupId"] = $('#groupname').val();
           //jsonData["PromoGroupName"] = $('#groupname').val();

           var jsonObjs = [];

           $('#dtTble > tbody > tr').each(function (index) {

               var theObj = {};


               //var id = idr.substring(4);

               if ($('#check'+index).prop("checked") == true) {

                   var mioid = $('#mio' + index).val();
                   theObj["MIOId"] = mioid;
                   jsonObjs.push(theObj);
               }

           });


           jsonData["adetail"] = jsonObjs;


           
           $.ajax({
               url: 'PromoMIOTag.aspx/SaveMIOTag',
               data: '{aTargetDao: ' + JSON.stringify(jsonData) + '}',
               dataType: 'json',
               type: "POST",
               contentType: "application/json;charset=utf-8",
               async: true,
               success: function (result) {
                   
                       //alert("Operation successfully done!!");
                       //var url = '../DoctorMaster_UI/ChamberTypeView.aspx';
                       //window.location.href = url;

                   successalert('Operation successful!', 'Success', 'PromoMIOTag.aspx');

                   
               },

               error: function (result) {

                   faildalert('Operation Faild!', 'Faild');

               }
           });
       }

       function GetData() {

           var id = $('#groupname').val();

           $.ajax({
               url: 'PromoMIOTag.aspx/LoadMIO',
               type: 'post',
               contentType: 'application/json;charset=utf-8',
               dataType: 'json',
               data: "{id : '" + id + "'}",
               async: true,
               success: function (data) {

                   var result = JSON.parse(data.d);

                   var row = "";
                   $('#dtTableBody').html("");
                   for (var i = 0; i < result.length; i++) {
                       row += "<tr>";
                       row += "<td>" + (i + 1) + "</td>";
                       if (result[i].CheckStatus == '1') {
                           row += "<td><input type='checkbox' id='check" + i + "' checked/> </td>";
                       } else {
                           row += "<td><input type='checkbox' id='check" + i + "' /> </td>";
                       }

                       
                       row += "<td>" + (result[i].EmpMasterCode) + "<input type='hidden' id='mio" + i + "' value='" + result[i].MIOId+"'></td>";

                       row += "<td>" + (result[i].EmpName) + "</td>";
                       row += "<td>" + (result[i].TerritoryName) + "</td>";
                       


                       ////if (result[i].IsActive) {
                       ////    row += "<td><span class='badge bg-success'>Active</span></td>";
                       ////} else {
                       ////    row += "<td><span class='badge bg-danger'>Inactive</span></td>";
                       ////}

                       ////if (result[i].IsDel == "Yes") {
                       ////    row += "<td><button class='btn-outline-warning    btn-xs mb-1 mb-md-0 ' onclick='editClick(" + result[i].ChamberId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> <button class='btn-outline-danger btn-xs mb-1 mb-md-0' onclick='DeleteClick(" + result[i].ChamberId + ")'><i class='fa fa-minus-circle' aria-hidden='true'></i></button> </td>";
                       ////} else {
                       ////    row += "<td><button class='btn-outline-warning    btn-xs mb-1 mb-md-0 ' onclick='editClick(" + result[i].ChamberId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> <button class='btn-outline-danger btn-xs mb-1 mb-md-0' disabled data-toggle='tooltip' data-placement='top' title='Can not be deleted !!' onclick='DeleteClick(" + result[i].ChamberId + ")'><i class='fa fa-minus-circle' aria-hidden='true'></i></button></td>";
                       ////}


                       //row += "<td><button class='btn-outline-warning    btn-xs mb-1 mb-md-0 ' onclick='editClick(" + result[i].PromoGroupId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> </td>";



                       row += "</tr>";
                   }
                   $('#dtTableBody').html(row);
                   
               },
               complete: function () {
               }
           });
       }


   </script>--%>




</asp:Content>

