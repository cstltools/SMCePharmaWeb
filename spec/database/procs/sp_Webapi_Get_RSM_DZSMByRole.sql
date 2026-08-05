CREATE PROCEDURE [dbo].[sp_Webapi_Get_RSM_DZSMByRole]
	-- Add the parameters for the stored procedure here
	@Role nvarchar(max),

	 @EmployeeId NVARCHAR(MAX)= NULL
	AS
    BEGIN
  
  declare @Id int
 IF(@Role='AM')
	BEGIN
		 
	 
	   
SELECT     STUFF( (SELECT CONCAT(',', mm.EmpAreaId , '')   FROM View_Webapi_EmployeeFieldForceInfo mm (NOLOCK)   WHERE EmpInfoId=@EmployeeId   FOR XML PATH ('') ),1,1,'')  EmpAreaId 
	    
	END
	IF(@Role='DZSM')
	BEGIN
	   SELECT    STUFF( (SELECT CONCAT(',', mm.EmpRegionId , '')   FROM View_Webapi_EmployeeFieldForceInfo mm (NOLOCK)   WHERE EmpInfoId=@EmployeeId   FOR XML PATH ('') ),1,1,'')   EmpRegionId
	   
	    
	END
	 

	end