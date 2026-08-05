CREATE PROCEDURE [dbo].[sp_SAP_BankDeposit_SAP_Process]
    @frmdate DATE,
    @todate DATE,
    @msgRes NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

delete from     SAP_API_Data..tbl_BankDeposit where ValueDate between @frmdate and @todate
        ;WITH src AS (
            SELECT
                tblCompanyUnit.Customer_Code AS CustomerCode,
                D.Amount,
                CONVERT(DATE, D.DepositDate) AS ValueDate,
                tblBankSAPMapping.Note AS BankAccountNo,
                ROW_NUMBER() OVER (ORDER BY D.DepositDate, D.DepositId) AS rn
            FROM tblCompanyWiseDeposit D
            LEFT JOIN tblBankSAPMapping ON D.AccountName = tblBankSAPMapping.BankAccNo
            LEFT JOIN tblCompanyUnit ON tblCompanyUnit.ComUnitId = D.CompanyId
            WHERE D.IsDelete = 0
              AND CONVERT(DATE, D.DepositDate) BETWEEN CONVERT(DATE, @frmdate) AND CONVERT(DATE, @todate)
              AND NOT EXISTS (
                  SELECT 1
                  FROM SAP_API_Data..tbl_BankDeposit BD
                  WHERE BD.DepositIdNew = D.DepositId
              )
        )
        INSERT INTO SAP_API_Data..tbl_BankDeposit (
            DepositIdNew,
            CustomerCode,
            Amount,
            ValueDate,
            BankAccountNo,
            Reference,
            CQNumber,
            EntryDate
        )
        SELECT
            (SELECT ISNULL(MAX(DepositIdNew), 0) FROM SAP_API_Data..tbl_BankDeposit) + rn,
            CustomerCode,
            Amount,
            ValueDate,
            BankAccountNo,
            '',
            '',
            GETDATE()
        FROM src;

        SET @msgRes = 'Data inserted successfully.';
        SELECT @@ROWCOUNT AS inserted;
    END TRY
    BEGIN CATCH
        SET @msgRes = ERROR_MESSAGE();
        SELECT 0 AS inserted;
    END CATCH
END
