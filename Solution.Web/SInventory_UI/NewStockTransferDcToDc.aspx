<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="NewStockTransferDcToDc.aspx.cs" Inherits="SInventory_UI_NewStockTransferDcToDc" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    


     <asp:UpdatePanel ID="UpdatePanel3" runat="server">
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Stock Transfer DC to DC </div>

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
                                    <label for="mainName" class="col-sm-2 col-form-label"> <span style="color: #00BCD4;font-weight: bold;font-size: 16px;"><u>From</u></span></label>

                                    <div class="col-sm-3">
                                    
                             


                                    </div>
                                      
                                        <label for="mainName" class="col-sm-2 col-form-label"> <span style="color: #00BCD4;font-weight: bold;font-size: 16px;"><u>To</u></span> </label>

                                    <div class="col-sm-3">
                                       
                             
                                       


                                    </div>
                                      
                                    
                                   
                                </div>  

                         <div class="form-group row">
                                    <label for="mainName" class="col-sm-2 col-form-label">  	Chalan Date:</label>

                                    <div class="col-sm-3">
                                    
                             <asp:TextBox ID="chalanDateTextBox" runat="server" CssClass="form-control form-control-sm " 
                                ReadOnly="True"></asp:TextBox>     


                                    </div>
                                      
                                        <label for="mainName" class="col-sm-2 col-form-label"> Chalan No:</label>

                                    <div class="col-sm-3">
                                     <asp:TextBox ID="chalanNoTextBox" runat="server" CssClass="form-control form-control-sm " ReadOnly="True"></asp:TextBox>
                             
                                       


                                    </div>
                                      
                                    
                                   
                                </div>  
                        
                           <div class="form-group row">
                                    <label for="mainName" class="col-sm-2 col-form-label">  	 	Sales Center Code:</label>

                                    <div class="col-sm-3">
                                    
                             <asp:TextBox ID="fromComUnitCodeTextBox" runat="server" AutoPostBack="True" 
                                 CssClass="form-control form-control-sm "  ontextchanged="fromComUnitCodeTextBox_TextChanged" ></asp:TextBox>


                                    </div>
                                      
                                        <label for="mainName" class="col-sm-2 col-form-label"> Sales Center Code:</label>

                                    <div class="col-sm-3">
                                        <asp:TextBox ID="toComUnitCodeTextBox" runat="server"    CssClass="form-control form-control-sm "   
                                ontextchanged="toComUnitCodeTextBox_TextChanged" AutoPostBack="True"></asp:TextBox>
                                       


                                    </div>
                                      
                                    
                                   
                                </div>  
                        
                          <div class="form-group row">
                                    <label for="mainName" class="col-sm-2 col-form-label">  	 	Name:</label>

                                    <div class="col-sm-3">
                                    
                              <asp:TextBox ID="fromComUnitNameTextBox" runat="server"   CssClass="form-control form-control-sm " 
                                ReadOnly="True"></asp:TextBox>


                                    </div>
                                      
                                        <label for="mainName" class="col-sm-2 col-form-label"> Name:</label>

                                    <div class="col-sm-3">
                                        <asp:TextBox ID="toComUnitNameTextBox" runat="server"    CssClass="form-control form-control-sm " ></asp:TextBox>


                                    </div>
                                      
                                    
                                   
                                </div>  
                        
                        
                        
                            <div class="form-group row">
                                    <label for="mainName" class="col-sm-2 col-form-label">  	 	Address:</label>

                                    <div class="col-sm-3">
                                    
                             <asp:TextBox ID="fromComUnitAddressTextBox" runat="server"   CssClass="form-control" 
                                ReadOnly="True" TextMode="MultiLine" Rows="3"></asp:TextBox>


                                    </div>
                                      
                                        <label for="mainName" class="col-sm-2 col-form-label"> Address:</label>

                                    <div class="col-sm-3">
                                        <asp:TextBox ID="toComUnitAddressTextBox" runat="server"  CssClass="form-control"  
                                 TextMode="MultiLine" Rows="3"></asp:TextBox>

                                    </div>
                                      
                                    
                                   
                                </div>  
                        <div class="form-group row" style="padding: 20px;">
                              &nbsp;
                            </div>
                          <div class="form-group row">
                                    <label for="mainName" class="col-sm-2 col-form-label">  	 	 Truck Number:</label>

                                    <div class="col-sm-3">
                                    
                             <asp:TextBox ID="truckNoTextBox" runat="server"   CssClass="form-control form-control-sm " 
                                ></asp:TextBox>


                                    </div>
                                      
                                        <label for="mainName" class="col-sm-2 col-form-label"> Driver Name:</label>

                                    <div class="col-sm-3">
                                        <asp:TextBox ID="driverNameTextBox" runat="server"   CssClass="form-control form-control-sm " ></asp:TextBox>

                                    </div>
                                      
                                    
                                   
                                </div>  
                        
                         <div class="form-group row">
                                    <label for="mainName" class="col-sm-2 col-form-label">  	 	  &nbsp;</label>

                                    <div class="col-sm-3">
                                    
                             &nbsp;


                                    </div>
                                      
                                        <label for="mainName" class="col-sm-2 col-form-label"> Manufacturer:</label>

                                    <div class="col-sm-3">
                                        <asp:DropDownList ID="manufacDropDownList" runat="server"  CssClass="form-control form-control-sm " >
                            </asp:DropDownList>

                                    </div>
                                      
                                    
                                   
                                </div>  
                        
                        
                        <div style="padding: 6px;"></div>
                         <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  	 	   Product Code:</label>

                                    <div class="col-sm-5">
                                    
                           <asp:TextBox ID="prodctCodeTextBox" runat="server" CssClass="form-control form-control-sm " 
                                ></asp:TextBox>


                                    </div>
                                      
                                        

                                    <div class="col-sm-3">
                                        <asp:LinkButton ID="Button1" runat="server"  onclick="Button1_Click" CssClass="btn btn-sm btn-outline-success" > <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>

                                    </div>
                                      
                                    
                                   
                                </div>  
                             <div style="padding: 6px;"></div>
                         <div class="row">
      <div class="table-responsive" id="MainGradeDiv">
           <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False" 
                                 DataKeyNames="DCStoreId,VATAmountPerUnit,UnitPrice"    CssClass="table table-bordered  text-center thead-dark" OnPreRender="gv_DocumentUpload_PreRender" >
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" 
                                                oncheckedchanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="PCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="PName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="StockQty" HeaderText="Stock Qty" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />
                                        <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ReceiveDate" />
                                    <asp:TemplateField HeaderText="Transfer Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="transferQtyTextBox" runat="server"  CssClass="form-control form-control-sm " 
                                                ontextchanged="dQtyTextBox_TextChanged" AutoPostBack="True"></asp:TextBox>
                                                 <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderconvRate" runat="server"
                                                    Enabled="True" TargetControlID="transferQtyTextBox" FilterType="Custom" ValidChars="0123456789">
                                                </asp:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
          

                          </div>
                      </div>
                        
                        
                             <div style="padding: 6px;"></div>
                        
                        
                         <div class="form-group row">
                                    <label for="mainName" class="col-sm-2 col-form-label">      &nbsp;</label>

                                    <div class="col-sm-3">
                                    
                             
                                             &nbsp;

                                    </div>
                                      
                                        <label for="mainName" class="col-sm-2 col-form-label">      &nbsp; </label>

                                    <div class="col-sm-3">
                                       
                                  <asp:LinkButton ID="addButton" runat="server"  CssClass="btn btn-sm btn-info"
                                onclick="addButton_Click" ><i class="fa fa-plus"></i>&nbsp; Add to List</asp:LinkButton>
                                       


                                    </div>
                                      
                                    
                                   
                                </div>  
                        
                            <div style="padding: 6px;"></div>
                        
                         <div class="row">
      <div class="table-responsive" id="MainGraddfeDiv">
           <asp:GridView ID="chalanGridView" runat="server" AutoGenerateColumns="False" 
                                 CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender"  DataKeyNames="DCStoreId,VATAmountPerUnit,UnitPrice">
                                <Columns>
                                    
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="TransferQty" HeaderText="Transfer Qty" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />
                                        <asp:TemplateField HeaderText="Remove Item">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="DeleteImageButton" runat="server" 
                                                ImageUrl="~/images/lineDelete.png" onclick="DeleteImageButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                </Columns>
                            </asp:GridView>

           </div>
                      </div>
                        
                        
                           <div style="padding: 6px;"></div>
                        
                          
                         <div class="form-group row">
                                    <label for="mainName" class="col-sm-2 col-form-label">      &nbsp;</label>

                                    <div class="col-sm-3">
                                    
                             
                                             &nbsp;

                                    </div>
                                      
                                        <label for="mainName" class="col-sm-2 col-form-label">      Taka </label>

                                    <div class="col-sm-3">
                                       
                                 <asp:Label ID="grandTotalWordLabel" runat="server"   CssClass="form-control form-control-sm "></asp:Label>
                                       


                                    </div>
                                      
                                    
                                   
                                </div>  
                        
                           <div style="padding: 6px;"></div>
                           
                        
                              <br />
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">


                                         <asp:LinkButton  OnClick="submitButton_Click1" OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                              
                                        <asp:LinkButton   ID="cancelButton"  runat="server"  OnClick="cancelButton_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>

 
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                         <div style="padding: 6px;"></div>
                           <div class="form-group row">
                                    
                                      
                                        <label for="mainName" class="col-sm-3 col-form-label">       	Chalan No: </label>

                                    <div class="col-sm-5">
                                       
                               <asp:TextBox ID="printChalanNoTextBox" runat="server" AutoPostBack="True" 
                                  CssClass="form-control form-control-sm " ontextchanged="fromComUnitCodeTextBox_TextChanged"></asp:TextBox>
                                       


                                    </div>
                                       <div class="col-sm-2">
                                             <asp:LinkButton ID="Button2" runat="server"   CssClass="btn btn-sm btn-primary" 
                                onclick="Button2_Click" ><i class="fa fa-print"></i>&nbsp;Print</asp:LinkButton>
                                           </div>
                                    
                                   
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
                            Stock Transfer DC to DC
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp; </td>
                        <td width="20%" class="TDRight">
                         
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:Label ID="MessageLabel" runat="server" ForeColor="#009900"></asp:Label>
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                         <asp:HyperLink ID="HyperLink1" runat="server" ForeColor="green"
                                NavigateUrl="~/SInventory_UI/B2BTransferView.aspx">View List</asp:HyperLink>
                    </tr>
                    
                    
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>

                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            From</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            To</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                            Chalan Date</td>
                        <td class="TDLeft" width="13%">
                           
                        </td>
                        <td class="TDRight" width="20%">
                            ChalanNo</td>
                        <td class="TDLeft" width="13%">
                           
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                           From Sales Center Code</td>
                        <td width="13%" class="TDLeft">
                           
                        </td>
                        <td width="20%" class="TDRight">
                            To Sales Center Code</td>
                        <td width="13%" class="TDLeft">
                        
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                             Name</td>
                        <td width="13%" class="TDLeft">
                          
                        </td>
                        <td width="20%" class="TDRight">
                             Name</td>
                        <td width="13%" class="TDLeft">
                          
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            Address</td>
                        <td class="TDLeft" width="13%">
                           
                        </td>
                        <td class="TDRight" width="20%">
                            Address</td>
                        <td class="TDLeft" width="13%">
                            
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            Truck Number</td>
                        <td class="TDLeft" width="13%">
                           
                        </td>
                        <td class="TDRight" width="20%">
                            Driver Name</td>
                        <td class="TDLeft" width="13%">
                           
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
                            Manufacturer</td>
                        <td class="TDLeft" width="13%">
                           
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
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            <asp:HiddenField ID="fromCunithiddenValue" runat="server" />     &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            Product Code</td>
                        <td class="TDLeft" width="13%">
                           
                        </td>
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
                        <td class="TDLeft" colspan="6">
                           
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
                            &nbsp; </td>
                        <td class="TDRight" width="20%" colspan="2">
                            Taka :&nbsp;&nbsp;
                          
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft" >
                            &nbsp;</td>
                            <td width="20%" class="TDRight">
                                &nbsp;</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                          
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Chalan No</td>
                        <td class="TDRight" width="20%">
                            
                        </td>                            

                        <td class="TDLeft" width="13%">
                          
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

