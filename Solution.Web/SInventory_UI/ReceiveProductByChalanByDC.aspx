<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ReceiveProductByChalanByDC.aspx.cs" Inherits="SInventory_UI_ReceiveProductByChalanByDC" %>
<%@ Register TagPrefix="ajaxToolkit" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    



     <asp:UpdatePanel ID="UpdatePanel4" runat="server">
        <ContentTemplate>
                 <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Stock Receive </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        
 <asp:LinkButton ID="viewLinkButton"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="backLinkButton_Click" runat="server"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>

                    
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">


  






                    <div class="card-body">
                        <br/>
                        
                 
                                
                                  <div class="form-group row">
                                    <label for="mainName" class="col-sm-2 col-form-label"> Chalan No:</label>

                                    <div class="col-sm-2">
                                    
                              <asp:TextBox ID="clnNoTextBox" CssClass="form-control form-control-sm " runat="server" ReadOnly="True"></asp:TextBox>
                                       


                                    </div>
                                      
                                        <label for="mainName" class="col-sm-2 col-form-label"> Chalan Date:</label>

                                    <div class="col-sm-2">
                                       <asp:TextBox ID="clnDateTextBox" runat="server"   CssClass="form-control form-control-sm "  ReadOnly="True"></asp:TextBox>
                             
                                       


                                    </div>
                                      
                                      
                                        <label for="mainName" class="col-sm-2 col-form-label">  	Receive Date:</label>

                                    <div class="col-sm-2">
                                        <asp:TextBox ID="rcvDateTextBox" runat="server"  CssClass="form-control form-control-sm "   ReadOnly="True"></asp:TextBox>
                             
                                       


                                    </div>
                                   
                                </div>  
                                
                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-2 col-form-label">  Truck No:</label>

                                    <div class="col-sm-2">
                                    
                              <asp:TextBox ID="truckTextBox" runat="server"  CssClass="form-control form-control-sm "   ReadOnly="True"></asp:TextBox>        


                                    </div>
                                      
                                        <label for="mainName" class="col-sm-2 col-form-label">Driver Name:</label>

                                    <div class="col-sm-2">
                                     <asp:TextBox ID="driverNameTextBox" runat="server"  CssClass="form-control form-control-sm "  ReadOnly="True"></asp:TextBox>
                                       


                                    </div>
                                      
                                      
                                      
                                   
                                </div>     
                        
                        <br />
                        <div class="row">
      <div class="table-responsive" id="MainGradeDiv">
          
            <asp:GridView ID="rcvGridView" runat="server" AutoGenerateColumns="False" 
                               CssClass="table table-bordered  text-center thead-dark" OnPreRender="gv_DocumentUpload_PreRender" DataKeyNames="ReqId,ReqChildId,StockInTransfarId">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="ProductCode" />
                                    <asp:BoundField DataField="ProductName" HeaderText="ProductName" />
                                    <asp:BoundField DataField="PackSize" HeaderText="PackSize" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="BatchNo" />
                                    <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />
                                    <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ReceiveDate" />
                                    <asp:TemplateField HeaderText="RcvQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="rcvQtyTextBox" runat="server"   CssClass="form-control form-control-sm "  Text= <%# Eval("Quantity")%> 
                                               ReadOnly="True" AutoPostBack="True" ontextchanged="rcvQtyTextBox_TextChanged"></asp:TextBox>
                                                <ajaxToolkit:FilteredTextBoxExtender ID="currentStockTextBox" runat="server"
                                                    TargetControlID="rcvQtyTextBox"         
                                                    FilterType="Custom, Numbers"
                                                    ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="UnRcvQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="damageTextBox" runat="server"   CssClass="form-control form-control-sm "  AutoPostBack="True" 
                                                ontextchanged="damageTextBox_TextChanged">0</asp:TextBox>
                                                 <ajaxToolkit:FilteredTextBoxExtender ID="fcurrentStockTextBox" runat="server"
                                                    TargetControlID="damageTextBox"         
                                                    FilterType="Custom, Numbers"
                                                    ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                      <asp:BoundField DataField="MfgDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="Mfgdate"/>
                                </Columns>
                            </asp:GridView>
            </div>
                    </div>
                        
                        
                             <br />
                        <div class="row">
                            <div class="col-4">&nbsp;</div>
                            <div class="col-6">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">
 
                       
                                         <asp:LinkButton   OnClientClick="return sweetAlertConfirm_Submit(this);"  OnClick="submitButton_Click"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>
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
       <asp:UpdatePanel ID="UpdatePanel1" runat="server" Visible="False">
        <ContentTemplate>
             <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Stock Receive
                        </td>
                         <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
            <tr>
                        <td class="TDLeft" width="13%">
                            Chalan No:</td>
                        <td class="TDRight" width="20%">
                           
                        </td>
                        <td class="TDLeft" width="13%">
                            Chalan Date :</td>
                        <td class="TDRight" width="20%">
                            
                        </td>
                        <td class="TDLeft" width="13%">
                            Receive Date :</td>
                        <td class="TDRight" width="20%">
                          
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            Truck No</td>
                        <td class="TDRight" width="20%">
                           
                        </td>
                        <td class="TDLeft" width="13%">
                            Driver Name :</td>
                        <td class="TDRight" width="20%">
                           
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                     <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%" colspan="6">
                          
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            <asp:LinkButton ID="backLinkButton" runat="server" Font-Bold="True" 
                                onclick="backLinkButton_Click">&lt;&lt;&lt;&lt;&lt;Back To List</asp:LinkButton>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                           <%-- <asp:Button ID="submitButton" runat="server" onclick="submitButton_Click" 
                                Text="Submit" />--%>
                                
                                
                                
                                
                                
                                
                                 <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                <ContentTemplate>
                            <asp:Button ID="saveButton" runat="server" Text="Submit"  OnClientClick="return confirm('Are you sure you want to Save ?');"
                                onclick="submitButton_Click" />
                                </ContentTemplate>
                        </asp:UpdatePanel>
                            <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="UpdatePanel3"
                                DisplayAfter="0" DynamicLayout="true">
                                <ProgressTemplate>
                                    <center>
                                        <asp:Image ID="Img2" runat="server" ImageUrl="~/Images/ajax-loader.gif" />
                                    </center>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                                
                                
                                
                                
                                
                                
                         
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            <asp:HiddenField ID="hdComUnitId" runat="server" />
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            <asp:HiddenField ID="hdReqId" runat="server" />
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>

             </table>
                 </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

