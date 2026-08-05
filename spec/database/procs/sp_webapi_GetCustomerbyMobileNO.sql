
CREATE PROCEDURE [dbo].[sp_webapi_GetCustomerbyMobileNO]
	-- Add the parameters for the stored procedure here
    @empId INT,
	@CellNo nvarchar(max)
AS
    BEGIN



        DECLARE @Q NVARCHAR(MAX)=''
	DECLARE @Param NVARCHAR(MAX)=''
	DECLARE @Id NVARCHAR(MAX)=0
	DECLARE @Roletype NVARCHAR(MAX)=NULL
	SELECT @Roletype=RoleTypeId FROM dbo.tblUser   with (nolock)
	LEFT JOIN dbo.tbl_UserRoleInfo  with (nolock) ON tbl_UserRoleInfo.UserRoleID = tblUser.UserRoleID
	WHERE EmpInfoId=@empId

	SET @Q='SELECT distinct  ISNULL(tblt.SerialNo,1000000) SerialNo,  D.MarketCode MarketCode, D.CustomerTypeId, D.ProgramTypeId, D.SMCTypeId, 0 as CustomerCheck,format(tbInvo.InvoiceDate,''dd MMMM, yyyy'') Note,  D.GroupId,D.RegionId, D.AreaId, D.TerritoryId, D.SubTerritoryId,D.MarketId,  D.CustomerMasterId ,
                D.CustomerName ,
                D.CustomerCode ,
                D.Address ,
                D.MarketName ,
                D.CellNo ,
                Type AS CustomerType ,
                CustomerStation AS ''CustomerStation'' ,
               D.OwnerName AS ''Route'' ,
                0 AS ''Balance'' ,
                0 AS ''CreditLimit'' ,
                NULL AS ''Route'' FROM dbo.View_CustomerMaster D with (nolock) 
				
					left join (
				select max(InvoiceDate) InvoiceDate, tblInvoice.CustomerMasterId from tblInvoice with (nolock)   group by CustomerMasterId) tbInvo on  tbInvo.CustomerMasterId=D.CustomerMasterId
				
				  LEFT JOIN (SELECT MarketId,EmpInfoId,min(SerialNo) SerialNo FROM dbo.tbl_TourPlanInfo   with (nolock) 
				WHERE CONVERT(DATE,TourPlanDate)=CONVERT(DATE,GETDATE()) AND EmpInfoId='+CONVERT(NVARCHAR(MAX),@empId)+'  group by MarketId,EmpInfoId) AS tblt ON tblt.MarketId = D.MarketId '

	--SELECT * FROM dbo.View_CustomerMaster WHERE GroupId

	IF(@Roletype='1')
	BEGIN
		SELECT @Id=EmpTerrId FROM dbo.View_Webapi_EmployeeFieldForceInfo   with (nolock)  WHERE EmpInfoId=@empId

	    SET @Param=@Param+' WHERE TerritoryId='+@Id
	END
	IF(@Roletype='2')
	BEGIN
	 
SELECT   @Id=  STUFF( (SELECT CONCAT(',', mm.EmpAreaId , '')   FROM View_Webapi_EmployeeFieldForceInfo mm (NOLOCK)   WHERE EmpInfoId=@empId   FOR XML PATH ('') ),1,1,'')  
	    SET @Param=@Param+' WHERE AreaId in ('+@Id+')'
 
	END
	IF(@Roletype='3')
	BEGIN
	    
		SELECT   @Id=  STUFF( (SELECT CONCAT(',', mm.EmpRegionId , '')   FROM View_Webapi_EmployeeFieldForceInfo mm (NOLOCK)   WHERE EmpInfoId=@empId   FOR XML PATH ('') ),1,1,'')  
	   

	    SET @Param=@Param+' WHERE RegionId in ('+@Id+')'
	END
	IF(@Roletype='4')
	BEGIN
	    SELECT @Id=EmpGroupId FROM dbo.View_Webapi_EmployeeFieldForceInfo   with (nolock)  WHERE EmpInfoId=@empId

	    SET @Param=@Param+' WHERE GroupId='+@Id
	END

	SET @Q=@Q+@Param +  ' and D.CellNo=''' +@CellNo  +''''

    EXEC sys.sp_executesql @Q



    END