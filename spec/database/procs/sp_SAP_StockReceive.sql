CREATE PROCEDURE [dbo].[sp_SAP_StockReceive] 

	@ChallanNo NVARCHAR(500),
	@ApproveBy INT
	
AS
BEGIN


	--SELECT * FROM tblCompanyUnit
	
	DECLARE @IsFromWH BIT = 0
	SELECT @IsFromWH = ISNULL(is_from_wharehouse,0) FROM SAP_API_Data..tblSAP_StockMovementMaster WHERE UPPER(RTRIM(LTRIM(challan_code))) =  UPPER(RTRIM(LTRIM(@ChallanNo)))

	DECLARE @IsB2B BIT = 0
	SELECT @IsB2B = CASE WHEN from_plant_code != '' and  from_plant_code is not null THEN 1 else 0 END FROM SAP_API_Data..tblSAP_StockMovementMaster WHERE UPPER(RTRIM(LTRIM(challan_code))) =  UPPER(RTRIM(LTRIM(@ChallanNo)))


	--PRINT @IsB2B
	--PRINT @IsFromWH

	--============================= For STO ===================================== 

	IF(@IsFromWH = 1 AND @IsB2B = 0)
	BEGIN

		--================================================================== FOR WH Stock In ======================================================================================

		-- Save WH Stock In Master

		DECLARE	@WHStockinMasterId int = 0

		EXEC @WHStockinMasterId = [dbo].[sp_SAP_WhStockInMaster]
		@ChallanNo = @ChallanNo


		-- Save WH Stock In Details

		IF(@WHStockinMasterId > 0)
		BEGIN
			
			EXEC [dbo].[sp_SAP_WhStockInDetails]
				 @MasterId = @WHStockinMasterId,
				 @ChallanNo = @ChallanNo


			-- WH Stock In Approval

			EXEC [dbo].[sp_SAP_WHStockInApprove]
				 @WHMasterInId = @WHStockinMasterId



			--================================================================== FOR STO ======================================================================================

			DECLARE	@STOId int = 0

			EXEC @STOId = [dbo].[sp_SAP_STOMaster]
			@WHMasterInId = @WHStockinMasterId

			-- Save STO Details

			IF(@STOId > 0)
			BEGIN
				
				EXEC [dbo].[sp_SAP_STODetails]
					 @WHMasterInId = @WHStockinMasterId,
					 @ReqMasterId = @STOId

			END

			--================================================================== FOR Challan ======================================================================================


			IF(@WHStockinMasterId > 0 AND @STOId > 0)
			BEGIN
				
				-- Requisition Master Update

				EXEC [dbo].[sp_SAP_RequisitionMasterUpdate]
					 @WHStockInMasterID = @WHStockinMasterId,
					 @ReqId = @STOId

				-- Requisition Detail Update

				EXEC [dbo].[sp_SAP_RequisitionDetailUpdate]
					 @WHStockInMasterID = @WHStockinMasterId,
					 @ReqId = @STOId

				-- Insert in Stock In Transfer

				EXEC [dbo].[sp_SAP_StockInTransfer]
					 @WHStockInMasterID = @WHStockinMasterId,
					 @ReqId = @STOId


			  --================================================================== FOR Challan ======================================================================================

			 --   -- Insert into Dc Store

				--EXEC [dbo].[sp_SAP_StockReceiveByDc]
				--	 @ReqMasterId = @STOId

				---- Update Stock in Transfer

				--EXEC [dbo].[sp_SAP_StockInTransferUpdate]
				--	 @ReqMasterId = @STOId 

				---- Update tblRequisition
				
				--UPDATE dbo.tblRequisition SET ReceiveIssue='OK', ReceiveIssueDate = GETDATE() WHERE ReqId = @STOId

				----================================================================== Update SAP Data ======================================================================================
				--UPDATE  SAP_API_Data..tblSAP_StockMovementMaster SET IsReceived = 1,ReceiveDate = GETDATE(), ReceiveBy = @ApproveBy
				--WHERE UPPER(RTRIM(LTRIM(challan_code))) =  UPPER(RTRIM(LTRIM(@ChallanNo)))

			END

			
			

		END
	END	



	-- ===============================================================================
	--========================= FOR B2B ==============================================
	-- ===============================================================================



	ELSE IF(@IsFromWH = 0 AND @IsB2B = 1)
	BEGIN

		--================================================================== Challan Master ======================================================================================

		DECLARE	@ChalanMasterId int = 0

	    EXEC	@ChalanMasterId = [dbo].[sp_SAP_B2BChallanMasterInsert]
		        @ChallanNo = @ChallanNo


		--================================================================== Challan Detail ======================================================================================

		IF(@ChalanMasterId > 0)
		BEGIN

			EXEC [dbo].[sp_SAP_B2BChallanDetailInsert]
				 @MasterId = @ChalanMasterId,
				 @ChallanNo = @ChallanNo

			--================================================================== Challan Receive ======================================================================================

			--EXEC [dbo].[sp_SAP_B2BStockReceiveByDc]
		 --        @MasterId = @ChalanMasterId


			--================================================================== Update SAP Data ======================================================================================

				--UPDATE  SAP_API_Data..tblSAP_StockMovementMaster SET IsReceived = 1,ReceiveDate = GETDATE(), ReceiveBy = @ApproveBy
				--WHERE UPPER(RTRIM(LTRIM(challan_code))) =  UPPER(RTRIM(LTRIM(@ChallanNo)))

		END

		

	END

END



