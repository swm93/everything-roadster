<%@ include file="util_connection.jsp" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>


<% final int maxRecentParts = 3; %>

<% Connection con = connectionManager.open(); %>

<!doctype html>
<html class="no-js" lang="">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title>EverythingRoadster - Browse</title>
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

      <div class="container-fluid">
        <div class="row">
          <form id="browse-sidebar-container" action="browse.jsp" method="GET">
            <button id="browse-apply-btn" class="btn btn-success" type="submit">Apply</button>
            <button id="browse-apply-btn" class="btn btn-danger" type="reset">Clear</button>

            <hr>

            <input id="browse-search-input" class="form-control" name="search" type="text" placeholder="Search" />

            <div class="filter-container">
              <hr>
              <h4>Part Categories</h4>
              <ul class="list-unstyled">
<%
  //load parts
  PreparedStatement partCategoriesPS = con.prepareStatement(
    "SELECT categoryName " +
      "FROM PartCategory;"
  );
  ResultSet partCategoriesRS = partCategoriesPS.executeQuery();

  while (partCategoriesRS.next())
  {
    String category = partCategoriesRS.getString("categoryName");
    String categoryStripped = category.replaceAll("\\s", "-").toLowerCase();

    String html = String.format(
               "<li>" +
                 "<input id=\"category-%s-checkbox\" class=\"filter-checkbox\" type=\"checkbox\" name=\"category\" value=\"%s\" /> " +
                 "<label for=\"category-%s-checkbox\">%s</label>" +
               "</li>",
    categoryStripped, categoryStripped, categoryStripped, category);

    out.println(html);
  }
%>
              </ul>
            </div>

            <div class="filter-container">
              <hr>
              <h4>Vehicle Makes</h4>
              <ul class="list-unstyled">
<%
  //load parts
  PreparedStatement makesPS = con.prepareStatement(
    "SELECT name " +
      "FROM Make;"
  );
  ResultSet makesRS = makesPS.executeQuery();

  while (makesRS.next())
  {
    String make = makesRS.getString("name").replaceAll("\\s", "");
    String makeStripped = make.replaceAll("\\s", "-").toLowerCase();

    String html = String.format(
               "<li>" +
                 "<input id=\"make-%s-checkbox\" class=\"filter-checkbox\" type=\"checkbox\" name=\"make\" value=\"%s\" /> " +
                 "<label for=\"make-%s-checkbox\">%s</label>" +
               "</li>",
    makeStripped, makeStripped, makeStripped, make);

    out.println(html);
  }
%>
              </ul>
            </div>

            <div class="filter-container">
              <hr>
              <h4>Vehicle Models</h4>
              <ul class="list-unstyled">
<%
  //load parts
  PreparedStatement modelsPS = con.prepareStatement(
    "SELECT name " +
      "FROM Model;"
  );
  ResultSet modelsRS = modelsPS.executeQuery();

  while (modelsRS.next())
  {
    String model = modelsRS.getString("name").replaceAll("\\s", "");
    String modelStripped = model.replaceAll("\\s", "-").toLowerCase();

    String html = String.format(
               "<li>" +
                 "<input id=\"model-%s-checkbox\" class=\"filter-checkbox\" type=\"checkbox\" name=\"model\" value=\"%s\" /> " +
                 "<label for=\"model-%s-checkbox\">%s</label>" +
               "</li>",
    modelStripped, modelStripped, modelStripped, model);

    out.println(html);
  }
%>
              </ul>
            </div>

          </form>

          <div id="browse-main-container" class="container-fluid">
            <div class="row">
<%
  String partsSQL = new String(
    "SELECT LP.listId, P.partName, LP.price, LP.quantity, P.imagePath, P.categoryName, P.description " +
      "FROM ListedPart LP " +
        "JOIN Part P ON P.partId=LP.partId " +
        "JOIN FitsIn F ON F.partId=P.partId " +
        "JOIN Vehicle V ON V.vehicleId=F.vehicleId "
  );
  Map<String, String[]> parameterMap = request.getParameterMap();
  List<String> whereParams = new ArrayList<String>();
  boolean addedWhere = false;

  for (Map.Entry<String, String[]> entry : parameterMap.entrySet())
  {
    String key = entry.getKey();
    String[] values = entry.getValue();

    if (values.length == 0 || values[0].equals(""))
    {
      continue;
    }

    if (!addedWhere)
    {
      partsSQL += "WHERE ";
      addedWhere = true;
    }
    else
    {
      partsSQL += "AND ";
    }

    if (key.equals("search"))
    {
      partsSQL += "partName LIKE ? ";
      whereParams.add("%" + String.join(" ", values) + "%");
    }
    else
    {
      String questionMarks = new String(new char[values.length-1]).replace("\0", ", ?");
      partsSQL += key + "Name IN (";

      for (int i = 0; i < values.length; i++)
      {
        partsSQL += "?, ";
        whereParams.add(values[i]);
      }
      partsSQL = partsSQL.substring(0, partsSQL.length()-2);
      partsSQL += ") ";
    }
  }

  partsSQL += "GROUP BY LP.listId;";

  PreparedStatement partsPS = con.prepareStatement(partsSQL);
  for (int i = 0; i < whereParams.size(); i++)
  {
    partsPS.setString(i+1, whereParams.get(i));
  }

  ResultSet partsRS = partsPS.executeQuery();

  while (partsRS.next())
  {
    int partId = partsRS.getInt("listId");
    String partName = partsRS.getString("partName");
    int quantity = partsRS.getInt("quantity");
    float price = partsRS.getFloat("price");
    String image = partsRS.getString("imagePath");
    String category = partsRS.getString("categoryName");
    String description = partsRS.getString("description");

    String partsHTML = String.format(
               "<div class=\"panel-container col-xs-6 col-sm-4 col-md-3 col-lg-2\">" +
                 "<div class=\"panel panel-default\">" +
                   "<div class=\"panel-heading\">%s</div>" +
                   "<div class=\"panel-body\">" +
                     "<img class=\"panel-img\" src=\"%s\" />" +
                     "<div>" +
                       "<span><b>Category: </b></span>" +
                       "<span>%s</span>" +
                     "</div>" +
                     "<p>%s</p>" +
                     "<form class=\"add-to-cart-container\">" +
                       "<button class=\"add-to-cart-btn btn btn-success\">" +
                         "<span class=\"glyphicon glyphicon-plus\"></span> " +
                         "<span>Add to Cart</span>" +
                       "</button>" +
                       "<label class=\"add-to-cart-quantity-label\" for=\"part-%s-quantity\">Quantity: </label>" +
                       "<input id=\"part-%s-quantity\" class=\"add-to-cart-input form-control\" name=\"part-%s-quantity\" value=\"1\" />" +
                     "</form>" +
                   "</div>" +
                 "</div>" +
               "</div>",
    partName, image, category, description, partId, partId, partId);

    out.println(partsHTML);
  }
%>
            </div>

            <div class="row">
            </div>
          </div>

        </div>
      </div>

      <%@ include file="util_copyright.jsp" %>

    </body>
</html>


<% connectionManager.close(); %>
