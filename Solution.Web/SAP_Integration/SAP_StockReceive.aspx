<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SAP_StockReceive.aspx.cs" Inherits="SAP_Integration_SAP_StockReceive" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">



    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>&nbsp; SAP Stock Receive </div>

                <div class="ms-auto">
                    <div class="btn-group">
                         <%--<asp:LinkButton runat="server" OnClick="BackToListButton_Click" class="btn btnMyDesignReset   btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Back to list </asp:LinkButton>--%>
                          <a href="../SAP_Integration/SAP_IntrigationPoint.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>

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

                                    <asp:HiddenField ID="hdfStockMovementMasterId" runat="server" />


                                    <div class="row">

                                        <div class="col-4">
                                            <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">Challan No: </label>
                                                <div class="col-sm-7 p-2">
                                                    <asp:Label ID="lblChallanNo" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-4">
                                            <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">Challan Date: </label>
                                                <div class="col-sm-7 p-2">
                                                     <asp:Label ID="lblChallanDate" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-4">
                                            <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">Approval Status: </label>
                                                <div class="col-sm-7 p-2">
                                                     <asp:Label ID="lblStatus" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">

                                        <div class="col-4">
                                            <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">From: </label>
                                                <div class="col-sm-7 p-2">
                                                    <asp:Label ID="lblFrom" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-4">
                                            <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">To: </label>
                                                <div class="col-sm-7 p-2">
                                                     <asp:Label ID="lblTo" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                        
                                    </div>


                                    



                                    <br />

                                    <div class="row">
                                        <div class="table-responsive" id="MainGradeDiv">

                                            <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                                CssClass="table table-striped table-bordered" DataKeyNames="ReceiveType,StockQuantity,UnitPrice,ProductCode,quantity,StockQuantityChk">

                                                <Columns>
                                                        <asp:TemplateField HeaderText="#SL">
        <ItemTemplate>
            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>

              <asp:HiddenField runat="server" ID="hfStockMovementDetailId" Value='<%#Eval("StockMovementDetailId")%>' />
            
              
        </ItemTemplate>
    </asp:TemplateField>
                                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                                    <asp:BoundField DataField="PackSize" HeaderText="Pack Size" /> 
                                                    <asp:BoundField DataField="batch_no" HeaderText="Batch No." /> 
                                                    <asp:BoundField DataField="UnitPrice" HeaderText="Unit Price" />

                                                       <asp:TemplateField HeaderText="Quantity">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtquantity"  type="number"   runat="server" Text='<%#Eval("quantity") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                                                
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                                    
                                                    <asp:BoundField DataField="StockQuantity" HeaderText="Current Stock" />

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

                                                    <asp:LinkButton OnClick="ApproveButton_Click" runat="server" ID="ApproveButton" class="btn btnMyDesignSearch   btn-sm"><i class="fa fa-print" aria-hidden="true"></i>&nbsp; Approve </asp:LinkButton>
                                                   


                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">
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

