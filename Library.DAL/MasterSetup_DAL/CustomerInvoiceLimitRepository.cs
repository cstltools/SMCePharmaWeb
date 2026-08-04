using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Library.DAL.DataManager;
using Library.DAL.InternalCls;
using Library.DAO.MasterSetup_DAO;
using SalesSolution.Web.DataLayer;

namespace Library.DAL.MasterSetup_DAL
{
    public class CustomerInvoiceLimitRepository
    {
        private DataAccessManager_daaw accessManager = new DataAccessManager_daaw();
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        private SeedDataDAL seedDataDal = new SeedDataDAL();

        public string Insert(CustomerInvoiceLimitModel model)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>
                {
                    new SqlParameter("@CustomerId", model.CustomerId),
                    new SqlParameter("@MaximumInvoiceValue", model.MaximumInvoiceValue),
                    new SqlParameter("@Remarks", (object)model.Remarks ?? DBNull.Value),
                    new SqlParameter("@IsActive", model.IsActive),
                    new SqlParameter("@CreatedBy", (object)model.CreatedBy ?? DBNull.Value)
                };

                bool status = accessManager.SaveData("sp_InsertCustomerInvoiceLimit", aSqlParameters);
                if (status)
                {
                    return "Success";
                }
                return "Failed to insert record.";
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 50000)
                {
                    return sqlEx.Message;
                }
                throw;
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public string Update(CustomerInvoiceLimitModel model)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>
                {
                    new SqlParameter("@Id", model.Id),
                    new SqlParameter("@MaximumInvoiceValue", model.MaximumInvoiceValue),
                    new SqlParameter("@Remarks", (object)model.Remarks ?? DBNull.Value),
                    new SqlParameter("@IsActive", model.IsActive),
                    new SqlParameter("@UpdatedBy", (object)model.UpdatedBy ?? DBNull.Value)
                };

