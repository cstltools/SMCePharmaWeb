CREATE PROCEDURE [dbo].[sp_Webapi_GetProductWiseOrderReportSum] -- sp_Get_Order_Info_WebAPI_NEw_MIo 313
	-- Add the parameters for the stored procedure here
@empId int = null,
 
 
@Role  nvarchar(max)=null,
 
@Month  int=null,
@Year   int=null

AS
BEGIN
 


 

		DECLARE @params NVARCHAR(max)='  '
		DECLARE @params2 NVARCHAR(max)='  '

		IF(@Month IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND MONTH(convert(Date,  D.SubmissionDate))='''+CAST(@Month AS NVARCHAR(max))+''''
		END
		IF(@Year IS NOT NULL )
		BEGIN
		    SET @params=@params+ ' AND   year(convert(Date,  D.SubmissionDate))= '''+CAST(@Year AS NVARCHAR(max))+''''
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
	SET @Q=' select ISNULL(count(D.OrderId),0) total_ot, convert(decimal(18,2),iSNULL(SUM(D.GrossValue-D.TotalDiscount),0))	 as total_amount,  SUM(dtl.Quantity) total_qty from tblOrderDetail dtl
inner join  dbo.tblOrder D  with (nolock) on dtl.OrderId=D.OrderId
left join tblUser u with (nolock) on D.EntryBy=u.UserId

left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs on emp.EmpInfoId=fs.EmpInfoId WHERE  IsFromApp = 1    '     +@params2 +@params+'
		  
			 '

EXEC sys.sp_executesql @Q


--(D.EntryBy = '+CAST(@mioCode as nvarchar(max))+'  OR
--			D.AreaId='+CAST(@AreaId as nvarchar(max))+' OR 
--			D.RegionId='+CAST(@ZoneId as nvarchar(max))+' OR 
--			D.GroupId='+CAST(@GroupId as nvarchar(max))+')


    END