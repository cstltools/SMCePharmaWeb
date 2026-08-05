
create PROCEDURE [dbo].[sp_Get_DDLDANameByDCID]
	-- Add the parameters for the stored procedure here
	@depoId INT = NULL
AS
BEGIN
   

   SELECT DAId  Value,DACode+' : '+ Name TextField  	  
		  FROM  tblDAInfo  	 with (nolock)  where ComUnitId=@depoId
END

