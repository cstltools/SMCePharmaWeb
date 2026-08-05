-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DCRVisitedWithList]
	-- Add the parameters for the stored procedure here
	@DcrId INT 
AS
BEGIN
	 
	SELECT  dtl.EmpInfoId, emp.EmpMasterCode+' - '+emp.EmpName EmpName
        
             FROM dbo.tbl_DcrVisitedWithDetails dtl with (nolock)
			 left join tblEmpGeneralInfo emp on dtl.EmpInfoId=emp.EmpInfoId

			  WHERE dtl.DcrId = @DcrId
END

