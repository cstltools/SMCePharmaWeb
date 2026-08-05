-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_NoticeMaster]
	-- Add the parameters for the stored procedure here
	@NoticeId INT,
    @NoticeTitle nvarchar (max),
	@Announcement nvarchar(max),
	@FromDate datetime,
    @ToDate datetime,
	@EntryBy nvarchar(50)


AS
    BEGIN
	
        INSERT  INTO [dbo].[tbl_Notice_MarketMaster]
                ( NoticeTitle ,                
                  Announcement,
                  FromDate ,
		          ToDate,
				  IsActive,
                  EntryBy ,
                  EntryDate 
	            )
        VALUES  ( @NoticeTitle ,              
                  @Announcement ,
                  @FromDate,
				  @ToDate,
				  1,
				  @EntryBy,		
                  GETDATE() 	
	            )

SELECT SCOPE_IDENTITY()

END

