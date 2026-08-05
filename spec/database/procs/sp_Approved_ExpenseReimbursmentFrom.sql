

CREATE PROCEDURE [dbo].[sp_Approved_ExpenseReimbursmentFrom]
 @ReimbursementMasterId nvarchar(max),
 @status nvarchar(max),
 @UpdateBy nvarchar(max)

AS
BEGIN


--UPDATE tbl_ReimbursmentFormMaster_HealthCare SET ActionStatus =@status, ApprovedBy=@UpdateBy, ApprovedDate=GETDATE() Where ReimbursFromMasterId in( select * from   fnSplit(@ReimbursementMasterId,','))

UPDATE tbl_ReimbursmentFormMaster_HealthCare SET ActionStatus =@status, ApprovedBy=@UpdateBy, ApprovedDate=GETDATE() Where ReimbursFromMasterId = @ReimbursementMasterId

END