<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="ConditionalPurposeSetting.aspx.cs" Inherits="SInventory_UI_ConditionalPurposeSetting" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>


             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Conditional Purpose Settings </div>

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


                    <div class="card-body">
                        
                                         <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Purpose:</label>

                                                <div class="col-sm-5">


                                                   <asp:TextBox ID="purposeTextBox" runat="server" CssClass="form-control form-control-sm" TextMode="MultiLine"></asp:TextBox>

                                              

                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>


                                         


                                            <br />
                                           

                                                  
                                            
                                            <div class="form-group row" >
                                                <label for="mainName" class="col-sm-3 col-form-label">Condition:</label>

                                                <div class="col-sm-5">

                                                     <asp:DropDownList ID="conditionDropDownList" runat="server" 
                                AutoPostBack="True" CssClass="form-control form-control-sm mySelect2">
                            </asp:DropDownList>
                                                   


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
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
                                                              <asp:LinkButton  OnClick="submitButton_Click1" OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>
                                                               
                                        <asp:LinkButton  runat="server" ID="btnReset"   OnClick="btnReset_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="col-2">&nbsp;</div>
                                            </div>
                        </div>
                        </div>
                        </div>
                        </div>
                        </div>
                        </div>
                        </div>

              
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
