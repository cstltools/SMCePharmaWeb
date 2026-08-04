using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;

public partial class SInventory_RPTVIEW_AuditReportOneReportViewer : System.Web.UI.Page
{

    ExpenseDal aExpenseDal = new ExpenseDal();
    ReportDocument rptdoc = new ReportDocument();

    protected void Page_Init(object sender, EventArgs e)
    {
        string fType = (Request.QueryString["fType"]);
        string EmpId = (Request.QueryString["rptType"]);
        string Month = (Request.QueryString["Month"]);
        string Year = (Request.QueryString["Year"]);
   


        DataSet Ds = new DataSet();

        DataTable dtExpense = new DataTable();
        string empName = EmpId.Trim();

        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("MainDate_");
        aDataTable.Columns.Add("EmpInfoId");
        aDataTable.Columns.Add("EmpMasterCode");
        aDataTable.Columns.Add("EmpName");
        aDataTable.Columns.Add("DesigName");
        aDataTable.Columns.Add("BaseHQ");
        aDataTable.Columns.Add("MarketCode");
        aDataTable.Columns.Add("ZoneCode");
        aDataTable.Columns.Add("MonthYear");
        aDataTable.Columns.Add("DAdate");
        aDataTable.Columns.Add("MarketName");

        aDataTable.Columns.Add("TourType");
        aDataTable.Columns.Add("daAmount", typeof(int));
        aDataTable.Columns.Add("AllowedMileageInKM", typeof(decimal));

        aDataTable.Columns.Add("mileageAmount", typeof(decimal));
        aDataTable.Columns.Add("expenseAmount", typeof(decimal));
        aDataTable.Columns.Add("totalAmount", typeof(decimal));

        if (empName != "")
        {
            try
            {
                if (empName.Contains(','))
                {
                    string[] emp = empName.Split(',');

                    for (int i = 0; i < emp.Length; i++)
                    {
                        
                          dtExpense = aExpenseDal.GetExpenseMasterById(Month, Year, emp[i]).Copy();


                      
               



                        DataRow dataRow = null;

                        for (int kk = 0; kk < dtExpense.Rows.Count; kk++)
                        {
 
                                


                                    dataRow = aDataTable.NewRow();

                                    dataRow["MainDate_"] = dtExpense.Rows[kk]["MainDate_"].ToString();

                                    dataRow["EmpInfoId"] = dtExpense.Rows[kk]["EmpInfoId"].ToString();
                                    dataRow["EmpName"] = dtExpense.Rows[kk]["EmpName"].ToString();
                                dataRow["EmpMasterCode"] = dtExpense.Rows[kk]["EmpMasterCode"].ToString();
                                dataRow["EmpName"] = dtExpense.Rows[kk]["EmpName"].ToString();
                                dataRow["DesigName"] = dtExpense.Rows[kk]["DesigName"].ToString();
                                dataRow["BaseHQ"] = dtExpense.Rows[kk]["BaseHQ"].ToString();
                                dataRow["MarketCode"] = dtExpense.Rows[kk]["MarketCode"].ToString();
                                dataRow["ZoneCode"] = dtExpense.Rows[kk]["ZoneCode"].ToString();
                                dataRow["MonthYear"] = dtExpense.Rows[kk]["MonthYear"].ToString();
                                dataRow["DAdate"] = dtExpense.Rows[kk]["DAdate"].ToString();
                                    dataRow["MarketName"] = dtExpense.Rows[kk]["MarketName"].ToString();
                                dataRow["TourType"] = dtExpense.Rows[kk]["TourType"].ToString();
                                dataRow["daAmount"] = Convert.ToInt32(dtExpense.Rows[kk]["daAmount"].ToString());
                                    dataRow["AllowedMileageInKM"] = Convert.ToDecimal(dtExpense.Rows[kk]["AllowedMileageInKM"].ToString());
                                dataRow["mileageAmount"] = Convert.ToDecimal(dtExpense.Rows[kk]["mileageAmount"].ToString());
                                dataRow["expenseAmount"] = Convert.ToDecimal(dtExpense.Rows[kk]["expenseAmount"].ToString());
                                dataRow["totalAmount"] = Convert.ToDecimal(dtExpense.Rows[kk]["totalAmount"].ToString());




                                aDataTable.Rows.Add(dataRow);
                                
                             
                        }
                        
                    }


                    dtExpense= aDataTable;
                }
                else
                {
                      dtExpense = aExpenseDal.GetExpenseMasterById(Month, Year, empName).Copy();
                }

            }
            catch
            {

            }

            }

        //            DataTable dtExpense = aExpenseDal.GetExpenseMasterById( Month,  Year,  EmpId).Copy();

        dtExpense.TableName = "dtExpense";
        Ds.Tables.Add(dtExpense);


        DataTable dtTotal = aExpenseDal.GetExpenseMasterTotalById(Month, Year, EmpId).Copy();

        dtTotal.TableName = "dtTotal";
        Ds.Tables.Add(dtTotal);


        DataTable dtAllowance = aExpenseDal.Get_EmpAllawance(EmpId, Month, Year).Copy();

        dtAllowance.TableName = "dtAllowance";
        Ds.Tables.Add(dtAllowance);

        DataTable dtStationType = aExpenseDal.GetGet_TourPlanBalanceMasterById(Month, Year, EmpId).Copy();

        dtStationType.TableName = "dtStationType";
        Ds.Tables.Add(dtStationType);


        rptdoc.Load(ReportPath("crpEmpExpense.rpt"));
        rptdoc.SetDataSource(Ds);
        if (fType == "Crys")
        {
            crvSalesRpt.ReportSource = rptdoc;
            crvSalesRpt.DataBind();
        }
        else
        {
           
           // rptdoc.PrintToPrinter(1, false, 0, 0);
            rptdoc.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
           "Monthly Expense Claim");
        }

       

    }
    private string ReportPath(string rptName)
    {
        return Convert.ToString(Server.MapPath("~\\Reports\\CrystalReports\\" + rptName));
    }
    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
    
    protected void crvCustMasterRpt_Unload(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvSalesRpt.Dispose();
        }
    }
    protected void crvCustMasterRpt_Disposed(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvSalesRpt.Dispose();
        }
    }
}