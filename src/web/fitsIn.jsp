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
	<b> Which vehicle(s) does this part fit in?</b>
	<b> if there are multiple vehicles, enter one at a time</b> vehicleId,
	<form action="./fitsIn.jsp" method="POST">
		<b>"makeName"</b> <input type="text" name="makeName" size="50">
		<b>"modelName"</b> <input type="text" name="modelName" size="50">
		<b>"year"</b> <input type="text" name="year" size="50">
		<button type="submit">AddPart</button>
	</form>
</head>

<%!void createFitsIn(HttpServletRequest request, Connection connection) {
		
	
		Integer partId = 12;
	
		String[] PartInfoKeys = {"makeName", "modelName", "year"};
	
		List<String> PartDets = new ArrayList<String>();

		for (String PartInfoKey : PartInfoKeys) {
			PartDets.add((String) request.getParameter(PartInfoKey));
		}

		// but we dont know the vehicleId..
		try {

			PreparedStatement preparedStatement = null;

			String query = "SELECT vehicleID From Vehicle Where (makeName = ? AND modelName = ? AND year =?);";
			preparedStatement = connection.prepareStatement(query);
			
			int i = 0;
			for (String column : PartDets) {
				preparedStatement.setString(i+1, PartDets.get(i));
				i++;
			}
			ResultSet rs = preparedStatement.executeQuery(query);
			rs.next();

			Integer vehicleId =0;
			if(rs.next()==true){
			vehicleId = rs.getInt(0);
				
			}else{
				vehicleId = createVehicle(PartDets,connection);
			}

			// we know the vehicleId.. and e part Id.. 

			String insertTableSQL = "INSERT INTO FitsIn (partId, vehicleId) VALUES ('"+partId +"'," + vehicleId +");";
	

			preparedStatement = connection.prepareStatement(insertTableSQL);

		
			// execute insert SQL stetement
			preparedStatement.executeUpdate();

			System.out.println("Confirm");
		} catch (SQLException e) {

			System.out.println(e);
			System.out.println("HOW DID YOU EVEN GET HERE!?!?!?");
		}

	}%>

<%!public static Integer createVehicle(List<String> partDets,Connection connection) {

	Integer k =0;
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
		System.out.println("HOW DID YOU EVEN GET HERE- vehicle!?!?!?");
	}
	
	
	return k; // why? sheer laziness

}


	%>
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