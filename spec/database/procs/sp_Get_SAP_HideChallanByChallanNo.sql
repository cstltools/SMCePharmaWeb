create PROCEDURE [dbo].[sp_Get_SAP_HideChallanByChallanNo]
	-- Add the parameters for the stored procedure here
	@ChallanNo nvarchar(max)
AS
BEGIN
  
		 
		DECLARE @IsFromWH BIT = 0
	SELECT @IsFromWH = ISNULL(is_from_wharehouse,0) FROM SAP_API_Data..tblSAP_StockMovementMaster WHERE UPPER(RTRIM(LTRIM(challan_code))) =  UPPER(RTRIM(LTRIM(@ChallanNo)))

	DECLARE @IsB2B BIT = 0
	SELECT @IsB2B = CASE WHEN from_plant_code != '' and  from_plant_code is not null THEN 1 else 0 END FROM SAP_API_Data..tblSAP_StockMovementMaster WHERE UPPER(RTRIM(LTRIM(challan_code))) =  UPPER(RTRIM(LTRIM(@ChallanNo)))


IF(@IsFromWH = 1 AND @IsB2B = 0)
	BEGIN
	select distinct IssueChalanNo from tblStockInTransfar
inner join tblRequisition on tblStockInTransfar.ReqId=tblRequisition.ReqId where   UPPER(RTRIM(LTRIM(IssueChalanNo))) =  UPPER(RTRIM(LTRIM(@ChallanNo)))
	end

	ELSE IF(@IsFromWH = 0 AND @IsB2B = 1)
	BEGIN
	select ChalanNo from tblChalanInfo where   UPPER(RTRIM(LTRIM(ChalanNo))) =  UPPER(RTRIM(LTRIM(@ChallanNo)))
	end

END
          
		   