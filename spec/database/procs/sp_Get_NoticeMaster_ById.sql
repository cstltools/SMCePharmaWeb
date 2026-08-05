-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
Create PROCEDURE [dbo].[sp_Get_NoticeMaster_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

         SELECT A.NoticeId ,
          A.NoticeTitle ,   
          A.IsActive ,
          A.Announcement ,
          A.FromDate ,
          A.ToDate
	  
		  FROM [dbo].[tbl_Notice_MarketMaster] A
				WHERE A.NoticeId = @id
    END

