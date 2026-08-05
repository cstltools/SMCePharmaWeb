-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 CREATE PROCEDURE [dbo].[sp_Update_NoticeMaster]
	-- Add the parameters for the stored procedure here
    @NoticeId  INT,
    @NoticeTitle NVARCHAR(MAX) ,
    @Announcement NVARCHAR(MAX),
    @FromDate DATETIME,
	@ToDate DATETIME,

	@UpdateBy NVARCHAR(50)

   
AS
    BEGIN

        UPDATE  dbo.tbl_Notice_MarketMaster
        SET     NoticeTitle = @NoticeTitle,
		        Announcement = @Announcement,
				FromDate = @FromDate,
				ToDate = @ToDate,
		
                UpdateBy = @UpdateBy,
                UpdateDate = GETDATE()                         
        WHERE   NoticeId = @NoticeId

		Delete From dbo.tbl_Notice_MarketDetails where NoticeId = @NoticeId
		Delete From dbo.tblNoticeUserRoleDetail where NoticeId = @NoticeId
	 Delete From dbo.tblNotice_Employee where MasterId = @NoticeId

    END

