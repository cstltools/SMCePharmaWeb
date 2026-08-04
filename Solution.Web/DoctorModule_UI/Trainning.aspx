<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"  ValidateRequest="false" AutoEventWireup="true" CodeFile="Trainning.aspx.cs" Inherits="DoctorModule_UI_Trainning" %>
<%--<%@ Register Assembly="FreeTextBox" Namespace="FreeTextBoxControls" TagPrefix="FTB" %>--%>
<%@ Register Src="~/MasterSetup_UI/IVMarketStructure.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   
    
    
        <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Trainning Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="TrainningView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">

                             <asp:UpdatePanel ID="UpdatePanel2" runat="server"  ClientIDMode="Static">
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
                            <div class="col-1">&nbsp;</div>
                            <div class="col-9">
                                <div class="form-group row">
                                    <label  class="col-sm-2 col-form-label">Title:  </label>

                                    <div class="col-sm-10">
                                          <div class="input-group">
                                           
                                            <asp:TextBox  runat="server"  ID="txtTitle" CssClass="form-control form-control-sm mb-3"></asp:TextBox>     

                                       
                                              
 <span class="input-group-text text-c-red">*</span>
                                    </div>

                                    </div>
                                    
                                </div>



                                <div class="form-group row">
                                    <label for="Description" class="col-sm-2 col-form-label">Description:  </label>

                                    <div class="col-sm-10">
                                          <div class="input-group">

                                     <asp:TextBox  runat="server"  TextMode="MultiLine"  id="txtDescription" class="form-control form-control-sm mb-3"   rows="2" ></asp:TextBox>

                                        <span id="v-Description" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


 <span class="input-group-text text-c-red">*</span>
                                    </div>
                                    </div>
                                   
                                </div>

                               
                                <div class="form-group row">
                                    <label for="TrainningMeterial" class="col-sm-2 col-form-label">Trainning Meterial:  </label>

                                      <div class="col-sm-10">
                                          <div class="input-group">
                                               <%--<FTB:FreeTextBox ID="txtMailBody"  Height="250" runat="server"></FTB:FreeTextBox>--%>
                                              <asp:TextBox ClientIDMode="Static" TextMode="MultiLine" name="TrainningMeterial"  class="form-control form-control-sm mb-3" runat="server" ID="TrainningMeterial" rows="5" ></asp:TextBox>
                                      
                                        <span id="v-TrainningMeterial" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                              
 <span class="input-group-text text-c-red">*</span>
                                    </div>

                                    </div>
                                     
                                </div>

                                   <script type="text/javascript">
                                      <%-- window.onload = function () {
                                           CKEDITOR.replace('<%=TrainningMeterial.ClientID %>');
                                       }--%>
                                     
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

                                           //CKEDITOR.replace('<%=TrainningMeterial.ClientID %>');
                                           //CKEDITOR.replace('ContentPlaceHolder1_TrainningMeterial');
                                         <%--  var prm = Sys.WebForms.PageRequestManager.getInstance();
                                           if (prm != null) {
                                               prm.add_endRequest(function (sender, e) {
                                                   if (sender._postBackSettings.panelsToUpdate != null) {
                                                       CKEDITOR.remove(CKEDITOR.instances['<%=TrainningMeterial.ClientID %>']);
                                                       CKEDITOR.replace('<%=TrainningMeterial.ClientID %>');
                                                       OpenModal();
                                                   }
                                               });
                                           } else {
                                              
                                           }
                                           ;--%>
                                           $('.mySelect2').select2({
                                               theme: 'bootstrap4',
                                               width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                               placeholder: $(this).data('placeholder'),
                                               allowClear: Boolean($(this).data('allow-clear')),
                                           });
                                       }
                                   </script>
                                <br />
                                           <div class="form-group row"></div>
                                <div class="form-group row">
                                    <label for="FromDate" class="col-sm-2 col-form-label">From Date:  </label>

                                    <div class="col-sm-3">
                                         <div class="input-group">

                                        <asp:TextBox  runat="server"   id="FromDate"  class="form-control form-control-sm mb-3 datepicker"  autocomplete="off" placeholder="Select  From date" ></asp:TextBox>
                                        <span id="v-FromDate" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>

   <span class="input-group-text text-c-red">*</span>
                                                </div>

                                    </div>

                                    <label for="Todate" class="col-sm-3 col-form-label">To Date:  </label>

                                    <div class="col-sm-3">
                                         <div class="input-group">
                                         <asp:TextBox  runat="server"   id="Todate"    placeholder="Select  To date"   class="form-control form-control-sm mb-3 datepicker"  autocomplete="off"></asp:TextBox>
                                        <span id="v-Todate" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
   <span class="input-group-text text-c-red">*</span>
                                                </div>

                                    </div>

                                </div>



                                

                            </div>
                            </div>


                                     <br />
                                      <h4>Market Structure</h4>
                                    <hr />

                                    
<uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />

                                    
                                    <div class="form-group row" style="margin-top:6px;">

                                       <label for="MarketSelect" class="col-sm-2 col-form-label">   </label>

                                    <div class="col-sm-3">

                                    

                                    </div>      
                                    <label for="MarketSelect" class="col-sm-2 col-form-label">  </label>

                                    <div class="col-sm-3">

                                          <asp:LinkButton ID="btnAddtoListMarket" runat="server"  OnClick="btnAddtoListMarket_Click" CssClass="btn btn-sm btn-success pull-right" ><i class="fa fa-plus-circle"></i>Add To List</asp:LinkButton>

                                    </div>                                    </div>



                              <br />

                 <div class="row">
                            <div class="col-2">&nbsp;</div>
                                       <div class="col-8">

                                            <div class="table-responsive" id="MainGradeDiv2">

                                                  <asp:GridView ID="gv_Market" runat="server" AutoGenerateColumns="False"
                                                                    CssClass="table table-bordered  text-center thead-dark"  >
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
                                    
                                     <br />
                                      <h4>User Role</h4>
                                    <hr />


                                      <div class="row">
                            <div class="col-1">&nbsp;</div>
                            <div class="col-9">
                                 <div class="form-group row">
                                    <label  class="col-sm-2 col-form-label">User Role:  </label>

                                    <div class="col-sm-10">
                                 <asp:ListBox ID="UserRoleSelect" runat="server" CssClass=" form-select form-select-sm mb-3 multiple-select" SelectionMode="Multiple"></asp:ListBox>
                                </div>
                                </div>
                                </div>
                                </div>
                           

                                            <br />
                                            <br />
                                            <div class="row">
                                                <div class="col-2">&nbsp;</div>
                                                <div class="col-8">

                                                    <div class="form-group row">
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                        <div class="col-sm-8">
                                                              <asp:LinkButton OnClientClick="return sweetAlertConfirm_Submit(this);"  OnClick="btnSave_Click" Visible="false"  runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                             <asp:LinkButton OnClientClick="return sweetAlertConfirm_Update(this);"   OnClick="btnSave_Click"  Visible="false"   runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Update
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  ID="btnReset" OnClick="btnReset_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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
     
<input id="masterId" value="0" style="display:none" />
    <script src="//cdn.ckeditor.com/4.14.1/standard/ckeditor.js"></script>
    
 





</asp:Content>

