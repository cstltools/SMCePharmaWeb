
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_DoctorCategory]
	-- Add the parameters for the stored procedure here
	  @CategoryId INT = 0 ,
    @CategoryName NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.tblDoctorCategory WHERE CategoryName=@CategoryName AND     CategoryId NOT IN ( @CategoryId)

END


