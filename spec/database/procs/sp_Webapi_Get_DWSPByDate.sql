-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DWSPByDate]
	-- Add the parameters for the stored procedure here
    @cDate DATETIME ,
    @empId INT
AS
    BEGIN
	

        SELECT  B.DWSPDetailId ,
                CONVERT(NVARCHAR(50), B.DWSPDate,106) AS DWSPDate,
				B.FCBAmount,
				B.GeneralAmount,
				B.CampaignAmount
        FROM    dbo.tbl_DWSPMaster A
                INNER JOIN dbo.tbl_DWSPDetail B ON B.DWSPMasterId = A.DWSPMasterId
               
                AND CONVERT(Date,B.DWSPDate) = CONVERT(Date,@cDate)
                AND A.EmpInfoId = @empId
				 


    END

