

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
CREATE PROCEDURE [dbo].[sp_Get_Notice_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

        Select  (SELECT LTRIM(RTRIM(ImagePath+'\'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType='Notice')AS ImagePreName ,format(FromDate,'dd MMMM, yyyy') FromDate,format(ToDate,'dd MMMM, yyyy') ToDate, STUFF( (SELECT CONCAT(',', brn.UserRoleID , '') FROM dbo.tblNoticeUserRoleDetail brn  with (nolock)   WHERE brn.NoticeId=mas.NoticeId ORDER BY brn.UserRoleID FOR XML PATH ('') ),1,1,'') AS UserRoleID, * from tbl_Notice_MarketMaster mas with (nolock) where NoticeId = @id

    END


