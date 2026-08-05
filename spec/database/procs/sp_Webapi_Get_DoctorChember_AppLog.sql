-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctorChember_AppLog]
	-- Add the parameters for the stored procedure here
	@doctorId INT 
AS
BEGIN
	 
	SELECT ChamberTypeId   , chm.ChamberName ChamberTypeName,
           Name AS ChamberName 
        
             FROM dbo.tblDoctorChemberDetail
			 left join tblDoctorChamber chm on chm.ChamberId=tblDoctorChemberDetail.ChamberTypeId

			  WHERE DoctorId = @doctorId  
END

