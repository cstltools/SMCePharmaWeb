using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.DataManager;
using Library.DAL.InternalCls;

using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class ProductDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        private static object ToDbValue(object value)
        {
            return value ?? DBNull.Value;
        }

        private static DataTable GetDataTableByText(string query, List<SqlParameter> parameters)
        {
            DataAccessManager accessManager = new DataAccessManager();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                return accessManager.GetDataTableByText(query, parameters);
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public bool SaveDataForProduct(Product aProduct)
        {
            string insertQuery = @"insert into tblProduct (ProductId,ProductCode,ProductName,Description,PackSize,CategoryId,ManufacId,StockUOMId,ProTypeId,ProductBrandId,CaseId,PackSizeId,TherapueticGroupId,GenericGroupId,ProductGroupId,ProductImage,ProductLineID,IsActive) 
            values (@ProductId,@ProductCode,@ProductName,@Description,@PackSize,@CategoryId,@ManufacId,@StockUOMId,@ProTypeId,@ProductBrandId,@CaseId,@PackSizeId,@TherapueticGroupId,@GenericGroupId,@ProductGroupId,@ProductImage,@ProductLineID,@IsActive)";

            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProductId", aProduct.ProductId),
                new SqlParameter("@ProductCode", ToDbValue(aProduct.ProductCode)),
                new SqlParameter("@ProductName", ToDbValue(aProduct.ProductName)),
                new SqlParameter("@Description", ToDbValue(aProduct.Description)),
                new SqlParameter("@PackSize", ToDbValue(aProduct.PackSize)),
                new SqlParameter("@CategoryId", aProduct.CategoryId),
                new SqlParameter("@ManufacId", aProduct.ManufacId),
                new SqlParameter("@StockUOMId", aProduct.StockUOMId),
                new SqlParameter("@ProTypeId", aProduct.ProTypeId),
                new SqlParameter("@ProductBrandId", aProduct.ProductBrandId),
                new SqlParameter("@CaseId", aProduct.CaseId),
                new SqlParameter("@PackSizeId", aProduct.PackSizeId),
                new SqlParameter("@TherapueticGroupId", ToDbValue(aProduct.TherapueticGroupId)),
                new SqlParameter("@GenericGroupId", ToDbValue(aProduct.GenericGroupId)),
                new SqlParameter("@ProductGroupId", ToDbValue(aProduct.ProductGroupId)),
                new SqlParameter("@ProductImage", ToDbValue(aProduct.ProductImage)),
                new SqlParameter("@ProductLineID", ToDbValue(aProduct.ProductLineID)),
                new SqlParameter("@IsActive", aProduct.IsActive)
            };

            return aCommonInternalDal.UpdateDataByUpdateCommandNew(insertQuery, parameters);
        }

        public bool HasProductName(Product aProduct)
        {
            string query = "select top 1 ProductId from tblProduct where ProductCode = @ProductCode";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProductCode", ToDbValue(aProduct.ProductCode))
            };

            return GetDataTableByText(query, parameters).Rows.Count > 0;
        }


        public DataTable LoadProduct()
        {
            string query = @"SELECT gg.GenericGroupName, cat.CategoryName, pro.PackSize, pg.GroupName, um.StockUOMName, case when  pro.IsActive=1 then 'badge bg-success' else 'badge bg-warning' end CSSStatus,  case when  pro.IsActive=1 then 'Active' else 'Inactive' end StatusInfo,  * FROM tblProduct pro with (nolock)
LEFT JOIN dbo.tblProCategory  cat  with (nolock) ON pro.CategoryId = cat.CategoryId
 LEFT JOIN dbo.tblPackSize ps with (nolock) ON pro.PackSizeId=ps.PackSizeId
 LEFT JOIN dbo.tblProductCase  pCase  with (nolock) ON pCase.ProductCode=pro.ProductCode

 LEFT JOIN dbo.tblGenericGroup gg with (nolock) ON pro.GenericGroupId=gg.GenericGroupId
 LEFT JOIN dbo.tblProductGroup pg with (nolock) ON pro.ProductGroupId=pg.GroupId
 LEFT JOIN dbo.tblStockUOM um with (nolock) ON pro.StockUOMId=um.StockUOMId   order by pro.ProductName asc
 ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public Product ProductEditLoad(string ProductId)
        {
            string query = "select  STUFF( (SELECT CONCAT(',', brn.ComUnitId , '') FROM dbo.tblProductDCDetails brn(NOLOCK)  WHERE brn.ProductId=tblProduct.ProductId ORDER BY brn.ComUnitId FOR XML PATH ('') ),1,1,'') AS ProductDCID,* from tblProduct where ProductId = @ProductId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProductId", ToDbValue(ProductId))
            };

            DataTable productTable = GetDataTableByText(query, parameters);
            Product aProduct = new Product();
            if (productTable.Rows.Count > 0)
            {
                DataRow row = productTable.Rows[0];
                aProduct.ProductId = Int32.Parse(row["ProductId"].ToString());
                aProduct.ProductCode = row["ProductCode"].ToString();
                aProduct.ProductName = row["ProductName"].ToString();
                aProduct.PackSize = row["PackSize"].ToString();
                aProduct.Description = row["Description"].ToString();
                aProduct.ProductDCID = row["ProductDCID"].ToString();

                if (row["CategoryId"] != DBNull.Value)
                {
                    aProduct.CategoryId = Convert.ToInt32(row["CategoryId"].ToString());

                }
                if (row["ManufacId"] != DBNull.Value)
                {
                    aProduct.ManufacId = Convert.ToInt32(row["ManufacId"].ToString());
                }

                if (row["StockUOMId"] != DBNull.Value)
                {
                    aProduct.StockUOMId = Convert.ToInt32(row["StockUOMId"].ToString());
                }

                if (row["ProTypeId"] != DBNull.Value)
                {
                    aProduct.ProTypeId = Convert.ToInt32(row["ProTypeId"].ToString());
                }

                if (row["ProductBrandId"] != DBNull.Value)
                {
                    aProduct.ProductBrandId = Convert.ToInt32(row["ProductBrandId"].ToString());
                }

                if (row["CaseId"] != DBNull.Value)
                {
                    aProduct.CaseId = Convert.ToInt32(row["CaseId"].ToString());
                }

                if (row["PackSizeId"] != DBNull.Value)
                {
                    aProduct.PackSizeId = Convert.ToInt32(row["PackSizeId"].ToString());
                }

                if (row["GenericGroupId"] != DBNull.Value)
                {
                    aProduct.GenericGroupId = Convert.ToInt32(row["GenericGroupId"].ToString());
                }

                if (row["TherapueticGroupId"] != DBNull.Value)
                {
                    aProduct.TherapueticGroupId = Convert.ToInt32(row["TherapueticGroupId"].ToString());
                }

                if (row["ProductGroupId"] != DBNull.Value)
                {
                    aProduct.ProductGroupId = Convert.ToInt32(row["ProductGroupId"].ToString());
                }
                if (row["ProductLineID"] != DBNull.Value)
                {
                    aProduct.ProductLineID = Convert.ToInt32(row["ProductLineID"].ToString());
                }

                if (row["IsActive"] != DBNull.Value)
                {
                    aProduct.IsActive = Convert.ToBoolean(row["IsActive"].ToString());
                }
                aProduct.ProductImage = row["ProductImage"].ToString();



            }
            return aProduct;
        }

        public bool UpdateProduct(Product aProduct)
        {
            string query = @"UPDATE tblProduct SET IsActive=@IsActive,ProductName=@ProductName,ProductCode=@ProductCode,Description=@Description,PackSize=@PackSize,CategoryId=@CategoryId,ManufacId=@ManufacId,StockUOMId=@StockUOMId,ProTypeId=@ProTypeId,ProductBrandId=@ProductBrandId,ProductGroupId=@ProductGroupId,GenericGroupId=@GenericGroupId,TherapueticGroupId=@TherapueticGroupId,ProductImage=@ProductImage,ProductLineID=@ProductLineID WHERE ProductId=@ProductId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@IsActive", aProduct.IsActive),
                new SqlParameter("@ProductName", ToDbValue(aProduct.ProductName)),
                new SqlParameter("@ProductCode", ToDbValue(aProduct.ProductCode)),
                new SqlParameter("@Description", ToDbValue(aProduct.Description)),
                new SqlParameter("@PackSize", ToDbValue(aProduct.PackSize)),
                new SqlParameter("@CategoryId", aProduct.CategoryId),
                new SqlParameter("@ManufacId", aProduct.ManufacId),
                new SqlParameter("@StockUOMId", aProduct.StockUOMId),
                new SqlParameter("@ProTypeId", aProduct.ProTypeId),
                new SqlParameter("@ProductBrandId", aProduct.ProductBrandId),
                new SqlParameter("@ProductGroupId", ToDbValue(aProduct.ProductGroupId)),
                new SqlParameter("@GenericGroupId", ToDbValue(aProduct.GenericGroupId)),
                new SqlParameter("@TherapueticGroupId", ToDbValue(aProduct.TherapueticGroupId)),
                new SqlParameter("@ProductImage", ToDbValue(aProduct.ProductImage)),
                new SqlParameter("@ProductLineID", ToDbValue(aProduct.ProductLineID)),
                new SqlParameter("@ProductId", aProduct.ProductId)
            };

            return aCommonInternalDal.UpdateDataByUpdateCommandNew(query, parameters);
        }


        public void LoadCategoryName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblProCategory";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "CategoryName", "CategoryId", queryStr);
        }
        public void LoadManufac(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblManufacturer";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ManufacName", "ManufacId", queryStr);
        }
        public void LoadPackSize(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblPackSize";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "PackSizeName", "PackSizeId", queryStr);
        }
        public void LoadStockUOM(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblStockUOM where UOMSAPCode is not null";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "StockUOMName", "StockUOMId", queryStr);
        }
        public void LoadType(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblProType";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ProTypeName", "ProTypeId", queryStr);
        }
        public void LoadIngrident(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblIngridents";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "IngridentsName", "IngridentsId", queryStr);
        }
        public void LoadProductSQ(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblProductSQ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ProductSQName", "ProductBrandId", queryStr);
        }

        public void LoadTherapeuticGroup(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblTherapeuticGroup with (nolock) where IsActive=1";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "TherapeuticGroupName", "TherapeuticGroupId", queryStr);
        }

        public void LoadGenericGroup(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblGenericGroup with (nolock) where IsActive=1";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "GenericGroupName", "GenericGroupId", queryStr);
        }

        public void LoadProductType_new(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblProductGroup with (nolock)";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "GroupName", "GroupId", queryStr);
        }
        public void LoadShippingCartonSize(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblProductCase";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "PcsPerCase", "CaseId", queryStr);
        }
        public DataTable ProductPriceDetailWithCase(string productCode)
        {
            string query = @"SELECT UP.*,PC.CaseQty,PC.PcsPerCase FROM dbo.tblUnitPrice UP "+
                            " LEFT JOIN dbo.tblProduct P ON UP.ProductCode = P.ProductCode  " +
                             " LEFT JOIN dbo.tblProductCase PC ON p.CaseId = PC.CaseId   " +
                            " WHERE UP.ProductCode=@ProductCode ";

            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProductCode", ToDbValue(productCode == null ? null : productCode.Trim()))
            };

            return GetDataTableByText(query, parameters);
        }
    }
}
