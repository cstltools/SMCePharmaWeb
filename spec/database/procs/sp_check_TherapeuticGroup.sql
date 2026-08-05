CREATE PROCEDURE [dbo].[sp_check_TherapeuticGroup]
	-- Add the parameters for the stored procedure here
	@id INT ,
    @TherapeuticGroupName     NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblTherapeuticGroup WHERE TherapeuticGroupName=@TherapeuticGroupName  AND  TherapeuticGroupId NOT IN ( @id)

END