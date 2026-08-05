 
CREATE PROCEDURE [dbo].[sp_Get_TerritorryWiseSalesReportList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)
AS
BEGIN
   
   SET NOCOUNT ON;
     DECLARE @Q NVARCHAR(MAX) = '
    SELECT  
       mas.RegionName_Ord, mas.AreaName_Ord, emp.EmpMasterCode OrderSenderCode,
        emp.EmpName OrderSenderName, 
        mas.TerritoryCode_Ord, 
        mas.TerritoryName_Ord, 
        CONVERT(DATE, I.UpdateDate) SalesDate,
        ISNULL(SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount),0) AS GPSales,
        SUM(TD.DeliveryNetAmount - TD.DeliveryTotalPriceVatAmount) AS TotalSales
    FROM dbo.tblInvoice I WITH (NOLOCK)
    INNER JOIN dbo.tblOrder mas WITH (NOLOCK) ON mas.OrderId = I.OrderId
    LEFT JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) 
        ON I.InvoiceId = D.InvoiceId 
        AND (ISNULL(D.Campaign,'''') <> '''' AND ISNULL(D.Campaign,'''') NOT LIKE ''%Fcfs%'')
    LEFT JOIN dbo.tblInvoiceDetail TD WITH (NOLOCK) ON I.InvoiceId = TD.InvoiceId

     left JOIN 
        dbo.tblMIOInfo mio WITH (NOLOCK) ON mio.TerritoryId = mas.TerritoryId and isnull(mio.IsActive,0)=1
        
        left JOIN 
        dbo.tblEmpGeneralInfo emp WITH (NOLOCK) ON mio.EmployeeId = emp.EmpInfoId

    WHERE I.InvoiceId is not null    ' + @Parm + '
    GROUP BY 
        mas.RegionName_Ord, mas.AreaName_Ord,
      emp.EmpMasterCode,
      emp.EmpName , 
        mas.TerritoryCode_Ord, 
        mas.TerritoryName_Ord,
        CONVERT(DATE, I.UpdateDate)
    ORDER BY mas.TerritoryCode_Ord';

    PRINT @Q; -- Debug: see final SQL
    EXEC (@Q);

END
              
 