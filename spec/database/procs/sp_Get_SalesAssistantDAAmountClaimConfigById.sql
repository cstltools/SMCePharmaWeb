
--------------------------------------------------
-- PROCEDURE: sp_Get_SalesAssistantDAAmountClaimConfigById
--------------------------------------------------

CREATE   PROCEDURE dbo.sp_Get_SalesAssistantDAAmountClaimConfigById
    @SalesAssistantDAAmountClaimConfigId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT SalesAssistantDAAmountClaimConfigId,
           RoleName,
           TourTypeId,
           DAAmount,
           IsActive
    FROM dbo.tblSalesAssistantDAAmountClaimConfig WITH (NOLOCK)
    WHERE SalesAssistantDAAmountClaimConfigId = @SalesAssistantDAAmountClaimConfigId;
END

