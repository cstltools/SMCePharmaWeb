<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DoctorCustomerTransferApproval.aspx.cs" Inherits="Approval_UI_DoctorCustomerTransferApproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

      <style>
          .radioChoice label {
            padding-left: 5px;
            padding-right: 30px;
                  font-size: 20px;
                  font-weight: bold;
        }

     
    </style>
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Doctor/Customer Approval</div>
                
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
                                  
              			
				
				 
                                  <div class="col-md-12" style="text-align:center">
                  <asp:RadioButtonList runat="server" ID="rbType" CssClass="radioChoice" AutoPostBack="True" OnSelectedIndexChanged="rbType_SelectedIndexChanged" RepeatDirection="Horizontal" RepeatLayout="Flow">
                      <asp:ListItem Selected="True" Value="0">Customer Transfer</asp:ListItem>
                      <asp:ListItem Value="1">Doctor Transfer</asp:ListItem>
                  </asp:RadioButtonList>
                                      </div>
                                          </div>
                          <div class="row">
                              <div class="col-md-4"></div>
                              <div class="col-md-4">
                                  
					<div class="col">
					<div class="card radius-10  bg-gradient">
							<div class="card-body">
								<div class="text-center">
									<div>
										  <div class="form-group" >
                                                <asp:Button ID="submitButton" runat="server" CssClass="btn btnMyDesignSearch   btn-sm" OnClick="btnSubmit0_Click" Text="Submit" />
                                              

                                              <div style="display:none"> <label style="font-weight: bold">Approval Status:&nbsp;<span style="color: #a52a2a">*</span></label>&nbsp;&nbsp;
                                                <asp:RadioButtonList ID="statusRadioButtonList"  RepeatColumns="2" RepeatLayout="Flow"  CssClass="radioChoice2" runat="server">
                                <asp:ListItem Value="1" Selected="True" Text="Approve"></asp:ListItem>
                                <asp:ListItem Value="0" Text="Reject"></asp:ListItem>
                            </asp:RadioButtonList></div>
                                             <br />
                                             <br />
                          
                                            
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



                                             <br />
                              <div class="row">
                           
                                       <div class="col-12">

                                            <div class="table-responsive" id="MainGradeDiv">

                                                            <asp:GridView ID="gv_Customer_List" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="MasterID" 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                                  <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfCustomerMasterId" Value='<%#Eval("CustomerMasterId")%>' />
                                           
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                           <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" CssClass="form-control-sm"  AutoPostBack="true" OnCheckedChanged="chkSelect_CheckedChanged"  runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                    
                                    <asp:BoundField DataField="CustomerType" HeaderText="Customer Type" />
                                    <%--<asp:BoundField DataField="DistributionRouteName" HeaderText="Distribution RouteName" />--%>
                              
 
                                    
                                </Columns>
                            </asp:GridView>

                                                 
                                  
                                                    <asp:GridView ID="gv_Doctor_List" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="DoctorId"  
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>

                                            <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfDoctorId" Value='<%#Eval("DoctorId")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                           <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkDoctorSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="chkDoctorSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkDoctorSelect" CssClass="form-control-sm"   runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                    <asp:BoundField DataField="DoctorCode" HeaderText="Doctor Code" />
                                    <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />
                                    
                                    <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                                    <asp:BoundField DataField="DegreeName" HeaderText="Degree" />
                                    <asp:BoundField DataField="DoctorSpeciality" HeaderText="Doctor Speciality" />
                                
                                     
                                </Columns>
                            </asp:GridView>

                                </div>

                                     </div>
                                     </div>



                                       <br />
                        

                        <div class="table-responsive" id="MaicnGradeDiv">
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

