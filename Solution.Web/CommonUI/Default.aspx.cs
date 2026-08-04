using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CommonUI_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Sample();
            DropDown();
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {

    }

    private void Sample()
    {

        DataTable table = new DataTable();
        table.Columns.Add("Dosage", typeof(int));
        table.Columns.Add("Drug", typeof(string));
        table.Columns.Add("Patient", typeof(string));
        table.Columns.Add("Date", typeof(DateTime));

        table.Rows.Add(25, "Indocin", "David", DateTime.Now);
        table.Rows.Add(50, "Enebrel", "Sam", DateTime.Now);
        table.Rows.Add(10, "Hydralazine", "Christoff", DateTime.Now);
        table.Rows.Add(21, "Combivent", "Janet", DateTime.Now);
        table.Rows.Add(100, "Dilantin", "Melanie", DateTime.Now);

        sampleGridView.DataSource = table;
        sampleGridView.DataBind();
    }
    private void DropDown()
    {
        DropDownList1.Items.Add("");
        DropDownList1.Items.Add("Software Engineer");
        DropDownList1.Items.Add("Programmer");
        DropDownList1.Items.Add("Group Leader");
    }
}