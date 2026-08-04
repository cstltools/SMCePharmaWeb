<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DoctorEntry.aspx.cs" Inherits="MasterSetup_UI_DoctorEntry" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register Src="~/MasterSetup_UI/IVMarketStructure.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="popDiv">
    </div> 
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Doctor Information</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../MasterSetup_UI/DoctorView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                    <asp:HiddenField runat="server" ID="id_mastetID" />




                                    <div class="row">

                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="DoctorName" class="col-sm-3 col-form-label">Doctor name:  </label>

                                                <div class="col-sm-7">
                                                    <asp:TextBox runat="server" CssClass="form-control form-control-sm " ID="DoctorName" placeholder="Doctor name"></asp:TextBox>

                                                    <span id="v-DoctorName" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>

                                        </div>
                                        <div class="col-6">

                                            <div class="form-group row">
                                                <label for="docCat" class="col-sm-3 col-form-label">Doctor Category:  </label>

                                                <div class="col-sm-7">
                                                    <asp:DropDownList runat="server" ID="docCat" name="DoctorTypeSelect" CssClass="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>
                                                    <span id="Span1" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                </div>

                                            </div>
                                            <div class="form-group row" runat="server" visible="false">
                                                <label for="SecondaryCode" class="col-sm-3 col-form-label">Secondary Code:  </label>

                                                <div class="col-sm-7">
                                                    <asp:TextBox runat="server" CssClass="form-control form-control-sm " ID="SecondaryCode" placeholder="Secondary Code"></asp:TextBox>

                                                    <span id="v-SecondaryCode" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                </div>

                                            </div>

                                        </div>
                                    </div>

                                    <div class="row" runat="server" visible="false">

                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="UPCode" class="col-sm-3 col-form-label">UP Code:  </label>

                                                <div class="col-sm-7">
                                                    <asp:TextBox runat="server" CssClass="form-control form-control-sm " ID="UPCode" placeholder="UP Code"></asp:TextBox>

                                                    <span id="v-UPCode" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                </div>

                                            </div>

                                        </div>

                                    </div>




                                    <div class="row">

                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="designationSelect" class="col-sm-3 col-form-label">Designation:  </label>

                                                <div class="col-sm-7">
                                                    <asp:DropDownList runat="server" ID="designationSelect" name="designationSelect" CssClass="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>
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
                                                    <span id="v-designationSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>

                                        </div>

                                        <div class="col-6">

                                             <div class="form-group row">
                                                <label for="GenderSelect" class="col-sm-3 col-form-label">Gender:  </label>

                                                <div class="col-sm-7">
                                                    <asp:DropDownList CssClass="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="GenderSelect" name="GenderSelect">

                                                        <asp:ListItem>Select from list</asp:ListItem>
                                                        <asp:ListItem>Male</asp:ListItem>
                                                        <asp:ListItem>Female</asp:ListItem>
                                                        <asp:ListItem>Other</asp:ListItem>

                                                    </asp:DropDownList>

                                                    <span id="v-GenderSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>
                                           

                                        </div>
                                    </div>

                                    <div class="row">
                                    </div>


                




                                    <div class="row">

                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="DoctorTypeSelect" class="col-sm-3 col-form-label">Doctor Type:  </label>

                                                <div class="col-sm-7">
                                                    <asp:DropDownList runat="server" AutoPostBack="true" OnSelectedIndexChanged="DoctorTypeSelect_SelectedIndexChanged" ID="DoctorTypeSelect" name="DoctorTypeSelect" CssClass="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>
                                                    <span id="v-DoctorTypeSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                </div>

                                            </div>

                                        </div>
                                        <div class="col-6">

                                             <div class="form-group row">
                                                <label for="txtNID" class="col-sm-3 col-form-label">Provider Type:</label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">
                                                        <asp:DropDownList CssClass="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlProgramType"></asp:DropDownList>


                                                        <span class="input-group-text text-c-red">*</span>

                                                    </div>

                                                </div>
                                            </div>
                                        
                                            <div class="form-group row">
                                                <label for="txtNID" class="col-sm-3 col-form-label">Pharma Platform:</label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">
                                                        <asp:DropDownList CssClass="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlPharmaPlatform"></asp:DropDownList>


                                                       

                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>





                                    <div class="row">

                                        <div class="col-6">
                                            <div class="form-group row" runat="server" visible="false">
                                                <label for="txtNID" class="col-sm-3 col-form-label">Station Type:</label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">
                                                        <asp:DropDownList CssClass="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlStationType"></asp:DropDownList>


                                                        <span class="input-group-text text-c-red">*</span>

                                                    </div>

                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-6">
                                           
                                        </div>

                                    </div>
                                    <br />
                                                        <div class="row">

                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="BrandSelect" class="col-sm-3 col-form-label">Brand:  </label>

                                                <div class="col-sm-7">
                                                    <asp:ListBox runat="server" ID="BrandSelect" SelectionMode="Multiple" class="form-select form-select-sm mb-3 multiple-select" name="BrandSelect"></asp:ListBox>

                                                    <span id="v-BrandSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>

                                        </div>
                                        <div class="col-6">
                                           
                                             <div class="form-group row">
                                                <label for="doctorSpecialitySelect" class="col-sm-3 col-form-label">Speciality:  </label>

                                                <div class="col-sm-7">
                                                    <asp:ListBox runat="server" ID="doctorSpecialitySelect" SelectionMode="Multiple" class="form-select form-select-sm mb-3 multiple-select" name="doctorSpecialitySelect"></asp:ListBox>

                                                    <span id="v-doctorSpecialitySelect" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">

                                         <div class="col-6">
                                            <div class="form-group row">
                                                <label for="degreeSelect" class="col-sm-3 col-form-label">Degree:  </label>

                                                <div class="col-sm-7">
                                                    <asp:ListBox ID="degreeSelect" runat="server" CssClass=" form-select form-select-sm mb-3 multiple-select" SelectionMode="Multiple"></asp:ListBox>
                                                    <%-- <asp:DropDownList  runat="server"  id="degreeSelect"   class=" form-select form-select-sm mb-3 multiple-select"   multiple="multiple"    name="degreeSelect"></asp:DropDownList>--%>

                                                    <span id="v-degreeSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>

                                    </div>
                                    </div>

                                    <br />
                                    <br />

                                    <h4>Market Structure</h4>
                                    <hr />
                                    <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
                                    <br />
                                    <br />
                                    <div class="row">

                                        <div class="col-6">
                                            <div class="form-group row"  runat="server" visible="false">
                                                <label for="txtNID" class="col-sm-4 col-form-label">Division:</label>

                                                <div class="col-sm-6">
                                                    <div class="input-group">
                                                        <asp:DropDownList CssClass="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlDivision" AutoPostBack="true" OnSelectedIndexChanged="ddlDivision_SelectedIndexChanged"></asp:DropDownList>


                                                        <span class="input-group-text text-c-red">*</span>

                                                    </div>

                                                </div>
                                            </div>

                                             <div class="form-group row"  runat="server" visible="false">
                                                <label for="txtNID" class="col-sm-4 col-form-label">District:</label>

                                                <div class="col-sm-6">
                                                    <div class="input-group">
                                                        <asp:DropDownList CssClass="form-select form-select-sm mb-3 mySelect2 " AutoPostBack="true" OnSelectedIndexChanged="ddlDistrict_SelectedIndexChanged" runat="server" ID="ddlDistrict"></asp:DropDownList>


                                                        <span class="input-group-text text-c-red">*</span>

                                                    </div>

                                                </div>
                                            </div>
                                                <div class="form-group row"  runat="server" visible="false">
                                                <label for="txtNID" class="col-sm-4 col-form-label">Thana:</label>

                                                <div class="col-sm-6">
                                                    <div class="input-group">
                                                        <asp:DropDownList CssClass="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlThana"></asp:DropDownList>


                                                        <span class="input-group-text text-c-red">*</span>

                                                    </div>

                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-6">
                                           
                                        </div>

                                    </div>



                                    <div class="row">

                                        <div class="col-6">
                                        
                                        </div>

                                        <div class="col-6">
                                            <div class="form-group row" runat="server" visible="false">
                                                <label for="txtNID" class="col-sm-3 col-form-label">Union Name:</label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">
                                                        <asp:TextBox CssClass="form-control form-control-sm mb-3 " runat="server" ID="txtUnion" placeholder=" Union Name"></asp:TextBox>


                                                        <span class="input-group-text text-c-red">*</span>

                                                    </div>

                                                </div>
                                            </div>
                                        </div>

                                    </div>



                                    <br />
                                    <br />
                                    <br />
                                    <h4>Chamber List</h4>
                                    <hr />
                                    <div class="row">

                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="ChamberTypeSelect" class="col-sm-3 col-form-label">Chamber Type:  </label>

                                                <div class="col-sm-7">
                                                    <asp:DropDownList runat="server" ID="ChamberTypeSelect" name="ChamberTypeSelect" CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                    <span id="v-ChamberTypeSelect" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                </div>

                                            </div>
                                        </div>

                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="txtChamberName" class="col-sm-3 col-form-label">Chamber Name:  </label>

                                                <div class="col-sm-7">
                                                    <asp:TextBox runat="server" CssClass="form-control form-control-sm mb-3 " ID="txtChamberName" placeholder=" Chamber Name"></asp:TextBox>



                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="txtChamberName" class="col-sm-3 col-form-label">Phone:  </label>

                                                <div class="col-sm-7">
                                                    <asp:TextBox runat="server" CssClass="form-control form-control-sm mb-3 " ID="txtPhone" placeholder=" Chamber Phone"  MaxLength="11"></asp:TextBox>

                                                     <asp:FilteredTextBoxExtender ID="FilteredTssextBoxExtender1" runat="server"
                                                                                        Enabled="True" TargetControlID="txtPhone" FilterType="Custom" ValidChars="0123456789"></asp:FilteredTextBoxExtender>

                                                </div>

                                            </div>
                                        </div>



                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="ChamberTypeSelect" class="col-sm-3 col-form-label">Chamber Address:  </label>

                                                <div class="col-sm-7">
                                                    <asp:TextBox CssClass="form-control form-control-sm mb-3 " TextMode="MultiLine" Rows="3" runat="server" ID="txtChamberAddress" placeholder="Chamber Address"></asp:TextBox>



                                                </div>

                                            </div>
                                        </div>


                                    </div>

                                    <div class="row">
                                        <div class="col-9">
                                        </div>

                                        <div class="col-2">
                                            <asp:LinkButton ID="addButtonChamber" runat="server" CssClass="btn btn-sm btn-success pull-left" OnClick="addButtonChamber_Click"><i class="fa fa-plus-circle"></i>Add To List</asp:LinkButton>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="table-responsive" id="MainGradeDiv">

                                                <asp:GridView ID="gv_Chamber" ShowHeaderWhenEmpty="true" runat="server" AutoGenerateColumns="False"
                                                    CssClass="table table-bordered  text-center thead-dark">
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="SL#">
                                                            <ItemTemplate>
                                                                <%#Container.DataItemIndex+1 %>
                                                                <asp:HiddenField runat="server" ID="hfChamberTypeId" Value='<%#Eval("ChamberTypeId")%>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Chamber Type">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_ChamberType" runat="server" Text='<%#Eval("ChamberTypeName") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>


                                                        <asp:TemplateField HeaderText="Chamber Name">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_ChamberName" runat="server" Text='<%#Eval("ChamberName") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>



                                                        <asp:TemplateField HeaderText="Phone">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_Phone" runat="server" Text='<%#Eval("Phone") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Chamber Address">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_ChamberAddress" runat="server" Text='<%#Eval("ChamberAddress") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Remove">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="deleteChamber" runat="server" OnClick="deleteChamber_Click" CssClass="btn-danger  btn-sm mb-1 mb-md-0"><i class='fa fa-minus' aria-hidden='true'></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                    </Columns>
                                                </asp:GridView>


                                            </div>

                                        </div>
                                    </div>

                                    <br />


                                    <br />
                                    <h4>Contacts List</h4>
                                    <hr />
                                    <div class="row">

                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="ddlContactType" class="col-sm-3 col-form-label">Contact Type:  </label>

                                                <div class="col-sm-7">
                                                    <asp:DropDownList runat="server" ID="ddlContactType" name="ChamberTypeSelect" CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                    <span id="v-ddlContactType" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                </div>

                                            </div>
                                        </div>

                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="txtContact" class="col-sm-3 col-form-label">Contact:  </label>

                                                <div class="col-sm-7">
                                                    <asp:TextBox runat="server" CssClass="form-control form-control-sm mb-3 " ID="txtContact" placeholder=" Contact"></asp:TextBox>

                                                          

                                                </div>

                                            </div>
                                        </div>
                                    </div>


                                    <div class="row">
                                        <div class="col-9">
                                        </div>

                                        <div class="col-2">
                                            <asp:LinkButton ID="lblContactAdd" runat="server" CssClass="btn btn-sm btn-success pull-left" OnClick="lblContactAdd_Click"><i class="fa fa-plus-circle"></i>Add To List</asp:LinkButton>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="table-responsive" id="MainGradeDivContact">

                                                <asp:GridView ID="gv_Contact" ShowHeaderWhenEmpty="true" runat="server" AutoGenerateColumns="False"
                                                    CssClass="table table-bordered  text-center thead-dark">
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="SL#">
                                                            <ItemTemplate>
                                                                <%#Container.DataItemIndex+1 %>
                                                                <asp:HiddenField runat="server" ID="hfContactTypeId" Value='<%#Eval("ContactTypeId")%>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Contact Type">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_ContactType" runat="server" Text='<%#Eval("ContactType") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>


                                                        <asp:TemplateField HeaderText="Contact">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_Contact" runat="server" Text='<%#Eval("Contact") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>




                                                        <asp:TemplateField HeaderText="Remove">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="deleteContact" runat="server" OnClick="deleteContact_Click" CssClass="btn-danger  btn-sm mb-1 mb-md-0"><i class='fa fa-minus' aria-hidden='true'></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                    </Columns>
                                                </asp:GridView>


                                            </div>

                                        </div>
                                    </div>

                                    <br />

                                    <br />
                                    <h4>Special Days List</h4>
                                    <hr />
                                    <div class="row">

                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="ddlSpecialDay" class="col-sm-3 col-form-label">Special Day:  </label>

                                                <div class="col-sm-7">
                                                    <asp:DropDownList runat="server" ID="ddlSpecialDay" name="ddlSpecialDay" CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                    <span id="v-ddlSpecialDay" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                </div>

                                            </div>
                                        </div>

                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="txtSpecialDate" class="col-sm-3 col-form-label">Date:  </label>

                                                <div class="col-sm-7">
                                                    <asp:TextBox runat="server" CssClass="form-control form-control-sm mb-3 datepicker" ID="txtSpecialDate" placeholder="Select Special Date"></asp:TextBox>



                                                </div>

                                            </div>
                                        </div>
                                    </div>


                                    <div class="row">
                                        <div class="col-9">
                                        </div>

                                        <div class="col-2">
                                            <asp:LinkButton ID="btnSpecialAdd" runat="server" CssClass="btn btn-sm btn-success pull-left" OnClick="btnSpecialAdd_Click"><i class="fa fa-plus-circle"></i>Add To List</asp:LinkButton>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="table-responsive" id="MainGradeDivSpecialAdd">

                                                <asp:GridView ID="gv_Special" ShowHeaderWhenEmpty="true" runat="server" AutoGenerateColumns="False"
                                                    CssClass="table table-bordered  text-center thead-dark">
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="SL#">
                                                            <ItemTemplate>
                                                                <%#Container.DataItemIndex+1 %>
                                                                <asp:HiddenField runat="server" ID="hfSpecialDayId" Value='<%#Eval("SpecialDayId")%>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Special Day ">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_SpecialDay" runat="server" Text='<%#Eval("SpecialDay") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Date">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_SpecialDate" runat="server" Text='<%#Eval("SpecialDate") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>




                                                        <asp:TemplateField HeaderText="Remove">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="deleteSpecial" runat="server" OnClick="deleteSpecial_Click" CssClass="btn-danger  btn-sm mb-1 mb-md-0"><i class='fa fa-minus' aria-hidden='true'></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                    </Columns>
                                                </asp:GridView>


                                            </div>

                                        </div>
                                    </div>


                                    
                                    <div class="row">

                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="txtNID" class="col-sm-7 col-form-label"></label>

                                                <div class="col-sm-4">
                                                    <div class="input-group">
                                                       
                                                        <asp:TextBox Visible="false" CssClass="form-control form-control-sm mb-3 datepicker" runat="server" ID="txtActiveDate" placeholder=" Select Date"></asp:TextBox>

                                                    </div>

                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-6">
                                            <div class="form-group row" runat="server" visible="false">
                                                <label for="txtNID" class="col-sm-3 col-form-label">Remarks:</label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">

                                                        <asp:TextBox CssClass="form-control form-control-sm mb-3 " TextMode="MultiLine" Rows="2" runat="server" ID="txtRemarks" placeholder=" Remarks"></asp:TextBox>



                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <br />
                               

                                         <div class="row" id="div1" runat="server">
                            <div class="col-2">&nbsp;</div>
                                       <div class="col-8">
                                  <div class="form-group row">
                                 <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label><br />

                                    <div class="col-sm-5">
                                                
                                                
                                                    <div class="col-sm-5">
                                                        <div class="form-check form-switch">
													<input class="form-check-input" type="checkbox" runat="server" id="chkIsActive" checked>
												 <label  class="custom-control-label" for="chkIsActive">Active</label>
												</div>


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
                                                    <asp:LinkButton OnClientClick="return sweetAlertConfirm_Submit(this);" OnClick="btnSave_Click" Visible="false" runat="server" ID="btnSave" class="btn btnMyDesignSearch   btn-sm">
                                            <i class="fa fa-check"></i>Submit
                                                    </asp:LinkButton>

                                                    <asp:LinkButton OnClientClick="return sweetAlertConfirm_Update(this);" OnClick="btnSave_Click" Visible="false" runat="server" ID="btnUpdate" class="btn btnMyDesignSearch   btn-sm">
                                            <i class="fa fa-check"></i>Update
                                                    </asp:LinkButton>
                                                    <asp:LinkButton runat="server" class="btn btnMyDesignReset   btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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

