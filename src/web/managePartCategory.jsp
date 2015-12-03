<%@ include file="util_connection.jsp" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page import="java.text.NumberFormat" %>


<% Connection con = connectionManager.open(); %>
<%@ include file="util_user.jsp" %>

<%
  if (user == null || !user.get("accountType").equals("admin"))
  {
    session.setAttribute("message", Arrays.asList("info", "You do not have permission to view this page."));
    response.sendRedirect("signIn.jsp");
    return;
  }
%>

<%!
  public void createCategory(String name, String description, Connection connection, HttpSession session)
  {
    try
    {
      PreparedStatement createCategoryPS = connection.prepareStatement(
        "INSERT INTO PartCategory (categoryName, description) " +
          "VALUES (?, ?);"
      );
      createCategoryPS.setString(1, name);
      createCategoryPS.setString(2, description);
      createCategoryPS.executeUpdate();

      session.setAttribute("message", Arrays.asList("success", "Successfully created your category!"));
    }
    catch (SQLException e)
    {
      System.out.println(e);
      session.setAttribute("message", Arrays.asList("danger", "Failed to create category. Check that one with that name doesn't already exist."));
    }
  }
%>

<%!
  public void deleteCategory(String name, Connection connection, HttpSession session)
  {
    try
    {
      PreparedStatement deleteCategoryPS = connection.prepareStatement(
        "DELETE FROM PartCategory " +
          "WHERE categoryName=?;"
      );
      deleteCategoryPS.setString(1, name);
      deleteCategoryPS.executeUpdate();

      session.setAttribute("message", Arrays.asList("success", "Successfully deleted your category!"));
    }
    catch (SQLException e)
    {
      System.out.println(e);
      session.setAttribute("message", Arrays.asList("danger", "Failed to delete category. Check that it is not being used by any parts."));
    }
  }
%>

<%
  if (request.getMethod().equals("POST"))
  {
    String action = request.getParameter("action");
    String name = request.getParameter("categoryName");

    if (action.equals("create") && name != null)
    {
      String description = request.getParameter("description");
      createCategory(name, description, con, session);
    }
    else if (action.equals("delete") && name != null)
    {
      deleteCategory(name, con, session);
    }
  }
%>


<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>EverythingRoadster - Manage Part Categories</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="vendor/stylesheets/bootstrap.min.css">
    <link rel="stylesheet" href="stylesheets/main.css">
    <link rel="stylesheet" href="stylesheets/browse.css">

    <script src="vendor/javascripts/modernizr-2.8.3-respond-1.4.2.min.js"></script>
    <script src="vendor/javascripts/jquery-2.1.4.min.js"></script>
    <script src="vendor/javascripts/bootstrap.min.js"></script>
    <script src="javascripts/browse.js"></script>
  </head>

  <body>
    <%@ include file="util_navbar.jsp" %>
    <%@ include file="util_message.jsp" %>

    <div class="container-fluid">
      <div class="row">
        <div class="col-xs-12">
          <h1>Create Part Category</h1>
        </div>
      </div>

      <div class="row">
        <form class="col-xs-12" action="./managePartCategory.jsp" method="POST">
          <div class="form-group">
            <label for="name-input">Name</label>
            <input id="name-input" class="form-control" type="text" name="categoryName"/>
          </div>
          <div class="form-group">
            <label for="description-input">Description</label>
            <textarea id="description-input" class="form-control" type="text" name="description"></textarea>
          </div>
          <button class="btn btn-success" type="submit" name="action" value="create">Create Category</button>
        </form>
      </div>

      <div class="row">
        <div class="col-xs-12">
          <h1>Existing Part Categories</h1>
        </div>

      </div>

      <div class="row">
        <table class="col-xs-12 table table-striped">
          <thead>
            <tr>
              <th>Name</th>
              <th>Description</th>
              <th>Number of Uses</th>
              <th>Delete</th>
            </tr>
          </thead>

          <tbody>

<%
  PreparedStatement categoriesPS = con.prepareStatement(
    "SELECT C.categoryName, C.description, COUNT(P.partId) AS numUses " +
      "FROM PartCategory C " +
        "LEFT OUTER JOIN Part P ON P.categoryName=C.categoryName " +
      "GROUP BY C.categoryName, C.description;"
  );
  ResultSet categoriesRS = categoriesPS.executeQuery();

  while (categoriesRS.next())
  {
    String name = categoriesRS.getString("categoryName");
    String description = categoriesRS.getString("description");
    Integer numUses = categoriesRS.getInt("numUses");

    String categoryHtml = String.format(
           "<tr>" +
             "<td>%s</td>" +
             "<td>%s</td>" +
             "<td>%d</td>" +
             "<td>" +
               "<form action=\"\" method=\"POST\">" +
                 "<input type=\"hidden\" name=\"categoryName\" value=\"%s\" />" +
                 "<button class=\"btn btn-default glyphicon glyphicon-remove\" type=\"submit\" name=\"action\" value=\"delete\"></button>" +
               "</form>" +
             "</td>" +
           "</tr>",
    name, description, numUses, name);
    out.println(categoryHtml);
  }
%>

          </tbody>
        </table>
      </div>
    </div>

    <%@ include file="util_copyright.jsp" %>

  </body>
</html>


<% connectionManager.close(); %>
