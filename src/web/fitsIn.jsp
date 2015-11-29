<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>


<%
	/*
- > part Id   - > need to look up each vehicle ->> add into fits in

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
	<b> Which vehicle(s) does this part fit in?</b>
	<b> if there are multiple vehicles, enter one at a time</b>
	
	vehicleId, makeName, modelName, year
	<form action="./addPart.jsp" method="POST">
		<b>"makeName"</b> <input type="text" name="makeName" size="50">
		<b>"modelName"</b> <input type="text" name="modelName" size="50">
		<b>"year"</b> <input type="text" name="year" size="50">
		<button type="submit">AddPart</button>
	</form>
</head>

<%!void createFitsIn(HttpServletRequest request, Connection connection) {
		
	
	
	
		String[] PartInfoKeys = {"makeName", "modelName", "year"};

		List<String> PartDets = new ArrayList<String>();

		for (String PartInfoKey : PartInfoKeys) {
			PartDets.add((String) request.getParameter(PartInfoKey));
		}

		// but we dont know the vehicleId..
		try {

			PreparedStatement preparedStatement = null;

			String query = "SELECT vehicleID From Vehicle Where (makeName = '?' AND modelName = '?' AND year = '?');";
	
			preparedStatement = connection.prepareStatement(query);
			
			int i = 0;
			for (String column : PartDets) {
				preparedStatement.setString(i+1, PartDets.get(i));
				i++;
			}
			ResultSet rs = preparedStatement.executeQuery(query);
			rs.next();
			String vehicleId = rs.getInt(1);

			String insertTableSQL = "INSERT INTO FitsIn (partId, vehicleId) VALUES ('1'," + vehicleId +");'

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
	if (request.getParameter("modelName") != null) {
		createFitsIn(request, con);
	} else {
		System.out.println("here");
	}
%>

<%
	connectionManager.close();
%>
</Body>