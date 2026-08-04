<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="PaymentReverse.aspx.cs" Inherits="SInventory_UI_PaymentReverse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <div class="page-wrapper">
			<div class="page-content">
				<!--breadcrumb-->
                
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Payment Reverse</div>
                
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
                               <asp:UpdateProgress ID="UpdateProgress1" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
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
                                                <label for="mainName" class="col-sm-3 col-form-label">Order No:</label>

                                                <div class="col-sm-5">

                                                                                 <asp:TextBox ID="orderNoTextBox" runat="server" CssClass="form-control form-control-sm mb-3"></asp:TextBox>

                                                  

                                                        <script type="text/javascript">
                                                        function pageLoad() {
                                                            $('.mySelect2').select2({
                                                                theme: 'bootstrap4',
                                                                width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                                placeholder: $(this).data('placeholder'),
                                                                allowClear: Boolean($(this).data('allow-clear')),
                                                            });
                                                            $('.datepicker').pickadate({
                                                                selectMonths: true,
                                                                selectYears: true
                                                            })
                                                            
                                                        }
                                                        </script>


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
                                                    
                                                      <asp:LinkButton  OnClick="submitButton_Click1"   runat="server" id="submitbutton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-check"></i> Return Payment
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
