-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_DDLDAName]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   

   SELECT DAId  Value,DACode+' : '+ Name TextField  	  
		  FROM  tblDAInfo  	 with (nolock)
END
