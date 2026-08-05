
CREATE PROCEDURE [dbo].[sp_Get_SAP_StockReceivePendingData]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)
AS
BEGIN
  
		--SELECT *  FROM SAP_API_Data..tblSAP_StockMovementMaster

		SELECT M.StockMovementMasterId,challan_code, challan_date, CASE WHEN is_from_wharehouse = 1 THEN 'From WH' ELSE FUNT.ComUnitName END AS FromWH,
		ISNULL(from_plant_code,'N/A') from_plant_code, UNT.ComUnitName to_plant_code,ProductAndQuantity,
		'Pending' action FROM SAP_API_Data..tblSAP_StockMovementMaster AS M
		LEFT JOIN tblCompanyUnit AS UNT ON M.to_plant_code = UNT.SAP_Code
		LEFT JOIN tblCompanyUnit AS FUNT ON M.from_plant_code = FUNT.SAP_Code
		LEFT JOIN (SELECT
		  StockMovementMasterId,
		  STUFF((
		    SELECT '; ' + CONCAT(ProductName, ' - ', quantity)
		    FROM SAP_API_Data..tblSAP_StockMovementDetail AS D2
		    LEFT JOIN tblProduct AS PD2 ON D2.product_code = PD2.SAP_Code
		    WHERE D2.StockMovementMasterId = D.StockMovementMasterId
		    FOR XML PATH(''), TYPE
		  ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS ProductAndQuantity
		FROM SAP_API_Data..tblSAP_StockMovementDetail AS D
		GROUP BY StockMovementMasterId) AS D ON M.StockMovementMasterId = D.StockMovementMasterId
		WHERE to_plant_code IS NOT NULL AND( (ISNULL(IsReceived,0) = 0 AND is_from_wharehouse = 1) OR (ISNULL(IsReceived,0) = 0 AND from_plant_code IS NOT NULL))


END
          
		  
		  
--SELECT challan_code, challan_date, CASE WHEN is_from_wharehouse = 1 THEN 'From WH' END AS FromWH,
--ISNULL(from_plant_code,'N/A') from_plant_code,to_plant_code,ProductAndQuantity FROM SAP_API_Data..tblSAP_StockMovementMaster AS M
--LEFT JOIN (SELECT
--  StockMovementMasterId,
--  STUFF((
--    SELECT ' | ' + CONCAT(ProductName, ' - ', quantity)
--    FROM SAP_API_Data..tblSAP_StockMovementDetail AS D2
--    LEFT JOIN tblProduct AS PD2 ON D2.product_code = PD2.SAP_Code
--    WHERE D2.StockMovementMasterId = D.StockMovementMasterId
--    FOR XML PATH(''), TYPE
--  ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS ProductAndQuantity
--FROM SAP_API_Data..tblSAP_StockMovementDetail AS D
--GROUP BY StockMovementMasterId) AS D ON M.StockMovementMasterId = D.StockMovementMasterId
--WHERE IsReceived = 0
