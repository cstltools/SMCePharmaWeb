CREATE PROCEDURE [dbo].[sp_webapi_GetCustomerListByCusId]
	-- Add the parameters for the stored procedure here
   @CustomerMasterId int
AS
    BEGIN



        SELECT mr.MarketCode MarketCode, '' CustomerImagePreName, '' CustomerImagePreName,'' TradeLicenseImagePreName, (SELECT LTRIM(RTRIM(ImagePath+'/'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType='CustomerMy')+CAST(A.CustomerMasterId as nvarchar(max))+'.jpg' AS   ImageBase64String, (SELECT LTRIM(RTRIM(ImagePath+'/'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType='TradeLicenseMy')+CAST(A.CustomerMasterId as nvarchar(max))+'.jpg' AS   TradeLicenseImg,  A.CustomerMasterId ,
                A.CustomerName ,
                A.CustomerCode ,
                A.Address ,
                mr.MarketName ,A.MarketId,  sr.SubTerritoryId, tr.TerritoryId, ar.AreaId,rg.RegionId,gr.GroupId, ar.AreaName, tr.TerritoryName,ar.AreaName, rg.RegionName,
                A.CellNo , A.CustomerTypeId,A.IsVatApplicable,A.VoterID,
                E.CustomerType AS CustomerType , A.Latitude,A.Longitude, A.StreetAddress,A.ProgramTypeId,pt.ProgramTypeName,A.TermOfPayment,A.OwnerName,A.Reamrks,A.TradeLicense,sType.SMCType,A.SMCTypeId,sr.SubTerritoryName Subterritory
               
     FROM    dbo.tblCustMaster A with (nolock)
            
                left JOIN dbo.tblMarket mr with (nolock) ON A.MarketId = mr.MarketId
               left join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
		left join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
		left join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
		left join tblRegion rg   with (nolock)  on ar.RegionId=rg.RegionId
		left join tbl_Group gr   with (nolock)  on gr.GroupId=rg.GroupId

	 

                left JOIN dbo.TblSmcType sType  with (nolock)  ON sType.SMCTypeId = A.SMCTypeId
               
                left JOIN dbo.tblcustomertype E  with (nolock)  ON E.CustomerTypeid = A.CustomerTypeid
                left JOIN dbo.tblProgramType pt  with (nolock)  ON pt.ProgramTypeId = A.ProgramTypeId
        WHERE    A.CustomerMasterId=@CustomerMasterId



    END