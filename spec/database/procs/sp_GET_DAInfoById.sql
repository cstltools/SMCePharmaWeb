

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GET_DAInfoById]
    
	@Parameter NVARCHAR(MAX)


AS
BEGIN


  SELECT * FROM tblDAInfo WHERE DAId = @Parameter

END



