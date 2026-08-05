-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_Prescription]
	-- Add the parameters for the stored procedure here
	@PrescriptionId INT,
    @PrescriptionDate datetime ,
	@PrescriptionTypeId INT,
	@DoctorId int,
    @EntryBy int
	--@ImagePath NVARCHAR(Max),
	--@ImageName NVARCHAR(MAx)

AS
    BEGIN
	
        INSERT  INTO [dbo].[tbl_PrescriptionMaster]
                ( PrescriptionDate ,                
                  PrescriptionTypeId,
                  DoctorId ,
				  --ImagePath,
				  --ImageName,
                  EntryBy ,
                  EntryDate 
	            )
        VALUES  ( @PrescriptionDate ,              
                  @PrescriptionTypeId ,
                  @DoctorId,
				  --@ImagePath,
				  --@ImageName,
                  @EntryBy ,
                  GETDATE() 	
	            )

SELECT SCOPE_IDENTITY()

END

