namespace SalesSolution.Web.Models
{
    public class ResultInfo
    {

        public bool isSuccess { get; set; }
        public bool isDuplicateCheck { get; set; }
        public bool isValiCheck { get; set; }
        public bool isError { get; set; }
        public string ErrorMessage { get; set; }
   
        public int Id { get; set; }

    }
}