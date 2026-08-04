<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="CreatePickingDetailForWareHouse.aspx.cs" Inherits="SInventory_UI_CreatePickingDetailForWareHouse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">





      <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Challan Generation </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        
 <asp:LinkButton ID="LinkButton1"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="LinkButton1_Click" runat="server"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>

                    
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
                                      

                        <div class="row">

                            <div class="col-md-4">
                                  
                          
                             
                                 <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">  Req No :</label>

                                    <div class="col-sm-5">
                                    
                                          

                                    <asp:TextBox ID="reqNoTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="True"></asp:TextBox>


                                                                 
                                    </div>

                                 
                                </div>  

                          
                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Packing No :</label>

                                    <div class="col-sm-5">
                                    
                                          
                                    <asp:TextBox ID="clnNoTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="True"></asp:TextBox>

                                                           
                                    </div>

                                 
                                </div>  
                            

                          </div>      


                            <div class="col-md-4">

                               <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label"> Req Date :</label>

                                    <div class="col-sm-5">
                                     

                                       <asp:TextBox ID="reqDateTextBox" runat="server" CssClass="form-control form-control-sm"  ReadOnly="True"></asp:TextBox>

                                            
                                    </div>
                                 
                                </div>   
                 
                      
                              <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">  Packing Date :</label>

                                    <div class="col-sm-5">
                                     

                                     <asp:TextBox ID="clnDateTextBox" runat="server" CssClass="form-control form-control-sm"  ReadOnly="True"></asp:TextBox>
                           
                           
                                    
                                    </div>
                                 
                                </div>   
                                                 
                             </div>  


                           <div class="col-md-4">

                               <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label"> Truck No:</label>

                                    <div class="col-sm-5">
                                     

                                       <asp:TextBox ID="truckNoTextBox" runat="server" CssClass="form-control form-control-sm"  ReadOnly="True"></asp:TextBox>

                                            
                                    </div>
                                 
                                </div>   
                 
                      
                              <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">  Driver No :</label>

                                    <div class="col-sm-5">
                                     

                                     <asp:TextBox ID="driverNameTextBox" runat="server" CssClass="form-control form-control-sm"  ReadOnly="True"></asp:TextBox>
                           
                           
                                    
                                    </div>
                                 
                                </div>   
                                                 
                             </div>  


                        </div>  

                <br />
                        
                        <div class="row">
           <div class="table-responsive" id="MainGradeDiv">                      
                        
          

                             <asp:GridView ID="issueGridView" runat="server" CssClass="table table-bordered  text-center thead-dark" OnPreRender="gv_DocumentUpload_PreRender"
                                AutoGenerateColumns="False" DataKeyNames="ReqChildId">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                    <asp:BoundField DataField="CurrentStockQty" HeaderText="Curr. Stock" />
                                    <asp:BoundField DataField="ProductUnitPrice" HeaderText="Unit Price" />
                                    <asp:BoundField DataField="ReqQty" HeaderText="Req Qty" />
                                    <asp:TemplateField HeaderText="Pick Qty">
                                        <ItemTemplate>

                                                <asp:HiddenField runat="server" ID="hfBatchNO" Value='<%#Eval("BatchNO")%>' />

                                            <asp:TextBox ID="issueQtyTextBox" runat="server" ReadOnly="True"
                                                AutoPostBack="True" CssClass="form-control form-control-sm" Text= <%# Eval("ReqQty")%> 
                                                ontextchanged="issueQtyTextBox_TextChanged"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Price">
                                        <ItemTemplate>
                                            <asp:TextBox ID="priceTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="True"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="VAT">
                                        <ItemTemplate>
                                            <asp:TextBox ID="vatTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="True"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total Value">
                                        <ItemTemplate>
                                            <asp:TextBox ID="totalPriceTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="True"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Case">
                                        <ItemTemplate>
                                            <asp:TextBox ID="caseTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="True"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Pick">
                                           <HeaderTemplate>
                                               <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True"  OnCheckedChanged="chkSelectAll_CheckedChanged"/>
                                            </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="issueCheckBox" runat="server" AutoPostBack="True" 
                                                oncheckedchanged="issueCheckBox_CheckedChanged" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>



           
          </div>
       </div>

   <br />

                      <div class="row">

                            <div class="col-md-4">


                                  <div class="form-group row">
                              


