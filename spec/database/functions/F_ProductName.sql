

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE FUNCTION [dbo].[F_ProductName]
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


SELECT ProductName AS ProductName FROM GetDCwiseStock()
    AS p
    GROUP BY ProductName 
	

RETURN
END




