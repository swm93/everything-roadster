<!-- due to the FK restraints it's prone to errors -->

<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>


<% Connection con = connectionManager.open(); %>

<%!
  void createPart(HttpServletRequest request, Connection connection) {
    String[] PartInfoKeys = { "categoryName", "partName", "description", "imagePath" };

    List<String> PartDets = new ArrayList<String>();

    for (String PartInfoKey : PartInfoKeys) {
      PartDets.add((String) request.getParameter(PartInfoKey));
    }

    try {

      PreparedStatement preparedStatement = null;

      String query = "SELECT MAX(PartId) FROM Part;";

      preparedStatement = connection.prepareStatement(query);
      ResultSet rs = preparedStatement.executeQuery(query);

      rs.next();
      Integer k = rs.getInt(1);

      String insertTableSQL = "INSERT INTO Part (PartId, categoryName, partName, description, imagePath)" + "VALUES"
          + "(?,?,?,?,?)";

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
      
      // int toBePass = k+1; (k+1 = partId)
    } catch (Exception e) {

      System.out.println(e);
    }

  }
%>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>EverythingRoadster - Add Part</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="vendor/stylesheets/bootstrap.min.css">
    <link rel="stylesheet" href="stylesheets/main.css">
    <link rel="stylesheet" href="stylesheets/addPart.css">

    <script src="vendor/javascripts/modernizr-2.8.3-respond-1.4.2.min.js"></script>
    <script src="vendor/javascripts/jquery-2.1.4.min.js"></script>
    <script src="vendor/javascripts/bootstrap.min.js"></script>
  </head>

  <body>
    <%@ include file="util_navbar.jsp" %>

    <div class="container-fluid">
      <div class="row">
        <div class="col-xs-12">
          <h1>Part Creation Page</h1>
        </div>
      </div>

      <form class="add-part-form row" action="./addPart.jsp" method="POST">
        <div class="col-xs-12">
          <div class="form-group">
            <label for="part-name-input">Part Name</label>
            <input id="part-name-input" class="form-control"  type="text" name="partName" />
          </div>
          <div class="form-group">
            <label for="category-name-input">Category Name</label>
            <select id="category-name-input" class="form-control" name="categoryName">

<%
  PreparedStatement categoryNamesPS = con.prepareStatement(
    "SELECT categoryName " +
      "FROM PartCategory;"
  );
  ResultSet categoryNamesRS = categoryNamesPS.executeQuery();

  while (categoryNamesRS.next())
  {
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
            <label for="description-input">Description</label>
            <input id="description-input" class="form-control"  type="text" name="description" />
          </div>
          <div class="form-group">
            <label for="image-path-input">Image Path</label>
            <input id="image-path-input" class="form-control"  type="text" name="imagePath" />
          </div>

          <button class="btn btn-success" type="submit">Add Part</button>
        </div>
      </div>
    </form>

<%
  if (request.getParameter("partName") != null) {
    createPart(request, con);
  } else {
    System.out.println("here");
  }
%>

    <%@ include file="util_copyright.jsp" %>

  </body>
</html>

<% connectionManager.close(); %>
