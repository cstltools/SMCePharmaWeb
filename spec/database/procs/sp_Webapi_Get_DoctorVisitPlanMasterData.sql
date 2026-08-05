-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctorVisitPlanMasterData]
	-- Add the parameters for the stored procedure here
@empId INT=null,@month INT=null,@year INT=null
AS
BEGIN
	
	SELECT DocTPMaster ,
           MonthValue ,
           YearValue ,
           EmpInfoId ,
           IsFinalSubmit ,
           ApprovalStatus ,
           ApprovedBy ,
           ApprovedDate ,
           FinalSubmitRemarks ,
           ApprovalRemarks FROM dbo.tbl_DoctorTourPlanMaster WHERE EmpInfoId = @empId AND MonthValue = @month AND YearValue = @year


END

