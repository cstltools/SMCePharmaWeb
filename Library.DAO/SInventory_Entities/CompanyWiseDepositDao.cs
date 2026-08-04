using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class CompanyWiseDepositDao
    {
        public int DepositId { get; set; }
        public int CompanyId { get; set; }
        public int? MIOId { get; set; }
        public int BankId { get; set; }
        public string BranchName { get; set; }
        public string DepositType { get; set; }
        public string AccountName { get; set; }
        public string DepositCode { get; set; }
        public string CheckNumber { get; set; }
        public  DateTime ? CheckDate { get; set; }
        public decimal Amount { get; set; }
        public string EntryBy { get; set; }
        public string Remarks { get; set; }
        public DateTime EntryDate { get; set; }
        public string UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }
        public DateTime DepositDate { get; set; }
        public bool IsDelete { get; set; }
        public bool IsExcelUpload { get; set; }
        public string DeleteBy { get; set; }
        public DateTime DeleteDate { get; set; }

        public decimal AIT { get; set; }

    }
    public class TargetExcelUploadDao
    {
        public string TerritoryCode { get; set; }
    
        public string Value { get; set; }
        public string MonthName { get; set; }
        public string YearValue { get; set; }
        public string FinYearValue { get; set; } 
        public string EntryBy { get; set; } 

    }
}
