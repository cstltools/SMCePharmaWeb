CREATE PROCEDURE [dbo].[sp_webapi_GetCustomerList]
	-- Add the parameters for the stored procedure here
   
AS
    BEGIN



        SELECT   A.CustomerMasterId ,
                A.CustomerName ,
                A.CustomerCode ,
                A.Address ,
                mr.MarketName ,A.MarketId, ar.AreaName, tr.TerritoryName,ar.AreaName,
                A.CellNo , A.CustomerTypeId,A.IsVatApplicable,A.VoterID,
                E.CategoryName AS CustomerType , A.Latitude,A.Longitude, A.StreetAddress,A.ProgramTypeId,pt.ProgramTypeName,A.TermOfPayment,A.OwnerName,(SELECT LTRIM(RTRIM(ImagePath+'\'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType='Customer')AS CustomerImagePreName,(SELECT LTRIM(RTRIM(ImagePath+'\'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType='TradeLicense')AS TradeLicenseImagePreName,A.Reamrks
               
     FROM    dbo.tblCustMaster A
            
                left JOIN dbo.tblMarket mr ON A.MarketId = mr.MarketId
               left join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
		left join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
		left join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
	 

               
                left JOIN dbo.tblCustCategory E  with (nolock)  ON E.CategoryId = A.CategoryId
                left JOIN dbo.tblProgramType pt  with (nolock)  ON pt.ProgramTypeId = A.ProgramTypeId
        WHERE    A.IsActive = 1



    END