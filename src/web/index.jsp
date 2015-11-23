<%@ include file="util_connection.jsp" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>


<% final int maxRecentParts = 3; %>

<% Connection con = connectionManager.open(); %>

<!doctype html>
<html class="no-js" lang="">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title>EverythingRoadster</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="stylesheet" href="vendor/stylesheets/bootstrap.min.css">
        <link rel="stylesheet" href="stylesheets/main.css">
        <link rel="stylesheet" href="stylesheets/home/index.css">

        <script src="vendor/javascripts/modernizr-2.8.3-respond-1.4.2.min.js"></script>
    </head>

    <body>
      <nav class="navbar navbar-default navbar-fixed-top" role="navigation">
        <div class="container-fluid">
          <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">
              <img class="navbar-brand-image" src="assets/images/logo02.jpg" />
              <span>EverythingRoadster</span>
            </a>
          </div>
          <div id="navbar" class="navbar-collapse collapse">
            <ul class="nav navbar-nav navbar-right">
              <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                  <span class="glyphicon glyphicon-shopping-cart"></span>
                  <span>Cart</span>
                  <span class="badge">3</span>
                </a>
                <ul class="dropdown-menu">
                  <li>
                    <a href="#">
                      <span class="badge">1</span>
                      <span>Power Steering Pump</span>
                    </a>
                  </li>
                  <li>
                    <a href="#">
                      <span class="badge">1</span>
                      <span>Head Gasket</span>
                    </a>
                  </li>
                  <li>
                    <a href="#">
                      <span class="badge">1</span>
                      <span>Turbo Charger</span>
                    </a>
                  </li>
                </ul>
              </li>
              <li class="navbar-form">
                <button type="submit" class="btn btn-danger">Sign in</button>
              </li>
            </ul>
          </div>
        </div>
      </nav>

      <div class="jumbotron">
        <div id="new-parts-carousel-container" class="container">
          <div id="carousel-new-parts" class="carousel slide" data-ride="carousel">
            <ol class="carousel-indicators">
<%
  //load parts
  PreparedStatement recentPartsPS = con.prepareStatement(
    "SELECT P.partName, P.imagePath " +
      "FROM Part P " +
        "JOIN ListedPart LP ON P.partId = LP.partId " +
      "ORDER BY LP.dateListed ASC " +
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
               "<img src=\"%s\">" +
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

      <div id="part-categories-container" class="container">
        <h2>Part Categories</h2>
        <ul class="list-group">
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
         "<a href=\"/browse?category=%s\" class=\"list-group-item\">" +
           "<span class=\"badge\">%d</span>" +
           "<span>%s</span>" +
         "</a>",
    category, numParts, category);

    out.println(html);
  }
%>
        </ul>
      </div>

      <hr>

      <div id="copyright-container" class="container">
        <footer>
          <p>&copy; EverythingRoadster 2015</p>
        </footer>
      </div>

      <script src="vendor/javascripts/jquery-2.1.4.min.js"></script>
      <script src="vendor/javascripts/bootstrap.min.js"></script>
      <script src="javascripts/bootstrap.min.js"></script>
    </body>
</html>


<% connectionManager.close(); %>
