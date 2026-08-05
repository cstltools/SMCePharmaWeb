

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_RouteInformationMArket]
	-- Add the parameters for the stored procedure here
	 @id     NVARCHAR(MAX) ,
      @Name     NVARCHAR(MAX) ,
      @Status     NVARCHAR(MAX) 

AS
BEGIN

if(@Status='Entry')
begin 
		 
	SELECT * FROM dbo.tblRouteInformationMarketDetail WHERE MarketId  in (select * from fnSplit(@Name,','))

	end 
	else 
	begin
	SELECT * FROM dbo.tblRouteInformationMarketDetail WHERE MarketId   in (select * from fnSplit(@Name,',')) AND  RouteInformationMasterId NOT IN ( @id)

	end
END



