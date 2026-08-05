

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_check_ReferInstitution]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
    @Name    NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblReferInstitution WHERE InstitutionName=@Name AND  InstitutionId NOT IN ( @id)

END



