<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="OtherStockAction.aspx.cs" Inherits="SInventory_UI_OtherStockAction" %>

<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <script type="text/javascript">
        function DisableButton() {
            document.getElementById("<%=submitButton0.ClientID %>").disabled = true;
        }
        window.onbeforeunload = DisableButton;
    </script>
    <style>
        .divWaiting
        {
            position: absolute;
            z-index: 2147483647 !important;
            opacity: 0.5;
            overflow: hidden;
            text-align: center;
            top: 0;
            left: 0;
            height: 100%;
            width: 100%;
            padding-top: 0px;
        }
    </style>



     <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Freeze Stock Release </div>

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
                      
                        

                        <div class="row">&nbsp;</div>

                         <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
 
                               <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Distribution Center :</label>

                                    <div class="col-sm-5">
                                    
                                          
                                          <script type="text/javascript">
                                              function pageLoad() {
                                                  $('.datepicker').pickadate({
                                                      selectMonths: true,
                                                      selectYears: true
                                                  })
                                                  $('.mySelect2').select2({
                                                      theme: 'bootstrap4',
                                                      width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                      placeholder: $(this).data('placeholder'),
                                                      allowClear: Boolean($(this).data('allow-clear')),
                                                  });
                                              }
                                             </script>

                                 <asp:DropDownList ID="dcDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" OnSelectedIndexChanged="dcDropDownList_SelectedIndexChanged"
                                AutoPostBack="True">
                            </asp:DropDownList>
                                                                 
                                    </div>

                                 
                                </div>  

                               <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Manufacturer :</label>

                                    <div class="col-sm-5">
                                    
                                          

                                 <asp:DropDownList ID="manufacturerDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2"
                                AutoPostBack="True" OnSelectedIndexChanged="manufacturerDropDownList_SelectedIndexChanged">
                            </asp:DropDownList>
                                                                 
                                    </div>

                                 
                                </div>  

                      
                                
                          
                                                 
                                </div>  
                                </div>                                                    
                         <br/>
                         <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">





                                   <asp:LinkButton ID="submitButton" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="submitButton_Click" style="background-color: #00bcd4;color: #fff;"
                                  ><i class="fa fa-search-plus"></i>&nbsp; Search Information</asp:LinkButton>


                              <asp:LinkButton ID="submitButton0" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="submitButton0_OnClick" style="background-color: #00bcd4;color: #fff;"
                                  ><i class="fa fa-check-square"></i>&nbsp; Submit Information</asp:LinkButton>

<%--
                             <asp:LinkButton ID="LinkButton4"  class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" runat="server" OnClick="cancelButton_Click"
                                ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset Information </asp:LinkButton>

--%>

                                        
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" ClientIDMode="Static" DisplayAfter="0"
                                DynamicLayout="true">
                                <ProgressTemplate>
                                    <div class="divWaiting">
                                        <asp:Image ID="imgWait" runat="server" ImageAlign="Middle" ImageUrl="~/Images/loading-icon-big.gif"
                                            Height="100%" Width="100%" />
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                         <br />
                         <div class="row">
      <div class="table-responsive" id="MainGradeDiv">
       

                          <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender"
                                DataKeyNames="DCStoreFreezeId,DCStoreId" OnRowCommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:TemplateField HeaderText="#SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ProductCode" HeaderText="ProductCode" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch" />
                                    <asp:BoundField DataField="ExpDate" HeaderText="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="StockQty" HeaderText="StockQty" />
                                    <asp:BoundField DataField="Amount" HeaderText="Amount" />
                                    <asp:BoundField DataField="StockCondition" HeaderText="StockCondition" />
                                    <asp:TemplateField HeaderText="Return Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="returnQtyTextBox" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderconvRate" runat="server"
                                                Enabled="True" TargetControlID="returnQtyTextBox" FilterType="Custom" ValidChars="0123456789.">
                                            </cc1:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" AutoPostBack="True" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>

          </div>
          </div>              
                         <br />
                         <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">

                                  <asp:LinkButton ID="addButton" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="addButton_Click" style="background-color: #00bcd4;color: #fff;">   <i class="fa fa-plus"></i>&nbsp; Add</asp:LinkButton>
                          
                                         
                                    </div>
                                </div>

                            </div>

                            <div class="col-2">&nbsp;</div>
                        </div>
                         <br />
                         <div class="row">
                      <div class="table-responsive" id="MainGradeDiv">
       
                  

            


                       <asp:GridView ID="labelGridView" runat="server" AutoGenerateColumns="False"  CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender"
                                DataKeyNames="DCStoreFreezeId,DCStoreId" OnRowCommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:TemplateField HeaderText="#SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ProductCode" HeaderText="ProductCode" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch" />
                                    <asp:BoundField DataField="ExpDate" HeaderText="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="StockQty" HeaderText="StockQty" />
                                    <asp:BoundField DataField="Amount" HeaderText="Amount" />
                                    <asp:BoundField DataField="StockCondition" HeaderText="StockCondition" />
                                    <asp:BoundField DataField="ReturnQty" HeaderText="Return Qty" />
                                    <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
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


   
                                </div>  
                                </div>  
                                </div>  
                                </div>  
         
                                </div>  

        </div>  
     </div>  

                   </ContentTemplate>
    </asp:UpdatePanel>

