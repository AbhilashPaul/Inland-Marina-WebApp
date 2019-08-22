using Lab2Group4.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Lab2Group4
{
    public partial class LeaseASlip : System.Web.UI.Page
    {
        //variable to hold user's customer ID 
        int customerID;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["customerid"] == null)                                          //if customer ID is null(i.e, user has not logged in) 
            {
                Response.Redirect("~/Account/Login.aspx");                              //redirect the user to login page
            }
            else
            {
                customerID = (int)Session["customerid"];                                    //get Customer ID of the user
            }

            lblGreeting.Text = "Welcome back " + Session["firstname"] + "!";                    //Display a peronalized greeting
            if (GridView2.Rows.Count == 0)
            {
                lblLease.Visible = false;
            }
            displaySelectedSlips();                                                     //update the slected slips diaplay. Ensures empty display on page load
        }


        /// <summary>
        /// This event handler is called when a slip is selected and stores the selected slip id into a list and session variable.
        /// User is able to select multiple slips at a time.
        /// </summary>
        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            //list to store the selected slip ids for leasing
            List<int> selectedSlipID = new List<int>();

            if (IsPostBack)
            {
                // Remove any messages previously send to the user
                lblMessage.Text = "";

                //get the slip ID selected by the customer
                GridViewRow row = GridView1.SelectedRow;
                int slipID = Convert.ToInt32(row.Cells[0].Text);

                //if session variable for selected slips already exist, convert it to a list
                //Ensures that the applcation captures multiple slips selected
                if (Session["selectedSlip"] != null)
                {
                    selectedSlipID = (List<int>)Session["selectedSlip"];
                }

                //check if the slip is already in the list
                //show a message if slip id was already selected in this session
                if (selectedSlipID.Contains(slipID))
                {
                    lblMessage.Text = "Slip " + slipID.ToString() + " is already selected!";
                }
                else //save the slip ID into the list
                {
                    selectedSlipID.Add(slipID);
                }
            }

            // Assign the list to a session variable
            Session["selectedSlip"] = selectedSlipID;
            //Display selected slip IDs back to the user 
            displaySelectedSlips();
        }

        /// <summary>
        /// Function to display slected slips on listbox
        /// </summary>
        protected void displaySelectedSlips()
        {
            //convert the slected slips stored in session variable back to list 
            List<int> selectedSlips = (List<int>)Session["selectedSlip"];
            //bind the list with the list box
            lstSlips.DataSource = selectedSlips;
            lstSlips.DataBind();
        }

        /// <summary>
        /// sets the the table to the first page when the selected dock changes
        /// </summary>
        protected void ddlDocks_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.PageIndex = 0;
        }

        /// <summary>
        /// Displays the page number on the available slips grid view
        /// </summary>
        protected void GridView1_PreRender(object sender, EventArgs e)
        {
            lblPagination.Text = "Displaying Page " +
                (GridView1.PageIndex + 1).ToString() +
                " of " + (GridView1.PageCount).ToString();
        }
        /// <summary>
        /// Create lease records by inserting the selected slips  and the customer id to the lease table
        /// </summary>
        protected void btnLease_Click(object sender, EventArgs e)
        {
            bool success = true;

            if (Session["selectedSlip"] != null)
            {
                List<int> selectedSlips = (List<int>)Session["selectedSlip"];
                //Insert all the slip IDs into the lease table
                foreach (int slipId in selectedSlips)
                {
                    success = UpdateLease(slipId, customerID);
                }

                //check if the insert command was successfully executed
                if (success == true)
                {
                    //on successful execution, clear the session variable
                    Session["selectedSlip"] = null;
                    //Refresh the page the in order to  the data sources. 
                    //This make sure that the user will not select any slip already selected  
                    Page.Response.Redirect(Page.Request.Url.ToString(), true);
                }
            }
        }
        /// <summary>
        /// Function inserts new leasing record in the lease database
        /// </summary>
        /// <param name="slipID"> Selected slip ID</param>
        /// <param name="customerID"> Customer ID of the user</param>
        /// <returns></returns>
        protected static bool UpdateLease(int slipID, int customerID)
        {
            bool success = true;
            using (SqlConnection connection = MarinaDB.GetConnection(Environment.MachineName))
            {
                //define select query
                string selectQuery = "INSERT INTO Lease " +
                                     "(SlipID, CustomerID) " +
                                     "VALUES (@SlipId, @CustomerId)";
                using (SqlCommand cmd = new SqlCommand(selectQuery, connection))                //initialize sqlcommand
                {
                    cmd.Parameters.AddWithValue("@SlipId", slipID);                             // data bind slip id and customer id                                              
                    cmd.Parameters.AddWithValue("@CustomerId", customerID);
                    connection.Open();                                                          //open connection
                    int rowsUpdated = cmd.ExecuteNonQuery();                                    //number of rows affected
                    if (rowsUpdated == 0) success = false;
                }
            }
            return success;
        }
    }

}