
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_Transport]
	-- Add the parameters for the stored procedure here
	  @TransportId INT = 0 ,
    @TransportName NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.tbl_Transport WHERE TransportName=@TransportName AND    TransportId NOT IN ( @TransportId)

END


