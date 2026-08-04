using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.PanalCls;

public partial class MasterPages_MainMasterPage : System.Web.UI.MasterPage
{
    private PanalClsDAL aDal = new PanalClsDAL();
    private DataTable aDataTableMenu = new DataTable();
    private DataTable aDataTableSubItem = new DataTable();
    private DataTable aTableSubSubItem = new DataTable();
    private DataTable aTableSubSubChildItem = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null ||  Session["UserId"].ToString() == "")
        {
            Response.Redirect("../Login.aspx");
        }
        if (!IsPostBack)
        {
            Menu();
            UserNameTime();
        }
    }

    public void UserNameTime()
    {
        Label1.Text = Session["LoginName"].ToString();
        Label2.Text = Session["UserTime"].ToString();
    }
    private void Menu()
    {
        string clM = "menu";
        string page = @"#";
        string parent = "halflings white home";
        string item = @"Product Info";
        string responsive = @"responsive";
        string clMainMenu = @"halflings white home";
        string navigation = @"navigation";
        string leftC = @"left-corner";
        string rightC = @"right-corner";


        aDataTableMenu = Convert.ToInt32(Session["UserId"])==1 ? aDal.MainMenu() : aDal.MainMenu(Convert.ToInt32(Session["UserId"]));
        

        if (aDataTableMenu.Rows.Count > 0)
        {
            ///////////////////////////////Start//////////////////////////////////////////////////////

            string manurHtml = "";

          manurHtml=@"<nav id="+navigation+" >";
          manurHtml = manurHtml + @"<div class=" + leftC + "></div><div class=" + rightC +"></div>";
            
            
            

            manurHtml = manurHtml + @"<ul class=" + clM + " id=" + responsive + ">";

            for (int i = 0; i < aDataTableMenu.Rows.Count; i++)
            {
                //////////////////////////////////////////////////MainMenuBind/////////////////////////////////////////////////////////



                manurHtml = manurHtml + @" <li><a href=" + aDataTableMenu.Rows[i]["URL"].ToString().Trim() + "><i class=" + parent + "></i>" +
                            aDataTableMenu.Rows[i]["ManuName"].ToString().Trim() + " </a>";





                aDataTableSubItem = Convert.ToInt32(Session["UserId"])==1 ? aDal.SubItem(aDataTableMenu.Rows[i]["SL"].ToString().Trim()) : aDal.SubItem(aDataTableMenu.Rows[i]["SL"].ToString().Trim(),Convert.ToInt32(Session["UserId"]));


                //aDataTableSubItem = aDal.SubItem(aDataTableMenu.Rows[i]["SL"].ToString().Trim());




                if (aDataTableSubItem.Rows.Count > 0)
                {
                    manurHtml = manurHtml + @"<div><ul>";

                    for (int j = 0; j < aDataTableSubItem.Rows.Count; j++)
                    {

                        //////////////////////////////////////////////////SubItemBind/////////////////////////////////////////////////////////


                        manurHtml = manurHtml + @" <li><a href=" + aDataTableSubItem.Rows[j]["URL"].ToString().Trim() + ">" + aDataTableSubItem.Rows[j]["ManuName"].ToString().Trim() + "</a>";
                        
                        
                        
                        //aTableSubSubItem = aDal.SubSubItem(aDataTableSubItem.Rows[j]["SL"].ToString().Trim());

                        aTableSubSubItem = Convert.ToInt32(Session["UserId"]) == 1 ? aDal.SubSubItem(aDataTableSubItem.Rows[j]["SL"].ToString().Trim()) : aDal.SubSubItem(aDataTableSubItem.Rows[j]["SL"].ToString().Trim(), Convert.ToInt32(Session["UserId"]));
                        
                        
                        if (aTableSubSubItem.Rows.Count > 0)
                        {
                            manurHtml = manurHtml + @"<div><ul>";
                            for (int k = 0; k < aTableSubSubItem.Rows.Count; k++)
                            {
                                //////////////////////////////////////////////////SubSubItemBind/////////////////////////////////////////////////////////


                                manurHtml = manurHtml + @"<li><a href=" + aTableSubSubItem.Rows[k]["URL"].ToString().Trim() +
                                            ">" + aTableSubSubItem.Rows[k]["ManuName"].ToString().Trim() + "</a>";




                                //aTableSubSubChildItem = aDal.SubSubChildItem(aTableSubSubItem.Rows[k]["SL"].ToString().Trim());

                                aTableSubSubChildItem = Convert.ToInt32(Session["UserId"]) == 1 ? aDal.SubSubChildItem(aTableSubSubItem.Rows[k]["SL"].ToString().Trim()) : aDal.SubSubChildItem(aTableSubSubItem.Rows[k]["SL"].ToString().Trim(), Convert.ToInt32(Session["UserId"]));


                                if (aTableSubSubChildItem.Rows.Count > 0)
                                {
                                    manurHtml = manurHtml + @"<div><ul>";
                                    for (int l = 0; l < aTableSubSubChildItem.Rows.Count; l++)
                                    {
                                        //////////////////////////////////////////////////SubSubChildItemBind/////////////////////////////////////////////////////////

                                        manurHtml = manurHtml + @"<li><a href=" +
                                                    aTableSubSubChildItem.Rows[l]["URL"].ToString().Trim() + ">" +
                                                    aTableSubSubChildItem.Rows[l]["ManuName"].ToString().Trim() +
                                                    "</a></li>";

                                        //////////////////////////////////////////////////SubSubChildItemBindEnd/////////////////////////////////////////////////////////
                                    }


                                    manurHtml = manurHtml + @"</ul></div>";

                                }








                                //////////////////////////////////////////////////SubSubItemBind/////////////////////////////////////////////////////////
                                manurHtml = manurHtml + @"</li>";
                            }

                            manurHtml = manurHtml + @"</ul></div>";
                        }



                        //////////////////////////////////////////////////SubItemBindEnd/////////////////////////////////////////////////////////
                        manurHtml = manurHtml + @"</li>";
                    }

                    manurHtml = manurHtml + @"</ul></div>";



                }


                manurHtml = manurHtml + @"</li>";

                //////////////////////////////////////////////////MainMenuBindEnd/////////////////////////////////////////////////////////
            }






            manurHtml = manurHtml + @"</ul></nav>";

            //////////////////////////////////////////end////////////////////////////////////////
            menu.InnerHtml = manurHtml;
        }


    }
    //protected void logOutLinkButton_Click(object sender, EventArgs e)
    //{
    //    Session["UserId"] = null;
    //    Session["LoginName"] = null;
    //    Session["UserType"] = null;
    //    Session.Abandon();
    //    Response.Redirect("../Login.aspx");
    //}
    protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
    {
        Session["UserId"] = null;
        Session["LoginName"] = null;
        Session["UserType"] = null;
        Session["ComUnitId"] = null;
        Session.Abandon();
        Response.Redirect("../Login.aspx");
    }
}

