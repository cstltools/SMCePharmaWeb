


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_CustomerCategory]
	-- Add the parameters for the stored procedure here

AS
BEGIN
    

	Select * from tblCustomerCategory A  WITH (NOLOCK)  order by CustomerCategory


END




