CREATE PROCEDURE [dbo].[sp_Get_SAP_StockReceivePendingDataById]
	-- Add the parameters for the stored procedure here
	@StockMovementMasterId INT
AS
BEGIN
  
		--SELECT M.StockMovementMasterId,challan_code, challan_date, CASE WHEN is_from_wharehouse = 1 THEN 'From WH' ELSE FUNT.ComUnitName END AS FromWH,
		--CASE WHEN is_from_wharehouse = 1 THEN 'STO' ELSE 'B2B' END AS ReceiveType,
		--UNT.ComUnitName to_plant_code,PD2.ProductCode,PD2.ProductName,PD2.PackSize,D.quantity,ISNULL(DCS.StockQuantity,0) StockQuantity,ISNULL(UP.UnitPrice,0) UnitPrice,
		--'Pending' action FROM SAP_API_Data..tblSAP_StockMovementMaster AS M
		--LEFT JOIN SAP_API_Data..tblSAP_StockMovementDetail AS D ON M.StockMovementMasterId = D.StockMovementMasterId
		--LEFT JOIN tblProduct AS PD2 ON   SUBSTRING(D.product_code, 13, LEN(D.product_code))= PD2.SAP_Code
		--LEFT JOIN tblUnitPrice AS UP ON PD2.ProductId = UP.ProductId
		--LEFT JOIN tblCompanyUnit AS UNT ON M.to_plant_code = UNT.SAP_Code
		--LEFT JOIN tblCompanyUnit AS FUNT ON M.from_plant_code = FUNT.SAP_Code
		--LEFT JOIN (SELECT ProductCode,ComUnitId,SUM(StockQty) AS StockQuantity FROM tblDCStore AS DC
		--WHERE StockQty > 0 GROUP BY ProductCode,ComUnitId) AS DCS ON UNT.ComUnitId = DCS.ComUnitId AND PD2.ProductCode = DCS.ProductCode
		--WHERE M.StockMovementMasterId = @StockMovementMasterId   and isnull(D.quantity,0)>0 
		--and UP.IsActive=1


		SELECT D.StockMovementDetailId, D.batch_no, M.StockMovementMasterId,challan_code, challan_date, CASE WHEN is_from_wharehouse = 1 THEN 'From WH' ELSE FUNT.ComUnitName END AS FromWH,
		CASE WHEN is_from_wharehouse = 1 THEN 'STO' ELSE 'B2B' END AS ReceiveType,
		UNT.ComUnitName to_plant_code,PD2.ProductCode,PD2.ProductName,PD2.PackSize, case when ISNULL(conQty.ConvertionQty,0)= 0 then  D.quantity else D.quantity/ ISNULL(conQty.ConvertionQty,0) end quantity   ,ISNULL(DCS.StockQuantity,0) StockQuantity,ISNULL(UP.UnitPrice,0) UnitPrice,isnull(StockQuantity,0) StockQuantityChk,
		'Pending' action FROM SAP_API_Data..tblSAP_StockMovementMaster AS M
		LEFT JOIN SAP_API_Data..tblSAP_StockMovementDetail AS D ON M.StockMovementMasterId = D.StockMovementMasterId
		LEFT JOIN tblProduct AS PD2 ON   SUBSTRING(D.product_code, 13, LEN(D.product_code)) = PD2.SAP_Code 

		left join tblConvQty conQty on PD2.ProductCode=conQty.ProductCode
		LEFT JOIN tblUnitPrice AS UP ON PD2.ProductId = UP.ProductId
		LEFT JOIN tblCompanyUnit AS UNT ON M.to_plant_code = UNT.SAP_Code
		LEFT JOIN tblCompanyUnit AS FUNT ON M.from_plant_code = FUNT.SAP_Code
		LEFT JOIN (SELECT DC.ComUnitId,ProductCode,BatchNo,ExpDate,MfgDate,SUM(ISnUll(StockQty,0)) StockQuantity FROM tblDCStore AS DC
		LEFT JOIN tblCompanyUnit AS CS ON DC.ComUnitId = CS.ComUnitId
		WHERE StockQty > 0 AND ComUnitCode IS NOT NULL GROUP BY DC.ComUnitId,ProductCode,BatchNo,ExpDate,MfgDate) AS DCS ON 
		FUNT.ComUnitId = DCS.ComUnitId AND PD2.ProductCode = DCS.ProductCode AND D.batch_no = DCS.BatchNo AND D.manufacturer_date = DCS.MfgDate AND D.expiry_date = DCS.ExpDate
		WHERE M.StockMovementMasterId = @StockMovementMasterId   and isnull(D.quantity,0)>0 
		 

END
          
		   