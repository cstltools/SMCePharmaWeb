
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Delete_NoticeMaster]
	-- Add the parameters for the stored procedure here
    @NoticeId INT 
   
AS
    BEGIN

	Delete from tbl_Notice_MarketMaster where NoticeId = @NoticeId

	Delete from dbo.tbl_Notice_MarketDetails where NoticeId = @NoticeId

    END
