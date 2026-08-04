<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ZoneWiseTargetSetupView.aspx.cs" Inherits="DWSP_ZoneWiseTargetSetupView" %>
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Zone Wise Target List  </div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DWSP/ZoneWiseTargetSetup.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>


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

<%--                                         <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>--%>

 <asp:HiddenField runat="server" ID="id_mastetID"/>
                                         
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
                                                <asp:DropDownList  runat="server"   id="ddlYear" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

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
                                                        <asp:DropDownList  runat="server"   id="ddlmonth" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

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
                                               <asp:DropDownList  runat="server" AutoPostBack="true" OnSelectedIndexChanged="groupname_SelectedIndexChanged"  id="groupname" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                <span id="v-groupname" class="invalid-tooltip fade hide" data-delay="2000">
                                                </span>
                                                <span class="input-group-text text-c-red">*</span>

                                            </div>

                                        </div> 
    
                                 
                                    </div>
                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>


                           

                            <div class="row" runat="server" ID="Target" Visible="False">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-8">
                                    <div class="form-group row">
                                       <%-- <label for="mainName" class="col-sm-3 col-form-label"><asp:CheckBox runat="server" ID="chkQty" CssClass="chkChoice" AutoPostBack="true" OnCheckedChanged="chkQty_CheckedChanged" Text=" Is Common QTY:" />  </label>--%>
                                        
                                        <label for="mainName" class="col-sm-3 col-form-label">Target:  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox   runat="server" id="amount" ReadOnly="True" class=" form-control form-control-sm mb-3 clsDecimal" ></asp:TextBox>

                                                <span id="v-amount" class="invalid-tooltip fade hide" data-delay="2000">
                                                </span>
                                                <span class="input-group-text text-c-red" >*</span>

                                            </div>

                                        </div> 
    
                                 
                                    </div>
                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>
                                    
                                    
                                    
                                    
                                <div style="padding-top:16px;"></div>
                                <div class="row">
                                    <div class="col-md-5">
                                    </div>
                                    <div class="col-md-4" style="align-content:center">
                                        <asp:LinkButton runat="server"  id="btnSearch" class="btn btnMyDesignSearch   btn-sm "  onclick="btnSearch_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                                  
                                
                                        <asp:LinkButton  runat="server" class="btn btnMyDesignReset   btn-sm"   id="resetBtn" onclick="resetBtn_Click" ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                    </div>
                                </div>
                                    
                                    <br/>


                                      <div class="row">
                                
                                <div class="col-12">
                                    <div class="table-responsive" id="MainGradeDiv">

                                        <asp:GridView ID="gv_List" runat="server" AutoGenerateColumns="False" ShowFooter="True"
                                                      onrowcommand="loadGridView_RowCommand" DataKeyNames="ZoneWTSetupId,IsActive"
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                                  <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="HFZoneId" Value='<%#Eval("RegionId")%>' />

                                        </ItemTemplate>
                                    </asp:TemplateField>


                                    <asp:BoundField DataField="RegionName" HeaderText="Zone" />
                                    <asp:TemplateField HeaderText="Amount">
                                                    <ItemTemplate>

                                                        <div class="form-group row">
                                                            <div class="col-md-10">
                                                                <asp:TextBox ID="txtAmount" ReadOnly="true" runat="server" Text='<%#Eval("Amount") %>' Height="65%" AutoPostBack="True" OnTextChanged="txtAmount_OnTextChanged" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                                                         <%--       <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server"
                                                                                             TargetControlID="txtAmount"
                                                                                             FilterType="Custom, Numbers"
                                                                                             ValidChars="." />--%>
                                                            </div>
                                                            
                                                            <div class="col-md-2">
                                                                <asp:LinkButton ID="btnEdit" runat="server" Visible="false" Height="65%" class="btn-warning  btn-sm mb-1 mb-md-0"
                                                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="UpdateData"><i class='bx bxs-edit' aria-hidden='true'></i> Update</asp:LinkButton>
                                                            </div>

                                                        </div>

                                                    </ItemTemplate>
                                        

                                                </asp:TemplateField>
                                    
                                    
                                    
                                <%--    <asp:TemplateField HeaderText="Edit">
                                        <ItemTemplate>
                                           

                                        </ItemTemplate>
                                    </asp:TemplateField>--%>


                                </Columns>
                            </asp:GridView>

                                        

                                    </div>
                                    

                                </div>
                                
                            </div>
                        <br />
                            <br />
                                

                        

      </ContentTemplate>
                                     </asp:UpdatePanel>
                       

                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
 

</asp:Content>

