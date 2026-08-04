<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SampleStockforWarehouse.aspx.cs" Inherits="SInventory_UI_SampleStockforWarehouse" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Warehouse Sample Stock Conversion </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        
<%-- <asp:LinkButton ID="viewLinkButton"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="viewLinkButton_OnClick" runat="server"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>--%>

                    
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
                        <div class="row">&nbsp;</div>

                                         <asp:HiddenField ID="HiddenField1" runat="server" />

                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
 
                               <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  SC :</label>

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

                                      <asp:DropDownList ID="DistributioncenterDropDownList1" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="True"  OnSelectedIndexChanged="DistributioncenterDropDownList1_OnSelectedIndexChanged">
                                     </asp:DropDownList>
                                                                 
                                    </div>

                                    
                                </div>  

                               <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Action :</label>

                                    <div class="col-sm-5">
                                    
                                          

                                            <asp:DropDownList ID="ActionDropDownList" runat="server" 
                                         CssClass="form-select form-select-sm mb-3 mySelect2 "  >
                            <asp:ListItem Value="0">Select One </asp:ListItem>
                            <asp:ListItem Value="1">Sample to Sound </asp:ListItem>
                            <asp:ListItem Value="2">Sound to Sample </asp:ListItem>

                        </asp:DropDownList>
                                                                 
                                    </div>

                                 
                                </div>  

                               <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">  Date :</label>

                                    <div class="col-sm-5">
                                     

                             <asp:TextBox ID="DateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker " ></asp:TextBox>
                          
                           
                           
                                    
                                    </div>
                                 
                                </div>   
                 
                               <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">  Product :</label>

                                    <div class="col-sm-5">
                                    
                                            <asp:DropDownList ID="productDropDownList"  CssClass="form-select form-select-sm mb-3 mySelect2"   runat="server" > </asp:DropDownList>
                                                                 
                                    </div>

                                 
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

                                  <asp:LinkButton ID="Button2" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="Button1_Click" style="background-color: #00bcd4;color: #fff;">   <i class="fa fa-search-plus"></i>&nbsp; Search Product</asp:LinkButton>
                          
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>                 
                        <br/>
       <div class="row">
           <div class="table-responsive" id="MainGradeDiv">                      
                           <asp:GridView ID="DerectStoctGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="table table-bordered  text-center thead-dark" OnPreRender="gv_DocumentUpload_PreRender" DataKeyNames="ReceiveId" >
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
                                    <asp:BoundField DataField="StockInQty" HeaderText="Stock Qty" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />
                                        <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ReceiveDate" />
                                    <asp:TemplateField HeaderText="Convention Stock">
                                        <ItemTemplate>
                                               <asp:TextBox ID="ConventionTextBox" runat="server" CssClass="TextBox" 
                                                Height="21px" ontextchanged="dQtyTextBox_TextChanged" AutoPostBack="True"></asp:TextBox>
                                                 <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderconvRate" runat="server"
                                                    Enabled="True" TargetControlID="ConventionTextBox" FilterType="Custom" ValidChars="0123456789">
                                                </asp:FilteredTextBoxExtender>
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
       
                          
           <asp:GridView ID="ProductGridView" runat="server" AutoGenerateColumns="False" 
                                 CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender" DataKeyNames="ReceiveId">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                                    HeaderText="Receive Date" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                                    HeaderText="Expiry Date" />
                                    <asp:BoundField DataField="StockInQty" HeaderText="Current Stock" />
                                    <asp:BoundField DataField="ConventionStock" HeaderText="Convention Stock" />

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

                        <br />
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">

 <asp:LinkButton ID="submitButton" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="submitButton_Click1" style="background-color: #00bcd4;color: #fff;"
                 >   <i class="fa fa-check-square"></i>&nbsp; Submit Information</asp:LinkButton>
                            <asp:LinkButton ID="LinkButton4"  class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" runat="server" OnClick="cancelButton_Click"
                                ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset Information </asp:LinkButton>
                                         
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

    <%--     <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                               Warehouse Sample Stock Conversion
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            <asp:HiddenField ID="HiddenField1" runat="server" />
                    
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">

                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            View List :
                        </td>
                        <td width="20%" class="TDRight">
                    
                            <asp:ImageButton ID="ImageButton3" runat="server" 
                                             ImageUrl="~/images/viewList.png" onclick="ListImageButton_Click" />
                            </td>
                        <td width="13%" class="TDLeft">
                       
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                    </tr>

                       <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            </td>
                        <td width="13%" class="TDLeft">
                            Sc:
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="DistributioncenterDropDownList1" runat="server" CssClass="DropDown" AutoPostBack="True"  OnSelectedIndexChanged="DistributioncenterDropDownList1_OnSelectedIndexChanged">
                            </asp:DropDownList>
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
                        </td>
                    <td width="13%" class="TDLeft">
                        Action:
                    </td>
                    <td width="20%" class="TDRight">
                        <asp:DropDownList ID="ActionDropDownList" runat="server" 
                                          CssClass="DropDown" >
                            <asp:ListItem Value="0">Select One </asp:ListItem>
                            <asp:ListItem Value="1">Sample to Sound </asp:ListItem>
                            <asp:ListItem Value="2">Sound to Sample </asp:ListItem>

                        </asp:DropDownList>
                       </td>
                    <td width="13%" class="TDLeft">
                    
                    </td>
                    <td width="20%" class="TDRight">
                    </td>
                </tr>

                <tr>
                    <td class="TDLeft" width="13%">
                    </td>
                    <td class="TDRight" width="20%">
                        </td>
                    <td class="TDLeft" width="13%">
                          Date:
                    </td>
                    <td class="TDRight" width="20%">
                        <asp:TextBox ID="DateTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                         TabIndex="4" ID="imgDate"></asp:ImageButton>
                        <asp:CalendarExtender ID="Date" runat="server" Format="dd-MMM-yyyy" TargetControlID="DateTextBox"
                                              PopupButtonID="imgDate">
                        </asp:CalendarExtender>

                    </td>
                    <td class="TDLeft" width="13%">
                          
                    <td class="TDRight" width="20%">
                    </td>
                </tr>

                 
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            </td>
                        <td class="TDLeft" width="13%">
                            Product:
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="productDropDownList" runat="server" AutoPostBack="True" 
                                              CssClass="DropDown" 
                                             >
                            </asp:DropDownList>
                            &nbsp;
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
                            <asp:Button ID="Button2" runat="server" Text="Search Product" onclick="Button1_Click" />
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
                            <asp:GridView ID="DerectStoctGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="ReceiveId" >
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
                                    <asp:BoundField DataField="StockInQty" HeaderText="Stock Qty" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />
                                        <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ReceiveDate" />
                                    <asp:TemplateField HeaderText="Convention Stock">
                                        <ItemTemplate>
                                               <asp:TextBox ID="ConventionTextBox" runat="server" CssClass="TextBox" 
                                                Height="21px" ontextchanged="dQtyTextBox_TextChanged" AutoPostBack="True"></asp:TextBox>
                                                 <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderconvRate" runat="server"
                                                    Enabled="True" TargetControlID="ConventionTextBox" FilterType="Custom" ValidChars="0123456789">
                                                </asp:FilteredTextBoxExtender>
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
                            <asp:GridView ID="ProductGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="ReceiveId">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                                    HeaderText="Receive Date" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                                    HeaderText="Expiry Date" />
                                    <asp:BoundField DataField="StockInQty" HeaderText="Current Stock" />
                                    <asp:BoundField DataField="ConventionStock" HeaderText="Convention Stock" />

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
                                <asp:Button ID="submitButton" runat="server" onclick="submitButton_Click1" 
                                            Text="Submit" />
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
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            </td>
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
    </asp:UpdatePanel>--%>
    

</asp:Content>

