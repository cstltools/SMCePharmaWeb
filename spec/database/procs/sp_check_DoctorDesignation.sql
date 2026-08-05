
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_DoctorDesignation]
	-- Add the parameters for the stored procedure here
	  @DesignationId INT = 0 ,
    @DesignationName NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.tblDoctorDesignation WHERE DesignationName=@DesignationName AND    DesignationId NOT IN ( @DesignationId)

END


