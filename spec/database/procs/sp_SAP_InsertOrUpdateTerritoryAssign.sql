-- Create a stored procedure to insert or update territory assignment data
CREATE PROCEDURE [dbo].[sp_SAP_InsertOrUpdateTerritoryAssign]
    @employee_id INT,
    @from_territory_code NVARCHAR(max),
    @to_territory_code NVARCHAR(max),
    @transfer_effective_date DATE,
    @action NVARCHAR(max) 
AS
BEGIN
    DECLARE @territory_assign_id INT  , @result bit=0;

    --IF @action = 'Create'
    --BEGIN
        -- Insert new territory assignment record
        INSERT INTO SAP_API_Data..tblSAP_Territory_Assign (employee_id, from_territory_code, to_territory_code, transfer_effective_date, action,SAP_ReceiveDatetime)
        VALUES (@employee_id, @from_territory_code, @to_territory_code, @transfer_effective_date, @action,getdate());

    --    SET @territory_assign_id = SCOPE_IDENTITY();

    --    -- Set result to 1 to indicate success
    --    SET @result = 1;
    --END
    --ELSE IF @action = 'Update'
    --BEGIN
    --    -- Update existing territory assignment record
    --    UPDATE SAP_API_Data..tblSAP_Territory_Assign
    --    SET from_territory_code = @from_territory_code,
    --        to_territory_code = @to_territory_code,
    --        transfer_effective_date = @transfer_effective_date
    --    WHERE employee_id = @employee_id;

    --    -- Set result to 1 if rows are affected, indicating success; otherwise, set to 0
    --    IF @@ROWCOUNT > 0
    --        SET @result = 1;
    --    ELSE
    --        SET @result = 0;
    --END
    --ELSE
    --BEGIN
    --    -- Invalid action, set result to -1
    --    SET @result = 0;
    --END
END;
