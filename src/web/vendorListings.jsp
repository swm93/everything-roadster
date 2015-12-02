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
  if (user == null)
  {
    session.setAttribute("message", Arrays.asList("info", "You must be logged in in order to view that page."));
    response.sendRedirect("signIn.jsp");
  }
  else if (user.get("accountType").equals("admin") || user.get("accountType").equals("customer"))
  {
    session.setAttribute("message", Arrays.asList("info", "You must be a vendor in order to view that page."));
    response.sendRedirect("index.jsp");
  }
%>


<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>EverythingRoadster - Your Listings</title>
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
          <h1>Active Listings</h1>
        </div>
      </div>

      <div class="row">
        <div class="col-xs-12">
          <h1>Sales History</h1>
        </div>
      </div>

      <table class="table table-hover table-striped">
        <thead>
          <tr>
            <th>Id</th>
            <th>Part Name</th>
            <th>Price</th>
            <th>Quantity Listed</th>
            <th>Quantity Sold</th>
            <th>Date Listed</th>
            <th>Date Sold</th>
          </tr>
        </thead>

        <tbody>
<%
  NumberFormat formatter = NumberFormat.getCurrencyInstance();
  PreparedStatement soldPartsPS = con.prepareStatement(
    "SELECT LP.listId, LP.quantity AS quantityListed, LP.price, LP.dateListed, P.partName, CP.quantity AS quantitySold, O.orderDate " +
      "FROM ListedPart LP " +
        "JOIN Part P ON P.partId=LP.partId " +
        "JOIN ContainsPart CP ON CP.listId=LP.listId " +
        "JOIN PartOrder O ON O.orderId=CP.orderId " +
      "WHERE LP.vendorId=? " +
      "ORDER BY ListId;"
  );
  soldPartsPS.setString(1, user.get("accountId"));

  Integer i = 0;
  ResultSet soldPartsRS = soldPartsPS.executeQuery();

  while (soldPartsRS.next())
  {
    Integer listId = soldPartsRS.getInt("listId");
    String partName = soldPartsRS.getString("partName");
    String price = formatter.format(soldPartsRS.getFloat("price"));
    Integer quantityListed = soldPartsRS.getInt("quantityListed");
    Integer quantitySold = soldPartsRS.getInt("quantitySold");
    String dateListed = soldPartsRS.getDate("dateListed").toString();
    String dateSold = soldPartsRS.getDate("orderDate").toString();

    String soldPartsHtml = String.format(
         "<tr>" +
           "<td>%d</td>" +
           "<td>%s</td>" +
           "<td>%s</td>" +
           "<td>%d</td>" +
           "<td>%d</td>" +
           "<td>%s</td>" +
           "<td>%s</td>" +
         "</tr>",
    listId, partName, price, quantityListed, quantitySold, dateListed, dateSold);
    out.println(soldPartsHtml);

    i++;
  }

  if (i == 0)
  {
    out.println(
         "<tr>" +
           "<td colspan=\"7\">You have not sold any parts yet.</td>" +
         "</tr>"
    );
  }
%>
        </tbody>
      </table>
    </div>

    <%@ include file="util_copyright.jsp" %>

  </body>
</html>


<% connectionManager.close(); %>
