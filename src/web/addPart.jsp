<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>


<%
	/*
	-- NOTE TO SCOTT: Other than prettification, is it possible to change category name into a drop down list?
	-- due to the FK restraints it's prone to errors. 
	*/
%>
<%
	Connection con = connectionManager.open();
%>

<!DOCTYPE html>
<html>
<head>
<title>Everything Roadster</title>
</head>
<Body>
	<b> Part Creation Page</b>
	<form action="./addPart.jsp" method="POST">
		<b>"categoryName"</b> <input type="text" name="categoryName" size="50">
		<b>"partName"</b> <input type="text" name="partName" size="50">
		<b>"description"</b> <input type="text" name="description" size="50">
		<b>"imagePath"</b> <input type="text" name="imagePath" size="50">
		<button type="submit">AddPart</button>
	</form>
</head>



<%!void createPart(HttpServletRequest request, Connection connection) {
		String[] PartInfoKeys = { "categoryName", "partName", "description", "imagePath" };

		List<String> PartDets = new ArrayList<String>();

		for (String PartInfoKey : PartInfoKeys) {
			PartDets.add((String) request.getParameter(PartInfoKey));
		}

		try {

			PreparedStatement preparedStatement = null;

			String query = "SELECT MAX(PartId) FROM Part;";

			preparedStatement = connection.prepareStatement(query);
			ResultSet rs = preparedStatement.executeQuery(query);

			rs.next();
			Integer k = rs.getInt(1);

			String insertTableSQL = "INSERT INTO Part (PartId,categoryName,partName, description, imagePath)" + "VALUES"
					+ "(?,?,?,?,?)";

			preparedStatement = connection.prepareStatement(insertTableSQL);

			preparedStatement.setInt(1, k + 1);

			int i = 2;
			for (String column : PartDets) {
				preparedStatement.setString(i, PartDets.get(i - 2));
				i++;
			}

			String imagePath = "public/images/parts/" + PartDets.get(3) + ".jpg";
			preparedStatement.setString(5, imagePath);
			// execute insert SQL stetement
			preparedStatement.executeUpdate();

			System.out.println("Your part has been added");
		} catch (Exception e) {

			System.out.println(e);
		}

	}%>
<%
	if (request.getParameter("partName") != null) {
		System.out.println("Your part has been added!");
		createPart(request, con);
	} else {
		System.out.println("here");
	}
%>

<%
	connectionManager.close();
%>
</Body>