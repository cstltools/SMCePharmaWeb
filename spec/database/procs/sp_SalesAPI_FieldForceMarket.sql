
CREATE PROCEDURE [dbo].[sp_SalesAPI_FieldForceMarket]
    
	
    @EmpMasterCode NVARCHAR(500),
	@EmpRole NVARCHAR(50) 

AS
    BEGIN

			DECLARE @Parrameter NVARCHAR(MAX)='';
  	        DECLARE @Query NVARCHAR(MAX);


			if(@EmpRole = 'DZSM')
			BEGIN

				SET @Parrameter = 'AND RSMCode = '''+ @EmpMasterCode +'''';

			END

			else if(@EmpRole = 'AM')
			BEGIN

				SET @Parrameter = 'AND ASMCode = '''+ @EmpMasterCode +'''';

			END

			else if(@EmpRole = 'MIO')
			BEGIN

				SET @Parrameter = 'AND MIOCode = '''+ @EmpMasterCode +'''';

			END

			else if(@EmpRole = 'NSM')
			BEGIN

				SET @Parrameter = 'AND NSMCode =  '''+ @EmpMasterCode +'''';

			END
			
			SET @Query = 'SELECT distinct MKT.MarketId,MKT.MarketName,MKT.SubTerritoryId FROM View_FieldForceMarket AS MKT with (nolock) WHERE MKT.MarketId IS NOT NULL ' + @Parrameter
			
	
			EXEC (@Query)
    END