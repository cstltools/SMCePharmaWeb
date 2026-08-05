

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
Create FUNCTION [dbo].[F_MonthName]
(
   @FromDate NVARCHAR(MAX),
	@ToDate NVARCHAR(MAX)

)
RETURNS 

@MasterTable TABLE 
(
    
		
			MonthYear NVARCHAR(MAX)
)

AS

BEGIN
INSERT INTO @MasterTable
        ( 
          
           MonthYear 
          
          
        )


SELECT [MonthYear] AS [Name] FROM dbo.GetMonthWiseSale(@FromDate,@ToDate)
    AS p
    GROUP BY [MonthYear] ORDER BY CONVERT(DATE,MonthYear)
	

RETURN
END





