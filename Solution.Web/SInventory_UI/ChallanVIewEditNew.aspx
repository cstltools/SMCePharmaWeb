<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChallanVIewEditNew.aspx.cs" Inherits="SInventory_UI_ChallanVIewEditNew" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>Edit</title>
    <link href="../css/custom.css" rel="stylesheet" type="text/css" />
     <link rel="stylesheet" href="../css/style.css" type="text/css">
    <link rel="stylesheet" href="../css/colors/blue.css" id="colors" type="text/css">
</head>
<body>
    <form id="form1" runat="server">
   
            <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
      <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                           Challan Edit</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                            <asp:HiddenField ID="salesCenterInfoIdHiddenField" runat="server" />


                    </td>
                        <td class="TDRight" width="20%">
                            
                               
                        </td>
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                         <asp:Label ID="MessageLabel" runat="server" ForeColor="Black"></asp:Label>    
                        </td>
                        <td class="TDLeft" width="13%">
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
                            Challan Date</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="clnDateTextBox" runat="server" CssClass="TextBox" ></asp:TextBox>
                            
                               <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgDate2"></asp:ImageButton>
                            <asp:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="clnDateTextBox"
                                PopupButtonID="imgDate2">
                            </asp:CalendarExtender>

                           
                        </td>

  <td class="TDLeft" width="13%">
                           &nbsp;
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
                        </td>
                        <td class="TDRight" width="20%">
                         
                        </td>
                         <td class="TDLeft" width="13%">
                            Truck No</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="truckNoTextBox" runat="server"></asp:TextBox>
                        </td>


 
    <td class="TDLeft" width="13%">
                           &nbsp;
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
                        </td>
                        <td class="TDRight" width="20%">
                         
                        </td>
                        <td class="TDLeft" width="13%">
                            Driver No</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="driverNameTextBox" runat="server"></asp:TextBox>
                        </td>
                        
                            <td class="TDLeft" width="13%">
                           &nbsp;
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
                        </td>
                        <td class="TDRight" width="20%">
                         <asp:HiddenField ID="hdReqId" runat="server" />
                        </td>
                           <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                            
                            <br/>
                             <asp:Button ID="bmitButton" runat="server" onclick="bmitButton_Click" 
                                Text="Update"  OnClientClick="return confirm('Are you sure you want Update ?');" />
                            
                        </td>
                        <td class="TDLeft" width="13%">
                           &nbsp;
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

  

</ContentTemplate>
</asp:UpdatePanel>
    </form>
</body>
</html>
