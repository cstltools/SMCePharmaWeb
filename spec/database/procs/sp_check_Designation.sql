

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_Designation]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
    @DesigName     NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblDesignation WHERE DesigName=@DesigName AND    DesignationId NOT IN ( @id)

END



