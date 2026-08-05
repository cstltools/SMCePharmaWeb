CREATE   PROCEDURE dbo.sp_UpdateOpeningBalanceStockQty
(
    @ComUnitId INT
)
AS
BEGIN
    SET NOCOUNT ON;

    ---------------------------------------------------
    -- Difference List
    ---------------------------------------------------
    DECLARE @Difference TABLE
    (
        ProductCode NVARCHAR(50),
        Difference INT
    );

    INSERT INTO @Difference(ProductCode, Difference)
    VALUES
    ('AID02',-10),
    ('ANB019',-40),
    ('ANB020',-11),
    ('ANB06',-3),
    ('ANB07',-4),
    ('ANB09',-1),
    ('ANB08',-11),
    ('AID03',-20),
    ('ARD10',-9),
    ('ARD03',-2),
    ('AID05',-6),
    ('OAD02',-65),
    ('ANH01',-23),
    ('AID08',-11),
    ('ANM02',-2),
    ('ANM01',-2),
    ('FGD03',-9),
    ('ANB10',-13),
    ('ANB18',-14),
    ('ARD14',-13),
    ('ARD15',-4),
    ('VTM04',-19),
    ('ARD11',-10),
    ('ARD12',-22),
    ('MNS03',-16),
    ('MNS08',-18),
    ('ANB12',-1),
    ('MNS07',-25),
    ('FGD01',-2),
    ('AID09',-7),
    ('170614',-1);

    ---------------------------------------------------
    -- Update Latest TOP 1 Record
    ---------------------------------------------------
    UPDATE OB
    SET OB.StockQty =
        CASE
            WHEN D.Difference < 0
                THEN ISNULL(OB.StockQty,0) - ABS(D.Difference)
            ELSE
                ISNULL(OB.StockQty,0) + D.Difference
        END
    FROM tblDCStore_OpeningBalance OB
    INNER JOIN @Difference D
        ON D.ProductCode = OB.ProductCode
    WHERE OB.DCOpeningBalanceId =
    (
        SELECT TOP (1) X.DCOpeningBalanceId
        FROM tblDCStore_OpeningBalance X
        WHERE X.ComUnitId = OB.ComUnitId
          AND X.ProductCode = OB.ProductCode
          AND X.DCOpeningBalanceDate = '2026-07-01'
        ORDER BY X.DCOpeningBalanceId DESC
    )
    AND OB.ComUnitId = @ComUnitId
    AND OB.DCOpeningBalanceDate = '2026-07-01';

END
