-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_DcrBrand]
	-- Add the parameters for the stored procedure here
    @BrandId INT, @pk INT
AS
    BEGIN
	
        INSERT  INTO dbo.tbl_DcrBrandDetails
                ( BrandId, DcrId )
        VALUES  ( @BrandId, @pk )


    END

