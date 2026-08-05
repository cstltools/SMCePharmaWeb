-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 Create PROCEDURE [dbo].[sp_DEL_NoticeImage]
	-- Add the parameters for the stored procedure here
    @NoticeId INT 
AS
    BEGIN

    Delete from tbl_Notice_Image where NoticeId =@NoticeId
		
END


