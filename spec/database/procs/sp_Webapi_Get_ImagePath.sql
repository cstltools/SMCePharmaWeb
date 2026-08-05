-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_ImagePath]
	-- Add the parameters for the stored procedure here
@type NVARCHAR(50)
AS
BEGIN
	SELECT ImagePathId ,
           ImageType ,
           ImagePreName ,
           IsActive ,
           ImagePath FROM dbo.tbl_ImagePath_Setting WHERE ImageType = @type
END

