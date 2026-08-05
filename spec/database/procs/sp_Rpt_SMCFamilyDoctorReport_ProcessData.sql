CREATE PROCEDURE [dbo].[sp_Rpt_SMCFamilyDoctorReport_ProcessData] --exec sp_GetHourlySweingOutput '20-sep-2020' 
	@frmDate nvarchar(max),
	@toDate  nvarchar(max) ,
	@Parameter  nvarchar(max),
	@Zone  nvarchar(max) ,
	@Area  nvarchar(max) ,
	@Teritory  nvarchar(max)  
AS
BEGIN

select * from  [dbo].[tblProcess_SMCFamilyDoctor] mas with (nolock)  where ((mas.RegionId= COALESCE( NULLIF(@Zone , 0) ,mas.RegionId ))  and (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId ))  and (mas.TerritoryId= COALESCE( NULLIF(@Teritory , 0) ,mas.TerritoryId )) )     and mas.to_DCP+mas.to_DCR+mas.to_RX>0  and MonthValue=MONTH(@frmDate) and   YearValue=Year(@frmDate) 


end