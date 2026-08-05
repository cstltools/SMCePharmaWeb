
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_MonthlyAllowance]
	-- Add the parameters for the stored procedure here
    @MonthlyAllowanceId INT = 0 ,
    @MonthlyAllowanceName NVARCHAR(MAX) ,
	@MonthlyAllowance Decimal(18,2),
    @UpdateBy NVARCHAR(50) ,
    @IsActive BIT ,
    @UserRoleId int =Null 

AS
    BEGIN
        UPDATE  [dbo].[tbl_MonthlyAllowance]
        SET   
		        MonthlyAllowanceName =@MonthlyAllowanceName ,
				MonthlyAllowance =@MonthlyAllowance,
                UpdateBy = @UpdateBy,
                UpdateDate = GETDATE(),
                IsActive = @isActive    
            
        WHERE   MonthlyAllowanceId = @MonthlyAllowanceId    
		
DELETE FROM [dbo].[tbl_MonthlyAllowanceDetail]
        WHERE   MonthlyAllowanceId = @MonthlyAllowanceId   and UserRoleId  =  @UserRoleId  
    END

