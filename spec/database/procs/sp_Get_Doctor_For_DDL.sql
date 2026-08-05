
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Get_Doctor_For_DDL]
	-- Add the parameters for the stored procedure here

AS
BEGIN
    
	SELECT * FROM tblDoctorMaster 
	
	--SELECT * FROM tbl_PrescriptionType WHERE IsActive = 1

END


