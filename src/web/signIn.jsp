<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>

<%
	Connection con = connectionManager.open();
%>

<!DOCTYPE html>
<html>
<head>
<title>Everything Roadster</title>
</head>
<Body>
	<b> Sign In</b>
	<form action="./signIn.jsp" method="POST">
		<b>"email"</b> <input type="text" name="email" size="50"> <b>"password"</b>
		<input type="text" name="password" size="50"> <b>"year"</b> 
		<button type="submit">sign In</button>
	</form>
</head>

<%!void signIn(HttpServletRequest request, Connection connection) {

		String[] accountInfoKeys = { "email", "password" };

		List<String> accountDets = new ArrayList<String>();

		for (String accountInfoKey : accountInfoKeys) {
			accountDets.add((String) request.getParameter(accountInfoKey));
		}

		try {
			PreparedStatement preparedStatement = null;
			String query = "SELECT accountId FROM Account WHERE email = ? and password = ?;";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, accountDets.get(0));
			preparedStatement.setString(2, accountDets.get(1));
			ResultSet rs = preparedStatement.executeQuery();
			Integer accountId = 0;
			if (rs.next()) {
				Integer AccountId = rs.getInt(1);
				System.out.println("signed In!");
				
				// What?
			} else {
				System.out.println("wrong e-mail/password combination");
			}
			;
		} catch (SQLException e) {

			System.out.println(e);
		}

	}%>

<%
	if (request.getParameter("email") != null) {
		signIn(request, con);
	} else {
		System.out.println("Check fail");
	}
%>

<%
	connectionManager.close();
%>
</Body>