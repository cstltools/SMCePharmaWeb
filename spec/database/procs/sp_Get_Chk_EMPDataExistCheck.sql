
CREATE PROCEDURE [dbo].[sp_Get_Chk_EMPDataExistCheck]
	-- Add the parameters for the stored procedure here
	@EmpCode nvarchar(max),
	@MonthValue nvarchar(max),
	@YearValue nvarchar(max)


AS
BEGIN



select * from tblTerritoryDataMigration  where   LTRIM(RTRIM(TerritoryCode))= LTRIM(RTRIM(@EmpCode)) and MonthName=@MonthValue and  YearValue=@YearValue
 

  end 

			  