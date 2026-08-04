<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="StockRcvByWH.aspx.cs" Inherits="SInventory_UI_StockRcvByWH" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


         <div class="page-wrapper">
			<div class="page-content">
				<!--breadcrumb-->
                
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Stock Receive WH</div>
                
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
                               <asp:UpdateProgress ID="UpdateProgress1" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
							 

                                         <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Warehouse:</label>

                                                <div class="col-sm-5">


                                                    <asp:DropDownList ID="dcDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" >
                                                    </asp:DropDownList>

                                                        <script type="text/javascript">
                                                        function pageLoad() {
                                                            $('.mySelect2').select2({
                                                                theme: 'bootstrap4',
                                                                width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                                placeholder: $(this).data('placeholder'),
                                                                allowClear: Boolean($(this).data('allow-clear')),
                                                            });
                                                            $('.datepicker').pickadate({
                                                                selectMonths: true,
                                                                selectYears: true
                                                            })
                                                            
                                                        }
                                                        </script>


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

                                                      <asp:LinkButton  OnClick="searchButton_Click"   runat="server" id="searchButton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-search"></i> Search
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                  


                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>


                                                 <br />

                                    <div class="row">
                                        <div class="table-responsive" id="MainGradeDiv">


                                <asp:GridView ID="stockInTraGridView" runat="server" AutoGenerateColumns="False"
                                   DataKeyNames="ReqId" CssClass="table table-bordered  text-center thead-dark"  OnPreRender="gv_DocumentUpload_PreRender">
                                    <Columns>
                                        <asp:BoundField DataField="IssueChalanNo" HeaderText="ChalanNo" />
                                        <asp:BoundField DataField="IssuChalanDate" DataFormatString="{0:dd-MMM-yyyy}" HeaderText="ChalanDate" />
                                        <asp:BoundField DataField="TruckNo" HeaderText="TruckNo" />
                                        <asp:BoundField DataField="DriverName" HeaderText="DriverName" />
                                        <asp:HyperLinkField HeaderText="Receive Product" DataNavigateUrlFields="ReqId" DataNavigateUrlFormatString="ReceiveProductByChalanByWh.aspx?ReqId={0}"
                                            Text="Receive Product &gt;&gt;" />
                                    </Columns>
                                </asp:GridView>
                                        </div>
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
