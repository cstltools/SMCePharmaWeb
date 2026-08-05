
CREATE PROCEDURE [dbo].[sp_GET_AllArea]   -- exec sp_GET_AllArea
	-- Add the parameters for the stored procedure here
   --@FinancialYearId NVARCHAR(max),
   --  @Month NVARCHAR(max),
   --     @ZoneId NVARCHAR(max) ,
   --             @AreaId NVARCHAR(max)  
AS
BEGIN

	SELECT RegionId,AreaId,AreaName FROM tblArea
END