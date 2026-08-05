
CREATE PROCEDURE [dbo].[sp_GET_AllRegion]   -- exec sp_GET_AllRegion
	-- Add the parameters for the stored procedure here
   --@FinancialYearId NVARCHAR(max),
   --  @Month NVARCHAR(max),
   --     @ZoneId NVARCHAR(max) ,
   --             @AreaId NVARCHAR(max)  
AS
BEGIN

	SELECT RegionId,RegionName FROM tblRegion
END