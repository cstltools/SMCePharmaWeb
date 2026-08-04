<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="MarketSetup.aspx.cs" Inherits="DoctorModule_UI_MarketSetup" %>
<%@ Register Src="~/MasterSetup_UI/IVMarketStructureMarket.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Market Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/MarketRecords.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                        
                            <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                     <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />

                                </div>
                            </div>

                                     <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Market Name </label>
                                        <div class="col-sm-8">
                                            <div class="input-group">
                                                 <asp:TextBox   runat="server"   class="form-control form-control-sm mb-3" id="mainName" autocomplete="off" placeholder="Enter Market Name"></asp:TextBox>
                                                <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                                            <div class="col-2" runat="server" id="divShowHide" visible="false">
                                <div class="form-group row"  style="display:none">
                                  <br />
                                    <div class="col-sm-12">
                                        <div class="form-check form-switch">
                                            <input type="checkbox" class="form-check-input" id="isStrucChange" checked  >
                                             
                                             <label  class="custom-control-label" for="isStrucChange">Is Structure Change</label>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            </div>
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


                            

                             <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                         <label for="DivisionSelect" class="col-sm-3 col-form-label">Division:  </label>

                                                            <div class="col-sm-8">
                                                                <asp:DropDownList runat="server"     AutoPostBack="true" OnSelectedIndexChanged="DivisionSelect_SelectedIndexChanged"  id="DivisionSelect" name="DivisionSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                                <span id="v-DivisionSelect" class="invalid-tooltip fade hide" data-delay="2000">
                                                                </span>


                                                            </div>
                                    </div>

                                </div>
                            </div>


                                <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                          <label for="DistrictSelect" class="col-sm-3 col-form-label">District:  </label>

                                                            <div class="col-sm-8">
                                                                 <asp:DropDownList runat="server"   OnSelectedIndexChanged="DistrictSelect_SelectedIndexChanged"  AutoPostBack="true"  id="DistrictSelect" name="DistrictSelect"  class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                                <span id="v-DistrictSelect" class="invalid-tooltip fade hide" data-delay="2000">
                                                                </span>


                                                            </div>
                                    </div>

                                </div>
                            </div>

                              <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                         <label for="ThanaSelect" class="col-sm-3 col-form-label">Thana:  </label>

                                                            <div class="col-sm-8">
                                                                  <div class="input-group">
                                                                <asp:DropDownList runat="server"    id="ThanaSelect" name="ThanaSelect"  class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                                <span id="v-ThanaSelect" class="invalid-tooltip fade hide" data-delay="2000">
                                                                </span>
   <span class="input-group-text text-c-red">*</span>

                                                            </div>
                                                            </div>
                                    </div>

                                </div>
                            </div>
                            

                             
                            <br/>
                            <h4>User Role Wise Station Type</h4>
                            <hr>
                             <div class="row mt-1">
                                  <div class="col-1">
                                      </div>
                                <div class="col-4">
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-4 col-form-label">User Type </label>
                                        <div class="col-sm-8">
                                            <div class="input-group">
                                                     <asp:DropDownList runat="server"    id="UserRoleSelect" name="UserRoleSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                <span id="v-UserRoleSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>

                                  <div class="col-4">
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-4 col-form-label">Station Type </label>
                                        <div class="col-sm-8">
                                            <div class="input-group">
                                                    <asp:DropDownList runat="server"    id="StationTypeSelect" name="StationTypeSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                <span id="v-StationTypeSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>

                                  <div class="col-2">
                                    <div class="form-group row">
                                         <asp:LinkButton runat="server" class="btn btn-sm btn-sm btn-outline-success" id="addButton" onclick="addButton_Click"><i class="fa fa-plus"></i>Add to list</asp:LinkButton>
                                                      
                                                        <span id="v-btnAddtolist" class="invalid-tooltip fade hide" data-delay="1000"></span>
                                        </div>
                                        </div>
                            </div>

                               <div class="form-group row">
                                                    <div class="table-responsive" id="MainGradeDiv">


                                                         <asp:GridView ID="gv_UserRole" runat="server" AutoGenerateColumns="False"
                                                                   ShowHeaderWhenEmpty="true"       CssClass="table table-bordered  text-center thead-dark">
                                                                    <Columns>

                                                                         <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfRoleTypeId" Value='<%#Eval("RoleTypeId")%>' />
                                             <asp:HiddenField runat="server" ID="hfStationTypeId" Value='<%#Eval("StationTypeId")%>' />
                                            
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                                                        
                                                                          <asp:TemplateField HeaderText="User Role">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_RoleType" runat="server" Text='<%#Eval("RoleType") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                                        
                                                <asp:TemplateField HeaderText="Station Type">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_StationTypeName" runat="server" Text='<%#Eval("StationTypeName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                        <asp:TemplateField HeaderText="Remove">
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="deleteImageButton" runat="server" OnClick="deleteImageButton_Click" CssClass="btn-danger  btn-sm mb-1 mb-md-0"
                                                                                    ><i class='fa fa-minus' aria-hidden='true'></i></asp:LinkButton>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>

                                                                    </Columns>
                                                                </asp:GridView>
 

                                                    </div>
                                                </div>


                      

                            <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                       <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label><br />
                                        <div class="col-sm-8">
                                            <div class="form-check form-switch">
                                               	<input class="form-check-input" type="checkbox" runat="server" onchange="IsActiveChange()" id="chkIsActive" checked>
												 <label  class="custom-control-label" for="chkIsActive">Active</label>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>

                                

                            <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="acDate" id="pacinTxt" class="col-sm-3 col-form-label">Active Date </label>
                                        <div class="col-sm-8">
                                            <div class="input-group">
                                                <asp:TextBox   runat="server"   id="acDate"  class="datepicker form-control form-control-sm mb-3" autocomplete="off" placeholder="Select Date"></asp:TextBox>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>


                            <br />
                            <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">

                                    <div class="form-group row">
                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                        <div class="col-sm-9">


  <asp:LinkButton  OnClick="btnSave_Click" Visible="false" OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                             <asp:LinkButton  OnClick="btnSave_Click"  Visible="false"   runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm" OnClientClick="return sweetAlertConfirm_Update(this);"   >
                                            <i class="fa fa-check"></i>Update
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server" id="restbtn" OnClick="restbtn_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>

                                        </div>
                                    </div>

                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>

                                       <br/>
                                       <br/>
                            <h4>Dependency list</h4>
                            <hr>

                                      <div class="form-group row">
                                                    <div class="table-responsive" id="MainGrwadeDiv">


                                                         <asp:GridView ID="gv_Count" runat="server" AutoGenerateColumns="False"
                                                                   ShowHeaderWhenEmpty="true"       CssClass="table table-bordered  text-center thead-dark">
                                                                    <Columns>

                                                                         <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                            
                                            
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                                                        
                                                                          <asp:TemplateField HeaderText="Particulars">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_Parti" runat="server" Text='<%#Eval("Parti") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                                        
                                                <asp:TemplateField HeaderText="Count">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_MarketIdCount" runat="server" Text='<%#Eval("MarketIdCount") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                 

                                                                    </Columns>
                                                                </asp:GridView>
 

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
      
     
    <input id="masterId" value="0" style="display: none" />
      

   <%-- <script>

        var roleList = [];

        var idd = 0;
        var idd2 = 0;
        function ResetLink() {
            location.reload();
        }
        function ValidationAddtoList() {



            $('#UserRoleSelect').removeClass('is-invalid');
            $('#StationTypeSelect').removeClass('is-invalid');

            RemoveValidationTooltip("#v-UserRoleSelect");
            RemoveValidationTooltip("#v-StationTypeSelect");

            isValid = true;

            if ($('#UserRoleSelect').val() == null || $('#UserRoleSelect').val() == "" || $('#UserRoleSelect').val() == "0") {


                $('#UserRoleSelect').addClass("is-invalid");
                ValidationTooltip("#v-UserRoleSelect", "Please fill out of this field!");
                isValid = false;
            }
            if ($('#StationTypeSelect').val() == null || $('#StationTypeSelect').val() == "" || $('#StationTypeSelect').val() == "0") {


                $('#StationTypeSelect').addClass("is-invalid");
                ValidationTooltip("#v-StationTypeSelect", "Please fill out of this field!");
                isValid = false;
            }
            

            return isValid;
        }

        function validationForOrder() {

            console.log(roleList);

            debugger;
            var Isvalid = true;

          


           // if ($.inArray('1', roleList) != -1 && $.inArray('2', roleList) != -1 && $.inArray('3', roleList) != -1) {

                
                Isvalid = true;

            //} else {

            //    Isvalid = false;

            //    alert("You should add at least one MIO,AM,DZSM !!");

            //}


            
            //$('#dtTble tbody tr').each(function (i) {
          
               
            //    i++;
               
                
            //    var FieldName = $("input[name='UserRole[" + i + "]']").val();
                 
            //    if (FieldName == "1") {
            //        countMIO++;

            //    }
            //    if (FieldName == "2") {
            //        countNSM++;

            //    }
            //    if (FieldName == "3") {
            //        countDZSM++;

            //    }
            //})

            //if (countMIO != 1) {

            //    alert("MIO must be added in list!!!");
            //    return NotValid;
            //}
            //if (countNSM != 1) {

            //    alert("AM must be added in list!!!");

            //    return NotValid;
            //}

            //if (countDZSM != 1) {

            //    alert("DZSM must be added in list!!!");

            //    return NotValid;
            //}
            return Isvalid;
        }
        dd
        function GetUserRoleInfo(id) {
            
            var urlpath = '../DoctorModule_UI/Setup.aspx/Get_UserTypeInfo';
            SelectOption_DtTable_Async_True(urlpath, $('#UserRoleSelect'), 'RoleTypeId', 'RoleType', id);
            $('#UserRoleSelect').select2();
        }

        function GetStationTypeInfo(id) {
            var urlpath = '../DoctorModule_UI/Setup.aspx/Get_StationTypeInfo';
            SelectOption_DtTable_Async_True(urlpath, $('#StationTypeSelect'), 'StationTypeId', 'StationTypeName', id);
            $('#StationTypeSelect').select2();
        }

        

        function PreviewExpenseDetails() {


            if (ValidationAddtoList()) {

               

                var UserRoleId = $("#UserRoleSelect").val();

                if (roleList.indexOf(UserRoleId) === -1) {

                    idd++;
                    roleList.push(UserRoleId);

                    var UserRole = $("#UserRoleSelect :selected").text();

                    var StationTypId = $("#StationTypeSelect").val();
                    var StationTyp = $("#StationTypeSelect :selected").text();


                    var tr = '<tr id="addr' + (idd) + '">';
                    var qtyTd = '<td  >' + (idd) + '</td>';



                    var UserRole = '<td  > <input type="hidden"  id="HfUserRoleId" name="UserRole[' + idd + ']" value="' + UserRoleId + '"/>' + UserRole + ' </td>';

                    /*  row += "<td>" + ProviderName + '<input type = "hidden" style = "text-align:center" id = "HfPId"  name ="AddToListPId[' + AddToListRowId + ']" value = "' + ProviderId + '" />' + "</td>"*/

                    var StationTyp = '<td  > <input type="hidden"  id="HfStationTypId" name="StationTyp[' + idd + ']" value="' + StationTypId + '"/>' + StationTyp + ' </td>';

                    var button = '<td  ><button class="btn-outline-danger  btn-xs mb-1 mb-md-0" onclick="RemoveRow(' + idd + ')"><i class="bx bxs-minus-circle" aria-hidden="true"></i></button></td>';
                    tr += qtyTd + UserRole + StationTyp + button + '</tr>';
                    $("#dtTableBody").append(tr);

                } else {
                    alert("Already exist !");
                }

                GetUserRoleInfo(0);
                GetStationTypeInfo(0);
            }

        }
        function RemoveRow(tbId) {

            console.log(roleList);

            var roleId = $("input[name='UserRole[" + idd + "]']").val();

            roleList.pop(roleId);
            console.log(roleList);

            $("#addr" + (tbId)).remove();

             

        }

       


        $(function () {
            //GetThanaAllInfo(0);
            GetUserRoleInfo(0);
            GetStationTypeInfo(0);
            GetDivisionAllInfo(0);
                   $('.datepicker').pickadate({
                       selectMonths: true,
                       selectYears: true
                   })
                   var masterid = getUrlVars()["id"];
                   if (masterid) {

                       $("#masterId").val(getUrlVars()["id"]);
                       /*$('#hRemarkDiv').show();*/
                       GetData(masterid);
                   }
                   else {
                       GetGroupInfo(0);
                   }
                   $("form").submit(function (e) {
                       e.preventDefault(e);
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
               function IsActiveChange() {
                   var isActive = $('#ContentPlaceHolder1_chkIsActive').is(':checked');
                   $('#pacinTxt').text("");
                   if (isActive) {
                       $('#pacinTxt').text("Active Date");
                   } else {
                       $('#pacinTxt').text("Inactive Date");
                   }
               }
               function GetGroupInfo(id) {
                   _GetGroupInfo_Active($('#GroupNameSelect'), 'GroupId', 'GroupName', id);
               }

               function GetGroupAllInfo(id) {
                   _GetGroupInfo_All($('#GroupNameSelect'), 'GroupId', 'GroupName', id);
        }


        function GetDivisionAllInfo(id) {
            _getDivision_Active_Active($('#DivisionSelect'), 'DivisionId', 'DivisionName', id);
        }

        function GetThanaAllInfo(id) {
            _GetThanaInfo_All($('#ThanaSelect'), 'ThanaId', 'ThanaName', id);
        }

        function GetDistrictbyId(id, SetId) {



            _getDistrict_ByDivision_Active($('#DistrictSelect'), 'DistrictId', 'DistrictName', id, SetId)
        }


        function GetThanabyId(id, SetId) {
 
            _getThana_ByDistrict_Active($('#ThanaSelect'), 'ThanaId', 'ThanaName', id, SetId)
        }

        $("#DivisionSelect").on("change", function (e) {
            var GroupId = $("#DivisionSelect").val();
            if (GroupId > 0) {
                GetDistrictbyId(GroupId, 0);

            }
            else {
                GetDistrictbyId(0, 0);
            }
        });

        $("#DistrictSelect").on("change", function (e) {
            var GroupId = $("#DistrictSelect").val();
            if (GroupId > 0) {
                GetThanabyId(GroupId, 0);

            }
            else {
                GetThanabyId(0, 0);
            }
        });

               $("#GroupNameSelect").on("change", function (e) {
                   var GroupId = $("#GroupNameSelect").val();
                   if (GroupId > 0) {
                       GetZone(GroupId, 0);

                   }
                   else {
                       GetZone(0, 0);
                   }
               });
               $("#zoneSelect").on("change", function (e) {
                   var zoneId = $("#zoneSelect").val();
                   if (zoneId > 0) {
                       GetArea_ByZone(zoneId);

                   }
               });


               $("#areaSelect").on("change", function (e) {

                   var id = $("#areaSelect").val();
                   if (id > 0) {
                       GetTerritory_ByAreaId(id);

                   }
               });

               $("#territorySelect").on("change", function (e) {
                   debugger;
                   var id = $("#territorySelect").val();
                   if (id > 0) {
                       GetSubTerritory_ByTerritoryId(id);

                   }
               });

               function GetZone(id, SetId) {



                   _getZone_ByGroupId_Active_SetValue($('#zoneSelect'), 'RegionId', 'RegionName', id, SetId)
               }

               function GetZone_All(id, SetId) {



                   _getZone_ByGroupId_All_SetValue($('#zoneSelect'), 'RegionId', 'RegionName', id, SetId)
               }







               function GetArea_ByZone(id) {
                   _getArea_ByZoneId_Active($('#areaSelect'), 'AreaId', 'AreaName', id);
               }

               function GetArea_All_ByZone(id, SetId) {
                   _getArea_ByZoneId_All($('#areaSelect'), 'AreaId', 'AreaName', id, SetId);
               }


               function GetTerritory_ByAreaId(id) {
                   _getTerritory_ByAreaId_Active($('#territorySelect'), 'TerritoryId', 'TerritoryName', id);
               }

               function GetTerritory_ByAreaId_All(id, SetId) {
                   _getTerritory_ByAreaId_All($('#territorySelect'), 'TerritoryId', 'TerritoryName', id, SetId);
               }

               function GetMarket_ByTerritoryId(id) {
                   _getMarket_ByTerritoryId_Active($('#MarketSelect'), 'MarketId', 'MarketName', id);
               }




               function GetSubTerritory_ByTerritoryId_All(id, SetId) {
                   _GetSubTerritory_ByTerritoryId_All($('#SubterritorySelect'), 'SubTerritoryId', 'SubTerritoryName', id, SetId);
               }



               //function GetMarket_ByTerritoryId_All(id, SetId) {
               //    _getMarket_ByTerritoryId_All($('#MarketSelect'), 'MarketId', 'MarketName', id, SetId);
               //}

               function GetSubTerritory_ByTerritoryId(id) {
                   _GetSubTerritory_ByTerritoryId_Active($('#SubterritorySelect'), 'SubTerritoryId', 'SubTerritoryName', id);
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

                   $('#GroupNameSelect').removeClass('is-invalid');
                   $('#zoneSelect').removeClass('is-invalid');
                   $('#areaSelect').removeClass('is-invalid');
                   $('#territorySelect').removeClass('is-invalid');
                   $('#mainName').removeClass('is-invalid');
                   $('#acDate').removeClass('is-invalid');
                   $('#ThanaSelect').removeClass('is-invalid');

                   RemoveValidationTooltip("#v-GroupNameSelect");

                   RemoveValidationTooltip("#v-zoneSelect");

                   RemoveValidationTooltip("#v-areaSelect");

                   RemoveValidationTooltip("#v-territorySelect");

                   RemoveValidationTooltip("#v-mainName");
                   RemoveValidationTooltip("#v-ThanaSelect");

                   RemoveValidationTooltip("#v-acDate");

                   isValid = true;

                   if ($('#GroupNameSelect').val() == 0 || $('#GroupNameSelect').val() == "" || $('#GroupNameSelect').val() == null) {
                       $('#GroupNameSelect').addClass("is-invalid");
                       ValidationTooltip("#v-GroupNameSelect", "Please fill out of this field!");
                       isValid = false;
                   }


                   if ($('#zoneSelect').val() == 0 || $('#zoneSelect').val() == "" || $('#zoneSelect').val() == null) {

                       $('#zoneSelect').addClass("is-invalid");
                       ValidationTooltip("#v-zoneSelect", "Please fill out of this field!");
                       isValid = false;
                   }

                   if ($('#areaSelect').val() == 0 || $('#areaSelect').val() == "" || $('#areaSelect').val() == null) {

                       $('#areaSelect').addClass("is-invalid");
                       ValidationTooltip("#v-areaSelect", "Please fill out of this field!");
                       isValid = false;
                   }

                   if ($('#territorySelect').val() == 0 || $('#territorySelect').val() == "" || $('#territorySelect').val() == null) {

                       $('#territorySelect').addClass("is-invalid");
                       ValidationTooltip("#v-territorySelect", "Please fill out of this field!");
                       isValid = false;
                   }


                   if ($('#mainName').val() == "") {

                       $('#mainName').addClass("is-invalid");
                       ValidationTooltip("#v-mainName", "Please fill out of this field!");
                       isValid = false;
                   }

                   if ($('#ThanaSelect').val() == 0 || $('#ThanaSelect').val() == "" || $('#ThanaSelect').val() == null) {

                       $('#ThanaSelect').addClass("is-invalid");
                       ValidationTooltip("#v-ThanaSelect", "Please fill out of this field!");
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
                       if (validationForOrder()) {
                       FinalSave();


                       }
                   }

               }
               function FinalSave() {
                   var jsonData = {};
                   jsonData["MarketId"] = $('#masterId').val();
                   jsonData["SubTerritoryId"] = $('#SubterritorySelect').val();
                   jsonData["MarketName"] = $('#mainName').val();
                   jsonData["IsActive"] = $('#customSwitch1').is(':checked');
                   jsonData["AcOrInAcDate"] = $('#acDate').val();
                   jsonData["Remarks"] = $('#remarksTxt').val();

                   jsonData["GroupId"] = $('#GroupNameSelect').val();
                   jsonData["ThanaId"] = $('#ThanaSelect').val();





                   var jsonObjs = [];

                  
                   $('#dtTble tbody tr').each(function (idd) {
                       debugger;
                       var theObj = {};
                       idd++;
                       //  if (typeof FieldName ==="" ) 
                       var FieldName = $("input[name='UserRole[" + idd + "]']").val();
                

                       var IsRequired = $("input[name='StationTyp[" + idd + "]']").val();
                       //var ProviderId = $("input[name='AddToListPId[" + AddToListRowId + "]']").val();
                       theObj["UserRoleID"] = FieldName;
                       theObj["StationTypeId"] = IsRequired;

                       jsonObjs.push(theObj);
                       jsonData["MarketStationDetailDaoList"] = jsonObjs;

                   });


                   var urlpath = 'Setup.aspx/SaveMarket';
                   $.ajax({
                       data: JSON.stringify({ 'masterData': jsonData }),
                       url: urlpath,
                       contentType: "application/json; charset=utf-8",
                       type: "POST",
                       beforeSend: function () {
                           //_open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                       },
                       success: function (result) {
                           result = result.d;
                           if (result.isSuccess == true) {

                               successalert('Operation successful!', 'Success', 'MarketRecords.aspx');
                           }
                           else if (result.isValiCheck == true) {

                               faildalert('Data cannot be deactivated!', 'Faild');
                           }
                           else {
                               faildalert('Operation Faild!', 'Faild');
                           }

                       },
                       error: function (data) {
                           faildalert('Operation Faild!', 'Faild');
                       },

                   });
               }


               function GetData(id) {
                   var urlpath = 'Setup.aspx/GetMarketEditData';
                   $.ajax({
                       url: urlpath,
                       dataType: 'json',
                       data: JSON.stringify({ 'id': id }),
                       type: "POST", contentType: "application/json; charset=utf-8",
                       async: true,
                       success: function (data) {
                           var result = JSON.parse(data.d);


                         
                           $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");

                           GetDivisionAllInfo(result[0].DivisionId);
                           GetDistrictbyId(result[0].DivisionId, result[0].DistrictId);
                           GetThanabyId(result[0].DistrictId, result[0].ThanaId);
                           GetGroupAllInfo(result[0].GroupId);
                           //GetThanaAllInfo(result[0].ThanaId);
                           GetZone_All(result[0].GroupId, result[0].RegionId);
                           GetArea_All_ByZone(result[0].RegionId, result[0].AreaId);
                           GetTerritory_ByAreaId_All(result[0].AreaId, result[0].TerritoryId);
                           GetSubTerritory_ByTerritoryId_All(result[0].TerritoryId, result[0].SubTerritoryId);
                           //_getZone_ByGroupId_Active_SetValue($('#zoneSelect'), 'RegionId', 'RegionName' ,data.GroupId, data.ZoneId);
                           //_getArea_ByZoneId_Active_SetValue($('#areaSelect'), 'AreaId', 'AreaName', data.ZoneId, data.AreaId);
                           //_getTerritory_ByAreaId_Active_SetValue($('#territorySelect'), 'TerritoryId', 'TerritoryName', data.AreaId, data.TerritoryId);
                           //_getSubTerritory_ByTertory_Active_SetValuee($('#SubterritorySelect'), 'SubTerritoryId', 'SubTerritoryName', data.TerritoryId, data.SubTerritoryId);
                           $('#mainName').val(result[0].MarketName);
                          
                           $('#acDate').val((result[0].AcOrInAcDate));
                          
                           if (result[0].IsActive) {
                               $('#customSwitch1').prop('checked', true);
                           } else {
                               $('#customSwitch1').prop('checked', false);
                           }



                           var row = "";
                           $('#dtTableBody').html("");
                           for (var i = 0; i < result.length; i++) {



                               if (result[i].UserRoleID != null && result[i].StationTypeId != null) {

                                


                                    
                                       idd++;
                                       var UserRoleID = result[i].UserRoleID;
                                       var RoleName = result[i].RoleName;
                                       roleList.push(result[i].UserRoleID);
                                       var StationTypeId = result[i].StationTypeId;
                                       var StationTypeName = result[i].StationTypeName;


                                       row += '<tr id="addr' + (idd) + '">';
                                       row += "<td>" + (idd) + "</td>";
                                       row += '<td > <input type="hidden"   id="HfUserRoleId"  name="UserRole[' + idd + ']" value="' + UserRoleID + '"/>' + RoleName + '</td>';

                                       row += '<td > <input type="hidden"   id="HfStationTypId"  name="StationTyp[' + idd + ']" value="' + StationTypeId + '"/>' + StationTypeName + '</td>';

                                       row += "<td ><button class='btn-outline-danger  btn-xs mb-1 mb-md-0' onclick='RemoveRow(" + idd + ")'><i class='bx bxs-minus-circle' aria-hidden='true'></i></button></td>";
                                       row += "</tr>";
                                   }
                             
                               else {
                                   $('#dtTableBody').html(row);

                               }
                               //alert(roleList);
                           }
                           

                       
                      
                           $('#dtTableBody').html(row);
                       },
                       complete: function () {

                       }
                   });
               }



    </script>--%>




</asp:Content>

