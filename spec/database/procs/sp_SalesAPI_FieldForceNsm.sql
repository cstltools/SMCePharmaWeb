CREATE PROCEDURE [dbo].[sp_SalesAPI_FieldForceNsm]
    
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

				SET @Parrameter = 'AND ASMCode =  '''+ @EmpMasterCode +'''';

			END

			else if(@EmpRole = 'MIO')
			BEGIN

				SET @Parrameter = 'AND MIOCode =  '''+ @EmpMasterCode +'''';

			END

			else if(@EmpRole = 'NSM')
			BEGIN

				SET @Parrameter = 'AND NSMCode = '''+ @EmpMasterCode +'''';

			END
			
			SET @Query = 'SELECT DISTINCT NSM.NSMEmpId, NSM.NSMId,NSM.GroupId,NSM.EmpName,NSM.EmpMasterCode FROM View_FieldForceNsm AS NSM WHERE NSM.NSMId IS NOT NULL ' + @Parrameter
			
	
			EXEC (@Query)
    END