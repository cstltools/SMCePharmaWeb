-- Create a stored procedure to insert or update employee data
CREATE PROCEDURE [dbo].[sp_SAP_InsertOrUpdateEmployee]
    @employee_code NVARCHAR(max),
    @name NVARCHAR(max),
    @role NVARCHAR(max),
    @joining_date DATE,
    @mobile_no NVARCHAR(max),
    @is_active BIT,
    @action NVARCHAR(max)
AS
BEGIN
    DECLARE @employee_id INT;

    -- Check if the employee already exists based on employee_code
    SELECT @employee_id = employee_id
    FROM tblSAP_Employee
    WHERE employee_code = @employee_code;

    --IF @action = 'Create'
    --BEGIN
    --    IF @employee_id IS NULL
    --    BEGIN
            -- Insert new employee record
            INSERT INTO SAP_API_Data..tblSAP_Employee (employee_code, name, role, joining_date, mobile_no, is_active, action,SAP_ReceiveDatetime)
            VALUES (@employee_code, @name, @role, @joining_date, @mobile_no, @is_active, @action,getdate());

            SET @employee_id = SCOPE_IDENTITY();
       -- END
		--else

  --      -- Handle error or throw an exception if employee already exists
  --  END
  --  ELSE IF @action = 'Update'
  --  BEGIN
  --      IF @employee_id IS NOT NULL
  --      BEGIN
  --          -- Update existing employee record
  --          UPDATE SAP_API_Data..tblSAP_Employee
  --          SET name = @name,
  --              role = @role,
  --              joining_date = @joining_date,
  --              mobile_no = @mobile_no,
  --              is_active = @is_active
  --          WHERE employee_code = @employee_code;
  --      END
  --      -- Handle error or throw an exception if employee doesn't exist
  --  END

    -- Return the updated/inserted employee_id
    SELECT @employee_id AS employee_id;
END
 

-- Create similar stored procedures for updating and inserting Territory_Assign, Zone_Assign, and Area_Assign data based on the action value
