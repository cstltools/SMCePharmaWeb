-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Get_ProgramType]
	-- Add the parameters for the stored procedure here
AS
    BEGIN
		
        SELECT  ProgramTypeId ,
                ProgramTypeName
        FROM    dbo.tblProgramType
        WHERE   IsActive = 1


    END

