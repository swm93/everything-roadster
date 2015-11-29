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
	<form action="./fitsIn.jsp" method="POST">
		<b>"makeName"</b> <input type="text" name="makeName" size="50">
		<b>"modelName"</b> <input type="text" name="modelName" size="50">
		<b>"year"</b> <input type="text" name="year" size="50">
		<button type="submit">create Vehicle</button>
	</form>
</head>

<%!void createFitsIn(HttpServletRequest request, Connection connection) {
		
	
	Integer partId = 12;
	
		String[] PartInfoKeys = {"makeName", "modelName", "year"};
	
		List<String> PartDets = new ArrayList<String>();

		for (String PartInfoKey : PartInfoKeys) {
			PartDets.add((String) request.getParameter(PartInfoKey));
		}

		try {

			PreparedStatement preparedStatement = null;

			String query = "SELECT vehicleID From Vehicle Where (makeName = '?' AND modelName = '?' AND year = '?');";
			
			preparedStatement = connection.prepareStatement(query);

			ResultSet rs = preparedStatement.executeQuery(query);
			rs.next();

			Integer vehicleId =0;
			if(rs.next()==true){
				
			}else{
				vehicleId = createVehicle(PartDets,connection);
			}



			System.out.println("Confirm");
		} catch (SQLException e) {

			System.out.println(e);
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