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
	<b> Remove Account</b>
	<form action="./removeAccount.jsp" method="POST">
		<b>"accountId"</b> <input type="text" name="accountId" size="50">
		<b>"accountType"</b> <input type="text" name="accountType" size="50">
		<button type="submit">remove Account</button>
	</form>
</head>

<%!public void removeAccount(HttpServletRequest request, Connection connection){
	String[] accountInfoKeys = {"accountId", "accountType"};

	List<String> accountDets = new ArrayList<String>();

	for (String accountInfoKey : accountInfoKeys) {
		accountDets.add((String) request.getParameter(accountInfoKey));
	}

	if(accountDets.get(1).equals("admin")){
		System.out.println("you cannot delete a fellow admin through the website");
	}else{

	try {

		PreparedStatement preparedStatement = null;
		String query = "DELETE FROM Account WHERE accountId=?;";
		preparedStatement = connection.prepareStatement(query);

		//commented out cause there are no paramets atm
		Integer accountId = Integer.parseInt(accountDets.get(0));
		preparedStatement.setInt(1, accountId);
		preparedStatement.executeUpdate();
		
		preparedStatement = null;
		String query2 = "SELECT accountId FROM Account WHERE accountId=?;";
		preparedStatement = connection.prepareStatement(query);
		ResultSet rs = preparedStatement.executeQuery();
		
		if(rs.next()){
			System.out.println("nothing happened..");
		}else{
			System.out.println("Account removed");
		}
	} catch (SQLException e) {

		System.out.println(e);
		
	}
	}
}%>

<%
	if (request.getParameter("accountId") != null) {
		removeAccount(request, con);
	} else {
		System.out.println("Nothing Entered- yet");
	}
%>

<%
	connectionManager.close();
%>
</Body>