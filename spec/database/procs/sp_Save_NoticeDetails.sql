
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_NoticeDetails]
	-- Add the parameters for the stored procedure here
	@NoticeDetailsId INT,
    @NoticeId INT,
	@RegionId INT,
	@AreaId INT,
    @TerritoryId INT,
	@MarketId INT,
	@GroupId INT


AS
    BEGIN
	
        INSERT  INTO [dbo].[tbl_Notice_MarketDetails]
                ( NoticeId ,                
                  RegionId,
                  AreaId ,
		          TerritoryId,
				  MarketId,
                  GroupId 
                 
	            )
        VALUES  ( @NoticeId ,              
                  @RegionId ,
                  @AreaId,
				  @TerritoryId,
				  @MarketId,
				  @GroupId		            
	            )

SELECT SCOPE_IDENTITY()

END


