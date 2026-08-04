<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="OrderDeleteorEdit.aspx.cs" Inherits="SInventory_UI_OrderDeleteorEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
         <div class="page-wrapper">
			<div class="page-content">
				<!--breadcrumb-->
                
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Inactive  Order Information</div>
                
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
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	Order No:</label>

                                                <div class="col-sm-5">

                                                    <asp:TextBox Visible="false" ID="custcodenameTextBox" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                                   
                                                      <asp:DropDownList ID="ddlOrder" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" 
                                AutoPostBack="True" 
                             >
                            </asp:DropDownList>
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

                                                      <asp:LinkButton   OnClientClick="return sweetAlertConfirm_Delete(this);"  OnClick="Button1_Click"   runat="server" id="searchButton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-inverse"></i> Inactive Order
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                  


                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>


                                                 <br />

                                    <div class="row">
                                        <div class="table-responsive" id="MainGradeDiv">

 

                                              <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                 DataKeyNames="OrderId" 
                                onrowcommand="loadGridView_RowCommand"  CssClass="table table-bordered  text-center thead-dark"  OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="SC Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="SC Name" />
                                    <asp:BoundField DataField="OrderCode" HeaderText="Order No" />
                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                    <asp:BoundField DataField="GrossValue" HeaderText="Gross Value" />
                                 <%--   <asp:TemplateField HeaderText="Edit">
                                        <ItemTemplate>
                                           

                                                 <asp:LinkButton ID="edistIasdasdmageButton" runat="server" CommandArgument="<%# Container.DataItemIndex %>" class="btn-warning  btn-sm mb-1 mb-md-0" 
                                                    CommandName="EditData"   
                                                      >   <i class="bx bxs-edit"></i></asp:LinkButton>

                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                   <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>
                                                   
                                                <asp:LinkButton ID="edistImageButton" runat="server" CommandArgument="<%# Container.DataItemIndex %>" class="btn-danger  btn-sm mb-1 mb-md-0" 
                                                    CommandName="DelData" OnClientClick="return sweetAlertConfirm_Delete(this);" 
                                                      >   <i class="fa fa-trash"></i></asp:LinkButton>
                                          
                                         
                                              <%--  OnClick="ImageButton2_Click"--%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                                        </div>
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

