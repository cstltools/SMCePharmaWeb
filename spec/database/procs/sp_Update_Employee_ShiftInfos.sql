-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_Employee_ShiftInfos]
	-- Add the parameters for the stored procedure here
 

	@ShiftId INT = 0 ,
    @ShiftText NVARCHAR(MAX) ,
    @ShiftInTime TIME ,
    @ShiftOutTime TIME ,
   
	@IsActive BIT,
	@Activedate DATETIME,
	@UpdateBy NVARCHAR(50) 
AS
    BEGIN

      UPDATE [dbo].[tbl_Shift]
   SET [ShiftText] = @ShiftText 
      ,[ShiftInTime] = @ShiftInTime 
      ,[ShiftOutTime] = @ShiftOutTime 
      ,[IsActive] = @IsActive 
      ,[Activedate] = @Activedate 
     
      ,[UpdateBy] = @UpdateBy 
      ,[UpdateDate] = GETDATE()
        WHERE    ShiftId = @ShiftId


    END


