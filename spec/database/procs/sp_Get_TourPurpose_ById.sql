
CREATE PROCEDURE [dbo].[sp_Get_TourPurpose_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

         SELECT [TPId]
      ,[TPName]
      ,[IsActive]
      ,[Activedate]
      ,[EntryBy]
      ,[EntryDate]
      ,[UpdateBy]
      ,[UpdateDate]
      ,[IsDelate]
      ,[DeleteBy]
      ,[DeleteDate]
      ,[IsExtraBenifit]
      ,isnull([MIOAmount],0) [MIOAmount]
      ,isnull([AMAmount],0) [AMAmount]
      ,isnull([DZSMAmount],0) [DZSMAmount]
      ,isnull([IsMarketVisit],0) [IsMarketVisit]
      ,isnull([IsOtherVisit],0)	   [IsOtherVisit]
		  FROM  tbl_TourPlanPurpose A
				WHERE A.TPId = @id

    END
