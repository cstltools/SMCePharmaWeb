<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="SubDepotStockOutApproval.aspx.cs" Inherits="SInventory_UI_DcStockOutApproval" %>

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
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    
                    <div class="container-fluid" style="width: 100% !important;">

    <div class="page-body m-t-20">
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
             <%-- <asp:UpdateProgress>
            <ProgressTemplate>
                                    <div class="divWaiting">
                                        <asp:Image ID="imgWait" runat="server" ImageAlign="Middle" ImageUrl="~/Images/loading-icon-big.gif"
                                            Height="100%" Width="100%" />
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>--%>
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="card main-card  pb-4">
                    <div class="card-header main-card-head">
                        <h5 class=""> <i style="color: #64B1E8!important" data-feather="grid"></i>  Direct Stock Out Approval </h5>
                      

                            <asp:Label ID="MessageLabel" runat="server" ForeColor="#009900"></asp:Label>

<%-- <asp:LinkButton ID="viewLinkButton"    class="btn btn-sm btn-info" 
                                runat="server"> <i data-feather="corner-up-right" style="width: 16px !important; height: 16px !important;"></i> View Details</asp:LinkButton>--%>
                    </div>
                

                    <div class="card-body">
                    


                  
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">



                                 <div class="form-group row">

                                     <div class="col-sm-5"></div>
                                    <div class="col-sm-5">
                                           <span style="font-size: 15px; font-weight: bold; text-align: left; padding-right: 5px; line-height: 35px;">Take Action:</span>
                                        <br />
                            <asp:RadioButtonList ID="statusRadioButtonList" CssClass="radioButtonList" runat="server">
                                <asp:ListItem Value="1" Text="Approve"></asp:ListItem>
                                <asp:ListItem Value="0" Text="Reject"></asp:ListItem>
                            </asp:RadioButtonList>


                                    </div>
                      
                                </div>  


                  

                                </div>  
                                </div>  




                           <br />
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                             <div class="col-md-4"> </div>
                                    <div class="col-sm-8">

 <asp:LinkButton ID="LinkButton1" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="btnSubmit0_Click" style="background-color: #00bcd4;color: #fff;"
                           >   <i class="fas fa-check-square"></i>&nbsp; Submit </asp:LinkButton>
                            <asp:LinkButton ID="cancelButton"  class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" runat="server" OnClick="cancelButton_Click"
                                ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset Information </asp:LinkButton>
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>

     

             <br />

                        <div class="row">
      <div class="table-responsive" id="MainGradeDiv">
       
                    <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender" DataKeyNames="SubDcStockOutMasterId" 
                                onrowcommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="ComUnitName" HeaderText="ComUnit Name" />
                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" />
                                    <asp:BoundField DataField="Reason" HeaderText="Reason" />
                                    <asp:BoundField DataField="StockOutDate" HeaderText="StockOut Date " DataFormatString="{0:dd-MMM-yyyy}" />
                   
                                    <asp:BoundField DataField="Status" HeaderText="Status" />
                                    <asp:TemplateField HeaderText="View">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="reportImageButton" runat="server" 
                                                             CommandArgument="<%# Container.DataItemIndex %>" CommandName="View" ImageUrl="~/images/report-disk-icon.png"
                                            />
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
                                 
                                </Columns>
                            </asp:GridView>

          </div>
          </div>


                                </div>  
                                </div>  
                                </div>  
                                </div>  
                </ContentTemplate>
    </asp:UpdatePanel>
                                </div>  
                                </div>  



<%--     <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Direct Stock Out Approval
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
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            
                        </td>
                        <td width="20%" class="TDRight">
                            <span style="font-size: 15px; font-weight: bold; text-align: left; padding-left: 5px; line-height: 35px;">Take Action:</span>
                            <asp:RadioButtonList ID="statusRadioButtonList" CssClass="radioButtonList" runat="server">
                                <asp:ListItem Value="1" Text="Approve"></asp:ListItem>
                                <asp:ListItem Value="0" Text="Reject"></asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" style="padding-left: 7px; padding-top: 7px;" width="20%">
                            <asp:Button ID="submitButton" runat="server" OnClick="btnSubmit0_Click" Text="Submit" />
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" colspan="6">
                              <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="SubDcStockOutMasterId" 
                                onrowcommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="ComUnitName" HeaderText="ComUnit Name" />
                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" />
                                    <asp:BoundField DataField="Reason" HeaderText="Reason" />
                                    <asp:BoundField DataField="StockOutDate" HeaderText="StockOut Date " DataFormatString="{0:dd-MMM-yyyy}" />
                   
                                    <asp:BoundField DataField="Status" HeaderText="Status" />
                                    <asp:TemplateField HeaderText="View">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="reportImageButton" runat="server" 
                                                             CommandArgument="<%# Container.DataItemIndex %>" CommandName="View" ImageUrl="~/images/report-disk-icon.png"
                                            />
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
                                 
                                </Columns>
                            </asp:GridView>

                      
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                <tr>
                    <td class="TDLeft" width="13%">
                        &nbsp;
                    </td>
                    <td class="TDRight" width="20%">
                        &nbsp;
                    </td>
                    <td class="TDLeft" width="13%">
                       
                    </td>
                    <td class="TDRight" width="20%">
                        &nbsp;
                    </td>
                    <td class="TDLeft" width="13%">
                        &nbsp;
                    </td>
                    <td class="TDRight" width="20%">
                        &nbsp;
                    </td>
                </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" style="padding-left: 250px;" class="TDRight">
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
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>

