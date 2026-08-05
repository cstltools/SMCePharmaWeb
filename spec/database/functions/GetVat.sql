CREATE FUNCTION [dbo].[GetVat] (
    @FromDate DATETIME=null,
	@ToDate DATETIME=null,
	@IssueChalanNo NVARCHAR(max)=null
)
RETURNS TABLE
AS
RETURN
    

SELECT 
req.IssueChalanNo															AS ID						  
, '001'																	    AS Branch_Code				  
, com.ComUnitName															AS Customer_Name			  
, ISNULL(com.ComUnitCode, '-')												AS Customer_Code			  
, com.Address																AS Delivery_Address			  
, '-'																		AS Vehicle_No
, '-' 																		AS VehicleType				  
, CAST(req.IssuChalanDate AS varchar(20)) 									AS Invoice_Date_Time		  
, CAST(req.IssuChalanDate AS varchar(20)) 									AS Delivery_Date_Time		  
, req.IssueChalanNo 														AS Reference_No				  
, '-' 																		AS Comments					  
, 'New' 																	AS Sale_Type				  
, '' 																		AS Previous_Invoice_No		  
, 'N' 																		AS Is_Print					  
, '0' 																		AS Tender_Id				  
, 'Y' 																		AS Post						  
, 'NA' 																		AS LC_Number				  
, 'BDT' 																	AS Currency_Code			  
, sit.ProductCode 															AS Item_Code				  
, sit.ProductName 															AS Item_Name				  
, ISNULL(NULLIF (sit.PackSize, '&nbsp;'), 'PACK') 							AS UOM						  
, sit.Quantity																AS Quantity					  
, sit.PriceAmount / sit.Quantity 											AS NBR_Price				  
, ROUND(ISNULL(sit.VATAmount, 0) / sit.PriceAmount * 100, 5) 				AS VAT_Rate					  
, 0 																		AS SD_Rate					  
, sit.PriceAmount 															AS SubTotal					  
, sit.VATAmount 															AS VAT_Amount				  
, sit.TotalPriceAmount 														AS TotalValue				  
, 'N' 																		AS Non_Stock				  
, 0 																		AS Trading_MarkUp
, CASE WHEN (isnull(sit.VATAmount, 0) / sit.PriceAmount) * 100 >= 15 THEN 'VAT' 
WHEN (isnull(sit.VATAmount, 0) / sit.PriceAmount) * 100 = 0 THEN 'NonVAT' 
WHEN (isnull(sit.VATAmount, 0) / sit.PriceAmount) * 100 >= 0 AND (isnull(sit.VATAmount, 0) / sit.PriceAmount) * 100 < 15 THEN 'OtherRate' 
END 																		AS Type						  
, 0 																		AS Discount_Amount			  
, 0 																		AS Promotional_Quantity		  
, 'VAT 4.3' 																AS VAT_Name	
, 'Other'                                                                   AS TransactionType	
, 'SMC'			                                                            AS CompanyCode
, 'Pharma'                                                                  AS DataSource
FROM	dbo.tblRequisition AS req 
LEFT OUTER JOIN	dbo.tblCompanyUnit AS com ON req.ComUnitId = com.ComUnitId 
LEFT OUTER JOIN dbo.tblStockInTransfar AS sit ON sit.ReqId = req.ReqId
WHERE    (    (1 = 1) AND (req.IssuChalanDate >= '2021-Dec-01')
AND ISNULL(sit.Quantity,0) > 0 AND ISNULL(sit.PriceAmount,0) > 0)

and ((req.IssuChalanDate >= @FromDate and req.IssuChalanDate <= @ToDate))
 or (req.IssueChalanNo=@IssueChalanNo)


