 
CREATE PROCEDURE usp_InsertUOMWithConversion
    @product_id INT,
    @product_code NVARCHAR(255),
    @uom_code NVARCHAR(255),
    @qty_in_base NVARCHAR(255),
    @action NVARCHAR(255)
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
        @product_code,
        @uom_code,
        @qty_in_base,
        @action
    );

   
END;
