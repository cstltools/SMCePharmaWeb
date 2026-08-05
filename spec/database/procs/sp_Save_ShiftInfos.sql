-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_ShiftInfos]
	-- Add the parameters for the stored procedure here
	@ShiftId INT,
    @ShiftText NVARCHAR(MAX) ,
    @ShiftInTime TIME ,
    @ShiftOutTime TIME ,
   
	@IsActive BIT,
	@Activedate DATETIME,
    @EntryBy NVARCHAR(MAX)


AS
    BEGIN

 
	if not exists (select ShiftText from tbl_Shift where ShiftText=@ShiftText)
begin 

INSERT INTO [dbo].[tbl_Shift]
           (ShiftText
           ,[ShiftInTime]
           ,[ShiftOutTime]
           ,[IsActive]
           ,[Activedate]
           ,[EntryBy]
           ,[EntryDate]
           )
     VALUES
           (@ShiftText 
           ,@ShiftInTime 
           ,@ShiftOutTime
           ,@IsActive
           ,@Activedate
           ,@EntryBy
           ,GETDATE() 	
           )
 
SELECT SCOPE_IDENTITY()
End
else  Return 0
	
 
		
END


