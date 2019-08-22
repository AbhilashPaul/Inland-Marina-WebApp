using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Lab2Group4
{
    public class MarinaDB
    {
        /// <summary>
        /// Connects to the database. Use "MarinaDB.GetConnection(Environment.MachineName)" when calling the method.
        /// </summary>
        /// <param name="MachineName">name of the machine the application runs on</param>
        /// <returns> returns the connection</returns>
        public static SqlConnection GetConnection(string MachineName)       //works only if the application and server is in the same machine
        {
            string connectionString = "Data Source=" + MachineName + @"\SQLEXPRESS;Initial Catalog=Marina;Integrated Security=True";
            SqlConnection con = new SqlConnection(connectionString);
            return con;
        }
    }
}