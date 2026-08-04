using System; 
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using Library.DAL.DataManager;
using Library.DAO.MasterSetup_DAO;

namespace Library.DAL.ChartDAL
{
    public class ChartDAL
    {

        private DataAccessManager  accessManager = new DataAccessManager ();

        public TotalInfoDAO GetTotalInfoByCurrentDateDAL(int id)
        {
             
                string  RoleTypeName ="";
            string EmpInfoId = "";
            string ToRoleTypeId = "";
            try
            {
                RoleTypeName = HttpContext.Current.Session["RoleTypeName"].ToString();
                  EmpInfoId = HttpContext.Current.Session["EmpInfoId"].ToString();
                  ToRoleTypeId = HttpContext.Current.Session["RoleTypeId"].ToString();
            }
            catch
            {

            }
           
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                TotalInfoDAO master = new TotalInfoDAO();
            DataTable dr = new DataTable();
                if(RoleTypeName== "DZSM")
                {
                    List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                    aSqlParameterlist.Add(new SqlParameter("@EmployeeId", EmpInfoId));
                    aSqlParameterlist.Add(new SqlParameter("@RoleId", ToRoleTypeId));

                    DataTable dtMarket = accessManager.GetDataTable("sp_HigharchyInfoByEmployeeId", aSqlParameterlist);
                    string areaId = "", masArea = "";
                    for (int i = 0; i < dtMarket.Rows.Count; i++)
                    {
                        areaId = areaId + dtMarket.Rows[i]["RegionId"].ToString() + ',';
                    }
                    masArea = areaId.TrimEnd(',');

                    List<SqlParameter> aSql  = new List<SqlParameter>();
                    aSql.Add(new SqlParameter("@ZoneId", masArea));

                    dr = accessManager.GetDataTable("sp_Get_DashboardTopBarData_Zone", aSql);

                }
              else  if(RoleTypeName== "NSM")
                {
                    List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                    aSqlParameterlist.Add(new SqlParameter("@EmployeeId", EmpInfoId));
                    aSqlParameterlist.Add(new SqlParameter("@RoleId", ToRoleTypeId));

                    DataTable dtMarket = accessManager.GetDataTable("sp_HigharchyInfoByEmployeeId", aSqlParameterlist);
                    string areaId = "", masArea = "";
                    for (int i = 0; i < dtMarket.Rows.Count; i++)
                    {
                        areaId = areaId + dtMarket.Rows[i]["GroupId"].ToString() + ',';
                    }
                    masArea = areaId.TrimEnd(',');

                    List<SqlParameter> aSql  = new List<SqlParameter>();
                    aSql.Add(new SqlParameter("@GroupId", masArea));

                    dr = accessManager.GetDataTable("sp_Get_DashboardTopBarData_NSM", aSql);

                }
                else
                {
                    dr = accessManager.GetDataTable("sp_Get_DashboardTopBarData");

                }


                if (dr.Rows.Count>0)
                {
                    
                    master.TotalOrder =  (dr.Rows[0]["TotalOrder"].ToString());
                    master.totalInvoice = (dr.Rows[0]["totalInvoice"].ToString());
                    master.totalDelivery = (dr.Rows[0]["totalDelivery"].ToString());
                    master.totalPayment = (dr.Rows[0]["totalPayment"].ToString());
                    master.TotalRejection = (dr.Rows[0]["TotalRejection"].ToString());
                    master.TotalOrderPer = (dr.Rows[0]["TotalOrderPer"].ToString());
                    master.TotalInvoicerPer = (dr.Rows[0]["TotalInvoicerPer"].ToString());

                    master.TotalDcr = (dr.Rows[0]["TotalDcr"].ToString());
                    master.TotalRX = (dr.Rows[0]["TotalRX"].ToString());

                    master.TotalDcrType = (dr.Rows[0]["TotalDcrType"].ToString());
                    master.TotalRXType = (dr.Rows[0]["TotalRXType"].ToString());

                    master.TotalAttandence = (dr.Rows[0]["TotalAttandence"].ToString());
                    master.totalCustomerCoverage = (dr.Rows[0]["totalCustomerCoverage"].ToString());
                    master.TotalLeave = (dr.Rows[0]["TotalLeave"].ToString());


                }
                return master;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

        }
        public DataTable GetPerMonthAmount(string fromdt, string todt, string param, string Type, string CustomerTypeId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Month",  (fromdt)));
                aSqlParameterlist.Add(new SqlParameter("@Year", (todt) ));
                aSqlParameterlist.Add(new SqlParameter("@param", param));
                aSqlParameterlist.Add(new SqlParameter("@CustomerTypeId", CustomerTypeId));
                DataTable dt = new DataTable();
                if (Type == "Invoice")
                {
                    dt = accessManager.GetDataTable("sp_Get_SalesRecordMonthlyDayWsie_New", aSqlParameterlist);
                }

                if (Type == "Payment")
                {
                    dt = accessManager.GetDataTable("sp_Get_SalesRecordMonthlyDayWsiePayment", aSqlParameterlist);

                }


                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable GetBrandWiseOrderReportDAL(string fromdt, string todt, string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@FrmDate", Convert.ToDateTime(fromdt)));
                aSqlParameterlist.Add(new SqlParameter("@ToDate", Convert.ToDateTime(todt)));
                aSqlParameterlist.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_BrandWiseOrderDashboard_new", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable GetBrandWiseOrderReportDayWiseDAL(string fromdt, string todt, string param, string Brand)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@FrmDate", fromdt));
                aSqlParameterlist.Add(new SqlParameter("@ToDate", Convert.ToDateTime(todt)));
                aSqlParameterlist.Add(new SqlParameter("@param", param));
            
