<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="Customer_Doctor_Transfer.aspx.cs" Inherits="MasterSetup_UI_Customer_Doctor_Transfer" %>

<%@ Register Src="~/MasterSetup_UI/IVMarketStructureFrom_To.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %>
<%@ Register Src="~/MasterSetup_UI/IVMarketStructureTo.ascx" TagPrefix="uc1" TagName="IVMarketStructureTo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style>
        .radioChoice label {
            padding-left: 5px;
            padding-right: 30px;
            font-size: 20px;
            font-weight: bold;
        }
    </style>
    <div id="popDiv">
    </div>

    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Customer/Doctor Transfer</div>

                <div class="ms-auto">
                    <div class="btn-group">
                          <asp:LinkButton ID="viewLinkButton"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="ListImageButton_Click" runat="server"> <i class="fa fa-backward"></i>&nbsp;Go to Approval List</asp:LinkButton>
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




                                        <div class="col-md-12" style="text-align: center">
                                            <asp:RadioButtonList runat="server" ID="rbType" CssClass="radioChoice" AutoPostBack="True" OnSelectedIndexChanged="rbType_SelectedIndexChanged" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                                <asp:ListItem Selected="True" Value="0">Customer Transfer</asp:ListItem>
                                                <asp:ListItem Value="1">Doctor Transfer</asp:ListItem>
                                            </asp:RadioButtonList>

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
                                            </script>
                                        </div>


                                    </div>

                                    <br />
                                    <div class="row">

                                        <div class="col-md-6">
                                            <fieldset class="for-panel">
                                                <legend>From</legend>
                                                <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
                                                <div class="form-group row">
                                                    <label for="GroupSelect" class="col-sm-3 col-form-label"></label>

                                                    <div class="col-sm-8">
                                                        <div class="input-group">

                                                            <asp:LinkButton runat="server" ID="btnSearch" class="btn btnMyDesignAddtoList   btn-sm pull-left" OnClick="btnSearch_Click">
                                               <i class="fa fa-search-plus"></i>Search &nbsp; 
                                                            </asp:LinkButton>

                                                            <span class="input-group-text text-c-red">&nbsp;</span>

                                                        </div>
                                                    </div>
                                                </div>
                                            </fieldset>
                                        </div>
                                        <div class="col-md-6">
                                            <fieldset class="for-panel">
                                                <legend>To</legend>
                                                <uc1:IVMarketStructureTo runat="server" ID="IVMarketStructureTo" />






                                            </fieldset>
                                        </div>

                                    </div>



                                    <br />
                                    <div class="row">

                                        <div class="col-12">

                                            <div class="table-responsive" id="MainGradeDiv">

                                                <asp:GridView ID="gv_Customer_List" runat="server" AutoGenerateColumns="False"
                                                    DataKeyNames="CustomerMasterId"
                                                    CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="SL#">
                                                            <ItemTemplate>
                                                                <%#Container.DataItemIndex+1 %>
                                                                <asp:HiddenField runat="server" ID="hfCustomerMasterId" Value='<%#Eval("CustomerMasterId")%>' />


                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <asp:CheckBox ID="chkSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:CheckBox ID="chkSelect" CssClass="form-control-sm" AutoPostBack="true" OnCheckedChanged="chkSelect_CheckedChanged" runat="server" />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                                        <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />

                                                        <asp:BoundField DataField="CustomerType" HeaderText="Customer Type" />

                                                       <asp:BoundField DataField="OwnerName" HeaderText="Owner Name" />
                                                <asp:BoundField DataField="CellNo" HeaderText="Mobile NO" />
                                                <asp:BoundField DataField="Address" HeaderText="Address" />



                                                        <%--<asp:BoundField DataField="DistributionRouteName" HeaderText="Distribution RouteName" />--%>
                                                    </Columns>
                                                </asp:GridView>



                                                <asp:GridView ID="gv_Doctor_List" runat="server" AutoGenerateColumns="False"
                                                    DataKeyNames="DoctorId"
                                                    CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="SL#">
                                                            <ItemTemplate>
                                                                <%#Container.DataItemIndex+1 %>
                                                                <asp:HiddenField runat="server" ID="hfDoctorId" Value='<%#Eval("DoctorId")%>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <asp:CheckBox ID="chkDoctorSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="chkDoctorSelectAll_CheckedChanged" />
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:CheckBox ID="chkDoctorSelect" CssClass="form-control-sm" runat="server" />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:BoundField DataField="DoctorCode" HeaderText="Doctor Code" />
                                                        <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />

                                                        <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                                                        <asp:BoundField DataField="DegreeName" HeaderText="Degree" />
                                                        <asp:BoundField DataField="DoctorSpeciality" HeaderText="Doctor Speciality" />

                                                           <asp:BoundField DataField="ChamberInfo" HeaderText="Chamber Info" />
                                                <asp:BoundField DataField="ContactName" HeaderText="Mobile NO" />
                                                <asp:BoundField DataField="DoctorAddress" HeaderText="Address" />


                                                    </Columns>
                                                </asp:GridView>

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




                                                    <asp:LinkButton OnClick="btnSave_Click" runat="server" ID="btnSave" class="btn btnMyDesignSearch   btn-sm" OnClientClick="return sweetAlertConfirm_Submit(this);">
                                            <i class="fa fa-check"></i>Submit
                                                    </asp:LinkButton>
                                                    <asp:LinkButton runat="server" ID="btnReset" OnClick="btnReset_Click" class="btn btnMyDesignReset   btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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

