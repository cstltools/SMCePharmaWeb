<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TerritoryWiseDepotSetup.aspx.cs" Inherits="MasterSetup_UI_TerritoryWiseDepotSetup" %>
<%@ Register Src="~/MasterSetup_UI/IVMarketStructureArea.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style>
             .Label_Title {
            background-color: #C7C7C7;
            width: 100%;
            text-align: center;
            margin: 0px;
            padding: 3px;
            text-align: center;
            color: #000;
            margin-right: 5%;
            font-weight: bold;
            font-size: 13px;
        }
               .SelectchkChoice label {
            padding-left: 6px;
            font-weight: bold;
        }

                .chkChoice label {
            padding-left: 10px;
            padding-right: 30px;
        }

    </style>
     <div id="popDiv">

</div>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Territory Wise Route Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">

 
                        
                        <a href="../MasterSetup_UI/TerritoryWiseDepotView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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


                                      <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                             

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

                                 <div class="form-group row mt-1">
                                     <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
                                </div>
                                    <div class="form-group row mt-1">
                                    <label for="mainName" class="col-sm-3 col-form-label">   </label>
                                    <div class="col-sm-5">
                                        
                                        <asp:LinkButton runat="server" ID="bnSearch" class="btn btn-sm btn-success  pull-right" onclick="bnSearch_Click"><i class="fa fa-search-plus"></i> Search</asp:LinkButton>
                                     
                                    </div>
                                    
                                </div>
                                <br />
                                   <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Depot Name: </label>
                                    <div class="col-sm-5">
                                        <asp:DropDownList  runat="server"  ID="ddlDepotName" AutoPostBack="true" OnSelectedIndexChanged="ddlDepotName_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>
                                      

                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>

                                <div class="form-group row mt-1" runat="server">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Route Name: </label>
                                    <div class="col-sm-5">
                                        <asp:DropDownList  runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlRouteName_SelectedIndexChanged" ID="ddlRouteName" class="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>
                                       
                                     
                                    </div>
                                    
                                </div>
                                 <div class="form-group row mt-1">
                                     <div class="Label_Title">Territory List</div>
                                                              
                                                                <div class="form-group">
                                                                    <div style="overflow: scroll; height: 330px">
                                                                         <asp:CheckBox runat="server" ID="chkTerritoryAll" CssClass="SelectchkChoice" AutoPostBack="True" OnCheckedChanged="chkTerritoryAll_CheckedChanged" Visible="false" Text=" Select All / Unselect All" />
                                                                        <br />
                                                                        <asp:CheckBoxList ID="chkTerritoryList"  CssClass="chkChoice" RepeatColumns="1" RepeatDirection="Horizontal" runat="server"></asp:CheckBoxList>
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
                                                        <div class="col-sm-8">
                                                              <asp:LinkButton  OnClick="btnSave_Click" Visible="false" OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                             <asp:LinkButton  OnClick="btnSave_Click"  Visible="false"   runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm" OnClientClick="return sweetAlertConfirm_Update(this);"   >
                                            <i class="fa fa-check"></i>Update
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server" ID="btnRest"  OnClick="btnRest_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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

