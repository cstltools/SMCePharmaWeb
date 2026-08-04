

<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="StockConditionFreeze.aspx.cs" Inherits="SInventory_UI_StockConditionFreeze" %>

<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


      <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Stock Condition Freeze </div>

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


                

                    <div class="card-body">
                        <br/>
                        
 <div class="row">&nbsp;</div>
                        <div class="row">&nbsp;</div>

                         <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">



                               <div id="Div1" class="form-group row" runat="server" Visible="False">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Central Warehouse  :</label>

                                    <div class="col-sm-5">
                                    
                                          
                                            <asp:CheckBox ID="centalWHCheckBox" runat="server" AutoPostBack="True" OnCheckedChanged="centalWHCheckBox_CheckedChanged" Enabled="False"/>
                                
                                                                 
                                    </div>

                                 
                                </div>  

                               <div class="form-group row" runat="server" visible="False" id="DIVCH">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Central Warehouse  :</label>

                                    <div class="col-sm-5">
                                    
                                          
                                           <asp:DropDownList ID="whDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="True"
                                                OnSelectedIndexChanged="whDropDownList_SelectedIndexChanged">
                                                </asp:DropDownList>
                                 
                                                                 
                                    </div>

                                 
                                </div>  



 
                               <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Manufacturer :</label>

                                    <div class="col-sm-5">
                                    
                                          

                               
                              <asp:DropDownList ID="manufacturerDropDownList" runat="server" AutoPostBack="True"
                                CssClass="form-select form-select-sm mb-3 mySelect2" OnSelectedIndexChanged="manufacturerDropDownList_SelectedIndexChanged">
                            </asp:DropDownList>
                                                                 
                                    </div>

                                 
                                </div>  

                               <div class="form-group row" runat="server" visible="True" id="DIVDC">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Distribution Center :</label>

                                    <div class="col-sm-5">
                                                                            
                                       <asp:DropDownList ID="dcDropDownList1" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="True"
                                        OnSelectedIndexChanged="dcDropDownList1_SelectedIndexChanged">
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





                                   <asp:LinkButton ID="LinkButton1" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="submitButton_Click" style="background-color: #00bcd4;color: #fff;"
                                  ><i class="fa fa-search-plus"></i>&nbsp; Search Information</asp:LinkButton>


                              <asp:LinkButton ID="LinkButton2" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="submitButton0_OnClick" style="background-color: #00bcd4;color: #fff;"
                                  ><i class="fa fa-check-square"></i>&nbsp; Submit Information</asp:LinkButton>


                             <asp:LinkButton ID="LinkButton4"  class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" runat="server" OnClick="cancelButton_Click"
                                ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset Information </asp:LinkButton>



                                        
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
                                    DataKeyNames="nomanslandID" OnRowCommand="loadGridView_RowCommand">
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
                                        <asp:BoundField DataField="ReceiveDate" HeaderText="Receive Date"  DataFormatString="{0:dd-MMM-yyyy}"/>
                                        <asp:BoundField DataField="TotalQuantity" HeaderText="StockInQty" />
                                        <asp:BoundField DataField="StockQty" HeaderText="C.StockQty" />
                                        <asp:BoundField DataField="Amount" HeaderText="Amount" />
                                         <asp:BoundField DataField="StockCondition" HeaderText="Stock" />
                                          <asp:TemplateField HeaderText="Stock Condition">
                                            <ItemTemplate>
                                                <asp:DropDownList ID="StockConditionDropDownList" runat="server" class="form-control" Width="90px" AutoPostBack="True" OnSelectedIndexChanged="myListDropDown_Change"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Qty">
                                            <ItemTemplate>
                                                <asp:TextBox ID="returnQtyTextBox" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderconvRate" runat="server"
                                                    Enabled="True" TargetControlID="returnQtyTextBox" FilterType="Custom" ValidChars="0123456789">
                                                </cc1:FilteredTextBoxExtender>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Remarks">
                                            <ItemTemplate>
                                                <asp:TextBox ID="remarksTextBox" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                       <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" 
                                                    oncheckedchanged="chkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" AutoPostBack="True" runat="server" />
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

   <%-- <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Stock Condition Freeze
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
                    <tr runat="server" Visible="False">
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" width="13%">
                            Central Warehouse :
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:CheckBox ID="centalWHCheckBox" runat="server" AutoPostBack="True" OnCheckedChanged="centalWHCheckBox_CheckedChanged" Enabled="False"/>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                    <tr runat="server" visible="False" id="DIVCH">
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" width="13%">
                            Central Warehouse :
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="whDropDownList" runat="server" CssClass="DropDown" AutoPostBack="True"
                                OnSelectedIndexChanged="whDropDownList_SelectedIndexChanged">
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
                            <asp:DropDownList ID="manufacturerDropDownList" runat="server" AutoPostBack="True"
                                CssClass="DropDown" OnSelectedIndexChanged="manufacturerDropDownList_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                    <tr runat="server" visible="True" id="DIVDC">
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" width="13%">
                            Distribution Center :
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="dcDropDownList1" runat="server" CssClass="DropDown" AutoPostBack="True"
                                OnSelectedIndexChanged="dcDropDownList1_SelectedIndexChanged">
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
                            <asp:Button ID="submitButton" runat="server" Text="Search" 
                                OnClick="submitButton_Click" BackColor="#339933" />
                       
                            <asp:Button ID="submitButton0" runat="server" OnClick="submitButton0_OnClick" 
                                Text="Submit" />
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
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
                                    DataKeyNames="nomanslandID" OnRowCommand="loadGridView_RowCommand">
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
                                        <asp:BoundField DataField="ReceiveDate" HeaderText="Receive Date"  DataFormatString="{0:dd-MMM-yyyy}"/>
                                        <asp:BoundField DataField="TotalQuantity" HeaderText="StockInQty" />
                                        <asp:BoundField DataField="StockQty" HeaderText="C.StockQty" />
                                        <asp:BoundField DataField="Amount" HeaderText="Amount" />
                                         <asp:BoundField DataField="StockCondition" HeaderText="Stock" />
                                          <asp:TemplateField HeaderText="Stock Condition">
                                            <ItemTemplate>
                                                <asp:DropDownList ID="StockConditionDropDownList" runat="server" class="form-control" Width="90px" AutoPostBack="True" OnSelectedIndexChanged="myListDropDown_Change"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Qty">
                                            <ItemTemplate>
                                                <asp:TextBox ID="returnQtyTextBox" runat="server" Width="60px"></asp:TextBox>
                                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderconvRate" runat="server"
                                                    Enabled="True" TargetControlID="returnQtyTextBox" FilterType="Custom" ValidChars="0123456789">
                                                </cc1:FilteredTextBoxExtender>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Remarks">
                                            <ItemTemplate>
                                                <asp:TextBox ID="remarksTextBox" runat="server" ></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                       <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" 
                                                    oncheckedchanged="chkSelectAll_CheckedChanged" />
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
