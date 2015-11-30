<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>


<%
    PreparedStatement loginPS = connection.prepareStatement(
        "SELECT email " +
            "FROM Account " +
            "WHERE email=? AND password=?;"
    );

    String email = request.getParameter("email");
    String password = request.getParameter("password");

    if (email == null ||
        email.length() == 0 ||
        password == null ||
        password.length() == 0)
    {
        //TODO: add error, invalid parameters
        return;
    }

    loginPS.setString(1, email);
    loginPS.setString(2, password);

    ResultSet loginRS = loginPS.executeQuery();
    if (!loginRS.next())
    {
        //TODO: add error, invalid credentials
        return;
    }

    session.setAttribute("authenticatedUser", email);
%>