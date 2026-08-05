CREATE PROCEDURE [dbo].[sp_Webapi_Get_SMCType] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
		 
		 SELECT top 1 0 SMCTypeId,'Select' SMCType,     1 forCustomer,       1   forDoctor
			    FROM tblSMCType d 
				union all
		SELECT d.SMCTypeId SMCTypeId, d.SMCType SMCType,case when   d.forCustomer=1 then 1 else 0 end forCustomer,   case when d.forDotor=1 then 1 else 0 end forDoctor
			    FROM tblSMCType d with (nolock) WHERE IsActive = 1


END