                bool status = accessManager.UpdateData("sp_UpdateCustomerInvoiceLimit", aSqlParameters);
                if (status)
                {
                    return "Success";
                }
                return "Failed to update record.";
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public string Delete(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>
                {
                    new SqlParameter("@Id", id)
                };

                bool status = accessManager.DeleteData("sp_DeleteCustomerInvoiceLimit", aSqlParameters);
                if (status)
                {
                    return "Success";
                }
                return "Failed to delete record.";
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public CustomerInvoiceLimitViewModel GetById(int id)
        {
            CustomerInvoiceLimitViewModel model = null;
            try
            {
                string query = "EXEC sp_GetCustomerInvoiceLimitById " + id;
                IDataReader reader = aCommonInternalDal.DataContainerDataReader(query, "SSIDB");
                
                if (reader != null)
                {
                    if (reader.Read())
                    {
                        model = new CustomerInvoiceLimitViewModel
                        {
                            Id = Convert.ToInt32(reader["Id"]),
                            CustomerId = Convert.ToInt32(reader["CustomerId"]),
                            CustomerCode = reader["CustomerCode"].ToString(),
                            CustomerName = reader["CustomerName"].ToString(),
                            MobileNo = reader["MobileNo"].ToString(),
                            MaximumInvoiceValue = Convert.ToDecimal(reader["MaximumInvoiceValue"]),
                            Remarks = reader["Remarks"] != DBNull.Value ? reader["Remarks"].ToString() : string.Empty,
                            IsActive = Convert.ToBoolean(reader["IsActive"])
                        };
                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return model;
        }

        public List<CustomerInvoiceLimitViewModel> GetList()
        {
            List<CustomerInvoiceLimitViewModel> list = new List<CustomerInvoiceLimitViewModel>();
            try
            {
                string query = "EXEC sp_GetCustomerInvoiceLimits";
                IDataReader reader = aCommonInternalDal.DataContainerDataReader(query, "SSIDB");

                if (reader != null)
                {
                    while (reader.Read())
                    {
                        var model = new CustomerInvoiceLimitViewModel
                        {
                            Id = Convert.ToInt32(reader["Id"]),
                            CustomerId = Convert.ToInt32(reader["CustomerId"]),
                            CustomerCode = reader["CustomerCode"].ToString(),
                            CustomerName = reader["CustomerName"].ToString(),
                            MobileNo = reader["MobileNo"].ToString(),
                            MaximumInvoiceValue = Convert.ToDecimal(reader["MaximumInvoiceValue"]),
                            Remarks = reader["Remarks"] != DBNull.Value ? reader["Remarks"].ToString() : string.Empty,
                            IsActive = Convert.ToBoolean(reader["IsActive"]),
                            CreatedBy = reader["CreatedBy"] != DBNull.Value ? reader["CreatedBy"].ToString() : string.Empty,
                            CreatedDate = reader["CreatedDate"] != DBNull.Value ? Convert.ToDateTime(reader["CreatedDate"]).ToString("dd-MMM-yyyy") : string.Empty
                        };
                        list.Add(model);
                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return list;
        }

        public List<CustomerAutoCompleteViewModel> GetCustomerAutoComplete(string keyword)
        {
            List<CustomerAutoCompleteViewModel> list = new List<CustomerAutoCompleteViewModel>();
            try
            {
                string query = "EXEC sp_GetCustomerAutoComplete '" + keyword.Replace("'", "''") + "'";
                IDataReader reader = aCommonInternalDal.DataContainerDataReader(query, "SSIDB");

                if (reader != null)
                {
                    while (reader.Read())
                    {
                        var model = new CustomerAutoCompleteViewModel
                        {
                            CustomerId = Convert.ToInt32(reader["CustomerId"]),
                            CustomerCode = reader["CustomerCode"].ToString(),
                            CustomerName = reader["CustomerName"].ToString(),
                            MobileNo = reader["MobileNo"].ToString()
                        };
                        list.Add(model);
                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return list;
        }

        public string InsertInvoiceNotBinding(InvoiceNotBindingModel model)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                bool isCustomerType = model.ApplyType == "CustomerType";
                List<SqlParameter> aSqlParameters = new List<SqlParameter>
                {
                    new SqlParameter("@ApplyType", (object)model.ApplyType ?? "Customer"),
                    new SqlParameter("@CustomerId", isCustomerType ? (object)DBNull.Value : model.CustomerId),
                    new SqlParameter("@CustomerCode", isCustomerType ? (object)DBNull.Value : ((object)model.CustomerCode ?? DBNull.Value)),
                    new SqlParameter("@CustomerTypeId", isCustomerType ? (object)model.CustomerTypeId : DBNull.Value),
                    new SqlParameter("@ActiveFromDate", model.ActiveFromDate),
                    new SqlParameter("@ActiveToDate", model.ActiveToDate.HasValue ? (object)model.ActiveToDate.Value : DBNull.Value),
                    new SqlParameter("@AllowedNoOfInvoice", model.AllowedNoOfInvoice),
                    new SqlParameter("@AllowedCreditLimit", model.AllowedCreditLimit),
                    new SqlParameter("@NumberOfDaysInTransit", model.NumberOfDaysInTransit),
                    new SqlParameter("@Remarks", (object)model.Remarks ?? DBNull.Value),
                    new SqlParameter("@IsActive", model.IsActive),
                    new SqlParameter("@CreatedBy", (object)model.CreatedBy ?? DBNull.Value)
                };

                bool status = accessManager.SaveData("sp_InsertInvoiceNotBinding", aSqlParameters);
                if (status)
                {
                    return "Success";
                }
                return "Failed to insert invoice not binding record.";
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 50000)
                {
                    return sqlEx.Message;
                }
                throw;
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public string UpdateInvoiceNotBinding(InvoiceNotBindingModel model)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>
                {
                    new SqlParameter("@InvoiceNotBindingId", model.InvoiceNotBindingId),
                    new SqlParameter("@ActiveFromDate", model.ActiveFromDate),
                    new SqlParameter("@ActiveToDate", model.ActiveToDate.HasValue ? (object)model.ActiveToDate.Value : DBNull.Value),
                    new SqlParameter("@AllowedNoOfInvoice", model.AllowedNoOfInvoice),
                    new SqlParameter("@AllowedCreditLimit", model.AllowedCreditLimit),
                    new SqlParameter("@NumberOfDaysInTransit", model.NumberOfDaysInTransit),
                    new SqlParameter("@Remarks", (object)model.Remarks ?? DBNull.Value),
                    new SqlParameter("@IsActive", model.IsActive),
                    new SqlParameter("@UpdatedBy", (object)model.UpdatedBy ?? DBNull.Value)
                };

                bool status = accessManager.UpdateData("sp_UpdateInvoiceNotBinding", aSqlParameters);
                if (status)
                {
                    return "Success";
                }
                return "Failed to update invoice not binding record.";
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public string DeleteInvoiceNotBinding(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>
                {
                    new SqlParameter("@InvoiceNotBindingId", id)
                };

                bool status = accessManager.DeleteData("sp_DeleteInvoiceNotBinding", aSqlParameters);
                if (status)
                {
                    return "Success";
                }
                return "Failed to delete record.";
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public InvoiceNotBindingViewModel GetInvoiceNotBindingById(int id)
        {
            InvoiceNotBindingViewModel model = null;
            try
            {
                string query = "EXEC sp_GetInvoiceNotBindingById " + id;
                IDataReader reader = aCommonInternalDal.DataContainerDataReader(query, "SSIDB");

                if (reader != null)
                {
                    if (reader.Read())
                    {
                        model = new InvoiceNotBindingViewModel
                        {
                            InvoiceNotBindingId = Convert.ToInt32(reader["InvoiceNotBindingId"]),
                            ApplyType = reader["ApplyType"] != DBNull.Value ? reader["ApplyType"].ToString() : "Customer",
                            CustomerId = reader["CustomerId"] != DBNull.Value ? Convert.ToInt32(reader["CustomerId"]) : 0,
                            CustomerCode = reader["CustomerCode"] != DBNull.Value ? reader["CustomerCode"].ToString() : string.Empty,
                            CustomerName = reader["CustomerName"] != DBNull.Value ? reader["CustomerName"].ToString() : string.Empty,
                            MobileNo = reader["MobileNo"] != DBNull.Value ? reader["MobileNo"].ToString() : string.Empty,
                            CustomerTypeId = reader["CustomerTypeId"] != DBNull.Value ? Convert.ToInt32(reader["CustomerTypeId"]) : 0,
                            CustomerTypeName = reader["CustomerTypeName"] != DBNull.Value ? reader["CustomerTypeName"].ToString() : string.Empty,
                            ActiveFromDate = reader["ActiveFromDate"] != DBNull.Value ? Convert.ToDateTime(reader["ActiveFromDate"]).ToString("yyyy-MM-dd") : string.Empty,
                            ActiveToDate = reader["ActiveToDate"] != DBNull.Value ? Convert.ToDateTime(reader["ActiveToDate"]).ToString("yyyy-MM-dd") : string.Empty,
                            AllowedNoOfInvoice = reader["AllowedNoOfInvoice"] != DBNull.Value ? Convert.ToInt32(reader["AllowedNoOfInvoice"]) : 4,
                            AllowedCreditLimit = reader["AllowedCreditLimit"] != DBNull.Value ? Convert.ToDecimal(reader["AllowedCreditLimit"]) : 100000.00m,
                            NumberOfDaysInTransit = reader["NumberOfDaysInTransit"] != DBNull.Value ? Convert.ToInt32(reader["NumberOfDaysInTransit"]) : 45,
                            Remarks = reader["Remarks"] != DBNull.Value ? reader["Remarks"].ToString() : string.Empty,
                            IsActive = Convert.ToBoolean(reader["IsActive"])
                        };
                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return model;
        }

        public List<CustomerTypeViewModel> GetCustomerTypeListActive()
        {
            List<CustomerTypeViewModel> list = new List<CustomerTypeViewModel>();
            DataTable dt = seedDataDal.GetChemistTypeListActive();
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    list.Add(new CustomerTypeViewModel
                    {
                        CustomerTypeId = Convert.ToInt32(row["CustomerTypeId"]),
                        CustomerType = row["CustomerType"].ToString()
                    });
                }
            }
            return list;
        }

        public List<InvoiceNotBindingViewModel> GetInvoiceNotBindingList()
        {
            List<InvoiceNotBindingViewModel> list = new List<InvoiceNotBindingViewModel>();
            try
            {
                string query = "EXEC sp_GetInvoiceNotBindingList";
                IDataReader reader = aCommonInternalDal.DataContainerDataReader(query, "SSIDB");

                if (reader != null)
                {
                    while (reader.Read())
                    {
                        var model = new InvoiceNotBindingViewModel
                        {
                            InvoiceNotBindingId = Convert.ToInt32(reader["InvoiceNotBindingId"]),
                            ApplyType = reader["ApplyType"] != DBNull.Value ? reader["ApplyType"].ToString() : "Customer",
                            CustomerId = reader["CustomerId"] != DBNull.Value ? Convert.ToInt32(reader["CustomerId"]) : 0,
                            CustomerCode = reader["CustomerCode"] != DBNull.Value ? reader["CustomerCode"].ToString() : string.Empty,
                            CustomerName = reader["CustomerName"] != DBNull.Value ? reader["CustomerName"].ToString() : string.Empty,
                            MobileNo = reader["MobileNo"] != DBNull.Value ? reader["MobileNo"].ToString() : string.Empty,
                            CustomerTypeId = reader["CustomerTypeId"] != DBNull.Value ? Convert.ToInt32(reader["CustomerTypeId"]) : 0,
                            CustomerTypeName = reader["CustomerTypeName"] != DBNull.Value ? reader["CustomerTypeName"].ToString() : string.Empty,
                            ActiveFromDate = reader["ActiveFromDate"] != DBNull.Value ? Convert.ToDateTime(reader["ActiveFromDate"]).ToString("dd-MMM-yyyy") : string.Empty,
                            ActiveToDate = reader["ActiveToDate"] != DBNull.Value ? Convert.ToDateTime(reader["ActiveToDate"]).ToString("dd-MMM-yyyy") : string.Empty,
                            AllowedNoOfInvoice = reader["AllowedNoOfInvoice"] != DBNull.Value ? Convert.ToInt32(reader["AllowedNoOfInvoice"]) : 4,
                            AllowedCreditLimit = reader["AllowedCreditLimit"] != DBNull.Value ? Convert.ToDecimal(reader["AllowedCreditLimit"]) : 100000.00m,
                            NumberOfDaysInTransit = reader["NumberOfDaysInTransit"] != DBNull.Value ? Convert.ToInt32(reader["NumberOfDaysInTransit"]) : 45,
                            Remarks = reader["Remarks"] != DBNull.Value ? reader["Remarks"].ToString() : string.Empty,
                            IsActive = Convert.ToBoolean(reader["IsActive"]),
                            CreatedBy = reader["CreatedBy"] != DBNull.Value ? reader["CreatedBy"].ToString() : string.Empty,
                            CreatedDate = reader["CreatedDate"] != DBNull.Value ? Convert.ToDateTime(reader["CreatedDate"]).ToString("dd-MMM-yyyy") : string.Empty
                        };
                        list.Add(model);
                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return list;
        }
    }
}
