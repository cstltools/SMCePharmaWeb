<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TourPurposeOtherSetup.aspx.cs" Inherits="DoctorModule_UI_TourPurposeOtherSetup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <style>
        .input-group > :not(:first-child):not(.dropdown-menu):not(.valid-tooltip):not(.valid-feedback):not(.invalid-tooltip):not(.invalid-feedback) {
    margin-left: -1px;
    border-top-left-radius: 0;
    border-bottom-left-radius: 0;
    padding: 5px;
}
    </style>
    <div id="popDiv">
    </div>


    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Tour Purpose Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <%--<a href="../DoctorModule_UI/ExpenseTypeView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>--%>


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
                        <div class="row">



                            <div class="form-group row" style="display:none">
                    <label for="visitType" class="col-sm-3 col-form-label">Visit Type:</label>
                    <div class="col-sm-7">
                        <asp:RadioButtonList ID="visitType" runat="server" RepeatDirection="Horizontal" CssClass="radio-container" AutoPostBack="true" OnSelectedIndexChanged="VisitType_SelectedIndexChanged">
                            <asp:ListItem Text="Market Visit" Value="market" />
                            <asp:ListItem Selected="True" Text="Other Visit" Value="other" />
                        </asp:RadioButtonList>
                    </div>
                </div>

                <!-- Tour Purpose -->
                <div class="form-group row">
                    <label for="tourPurpose" class="col-sm-3 col-form-label">Tour Purpose:</label>
                    <div class="col-sm-7">
                        <asp:TextBox ID="tourPurpose" Visible="false" runat="server" CssClass="form-control form-control-sm mb-3" placeholder="Tour Purpose" />
                         <asp:DropDownList  class="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlTourPurpose" AutoPostBack="true" OnSelectedIndexChanged="ddlTourPurpose_SelectedIndexChanged"  ></asp:DropDownList>

                    </div>
                </div>
                <div class="form-group row">
                    <label for="tourPurpose" class="col-sm-3 col-form-label"> </label>
                    <div class="col-sm-7">
                        		 <div class="input-group">
                            
                          <div class="form-check form-switch" style="padding-left: 35px !important;">
												<input    class="form-check-input"   runat="server" type="checkbox" id="chkIsActive" checked>
												 <label  class="custom-control-label" for="chkIsActive">Active</label>
											</div>      
                           

                                   
                                </div>

                    </div>
                </div>
                                                        <script type="text/javascript">
                                                            function pageLoad() {
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

                                                                $('.multiple-select').select2({
                                                                    includeSelectAllOption: true,
                                                                    theme: 'bootstrap4',
                                                                    width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                                    placeholder: $(this).data('placeholder'),
                                                                    allowClear: Boolean($(this).data('allow-clear')),
                                                                });

                                                            }
                                                        </script>
                <!-- Role Panel -->
                <asp:Panel ID="rolePanel" runat="server" CssClass="form-group row" Visible="false">
                    <div class="form-group row">
                        <label for="roleSelect" class="col-sm-3 col-form-label">Role:</label>
                        <div class="col-sm-7">
                            <asp:DropDownList ID="roleSelect" AutoPostBack="true" OnSelectedIndexChanged="roleSelect_SelectedIndexChanged"  runat="server" CssClass="form-control form-control-sm mb-3">
                                <asp:ListItem Text="Select One" Value="0" />
                                <asp:ListItem Text="MIO" Value="MIO" />
                                <asp:ListItem Text="AM" Value="AM" />
                                <asp:ListItem Text="DZSM" Value="DZSM" />
                                <asp:ListItem Text="Regional Head" Value="NSM" />
                                <%--<asp:ListItem Text="NSM" Value="Head of NSM" />--%>
                            </asp:DropDownList>
                        </div>
                    </div>
                </asp:Panel>

                <!-- Territory Group -->
                <div class="form-group row" id="territoryGroup" runat="server" Visible="false">
                    <label for="territorySelect" class="col-sm-3 col-form-label">Territory:</label>
                    <div class="col-sm-7">
                        <asp:DropDownList ID="territorySelect" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                            <asp:ListItem Text="Select Territory" Value="0" />
                        </asp:DropDownList>
                    </div>
                </div>

                <!-- Area Group -->
                <div class="form-group row" id="areaGroup" runat="server" Visible="false">
                    <label for="areaSelect" class="col-sm-3 col-form-label">Area:</label>
                    <div class="col-sm-7">
                        <asp:DropDownList ID="areaSelect" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                            <asp:ListItem Text="Select Area" Value="0" />
                        </asp:DropDownList>
                    </div>
                </div>

                <!-- Region Group -->
                <div class="form-group row" id="regionGroup" runat="server" Visible="false">
                    <label for="regionSelect" class="col-sm-3 col-form-label">Region:</label>
                    <div class="col-sm-7">
                        <asp:DropDownList ID="regionSelect" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                            <asp:ListItem Text="Select Region" Value="0" />
                        </asp:DropDownList>
                    </div>
                </div>
                             <div class="form-group row" id="DivGroup" runat="server" Visible="false">
                    <label for="GroupSelect" class="col-sm-3 col-form-label">Group:</label>
                    <div class="col-sm-7">
                        <asp:DropDownList ID="GroupSelect" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                            <asp:ListItem Text="Select Region" Value="0" />
                        </asp:DropDownList>
                    </div>
                </div>

                <!-- Zone Group -->
            

                <!-- Station Type -->
                <div class="form-group row">
                    <label for="stationType" class="col-sm-3 col-form-label">Station Type:</label>
                    <div class="col-sm-7">
                        <asp:DropDownList ID="StationSelect" runat="server" CssClass="form-control form-control-sm mb-3">
                            <asp:ListItem Text="Select One" Value="0" />
                            <asp:ListItem Text="HQ" Value="2" />
                            <asp:ListItem Text="EX-HQ" Value="1" />
                            <asp:ListItem Text="OS" Value="3" />
                        </asp:DropDownList>
                    </div>
                </div>

                  <!-- Add to List Button -->
            <div class="form-group row">
                <div class="col-sm-7 offset-sm-3">
                    
                        <asp:LinkButton ID="btnAdd" runat="server"  CssClass="btn btn-sm btn-success" OnClick="btnAdd_Click" ><i class="fa fa-plus-circle"></i>Add To List</asp:LinkButton>
                </div>
            </div>
                            <br />

