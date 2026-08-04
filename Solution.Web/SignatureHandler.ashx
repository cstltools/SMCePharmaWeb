<%@ WebHandler Language="C#"  Class="SignatureHandler" %>

    using System.Web;

public class SignatureHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            //Checking whether the imagebytes variable have anything else not doin anything
            if ((context.Session["ImageBytes"]) != null)
            {
                byte[] image = (byte[]) (context.Session["SigImageBytes"]);
                context.Response.ContentType = "image/JPEG";
                context.Response.BinaryWrite(image);
            }
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }

