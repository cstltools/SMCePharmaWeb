
create PROCEDURE [dbo].[sp_Webapi_GetProductWiseSalesReport_L] -- sp_Get_Order_Info_WebAPI_NEw_MIo 313
	-- Add the parameters for the stored procedure here
	@empId int = null,
 
 
@Role  nvarchar(max)=null,
 
@Month  int=null,
@Year   int=null,
@ProviderType  int=null,
@CustomerType  int=null

AS
BEGIN

 

 

		DECLARE @params NVARCHAR(max)='  '
		DECLARE @params2 NVARCHAR(max)='  '

		IF(@Month IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND MONTH(convert(Date,A.InvoiceDate))='''+CAST(@Month AS NVARCHAR(max))+''''
		END
		IF(@Year IS NOT NULL )
		BEGIN
		    SET @params=@params+ ' AND   year(convert(Date,A.InvoiceDate))= '''+CAST(@Year AS NVARCHAR(max))+''''
		END

	 
	 	IF(@ProviderType IS NOT NULL )
		BEGIN
		    SET @params=@params+ ' AND  D.ProgramTypeId='''+CAST(@ProviderType AS NVARCHAR(max))+''''
		END

			IF(@CustomerType IS NOT NULL )
		BEGIN
		    SET @params=@params+ ' AND  D.CustTypeId='''+CAST(@CustomerType AS NVARCHAR(max))+''''
		END
	 
			IF(@Role='MIO')
		BEGIN
		    SET @params2=@params2+ ' AND  fs.MIOEmpId='''+CAST(@empId AS NVARCHAR(max))+''''
		END


			IF(@Role='AM')
		BEGIN
		    SET @params2=@params2+ ' AND  fs.ASMEMPId='''+CAST(@empId AS NVARCHAR(max))+''''
		END
		IF(@Role='DZSM')
		BEGIN
		    SET @params2=@params2+ ' AND  fs.RSMEMPId='''+CAST(@empId AS NVARCHAR(max))+''''
		END


		IF(@Role='NSM')
		BEGIN
		    SET @params2=@params2+ ' AND  fs.NSMEMPId='''+CAST(@empId AS NVARCHAR(max))+''''
		END

	  


DECLARE @Q NVARCHAR(MAX)
SET @Q='select  ROW_NUMBER() Over (Order by pro.ProductCode) As [SN], order_times,  pro.ProductCode+'' : ''+pro.ProductName product_name,   (tblDtl.Quantity) ordered_qty, ordered_value from tblProduct pro
inner join (select ISNULL(count(D.OrderId),0) order_times,  convert(decimal(18,2),iSNULL(SUM(dtl.TotalTradePrice-dtl.DiscountAmount),0))	 as ordered_value,  SUM(dtl.Quantity) Quantity, dtl.ProductId from tblOrderDetail dtl
inner join  dbo.tblOrder D  with (nolock) on dtl.OrderId=D.OrderId
inner join  dbo.tblInvoice A  with (nolock) on A.OrderId=D.OrderId
left join tblUser u with (nolock) on D.EntryBy=u.UserId

left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs on emp.EmpInfoId=fs.EmpInfoId WHERE  IsFromApp = 1    
 
		 
		  '     +@params2 +@params+'
 group by  ProductId) tblDtl on tblDtl.ProductId=pro.ProductId    
 '

EXEC sys.sp_executesql @Q


--(D.EntryBy = '+CAST(@mioCode as nvarchar(max))+'  OR
--			D.AreaId='+CAST(@AreaId as nvarchar(max))+' OR 
--			D.RegionId='+CAST(@ZoneId as nvarchar(max))+' OR 
--			D.GroupId='+CAST(@GroupId as nvarchar(max))+')


    END