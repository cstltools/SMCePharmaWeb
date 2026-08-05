-- Create a stored procedure to insert or update area assignment data
CREATE PROCEDURE [dbo].[sp_SAP_InsertOrUpdateAreaAssign]
    @employee_id INT,
    @from_area_code NVARCHAR(max),
    @to_area_code NVARCHAR(max),
    @transfer_effective_date DATE,
    @action NVARCHAR(max) 
AS
BEGIN
     DECLARE @area_assign_id INT, @result bit=0;

    --IF @action = 'Create'
    --BEGIN
        -- Insert new area assignment record
        INSERT INTO SAP_API_Data..tblSAP_Area_Assign (employee_id, from_area_code, to_area_code, transfer_effective_date, action,SAP_ReceiveDatetime)
        VALUES (@employee_id, @from_area_code, @to_area_code, @transfer_effective_date, @action,getdate());

    --    SET @area_assign_id = SCOPE_IDENTITY();

    --    -- Set result to 1 to indicate success
    --    SET @result = 1;
    --END
    --ELSE IF @action = 'Update'
    --BEGIN
    --    -- Update existing area assignment record
    --    UPDATE SAP_API_Data..tblSAP_Area_Assign
    --    SET from_area_code = @from_area_code,
    --        to_area_code = @to_area_code,
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
    --    -- Invalid action, set result to 0 (failure)
    --    SET @result = 0;
    --END
END;
