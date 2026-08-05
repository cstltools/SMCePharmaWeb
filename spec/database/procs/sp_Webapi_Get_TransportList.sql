-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_TransportList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	
	SELECT TransportId ,
           TransportName  FROM dbo.tbl_Transport WHERE IsActive = 1



END

