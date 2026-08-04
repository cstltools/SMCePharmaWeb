<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="MarketStructure_TransferApprove.aspx.cs" Inherits="TransferUI_MarketStructure_TransferApprove" %>
<%@ Register Src="~/MasterSetup_UI/IVMarketStructureFrom_To.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
<%@ Register Src="~/MasterSetup_UI/IVMarketStructureTo.ascx" TagPrefix="uc1" TagName="IVMarketStructureTo" %> 

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Transfer Approval List</div>

                <div class="ms-auto">
                    <div class="btn-group">


                         


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
                                         <div class="col-sm-3">
                                            <div class="form-group">
                                                <label class="col-form-label">Effective Date</label>
                                                <asp:TextBox runat="server" ID="txtProbationEndDate" type="text" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select  Effective date"></asp:TextBox>

                                                <span id="v-txtProbationEndDate" class="invalid-tooltip fade hide" data-delay="1000"></span>
                                            </div>
                                        </div>
                                    </div>
                             <div class="row">
                                  
              			
				
				 
                                  <div class="col-md-12" style="text-align:center">
                  <asp:RadioButtonList runat="server" ID="rbType" CssClass="radioChoice" AutoPostBack="True" OnSelectedIndexChanged="rbType_SelectedIndexChanged" RepeatDirection="Horizontal" RepeatLayout="Flow">
                      <asp:ListItem Selected="True" Value="Market">Market Transfer</asp:ListItem>
                      <asp:ListItem Value="Sub-Territory">Sub-Territory Transfer</asp:ListItem>
                      <asp:ListItem Value="Territory">Territory Transfer</asp:ListItem>
                      <asp:ListItem Value="Area">Area Transfer</asp:ListItem>
                      <asp:ListItem Value="Zone">Zone Transfer</asp:ListItem>
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
                              <div class="row" runat="server" visible="false">

                                  <div class="col-md-6">
                                      <fieldset class="for-panel">
                                                            <legend>From</legend>
<uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
                                           <div class="form-group row">
                                    <label for="GroupSelect" class="col-sm-3 col-form-label">   </label>

                                    <div class="col-sm-8">
                                           <div class="input-group">
                                            
                                               <asp:LinkButton runat="server" id="btnSearch" class="btn btnMyDesignAddtoList   btn-sm pull-left"  onclick="btnSearch_Click">
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

                                                            <asp:GridView ID="gv_Zone" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="MarketStructureTranferId" 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                                  <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfMarketStructureTranferId" Value='<%#Eval("MarketStructureTranferId")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                           <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="gv_ZonechkSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="gv_ZonechkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" CssClass="form-control-sm"   runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                       <%--<asp:BoundField DataField="FAreaName" HeaderText="From Area" />--%>
                                    <asp:BoundField DataField="TRegionName" HeaderText="Zone" />

                                   
                                    
                                </Columns>
                            </asp:GridView>

                                                 
                                   <asp:GridView ID="gv_Area" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="MarketStructureTranferId" 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                                  <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfMarketStructureTranferId" Value='<%#Eval("MarketStructureTranferId")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                           <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="gv_AreachkSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="gv_AreachkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" CssClass="form-control-sm"   runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                       <%--<asp:BoundField DataField="FAreaName" HeaderText="From Area" />--%>
                                  
                                    <%--<asp:BoundField DataField="FAreaName" HeaderText="From Area" />--%>
                                    <asp:BoundField DataField="TAreaName" HeaderText=" Area" />
                                    
                                    <%--<asp:BoundField DataField="TTerritoryName" HeaderText="Territory" />--%>


                                    
                                    
                                </Columns>
                            </asp:GridView>

                                   <asp:GridView ID="gv_Terrritory" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="MarketStructureTranferId" 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                                  <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfMarketStructureTranferId" Value='<%#Eval("MarketStructureTranferId")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                           <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="gv_TerrritorychkSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="gv_TerrritorychkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" CssClass="form-control-sm"   runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
 
                                     <%--<asp:BoundField DataField="FTerritoryName" HeaderText="Territory" />--%>
                                    <asp:BoundField DataField="TTerritoryName" HeaderText="Territory" />
                                    
                                    <%--<asp:BoundField DataField="TSubTerritoryName" HeaderText="Sub-Territory" />--%>


                                
                                    
                                </Columns>
                            </asp:GridView>


                                                 <asp:GridView ID="gv_subTerri" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="MarketStructureTranferId" 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                                  <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfMarketStructureTranferId" Value='<%#Eval("MarketStructureTranferId")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                           <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="gv_subTerrichkSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="gv_subTerrichkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" CssClass="form-control-sm"   runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
 
                                     <%--<asp:BoundField DataField="FSubTerritoryName" HeaderText="From Sub-Territory" />--%>
                                    <asp:BoundField DataField="TSubTerritoryName" HeaderText=" Sub-Territory" />
                                 
 
                                    
                                </Columns>
                            </asp:GridView>

 <asp:GridView ID="gv_market" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="MarketStructureTranferId" 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                                  <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfMarketStructureTranferId" Value='<%#Eval("MarketStructureTranferId")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                           <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="gv_marketchkSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="gv_marketchkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" CssClass="form-control-sm"   runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                

                                    
                                
                                    <asp:BoundField DataField="MarketName" HeaderText="Market" />
                                  
 
                                    
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
                                


                                        
                                                         <asp:LinkButton  OnClick="btnSave_Click"  runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm" OnClientClick="return sweetAlertConfirm_Submit(this);"    >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  id="btnReset"  OnClick="btnReset_Click" class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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

