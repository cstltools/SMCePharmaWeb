<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="RouteInformationEntry.aspx.cs" Inherits="MasterSetup_UI_RouteInformationEntry" %>

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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Route Information</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../MasterSetup_UI/RouteInformationList.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="form-group row">
                                                <label for="txtNID" class="col-sm-3 col-form-label">DC:</label>

                                                <div class="col-sm-5">
                                                    <div class="input-group">
                                                        <asp:DropDownList runat="server" ID="ddlDepotName" AutoPostBack="true" OnSelectedIndexChanged="dc_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>

                                                        <span class="input-group-text text-c-red">*</span>

                                                    </div>

                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label for="txtNID" class="col-sm-3 col-form-label"></label>

                                                <div class="col-sm-5">
                                                    <div class="input-group">
                                                        <asp:CheckBox runat="server" ID="chkIsSubDepo" Text="Is Sub-Depot" />



                                                    </div>

                                                </div>
                                            </div>
                                            <div class="form-group row">
                                                <label for="txtNID" class="col-sm-3 col-form-label">Route Name:</label>

                                                <div class="col-sm-5">
                                                    <div class="input-group">
                                                        <asp:TextBox class="form-control form-control-sm mb-3 " runat="server" ID="txtRouteName" placeholder="Route Name"></asp:TextBox>


                                                        <span class="input-group-text text-c-red">*</span>

                                                    </div>

                                                </div>
                                            </div>



                                        </div>
                                    </div>

                                    <br />
                                    <h4>DA Information</h4>
                                    <hr />

                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">DA Name: </label>

                                                <div class="col-sm-5">
                                                    <div class="input-group">
                                                        <asp:DropDownList runat="server" class="form-select form-select-sm mb-3 mySelect2 " ID="ddlDAName"></asp:DropDownList>

                                                        <script type="text/javascript">
                                                            function pageLoad() {
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
                                                        <span class="input-group-text text-c-red">*</span>

                                                    </div>

                                                </div>
                                                <div class="col-3">
                                                    <asp:LinkButton ID="addButtonDA" runat="server" CssClass="btn btn-sm btn-success" OnClick="addButtonDA_Click"><i class="fa fa-plus-circle"></i>Add To List</asp:LinkButton>
                                                </div>
                                            </div>
                                        </div>

                                    </div>

                                    <br />

                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="table-responsive" id="MainGradeDiv">

                                                <asp:GridView ID="gv_DA" runat="server" AutoGenerateColumns="False"
                                                    ShowHeaderWhenEmpty="true" CssClass="table table-bordered  text-center thead-dark" DataKeyNames="DANameId">
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="SL#">
                                                            <ItemTemplate>
                                                                <%#Container.DataItemIndex+1 %>
                                                                <asp:HiddenField runat="server" ID="hfDANameId" Value='<%#Eval("DANameId")%>' />

                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="DAName" HeaderText="DA Name" />


                                                        <asp:TemplateField HeaderText="Remove">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="deleteImageButton" runat="server" OnClick="deleteImageButton_Click" CssClass="btn-danger  btn-sm mb-1 mb-md-0"><i class='fa fa-minus' aria-hidden='true'></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                    </Columns>
                                                </asp:GridView>


                                            </div>

                                        </div>
                                    </div>
                                    <br />
                                    <h4>Market Structure</h4>
                                    <hr />

                                    <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />





                                    <div class="form-group row" style="margin-top: 6px;">

                                        <label for="MarketSelect" class="col-sm-2 col-form-label">Distance(km)</label>

                                        <div class="col-sm-3">
                                             <div class="input-group">
     <asp:TextBox class="form-control form-control-sm mb-3 " runat="server" ID="txtDistance" TextMode="SingleLine"  placeholder="Distance"></asp:TextBox>
     <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderDistance" runat="server"
         Enabled="True" TargetControlID="txtDistance" FilterType="Custom" ValidChars="0123456789.">
     </asp:FilteredTextBoxExtender>


     <span class="input-group-text text-c-red">*</span>

 </div>
                                        </div>

                                         <div class="col-sm-2">
 </div>
                                       
                                        <div class="col-sm-3">

                                            <asp:LinkButton ID="btnAddtoListMarket" runat="server" OnClick="btnAddtoListMarket_Click" CssClass="btn btn-sm btn-success pull-right"><i class="fa fa-plus-circle"></i>Add To List</asp:LinkButton>

                                        </div>
                                    </div>

                                    <br />

                                    <div class="row">
                                         
                                        <div class="col-12">

                                            <div class="table-responsive" id="MainGradeDiv2">

                                                <asp:GridView ID="gv_Market" runat="server" AutoGenerateColumns="False"
                                                    ShowHeaderWhenEmpty="true" CssClass="table table-bordered  text-center thead-dark">
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

                                                        <asp:TemplateField HeaderText="AreaName">
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

                                                        <asp:TemplateField HeaderText="Distance (km)">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtGridDistance" runat="server" CssClass="form-control form-control-sm grid-distance" Text='<%# Eval("Distance") %>' oninput="updateMarketDistanceTotal();"></asp:TextBox>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Move">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="btnMoveUp" runat="server" OnClick="MarketMoveUp_Click" CssClass="btn btn-sm btn-outline-secondary me-1"><i class="fa fa-arrow-up"></i></asp:LinkButton>
                                                                <asp:LinkButton ID="btnMoveDown" runat="server" OnClick="MarketMoveDown_Click" CssClass="btn btn-sm btn-outline-secondary"><i class="fa fa-arrow-down"></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>


                                                        <asp:TemplateField HeaderText="Remove">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="MarketdeleteImageButton" runat="server" OnClick="MarketdeleteImageButton_Click" CssClass="btn-danger  btn-sm mb-1 mb-md-0"><i class='fa fa-minus' aria-hidden='true'></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                    </Columns>
                                                </asp:GridView>


                                            </div>

                                        </div>
                                    </div>
                                    <br />

                                    <br />
                                    <h4>Route Information </h4>
                                    <hr />

                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="txtNID" class="col-sm-3 col-form-label">Total Distance(KM):</label>

                                                <div class="col-sm-5">
                                                    <div class="input-group">
                                                        <asp:TextBox class="form-control form-control-sm mb-3 " runat="server" ID="txtTotalDistance" placeholder="Total Distance"></asp:TextBox>
                                                        <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderunitValue" runat="server"
                                                            Enabled="True" TargetControlID="txtTotalDistance" FilterType="Custom" ValidChars="0123456789.">
                                                        </asp:FilteredTextBoxExtender>

                                                        <span class="input-group-text text-c-red">*</span>

                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <script type="text/javascript">
                                        function updateMarketDistanceTotal() {
                                            var total = 0;
                                            var inputs = document.querySelectorAll('.grid-distance');
                                            for (var i = 0; i < inputs.length; i++) {
                                                var val = parseFloat(inputs[i].value);
                                                if (!isNaN(val)) {
                                                    total += val;
                                                }
                                            }
                                            var totalBox = document.getElementById('<%= txtTotalDistance.ClientID %>');
                                            if (totalBox) {
                                                totalBox.value = total === 0 ? '' : total.toFixed(2).replace(/\.?0+$/, '');
                                            }
                                        }
                                    </script>


                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="txtNID" class="col-sm-3 col-form-label">Total Day:</label>

                                                <div class="col-sm-5">
                                                    <div class="input-group">
                                                        <asp:TextBox class="form-control form-control-sm mb-3 " runat="server" ID="txtTotalDay" placeholder="Total Day"></asp:TextBox>
                                                        <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server"
                                                            Enabled="True" TargetControlID="txtTotalDay" FilterType="Custom" ValidChars="0123456789.">
                                                        </asp:FilteredTextBoxExtender>

                                                        <span class="input-group-text text-c-red">*</span>

                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>


                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="txtNID" class="col-sm-3 col-form-label">Route Type:</label>

                                                <div class="col-sm-5">
                                                    <div class="input-group">
                                                        <asp:DropDownList runat="server" class="form-select form-select-sm mb-3 mySelect2 " ID="ddlRouteType"></asp:DropDownList>


                                                        <span class="input-group-text text-c-red">*</span>

                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>




                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="txtNID" class="col-sm-3 col-form-label">TA Amount:</label>

                                                <div class="col-sm-5">
                                                    <div class="input-group">
                                                        <asp:TextBox class="form-control form-control-sm mb-3 " runat="server" ID="txtTAAmount" placeholder="TA Amount"></asp:TextBox>
                                                        <asp:FilteredTextBoxExtender ID="FilteredsssTextBoxExtender3" runat="server"
                                                            Enabled="True" TargetControlID="txtTAAmount" FilterType="Custom" ValidChars="0123456789.">
                                                        </asp:FilteredTextBoxExtender>

                                                        <span class="input-group-text text-c-red">*</span>

                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="txtNID" class="col-sm-3 col-form-label">DA Amount:</label>

                                                <div class="col-sm-5">
                                                    <div class="input-group">
                                                        <asp:TextBox class="form-control form-control-sm mb-3 " runat="server" ID="txtDAAmount" placeholder="DA Amount"></asp:TextBox>
                                                        <asp:FilteredTextBoxExtender ID="FilsadasdteredTextBoxExtender4" runat="server"
                                                            Enabled="True" TargetControlID="txtDAAmount" FilterType="Custom" ValidChars="0123456789.">
                                                        </asp:FilteredTextBoxExtender>

                                                        <span class="input-group-text text-c-red">*</span>

                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>


                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="txtNID" class="col-sm-3 col-form-label">Route Day:</label>

                                                <div class="col-sm-5">
                                                    <div class="input-group">

                                                        <asp:ListBox runat="server" ID="ddlRouteDay" SelectionMode="Multiple" class="form-select form-select-sm mb-3 multiple-select" name="doctorSpecialitySelect"></asp:ListBox>

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
                                                    <asp:HiddenField runat="server" ID="id_mastetID" />



                                                    <asp:LinkButton runat="server" OnClientClick="return sweetAlertConfirm_Submit(this);" Visible="false" OnClick="btnSave_Click" ID="btnSave" class="btn btnMyDesignSearch   btn-sm">
                                            <i class="fa fa-check"></i>Submit
                                                    </asp:LinkButton>

                                                    <asp:LinkButton runat="server" OnClick="btnSave_Click" OnClientClick="return sweetAlertConfirm_Update(this);" Visible="false" ID="btnUpdate" class="btn btnMyDesignSearch   btn-sm">
                                            <i class="fa fa-check"></i>Update
                                                    </asp:LinkButton>

                                                    <asp:LinkButton ID="btnReset" runat="server" OnClick="btnReset_Click" class="btn btnMyDesignReset   btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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

