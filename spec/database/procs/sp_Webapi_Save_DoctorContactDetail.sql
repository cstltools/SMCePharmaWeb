-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Save_DoctorContactDetail]
	-- Add the parameters for the stored procedure here
@pk INT,
@ContactTypeId INT = NULL,
@Contact NVARCHAR(max) = NULL
AS
BEGIN
	
	INSERT INTO dbo.tblDoctorContactDetail
	        ( DoctorId ,
	          ContactTypeId ,
	          Contact
	        )
	VALUES  ( @pk,
	@ContactTypeId,
	@Contact
	        )
END

