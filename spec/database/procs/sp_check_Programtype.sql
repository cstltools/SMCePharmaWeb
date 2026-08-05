
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_Programtype]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
    @ProgramTypeName  NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.tblProgramType WHERE ProgramTypeName=@ProgramTypeName AND    ProgramTypeId NOT IN ( @id)

END


