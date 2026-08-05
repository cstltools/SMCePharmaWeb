-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GET_NSMInfo]
	
	-- Add the parameters for the stored procedure here
	@Parameter NVARCHAR(MAX)

AS
BEGIN
   

   DECLARE @Query NVARCHAR(MAX)

   SET @Query = 'SELECT NSM.NSMId,GP.GroupId,GP.GroupCode + '':''+ GP.GroupName AS GroupName,
   EGI.EmpMasterCode + '':''+ EGI.EmpName AS EmployeeName,
   NSM.IsActive,CONVERT(NVARCHAR(50),NSM.ActiveDate,106)AS ActiveInActiveDate,
   CASE WHEN ISNULL(C.NoOf,0) > 0 THEN ''disabled'' ELSE '''' END AS DeleteStatus
   FROM tblNSMInfo AS NSM
   LEFT JOIN tbl_Group AS GP ON NSM.GroupId = GP.GroupId
   LEFT JOIN tblEmpGeneralInfo AS EGI ON NSM.EmployeeId = EGI.EmpInfoId 
   LEFT JOIN (SELECT DISTINCT NSMId,COUNT(ASMId) NoOf FROM tblOrder WHERE NSMId IS NOT NULL GROUP BY NSMId) AS C ON NSM.NSMId = C.NSMId
   WHERE NSM.NSMId IS NOT NULL ' + @Parameter


  


   --SELECT GP.GroupCode + ':'+ GP.GroupName AS GroupName FROM tbl_Group AS GP


   --SELECT DISTINCT ASMId,COUNT(ASMId) NoOf FROM tblOrder AS INV GROUP BY ASMId
   

   EXEC(@Query)

 
END
