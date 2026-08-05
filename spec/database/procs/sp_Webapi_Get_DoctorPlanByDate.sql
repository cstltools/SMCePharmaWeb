-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctorPlanByDate]
	-- Add the parameters for the stored procedure here
    @cDate DATETIME ,
    @empId INT
AS
    BEGIN
	

        SELECT  B.DocTPDetailsId ,
                CONVERT(NVARCHAR(50), B.TourPlanDate,106) AS TpDate,
				C.DoctorCode,
				C.DoctorName,
				C.DoctorId
        FROM    dbo.tbl_DoctorTourPlanMaster A
                INNER JOIN dbo.tbl_DoctorTourPlanDetail B ON B.DocTPMaster = A.DocTPMaster
                INNER JOIN dbo.tblDoctorMaster C ON C.DoctorId = B.DoctorId
        WHERE   A.ApprovalStatus = 'Approved'
                AND B.TourPlanDate = @cDate
                AND A.EmpInfoId = @empId
				AND B.IsDcrDone = 0


    END

