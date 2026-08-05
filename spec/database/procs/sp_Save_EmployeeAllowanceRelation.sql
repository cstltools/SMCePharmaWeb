-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_EmployeeAllowanceRelation]
	-- Add the parameters for the stored procedure here
	 @EmpInfoId INT ,
    @AllowanceId INT
	--@ImagePath NVARCHAR(Max),
	--@ImageName NVARCHAR(MAx)

AS
    BEGIN
	
        INSERT  INTO [dbo].[EmployeeAllowance]
                ( EmpInfoId ,                
                  AllowanceId
               
	            )
        VALUES  ( @EmpInfoId ,              
                  @AllowanceId 
           
	            )

SELECT SCOPE_IDENTITY()

END

