<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TerritoryWiseTargetSetup.aspx.cs" Inherits="DWSP_TerritoryWiseTargetSetup" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
        <style>

    .form-switch {
        padding-left: 2.5em;
    }

    .form-check {
        display: block;
        min-height: 1.5rem;
        padding-left: 1.5em;
        margin-bottom: .125rem;
    }

      .chkChoice label {
            padding-left: 2px;
            padding-right: 2px;
        }
</style>


        <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Territory Wise Target Setup  </div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DWSP/TerritoryTargetSetupView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>

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
                                         
                                                 <script type="text/javascript">
                                                     function pageLoad() {
                                                         $('.datepicker').pickadate({
                                                             selectMonths: true,
                                                             selectYears: true
                                                         });
                                                         $('.mySelect2').select2({
                                                             theme: 'bootstrap4',
                                                             width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                             placeholder: $(this).data('placeholder'),
                                                             allowClear: Boolean($(this).data('allow-clear')),
                                                         });
                                                     }

                                                     var dateNow = new Date();
                                                     $('.datepickess').datepicker("setDate", dateNow);
                                                     minDate: new Date() // to disable privious dates 
                                                 </script>
                        <div class="row">&nbsp;</div>

                   

                                <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-8">
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Year:  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:DropDownList  runat="server"   AutoPostBack="true" OnSelectedIndexChanged="ddlmonth_SelectedIndexChanged" id="ddlYear" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                <span id="v-year" class="invalid-tooltip fade hide" data-delay="2000">
                                                </span>
                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div> 
    
                                 
                                    </div>
                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>
                                    
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Month:  </label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">
                                                        <asp:DropDownList  runat="server"  AutoPostBack="true" OnSelectedIndexChanged="ddlmonth_SelectedIndexChanged"   id="ddlmonth" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                        </select>

                                                        <span id="v-month" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>
                                                        <span class="input-group-text text-c-red">*</span>

                                                    </div>

                                                </div> 
    
                                 
                                            </div>
                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>

                            <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-8">
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Group:  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                               <asp:DropDownList  runat="server" AutoPostBack="true" OnSelectedIndexChanged="groupname_SelectedIndexChanged1" id="groupname"  CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                <span id="v-groupname" class="invalid-tooltip fade hide" data-delay="2000">
                                                </span>
                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div> 
    
                                 
                                    </div>
                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>

                                <div class="row">
                                    <div class="col-2">&nbsp;</div>
                                    <div class="col-8">
                                        <div class="form-group row">
                                            <label for="mainName" class="col-sm-3 col-form-label">Zone:  </label>
                                            <asp:HiddenField ID="hfAreaId" runat="server" /> 
                                            <asp:HiddenField ID="hfZoneId" runat="server" /> 
                                            <div class="col-sm-7">
                                                <div class="input-group">
                                                    <asp:DropDownList  runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlZone_OnSelectedIndexChanged" id="ddlZone" CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                    <span id="v-ddlZone" class="invalid-tooltip fade hide" data-delay="2000">
                                                    </span>
                                                    <span class="input-group-text text-c-red">*</span>

                                                </div>

                                            </div> 
    
                                 
                                        </div>
                                    </div>
                                    <div class="col-2">&nbsp;</div>
                                </div>

                                          <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-8">
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Area:  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                               <asp:DropDownList  runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlArea_SelectedIndexChanged" id="ddlArea"  CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                <span id="v-ddlArea" class="invalid-tooltip fade hide" data-delay="2000">
                                                </span>
                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div> 
    
                                 
                                    </div>
                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>

                            <div class="row" >
                                <div class="col-2">&nbsp;</div>
                                <div class="col-8">
                                    <div class="form-group row">
                                   
                                        
                                        <label for="mainName" class="col-sm-3 col-form-label">Target:  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox   runat="server" id="amount" ReadOnly="true" CssClass=" form-control form-control-sm mb-3 clsDecimal" ></asp:TextBox>
                                                
                                                <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server"
                                                                             TargetControlID="amount"
                                                                             FilterType="Custom, Numbers"
                                                                             ValidChars="." />

                                                <span id="v-amount" class="invalid-tooltip fade hide" data-delay="2000">
                                                </span>
                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div> 
    
                                 
                                    </div>
                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>




                                <div class="row">
                                
                                <div class="col-12">
                                    <div class="table-responsive" id="MainGradeDiv">

                                        <asp:GridView ID="gv_List" runat="server" AutoGenerateColumns="False" ShowFooter="True"
                                
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                                  <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="HFTerritoryId" Value='<%#Eval("TerritoryId")%>' />

                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:BoundField DataField="TerritoryName" HeaderText="Territory" />
                                    <asp:TemplateField HeaderText="Amount">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtAmount" runat="server" Text='<%#Eval("Amount") %>' AutoPostBack="True" OnTextChanged="txtAmount_OnTextChanged" CssClass="form-control form-control-sm mb-3 clsDecimal"></asp:TextBox>
                                                        
                                                        <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server"
                                                                                     TargetControlID="txtAmount"
                                                                                     FilterType="Custom, Numbers"
                                                                                     ValidChars="." />
                                                        

                                                    
                                                           
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                </Columns>
                            </asp:GridView>

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
                                    <div class="col-sm-9">
                                         <asp:LinkButton  OnClick="btnSave_Click" Visible="false" OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                        <asp:LinkButton  OnClick="btnSave_Click"  Visible="false"   runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm" OnClientClick="return sweetAlertConfirm_Update(this);"   >
                                            <i class="fa fa-check"></i>Update
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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

