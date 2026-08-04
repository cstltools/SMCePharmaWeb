<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="EmpGeneralInfoEntry.aspx.cs" Inherits="HRM_UI_EmpGeneralInfo" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
       
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script src="../scripts/jquery.min.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.js" type="text/javascript"></script>
    <%--<script src="../scripts/jquery.js" type="text/javascript"></script>--%>
    <link href="../css/jquery-ui.css" rel="stylesheet" type="text/css" />
    
    <link type="text/css" href="../css/Date/jquery.datepick.css" rel="stylesheet">
   <script type="text/javascript" src="../css/Date/jquery.datepick.js"></script>
   <script type="text/javascript">
       $(function () {
           $('.datepick').datepick();
       });
       var prm = Sys.WebForms.PageRequestManager.getInstance();
       if (prm != null) {
           prm.add_endRequest(function (sender, e) {
               if (sender._postBackSettings.panelsToUpdate != null) {

                   $('.datepick').datepick();
               }
           });
       }; 
 </script>
    
   <script type="text/javascript">
        $(document).ready(function() {
            $('#accordion').accordion({
                collapsible: true,
                active: 0,
                autoHeight: false
            });
        });
        ////On UpdatePanel Refresh
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        if (prm != null) {
            prm.add_endRequest(function (sender, e) {
                if (sender._postBackSettings.panelsToUpdate != null) {

                    $("#accordion").accordion({
                        collapsible: true,
                        active: parseInt(document.getElementById('<%= this.hidAccordionIndex.ClientID %>').value),
                        autoHeight: false
                    });
                }
            });
        };         
     </Script>
     
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                 <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Employee General Information
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            View List</td>
                        <td width="20%" class="TDRight">
                          <asp:ImageButton ID="empViewImageButton" runat="server" 
                                ImageUrl="~/images/viewList.png" onclick="empViewImageButton_Click" />
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:Label ID="MessageLabel" runat="server"></asp:Label>
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    </table>
                     <asp:HiddenField ID="hidAccordionIndex" runat="server" Value="1" />
                <div id="accordion" width="100%">
               
                    
                    <h3>
                        Employee General Information Part-1</h3>
                    <div>
                        <table width="100%" class="TableWorkArea">
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft" rowspan="5">
                            <asp:Image ID="pictureImage" runat="server" Height="104px" Width="100px" />
                            <asp:Button ID="previewButton" runat="server" onclick="previewButton_Click" 
                                PostBackUrl="~/HRM_UI/EmpGeneralInfo.aspx" Text="Preview" />
                            </td>
                        <td width="20%" class="TDRight" >
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
                                <td class="TDRight" width="20%">
                                    &nbsp;
                                </td>
                            </tr>
                    <div>
                    <tr>
                        <td width="13%" class="TDLeft">
                             &nbsp;</td>
                       <td class="TDRight" width="20%">
                            Employee Name :</td>
                        <td width="13%" class="TDLeft">
                            <asp:TextBox ID="empNameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                         
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                    </tr>
                    </div>
                            <tr>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                                <td class="TDRight" width="20%">
                                    Short Name :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="shortNameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                                </td>
                                <td class="TDRight" width="20%">
                                    &nbsp;</td>
                                 
                        <td width="20%" class="TDRight">
                            </td>
                            </tr>
                            <tr>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                               <td class="TDRight" width="20%">
                                    Father Name : </td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="fatherNameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                                </td>
                                <td class="TDRight" width="20%">
                                    &nbsp;</td>
                                 
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                            </tr>
                            <tr>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                               <td class="TDRight" width="20%">
                                    Mother Name :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="motherNameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                                </td>
                                <td class="TDRight" width="20%">
                                    &nbsp;</td>
                                <td class="TDLeft"  width="13%" colspan="2">
                                    <asp:FileUpload ID="pictureFileUpload" runat="server" />
                                </td>
                                    
                            </tr>
                            <tr>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                               <td class="TDRight" width="20%">
                                    Religion :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="religionTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                                </td>
                                <td class="TDRight" width="20%">
                                    &nbsp;</td>
                                <td class="TDLeft" width="13%" colspan="2" rowspan="2">
                                    <asp:Image ID="signatureImage" runat="server" Height="40px" Width="170px" />
                                    <asp:Button ID="sigpreviewButton" runat="server" 
                                        onclick="sigpreviewButton_Click" PostBackUrl="~/HRM_UI/EmpGeneralInfo.aspx" 
                                        Text="Preview" />
                                </td> 
                              <tr>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                               <td class="TDRight" width="20%">
                                    Nationality :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="nationalityTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                                                                      
                                   </td>
                                <td class="TDRight" width="20%">
                                    &nbsp;</td>
                                </tr> 

                            </tr>
                            <tr>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                               <td class="TDRight" width="20%">
                                    Date Of Birth</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="dateOfBirthTextBox" runat="server" CssClass="datepick"></asp:TextBox>
                                </td>
                                <td class="TDRight" width="20%">
                                    &nbsp;</td>
                                <td class="TDLeft" colspan="2">
                                    <asp:FileUpload ID="sigFileUpload" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                                <td class="TDRight" width="20%">
                                    Place Of Birth :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="placeOfBirthTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                                </td>
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
                    </table>
                    </div>
                    
                    <h3>
                        Employee General Information Part-2</h3>
                    <div>
                        <table width="100%" class="TableWorkArea">
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
                                    Present Address :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="prtAddressTextBox" runat="server" CssClass="TextBox" 
                                        TextMode="MultiLine"></asp:TextBox>
                                </td>
                                <td class="TDRight" width="20%">
                                    Permanent Address :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="permAddressTextBox" runat="server" CssClass="TextBox" 
                                        TextMode="MultiLine"></asp:TextBox>
                                </td>
                                <td class="TDRight" width="20%">
                                    &nbsp;</td>
                            </tr>
                            
                             <tr>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                                <td class="TDRight" width="20%">
                                    National Id No :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="nationalIdNoTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                                 </td>
                                <td class="TDRight" width="20%">
                                    Designation</td>
                                <td class="TDLeft" width="13%">
                                    <asp:DropDownList ID="designationDropDownList" runat="server" 
                                        CssClass="DropDown">
                                    </asp:DropDownList>
                                 </td>
                                <td class="TDRight" width="20%">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                               <td class="TDRight" width="20%">
                                    Gender :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:DropDownList ID="genderDropDown" runat="server" CssClass="DropDown">
                                        <asp:ListItem>----Select----</asp:ListItem>
                                        <asp:ListItem>Male</asp:ListItem>
                                        <asp:ListItem>Female</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td class="TDRight" width="20%">
                                    Department</td>
                                <td class="TDLeft" width="13%">
                                    <asp:DropDownList ID="departmentDropDownList" runat="server" 
                                        CssClass="DropDown">
                                    </asp:DropDownList>
                                </td>
                                <td class="TDRight" width="20%">
                                    &nbsp;</td>
                            </tr>
                            
                            <tr>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                               <td class="TDRight" width="20%">
                                    Blood Group :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:DropDownList ID="bloodGroupDropDown" runat="server" CssClass="DropDown">
                                        <asp:ListItem>----Select----</asp:ListItem>
                                        <asp:ListItem>A+</asp:ListItem>
                                        <asp:ListItem>A-</asp:ListItem>
                                        <asp:ListItem>B+</asp:ListItem>
                                        <asp:ListItem>B-</asp:ListItem>
                                        <asp:ListItem>O+</asp:ListItem>
                                        <asp:ListItem>O-</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td class="TDRight" width="20%">
                                    Mobile No :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="mobileNoTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                                </td>
                                <td class="TDRight" width="20%">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                               <td class="TDRight" width="20%">
                                    Marital Status :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:DropDownList ID="maritalStatusDropDown" runat="server" CssClass="DropDown">
                                        <asp:ListItem>----Select----</asp:ListItem>
                                        <asp:ListItem>Married</asp:ListItem>
                                        <asp:ListItem>UnMarried</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td class="TDRight" width="20%">
                                    Phone No :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="phoneNoTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                                </td>
                                <td class="TDRight" width="20%">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                               <td class="TDRight" width="20%">
                                    Medical Information :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="medicalTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                                </td>
                                <td class="TDRight" width="20%">
                                    Email : </td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="emailTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                                </td>
                                <td class="TDRight" width="20%">
                                    &nbsp;</td>
                            </tr>
                                
                            <tr>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                               <td class="TDRight" width="20%">
                                    Referance Name :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="referanceNameTextBox" runat="server" CssClass="TextBox" 
                                        AutoPostBack="True" ontextchanged="referanceNameTextBox_TextChanged"></asp:TextBox>
                                </td>
                                <td class="TDRight" width="20%">
                                    Refrance Cell No :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="refranceCellNoTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                                </td>
                                <td class="TDRight" width="20%">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td class="TDLeft" width="13%">
                                    &nbsp;</td>
                               <td class="TDRight" width="20%">
                                    Referance Address :</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="refranceAddressTextBox" runat="server" CssClass="TextBox" 
                                        TextMode="MultiLine"></asp:TextBox>
                                </td>
                                <td class="TDRight" width="20%">
                                    &nbsp;Joining Date</td>
                                <td class="TDLeft" width="13%">
                                    <asp:TextBox ID="joiningDateTextBox" runat="server" CssClass="datepick"></asp:TextBox>
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
                                    <asp:Button ID="submitButton" runat="server" onclick="submitButton_Click" 
                                        Text="Submit" />
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
                 </div>
               </div>
            
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>

