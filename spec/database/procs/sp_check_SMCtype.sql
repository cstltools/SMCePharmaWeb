
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_check_SMCtype]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
    @ProgramTypeName  NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.tblSMCType WHERE SMCType=@ProgramTypeName AND    SMCTypeId NOT IN ( @id)

END


