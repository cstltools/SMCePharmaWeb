<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SAP_IntrigationPoint.aspx.cs" Inherits="SAP_Integration_SAP_IntrigationPoint" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
         <style>
       .radioChoice label {
         padding-left: 5px;
         padding-right: 30px;
               font-size: 20px;
               font-weight: bold;
     }
             </style>

    <script type="text/javascript">


    function pageLoad() {


        $('.datepicker').pickadate({
            selectMonths: true,
            selectYears: true
        })
        $('.multiple-select').select2({
            includeSelectAllOption: true,
            theme: 'bootstrap4',
            width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
            placeholder: $(this).data('placeholder'),
            allowClear: Boolean($(this).data('allow-clear')),
        });
        $('.mySelect2').select2({
            theme: 'bootstrap4',
            width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
            placeholder: $(this).data('placeholder'),
            allowClear: Boolean($(this).data('allow-clear')),
        });


        $(".fancybox").fancybox({
            openEffect: "none",
            closeEffect: "none"
        });

        $(".zoom").hover(function () {

            $(this).addClass('transition');
        }, function () {

            $(this).removeClass('transition');
        });
    }
    </script>
       <div class="page-wrapper">
       <div class="page-content">
           <!--breadcrumb-->
           <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
               <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> SAP Integration Point</div>

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
<asp:HiddenField runat="server" ID="id_mastetID"/>
                                    <div class="row" style="display:none">

                                         <div class="col-md-4" >
                                             </div>
                                        <div class="col-md-4" >
                                                                                  <asp:GridView ID="gv_HeaderInfo" runat="server" AutoGenerateColumns="False"
          CssClass="table table-bordered  text-center thead-dark" >
       <Columns>

           <asp:TemplateField HeaderText="SL#">
               <ItemTemplate>
                   <%#Container.DataItemIndex+1 %>
                   
               </ItemTemplate>
           </asp:TemplateField>
 

           <asp:BoundField DataField="Title" HeaderText="Title" /> 
           <asp:BoundField DataField="ValueName" HeaderText="Value" />
          
               </Columns>
</asp:GridView>
                                        </div>
                                    </div>


                                                <div class="row">

                 
                <div class="col-md-12" style="text-align:center">
<asp:RadioButtonList runat="server" ID="rbType" CssClass="radioChoice"  AutoPostBack="true" OnSelectedIndexChanged="rbType_SelectedIndexChanged"  RepeatDirection="Horizontal" RepeatLayout="Flow">
    <asp:ListItem Value="Product Info">Product Info</asp:ListItem>
    <asp:ListItem Value="Employee Info">Employee Info</asp:ListItem>
     <asp:ListItem style="display:none" Value="Stock Receive">Stock Receive</asp:ListItem>
</asp:RadioButtonList>
                 </div>
                 </div>
          <br />

                                              <div class="row">
