


-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
Create FUNCTION [dbo].[F_DateName]
(
   @FromDate NVARCHAR(MAX),
	@ToDate NVARCHAR(MAX)

)
RETURNS 

@MasterTable TABLE 
(
    
		
			MainDate NVARCHAR(MAX)
)

AS

BEGIN
INSERT INTO @MasterTable
        ( 
          
           MainDate 
          
          
        )


SELECT REPLACE(REPLACE(CONVERT(VARCHAR,convert(date,MainDate),106), ' ','-'), ',','') AS [Name] FROM dbo.GetDateWiseSale(@FromDate,@ToDate)
    AS p
    GROUP BY MainDate ORDER BY CONVERT(DATE,MainDate)
	

RETURN
END






