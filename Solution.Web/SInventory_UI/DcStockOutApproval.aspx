<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DcStockOutApproval.aspx.cs" Inherits="SInventory_UI_DcStockOutApproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .align-middle
        {
            margin-left: 37px;
        }
        
        .pd-left {
            padding-left: 5px;
        }
        
        .radioButtonList
        {
            list-style: none;
            margin: 0;
            padding: 0;    
        }
        .radioButtonList.horizontal li
        {
            display: inline;
        }
        
        .radioButtonList label
        {
            display: inline;
        }
         .radioChoice2 label {
            padding-left: 3px;
            padding-right: 5px;
            font-size: 16px;
            font-weight: bold;
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Depot Stock Adjustments Voucher Approval</div>
                
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
                              <div class="col-md-4"></div>
                              <div class="col-md-4">
                                  
					<div class="col">
					<div class="card radius-10  bg-gradient">
							<div class="card-body">
								<div class="text-center">
									<div>
										  <div class="form-group" >

                                               <label style="font-weight: bold">Approval Status:&nbsp;<span style="color: #a52a2a">*</span></label>&nbsp;&nbsp;
                                                <asp:RadioButtonList ID="statusRadioButtonList"  RepeatColumns="2" RepeatLayout="Flow"  CssClass="radioChoice2" runat="server">
                                <asp:ListItem Value="1" Text="Approve"></asp:ListItem>
                                <asp:ListItem Value="0" Text="Reject"></asp:ListItem>
                            </asp:RadioButtonList>
                                             <br />
                                             <br />
                            <asp:Button ID="submitButton" runat="server" CssClass="btn btnMyDesignSearch   btn-sm" OnClick="btnSubmit0_Click" Text="Submit" />
                                            
                                              <%-- <input type="button" name="next" class="btn btnMyDesignSearch   btn-sm" onclick="SaveApproval()" value="Submit Information" />--%>

                                           </div>
									</div>
									
									</div>
								</div>
							</div>
						</div>
					</div>
                               
                              </div>
                         
                          

                              


                            <div style="padding-top:10px;"></div>

                        <div class="table-responsive" id="MainGradeDiv">
                             <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                DataKeyNames="DcStockOutMasterId"   CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender"
                                onrowcommand="loadGridView_RowCommand">
                                <Columns>

                                      <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                      <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center" />
                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" />
                                    <asp:BoundField DataField="Reason" HeaderText="Reason" />
                                    <asp:BoundField DataField="StockOutDate" HeaderText="StockOut Date " DataFormatString="{0:dd-MMM-yyyy}" />
                   
                                    <asp:BoundField DataField="Status" HeaderText="Status" />
                                    <asp:TemplateField HeaderText="Report">
                                        <ItemTemplate>

                                             <asp:LinkButton ID="LinkButton1" runat="server" class="btn-success  btn-sm mb-1 mb-md-0"
                                                                    CommandArgument="<%# Container.DataItemIndex %>" CommandName="View"><i class='bx bxs-printer' aria-hidden='true'></i></asp:LinkButton>
                                            
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                  
                                 
                                </Columns>
                            </asp:GridView>

                      
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

