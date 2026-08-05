-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
Create  PROCEDURE [dbo].[sp_Get_RouterMaster_ByRouterMasterId]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

Select RouterMasterId, RouterName from RouterMaster where RouterMasterId = @id

END


