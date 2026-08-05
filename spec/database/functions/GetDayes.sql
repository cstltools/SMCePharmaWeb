

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE FUNCTION [dbo].[GetDayes]
(

)
RETURNS 

		@MasterTable TABLE 
		(
				RowNo int Identity(1,1) Primary Key not null,
				DayNo datetime NULL
		)

		AS

		BEGIN
		DECLARE @StartDate datetime = '2017-03-01'
       ,@EndDate   datetime = '2017-03-31'
;

WITH theDates AS
     (SELECT @StartDate as theDate
      UNION ALL
      SELECT DATEADD(day, 1, theDate)
        FROM theDates
       WHERE DATEADD(day, 1, theDate) <= @EndDate
     )
		INSERT INTO @MasterTable
				( 
				  DayNo
				  
				)


		
SELECT theDate
  FROM theDates 
OPTION (MAXRECURSION 0) 
;

		RETURN
		END





