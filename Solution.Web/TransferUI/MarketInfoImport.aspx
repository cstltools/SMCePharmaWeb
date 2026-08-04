<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="MarketInfoImport.aspx.cs" Inherits="TransferUI_MarketInfoImport" %>

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
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Market Creation </div>

                <div class="ms-auto">
                    <div class="btn-group">
                         <asp:LinkButton ID="viewLinkButton"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="viewLinkButton_Click" runat="server"> <i class="fa fa-backward"></i>&nbsp;Go to Approval List</asp:LinkButton>
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

                            <div class="row" runat="server" visible="false">
                                <div class="col-md-2"></div>
                                <div class="col-md-8">
                                    <div class="form-group row">

                                        <label for="mainName" class="col-sm-3 col-form-label">Upload File :</label>

                                        <div class="col-sm-8">


                                         <%--   <asp:Button ID="Button1" runat="server" class="btn btn-primary" Text="Save" OnClick="Button1_OnClick" />--%>
                                            <asp:Button ID="Button2" runat="server" class="btn btn-primary" Text="Transfer" OnClick="Button2_OnClick" />


                                        </div>


                                    </div>
                                </div>
                            </div>


                            <div class="row">
                                <div class="col-md-2"><a href="../Approval_UI/MarketTranferFormat.xls"  class="btn  btn-secondary   btn-sm">Download Excel Format</a></div>
                                <div class="col-md-10">
                                    <div class="form-group row">

                                        <label for="mainName" class="col-sm-2 col-form-label">Upload File :</label>

                                        <div class="col-sm-7">

                                            <asp:FileUpload ID="id_fu" runat="server" ToolTip="Select File To Upload." class="form-control form-control-sm" />

                                            <asp:HiddenField ID="IsFileUploaded" runat="server" />
                                            <br />
                                            <asp:Label ID="lbl_up_status" runat="server" CssClass=""></asp:Label>
                                        </div>

                                        <div class="col-sm-3">
                                            <asp:Button ID="btnUpload" runat="server" class="btn btnMyDesignAddtoList   btn-sm" Text="Upload" OnClick="btnUpload_OnClick" />

                                            <asp:HiddenField ID="mainid" runat="server" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                                      <br />
                                      <div class="row">

                                   
                                  <div class="col-md-12" style="text-align:center">
                  <asp:RadioButtonList runat="server" ID="rbType" CssClass="radioChoice"   RepeatDirection="Horizontal" RepeatLayout="Flow">
                      <asp:ListItem  Selected="True"  Value="MarketInsert">Market Insert</asp:ListItem>

                      <asp:ListItem Value="MarketUpdate">Market Update</asp:ListItem>
                      <asp:ListItem Value="TerritoryUpdate">Territory Update</asp:ListItem>
                     
                  </asp:RadioButtonList>
                                   </div>
                                   </div>
                            <br />
                          <%--  <br />
  <div class="row">
      <span class="alert alert-info">Note for market update: Use 'N/A' for market update in Excel Territory Code column. The Excel Market Code column cannot be empty.</span>
      </div>--%>





                            <div class="row">
                                <div class="table-responsive" id="MainGradeDiv">

                                    <asp:GridView ID="dataGridView" runat="server" AutoGenerateColumns="False"
                                        CssClass="table table-bordered  text-center thead-dark">

                                        <Columns>
                                            <asp:TemplateField HeaderText="#SL">
                                                <ItemTemplate>
                                                    <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Territory Code">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblterritorycode" runat="server" CssClass="form-control form-control-sm"
                                                        Text='<%# Eval("territorycode")%>'></asp:Label>



                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Market Code">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblmarketcode" runat="server" CssClass="form-control form-control-sm"
                                                        Text='<%# Eval("marketcode")%>'></asp:Label>



                                                </ItemTemplate>
                                            </asp:TemplateField>


                                            <asp:TemplateField HeaderText="Market Name">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblMarketName" runat="server" CssClass="form-control form-control-sm"
                                                        Text='<%# Eval("MarketName")%>'></asp:Label>



                                                </ItemTemplate>
                                            </asp:TemplateField>


                                            <asp:TemplateField HeaderText="Division">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblDivision" runat="server" CssClass="form-control form-control-sm"
                                                        Text='<%# Eval("Division")%>'></asp:Label>



                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="District">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblDistrict" runat="server" CssClass="form-control form-control-sm"
                                                        Text='<%# Eval("District")%>'></asp:Label>



                                                </ItemTemplate>
                                            </asp:TemplateField>



                                            <asp:TemplateField HeaderText="Thana">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblThana" runat="server" CssClass="form-control form-control-sm"
                                                        Text='<%# Eval("Thana")%>'></asp:Label>



                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Regional Head Station Type">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblRegionalHeadStationType" runat="server" CssClass="form-control form-control-sm"
                                                        Text='<%# Eval("RegionalHeadStationType")%>'></asp:Label>



                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="DZSM Station Type">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblDZSMStationType" runat="server" CssClass="form-control form-control-sm"
                                                        Text='<%# Eval("DZSMStationType")%>'></asp:Label>



                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="AM Station Type">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblAMStationType" runat="server" CssClass="form-control form-control-sm"
                                                        Text='<%# Eval("AMStationType")%>'></asp:Label>



                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="MIO Station Type">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblMIOStationType" runat="server" CssClass="form-control form-control-sm"
                                                        Text='<%# Eval("MIOStationType")%>'></asp:Label>



                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Sales Assistant Station Type">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblSalesAssistantStationType" runat="server" CssClass="form-control form-control-sm"
                                                        Text='<%# Eval("SalesAssistantStationType")%>'></asp:Label>



                                                </ItemTemplate>
                                            </asp:TemplateField>

                                        </Columns>

                                    </asp:GridView>

                                </div>
                            </div>

                            <br />
                            <br />
                            <div class="row">
                                <div class="col-md-2">&nbsp;</div>
                                <div class="col-md-8">

                                    <div class="form-group row">
                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                        <div class="col-sm-8">
                                            <asp:LinkButton OnClick="submitButton_Click" OnClientClick="return sweetAlertConfirm_Submit(this);" runat="server" ID="submitButton" class="btn btnMyDesignSearch   btn-sm">
                                            <i class="fa fa-check"></i>Submit
                                            </asp:LinkButton>

                                            <asp:LinkButton runat="server" ID="LinkButton5" OnClick="cancelButton_Click" class="btn btnMyDesignReset   btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>



                                        </div>
                                    </div>

                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>




                                      </ContentTemplate>
                                <Triggers>

                                    <asp:PostBackTrigger ControlID="btnUpload" />
                                </Triggers>
                            </asp:UpdatePanel>



                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

   
</asp:Content>

