CREATE PROCEDURE [dbo].[sp_SalesAPI_FieldForceGroup]
    
	@EmpRole NVARCHAR(50) ,
    @EmpMasterCode NVARCHAR(50)

AS
    BEGIN

			DECLARE @Parrameter NVARCHAR(MAX)='';
  	        DECLARE @Query NVARCHAR(MAX);


			if(@EmpRole = 'RSM')
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
			
			SET @Query = 'SELECT DISTINCT GP.GroupId,GP.GroupName FROM View_FieldForceGroup AS GP WHERE GP.GroupId IS NOT NULL ' + @Parrameter
			
	
			EXEC (@Query)
    END