<%--                                       <asp:LinkButton ID="LinkButton1"  class="btn btn-sm btn-info" OnClick="LinkButton1_Click"  runat="server"> <i data-feather="corner-up-right" style="width: 16px !important; height: 16px !important;"></i> Back to List </asp:LinkButton>--%>
                                                                 
                                    </div>

                                 
                                </div>                                               

                            <div class="col-md-4">

               
 
                                    
                           <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label"> Total Amount </label>

                                    <div class="col-sm-5">
                                     

                                    <asp:TextBox ID="totalAllPriceTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="true" ></asp:TextBox>
                      
                           
                                                        
                                    </div>
                                 
                                </div>   


                           <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label"> Total VAT </label>

                                    <div class="col-sm-5">
                                     

                             <asp:TextBox ID="vatAllPriceTextBox" runat="server" CssClass="form-control form-control-sm "  ReadOnly="true"></asp:TextBox>
                          
                           
                           
                                    
                                    </div>
                                 
                                </div>   
                 
                      
                           <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">  Grand Total Amount :</label>

                                    <div class="col-sm-5">
                                     

                                        <asp:TextBox ID="grandTotalTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="true" ></asp:TextBox>

                                                                   
                                    </div>
                                 
                                </div>   
                                                 
                                </div>  
                
                      </div>  


                        <br />

                        <div class="row">
                            <div class="col-3">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">

                                 <asp:LinkButton ID="bmitButton" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="bmitButton_Click" OnClientClick="return confirm('Are you sure you want Save ?');" style="background-color: #00bcd4;color: #fff;"><i class="fa fa-check-square" aria-hidden="true"></i>&nbsp;  Submit Information</asp:LinkButton>
                                      
                             <%--    <asp:LinkButton ID="btn"  class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" runat="server" OnClick="cancelButton_Click"
                                 ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset Information </asp:LinkButton>--%>


                

                                  

                                             
                
                          
                                         
                                    </div>
                                </div>

                            </div>
                       
                        </div>                 
                        <br/>
                    
                        <asp:HiddenField ID="hfIsFromBatch" runat="server" />
                        <asp:HiddenField ID="hdReqId" runat="server" />
                     
                                </div>  
                                </div>  
                                </div>  


            
       
    </div>  

    </div>  
         
    </div>                    

      </ContentTemplate>
    </asp:UpdatePanel>



 <%--   <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
             <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                           Challan Generation 
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
                            Req No </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="reqNoTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            Req Date</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="reqDateTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            Truck No</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="truckNoTextBox" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            Picking No </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="clnNoTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            Picking Date</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="clnDateTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            Driver No</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="driverNameTextBox" runat="server"></asp:TextBox>
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
                        <td class="TDLeft" width="13%" colspan="6">
                           
                            <asp:GridView ID="issueGridView" runat="server" CssClass="gridview" 
                                AutoGenerateColumns="False" DataKeyNames="ReqChildId">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                    <asp:BoundField DataField="CurrentStockQty" HeaderText="Curr. Stock" />
                                    <asp:BoundField DataField="ProductUnitPrice" HeaderText="Unit Price" />
                                    <asp:BoundField DataField="ReqQty" HeaderText="Req Qty" />
                                    <asp:TemplateField HeaderText="Pick Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="issueQtyTextBox" runat="server" ReadOnly="True"
                                                AutoPostBack="True" CssClass="TextBoxCalander" Text= <%# Eval("ReqQty")%> 
                                                ontextchanged="issueQtyTextBox_TextChanged"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Price">
                                        <ItemTemplate>
                                            <asp:TextBox ID="priceTextBox" runat="server" CssClass="TextBoxCalander" ReadOnly="True"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="VAT">
                                        <ItemTemplate>
                                            <asp:TextBox ID="vatTextBox" runat="server" CssClass="TextBoxCalander" ReadOnly="True"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total Value">
                                        <ItemTemplate>
                                            <asp:TextBox ID="totalPriceTextBox" runat="server" CssClass="TextBoxCalander" ReadOnly="True"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Case">
                                        <ItemTemplate>
                                            <asp:TextBox ID="caseTextBox" runat="server" CssClass="TextBoxMini" ReadOnly="True"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Pick">
                                           <HeaderTemplate>
                                               <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True"  OnCheckedChanged="chkSelectAll_CheckedChanged"/>
                                            </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="issueCheckBox" runat="server" AutoPostBack="True" 
                                                oncheckedchanged="issueCheckBox_CheckedChanged" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
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
                            <asp:LinkButton ID="LinkButton1" runat="server" Font-Bold="True" 
                                onclick="LinkButton1_Click">&lt;&lt;&lt;&lt;&lt;Back To List </asp:LinkButton>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            Total Amount :</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="totalAllPriceTextBox" runat="server" ReadOnly="True"></asp:TextBox>
                        </td>
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
                            Total VAT :</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="vatAllPriceTextBox" runat="server" ReadOnly="True"></asp:TextBox>
                        </td>
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
                            Grand Total Amount :</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="grandTotalTextBox" runat="server" ReadOnly="True"></asp:TextBox>
                        </td>
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
                            <asp:Button ID="bmitButton" runat="server" onclick="bmitButton_Click" 
                                Text="Submit"  OnClientClick="return confirm('Are you sure you want Save ?');" />
                        </td>
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
             </table>
                 </div>

        </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>

