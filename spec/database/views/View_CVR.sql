













CREATE VIEW [dbo].[View_CVR]
 
AS
   
 select  distinct  mas.RegionId,mas.AreaId,mas.TerritoryId, mas.ApprovalStatus,   mas.DoctorId, CONVERT(date,mas.DcrDate)  DcrDate,  doc.CustomerCode [Customer Code],      doc.CustomerName [Customer Name], doc.OwnerName [Owner Name],  pt.ProgramTypeName, custpt.CustomerType, mas.GroupName  [Group], mas.RegionCode_DCR  [Region],mas.AreaCode_DCR  [Area],mas.TerritoryCode_DCR  [Territory],mas.SubTerritoryCode_DCR +' : '+ mas.SubTerritoryName [Sub-Territory],mas.MarketCode_DCR  [Market] from tbl_DCRInfo mas   WITH (NOLOCK) 
 inner join tblCustMaster doc  WITH (NOLOCK)    on mas.DoctorId=doc.CustomerMasterId
  left join tblProgramType pt  WITH (NOLOCK)    on doc.ProgramTypeId=pt.ProgramTypeId
  left join tblCustomerType custpt  WITH (NOLOCK)    on doc.CustomerTypeId=custpt.CustomerTypeId


 where mas.TypeDcr='CVR'   
  
   
    

