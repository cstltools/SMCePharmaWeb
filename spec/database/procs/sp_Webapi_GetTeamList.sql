
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE
 PROCEDURE [dbo].[sp_Webapi_GetTeamList]
	-- Add the parameters for the stored procedure here
    @role NVARCHAR(50) = NULL ,
    @id INT = NULL,
	@aparam NVARCHAR(MAX) NULL
AS
    BEGIN
	
	DECLARE @param NVARCHAR(MAX)=''
	IF(@role='AM')
	BEGIN
	    SET @param=@param+' Where ASMEMPId='+CONVERT(NVARCHAR(MAX),@id)+' AND View_Webapi_EmployeeFieldForceInfo.EmpInfoId<>'+CONVERT(NVARCHAR(MAX),@id)
	END
	IF(@role='RSM')
	BEGIN
	    SET @param=@param+' Where RSMEMPId='+CONVERT(NVARCHAR(MAX),@id)+' AND View_Webapi_EmployeeFieldForceInfo.EmpInfoId<>'+CONVERT(NVARCHAR(MAX),@id)
	END
	IF(@role='DZSM')
	BEGIN
	    SET @param=@param+' Where RSMEMPId='+CONVERT(NVARCHAR(MAX),@id)+' AND View_Webapi_EmployeeFieldForceInfo.EmpInfoId<>'+CONVERT(NVARCHAR(MAX),@id)
	END
	IF(@role='NSM')
	BEGIN
	    SET @param=@param+' Where NSMEMPId='+CONVERT(NVARCHAR(MAX),@id)+' AND View_Webapi_EmployeeFieldForceInfo.EmpInfoId<>'+CONVERT(NVARCHAR(MAX),@id)
	END


	DECLARE @q NVARCHAR(MAX)=''

	SET @q='

    SELECT distinct EmpRole,
           TerritoryName,
           TerritoryCode,
           AreaCode,
           AreaName,
           RegionCode,
           RegionName,      
           GroupName,
           tblEmpGeneralInfo.EmpMasterCode,
           EmpName,
           ShiftId,
           EmployeeStatus,
           tblEmpGeneralInfo.EmpInfoId,
           Gender,
           AddressPresent,
           PhoneNo,
           CellNumber,
           Email,
          '''' EmpImage,
           Designation,
           DeptName,
           EmrgContactNo
           FROM dbo.View_Webapi_EmployeeFieldForceInfo
	LEFT JOIN dbo.tblEmpGeneralInfo ON tblEmpGeneralInfo.EmpInfoId = View_Webapi_EmployeeFieldForceInfo.EmpInfoId
	'+@param + ' ' +@aparam
	

	EXEC sp_executesql @q

    END


