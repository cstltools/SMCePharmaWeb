using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class SupplierInfoDal
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();


        public bool SaveDataForCompanyInfo(SupplierInformation aCompanyInfo)
        {
            string insertQuery = @"insert into tblSupplierInformation (SupplierCode,SupplierName,SupplierAddress,ContactNo,Entryby,EntryDate) 
            values (@SupplierCode,@SupplierName,@SupplierAddress,@ContactNo,@Entryby,@EntryDate)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@SupplierCode", SInventorySql.DbValue(aCompanyInfo.CompanyCode)),
                new SqlParameter("@SupplierName", SInventorySql.DbValue(aCompanyInfo.SupplierName)),
                new SqlParameter("@SupplierAddress", SInventorySql.DbValue(aCompanyInfo.Address)),
                new SqlParameter("@ContactNo", SInventorySql.DbValue(aCompanyInfo.ContactNo)),
                new SqlParameter("@Entryby", SInventorySql.DbValue(aCompanyInfo.EntryBy)),
                new SqlParameter("@EntryDate", SInventorySql.DbValue(aCompanyInfo.EntryDate))
            });
        }

        public DataTable LoadSupplierInfo()
        {
            string query = @"SELECT * FROM tblSupplierInformation";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public bool HasCompanyName(SupplierInformation aCompanyInfo)
        {
            string query = "select * from tblSupplierInformation where SupplierName = @SupplierName";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@SupplierName", SInventorySql.DbValue(aCompanyInfo.SupplierName))
            });
        }


        public bool SaveCompanyInfoData(SupplierInformation aCompanyInfo)
        {
            try
            {
                if (!HasCompanyName(aCompanyInfo))
                {
                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    aCompanyInfo.SupplierId = aClsPrimaryKeyFind.PrimaryKeyMax("SupplierId", "tblSupplierInformation");
                    aCompanyInfo.CompanyCode = CompanyCodeGenerator(aCompanyInfo.SupplierId);
                    SaveDataForCompanyInfo(aCompanyInfo);
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        public string CompanyCodeGenerator(int id)
        {
            string code = string.Empty;

            string Id = id.ToString();

            if (Id.Length == 1)
            {
                Id = "00" + Id;
            }

            if (Id.Length == 2)
            {
                Id = "0" + Id;
            }

            code = "SPLR-" + Id;

            return code;
        }

        public DataTable LoadSupplierInfoById(int supplierid)
        {
            string query = @"SELECT * FROM tblSupplierInformation WHERE SupplierId = @SupplierId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@SupplierId", supplierid)
            });
        }

        public bool UpdateCompanyInfoData(SupplierInformation aCompanyInfo)
        {
            string query = @"UPDATE tblSupplierInformation SET SupplierName=@SupplierName,SupplierAddress=@SupplierAddress,ContactNo=@ContactNo,Updateby=@Updateby,UpdateDate=@UpdateDate WHERE SupplierId=@SupplierId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@SupplierName", SInventorySql.DbValue(aCompanyInfo.SupplierName)),
                new SqlParameter("@SupplierAddress", SInventorySql.DbValue(aCompanyInfo.Address)),
                new SqlParameter("@ContactNo", SInventorySql.DbValue(aCompanyInfo.ContactNo)),
                new SqlParameter("@Updateby", SInventorySql.DbValue(aCompanyInfo.UpdateBy)),
                new SqlParameter("@UpdateDate", SInventorySql.DbValue(aCompanyInfo.UpdateDate)),
                new SqlParameter("@SupplierId", aCompanyInfo.SupplierId)
            });
        }

        public bool CheckDuplicate(SupplierInformation aCompanyInfo)
        {
            string query = "select * from tblSupplierInformation where SupplierName = @SupplierName AND SupplierId <> @SupplierId";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@SupplierName", SInventorySql.DbValue(aCompanyInfo.SupplierName)),
                new SqlParameter("@SupplierId", aCompanyInfo.SupplierId)
            });
        }
    }
}
