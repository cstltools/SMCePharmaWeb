using Library.DAL.DataManager;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace Library.DAL.DoctorModule_DAL
{
    public class FinancialYearDeleteTableDAL
    {
        private readonly DataAccessManager accessManager = new DataAccessManager();

        public ResultInfo DeleteArchiveDBOrderData(string databaseName, DateTime startDate, DateTime endDate)
        {
            return ExecuteDeleteArch("sp_DeleteArchiveDBOrderData", DataBase.SalesDB, databaseName, startDate, endDate);
        }

        public ResultInfo DeleteArchiveDBInvoiceData(string databaseName, DateTime startDate, DateTime endDate)
        {
            return ExecuteDeleteArch("sp_DeleteArchiveDBInvoiceData", DataBase.SalesDB, databaseName, startDate, endDate);
        }

        public ResultInfo DeleteArchiveDBRxData(string databaseName, DateTime startDate, DateTime endDate)
        {
            return ExecuteDeleteArch("sp_DeleteArchiveDBRxData", DataBase.SalesDB, databaseName, startDate, endDate);
        }

        public ResultInfo DeleteArchiveDBDCRData(string databaseName, DateTime startDate, DateTime endDate)
        {
            return ExecuteDeleteArch("sp_DeleteArchiveDBDCRData", DataBase.SalesDB, databaseName, startDate, endDate);
        }

        public ResultInfo DeleteArchiveDBTourPlanData(string databaseName, DateTime startDate, DateTime endDate)
        {
            return ExecuteDeleteArch("sp_DeleteArchiveDBTourPlanData", DataBase.SalesDB, databaseName, startDate, endDate);
        }

        public ResultInfo DeleteArchiveDBAttendanceData(string databaseName, DateTime startDate, DateTime endDate)
        {
            return ExecuteDeleteArch("sp_DeleteArchiveDBAttendanceData", DataBase.SalesDB, databaseName, startDate, endDate);
        }

        public ResultInfo DeleteArchiveDBExpenseData(string databaseName, DateTime startDate, DateTime endDate)
        {
            return ExecuteDeleteArch("sp_DeleteArchiveDBExpenseData", DataBase.SalesDB, databaseName, startDate, endDate);
        }

        public ResultInfo DeleteArchiveOrderData(string databaseName, DateTime startDate, DateTime endDate)
        {
            return ExecuteDelete("sp_DeleteArchiveOrderData", DataBase.SalesDB, startDate, endDate);
        }

        public ResultInfo DeleteArchiveInvoiceData(string databaseName, DateTime startDate, DateTime endDate)
        {
            return ExecuteDelete("sp_DeleteArchiveInvoiceData", DataBase.SalesDB, startDate, endDate);
        }

        public ResultInfo DeleteArchiveRxData(string databaseName, DateTime startDate, DateTime endDate)
        {
            return ExecuteDelete("sp_DeleteArchiveRxData", DataBase.SalesDB, startDate, endDate);
        }

        public ResultInfo DeleteArchiveDCRData(string databaseName, DateTime startDate, DateTime endDate)
        {
            return ExecuteDelete("sp_DeleteArchiveDCRData", DataBase.SalesDB, startDate, endDate);
        }

        public ResultInfo DeleteArchiveAttendanceData(string databaseName, DateTime startDate, DateTime endDate)
        {
            return ExecuteDelete("sp_DeleteArchiveAttendanceData", DataBase.SalesDB, startDate, endDate);
        }

        public ResultInfo DeleteArchiveTourPlanData(string databaseName, DateTime startDate, DateTime endDate)
        {
            return ExecuteDelete("sp_DeleteArchiveTourPlanData", DataBase.SalesDB, startDate, endDate);
        }

        public ResultInfo DeleteArchiveExpenseData(string databaseName, DateTime startDate, DateTime endDate)
        {
            return ExecuteDelete("sp_DeleteArchiveExpenseData", DataBase.SalesDB, startDate, endDate);
        }

        private ResultInfo ExecuteDelete(string storeProcedure, string databaseName, DateTime startDate, DateTime endDate)
        {
            ResultInfo information = new ResultInfo();

            try
            {
                string targetDatabase = ResolveDatabaseName(databaseName);
                accessManager.SqlConnectionOpen(targetDatabase);

                List<SqlParameter> sqlParameters = new List<SqlParameter>();
                sqlParameters.Add(new SqlParameter("@FromDate", startDate.Date));
                sqlParameters.Add(new SqlParameter("@ToDate", endDate.Date));

                information.isSuccess = accessManager.UpdateData(storeProcedure, sqlParameters, false, targetDatabase);
            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                information.isSuccess = false;
                information.ErrorMessage = exception.Message;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return information;
        }

        private ResultInfo ExecuteDeleteArch(string storeProcedure, string sourceDatabaseName, string databaseName, DateTime startDate, DateTime endDate)
        {
            ResultInfo information = new ResultInfo();

            try
            {
                accessManager.SqlConnectionOpen(sourceDatabaseName);

                List<SqlParameter> sqlParameters = new List<SqlParameter>();
                sqlParameters.Add(new SqlParameter("@DatabaseName", ResolveDatabaseName(databaseName)));
                sqlParameters.Add(new SqlParameter("@FromDate", startDate.Date));
                sqlParameters.Add(new SqlParameter("@ToDate", endDate.Date));

                information.isSuccess = accessManager.UpdateData(storeProcedure, sqlParameters, false, sourceDatabaseName);
            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                information.isSuccess = false;
                information.ErrorMessage = exception.Message;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return information;
        }

        private string ResolveDatabaseName(string databaseName)
        {
            return string.IsNullOrWhiteSpace(databaseName) ? DataBase.SalesDB : databaseName.Trim();
        }
    }
}
