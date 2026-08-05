
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_GroupWisePromoQtyList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)=null
AS
BEGIN
   DECLARE @Q NVARCHAR(MAX)='
 SELECT tr.TerritoryCode+'' : ''+tr.TerritoryName TerritoryName  , emp.EmpMasterCode+'' : ''+emp.EmpName EmpName  ,   pro.ProductCode+'' : ''+pro.ProductName ProductName  , mas.PromoGroupId,PromoGroupCode +'' : ''+PromoGroupName PromoGroupName, * from dbo.tblGroupWisePromoQty mas WITH (NOLOCK) 
  LEFT JOIN dbo.tblPromoGroup  with (nolock) ON mas.PromoGroupId=dbo.tblPromoGroup.PromoGroupId
LEFT JOIN dbo.tblProduct pro  with (nolock) ON mas.ProductId=pro.ProductId
LEFT JOIN dbo.tblEmpGeneralInfo emp  with (nolock) ON mas.EmpInfoId=emp.EmpInfoId
LEFT JOIN dbo.tblMIOInfo mio  with (nolock) ON mas.EmpInfoId=mio.EmployeeId
LEFT JOIN dbo.tblTerritory tr  with (nolock) ON mio.TerritoryId=tr.TerritoryId


   where mas.GWPromoQtyId is not null
  '+@Parm  


EXEC sp_executesql @Q
	
END