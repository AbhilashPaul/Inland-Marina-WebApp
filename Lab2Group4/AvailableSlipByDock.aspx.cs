using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Lab2Group4
{
    public partial class AvailableSlipByDock : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        /// <summary>
        /// sets the the table to the first page when the selected dock changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ddlDocks_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.PageIndex = 0;
        }

        /// <summary>
        /// Displays the page number
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void GridView1_PreRender(object sender, EventArgs e)
        {
            lblPagination.Text = "Displaying Page " + (GridView1.PageIndex + 1).ToString() + " of " + (GridView1.PageCount).ToString();
        }
    }
}