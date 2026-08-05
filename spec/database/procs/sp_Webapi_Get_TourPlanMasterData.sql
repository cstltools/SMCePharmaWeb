-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Get_TourPlanMasterData]
	-- Add the parameters for the stored procedure here
@empId INT=null,@month INT=null,@year INT=null
AS
BEGIN
	
	SELECT mas.TPMaster,
           MonthValue ,
           YearValue ,
           EmpInfoId ,
           IsFinalSubmit ,
           ApprovalStatus ,
           ApprovedBy ,
           ApprovedDate ,
           FinalSubmitRemarks ,
           ApprovalRemarks FROM dbo.tbl_TourPlanMaster mas WHERE EmpInfoId = @empId AND MonthValue = @month AND YearValue = @year


END

