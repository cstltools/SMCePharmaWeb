using System.Data;
using System.Threading.Tasks;

namespace SalesSolution.Web.Interface
{
    interface iSeedData
    {

        DataTable GetEmployee_All();
        DataTable GetDivisions_All();
        DataTable GetDivisionList_NotInAnyTagWithZone();
        DataTable GetDivisions_ByZoneId(int zoneId);
        DataTable GetZone_ActiveOnly();
        DataTable GetDistrict_ActiveOnly();
        DataTable GetThana_All_Active();
        DataTable GetThana_All_WithTagInfo();
        DataTable GetGroup_All();

        DataTable GetChemistTypeList();
        DataTable GetCampaignTypeList();
        DataTable GetOfferTypeInfo(int id);

    }
}
