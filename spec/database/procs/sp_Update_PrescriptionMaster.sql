
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 CREATE PROCEDURE [dbo].[sp_Update_PrescriptionMaster]
	-- Add the parameters for the stored procedure here
 @PrescriptionId INT,
	@PrescriptionDate DATETIME=null,
    @PrescriptionTypeId INT =Null ,
	@DoctorId  INT=null,
	@ImageName  NVARCHAR(max)=null, 
	@UpdateBy NVARCHAR(50) ,
	@EntryBy NVARCHAR(50) ,
	@ChemberId int =null
AS
    BEGIN
        
UPDATE [dbo].[tbl_PrescriptionMaster]
   SET [PrescriptionDate] = @PrescriptionDate 
      ,[PrescriptionTypeId] = @PrescriptionTypeId 
      ,[DoctorId] = @DoctorId 
    
      ,[ImageName] = @ImageName 
      ,EntryBy = @EntryBy

      
      ,[UpdateBy] = @UpdateBy 
      ,[UpdateDate] = GETDATE() ,ChemberId=@ChemberId
      
 WHERE  PrescriptionId=@PrescriptionId
		Delete from tbl_PrescriptionProductDetail where PrescriptionId = @PrescriptionId
    END


