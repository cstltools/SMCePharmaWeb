-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_DoctorMarketDetail]
	-- Add the parameters for the stored procedure here

	@DoctorId INT,
	@SubmarketId INT,
	@IsTopDoctor BIT ,@IsDCRAllowed BIT

AS
BEGIN
	
	
	INSERT INTO [dbo].[tblDoctorMarketDetail]
           (DoctorId
           ,SubmarketId,IsTopDoctor,IsDCRAllowed)
     VALUES
           (@DoctorId
           ,@SubmarketId,@IsTopDoctor,@IsDCRAllowed)

END

