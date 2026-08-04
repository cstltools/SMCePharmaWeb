using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class MiaTargetBLL
    {
        MiaTargetDAL aMiaTargetDAL = new MiaTargetDAL();
        public bool SaveMiaTarget(MiaTarget MiaTarget)
        {
            try
            {
                ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                MiaTarget.MiaTargetId = aClsPrimaryKeyFind.PrimaryKeyMax("MiaTargetId", "tblMIATarget");
                aMiaTargetDAL.SaveMiaTarget(MiaTarget);
                return true;

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
       
        public bool UpdateDataForMiaTarget(MiaTarget aMiaTarget)
        {
            return aMiaTargetDAL.UpdateMiaTarget(aMiaTarget);
        }

        public DataTable LoadMiaTarget()
        {
            return aMiaTargetDAL.LoadMiaTargetView();
        }

        public MiaTarget MiaTargetEditLoad(string MiaTargetId)
        {
            return aMiaTargetDAL.MiaTargetEditLoad(MiaTargetId);
        }

        public DataTable LoadMIAInfo(string miaId)
        {
            return aMiaTargetDAL.LoadMiaInfo(miaId);
        }
    }
}