                DataTable dt = new DataTable();



                if (fromdt == "Invoice")
                {
                    if (Brand == "DayWise")
                    {
                        dt = accessManager.GetDataTable("sp_Get_BrandWiseOrderDashboard_new", aSqlParameterlist);
                    }

                    if (Brand == "BrandWise")
                    {
                        dt = accessManager.GetDataTable("sp_Get_BrandWiseOrderDashboard", aSqlParameterlist);
                    }

                    if (Brand == "ProductWise")
                    {
                        dt = accessManager.GetDataTable("sp_Get_ProductWiseOrderDashboard", aSqlParameterlist);
                    }
                }

                if (fromdt == "Payment")
                {
                    if (Brand == "DayWise")
                    {
                        dt = accessManager.GetDataTable("sp_Get_PaymentBrandWiseOrderDashboard", aSqlParameterlist);
                    }
                    if (Brand == "BrandWise")
                    {
                        dt = accessManager.GetDataTable("sp_Get_BrandWiseOrderPaymentDashboard", aSqlParameterlist);

                    }

                    if (Brand == "ProductWise")
                    {
                        dt = accessManager.GetDataTable("sp_Get_ProductWiseOrderPaymentDashboard", aSqlParameterlist);
                    }
                }
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable GetAttandenceMonthlyReportDAL(string month, string year, string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Month", month));
                aSqlParameterlist.Add(new SqlParameter("@Year", year));
                aSqlParameterlist.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_AttandenceMonthlyDashboard_new", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable GetSalesRetrunChartData(int month, int year, string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Month", month));
                aSqlParameterlist.Add(new SqlParameter("@Year", year));
                aSqlParameterlist.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_SalesReturnRecordMonthly_New", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable GetOrderChartDataDAL(string Month, string Year, string param, string Type)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Month",  (Month)));
                aSqlParameterlist.Add(new SqlParameter("@Year",  (Year))); 
                aSqlParameterlist.Add(new SqlParameter("@param", param));
                DataTable dt = new DataTable();
                if (Type== "Zone")
                { 
                  dt = accessManager.GetDataTable("sp_Get_OrderRecordMonthlyDashboard_New", aSqlParameterlist);

                }

                if (Type == "Depot")
                {
                    dt = accessManager.GetDataTable("sp_Get_OrderRecordMonthlyDashboard_Depo", aSqlParameterlist);

                }
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

       
        public DataTable GetCustomerReportChartDataDAL(string Month, string Year, string param, string CustomerTypeId, string Type )
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Month", (Month)));
                aSqlParameterlist.Add(new SqlParameter("@Year", (Year)));
                aSqlParameterlist.Add(new SqlParameter("@param", param));
                aSqlParameterlist.Add(new SqlParameter("@CustomerTypeId", CustomerTypeId));


              
                DataTable dt = new DataTable();
                if (Type == "Invoice")
                {
                    dt = accessManager.GetDataTable("sp_Get_CustomerCoverageRecordMonthlyDashboard_New", aSqlParameterlist);
                }

                if (Type == "Payment")
                {
                    dt = accessManager.GetDataTable("sp_Get_CustomerCoverageRecordPaymentDashboard_New", aSqlParameterlist);

                }

       return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable GetGMPVisitReportChartDataDAL(string fromdt, string todt, string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@FrmDate", Convert.ToDateTime(fromdt)));
                aSqlParameterlist.Add(new SqlParameter("@ToDate", Convert.ToDateTime(todt)));
                aSqlParameterlist.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorGMPRecordMonthlyDashboard_New", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable GetGMPVisitReportChartDataDayWiseDAL(string fromdt, string todt, string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@FrmDate", (fromdt)));
                aSqlParameterlist.Add(new SqlParameter("@ToDate",  (todt)));
                aSqlParameterlist.Add(new SqlParameter("@param", param));
            

                DataTable dt = new DataTable();
                if (fromdt == "Day")
                {
                    dt = accessManager.GetDataTable("sp_Get_DoctorGMPRecordMonthlyDashboardDayWise", aSqlParameterlist);
                }

                if (fromdt == "Zone")
                {
                    dt = accessManager.GetDataTable("sp_Get_DoctorGMPRecordMonthlyDashboardZoneWise", aSqlParameterlist);

                }
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable GetNONGMPVisitReportChartDataDAL(int month, int year)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Month", month));
                aSqlParameterlist.Add(new SqlParameter("@Year", year));
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorNGMPRecordMonthlyDashboard", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public DataTable GetGMPRXReportChartDataDAL(string fromdt, string todt, string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@FrmDate", Convert.ToDateTime(fromdt)));
                aSqlParameterlist.Add(new SqlParameter("@ToDate", Convert.ToDateTime(todt)));
                aSqlParameterlist.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorGMPxRecordMonthlyDashboard_new", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable GetGMPRXReportChartDataDayWiseDAL(string fromdt, string todt, string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@FrmDate", (fromdt)));
                aSqlParameterlist.Add(new SqlParameter("@ToDate", (todt)));
                aSqlParameterlist.Add(new SqlParameter("@param", param));
                DataTable dt = new DataTable();
                if (fromdt == "Day")
                {
                    dt = accessManager.GetDataTable("sp_Get_DoctorGMPxRecordMonthlyDashboardDayWise", aSqlParameterlist);

                }

                if (fromdt == "Zone")
                {
                    dt = accessManager.GetDataTable("sp_Get_DoctorGMPxRecordMonthlyDashboardZoneWise", aSqlParameterlist);

                }
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public DataTable GetNONGMPRXReportChartDataDAL(int month, int year)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Month", month));
                aSqlParameterlist.Add(new SqlParameter("@Year", year));
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorNGMPxRecordMonthlyDashboard", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable GetExpanseClaimMonthlyChartDataDAL(string month, string year, string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Month", month));
                aSqlParameterlist.Add(new SqlParameter("@Year", year));
                aSqlParameterlist.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_ExpanseClaimMonthlyDashboard", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable GetExpanseClaimMonthlyChartDataDayWiseDAL(string month, string year, string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Month", month));
                aSqlParameterlist.Add(new SqlParameter("@Year", year));
                aSqlParameterlist.Add(new SqlParameter("@param", param));
                DataTable dt = new DataTable();
                if (month == "Expense") {
                    dt = accessManager.GetDataTable("sp_Get_ExpanseClaimMonthlyDashboard_DayWise", aSqlParameterlist);
                }

                if (month == "DA")
                {
                    dt = accessManager.GetDataTable("sp_Get_DAMonthlyDashboard_DayWise", aSqlParameterlist);
                }

                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable GetDeptoWiseOrderDAL(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                DataTable dt = new DataTable();
                if (param == "Depot")
                {
                    dt = accessManager.GetDataTable("sp_Get_DashboardOrder_DeptoWise");

                }
                else
                {
                    dt = accessManager.GetDataTable("sp_Get_DashboardDeptoWiseOrder");

                }
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public DataTable Get_DeptoWiseInvoiceDAL(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                  

                DataTable dt = new DataTable();
                if (param == "Depot")
                {
                    dt = accessManager.GetDataTable("sp_Get_DashboardInvoice_DeptoWise");

                }
                else
                {
                    dt = accessManager.GetDataTable("sp_Get_DashboardDeptoWiseInvoice");

                }
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public DataTable Get_TopBarChartOrderDAL()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = accessManager.GetDataTable("sp_Get_DashboardTopBarChartOrder");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public DataTable Get_TopBarChartDeliveryAmountDAL()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = accessManager.GetDataTable("sp_Get_DashboardTopBarChartDeliveryAmount");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public DataTable Get_TopBarChartRejectionAmountDAL()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = accessManager.GetDataTable("sp_Get_DashboardTopBarChartRejectionAmount");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public DataTable Get_TopBarChartDCRDAL()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = accessManager.GetDataTable("sp_Get_DashboardTopBarChartTotalDCR");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable Get_TopBarChartTotalRXDAL()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = accessManager.GetDataTable("sp_Get_DashboardTopBarChartTotalRX");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public DataTable Get_TopBarChartTotalAttandenceDAL()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = accessManager.GetDataTable("sp_Get_DashboardTopBarChartTotalAttandence");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable Get_TopBarChartCustomerCoverageDAL()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = accessManager.GetDataTable("sp_Get_DashboardTopBarChartCustomerCoverage");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable Get_TopBarChartTotalLeaveDAL()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = accessManager.GetDataTable("sp_Get_DashboardTopBarChartTotalLeave");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }




        public DataTable  Get_TopBarChartOrderCountDAL()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = accessManager.GetDataTable("sp_Get_DashboardTopBarChartOrderCount");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public DataTable Get_TopBarChartTotalInvoiceDAL()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = accessManager.GetDataTable("sp_Get_DashboardTopBarChartTotalInvoiceAmount");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable GetOrderPerMonthAmount(int month, int year)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Month", month));
                aSqlParameterlist.Add(new SqlParameter("@Year", year));
                DataTable dt = accessManager.GetDataTable("sp_Get_OrderRecordMonthly", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
    }
}
