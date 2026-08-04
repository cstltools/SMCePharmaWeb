<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="EmployeeSetupForNewJoiner.aspx.cs" Inherits="MasterSetup_UI_EmployeeSetupForNewJoiner" %>
<%@ Register Src="~/MasterSetup_UI/IVMarketStructure.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Employee Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                    <%--    <a href="EmployeeRecords.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>--%>


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
                               <%--       <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>--%>

                                    <asp:HiddenField runat="server" ID="hfRoleType" />
                             <div class="row">
                                            <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Employee Name <span class="text-sm-left text-c-red">*</span></label>
                                                   <asp:TextBox  runat="server"    id="txtEmpName" class="form-control form-control-sm mb-3 " placeholder="Enter employee name "></asp:TextBox>

                                                    <span id="v-txtEmpName" class="invalid-tooltip fade hide" data-delay="1000"></span>
                                                </div>
                                            </div><!-- Col -->

                                  <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Employee Code   <span class="text-sm-left text-c-red">*</span></label>
                                                   <asp:TextBox  runat="server"  AutoPostBack="true" OnTextChanged="txtEmpCode_TextChanged"  id="txtEmpCode" class="form-control form-control-sm mb-3 " placeholder="Enter employee Code "></asp:TextBox>

                                                    <span id="v-txtEmpCode" class="invalid-tooltip fade hide" data-delay="1000"></span>
                                                </div>
                                            </div><!-- Col -->

                                              <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label"><asp:CheckBox runat="server" ID="chkIsTempEmployeeCode" Text="Is Temp Employee Code" />  </label>
                                                
                                                </div>
                                            </div><!-- Col -->

                                            <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Father's Name</label>
                                                  <asp:TextBox  runat="server"    id="txtEmpFatherName" class="form-control form-control-sm mb-3 " placeholder="Enter father's name"></asp:TextBox>
                                                </div>
                                            </div><!-- Col -->

                                            <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Mother's Name</label>
                                                   <asp:TextBox  runat="server"    id="txtEmpMotherName" class="form-control form-control-sm mb-3 " placeholder="Enter mother's name"></asp:TextBox>
                                                </div>
                                            </div><!-- Col -->
                                            <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Date of Birth (DOB)</label>
                                                  <asp:TextBox  runat="server"    id="txtEmpdobDate" type="text" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select date of birth" ></asp:TextBox>

                                                    <span id="v-txtEmpdobDate" class="invalid-tooltip fade hide" data-delay="1000"></span>
                                                </div>
                                            </div><!-- Col -->

                                  <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Emergency Contact No </label>
                                                   <asp:TextBox  runat="server"   MaxLength="11"   id="txtEmergencyContactNo" class="form-control form-control-sm mb-3 " placeholder="Emergency contact no"></asp:TextBox>

                                                      <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server"
                                                                                        Enabled="True" TargetControlID="txtEmergencyContactNo" FilterType="Custom" ValidChars="0123456789"></asp:FilteredTextBoxExtender>
                                                </div>
                                            </div> 

                                  <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">EC. Person & Relarionship </label>
                                                   <asp:TextBox  runat="server"    id="txtEmrgContactNoRelaton" class="form-control form-control-sm mb-3 " placeholder="Emergency Contact Person & Relarionship"></asp:TextBox>

                                                      
                                                </div>
                                            </div> 
                                        </div>
                                   
                                        <div class="row">
                                            <div class="col-sm-6">
                                                <div class="form-group">
                                                    <label class="col-form-label">Present Address</label>
                                                   <asp:TextBox  runat="server"  rows="2" TextMode="MultiLine"  id="txtEmpAddress" class="form-control form-control-sm mb-3 "   placeholder="Enter present address"></asp:TextBox>
                                                </div>
                                            </div><!-- Col -->

                                            <div class="col-sm-6">
                                                <div class="form-group">
                                                    <label class="col-form-label">Permanent Address</label>
                                                   <asp:TextBox  runat="server"  TextMode="MultiLine"  id="txtEmpPresentAddress" class="form-control form-control-sm mb-3 " rows="2" placeholder="Enter permanent address"></asp:TextBox>
                                                </div>
                                            </div><!-- Col -->
                                        </div>

                                        <br />
                                        <div class="row">
                                            <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Gender</label>
                                                     <asp:DropDownList   runat="server"   id="GenderSelect" name="GenderSelect" class="form-select form-select-sm mb-3 mySelect2 " >
                                                         <asp:ListItem Value="0">Select Gender</asp:ListItem>
                                                         <asp:ListItem>Male</asp:ListItem>
                                                         <asp:ListItem>Female</asp:ListItem>
                                                    </asp:DropDownList>
                                                      <script type="text/javascript">


                                                          function pageLoad() {


                                                              $('.datepicker').pickadate({
                                                                  selectMonths: true,
                                                                  selectYears: true
                                                              })
                                                              $('.multiple-select').select2({
                                                                  includeSelectAllOption: true,
                                                                  theme: 'bootstrap4',
                                                                  width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                                  placeholder: $(this).data('placeholder'),
                                                                  allowClear: Boolean($(this).data('allow-clear')),
                                                              });
                                                              $('.mySelect2').select2({
                                                                  theme: 'bootstrap4',
                                                                  width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                                  placeholder: $(this).data('placeholder'),
                                                                  allowClear: Boolean($(this).data('allow-clear')),
                                                              });
                                                          }
                                                      </script>  
                                                    
                                                </div>
                                            </div><!-- Col -->

                                            <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Religion</label>
                                                     <asp:DropDownList   runat="server"   id="ReligionSelect" name="ReligionSelect" class="form-select form-select-sm mb-3 mySelect2 " >
                                                         <asp:ListItem Value="">Select from list</asp:ListItem>
                                                         <asp:ListItem>Islam</asp:ListItem>
                                                         <asp:ListItem>Hindu</asp:ListItem>
                                                         <asp:ListItem>Christian</asp:ListItem>
                                                    </asp:DropDownList>
                                                    
                                                </div>
                                            </div><!-- Col -->

                                            <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Nationality</label>
                                                   

                                                                <asp:DropDownList   runat="server"   id="Nationality" name="Nationality" class="form-select form-select-sm mb-3 mySelect2 " >
                                                         <asp:ListItem Value="">Select from list</asp:ListItem>
                                                         <asp:ListItem>Bangladeshi</asp:ListItem>
                                                         <asp:ListItem>Indian</asp:ListItem>
                                                         <asp:ListItem>Others</asp:ListItem>
                                                    </asp:DropDownList>
                                                       
                                                     
                                                </div>
                                            </div><!-- Col -->
                                            <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Blood Group</label>

                                                    
                                                                <asp:DropDownList   runat="server"   id="BloodGroupSelect" name="BloodGroupSelect" class="form-select form-select-sm mb-3 mySelect2 " >
                                                         <asp:ListItem Value="">Select from list</asp:ListItem>
                                                         <asp:ListItem>A+</asp:ListItem>
                                                         <asp:ListItem>A-</asp:ListItem>
                                                         <asp:ListItem>B+</asp:ListItem>
                                                         <asp:ListItem>B-</asp:ListItem>
                                                         <asp:ListItem>O+</asp:ListItem>
                                                         <asp:ListItem>O-</asp:ListItem>
                                                         <asp:ListItem>AB+</asp:ListItem>
                                                         <asp:ListItem>AB-</asp:ListItem>
                                                    </asp:DropDownList>
                                                     
                                                </div>
                                            </div><!-- Col -->
                                        </div>
                                        <br />
                                        <div class="row">
                                            <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Marital Status</label>

                                                       <asp:DropDownList   runat="server"   id="MaritalStatusSelect" name="MaritalStatusSelect" class="form-select form-select-sm mb-3 mySelect2 " >
                                                         <asp:ListItem Value="">Select from list</asp:ListItem>
                                                         <asp:ListItem>Married</asp:ListItem>
                                                         <asp:ListItem>Unmarried</asp:ListItem>
                                                        
                                                    </asp:DropDownList>
                                                  
                                                </div>
                                            </div><!-- Col -->

                                            <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">NID No</label>
                                                  <asp:TextBox  runat="server"    id="txtNIDNO" class="form-control form-control-sm mb-3 " placeholder="Enter NID No"  MaxLength="17" ></asp:TextBox>
                                                     <asp:FilteredTextBoxExtender ID="FilnidteredTextBoxExtenderunitValue" runat="server"
                                                                                        Enabled="True" TargetControlID="txtNIDNO" FilterType="Custom" ValidChars="0123456789"></asp:FilteredTextBoxExtender>
                                                </div>
                                            </div><!-- Col -->

                                             <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Email </label>
                                                   <asp:TextBox  runat="server"   id="txtEmail" class="form-control form-control-sm mb-3 " placeholder="Employee email"></asp:TextBox>
                                                </div>
                                            </div><!-- Col -->
                                       
                                                   <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Employee Contact No </label>
                                              <asp:TextBox  runat="server"    id="txtEmpContactNo" class="form-control form-control-sm mb-3 "   MaxLength="11" placeholder="Employee contact no"></asp:TextBox>
                                                      <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server"
                                                                                        Enabled="True" TargetControlID="txtEmpContactNo" FilterType="Custom" ValidChars="0123456789"></asp:FilteredTextBoxExtender>
                                                </div>
                                            </div><!-- Col -->
                                        </div>



                            
                                        <div class="row">
                                            
                                            


                                                     <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Date of Join <span class="text-sm-left text-c-red">*</span></label>
                                                   <asp:TextBox  runat="server"     id="txtDateofjoin"  class="form-control form-control-sm mb-3  datepicker" autocomplete="off" placeholder="Select from date" ></asp:TextBox>
                                                </div>
                                            </div><!-- Col -->

                                               <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label for="txtDateofjoin" class=" col-form-label">Department:  </label>

                                                 
                                                       
                                                      <asp:DropDownList   runat="server"    id="DepartmentSelect" name="DepartmentSelect"  class="form-select form-select-sm mb-3 mySelect2 " ></asp:DropDownList>
                                                        </select>
                                                        <span id="v-DepartmentSelect" class="invalid-tooltip fade hide" data-delay="1000"></span>

  </div>
                                                    
                                              
                                                </div>

                                               <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label for="txtDateofjoin" class=" col-form-label">Designation:  </label>

                                                 
                                                   <asp:DropDownList   runat="server"    id="DesignationSelect" name="DesignationSelect"  class="form-select form-select-sm mb-3 mySelect2 " ></asp:DropDownList>
                                                       
                                                        <span id="v-DesignationSelect" class="invalid-tooltip fade hide" data-delay="1000"></span>

  </div>
                                                    
                                              
                                                </div>

                                              
                                               <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label for="txtDateofjoin" class=" col-form-label">Shift:  <span class="text-sm-left text-c-red">*</span> </label>

                                                 
                                                     <asp:DropDownList   runat="server"    id="ShiftSelect" name="ShiftSelect"  class="form-select form-select-sm mb-3 mySelect2 " ></asp:DropDownList>
                                                        <span id="v-ShiftSelect" class="invalid-tooltip fade hide" data-delay="1000"></span>


  </div>
                                                    
                                              
                                                </div>


                                             
                                            </div>

                            

                          
                                        <br />

                                        <div class="row">
                                            <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Reference Person Name </label>
                                                   <asp:TextBox  runat="server"    id="ReferencePersonName" class="form-control form-control-sm mb-3 " placeholder="Enter reference Person Name"></asp:TextBox>
                                                </div>
                                            </div><!-- Col -->

                                            <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Reference Contact No </label>
                                                  <asp:TextBox  runat="server"  MaxLength="11"    id="ReferenceContactNo" class="form-control form-control-sm mb-3 " placeholder="Enter reference contact no"></asp:TextBox>

                                                     <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server"
                                                                                        Enabled="True" TargetControlID="ReferenceContactNo" FilterType="Custom" ValidChars="0123456789"></asp:FilteredTextBoxExtender>
                                                </div>
                                            </div><!-- Col -->


                                                <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Last Company Name </label>
                                                   <asp:TextBox  runat="server"    id="txtLastCompanyName" class="form-control form-control-sm mb-3 " placeholder="Last Company Name "></asp:TextBox>
                                                </div>
                                            </div> 

                                            
                                             <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Last Job Location </label>
                                                   <asp:TextBox  runat="server"    id="txtLastJobLocation" class="form-control form-control-sm mb-3 " placeholder="Last Company Name "></asp:TextBox>
                                                </div>
                                            </div> 
                                        </div>
                                        <br />

                                        <div class="row">
                                           

                                                  <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Job Left Date</label>
                                                  <asp:TextBox  runat="server"    id="txtJobLeftDate" type="text" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select date of birth" ></asp:TextBox>

                                                    <span id="v-txtJobLeftDate" class="invalid-tooltip fade hide" data-delay="1000"></span>
                                                </div>
                                            </div><!-- Col -->

                                     


                                         

                                             <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Monthly Allawance</label>
                                                   
                                                <asp:ListBox   runat="server"  id="ddlMonthlyAllawance"  SelectionMode="Multiple"   class="form-select form-select-sm mb-3 multiple-select"  name="ddlProLine"></asp:ListBox>
                                                </div>
                                            </div><!-- Col -->

                                              <div class="col-sm-3">
                                            <div class="form-group">
                                                <label class="col-form-label">Is Probation </label>
                                                <div class="custom-control custom-switch">
                                                    <input type="checkbox" runat="server" class="custom-control-input" id="chkIsProbation"  >
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-sm-3">
                                            <div class="form-group">
                                                <label class="col-form-label">Probation End Date</label>
                                                <asp:TextBox runat="server" ID="txtProbationEndDate" type="text" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select date of birth"></asp:TextBox>

                                                <span id="v-txtProbationEndDate" class="invalid-tooltip fade hide" data-delay="1000"></span>
                                            </div>
                                        </div>

                                                 <div class="col-sm-3">
                                                <div class="form-group">
                                                    <label class="col-form-label">Active Status</label>
                                                    <div class="custom-control custom-switch">
                                                        <input type="checkbox" runat="server" class="custom-control-input" id="chkIsActive" checked onchange="IsActiveChange()">
                                                        <label style="padding-top:4px;" class="custom-col-form-label" for="chkIsActive"> Active</label> 
                                                    </div>
                                                </div>
                                            </div><!-- Col -->
                                        </div>

                                            




                                    
 <asp:HiddenField runat="server" ID="id_mastetID"/>

                     
                        <div runat="server" visible="false">
                            
                        <br />

   <h4> Login Access</h4>

                                    <hr />
                                              <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <asp:HiddenField runat="server" ID="hfNSMId" />
                                    <asp:HiddenField runat="server" ID="hfRSMId" />
                                    <asp:HiddenField runat="server" ID="hfAMID" />
                                    <asp:HiddenField runat="server" ID="hfMIOId" />
                                    <asp:HiddenField runat="server" ID="hfUserId" />
                                    <div class="form-group row">
                                        <label for="txtUserName" class="col-sm-3 col-form-label">Login ID </label>
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
                                              <asp:DropDownList  runat="server"  AutoPostBack="true" OnSelectedIndexChanged="ddlUserRole_SelectedIndexChanged"  class="form-select form-select-sm mb-3 mySelect2" id="ddlUserRole"></asp:DropDownList>
                                                <span id="v-ddlUserRole" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                               
                                                 <span class="input-group-text text_Link"><asp:LinkButton runat="server" ID="loadUserRole" OnClick="loadUserRole_Click"><i class="fa fa-refresh"></i></asp:LinkButton></span>
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

                                        <div  runat="server" visible="false" id="divmRAccess">
                                    <br />
                                   <h4>  Market Access</h4>
                                    <hr />

                                       <div class="row mt-1" runat="server" visible="false" id="divGroup">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="acDate" class="col-sm-3 col-form-label">Group </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                     <asp:DropDownList runat="server" id="GroupSelect" AutoPostBack="true" OnSelectedIndexChanged="GroupSelect_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2" >   </asp:DropDownList>
                                                
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>

 


                                       <div class="row mt-1"  runat="server" visible="false" id="divZone">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="acDate" class="col-sm-3 col-form-label">Zone </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                         <asp:DropDownList runat="server"  id="ZoneSelect" AutoPostBack="true" OnSelectedIndexChanged="ZoneSelect_SelectedIndexChanged"  class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>   
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>


                                       <div class="row mt-1"   runat="server" visible="false" id="divArea">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="acDate" class="col-sm-3 col-form-label">Area </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                       <asp:DropDownList runat="server"   id="AreaSelect"  AutoPostBack="true" OnSelectedIndexChanged="AreaSelect_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>


                                            <div class="row mt-1"    runat="server" visible="false" id="divTerritory">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="acDate" class="col-sm-3 col-form-label">Territory </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                           <asp:DropDownList runat="server"    id="TeritorySelect"     class="form-select form-select-sm mb-3 mySelect2">   </asp:DropDownList>

                                                
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>

                                            </div>
                                    
                                  <div runat="server" id="dcDiv" visible="false">

                                        <h4>  DC Permission</h4>
                                    <hr />
 

                                    
                                    <div class="form-group row" style="margin-top:6px;">

                                       <label for="MarketSelect" class="col-sm-3 col-form-label"> Distribution Center  </label>

                                    <div class="col-sm-5">

                                         <asp:ListBox runat="server" ID="ddlDistributionCenter" SelectionMode="Multiple" class="form-select form-select-sm mb-3 multiple-select" name="BrandSelect"></asp:ListBox>
</div>
</div>
 

                                  </div>

                                    <br />

                                          <div class="row mt-1">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <div class="form-group row">
                                        <label for="acDate" runat="server" id="pacinTxt" class="col-sm-3 col-form-label">Effective Date </label>
                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox   runat="server"    id="txtacDate" type="text" class="datepicker form-control form-control-sm mb-3" autocomplete="off" placeholder="Select Date" ></asp:TextBox>
                                                <span class="input-group-text text-c-red">*</span>
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
                                      
                                      <br />
                                            <div class="row">
                                                <div class="col-2">&nbsp;</div>
                                                <div class="col-8">

                                                    <div class="form-group row" style="text-align:center">
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                        <div class="col-sm-8">
                                                              <asp:LinkButton   OnClientClick="return sweetAlertConfirm_Submit(this);"  OnClick="btnSave_Click" Visible="false"  runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                             <asp:LinkButton   OnClientClick="return sweetAlertConfirm_Update(this);"   OnClick="btnSave_Click"  Visible="false"   runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Update
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server" id="btnReset" OnClick="btnReset_Click" Visible="false"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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
   
</asp:Content>

