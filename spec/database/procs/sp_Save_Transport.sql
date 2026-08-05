
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_Transport]
	-- Add the parameters for the stored procedure here
	@TransportId INT,
    @TransportName NVARCHAR(MAX),
	@AllowedMilagePerKM decimal(18,2),
	@IsActive BIT,

    @EntryBy NVARCHAR(MAX)

AS
    BEGIN
		if not exists (select TransportName from tbl_Transport where  TransportName=@TransportName)
begin 
        INSERT  INTO [dbo].[tbl_Transport]
                ( TransportName,
				  AllowedMilagePerKM,                   
                  IsActive ,
  
                  EntryBy ,
                  EntryDate 
	            )
        VALUES  ( @TransportName, 
		          @AllowedMilagePerKM,  
                  @IsActive ,
        
                  @EntryBy ,
                  GETDATE() 	
	            )

SELECT SCOPE_IDENTITY()
End
else  Return 0
	
 
		
END


