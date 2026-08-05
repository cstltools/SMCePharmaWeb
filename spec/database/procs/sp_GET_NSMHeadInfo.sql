-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_GET_NSMHeadInfo]
	
	-- Add the parameters for the stored procedure here
	@Parameter NVARCHAR(MAX)

AS
BEGIN
   

   DECLARE @Query NVARCHAR(MAX)

   SET @Query = 'SELECT NSM.National_NSMId,GP.NationalId,GP.NationalCode + '':''+ GP.NationalName AS GroupName,
   EGI.EmpMasterCode + '':''+ EGI.EmpName AS EmployeeName,
   NSM.IsActive,CONVERT(NVARCHAR(50),NSM.ActiveDate,106)AS ActiveInActiveDate,
    ''disabled''    AS DeleteStatus
   FROM tblNational_NSM AS NSM
   LEFT JOIN tbl_National AS GP ON NSM.NationalId = GP.NationalId
   LEFT JOIN tblEmpGeneralInfo AS EGI ON NSM.EmployeeId = EGI.EmpInfoId 
   
   WHERE NSM.National_NSMId IS NOT NULL ' + @Parameter


  


   --SELECT GP.GroupCode + ':'+ GP.GroupName AS GroupName FROM tbl_Group AS GP


   --SELECT DISTINCT ASMId,COUNT(ASMId) NoOf FROM tblOrder AS INV GROUP BY ASMId
   

   EXEC(@Query)

 
END
