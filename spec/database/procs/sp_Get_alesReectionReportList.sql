
CREATE PROCEDURE [dbo].[sp_Get_alesReectionReportList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)
AS
BEGIN
   
   DECLARE @Q NVARCHAR(MAX)='
SELECT up.UnitPrice AS Batch,up.VATAmountPerUnit AS VatAmount,U.ComUnitCode,U.ComUnitName,O.MarketCode_Ord  MarketCode, O.MarketName_Ord  MarketName,C.CustomerCode,C.CustomerName
                        ,O.OrderCode,CONVERT(NVARCHAR,O.SubmissionDate,103)SubmissionDate
                        ,D.ProductCode,PP.ProductName,I.InvoiceNo,CONVERT(NVARCHAR,I.InvoiceDate,103)InvoiceDate,D.Quantity AS RejectQuantity
                        ,D.TotalTradePrice AS NetRejectionAmount , CONVERT(NVARCHAR,I.InvoiceDate,103) AS DateofRejection,DZSM.EmpMasterCode AS DZSMCode,DZSM.EmpMasterCode AS FECode , MIO.EmpMasterCode AS MIOCode,O.TerritoryCode_Ord AS TerritoryCode
                        FROM dbo.tblOrder O
                        INNER JOIN dbo.tblOrderDetail D ON O.OrderId = D.OrderId
					 
 

                        left JOIN dbo.tblCompanyUnit U ON O.ComUnitId = U.ComUnitId
                        left JOIN dbo.tblProduct PP ON D.ProductCode = PP.ProductCode
                        left JOIN dbo.tblCustMaster C ON O.CustomerCode = C.CustomerCode
                        left JOIN dbo.tblInvoice I ON O.OrderCode = I.OrderNo
                        left JOIN dbo.tblUnitPrice UP ON D.ProductCode = UP.ProductCode
						LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON O.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON O.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON O.MIOId=MIO.EmpInfoId
                        WHERE Status=''Undelivered'' AND I.InvoiceNo IS NOT NULL
				 '+@Parm  
   


EXEC sp_executesql @Q

END
              