-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctorChamberByDocId]
	-- Add the parameters for the stored procedure here
	@doctorId INT 
AS
BEGIN
	SELECT ChemberId AS ChamberId ,
           LTRIM(rtrim(Name)) AS ChamberName,
           isnull(Phone,'') Phone ,
           isnull(Address,'') Address FROM dbo.tblDoctorChemberDetail WHERE DoctorId = @doctorId AND Name<>'' 
END

