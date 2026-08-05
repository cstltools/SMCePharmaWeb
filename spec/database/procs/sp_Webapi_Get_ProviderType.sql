CREATE PROCEDURE [dbo].[sp_Webapi_Get_ProviderType] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT d.ProgramTypeId ProviderTypeId, d.ProgramTypeName ProviderType,case when   d.IsCustomer=1 then 1 else 0 end forCustomer,   case when d.isDoctor=1 then 1 else 0 end forDoctor
			    FROM tblProgramType d with (nolock) WHERE IsActive = 1


END

