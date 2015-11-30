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
	<form action="./vehicleCreate.jsp" method="POST">
		<b>"makeName"</b> <input type="text" name="makeName" size="50">
		<b>"modelName"</b> <input type="text" name="modelName" size="50">
		<b>"year"</b> <input type="text" name="year" size="50">
		<button type="submit">create Vehicle</button>
	</form>
</head>

<%! public void checkExists(HttpServletRequest request, Connection connection){
	String[] PartInfoKeys = {"makeName", "modelName", "year"};

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
		if(rs.next()){
			System.out.println("Vehicle exists already");
		}else{
			createVehicle(PartDets, connection);
		}
	} catch (SQLException e) {

		System.out.println(e);
	}
}

%>
<%!public static void createVehicle(List<String> PartDets,Connection connection) {

	
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
	for (String column : PartDets) {
		preparedStatement.setString(i, PartDets.get(i - 2));
		i++;
	}
	// execute insert SQL stetement
	preparedStatement.executeUpdate();
	} catch (SQLException e) {

		System.out.println(e);
	}
	System.out.println("Vehicle Created");
	

}


	%>
<%
	if (request.getParameter("modelName") != null) {
		checkExists(request, con);
	} else {
		System.out.println("Nothing Entered- yet");
	}
%>

<%
	connectionManager.close();
%>
</Body>