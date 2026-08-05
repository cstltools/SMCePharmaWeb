
CREATE PROCEDURE [dbo].[sp_SAP_UpdateEmpTerritory] -- exec sp_SAP_UpdateEmpTerritory
    @Date DATE 
AS
BEGIN
    -- Declare variables
    DECLARE @CustomerCode NVARCHAR(500);
    DECLARE @Zone NVARCHAR(500);
    DECLARE @AREA NVARCHAR(500);
    DECLARE @Territory NVARCHAR(500);

    -- Declare cursor
    DECLARE CustomerCursor CURSOR FOR
    SELECT CustomerCode 
    FROM SAP_API_Data..tbl_DeliveryConfirmation_Sales 
    WHERE Territory IS NULL AND SalesDocDate =  @Date

    -- Open cursor
    OPEN CustomerCursor;

    -- Fetch the first row
    FETCH NEXT FROM CustomerCursor INTO @CustomerCode;

    -- Loop through all rows
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Initialize variables
        SET @Zone = NULL;
        SET @AREA = NULL;
        SET @Territory = NULL;

        -- Get zone, area, and territory based on the customer code
        SELECT TOP 1 
            @Territory = tblTerritory.SAP_Code,
            @AREA = tblArea.SAP_Code,
            @Zone = tblRegion.SAP_Code
        FROM tblTerritory
        INNER JOIN tblArea ON tblArea.AreaId = tblTerritory.AreaId
        INNER JOIN tblASMInfo ON tblASMInfo.AreaId = tblArea.AreaId
        INNER JOIN tblEmpGeneralInfo ON tblEmpGeneralInfo.EmpInfoId = tblASMInfo.EmployeeId
        INNER JOIN tblRegion ON tblRegion.RegionId = tblArea.RegionId
        WHERE tblEmpGeneralInfo.EmpMasterCode = SUBSTRING(@CustomerCode, 6, 10);

        -- Update the table with the obtained zone, area, and territory
        UPDATE SAP_API_Data..tbl_DeliveryConfirmation_Sales
        SET 
            zone = @Zone, 
            Area = @AREA, 
            Territory = @Territory 
        WHERE SalesDocDate = @Date AND CustomerCode = @CustomerCode;

        -- Fetch the next row
        FETCH NEXT FROM CustomerCursor INTO @CustomerCode;
    END

    -- Close and deallocate cursor
    CLOSE CustomerCursor;
    DEALLOCATE CustomerCursor;
END
