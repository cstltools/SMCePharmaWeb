-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Save_DoctorChemberDetail]
	-- Add the parameters for the stored procedure here
@pk INT,
@ChamberTypeId INT = NULL,
@Name NVARCHAR(max) = NULL
AS
BEGIN
	
	INSERT INTO dbo.tblDoctorChemberDetail
	        ( DoctorId ,
	          ChamberTypeId ,
	          Name
	        )
	VALUES  ( @pk,
	@ChamberTypeId,
	@Name
	        )
END

