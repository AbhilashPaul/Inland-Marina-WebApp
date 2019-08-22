using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Lab2Group4.Models
{
    public class CustomerDB
    {
        private static string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        }

        public static void CreateCustomer()
        {
            SqlConnection con = MarinaDB.GetConnection(Environment.MachineName);
            string insertStatement = "INSERT INTO Customer(firstName,lastName,city,phone,email) VALUES (@firstName, @lastName, @city, @phone, @email)";
            SqlCommand cmd = new SqlCommand(insertStatement, con);
            cmd.Parameters.AddWithValue("@firstName", HttpContext.Current.Session["firstName"].ToString());
            cmd.Parameters.AddWithValue("@lastName", HttpContext.Current.Session["lastName"].ToString());
            cmd.Parameters.AddWithValue("@city", HttpContext.Current.Session["city"].ToString());
            cmd.Parameters.AddWithValue("@phone", HttpContext.Current.Session["phone"].ToString());
            cmd.Parameters.AddWithValue("@email", HttpContext.Current.Session["email"].ToString());

            try
            {
                con.Open();
                cmd.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                throw ex;
            }
            finally
            {
                con.Close();
            }
        }

        /// <summary>
        /// Function to retrieve customer details from the database
        /// </summary>
        /// <param name="email"> email used for logging in</param>
        /// <returns></returns>
        public static Customer GetCustomer(string email)
        {
            SqlConnection con = MarinaDB.GetConnection(Environment.MachineName);
            string selectQuery = "SELECT  id, firstName, lastName FROM  Customer WHERE Email = @email";

            Customer cust=null;

            using (SqlCommand cmd = new SqlCommand(selectQuery, con))               //initialize sqlcommand
            {
                cmd.Parameters.AddWithValue("@email", email);                       //data bind email id                                             
                con.Open();                                                         //open connection
                using (SqlDataReader reader = cmd.ExecuteReader())                  //initialize reader
                {
                    if (reader.Read())                                              //if there is data to be read
                    {
                        cust = new Customer();                                      //create customer object
                        cust.CustomerID = (int)reader["ID"];                        //get the customer id
                        cust.FirstName = reader["firstname"].ToString();            //get the first name
                        cust.LastName = reader["lastname"].ToString();              //get the last name
                    }
                }
            }
            return cust;

        }
    }
}