

CREATE PROCEDURE [dbo].[sp_Get_SubTerritoryList]
    -- Add the parameters for the stored procedure here
    @Parameter NVARCHAR(max)
AS
BEGIN
   
        DECLARE @Query NVARCHAR(MAX)

    

        SET @Query = 'SELECT subDPT.SubTerritoryId,subDPT.SubTerritoryCode, subDPT.SubTerritoryName,
        DPT.TerritoryId, DPT.TerritoryCode, DPT.TerritoryName, DPT.IsActive, R.RegionName, ar.AreaName,G.GroupName,
        CASE  WHEN  Entryemp.EmpName Is Null  THEN  us.UserName
        ELSE Entryemp.EmpName  
        END as EMPEntryBy,
            CASE  WHEN updateBy.EmpName  Is Null  THEN  up.UserName
        ELSE updateBy.EmpName  
        END as  EMPUpdateBy,
            CASE  WHEN empAcIn.EmpName  Is Null  THEN  AcIN.UserName
        ELSE empAcIn.EmpName  
        END as  EMPActiveInactiveBy,                    
        CONVERT(NVARCHAR(50),DPT.EntryDate,106)AS EntryDatee,
        CONVERT(NVARCHAR(50),DPT.UpdateDate,106)AS UpdateDatee,
        CONVERT(NVARCHAR(50),DPT.AcOrInAcDate,106)AS InactiveDatee,    
        CASE WHEN ISNULL(C.NoOf,0) > 0 THEN ''disabled'' ELSE '''' END AS DeleteStatus
        FROM tblSubTerritory AS subDPT  WITH (NOLOCK)
        LEFT JOIN dbo.tblTerritory DPT ON subDPT.TerritoryId = DPT.TerritoryId
        LEFT JOIN dbo.tblArea ar ON ar.AreaId = DPT.AreaId
        LEFT JOIN dbo.tblRegion R ON R.RegionId = ar.RegionId    
        LEFT JOIN dbo.tbl_Group G On  G.GroupId = R.GroupId
        LEFT JOIN tblUser us ON us.UserId = DPT.EntryBy
        LEFT JOIN tblUser up ON up.UserId = DPT.UpdateBy
        LEFT JOIN tblUser AcIN ON AcIN.UserId = DPT.ActiveInactiveBy
        LEFT JOIN tblEmpGeneralInfo Entryemp  ON Entryemp.EmpInfoId = us.EmpInfoId    
        LEFT JOIN tblEmpGeneralInfo updateBy  ON updateBy.EmpInfoId = up.EmpInfoId
        LEFT JOIN tblEmpGeneralInfo empAcIn  ON  empAcIn.EmpInfoId = AcIN.EmpInfoId    
        LEFT JOIN (SELECT DISTINCT TerritoryId, COUNT(TerritoryId) NoOf FROM dbo.tblMarket WHERE IsActive = 1 GROUP BY TerritoryId) AS C ON DPT.TerritoryId = C.TerritoryId        
        WHERE subDPT.SubTerritoryId is not null
     ' + @Parameter  

    
    END

    EXEC(@Query)