<div class="form-group row" style="margin-top:20px!important">
            <!-- GridView to display the list -->
            <asp:GridView ID="gvList" runat="server" AutoGenerateColumns="false" CssClass="table table-striped" OnRowCommand="gvList_RowCommand">
                <Columns>

                    <asp:TemplateField HeaderText="SL#">
    <ItemTemplate>
        <%# Container.DataItemIndex + 1 %>
       </ItemTemplate>
</asp:TemplateField>
                     <asp:TemplateField HeaderText="Role">
                        <ItemTemplate>
                            <asp:Label ID="lblRole" runat="server" Text='<%# Eval("Role") %>' />
                            <asp:HiddenField ID="hfRoleId" runat="server" Value='<%# Eval("RoleId") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                     <asp:TemplateField HeaderText="Territory">
                        <ItemTemplate>
                            <asp:Label ID="lblTerritory" runat="server" Text='<%# Eval("Territory") %>' />
                            <asp:HiddenField ID="hfTerritoryId" runat="server" Value='<%# Eval("TerritoryId") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                      <asp:TemplateField HeaderText="Area">
                        <ItemTemplate>
                            <asp:Label ID="lblArea" runat="server" Text='<%# Eval("Area") %>' />
                            <asp:HiddenField ID="hfAreaId" runat="server" Value='<%# Eval("AreaId") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                     <asp:TemplateField HeaderText="Region">
                        <ItemTemplate>
                            <asp:Label ID="lblRegion" runat="server" Text='<%# Eval("Region") %>' />
                            <asp:HiddenField ID="hfRegionId" runat="server" Value='<%# Eval("RegionId") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                     <asp:TemplateField HeaderText="Group">
                        <ItemTemplate>
                            <asp:Label ID="lblGroup" runat="server" Text='<%# Eval("Group") %>' />
                            <asp:HiddenField ID="hfGroupId" runat="server" Value='<%# Eval("GroupId") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                     <asp:TemplateField HeaderText="Station Type">
                        <ItemTemplate>
                            <asp:Label ID="lblStationType" runat="server" Text='<%# Eval("StationType") %>' />
                            <asp:HiddenField ID="hfStationTypeId" runat="server" Value='<%# Eval("StationTypeId") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                     <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkDelete" runat="server" CssClass="btn btn-sm btn-danger"   CommandName="DeleteRow" CommandArgument="<%# Container.DataItemIndex %>"  ><i class='fa fa-minus' aria-hidden='true'></i></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
    </div>

                                     <div class="row">
