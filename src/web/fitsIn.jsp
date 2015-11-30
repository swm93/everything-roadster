<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>

-- To Do Scott: it is possible to make drop down menus for the model, make, year? 
-- Something that iterates through the current vehicle makes, models + years?
-- If they select something weird, the exceptions are handled via auto creating the vehicle
-- so if he made like a ford Caravan from 1950, it technically could be built. 
-- with the FK restraints however our users (Ramon), could have issues makeing something
-- example: he makes a part, he gets here he tries to make it fit into a "Dodg Viper 2013". The page won't crash
-- but dodg != dodge, so he couldn;t add it.

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
	<form action="./fitsIn.jsp" method="POST">
		<b>"makeName"</b> <input type="text" name="makeName" size="50">
		<b>"modelName"</b> <input type="text" name="modelName" size="50">
		<b>"year"</b> <input type="text" name="year" size="50">
		<button type="submit">AddPart</button>
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