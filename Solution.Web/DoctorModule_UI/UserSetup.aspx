<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="UserSetup.aspx.cs" Inherits="DoctorModule_UI_UserSetup" %>
<%@ Register Src="~/MasterSetup_UI/IVMarketStructure.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <style>
        .SelectchkChoice label {
            padding-left: 3px;
          
            
            font-weight: bold;
        }
    </style>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>User Setup </div>

                <div class="ms-auto">
                    <div class="btn-group">

                        <a href="../DoctorModule_UI/UserRecords.aspx" runat="server" id="btnBtL" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <br />
                            
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                             <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
 <asp:HiddenField runat="server" ID="hfEmpID"/>
 <asp:HiddenField runat="server" ID="id_mastetID"/>

                            <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="acDate" class="col-sm-3 col-form-label">User Type </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:DropDownList  runat="server"  AutoPostBack="true" OnSelectedIndexChanged="ddlUserType_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2" id="ddlUserType"></asp:DropDownList>

                                                  <script type="text/javascript">
                                                      function pageLoad() {

                                                          $('.multiple-select').select2({
                                                              includeSelectAllOption: true,
                                                              theme: 'bootstrap4',
                                                              width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                              placeholder: $(this).data('placeholder'),
                                                              allowClear: Boolean($(this).data('allow-clear')),
                                                          });
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
                                                  </script>
                                                <span id="v-ddlUserType" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>


                                      <div class="row mt-1" runat="server" visible="false" id="DivEmp">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="acDate" class="col-sm-3 col-form-label">Employee Name </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:DropDownList  runat="server"   class="form-select form-select-sm mb-3 mySelect2" id="ddlEmployeeName"></asp:DropDownList>
                                                <span id="v-ddlEmployeeName" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>

                                      <div class="row mt-1" runat="server" visible="false" id="DivDA">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="acDate" class="col-sm-3 col-form-label">DA Name </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:DropDownList  runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDaList_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2" id="ddlDaList"></asp:DropDownList>
                                                <span id="v-ddlDaList" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>

                            <div class="row mt-1" runat="server" visible="false">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="txtUserName" class="col-sm-3 col-form-label">User Name </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                               <asp:TextBox   runat="server"  Text="N/A"  id="txtUserName" type="text" class=" form-control form-control-sm"></asp:TextBox>
                                                <span id="v-txtUserName" class="invalid-tooltip fade hide" data-delay="2000"></span>
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
                                        <label for="txtUserName" class="col-sm-3 col-form-label">Login Name </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                               <asp:TextBox   runat="server"    id="txtLoginName" type="text" class=" form-control form-control-sm"></asp:TextBox>
                                                <span id="v-txtLoginName" class="invalid-tooltip fade hide" data-delay="2000"></span>
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
                                        <label for="acDate" class="col-sm-3 col-form-label">Password </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                 <asp:TextBox   runat="server"    id="txtPassword" type="text" class=" form-control form-control-sm"></asp:TextBox>
                                                <span id="v-password" class="invalid-tooltip fade hide" data-delay="2000"></span>
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
                                        <label for="acDate" class="col-sm-3 col-form-label"> <a href="../DoctorModule_UI/UserRoleEntry.aspx" title="Go to this Page" target="_blank">User Role </a></label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                              <asp:DropDownList  runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlUserRole_SelectedIndexChanged"  class="form-select form-select-sm mb-3 mySelect2" id="ddlUserRole"></asp:DropDownList>
                                                <span id="v-ddlUserRole" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                               
                                                 <span class="input-group-text text_Link"><asp:LinkButton runat="server" ID="loadUserRole" OnClick="loadUserRole_Click"><i class="fa fa-refresh"></i></asp:LinkButton></span>
                                                 <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>

                            <div class="row mt-1" runat="server" visible="false">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="acDate" class="col-sm-3 col-form-label">Product Line </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                            <asp:DropDownList  runat="server"   class="form-select form-select-sm mb-3 mySelect2" id="ddlProductLine"></asp:DropDownList>
                                                <span id="v-ddlProductLine" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>

                            <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="customSwitch2" class="col-sm-3 col-form-label">&nbsp; </label>
                                        <div class="col-sm-7">


                                            <div class="custom-control custom-switch mt-2">
                                                 <asp:CheckBox CssClass="SelectchkChoice" ID="chkMobileAccess" AutoPostBack="true" OnCheckedChanged="chkMobileAccess_CheckedChanged"  runat="server" Text="Is Mobile Access" />
                                                
                                                 
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>

                                    <div runat="server" visible="false" id="divMei">
                                        <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="txtImei1" class="col-sm-3 col-form-label">Mobile IMEI 1 </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                 <asp:TextBox   runat="server"    id="txtImei1" type="text" class="form-control form-control-sm"></asp:TextBox>
                                                <span id="v-txtImei1" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                              
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="txtImei2" class="col-sm-3 col-form-label">Mobile IMEI 2 </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox   runat="server"    id="txtImei2" type="text" class="form-control form-control-sm"></asp:TextBox>
                                                <span id="v-txtImei2" class="invalid-tooltip fade hide" data-delay="2000"></span>
                       
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>


                                    </div>

                                    
                                                     <style>
          .radioChoice label {
            padding-left: 3px;
            padding-right: 6px;
                  font-size: 14px;
                  font-weight: bold;
        }

     
    </style>
                                           <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="acDate" runat="server" id="Label1" class="col-sm-3 col-form-label"> </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                              <asp:RadioButtonList runat="server" CssClass="radioChoice" ID="rbDashboard" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                                  <asp:ListItem Selected="True" Value="0">Main Dashboard</asp:ListItem>
                                                  <asp:ListItem Value="1">Depot Dashboard</asp:ListItem>
                                                </asp:RadioButtonList>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>
                                       
                                    <div runat="server" visible="false">
                                              <div runat="server" id="divmrkAccess">
                                               

                                    <h4>Market Access</h4>
                             
<uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />

                                    
                                    <div class="form-group row" style="margin-top:6px;">

                                       <label for="MarketSelect" class="col-sm-2 col-form-label">   </label>

                                    <div class="col-sm-3">

                                    

                                    </div>      
                                    <label for="MarketSelect" class="col-sm-2 col-form-label">  </label>

                                    <div class="col-sm-3">

                                          <asp:LinkButton ID="btnAddtoListMarket" runat="server"  OnClick="btnAddtoListMarket_Click" CssClass="btn btn-sm btn-success pull-right" ><i class="fa fa-plus-circle"></i>Add To List</asp:LinkButton>

                                    </div>                                    </div>

         

                 <div class="row">
                            <div class="col-2">&nbsp;</div>
                                       <div class="col-8">


                                            <div class="table-responsive" id="MainGradeDiv2">
                                                

                                                  <asp:GridView ID="gv_Market" runat="server" AutoGenerateColumns="False"
                                                                    CssClass="table table-bordered  text-center thead-dark" ShowHeaderWhenEmpty="true" >
                                                                    <Columns>

                                                                         <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfGroupId" Value='<%#Eval("GroupId")%>' />

                                             <asp:HiddenField runat="server" ID="hfRegionId" Value='<%#Eval("RegionId")%>' />
                                             <asp:HiddenField runat="server" ID="hfAreaId" Value='<%#Eval("AreaId")%>' />
                                             <asp:HiddenField runat="server" ID="hfTerritoryId" Value='<%#Eval("TerritoryId")%>' />
                                             <asp:HiddenField runat="server" ID="hfSubTerritoryId" Value='<%#Eval("SubTerritoryId")%>' />
                                             <asp:HiddenField runat="server" ID="hfMarketId" Value='<%#Eval("MarketId")%>' />
                                            
                                                  
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                                                      
                                                <asp:TemplateField HeaderText="Group">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_GroupName" runat="server" Text='<%#Eval("GroupName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                                        
                                                <asp:TemplateField HeaderText="Zone">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_RegionName" runat="server" Text='<%#Eval("RegionName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                                        
                                                <asp:TemplateField HeaderText="Area">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_AreaName" runat="server" Text='<%#Eval("AreaName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                        
                                                <asp:TemplateField HeaderText="Territory">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_TerritoryName" runat="server" Text='<%#Eval("TerritoryName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                        
                                                <asp:TemplateField HeaderText="Sub-Territory">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_SubTerritoryName" runat="server" Text='<%#Eval("SubTerritoryName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                        
                                                <asp:TemplateField HeaderText="Market">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_MarketName" runat="server" Text='<%#Eval("MarketName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                                        
                                               


                                                                        <asp:TemplateField HeaderText="Remove">
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="MarketdeleteImageButton" runat="server" OnClick="MarketdeleteImageButton_Click" CssClass="btn-danger  btn-sm mb-1 mb-md-0"
                                                                                    ><i class='fa fa-minus' aria-hidden='true'></i></asp:LinkButton>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>

                                                                    </Columns>
                                                                </asp:GridView>
                                  

                                </div>

                                     </div>
                                     </div>
                                          </div>

                                    </div>
                              

                                  <div runat="server" id="dcDiv" visible="false">

                                        <h4>  DC Permission</h4>
                                    <hr />
 

                                    
                                    <div class="form-group row" style="margin-top:6px;">

                                       <label for="MarketSelect" class="col-sm-2 col-form-label"> Distribution Center  </label>

                                    <div class="col-sm-5">

                                         <asp:ListBox runat="server" ID="ddlDistributionCenter" SelectionMode="Multiple" class="form-select form-select-sm mb-3 multiple-select" name="BrandSelect"></asp:ListBox>
</div>
</div>
 

                                  </div>
 
                            <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="customSwitch1" class="col-sm-3 col-form-label">&nbsp; </label>
                                        <div class="col-sm-7">
                                            <div class="custom-control custom-switch mt-2">
                                               <asp:CheckBox AutoPostBack="true" OnCheckedChanged="chkIsActive_CheckedChanged" ID="chkIsActive" CssClass="SelectchkChoice" Checked="true" runat="server" Text="Is Active" />
                                              
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>





                            <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="acDate" runat="server" id="pacinTxt" class="col-sm-3 col-form-label">Active Date </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox   runat="server"    id="txtacDate" type="text" class="datepicker form-control form-control-sm mb-3" autocomplete="off" placeholder="Select Date" ></asp:TextBox>
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
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                        <div class="col-sm-8">
                                                              <asp:LinkButton  OnClick="btnSave_Click" Visible="false"  runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                             <asp:LinkButton  OnClick="btnSave_Click"  OnClientClick="return sweetAlertConfirm_Submit(this);"  Visible="false"   runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Update
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnReset"  runat="server"   class="btn btnMyDesignReset   btn-sm" OnClick="btnReset_Click" ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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

    <input id="masterId" value="0" style="display: none" />


</asp:Content>

