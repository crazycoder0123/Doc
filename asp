->  ASP.NET Frontend (Default.aspx)

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CrudApp.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CRUD Operations</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <label>ID:</label>
            <asp:TextBox ID="txtId" runat="server" /><br /><br />

            <label>Name:</label>
            <asp:TextBox ID="txtName" runat="server" /><br /><br />

            <label>Result:</label>
            <asp:TextBox ID="txtResult" runat="server" /><br /><br />

            <asp:Button ID="btnInsert" runat="server" Text="Insert" OnClick="btnInsert_Click" />
            <asp:Button ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click" />
            <asp:Button ID="btnDelete" runat="server" Text="Delete" OnClick="btnDelete_Click" />
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />

            <br /><br />
            <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>
        </div>
    </form>
</body>
</html>

-> Backend Code (Default.aspx.cs)

using System;
using System.Data.SqlClient;

namespace CrudApp
{
    public partial class Default : System.Web.UI.Page
    {
        string conString = "Data Source=.;Initial Catalog=CrudDb;Integrated Security=True";

        protected void btnInsert_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(conString))
            {
                string query = "INSERT INTO Users (Name, Result) VALUES (@Name, @Result)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Name", txtName.Text);
                cmd.Parameters.AddWithValue("@Result", txtResult.Text);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
                lblMessage.Text = "Data inserted successfully.";
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(conString))
            {
                string query = "UPDATE Users SET Name = @Name, Result = @Result WHERE Id = @Id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Id", txtId.Text);
                cmd.Parameters.AddWithValue("@Name", txtName.Text);
                cmd.Parameters.AddWithValue("@Result", txtResult.Text);
                con.Open();
                int rows = cmd.ExecuteNonQuery();
                con.Close();

                lblMessage.Text = rows > 0 ? "Data updated successfully." : "ID not found.";
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(conString))
            {
                string query = "DELETE FROM Users WHERE Id = @Id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Id", txtId.Text);
                con.Open();
                int rows = cmd.ExecuteNonQuery();
                con.Close();

                lblMessage.Text = rows > 0 ? "Data deleted successfully." : "ID not found.";
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(conString))
            {
                string query = "SELECT Name, Result FROM Users WHERE Id = @Id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Id", txtId.Text);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtName.Text = reader["Name"].ToString();
                    txtResult.Text = reader["Result"].ToString();
                    lblMessage.Text = "Data found.";
                }
                else
                {
                    lblMessage.Text = "No data found.";
                }
                con.Close();
            }
        }
    }
}
