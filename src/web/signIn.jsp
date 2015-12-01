<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>

<%
	Object user = session.getAttribute("user");
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

<%!void signIn(HttpServletRequest request, Connection connection, HttpSession session) {

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

			if (rs.next()) {
				Integer AccountId = rs.getInt(1);
				//HashMap<String, ArrayList<String>> userHashMap = createUserHash(AccountId, connection);
				//request.getSession().setAttribute("user", userHashMap);
				createUserHash(AccountId, connection, session);
				System.out.println("signed In!");
			} else {
				System.out.println("wrong e-mail/password combination");
			}
			;
		} catch (SQLException e) {

			System.out.println(e);
		}

	}%>


<%!//HashMap<String, ArrayList<String>> 
	void createUserHash(int accountId, Connection connection, HttpSession session) {
		String[] accountInfoKeys = { "accountType", "email", "password", "firstName", "lastName", "phoneNumber",
				"streetAddress", "city", "provinceState", "country", "postalCode" };
		HashMap<String, String> userHash = new HashMap<String, String>();
		ArrayList<String> accountDets = new ArrayList<String>();
		try {
			PreparedStatement preparedStatement = null;
			String query = "SELECT accountType, email, firstName, lastName ,password,  phoneNumber, streetAddress, city, provinceState, country, postalCode from Account where accountId = ?;";

			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setInt(1, accountId);

			ResultSet rs = preparedStatement.executeQuery();

			rs.next();
			for (int i = 0; i < accountInfoKeys.length; i++) {
				userHash.put(accountInfoKeys[i], rs.getString(accountInfoKeys[i]));
			}
			userHash.put("accountId", String.valueOf(accountId));
			session.setAttribute("user", userHash);

		} catch (SQLException e) {

			System.out.println(e);
		}

		//return userHash;
	}%>
<%
	if ((request.getParameter("email") != null) && (request.getParameter("password") != null)) {
		signIn(request, con, session);
	} else {
		System.out.println("Check fail");
	}
%>

<%
	connectionManager.close();
%>
</Body>