-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_BonusCampaingData] -- sp_Webapi_Get_BonusCampaingData 
	-- Add the parameters for the stored procedure here
    @customerId INT ,
    @empId INT ,
    @totalAmt DECIMAL(18, 2) ,
    @productCodeMultiple NVARCHAR(MAX)
AS
    BEGIN
	

        SELECT  
		B.CampaignDetailId AS CampgainMasterId,
                CASE WHEN D.CodeName = 'PTOA'
                     THEN 'Discount '
                          + CAST(B.DiscountPercentage AS NVARCHAR(10))
                          + '% On Order Amount'
                     WHEN D.CodeName = 'ADOTOA'
                     THEN 'Discount ' + CAST(B.DiscountAmount AS NVARCHAR(10))
                          + ' On Order Amount'
                     WHEN D.CodeName = 'PQO'
                     THEN ( SELECT  ProductName
                            FROM    dbo.tblProduct
                            WHERE   ProductCode = B.BonusProductCode
                          ) + ' : ' + CAST(B.BonusQuantity AS NVARCHAR(10))
                          + ' Offer on Order Amount'
                     ELSE A.CampaignName
                END AS CampaignName ,
                C.CodeName AS CamTypeCodeName ,
                D.CodeName AS BonusTypeCodeName ,
                A.CampaignDesc ,
                C.TypeName ,
                C.CampainTypeId ,
                D.BonusTypeId ,
                D.TypeName ,
                B.MinAmount ,
                B.MaxAmount ,
                B.DiscountPercentage ,
                B.DiscountAmount ,
                B.ProductCode ,
                B.Quantity ,
                B.BonusProductCode ,
                B.BonusQuantity ,
                0 AS ProductId ,
                '' AS ProductName
        FROM    dbo.tbl_BonusCampaignNewMaster A
                INNER JOIN dbo.tbl_BonusCampaignNewDetail B ON A.CampgainMasterId = B.CampaignMasterId
                LEFT JOIN dbo.tbl_CampaignType C ON C.CampainTypeId = A.CampainTypeId
                LEFT JOIN dbo.tbl_BonusOnType D ON D.BonusTypeId = B.BonusTypeId
        WHERE   A.IsActive = 1
                AND C.CodeName = 'TP'
                AND @totalAmt BETWEEN B.MinAmount AND B.MaxAmount
        UNION
        SELECT  B.CampaignDetailId AS CampgainMasterId,
                CASE WHEN D.CodeName = 'PQO'
                     THEN ( SELECT  ProductName
                            FROM    dbo.tblProduct
                            WHERE   ProductCode = B.ProductCode
                          ) + '(' + CAST(B.Quantity AS NVARCHAR(10)) + ' : '
                          + CAST(B.BonusQuantity AS NVARCHAR(10)) + ')'
                          + ( SELECT    ProductName
                              FROM      dbo.tblProduct
                              WHERE     ProductCode = B.BonusProductCode
                            )
                     ELSE A.CampaignName
                END AS CampaignName ,
                C.CodeName AS CamTypeCodeName ,
                D.CodeName AS BonusTypeCodeName ,
                A.CampaignDesc ,
                C.TypeName ,
                C.CampainTypeId ,
                D.BonusTypeId ,
                D.TypeName ,
                B.MinAmount ,
                B.MaxAmount ,
                B.DiscountPercentage ,
                B.DiscountAmount ,
                B.ProductCode ,
                B.Quantity ,
                B.BonusProductCode ,
                B.BonusQuantity ,
                p.ProductId ,
                p.ProductName
        FROM    dbo.tbl_BonusCampaignNewMaster A
                INNER JOIN dbo.tbl_BonusCampaignNewDetail B ON A.CampgainMasterId = B.CampaignMasterId
                LEFT JOIN dbo.tbl_CampaignType C ON C.CampainTypeId = A.CampainTypeId
                LEFT JOIN dbo.tbl_BonusOnType D ON D.BonusTypeId = B.BonusTypeId
                LEFT JOIN dbo.tblProduct p ON p.ProductCode = B.ProductCode
        WHERE   (A.IsActive = 1)  and (GETDATE() between FromDate and Todate)
                AND (C.CodeName <> 'TP')
                AND B.ProductCode IN (
                SELECT  *
                FROM    dbo.fnSplit(@productCodeMultiple, ',') ) 

    END

