CREATE PROCEDURE [dbo].[spGetPersonByDivisionDistrict]
    @DivisionId NVARCHAR(100),
    @DistrictId NVARCHAR(100),
    @ThanaId NVARCHAR(100),
        @FromWhom NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

 declare   @Division NVARCHAR(100),
    @District NVARCHAR(100), @ThanaName  NVARCHAR(100)
    --select @District= dis.DistrictName, @Division= d.DivisionName, @ThanaName=t.ThanaName from  tbl_Thana t
    --  inner join tbl_District dis on t.district_id=dis.DistrictId
    --inner join tbl_Division d on dis.DivisionId=d.DivisionId 

    SELECT distinct
     @Division= d.DivisionName , @District=di.DistrictName, @ThanaName= u.UpazilaName
    
FROM dbo.tblBSPDivision  AS d
JOIN dbo.tblBSPDistrict  AS di ON di.DivisionId = d.DivisionId
JOIN dbo.tblBSPUpazila   AS u  ON u.DistrictId  = di.DistrictId
  

   where  di.DistrictId=@DistrictId and   u.UpazilaId=@ThanaId

    if(@FromWhom='Entry')
    begin
      SELECT PersonId, OwnerName  OwnerName, ProviderType, BSPCode BSPCode , Name Name, Address, Mobile, Division, District,  Upazila
    FROM tblPersonInfo with (nolock) WHERE BSPCode not in (select CustomerBsPCode from tblCustMaster  with (nolock) where CustomerBsPCode is not null)  and       (@District IS NULL OR District = @District)   AND (@ThanaName IS NULL OR Upazila = @ThanaName)  order by BSPCode asc;
    end
    else
    begin
      SELECT PersonId, OwnerName  OwnerName, ProviderType, BSPCode BSPCode , Name Name, Address, Mobile, Division, District,  Upazila
    FROM tblPersonInfo with (nolock)  where     (@District IS NULL OR District = @District)   AND (@ThanaName IS NULL OR Upazila = @ThanaName) order by BSPCode asc;
    end
  
    --WHERE (@Division IS NULL OR Division = @Division)
    --  AND (@District IS NULL OR District = @District)   AND (@ThanaName IS NULL OR Upazila = @ThanaName);
END


  