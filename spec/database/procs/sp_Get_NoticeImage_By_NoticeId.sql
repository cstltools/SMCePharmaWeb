-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
create PROCEDURE [dbo].[sp_Get_NoticeImage_By_NoticeId]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN
	      
   Select * from tbl_Notice_Image  where NoticeId = @id

   --Delete from tbl_Notice_Image where NoticeId = @id

   END

