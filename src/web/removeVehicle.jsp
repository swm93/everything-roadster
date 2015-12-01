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
        removeVehicle(vID, connection, session);
        System.out.println("vehicle was removed");
        session.setAttribute("message", Arrays.asList("success", "Your vehicle was successfully removed!"));
      } else {
        System.out.println("vehicle doesn't exist");
        session.setAttribute("message", Arrays.asList("danger", "Failed to remove your vehicle."));
      }
    } catch (SQLException e) {

      System.out.println(e);
      session.setAttribute("message", Arrays.asList("danger", "Failed to remove your vehicle."));
    }
  }
%>

<%!
public static void removeVehicle(int removeId, Connection connection, HttpSession session) {

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

  }
%>

<%
  if ((request.getParameter("modelName") != null) && (request.getParameter("makeName") != null) && (request.getParameter("year") != null))
  {
    checkExists(request, con, session);
  }
  else
  {
    System.out.println("Nothing Entered- yet");
  }
%>


<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>EverythingRoadster - Remove Vehicle</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="vendor/stylesheets/bootstrap.min.css">
    <link rel="stylesheet" href="stylesheets/main.css">

    <script src="vendor/javascripts/modernizr-2.8.3-respond-1.4.2.min.js"></script>
    <script src="vendor/javascripts/jquery-2.1.4.min.js"></script>
    <script src="vendor/javascripts/bootstrap.min.js"></script>
    <script src="vendor/javascripts/underscore-min.js"></script>
    <script src="javascripts/removeVehicle.js"></script>
    <script>
      var vehicles = [];
<%
  PreparedStatement vehiclePS = con.prepareStatement(
    "SELECT * " +
      "FROM Vehicle;"
  );
  ResultSet vehicleRS = vehiclePS.executeQuery();

  while (vehicleRS.next())
  {
    String make = vehicleRS.getString("makeName");
    String model = vehicleRS.getString("modelName");
    Integer year = vehicleRS.getInt("year");

    String vehicleHtml = String.format(
      "vehicles.push({makeName: \"%s\", modelName: \"%s\", year: \"%s\"});",
    make, model, year);
    out.println(vehicleHtml);
  }
%>
  </script>
  </head>

  <body>
    <%@ include file="util_navbar.jsp" %>
    <%@ include file="util_message.jsp" %>

    <div class="container-fluid">
      <div class="row">
        <div class="col-xs-12">
          <h1>Remove Vehicle</h1>
        </div>
      </div>

      <form class="remove-vehicle-form row" action="./removeVehicle.jsp" method="POST">
        <div class="col-xs-12 col-sm-5 form-group">
          <label for="make-name-input">Make Name</label>
          <select id="make-name-input" class="filtered-select form-control" name="makeName"></select>
        </div>
        <div class="col-xs-12 col-sm-5 form-group">
          <label for="model-name-input">Model Name</label>
          <select id="model-name-input" class="filtered-select form-control" name="modelName"></select>
        </div>
        <div class="col-xs-12 col-sm-2 form-group">
          <label for="year-input">Year</label>
          <select id="year-input" class="filtered-select form-control" name="year"></select>
        </div>
        <div class="col-xs-12">
          <button class="btn btn-success" type="submit">Remove Vehicle</button>
        </div>
      </div>
    </form>

    <%@ include file="util_copyright.jsp" %>

  </body>
</html>

<% connectionManager.close(); %>