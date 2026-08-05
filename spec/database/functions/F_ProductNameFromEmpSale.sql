

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
Create FUNCTION [dbo].[F_ProductNameFromEmpSale]
(

)
RETURNS 

@MasterTable TABLE 
(
    
		
		ProductName NVARCHAR(MAX)	
)

AS

BEGIN
INSERT INTO @MasterTable
        ( 
          
          ProductName 
          
          
        )


SELECT ProductName AS ProductName FROM EmployeeSale()
    AS p
    GROUP BY ProductName 
	

RETURN
END




