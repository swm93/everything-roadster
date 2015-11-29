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
	<b>No account num input on purpose</b>

	<b> Account Creation Page</b>
	<form action="./signUp.jsp" method="POST">
		<b>"accountType"</b> <input type="text" name="accountType" size="50">
		<b>"email"</b> <input type="text" name="email" size="50"> <b>"password"</b>
		<input type="password" name="password" size="50"> <b>"firstName"</b>
		<input type="text" name="firstName" size="50"> <b>"lastName"</b>
		<input type="text" name="lastName" size="50"> <b>"phoneNumber"</b>
		<input type="text" name="phoneNumber" size="50"> <b>"streetAddress"</b>
		<input type="text" name="streetAddress" size="50"> <b>"city"</b>
		<input type="text" name="city" size="50"> <b>"provinceState"</b>
		<input type="text" name="provinceState" size="50"> <b>"country"</b>
		<input type="text" name="country" size="50"> <b>"postalCode"</b>
		<input type="text" name="postalCode" size="50"> button

		<button type="submit">Signup</button>
	</form>
</head>


<%!void createAccount(HttpServletRequest request, Connection connection) {
		String[] accountInfoKeys = { "accountType", "email", "password", "firstName", "lastName", "phoneNumber",
				"streetAddress", "city", "provinceState", "country", "postalCode" };

		List<String> accountDets = new ArrayList<String>();

		for (String accountInfoKey : accountInfoKeys) {
			accountDets.add((String) request.getParameter(accountInfoKey));
		}

		try {

			PreparedStatement preparedStatement = null;

			String query = "SELECT MAX(accountId) FROM Account;";

			preparedStatement = connection.prepareStatement(query);
			ResultSet rs = preparedStatement.executeQuery(query);

			rs.next();

			Integer k = rs.getInt(1); /// whatever)

			String insertTableSQL = "INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode) "
					+ "VALUES" + "(?,?,?,?,?,?,?,?,?,?,?,?)";

			preparedStatement = connection.prepareStatement(insertTableSQL);

			preparedStatement.setInt(1, k + 1);

			int i = 2;
			for (String column : accountDets) {
				preparedStatement.setString(i, accountDets.get(i - 2));
				i++;
			}

			// execute insert SQL stetement
			preparedStatement.executeUpdate();
		} catch (Exception e) {
			System.out.println(e);
		}

	}%>


<%
	// I mean, I guess it should
	if (request.getParameter("accountType") != null) {
		System.out.println("creating account");
		createAccount(request, con);
	}
%>

<%
	connectionManager.close();
%>
</Body>