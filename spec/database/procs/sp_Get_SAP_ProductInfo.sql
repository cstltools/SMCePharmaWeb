
create PROCEDURE [dbo].[sp_Get_SAP_ProductInfo]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max) ,
	@Parm2 nvarchar(max) 
AS
BEGIN
  select    cat.CategoryName,   pg.GroupName, um.StockUOMName, format(pro.effective_date, 'dd-MMM-yyyy') effective_date, pro.* from SAP_API_Data..tblProduct pro with (nolock)
LEFT JOIN dbo.tblProCategory  cat  with (nolock) ON pro.category_code = cat.CategorySAPCode
 LEFT JOIN dbo.tblPackSize ps with (nolock) ON pro.pack_size_code=ps.PackSizeSAPCode 
 
 LEFT JOIN dbo.tblProductGroup pg with (nolock) ON pro.group_code=pg.GroupSAPCode
 LEFT JOIN dbo.tblStockUOM um with (nolock) ON pro.sales_uom_code=um.UOMSAPCode  

	  where  isnull(pro.Is_EpharmaSystemUpdate,0)=0 

	    order by pro.product_code asc
 --select * from tblRoleType
 --select * from SAP_API_Data..tblSAP_Zone_Assign

END
             

			  