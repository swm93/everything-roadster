<%@ include file="util_connection.jsp" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>


<% final int maxRecentParts = 3; %>

<% Connection con = connectionManager.open(); %>

<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>EverythingRoadster</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="vendor/stylesheets/bootstrap.min.css">
    <link rel="stylesheet" href="stylesheets/main.css">
    <link rel="stylesheet" href="stylesheets/index.css">

    <script src="vendor/javascripts/modernizr-2.8.3-respond-1.4.2.min.js"></script>
    <script src="vendor/javascripts/jquery-2.1.4.min.js"></script>
    <script src="vendor/javascripts/bootstrap.min.js"></script>
  </head>

  <body>
    <%@ include file="util_navbar.jsp" %>
    <%@ include file="util_message.jsp" %>

    <div class="jumbotron">
      <div id="new-parts-carousel-container" class="container-fluid">
        <div id="carousel-new-parts" class="carousel slide" data-ride="carousel">
          <ol class="carousel-indicators">
<%
  //load parts
  PreparedStatement recentPartsPS = con.prepareStatement(
    "SELECT P.partName, P.imagePath " +
      "FROM Part P " +
        "JOIN ListedPart LP ON P.partId = LP.partId " +
      "ORDER BY LP.dateListed DESC " +
      "LIMIT ?;"
  );
  recentPartsPS.setInt(1, maxRecentParts);
  ResultSet recentPartsRS = recentPartsPS.executeQuery();

  int numRecentParts = 0;
  if (recentPartsRS.last())
  {
    numRecentParts = recentPartsRS.getRow();
    recentPartsRS.beforeFirst();
  }

  for (int i=0; i < numRecentParts; i++)
  {
    String active = (i == 0) ? " active" : "";
    String html = String.format(
           "<li data-target=\"#carousel-example-generic\" data-slide-to=\"%d\" class=\"slide %s\"></li>",
    i, active);

    out.println(html);
  }
%>
          </ol>

          <h3 class="carousel-header">Recently Listed Parts</h3>

          <div class="carousel-inner" role="listbox">
<%
  while (recentPartsRS.next())
  {
    String name = recentPartsRS.getString("partName");
    String imagePath = recentPartsRS.getString("imagePath");
    String active = (recentPartsRS.getRow() == 1) ? " active" : "";

    String html = String.format(
           "<div class=\"item%s\">" +
             "<img src=\"%s\" onerror=\"if (this.src != 'public/images/parts/part_default.jpg') this.src = 'public/images/parts/part_default.jpg';\">" +
             "<h4 class=\"carousel-title\">%s</h4>" +
           "</div>",
    active, imagePath, name);

    out.println(html);
  }
%>
          </div>

          <a class="left carousel-control" href="#carousel-new-parts" role="button" data-slide="prev">
            <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
          </a>
          <a class="right carousel-control" href="#carousel-new-parts" role="button" data-slide="next">
            <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
            <span class="sr-only">Next</span>
          </a>
        </div>
      </div>
    </div>

    <hr>

    <div id="part-categories-container" class="container-fluid">
      <h2>Browse Parts</h2>
      <ul class="list-group">
        <a href="browse.jsp" class="list-group-item">All</a>
<%
  //load parts
  PreparedStatement partCategoriesPS = con.prepareStatement(
    "SELECT P.categoryName, COUNT(*) AS numParts " +
      "FROM Part P " +
        "JOIN ListedPart LP ON P.partId = LP.partId " +
      "GROUP BY P.categoryName;"
  );
  ResultSet partCategoriesRS = partCategoriesPS.executeQuery();

  while (partCategoriesRS.next())
  {
    String category = partCategoriesRS.getString("categoryName");
    int numParts = partCategoriesRS.getInt("numParts");

    String html = String.format(
       "<a href=\"browse.jsp?category=%s\" class=\"list-group-item\">" +
         "<span class=\"badge\">%d</span>" +
         "<span>%s</span>" +
       "</a>",
    category, numParts, category);

    out.println(html);
  }
%>
      </ul>
    </div>

    <%@ include file="util_copyright.jsp" %>

  </body>
</html>

<% connectionManager.close(); %>
