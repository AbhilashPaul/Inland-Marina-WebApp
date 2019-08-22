using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Lab2Group4.Models
{
    public class Customer
    {
        public int CustomerID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Phone { get; set; }
        public string City { get; set; }
        public string email { get; set;}
    }
}