<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="UserProfile.aspx.cs" Inherits="UserProfile_UI_UserProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style>
        

/*profile*/
.profile-sidebar {
    float: left;
    width: 300px;
    margin-right: 20px
}

.profile-content {
    overflow: hidden
}

.profile-sidebar-portlet {
    padding: 30px 0 0!important
}

.profile-userpic img {
    float: none;
    margin: 0 auto;
    width: 50%;
    height: 50%;
    -webkit-border-radius: 50%!important;
    -moz-border-radius: 50%!important;
    border-radius: 50%!important
}

.profile-usertitle {
    text-align: center;
    margin-top: 20px
}

.profile-usertitle-name {
    color: #5a7391;
    font-size: 20px;
    font-weight: 600;
    margin-bottom: 7px
}


.profile-usertitle-nameDES {
    color: #5a7391;
    font-size: 18px;
     font-weight: 600;
    margin-bottom: 7px
}

.profile-usertitle-job {
    text-transform: uppercase;
    color: #5b9bd1;
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 7px
}

.profile-userbuttons {
    text-align: center;
    margin-top: 10px
}

.profile-userbuttons .btn {
    margin-right: 5px
}

.profile-userbuttons .btn:last-child {
    margin-right: 0
}

.profile-userbuttons button {
    text-transform: uppercase;
    font-size: 11px;
    font-weight: 600;
    padding: 6px 15px
}

.profile-usermenu {
    margin-top: 30px;
    padding-bottom: 20px
}

.profile-usermenu ul li {
    border-bottom: 1px solid #f0f4f7
}

.profile-usermenu ul li:last-child {
    border-bottom: none
}

.profile-usermenu ul li a {
    color: #93a3b5;
    font-size: 16px;
    font-weight: 400
}

.profile-usermenu ul li a i {
    margin-right: 8px;
    font-size: 16px
}

.profile-usermenu ul li a:hover {
    background-color: #fafcfd;
    color: #5b9bd1
}

.profile-usermenu ul li.active a {
    color: #5b9bd1;
    background-color: #f6f9fb;
    border-left: 2px solid #5b9bd1;
    margin-left: -2px
}

.profile-stat {
    padding-bottom: 20px;
    border-bottom: 1px solid #f0f4f7
}

.profile-stat-title {
    color: #7f90a4;
    font-size: 25px;
    text-align: center
}

.profile-stat-text {
    color: #5b9bd1;
    font-size: 11px;
    font-weight: 800;
    text-align: center
}

.profile-desc-title {
    color: #7f90a4;
    font-size: 17px;
    font-weight: 600
}

.profile-desc-text {
    color: #7e8c9e;
    font-size: 14px
}

.profile-desc-link i {
    width: 22px;
    font-size: 19px;
    color: #abb6c4;
    margin-right: 5px
}

.profile-desc-link a {
    font-size: 14px;
    font-weight: 600;
    color: #5b9bd1
}

