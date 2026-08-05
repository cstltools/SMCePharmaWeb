CREATE   PROCEDURE dbo.usp_GenerateCustomerCode
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @CustCodeInt INT;

        SELECT @CustCodeInt =
            ISNULL(MAX(CONVERT(INT, SUBSTRING(CustomerCode, 2, LEN(CustomerCode)))), 0)
        FROM dbo.tblCustMaster WITH (UPDLOCK, HOLDLOCK)
        WHERE ActionStatus = '2'
          AND CustomerCode IS NOT NULL;

        ;WITH CTE AS
        (
            SELECT
                CustomerMasterId,
                ROW_NUMBER() OVER (ORDER BY CustomerMasterId) AS RN
            FROM dbo.tblCustMaster
            WHERE ActionStatus = '2'
              AND CustomerCode IS NULL
              AND CreateDate >= '2026-07-28'
        )
        UPDATE CM
        SET CustomerCode = 'C' + CAST(@CustCodeInt + CTE.RN AS NVARCHAR(20)), IsActive=1
        FROM dbo.tblCustMaster CM
        JOIN CTE
            ON CM.CustomerMasterId = CTE.CustomerMasterId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrState INT = ERROR_STATE();

        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END
