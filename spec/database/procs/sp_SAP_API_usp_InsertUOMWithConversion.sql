 
CREATE PROCEDURE sp_SAP_API_usp_InsertUOMWithConversion
    @product_id INT,
    @ProductCode NVARCHAR(255),
    @UomCode NVARCHAR(255),
    @QuantityInBase NVARCHAR(255),
    @Action NVARCHAR(255)
AS
BEGIN
    INSERT INTO SAP_API_Data..[tblUOMWithConversion] (
        [product_id],
        [product_code],
        [uom_code],
        [qty_in_base],
        [action]
    )
    VALUES (
        @product_id,
        @ProductCode,
        @UomCode,
        @QuantityInBase,
        @Action
    );

   
END;
