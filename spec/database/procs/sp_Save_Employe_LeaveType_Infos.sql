

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_Employe_LeaveType_Infos]
	-- Add the parameters for the stored procedure here
	@LeaveTypeId INT,
    @LeaveTypeName NVARCHAR(500) =null,
	@LeaveDays INT =null,
	@IsActive BIT = null,
    @EntryBy INT =null
AS
    BEGIN

if not exists (select LeaveTypeName from Employe_LeaveTypeInfos where LeaveTypeName=@LeaveTypeName)
begin
        INSERT  INTO [dbo].[Employe_LeaveTypeInfos]
                ( LeaveTypeName,
				  LeaveDays,                   
                  IsActive,       
                  EntryBy,
                  EntryDate 
	            )
        VALUES  ( @LeaveTypeName,   
		          @LeaveDays,        
                  @IsActive,             
                  @EntryBy ,
                  GETDATE() 	
	            )
SELECT SCOPE_IDENTITY()
End
else  Return 0
END



