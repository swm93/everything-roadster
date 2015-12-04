<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>


<%
    class ConnectionManager
    {
        public final String configFile = "config/server.json";
        private Connection connection = null;


        public Connection open() throws SQLException, ClassNotFoundException
        {
            System.out.println("Connecting to database.");

            if (connection == null)
            {
                Class.forName("com.mysql.jdbc.Driver");

                connection = DriverManager.getConnection(
                    "jdbc:mysql://cosc304.ok.ubc.ca/group11",
                    "group11",
                    "group11"
                );
            }

            return connection;
        }

        public void close() throws SQLException
        {
            System.out.println("Disconnecting from database.");

            if (connection != null)
            {
                connection.close();
            }

            connection = null;
        }
    }
%>

<% ConnectionManager connectionManager = new ConnectionManager(); %>