<div class="col-2">&nbsp;</div>
<div class="col-8">

     <div class="form-group row">
        <label for="customSwitch1" class="col-sm-3 col-form-label">  </label>

        <div class="col-sm-7" style="padding-top:6px;">

      
            
                          <asp:LinkButton  OnClick="btnSave_Click"  OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="LinkButton1" class="btn btnMyDesignSearch   btn-sm"  >
                <i class="fa fa-check"></i>Submit
            </asp:LinkButton>

                                 <asp:LinkButton  OnClick="btnSave_Click"  Visible="false"   runat="server" id="LinkButton2" class="btn btnMyDesignSearch   btn-sm" OnClientClick="return sweetAlertConfirm_Update(this);"   >
                <i class="fa fa-check"></i>Update
            </asp:LinkButton>
            <asp:LinkButton  runat="server" id="restbtn" OnClick="restbtn_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>

        </div>

    </div>

    </div>
    </div>


                            <div class="col-2">&nbsp;</div>
                            <div class="col-8" style="display:none">
                                <div class="form-group row">
                                    <label for="TxtName" class="col-sm-3 col-form-label">Name:  </label>

                                    <div class="col-sm-8">

                                          <div class="input-group">
                                       <asp:TextBox   runat="server"   id="TxtName" name="TxtName"   class="form-control form-control-sm mb-3"></asp:TextBox>

                                        <span id="v-TxtName" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div>
                                </div> 
                                
                                <div class="form-group row">
                                    <label for="TxtName" class="col-sm-3 col-form-label">Role Type:  </label>

                                    <div class="col-sm-8">

                                          <div class="input-group">
                                  
                                              	 <asp:ListBox runat="server" ID="ddlRoleType" AutoCompleteType="Disabled" SelectionMode="Multiple" class="form-select form-select-sm mb-3 multiple-select" name="ddlRoleType"></asp:ListBox>
                                        <span id="v-ddlRoleType" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div>
                                </div> 
                            

                                <div class="form-group row">
                                    <label for="TxtName" class="col-sm-3 col-form-label">Employee Name:  </label>

                                    <div class="col-sm-8">

                                          <div class="input-group">

                                               <asp:ListBox  runat="server" ID="EmployeeIdSelect"  AutoCompleteType="Disabled" SelectionMode="Multiple" class="form-select form-select-sm mb-3 multiple-select" name="EmployeeIdSelect"></asp:ListBox>
                                     
                                        <span id="v-EmployeeIdSelect" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div>
                                </div>



                                      <div class="form-group row">
                                    <label for="TxtName" class="col-sm-3 col-form-label">  </label>

                                    <div class="col-sm-5"  >
                                           
                                     <asp:CheckBox runat="server" ID="chkFixed" Text="is Fixed Amount" AutoPostBack="true" OnCheckedChanged="chkFixed_CheckedChanged" />
                                            
                                          

                                    </div>
                                </div>


                                    <div class="form-group row">
        <label for="TxtName" class="col-sm-3 col-form-label">Amount:  </label>

        <div class="col-sm-8">

              <div class="input-group">
           <asp:TextBox   runat="server"   id="txtAmount" name="txtAmount"  ReadOnly="true" class="form-control form-control-sm mb-3"></asp:TextBox>

            <span id="v-txtAmount" class="invalid-tooltip fade hide" data-delay="2000">
            </span>
        <span class="input-group-text text-c-red">*</span>

                  </div>

        </div>
    </div> 
                                    
                                <div class="form-group row">
                                    <label for="inlineImageRequired" class="col-sm-3 col-form-label">Image Required:  </label>

                                    <div class="col-sm-8 " style="margin-top:8px;">
                                           <div class="input-group">

                                               <asp:RadioButtonList runat="server" ID="rbImgType" RepeatDirection="Horizontal" RepeatLayout="Flow" >
                                                   <asp:ListItem Selected="True">Yes</asp:ListItem>
                                                   <asp:ListItem>No</asp:ListItem>
                                               </asp:RadioButtonList>
                                        
                                   <span class="input-group-text text-c-red">*</span>

                                               </div>
                                    </div>
                                </div>




                                <br />
                                <br />
                                <div class="form-group row">
                                    <label for="AllowancePerMile" class="col-sm-3 col-form-label">Field Name:  </label>

                                    <div class="col-sm-3">

                                         <asp:TextBox   runat="server"   id="txtFieldName" name="txtFieldName" class="form-control form-control-sm mb-3"></asp:TextBox>

                                        <span id="v-txtFieldName" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                    </div>

                                    <label for="AllowancePerMile" class="col-sm-2 col-form-label">Required:  </label>

                                    <div class="col-sm-2">

                                          <asp:DropDownList  runat="server"  id="IsRequired" class="form-select form-select-sm mb-3 mySelect2">
                                              <asp:ListItem>True</asp:ListItem>
                                              <asp:ListItem>False</asp:ListItem>

                                          </asp:DropDownList>

                                           
                                     <asp:HiddenField ID="hfForMe" runat="server" />


                                    </div>

                                    <div class="col-sm-2">
                                        <%--<button class="btn btn-primary p-2" onclick="PreviewExpenseDetails()">Add to list</button>
                                        <button class="btn btn-primary p-2" >Addsdfasf to list</button>--%>
                                         
                                         <asp:LinkButton ID="addButtonDA" runat="server"  CssClass="btn btn-sm btn-success" OnClick="addButtonDA_Click" ><i class="fa fa-plus-circle"></i>Add To List</asp:LinkButton>
                                        <span id="v-btnAddtolist" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                    </div>

                                </div>
                                <br />

                                <div class="form-row">
                                    <div class="table-responsive" id="MainGradeDiv">
                                       <asp:GridView ID="gv_DA" runat="server" AutoGenerateColumns="False"
              ShowHeaderWhenEmpty="true" CssClass="table table-bordered text-center thead-dark">
    <Columns>
        <asp:TemplateField HeaderText="SL#">
            <ItemTemplate>
                <%# Container.DataItemIndex + 1 %>
                <asp:HiddenField runat="server" ID="hfExpenseTypDetailsId" Value='<%# Eval("ExpenseTypDetailsId") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Field Name">
            <ItemTemplate>
                <asp:Label ID="lbl_FieldName" runat="server" Text='<%# Eval("FieldName") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Required">
            <ItemTemplate>
                <asp:Label ID="lbl_IsRequied" runat="server" Text='<%# Eval("IsRequied") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Remove">
            <ItemTemplate>
                <asp:LinkButton ID="deleteImageButton" runat="server" OnClick="deleteImageButton_Click"
                                CommandArgument='<%# Container.DataItemIndex %>' 
                                CssClass="btn-danger btn-sm mb-1 mb-md-0">
                    <i class='fa fa-minus' aria-hidden='true'></i>
                </asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>


                                    </div>
                                </div>
                                <asp:HiddenField runat="server" ID="id_mastetID"/>

                                <div class="form-group row">
                                    <label for="AllowancePerMile" class="col-sm-3 col-form-label">   </label>

                                    <div class="col-sm-7" style="padding-top:6px;">

                                        <div  class="form-check form-switch">
                                            <input type="checkbox"  class="form-check-input" runat
                                                ="server" id="customSwitch1" checked onchange="IsActiveChange()">

                                             <label  class="custom-control-label" for="customSwitch1">Is Active</label>
                                             </label>
                                        </div>


                                    </div>

                                </div>

                                <br />
                                <br />
                                <br />
                                            <div class="row">
                                                <div class="col-2">&nbsp;</div>
                                                <div class="col-8">

                                                    <div class="form-group row">
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                        <div class="col-sm-8">
                                                              <asp:LinkButton  OnClick="btnSave_Click" Visible="false" OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                             <asp:LinkButton  OnClick="btnSave_Click"  Visible="false"   runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm" OnClientClick="return sweetAlertConfirm_Update(this);"   >
                                            <i class="fa fa-check"></i>Update
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server" id="btnReset" OnClick="btnReset_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="col-2">&nbsp;</div>
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

 


<input type="hidden" id="masterId" value="0"  style="display:none" />
  
 








</asp:Content>

