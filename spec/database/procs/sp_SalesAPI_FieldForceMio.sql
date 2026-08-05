CREATE PROCEDURE [dbo].[sp_SalesAPI_FieldForceMio]
    
	@EmpRole NVARCHAR(50) ,
    @EmpMasterCode NVARCHAR(50)

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

				SET @Parrameter = 'AND MIOCode =  '''+ @EmpMasterCode +'''';

			END

			else if(@EmpRole = 'NSM')
			BEGIN

				SET @Parrameter = 'AND NSMCode = '''+ @EmpMasterCode +'''';

			END
			
			SET @Query = 'SELECT DISTINCT MIO.MIOEmpId,MIO.MIOId,MIO.TerritoryId,MIO.MIOName AS EmpName,MIO.MIOCode AS EmpMasterCode FROM View_FieldForceMio AS MIO WHERE MIO.MioId IS NOT NULL ' + @Parrameter
			
	
			EXEC (@Query)
    END