@media (max-width:991px) {
    .profile-sidebar {
        float: none;
        width: 100%!important;
        margin: 0
    }
    .profile-sidebar>.portlet {
        margin-bottom: 20px
    }
    .profile-content {
        overflow: visible
    }
}

    </style>
       <div class="content" id="content">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                   <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
                <!-- PAGE HEADING -->
                
                

               
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> User Profile </div>  

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
                <!-- //END PAGE HEADING -->
                
             
             
       <style>
                    .imgshadow {
                      -webkit-box-shadow: 5px 5px 15px 5px #000000; 
box-shadow: 5px 5px 15px 5px #000000;
                    }
                     
                                                                                                 
                </style>
    

                 

                            <div class="row">

                                <div class="col-md-12">
                                     <div class="row">

                                            <div class="col-md-4">
                                                </DIv>
                                     
            <div class="col-md-4 card border-top border-0 border-4 border-primary" >

                <div class=" card-body"  >
                    <style>
                        .scenter {
                            display: block;
                            margin-left: auto;
                            margin-right: auto;
                            width: 50%;
                        }
                    </style>
                    <div class="profile-userpic">
                        <%--<asp:Image ID="UserImage" runat="server" CssClass="img-responsive scenter" alt="" />--%>
                        <img src="../images/man.png"  class="img-responsive scenter" alt="">
                    </div>
                    <div class="profile-usertitle">
                        
                         <div class="profile-usertitle-name">
                           <label class="font-weight-bold" style="color: black">ID: </label><asp:Label runat="server" ID="lblID" />
                        </div>
                      <div class="profile-usertitle-job">
                          <label class="font-weight-bold" style="color: black"> Name:</label> <asp:Label runat="server" ID="lblshortName" />
                        </div>

                         <div class="profile-usertitle-nameDES">
                         <label class="font-weight-bold" style="color: black"> Role:</label>  <asp:Label runat="server" ID="lblRoleName" />
                        </div>

                 <div class="profile-usertitle-nameDES">
                         <label class="font-weight-bold" style="color: black"> Designation:</label>  <asp:Label runat="server" ID="lblDesignation" />
                        </div>
                    </div>
                  <%--  <div class="profile-userbuttons">--%>
                        <%--<asp:UpdatePanel ID="upFormBody" runat="server">
            <ContentTemplate>--%>
                     <%--   <asp:Button ID="btnPrintCv" runat="server" OnClick="btnPrintCv_Click" CssClass="btn btn-info  btn-sm" Text="Print CV" />--%>
                        <%--</ContentTemplate>
                             </asp:UpdatePanel>--%>
                 <%--   </div>--%>
                    <br />
                    <%--   <div class="profile-usermenu">
                <ul class="nav">
                     <li class="active">
                        <a href="#">
                            <i class="icon-home"></i> Ticket List </a>
                    </li>
                    <li>
                        <a href="#">
                            <i class="icon-settings"></i> Support Staff </a>
                    </li>
                    <li>
                        <a href="#">
                            <i class="icon-info"></i> Configurations </a>
                    </li>
                </ul>
            </div>--%>
                </div>
            </div>
                                         
                                         
                                           <div class="col-md-4">
                                               </div>
                                    </div>
                                    
                                    
                                     <div class="row" runat="server" visible="false">
                                <style>
                                    .tblTHColorChang{
                                        background-color: #EDF2F5!important;
                                        font-weight: bold;
                                        font-size: 13px;
                                    }


.title-widget {
	color: #898989;
	font-size: 20px;
	font-weight: 300;
	line-height: 1;
	position: relative;
	text-transform: uppercase;
	font-family: 'Fjalla One', sans-serif;
	margin-top: 0;
	margin-right: 0;
	margin-bottom: 25px;
	 
	padding-left: 12px;

}

.title-widget::before {
    background-color: #ea5644;
    content: "";
    height: 22px;
    left: 0px;
    position: absolute;
    top: -2px;
    width: 5px;
}


                                </style>
                                            <div class="col-md-4">
                                        </div>
                                           <div class="col-md-4">
                                               
                                                 </DIv>
                                     
                                     
                                            </div>
                                    
                                    <div class="row"  runat="server" visible="false">
                                           <div class="col-md-4">
                                        </div>
                                         <div class="col-md-4">
                                             
                                                <div class="form-group">
                                        <label class="col-form-label">New Password&nbsp;<span style="color: #a52a2a">*</span></label>
                                        <asp:TextBox runat="server"  AutoCompleteType="None" ID="txt_Password" class="form-control form-control-sm"></asp:TextBox>
                                    </div>
                                                </DIv>
                                     
                                     
                                            </div>
                                    
                                    
                                     <div class="row" runat="server" visible="false">
                                           <div class="col-md-4">
                                        </div>
                                         <div class="col-md-4">
                                             
                                                <div class="form-group">
                                        <label class="col-form-label">Confirm Password&nbsp;<span style="color: #a52a2a">*</span></label>
                                        <asp:TextBox runat="server"  AutoCompleteType="None" ID="txtConfirm" class="form-control form-control-sm"></asp:TextBox>
                                                    <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="Password is not Matched" ForeColor="#CC3300" Font-Bold="True" ControlToCompare="txt_Password" ControlToValidate="txtConfirm"></asp:CompareValidator>
                                    </div>
                                                </DIv>
                                     
                                     
                                            </div>
   <div class="row" runat="server" visible="false">
                                        <div class="col-md-4">
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                           
                                                
                                                    <asp:LinkButton runat="server" ID="btn_Save" OnClick="btn_Save_OnClick" CssClass="btn btn-sm btn-info btn-block" OnClientClick="return sweetAlertConfirm_Update(this);" Style="box-shadow: 0 0 3px 1px rgba(0,0,0,.35);" > &nbsp; Update Password

&nbsp; </asp:LinkButton>
                                                 
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
    </div>
</asp:Content>

