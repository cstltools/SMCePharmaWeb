-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_DoctorSpecialDayDetail]
	-- Add the parameters for the stored procedure here
@pk INT,
@SpecialDayId INT = NULL,
@SpeciaDateStr datetime = NULL
AS
BEGIN
	
	INSERT INTO dbo.tblDoctorSpecialDayDetail
	        ( DoctorId ,
	          SpecialDayId ,
	          SpecialDate
	        )
	VALUES  ( @pk,
	@SpecialDayId,
	@SpeciaDateStr
	        )
END

