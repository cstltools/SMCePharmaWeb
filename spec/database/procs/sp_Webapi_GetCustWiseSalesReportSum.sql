create PROCEDURE [dbo].[sp_Webapi_GetCustWiseSalesReportSum] -- sp_Get_Order_Info_WebAPI_NEw_MIo 313
	-- Add the parameters for the stored procedure here
	@empId int = null,
 
 
@Role  nvarchar(max)=null,
 
@Month  int=null,
@Year   int=null

 

AS
BEGIN

 


		 

		DECLARE @params NVARCHAR(max)='  '
	IF(@Month IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND MONTH(convert(Date,  D.SubmissionDate))='''+CAST(@Month AS NVARCHAR(max))+''''
		END
		IF(@Year IS NOT NULL )
		BEGIN
		    SET @params=@params+ ' AND   year(convert(Date,  D.SubmissionDate))= '''+CAST(@Year AS NVARCHAR(max))+''''
		END

	 
	  





DECLARE @Q NVARCHAR(MAX)
	SET @Q='
	SELECT  ISNULL( Count(D.CustomerMasterId), 0) total_qty ,
	convert(decimal(18,2),iSNULL(SUM(D.GrossValue-D.TotalDiscount),0))	 as total_amount

FROM    dbo.tblOrder D with (nolock) 
 
left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs on emp.EmpInfoId=fs.EmpInfoId




			WHERE  
			 
			 IsFromApp = 1 and  	(fs.MIOEmpId='+convert(nvarchar(max),@empId)+' or fs.ASMEMPId='+convert(nvarchar(max),@empId)+' or fs.RSMEMPId='+convert(nvarchar(max),@empId)+' or fs.NSMEMPId='+convert(nvarchar(max),@empId)+')  
  '  +@params+'
		  
			 '

EXEC sys.sp_executesql @Q


--(D.EntryBy = '+CAST(@mioCode as nvarchar(max))+'  OR
--			D.AreaId='+CAST(@AreaId as nvarchar(max))+' OR 
--			D.RegionId='+CAST(@ZoneId as nvarchar(max))+' OR 
--			D.GroupId='+CAST(@GroupId as nvarchar(max))+')


    END