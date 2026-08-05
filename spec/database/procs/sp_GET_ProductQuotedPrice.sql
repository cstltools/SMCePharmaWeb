
CREATE PROCEDURE [dbo].[sp_GET_ProductQuotedPrice]
	-- Add the parameters for the stored procedure here
   @Parameter NVARCHAR(max)

AS
    BEGIN

	DECLARE @Query NVARCHAR(MAX)

	SET @Query = 'SELECT DPT.QuotedPriceId, DPT.QuotedPrice,cus.CustomerName, Pro.ProductName, UP.UnitPrice, 
		CASE  WHEN  Entryemp.EmpName Is Null  THEN  us.UserName 
		ELSE Entryemp.EmpName  
		END as EMPEntryBy,
		CASE  WHEN empAcIn.EmpName  Is Null  THEN  AcIN.UserName 
		ELSE empAcIn.EmpName  
		END as  EMPActiveInactiveBy,			
		CONVERT(NVARCHAR,DPT.ActiveDate, 0) ActiveDate,			
	    CONVERT(NVARCHAR,DPT.InactiveDate, 0) InactiveDate,										
		CONVERT(NVARCHAR,DPT.EntryDate, 0) EntryDate,			
		CASE WHEN DPT.IsActive = 0 THEN  ''disabled'' ElSE '''' END InativeStatus,   	
		DPT.IsActive
		FROM tblProductQuotedPrice AS DPT 
		LEFT JOIN tblCustMaster cus on cus.CustomerMasterId = DPT.CustomerMasterId
        LEFT JOIN tblProduct Pro On Pro.ProductId = DPT.ProductId
        LEFT JOIN tblUnitPrice UP On UP.ProductId = DPT.ProductId 
		LEFT JOIN tblUser us ON us.UserId = DPT.EntryBy
		LEFT JOIN tblUser AcIN ON AcIN.UserId = DPT.ActiveInActiveBy
		LEFT JOIN tblEmpGeneralInfo Entryemp  ON Entryemp.EmpInfoId = us.EmpInfoId	
		LEFT JOIN tblEmpGeneralInfo empAcIn  ON  empAcIn.EmpInfoId = AcIN.EmpInfoId			
		WHERE DPT.QuotedPriceId IS NOT NULL And UP.IsActive =1' + @Parameter
	
    END



	    



	EXEC(@Query)



