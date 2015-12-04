<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Arrays" %>


<% Connection con = connectionManager.open(); %>

<%!
  public void checkExists(HttpServletRequest request, Connection connection, HttpSession session) {
    String[] PartInfoKeys = {"makeName", "modelName", "year"};

    List<String> PartDets = new ArrayList<String>();

    for (int i=0; i<PartInfoKeys.length; i++) {
      String PartInfoKey = PartInfoKeys[i];
      PartDets.add((String) request.getParameter(PartInfoKey));
    }

    PreparedStatement preparedStatement = null;
    try {

      String query = "SELECT vehicleId FROM Vehicle WHERE makeName=? AND modelName=? AND year=?;";
      preparedStatement = connection.prepareStatement(query);

      preparedStatement.setString(1, PartDets.get(0));
      preparedStatement.setString(2, PartDets.get(1));
      Integer year = Integer.parseInt(PartDets.get(2));
      preparedStatement.setInt(3, year);

      ResultSet rs = preparedStatement.executeQuery();
      if(rs.next()){
        System.out.println("Vehicle exists already");
      }else{
        createVehicle(PartDets, connection, session);
      }
    } catch (SQLException e) {

      System.out.println(e);
    }
  }
%>

<%!
public static void createVehicle(List<String> PartDets, Connection connection, HttpSession session) {
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

      for (int i=0; i<PartDets.size(); i++) {
        preparedStatement.setString(i+2, PartDets.get(i));
      }
      // execute insert SQL stetement
      preparedStatement.executeUpdate();

      System.out.println("Vehicle Created");
      session.setAttribute("message", Arrays.asList("success", "Your vehicle has been successfully created!"));
    } catch (SQLException e) {

      System.out.println(e);
      session.setAttribute("message", Arrays.asList("danger", "Failed to create your vehicle."));
    }
  }
%>

<%
  if (request.getParameter("modelName") != null) {
    checkExists(request, con, session);
  } else {
    System.out.println("Nothing Entered- yet");
  }
%>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>EverythingRoadster - Create Vehicle</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="vendor/stylesheets/bootstrap.min.css">
    <link rel="stylesheet" href="stylesheets/main.css">

    <script src="vendor/javascripts/modernizr-2.8.3-respond-1.4.2.min.js"></script>
    <script src="vendor/javascripts/jquery-2.1.4.min.js"></script>
    <script src="vendor/javascripts/bootstrap.min.js"></script>
  </head>

  <body>
    <%@ include file="util_navbar.jsp" %>
    <%@ include file="util_message.jsp" %>

    <div class="container-fluid">
      <div class="row">
        <div class="col-xs-12">
          <h1>Create Vehicle</h1>
        </div>
      </div>

      <form class="remove-vehicle-form row" action="./createVehicle.jsp" method="POST">
        <div class="col-xs-12 col-sm-5 form-group">
          <label for="make-name-input">Make Name</label>
          <input id="make-name-input" class="form-control" name="makeName" type="text" />
        </div>
        <div class="col-xs-12 col-sm-5 form-group">
          <label for="model-name-input">Model Name</label>
          <input id="model-name-input" class="form-control" name="modelName" type="text" />
        </div>
        <div class="col-xs-12 col-sm-2 form-group">
          <label for="year-input">Year</label>
          <input id="year-input" class="form-control" name="year" type="text" />
        </div>
        <div class="col-xs-12">
          <button class="btn btn-success" type="submit">Create Vehicle</button>
        </div>
      </form>
    </div>

    <%@ include file="util_copyright.jsp" %>

  </body>
</html>

<% connectionManager.close(); %>
