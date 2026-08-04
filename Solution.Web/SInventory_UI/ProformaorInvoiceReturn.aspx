<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ProformaorInvoiceReturn.aspx.cs" Inherits="SInventory_UI_ProformaorInvoiceReturn" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style>
        .SelectchkChoice label {
            padding-left: 4px;
            font-weight: bold;
        }
    </style>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Invoice/Delivery Return</div>

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

                    <div class="card-body">

                        <br/>

                            <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                 <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">   </label>

                                    <div class="col-sm-5">

                                       
                           
                                         <asp:CheckBox ID="ProformaCheckBox" runat="server" AutoPostBack="True"  Text="Invoice"   oncheckedchanged="ProformaCheckBox_CheckedChanged" CssClass="SelectchkChoice"  />

                                  

                                    </div>
                             
                                </div>  
           
                                </div>  
                                </div>  

                            <div class="row">
                            <div class="col-2">&nbsp;</div>

                            <div class="col-8">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">    </label>

                                    <div class="col-sm-5">

                                            
                           

                                         <asp:CheckBox ID="InvoiceCheckBox" runat="server" Visible="false" AutoPostBack="True"  CssClass="SelectchkChoice"  Text="Delivery" oncheckedchanged="InvoiceCheckBox_CheckedChanged"  />

                                        
                                     

                                    </div>
              
                                </div>  


                  

                                </div>  
                                </div>  

                            <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">



                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  No :</label>

                                    <div class="col-sm-5">
                                                               <asp:TextBox ID="proformaInvoiceTextBox" runat="server"  CssClass="form-control form-control-sm"
                                ontextchanged="proformaInvoiceTextBox_TextChanged" AutoPostBack="True"></asp:TextBox>


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

 <asp:LinkButton ID="submitButton" class="btn btn-danger   btn-sm" runat="server" OnClick="saveButton_Click"   OnClientClick="return sweetAlertConfirm_Submit(this);"    
                           >   <i class="fa fa-trash"></i>&nbsp; Delete</asp:LinkButton>
                              <asp:LinkButton ID="LinkButton4"  class="btn btnMyDesignReset   btn-sm"  runat="server" OnClick="cancelButton_Click"
                                ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>

                        <br/>


                                </div>  
                                </div>  
                                </div>  
                                </div>  
               
                                </div>  
                                </div>  

                 </div>  
    </ContentTemplate>
    </asp:UpdatePanel>


<%--     <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Proforma/Invoice Return
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
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" width="13%">
                            Proforma 
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:CheckBox ID="ProformaCheckBox" runat="server" AutoPostBack="True" 
                                oncheckedchanged="ProformaCheckBox_CheckedChanged"  />
                            
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                     <tr>
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" width="13%">
                            Invoice 
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:CheckBox ID="InvoiceCheckBox" runat="server" AutoPostBack="True" 
                                oncheckedchanged="InvoiceCheckBox_CheckedChanged"   />
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                    <tr runat="server"  id="DIVProforma">
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" width="13%">
                            No :
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="proformaInvoiceTextBox" runat="server" 
                                ontextchanged="proformaInvoiceTextBox_TextChanged" AutoPostBack="True"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                    <tr runat="server" visible="True" id="DIVINV">
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" width="13%">
                            
                        </td>
                        <td class="TDRight" width="20%">
                          
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Button ID="saveButton" runat="server" Text="Delete" 
                                onclick="saveButton_Click" OnClientClick="return confirm('Are you sure you want to Delete ?');"/>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                           
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft" >
                            &nbsp;
                        </td>
                         <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>--%>
    
    
    

</asp:Content>

