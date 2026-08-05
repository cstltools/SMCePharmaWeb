-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Update_Prescription]
	-- Add the parameters for the stored procedure here
    @PrescriptionId  INT  ,
    @PrescriptionDate datetime ,
	@PrescriptionTypeId INT,
	@DoctorId int,
    @EntryBy int,
	@UpdateBy NVARCHAR(50) 
AS
    BEGIN
        UPDATE  dbo.tbl_PrescriptionMaster
        SET     
	        	EntryBy = @EntryBy,
	        	DoctorId = @DoctorId,
	        	PrescriptionTypeId=@PrescriptionTypeId,
				PrescriptionDate = @PrescriptionDate,
                UpdateBy = @UpdateBy,
                UpdateDate = GETDATE()
               
        WHERE   PrescriptionId = @PrescriptionId
    END

