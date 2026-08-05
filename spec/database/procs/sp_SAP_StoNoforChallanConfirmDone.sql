CREATE PROCEDURE [dbo].[sp_SAP_StoNoforChallanConfirmDone]
 @StoNo varchar(50) 

AS


BEGIN



		
		 	UPDATE  SAP_API_Data..tblSAP_StockMovementMaster SET  isConfirmDone=1,  IsReceived = 1,ReceiveDate = GETDATE() 
				WHERE UPPER(RTRIM(LTRIM(challan_code))) =  UPPER(RTRIM(LTRIM( @StoNo)))  
END;
