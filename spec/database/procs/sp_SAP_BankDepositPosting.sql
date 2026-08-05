CREATE PROCEDURE [dbo].[sp_SAP_BankDepositPosting] ---SAP Invoice Details
   
     @frmDate nvarchar(max),
   @toDate nvarchar(max)

AS
BEGIN


--select D.DepositIdNew SL, CustomerCode CustomerCode,sum(Amount)Amount,FORMAT(DATEADD(DAY, -0, ValueDate),'dd.MM.yyyy') DepositDate,BankAccountNo as BankAccountNo,Reference as Reference,CQNumber as CQNumber 


--from SAP_API_Data..tbl_BankDeposit D

--where isnull(IS_SAP_MigrationDone,0)=1 and isnull(IS_SAP_Send,0)=0 and CONVERT(DATE,D.ValueDate)    BETWEEN CONVERT(DATE, @frmdate) AND CONVERT(DATE, @todate)
----FORMAT(EntryDate ,'dd.MM.yyyy')=FORMAT(DATEADD(DAY, -1,GETDATE()),'dd.MM.yyyy')  
 
--group by D.DepositIdNew  , CustomerCode  , FORMAT(DATEADD(DAY, -0, ValueDate),'dd.MM.yyyy')  ,BankAccountNo    ,Reference,CQNumber





select D.DepositIdNew SL, CustomerCode CustomerCode,(Amount)Amount,FORMAT(DATEADD(DAY, -0, ValueDate),'dd.MM.yyyy') DepositDate,BankAccountNo as BankAccountNo,Reference as Reference,CQNumber as CQNumber , isnull(IS_SAP_MigrationDone,0) IS_SAP_MigrationDone


from SAP_API_Data..tbl_BankDeposit D

where  CONVERT(DATE,D.ValueDate)    BETWEEN CONVERT(DATE, @frmDate) AND CONVERT(DATE, @toDate) order by DepositDate asc
--FORMAT(EntryDate ,'dd.MM.yyyy')=FORMAT(DATEADD(DAY, -1,GETDATE()),'dd.MM.yyyy')  
 




--select  '' CustomerCode, sum(Amount)Amount,FORMAT(DATEADD(DAY, -0, ValueDate),'dd.MM.yyyy') DepositDate,BankAccountNo as BankAccountNo,Reference as Reference,CQNumber as CQNumber 


--from SAP_API_Data..tbl_BankDeposit D

--where CONVERT(DATE,D.ValueDate)    BETWEEN CONVERT(DATE, @frmdate) AND CONVERT(DATE, @todate)
----FORMAT(EntryDate ,'dd.MM.yyyy')=FORMAT(DATEADD(DAY, -1,GETDATE()),'dd.MM.yyyy')  
 
--group by   FORMAT(DATEADD(DAY, -0, ValueDate),'dd.MM.yyyy')  ,BankAccountNo    ,Reference,CQNumber




END