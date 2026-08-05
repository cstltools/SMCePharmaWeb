
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Get_PrescriptionType_For_DDL]
	-- Add the parameters for the stored procedure here

AS
BEGIN
    
	SELECT * FROM tbl_PrescriptionType 
	
	--SELECT * FROM tbl_PrescriptionType WHERE IsActive = 1

END


