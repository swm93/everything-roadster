<!-- due to the FK restraints it's prone to errors -->

<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Arrays"%>


<% Connection con = connectionManager.open(); %>

<%!
  void createPart(HttpServletRequest request, Connection connection, HttpSession session) {
    try
    {
      // get part id
      PreparedStatement partIdPS = connection.prepareStatement(
        "SELECT MAX(partId) " +
          "FROM Part;"
      );

      ResultSet partIdRS = partIdPS.executeQuery();
      partIdRS.next();
      Integer partId = partIdRS.getInt(1) + 1;

      // get all vehicles ids for fits in associations
      String[] fitsInMake = request.getParameterValues("fitsInMakeName[]");
      String[] fitsInModel = request.getParameterValues("fitsInModelName[]");
      String[] fitsInYear = request.getParameterValues("fitsInYear[]");
      PreparedStatement vehiclePS = connection.prepareStatement(
        "SELECT V.vehicleId " +
          "FROM Vehicle V " +
          "WHERE V.makeName=? " +
            "AND V.modelName=? " +
            "AND V.year=?;"
      );

      ArrayList<Integer> vehicleIds = new ArrayList<Integer>();
      for (int i=0; i<fitsInMake.length; i++)
      {
        vehiclePS.setString(1, fitsInMake[i]);
        vehiclePS.setString(2, fitsInModel[i]);
        vehiclePS.setString(3, fitsInYear[i]);

        ResultSet vehicleRS = vehiclePS.executeQuery();
        if (vehicleRS.next())
        {
          vehicleIds.add(vehicleRS.getInt("vehicleId"));
        }
      }

      // disable auto commit so we can rollback inserts if an error occurs
      connection.setAutoCommit(false);

      // create part
      PreparedStatement createPartPS = connection.prepareStatement(
        "INSERT INTO Part (partId, categoryName, partName, description, imagePath) " +
          "VALUES (?, ?, ?, ?, ?);"
      );
      createPartPS.setInt(1, partId);
      createPartPS.setString(2, request.getParameter("categoryName"));
      createPartPS.setString(3, request.getParameter("partName"));
      createPartPS.setString(4, request.getParameter("description"));
      createPartPS.setString(5, "public/images/parts/" + request.getParameter("imagePath") + ".jpg");
      createPartPS.executeUpdate();

      // create fits in associations
      PreparedStatement createFitsInPS = connection.prepareStatement(
        "INSERT INTO FitsIn (partId, vehicleId) " +
          "VALUES (?, ?);"
      );
      createFitsInPS.setInt(1, partId);
      for (Integer vId : vehicleIds)
      {
        createFitsInPS.setInt(2, vId);
        createFitsInPS.executeUpdate();
      }

      connection.commit();

      System.out.println("Your part has been added");
      session.setAttribute("message", Arrays.asList("success", "Your part has been created!"));
    }
    catch (Exception e)
    {
      System.out.println(e);

      try
      {
        connection.rollback();
      }
      catch (SQLException re) {
        System.out.println(re);
      }

      session.setAttribute("message", Arrays.asList("danger", "Failed to create your part."));
    }
    finally
    {
      try
      {
        connection.setAutoCommit(true);
      }
      catch (SQLException ce) {
        System.out.println(ce);
      }
    }
  }
%>

<%
  if (request.getMethod().equals("POST"))
  {
    if (request.getParameter("partName") != null && !request.getParameter("partName").equals(""))
    {
      createPart(request, con, session);
    }
    else
    {
      System.out.println("nothing entered");
      session.setAttribute("message", Arrays.asList("danger", "Failed to create your part."));
    }
  }
%>


<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>EverythingRoadster - Create Part</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="vendor/stylesheets/bootstrap.min.css">
    <link rel="stylesheet" href="stylesheets/main.css">
    <link rel="stylesheet" href="stylesheets/createPart.css">

    <script src="vendor/javascripts/modernizr-2.8.3-respond-1.4.2.min.js"></script>
    <script src="vendor/javascripts/jquery-2.1.4.min.js"></script>
    <script src="vendor/javascripts/bootstrap.min.js"></script>
    <script src="vendor/javascripts/underscore-min.js"></script>
    <script src="javascripts/createPart.js"></script>
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

    String vehicleJS = String.format(
      "vehicles.push({makeName: \"%s\", modelName: \"%s\", year: \"%s\"});",
    make, model, year);
    out.println(vehicleJS);
  }
%>
    </script>
  </head>

  <body>
    <%@ include file="util_navbar.jsp"%>
    <%@ include file="util_message.jsp"%>

    <form class="container-fluid" action="./createPart.jsp" method="POST">
      <div class="row">
        <div class="col-xs-12">
          <h1>Create Part</h1>
        </div>
      </div>

      <div class="add-part-row row">
        <div class="col-xs-12">
          <div class="form-group">
            <label for="part-name-input">Part Name</label>
            <input id="part-name-input" class="form-control" type="text" name="partName" />
          </div>
          <div class="form-group">
            <label for="category-name-input">Category Name</label>
            <select id="category-name-input" class="form-control" name="categoryName">

<%
  PreparedStatement categoryNamesPS = con.prepareStatement("SELECT categoryName " + "FROM PartCategory;");
  ResultSet categoryNamesRS = categoryNamesPS.executeQuery();

  while (categoryNamesRS.next()) {
    String categoryName = categoryNamesRS.getString("categoryName");
    String categoryOptionHtml = String.format(
             "<option value=\"%s\">%s</option>",
      categoryName, categoryName);

    out.println(categoryOptionHtml);
  }
%>

            </select>
          </div>
          <div class="form-group">
            <label for="description-input">Description</label> <input
              id="description-input" class="form-control" type="text"
              name="description" />
          </div>
          <div class="form-group">
            <label for="image-path-input">Image Path</label> <input
              id="image-path-input" class="form-control" type="text"
              name="imagePath" />
          </div>
        </div>
      </div>

      <div id="part-fits-in-container">
        <div class="row">
          <div class="col-xs-12">
            <button id="add-fits-in-btn" class="btn btn-default" type="button">+</button>
            <h2 class="fits-in-header">Fits In Associations</h2>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-xs-12">
          <button class="btn btn-success" type="submit">Add Part</button>
        </div>
      </div>
    </form>

    <%@ include file="util_copyright.jsp"%>

  </body>
</html>

<% connectionManager.close(); %>
