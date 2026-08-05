
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_PrescriptionMaster]
	-- Add the parameters for the stored procedure here
	@PrescriptionId INT OUT,
	@PrescriptionDate DATETIME=null,
    @PrescriptionTypeId INT =Null ,
	@DoctorId  INT=null,
	@ImageName NVARCHAR(max) = null, 
	@ImagePath NVARCHAR(max) = null, 
    @EntryBy NVARCHAR(50) =null,
	@ChemberId int =null
AS
    BEGIN
	
       INSERT INTO [dbo].[tbl_PrescriptionMaster]
           ([PrescriptionDate]
           ,[PrescriptionTypeId]
           ,[DoctorId]
           ,[ImagePath]
           ,[ImageName]
           ,[EntryBy]
           ,[EntryDate]
          
           ,[ApprovalStatus],ChemberId
           )
     VALUES
           (@PrescriptionDate 
           ,@PrescriptionTypeId 
           ,@DoctorId ,
           @ImagePath
           ,@ImageName 
           ,@EntryBy 
           ,GETDATE() 
         
        
           ,'Pending' ,@ChemberId
          )

     --SET @PrescriptionId = SCOPE_IDENTITY()

	 SELECT SCOPE_IDENTITY()

END


