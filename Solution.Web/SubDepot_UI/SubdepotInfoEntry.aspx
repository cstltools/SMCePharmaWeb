<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SubdepotInfoEntry.aspx.cs" Inherits="SubDepot_UI_SubdepotInfoEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    
    <div class="page-wrapper">
			<div class="page-content">
				<!--breadcrumb-->
                
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Sub-Depot Information Entry</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                           <a href="SubdepotView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>
                      
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


                                         <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> Distribution Center:</label>

                                                <div class="col-sm-5">

                                                                         
                                                    <asp:DropDownList ID="companyNameDropDownList" runat="server" 
                                CssClass="form-select form-select-sm mb-3 mySelect2 " AutoPostBack="True" 
                                onselectedindexchanged="companyNameDropDownList_SelectedIndexChanged1">
                            </asp:DropDownList>

                                                  


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>

                                               <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">  	Sub-Depot Code:</label>

                                                <div class="col-sm-5">

                                                    <asp:TextBox ID="comUnitCodeTextBox" runat="server" CssClass="form-control form-control-sm mb-3 " ReadOnly="True"></asp:TextBox>


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>


                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">  	Sub-Depot Name:</label>

                                                <div class="col-sm-5">
                                                     <asp:TextBox ID="salesCenternameTextBox" runat="server" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                                                  


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>



                                               <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">  	Address:</label>

                                                <div class="col-sm-5">
                            <asp:TextBox ID="addressTextBox" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control form-control-sm mb-3"></asp:TextBox>

                                                 

                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>


                                               <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">  	Phone No:</label>

                                                <div class="col-sm-5">
                                                     <asp:TextBox ID="phoneNoTextBox" runat="server" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                                              


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>


                                               <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">  	Mobile No:</label>

                                                <div class="col-sm-5">
                                                     <asp:TextBox ID="mobileNoTextBox" runat="server" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                                                

                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>


                                               <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">  	Fax No:</label>

                                                <div class="col-sm-5">
                                                     <asp:TextBox ID="faxNoTextBox" runat="server" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                                                   


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
                                                
                                                      <asp:LinkButton  OnClick="submitButton_Click1"   runat="server" id="LinksubmitButtonButton1" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-check"></i> Submit
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                  

                                                     <asp:DropDownList ID="regionDropDownList" Visible="false" runat="server" CssClass="DropDown">
                            </asp:DropDownList>
                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>
                            <asp:HiddenField ID="subdepotIdHiddenField" runat="server" />


                    </ContentTemplate>
                                      </asp:UpdatePanel>
                            </div>
                             </div>
                        </div>
                    </div>
                </div>
                </div>


     
</asp:Content>

