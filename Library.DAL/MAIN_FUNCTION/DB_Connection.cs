using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAL.MAIN_FUNCTION
{
    internal class DB_Connection
    {
        internal static string GenerateString(string DataBaseName)
        {
            //test code
            return @"data source=" + DB_Authentication.DataSource + ";Initial Catalog=" + DataBaseName + ";Integrated Security=false; User Id=" + DB_Authentication.UserId + "; password=" + DB_Authentication.Password + ";";
        }
    }
}
