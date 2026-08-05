-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_Customer_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   

   SELECT CustomerMasterId  Value, CustomerCode+' ; '+CustomerName TextField  	  
		  FROM  tblCustMaster  	 with (nolock) where IsActive=1
END
