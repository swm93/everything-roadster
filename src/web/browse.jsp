<%@ include file="util_connection.jsp" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>


<% final int maxRecentParts = 3; %>

<% Connection con = connectionManager.open(); %>

<!DOCTYPE html>
<html>
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
    <%@ include file="util_message.jsp" %>

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

        <ul id="browse-main-container" class="container-fluid list-group">
<%
  String partsSQL = new String(
    "SELECT LP.listId, P.partName, LP.price, LP.quantity, P.imagePath, P.categoryName, P.description, LP.quantity - SUM(CP.quantity)/COUNT(DISTINCT V.vehicleId) AS remainingQuantity " +
      "FROM ListedPart LP " +
        "JOIN Part P ON P.partId=LP.partId " +
        "LEFT OUTER JOIN FitsIn F ON F.partId=P.partId " +
        "LEFT OUTER JOIN Vehicle V ON V.vehicleId=F.vehicleId " +
        "LEFT OUTER JOIN ContainsPart CP ON CP.listId=LP.listId "
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

  partsSQL += "GROUP BY LP.listId HAVING LP.quantity > SUM(CP.quantity)/COUNT(DISTINCT V.vehicleId) OR SUM(CP.quantity) IS NULL;";

  PreparedStatement partsPS = con.prepareStatement(partsSQL);
  for (int i = 0; i < whereParams.size(); i++)
  {
    partsPS.setString(i+1, whereParams.get(i));
  }

  ResultSet partsRS = partsPS.executeQuery();
  NumberFormat formatter = NumberFormat.getCurrencyInstance();

  while (partsRS.next())
  {
    int listId = partsRS.getInt("listId");
    String partName = partsRS.getString("partName");
    int quantity = partsRS.getInt("remainingQuantity");
    float price = partsRS.getFloat("price");
    String image = partsRS.getString("imagePath");
    String category = partsRS.getString("categoryName");
    String description = partsRS.getString("description");
    
    PreparedStatement ratingPS = con.prepareStatement("SELECT AVG(userRating) FROM ListedPart LP JOIN " +
    		"RatesVendor RV ON LP.vendorId = RV.vendorId WHERE listId=?");
    ratingPS.setInt(1, listId);
    ResultSet ratingRS = ratingPS.executeQuery();
    ratingRS.next();
    Double avgRating = ratingRS.getDouble("AVG(userRating)");

    String partsHTML = String.format(
           "<li class=\"list-group-item row\">" +
             "<div class=\"part-image-container col-xs-12 col-md-3\">" +
               "<img src=\"%s\" class=\"part-image\" />" +
               "<form class=\"add-to-cart-container input-group\" action=\"cart.jsp\" method=\"POST\">" +
                 "<span class=\"input-group-btn\">" +
                   "<button class=\"btn btn-success\" type=\"submit\" name=\"listId\" value=\"%d\">" +
                     "<span class=\"glyphicon glyphicon-plus\"></span> " +
                     "<span>Add to Cart</span>" +
                   "</button>" +
                 "</span>" +
                 "<input class=\"part-quantity-input form-control\" type=\"number\" name=\"quantity\" value=\"1\" min=\"1\" max=\"%s\" />" +
                 "<input type=\"hidden\" name=\"name\" value=\"%s\" />" +
                 "<input type=\"hidden\" name=\"action\" value=\"add\" />" +
               "</form>" +
             "</div>" +
             "<div class=\"col-xs-8 col-md-7\">" +
               "<h3 class=\"part-name-header\">%s</h3>" +
               "<h5 class=\"part-category-label\">%s</h5>" +
               "<p>%s</p>" +
             "</div>" +
             "<h5 class=\"col-xs-4 col-md-2\">" +
               "<span class=\"part-price-label pull-right\">" +
                 "<span>%s</span> " +
                 "<span class=\"glyphicon glyphicon-tags\"></span>" +
               "</span>" +
             "</h5>" +
             "<h5 class=\"col-xs-4 col-md-2\">" +
             	 "<span class=\"part-price-label pull-right\">" +
               	 "<span>Vendor Rating: %.2f</span> " +
             	 "</span>" +
           	 "</h5>" +
           "</li>",
    image, listId, quantity, partName, partName, category, description, formatter.format(price), avgRating);

    out.println(partsHTML);
  }
%>

        </ul>

      </div>
    </div>

    <%@ include file="util_copyright.jsp" %>

  </body>
</html>


<% connectionManager.close(); %>