<div class="table-responsive" id="MainGradeDiv">

    

       <asp:GridView ID="gv_EmpInfo" runat="server" AutoGenerateColumns="False"  onrowcommand="gv_EmpInfo_RowCommand" 
      CssClass="table table-bordered  text-center thead-dark dtclass2" OnPreRender="gv_DocumentUpload_PreRender">

      <Columns>
          <asp:TemplateField HeaderText="#SL">
              <ItemTemplate>
                  <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>

                    <asp:HiddenField runat="server" ID="hfemployee_code" Value='<%#Eval("employee_code")%>' />
                    <asp:HiddenField runat="server" ID="hfRoleType" Value='<%#Eval("RoleType")%>' />
                 
                    <asp:HiddenField runat="server" ID="hfemployee_id" Value='<%#Eval("employee_id")%>' />
                     <asp:HiddenField runat="server" ID="hfaction" Value='<%#Eval("action")%>' />
              </ItemTemplate>
          </asp:TemplateField>
       
           <asp:BoundField DataField="employee_code" HeaderText="EMP SAP Code" /> 
           <asp:BoundField DataField="name" HeaderText="EMP Name" /> 
           <asp:BoundField DataField="RoleType" HeaderText="Role Type" /> 
           <asp:BoundField DataField="joining_date" HeaderText="Joining Date" /> 
           <asp:BoundField DataField="mobile_no" HeaderText="Mobile No" /> 
           <asp:BoundField DataField="FTerritoryName" HeaderText="From Territory" /> 
           <asp:BoundField DataField="TTerritoryName" HeaderText="To Territory" /> 
          <asp:BoundField DataField="FAreaName" HeaderText="From Area" /> 
           <asp:BoundField DataField="TAreaName" HeaderText="To Area" />  

            <asp:BoundField DataField="FZoneName" HeaderText="From Zone" /> 
   <asp:BoundField DataField="TZoneName" HeaderText="To Zone" />  
   <asp:BoundField DataField="action" HeaderText="Action Status" />  


               
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                             
                                           <asp:LinkButton ID="lbApprove" runat="server" class="btn-info  btn-sm mb-1 mb-md-0"
                                                                     CommandArgument="<%# Container.DataItemIndex %>" CommandName="ApproveData"><i class='fa fa-check' aria-hidden='true'></i> Approve</asp:LinkButton>
                                              
                                             
                                        </ItemTemplate>
                                    </asp:TemplateField>
      </Columns>

  </asp:GridView>

           <asp:GridView ID="gv_ProductInfo" runat="server" AutoGenerateColumns="False" 
      CssClass="table table-bordered  text-center thead-dark dtclass" OnPreRender="gv_DocumentUpload_PreRender">

      <Columns>
          <asp:TemplateField HeaderText="#SL">
              <ItemTemplate>
                  <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>

                    <asp:HiddenField runat="server" ID="hfstatus" Value='<%#Eval("status")%>' />
                    <asp:HiddenField runat="server" ID="hfproduct_code" Value='<%#Eval("product_code")%>' />
                    <asp:HiddenField runat="server" ID="hfproduct_id" Value='<%#Eval("product_id")%>' />
                    
              </ItemTemplate>
          </asp:TemplateField>
       
           <asp:BoundField DataField="product_code" HeaderText="Product Code" /> 
           <asp:BoundField DataField="product_name" HeaderText="Product Name" /> 
           <asp:BoundField DataField="description" HeaderText="Description" /> 
           <asp:BoundField DataField="effective_date" HeaderText="Entry Date" /> 
           
   <asp:BoundField DataField="action" HeaderText="Action Status" />  


               
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                             
                                           <asp:LinkButton ID="lbApprove" runat="server" class="btn-info  btn-sm mb-1 mb-md-0" OnClick="lbApprove_Click"
                                                                     CommandArgument="<%# Container.DataItemIndex %>"  ><i class='fa fa-check' aria-hidden='true'></i> Approve</asp:LinkButton>
                                              
                                             
                                        </ItemTemplate>
                                    </asp:TemplateField>
      </Columns>

  </asp:GridView>

       <asp:GridView ID="gv_StockReceive"  runat="server" AutoGenerateColumns="False" OnRowCommand="gv_StockReceive_RowCommand" OnRowDataBound="gv_StockReceive_RowDataBound"
                                                CssClass="table table-bordered  text-center thead-dark dtclass2" OnPreRender="gv_StockReceive_PreRender" DataKeyNames="StockMovementMasterId">

                                                <Columns>
                                                    <asp:TemplateField HeaderText="#SL">
                                                        <ItemTemplate>
                                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>

                                                            <asp:HiddenField runat="server" ID="hfstatus" Value='<%#Eval("challan_code")%>' />


                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:BoundField DataField="challan_code" HeaderText="Challan No" />
                                                    <asp:BoundField DataField="challan_date" HeaderText="Challan Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                    <asp:BoundField DataField="FromWH" HeaderText="From" />
                                                    <asp:BoundField DataField="to_plant_code" HeaderText="To" />
                                                    <asp:BoundField DataField="action" HeaderText="Action Status" />
                                                    <%--<asp:BoundField DataField="ProductAndQuantity" HeaderText="Description" />--%>
                                                    <asp:TemplateField HeaderText="Actions">
                                                        <ItemTemplate>

                                                           <%-- <asp:LinkButton ID="lbApprove" runat="server" class="btn-info  btn-sm mb-1 mb-md-0"
                                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="ApproveData"><i class='fa fa-check' aria-hidden='true'></i> Approve</asp:LinkButton>--%>
                                                            
                                                            
                                                            
                                                            <asp:Button ID="PreviewButton" runat="server" Text="Preview >>" CssClass="btn btn-sm  btn-info" 
                                                                OnClick="previewButton_Click" />

                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>

                                            </asp:GridView>

  

                </div>
            </div>

                                   <script>

                                       $(document).ready(function () {



                                           var table = $('.dtclass2').DataTable(
                                               {
                                                   deferRender: true,
                                                   scrollY: 300,
                                                   scrollCollapse: true,
                                                   scroller: true,
                                                   "bInfo": true,
                                                   "bFilter": true,
                                                   lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                                                   pageLength: 10,
                                                   dom: 'lBfrtip',


                                                   //ordering: false,
                                                   //info: false,
                                                   buttons: ['copy', 'excel', 'pdf', 'print']
                                               }
                                           );

                                           var prm = Sys.WebForms.PageRequestManager.getInstance();
                                           if (prm != null) {
                                               prm.add_endRequest(function (sender, e) {
                                                   if (sender._postBackSettings.panelsToUpdate != null) {

                                                       table = $('.dtclass2').DataTable(
                                                           {

                                                               deferRender: true,
                                                               scrollY: 300,
                                                               scrollCollapse: true,
                                                               scroller: true,
                                                               "bInfo": true,
                                                               "bFilter": true,
                                                               lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                                                               pageLength: 10,
                                                               dom: 'lBfrtip',
                                                               //paging: false,
                                                               //ordering: false,
                                                               //info: false,

                                                               buttons: ['copy', 'excel', 'pdf', 'print']


                                                           }
                                                       );
                                                   }
                                               });
                                           };


                                           table.columns().every(function () {
                                               var that = this;


                                           });
                                       });


                                   </script>
                                   </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>

       
    <script>

        $(document).ready(function () {



            var table = $('.dtclass').DataTable(
                {
                    deferRender: true,
                    scrollY: 300,
                    scrollCollapse: true,
                    scroller: true,
                    "bInfo": true,
                    "bFilter": true,
                    lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    pageLength: 10,
                    dom: 'lBfrtip',


                    //ordering: false,
                    //info: false,
                    buttons: ['copy', 'excel', 'pdf', 'print']
                }
            );

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            if (prm != null) {
                prm.add_endRequest(function (sender, e) {
                    if (sender._postBackSettings.panelsToUpdate != null) {

                        table = $('.dtclass').DataTable(
                            {

                                deferRender: true,
                                scrollY: 300,
                                scrollCollapse: true,
                                scroller: true,
                                "bInfo": true,
                                "bFilter": true,
                                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                                pageLength: 10,
                                dom: 'lBfrtip',
                                //paging: false,
                                //ordering: false,
                                //info: false,

                                buttons: ['copy', 'excel', 'pdf', 'print']


                            }
                        );
                    }
                });
            };


            table.columns().every(function () {
                var that = this;


            });
        });


    </script>  
</asp:Content>

