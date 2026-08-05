
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_NoticeMaster]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
 SELECT A.NoticeId,A.NoticeTitle,A.Announcement,A.IsActive, CONVERT(NVARCHAR(50),A.FromDate,106)AS FromDate, CONVERT(NVARCHAR(50),A.ToDate,106)AS ToDate   from tbl_Notice_MarketMaster A order by A.EntryDate desc

END

