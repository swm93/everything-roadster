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
	<b> Create vehicle</b>
	<form action="./removeVehicle.jsp" method="POST">
		<b>"makeName"</b> <input type="text" name="makeName" size="50">
		<b>"modelName"</b> <input type="text" name="modelName" size="50">
		<b>"year"</b> <input type="text" name="year" size="50">
		<button type="submit">remove Vehicle</button>
	</form>
</head>

<%!public void checkExists(HttpServletRequest request, Connection connection) {
		String[] PartInfoKeys = { "makeName", "modelName", "year" };

		List<String> PartDets = new ArrayList<String>();

		for (String PartInfoKey : PartInfoKeys) {
			PartDets.add((String) request.getParameter(PartInfoKey));
		}

		PreparedStatement preparedStatement = null;
		try {

			String query = "SELECT vehicleId FROM Vehicle WHERE makeName=? AND modelName=? AND year=?;";
			preparedStatement = connection.prepareStatement(query);

			//commented out cause there are no paramets atm
			preparedStatement.setString(1, PartDets.get(0));
			preparedStatement.setString(2, PartDets.get(1));
			Integer year = Integer.parseInt(PartDets.get(2));
			preparedStatement.setInt(3, year);

			ResultSet rs = preparedStatement.executeQuery();
			Integer vID = 0;
			if (rs.next()) {
				vID=rs.getInt(1);
				removeVehicle(vID, connection);
				System.out.println("vehicle was removed");
			} else {
				System.out.println("vehicle doesn't exist");
			}
		} catch (SQLException e) {

			System.out.println(e);
		}
	}%>
<%!public static void removeVehicle(int removeId, Connection connection) {

		try {
			PreparedStatement preparedStatement = null;
			String delete = "DELETE FROM Vehicle WHERE vehicleId = ?;";
			System.out.println(removeId);
			preparedStatement = connection.prepareStatement(delete);
			preparedStatement.setInt(1, removeId);
			preparedStatement.executeUpdate();

		} catch (SQLException e) {

			System.out.println(e);
		}

	}%>
<%
	if ((request.getParameter("modelName") != null)&& (request.getParameter("makeName") != null)&& (request.getParameter("year") != null))
	{		checkExists(request, con);
	}else {
		System.out.println("Nothing Entered- yet");
	}
%>

<%
	connectionManager.close();
%>
</Body>