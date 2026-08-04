<%@ Application Language="C#" %>
<%@ Import Namespace="System.Web.Routing" %>

<script runat="server">
    void Application_Start(object sender, EventArgs e)
    {
        RegisterRoutes(RouteTable.Routes);
    }

    private static void RegisterRoutes(RouteCollection routes)
    {
        routes.MapPageRoute(
            "UserRecords",
            "user-records",
            "~/DoctorModule_UI/UserRecords.aspx");
    }
</script>
