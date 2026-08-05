


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_check_Customer]
	-- Add the parameters for the stored procedure here
	  @id  INT ,@MarketId int,@CellNo nvarchar(max) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblCustMaster WHERE CellNo=@CellNo and  MarketId=@MarketId AND CustomerMasterId NOT IN ( @id)  

END




