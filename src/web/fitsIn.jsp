<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>

--If you are reading this, you created a vehicle part and are now linking it to the cars the parts works in
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
	<b> after you are finished, click done to be redirected back to home</b>
	<form action="./fitsIn.jsp" method="POST">
		<b>"makeName"</b> <input type="text" name="makeName" size="50">
		<b>"modelName"</b> <input type="text" name="modelName" size="50">
		<b>"year"</b> <input type="text" name="year" size="50">
		<button type="submit">AddPart</button>
	</form>
	<form action="./index.jsp" method="POST">
		<button type="submit">Done</button>
	</form>
	
</head>

<%!void createFitsIn(HttpServletRequest request, Connection connection) {

		String[] PartInfoKeys = { "makeName", "modelName", "year" };

		List<String> PartDets = new ArrayList<String>();

		for (String PartInfoKey : PartInfoKeys) {
			PartDets.add((String) request.getParameter(PartInfoKey));
		}

		try {
			// we don't know the PartID... lazy implementation, should be passed from addPart
			PreparedStatement preparedStatement2 = null;
			String query2 = "SELECT MAX(PartId) FROM Part;";
			preparedStatement2 = connection.prepareStatement(query2);
			ResultSet rs2 = preparedStatement2.executeQuery(query2);
			rs2.next();
			Integer partId = rs2.getInt(1);

			// but we dont know the vehicleId..
			PreparedStatement preparedStatement = null;

			String query = "SELECT vehicleID From Vehicle Where (makeName = ? AND modelName = ? AND year =?);";
			preparedStatement = connection.prepareStatement(query);

			int i = 0;
			for (String column : PartDets) {
				preparedStatement.setString(i + 1, PartDets.get(i));
				i++;
			}
			ResultSet rs = preparedStatement.executeQuery();
			rs.next();

			Integer vehicleId;
			if (rs.next() == true) {
				vehicleId = rs.getInt(1);
				//System.out.println(vehicleId);
			} else {
				vehicleId = createVehicle(PartDets, connection);
				//System.out.println(vehicleId);
			}

			// we know the vehicleId.. and e part Id.. 

			String insertTableSQL = "INSERT INTO FitsIn (partId, vehicleId) VALUES ('" + partId + "'," + vehicleId
					+ ");";

			preparedStatement = connection.prepareStatement(insertTableSQL);

			// execute insert SQL stetement
			preparedStatement.executeUpdate();

			System.out.println("Confirm");
		} catch (SQLException e) {

			System.out.println(e);
			System.out.println("FIts");
		}

	}%>

<%!public static Integer createVehicle(List<String> partDets, Connection connection) {

		Integer k = 0;
		try {
			PreparedStatement preparedStatement = null;

			String query = "SELECT MAX(vehicleId) FROM Vehicle;";

			preparedStatement = connection.prepareStatement(query);
			ResultSet rs = preparedStatement.executeQuery(query);

			rs.next();
			k = rs.getInt(1) + 1; /// whatever

			String insertTableSQL = "INSERT INTO Vehicle (vehicleId, makeName, modelName, year) VALUES (?, ?, ?, ?);";

			preparedStatement = connection.prepareStatement(insertTableSQL);
			preparedStatement.setInt(1, k); // so there are no duplicate vehicleId's fail

			int i = 2;
			for (String column : partDets) {
				preparedStatement.setString(i, partDets.get(i - 2));
				i++;
			}
			// execute insert SQL stetement
			preparedStatement.executeUpdate();
		} catch (SQLException e) {

			System.out.println(e);
			System.out.println("vehicle!?!?!?");
		}

		return k; // why? sheer laziness

	}%>
<%
	if (request.getParameter("modelName") != null) {
		createFitsIn(request, con);
	} else {
		System.out.println("Check fail");
	}
%>

<%
	connectionManager.close();
%>
</Body>