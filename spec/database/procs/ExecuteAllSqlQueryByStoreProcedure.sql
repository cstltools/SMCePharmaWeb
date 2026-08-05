CREATE PROCEDURE [dbo].[ExecuteAllSqlQueryByStoreProcedure]
	-- Add the parameters for the stored procedure here
	@Query NVARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	EXEC (@Query)
END
