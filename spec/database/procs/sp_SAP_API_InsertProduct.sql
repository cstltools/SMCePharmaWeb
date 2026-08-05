CREATE PROCEDURE [dbo].[sp_SAP_API_InsertProduct]
    @product_code NVARCHAR(255),
    @product_name NVARCHAR(255),
    @description NVARCHAR(MAX),
    @therapeutic_code NVARCHAR(255),
    @group_code NVARCHAR(50),
    @category_code  NVARCHAR(50),
    @pack_size_code  NVARCHAR(50),
    @base_uom_code  NVARCHAR(50),
    @sales_uom_code  NVARCHAR(50),
    @type_code  NVARCHAR(50),
    @brand_code  NVARCHAR(50),
    @effective_date DATETIME,
    @unit_Vat decimal(18, 4),
    @status BIT,
    @action NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO SAP_API_Data..[tblProduct] (
        [product_code],
        [product_name],
        [description],
        [therapeutic_code],
        [group_code],
        [category_code],
        [pack_size_code],
        [base_uom_code],
        [sales_uom_code],
        [type_code],
        [brand_code],
        [effective_date],
        [unit_Vat],
        [status],
        [action]
    )
    VALUES (
        @product_code,
        @product_name,
        @description,
        @therapeutic_code,
        @group_code,
        @category_code,
        @pack_size_code,
        @base_uom_code,
        @sales_uom_code,
        @type_code,
        @brand_code,
        @effective_date,
        @unit_Vat,
        @status,
        @action
    );

    -- Return the newly inserted identity value
    SELECT SCOPE_IDENTITY() AS NewProductID;
END;
