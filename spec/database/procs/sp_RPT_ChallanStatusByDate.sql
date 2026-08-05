CREATE PROCEDURE [dbo].[sp_RPT_ChallanStatusByDate]
    @Month INT,
    @Year  INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        FORMAT(clnM.ChalanDate, 'dd-MMM-yyyy') AS ChalanDate,
        clnM.ChalanNo,
        CASE WHEN ISNULL(clnM.SAP_ChallanSend, 0) = 1 THEN 'Yes' ELSE 'No' END AS SAP_ChallanSend,
        CASE WHEN ISNULL(clnM.SAP_Challan_ConfirmationSend, 0) = 1 THEN 'Yes' ELSE 'No' END AS SAP_ChallanRecevie
    FROM tblChalanInfo clnM
    INNER JOIN tblChalanDetail clnD 
        ON clnD.ChalanId = clnM.ChalanId
    WHERE YEAR(clnM.ChalanDate)  = @Year
      AND MONTH(clnM.ChalanDate) = @Month
    ORDER BY clnM.ChalanDate, clnM.ChalanNo;
END
