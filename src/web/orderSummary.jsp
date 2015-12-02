<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Arrays" %>


<% Connection con = connectionManager.open(); %>


<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>EverythingRoadster - Order Summary</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="vendor/stylesheets/bootstrap.min.css">
    <link rel="stylesheet" href="stylesheets/main.css">
    <link rel="stylesheet" href="stylesheets/orderSummary.css">

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
          <h1>Order Summary</h1>
        </div>
      </div>

      <table id="order-summary-table" class="table table-hover">
<%
  boolean addedWhere = false;
  String orderQuery = "SELECT O.orderId, O.orderDate, A.firstName, A.lastName, CP.quantity, LP.price, P.categoryName, P.partName, P.description, S.toAddress, S.toCity, S.toProvinceState, S.toCountry, S.toPostalCode " +
        "FROM PartOrder O " +
          "JOIN Account A ON A.accountId=O.customerId " +
          "JOIN ContainsPart CP ON CP.orderId=O.orderId " +
          "JOIN ListedPart LP ON LP.listId=CP.listId " +
          "JOIN Part P ON P.partId=LP.partId " +
          "JOIN Shipment S ON S.orderId=O.orderId ";
  ArrayList<String> orderQueryParams = new ArrayList<String>();

  if (request.getParameter("orderId") != null)
  {
    orderQuery += "WHERE O.orderId=? ";
    orderQueryParams.add(request.getParameter("orderId"));

    addedWhere = true;
  }
  if (request.getParameter("customerId") != null)
  {
    if (addedWhere)
    {
      orderQuery += "AND ";
    }
    else
    {
      orderQuery += "WHERE ";
    }
    orderQuery += "A.accountId=? ";
    orderQueryParams.add(request.getParameter("customerId"));

    addedWhere = true;
  }

  orderQuery += "ORDER BY O.orderId;";

  PreparedStatement orderPS = con.prepareStatement(orderQuery);

  for (int i=1; i<=orderQueryParams.size(); i++)
  {
    orderPS.setString(i, orderQueryParams.get(i-1));
  }

  boolean firstOrder = true;
  Integer previousOrderId = null;
  ResultSet orderRS = orderPS.executeQuery();

  while (orderRS.next()) {
    Integer orderId = orderRS.getInt("orderId");
    if (orderId != previousOrderId)
    {
      String orderHtml = "</tbody>";
      if (firstOrder) {
        orderHtml = "";
        firstOrder = false;
      }

      orderHtml += String.format(
         "<thead>" +
           "<tr>" +
             "<th class=\"order-header-cell\" colspan=\"5\">" +
               "<h2>Order #%d</h2>" +
             "</th>" +
           "</tr>" +
           "<tr>" +
             "<th class=\"address-cell\" colspan=\"3\">" +
               "<address><strong>%s %s</strong><br>%s<br>%s, %s %s<br>%s</address>" +
             "</th>" +
             "<th class=\"date-cell\" colspan=\"2\">%s</th>" +
           "</tr>" +
           "<tr>" +
             "<th>Part Name</th>" +
             "<th>Category</th>" +
             "<th>Price</th>" +
             "<th>Quantity</th>" +
             "<th>Description</th>" +
           "</tr>" +
         "</thead>" +
         "</tbody>",
        orderId,
        orderRS.getString("firstName"),
        orderRS.getString("lastName"),
        orderRS.getString("toAddress"),
        orderRS.getString("toCity"),
        orderRS.getString("toProvinceState"),
        orderRS.getString("toPostalCode"),
        orderRS.getString("toCountry"),
        orderRS.getDate("orderDate").toString()
      );
      out.println(orderHtml);
    }

    String partHtml = String.format(
           "<tr>" +
             "<td>%s</td>" +
             "<td>%s</td>" +
             "<td>$%s</td>" +
             "<td>%s</td>" +
             "<td>%s</td>" +
           "</tr>",
      orderRS.getString("partName"),
      orderRS.getString("categoryName"),
      orderRS.getString("price"),
      orderRS.getString("quantity"),
      orderRS.getString("description")
    );
    out.println(partHtml);

    previousOrderId = orderId;
  }

  out.println("</tbody>");
%>

      </table>
    </div>

    <%@ include file="util_copyright.jsp" %>

  </body>
</html>

<% connectionManager.close(); %>