
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Delete_Transport]
	-- Add the parameters for the stored procedure here
    @TransportId INT = 0 ,
    @DeleteBy NVARCHAR(50)
AS
    BEGIN

        UPDATE [dbo].[tbl_Transport]
        SET     
                DeleteBy = @DeleteBy ,
                DeleteDate = GETDATE() ,
				IsDelate = 1                     
        WHERE   TransportId = @TransportId    
    END