<%--    <asp:UpdatePanel ID="UpdatePanel1" runat="server">



        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Freeze Stock Release
                        </td>
                    </tr>
                    <tr>
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
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" width="13%">
                            Distribution Center :
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="dcDropDownList" runat="server" CssClass="DropDown" OnSelectedIndexChanged="dcDropDownList_SelectedIndexChanged"
                                AutoPostBack="True">
                            </asp:DropDownList>
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
                            Manufacturer:
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="manufacturerDropDownList" runat="server" CssClass="radioButtonList"
                                AutoPostBack="True" OnSelectedIndexChanged="manufacturerDropDownList_SelectedIndexChanged">
                            </asp:DropDownList>
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
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:Button ID="submitButton" runat="server" Text="Search" OnClick="submitButton_Click"
                                BackColor="#339933" />
                          
                            <asp:Button ID="submitButton0" runat="server" OnClick="submitButton0_OnClick" Text="Submit" />


                            <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0"
                                DynamicLayout="true">
                                <ProgressTemplate>
                                    <div class="divWaiting">
                                        <asp:Image ID="imgWait" runat="server" ImageAlign="Middle" ImageUrl="~/Images/loading-icon-big.gif"
                                            Height="100%" Width="100%" />
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>

                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
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
                        <td width="20%" class="TDRight" colspan="6">
     
                            <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" CssClass="gridview"
                                DataKeyNames="DCStoreFreezeId,DCStoreId" OnRowCommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:TemplateField HeaderText="#SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ProductCode" HeaderText="ProductCode" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch" />
                                    <asp:BoundField DataField="ExpDate" HeaderText="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="StockQty" HeaderText="StockQty" />
                                    <asp:BoundField DataField="Amount" HeaderText="Amount" />
                                    <asp:BoundField DataField="StockCondition" HeaderText="StockCondition" />
                                    <asp:TemplateField HeaderText="Return Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="returnQtyTextBox" runat="server" CssClass="TextBoxMini"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderconvRate" runat="server"
                                                Enabled="True" TargetControlID="returnQtyTextBox" FilterType="Custom" ValidChars="0123456789.">
                                            </cc1:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" AutoPostBack="True" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                  
                        </td>
                    </tr>
                    
                    <tr>
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
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            <asp:Button ID="addButton" runat="server" Text="Add" 
                                onclick="addButton_Click" />
                        </td>
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
                        <td width="20%" class="TDRight" colspan="6">
    
                            <asp:GridView ID="labelGridView" runat="server" AutoGenerateColumns="False" CssClass="gridview"
                                DataKeyNames="DCStoreFreezeId,DCStoreId" OnRowCommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:TemplateField HeaderText="#SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ProductCode" HeaderText="ProductCode" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch" />
                                    <asp:BoundField DataField="ExpDate" HeaderText="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="StockQty" HeaderText="StockQty" />
                                    <asp:BoundField DataField="Amount" HeaderText="Amount" />
                                    <asp:BoundField DataField="StockCondition" HeaderText="StockCondition" />
                                    <asp:BoundField DataField="ReturnQty" HeaderText="Return Qty" />
                                    <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                                     <asp:TemplateField HeaderText="Remove Item">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="DeleteImageButton" runat="server" 
                                                ImageUrl="~/images/lineDelete.png" onclick="DeleteImageButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                
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
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
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
