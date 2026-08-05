create PROCEDURE [dbo].[sp_SAP_BankDepositSendtoSAP]  -- SAP Invoice Details
    @Ids NVARCHAR(MAX),
    @msgRes NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE SAP_API_Data..tbl_BankDeposit
        SET IS_SAP_Send = 1,
            SAP_SendDone = GETDATE()
        WHERE DepositIdNew IN (SELECT item FROM fnSplit(@Ids, ','))

        -- Set success message
        SET @msgRes = '✅ SAP Migration completed successfully.'
    END TRY
    BEGIN CATCH
        -- Handle any error and set failure message
        SET @msgRes = '❌ Error: ' + ERROR_MESSAGE()
    END CATCH
END
