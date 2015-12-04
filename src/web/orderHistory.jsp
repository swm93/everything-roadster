<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Iterator" %>


<% Connection con = connectionManager.open(); %>
<%@ include file="util_user.jsp" %>

<%
  if (user == null)
  {
    session.setAttribute("message", Arrays.asList("info", "You must be logged in in order to view that page."));
    response.sendRedirect("index.jsp");
    return;
  }
%>

<%!
void createVendorRates(HttpServletRequest request, Connection connection, HttpSession session, HashMap<String, String> user) {

    try {

      String vendorQuery = "SELECT DISTINCT(LP.vendorId) FROM PartOrder O JOIN Account A " +
				"ON A.accountId=O.customerId JOIN ContainsPart CP ON CP.orderId=O.orderId " +
				"JOIN ListedPart LP ON LP.listId=CP.listId WHERE A.accountId=" + user.get("accountId");
	
			PreparedStatement vendorPS = connection.prepareStatement(vendorQuery);
			ResultSet vendorRS = vendorPS.executeQuery();
			
			List<Integer> unratedVendors = new ArrayList<Integer>();
			
			while (vendorRS.next()) {
				PreparedStatement checkRatedPS = connection.prepareStatement("SELECT COUNT(*) FROM RatesVendor WHERE customerId=? AND vendorId=?");
				checkRatedPS.setInt(1, Integer.parseInt(user.get("accountId")));
				checkRatedPS.setInt(2, vendorRS.getInt("vendorId"));
				
				ResultSet checkRatedRS = checkRatedPS.executeQuery();
				
				checkRatedRS.next();
				if (checkRatedRS.getInt("COUNT(*)") == 0) {
					unratedVendors.add(vendorRS.getInt("vendorId"));
				}
			}
			
      for (int i=0; i<unratedVendors.size(); i++) {
        Integer vendorId = unratedVendors.get(i);
				String insertRatingStr = "INSERT INTO RatesVendor VALUES (?, ?, ?)";
				PreparedStatement insertRatingPS = connection.prepareStatement(insertRatingStr);
				insertRatingPS.setInt(1, Integer.parseInt(user.get("accountId")));
				insertRatingPS.setInt(2, vendorId);
				insertRatingPS.setDouble(3, Double.parseDouble(request.getParameter(("vendor-name-" + vendorId))));
				
				insertRatingPS.executeUpdate();
			}
			
      session.setAttribute("message", Arrays.asList("success", "You have successfully rated the vendors"));
    } catch (Exception e) {
      System.out.println(e);
      session.setAttribute("message", Arrays.asList("danger", "Failed to save the ratings"));
    }

  }
%>

<%
  // I mean, I guess it should
	boolean valid = true;
  Iterator orderIt = request.getParameterMap().keySet().iterator();
  while(orderIt.hasNext()) {
    String val = (String)orderIt.next();
		if (request.getParameter(val).equals("-")) {
			valid = false;
		}
	}
	if (valid && request.getMethod().equals("POST")) {  
	  System.out.println("inserting vendor ratings");
	  createVendorRates(request, con, session, user);
	}
%>


<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>EverythingRoadster - Order History</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="vendor/stylesheets/bootstrap.min.css">
    <link rel="stylesheet" href="stylesheets/main.css">
    <link rel="stylesheet" href="stylesheets/orderHistory.css">

    <script src="vendor/javascripts/modernizr-2.8.3-respond-1.4.2.min.js"></script>
    <script src="vendor/javascripts/jquery-2.1.4.min.js"></script>
    <script src="vendor/javascripts/bootstrap.min.js"></script>
  </head>

  <body>
    <%@ include file="util_navbar.jsp" %>
    <%@ include file="util_message.jsp" %>
    
<%

	if (!user.get("accountType").equals("admin")) {
		
		String vendorQuery = "SELECT DISTINCT(LP.vendorId) FROM PartOrder O JOIN Account A " +
					"ON A.accountId=O.customerId JOIN ContainsPart CP ON CP.orderId=O.orderId " +
					"JOIN ListedPart LP ON LP.listId=CP.listId WHERE A.accountId=" + user.get("accountId");
		
		PreparedStatement vendorPS = con.prepareStatement(vendorQuery);
		ResultSet vendorRS = vendorPS.executeQuery();
		
		List<Integer> unratedVendors = new ArrayList<Integer>();
		
		while (vendorRS.next()) {
			PreparedStatement checkRatedPS = con.prepareStatement("SELECT COUNT(*) FROM RatesVendor WHERE customerId=? AND vendorId=?");
			checkRatedPS.setInt(1, Integer.parseInt(user.get("accountId")));
			checkRatedPS.setInt(2, vendorRS.getInt("vendorId"));
			
			ResultSet checkRatedRS = checkRatedPS.executeQuery();
			checkRatedRS.next();
			if (checkRatedRS.getInt("COUNT(*)") == 0) {
				unratedVendors.add(vendorRS.getInt("vendorId"));
			}
		}

		if (unratedVendors.size() > 0) {
			String rateHtml = "<div class=\"container-fluid\">" +
					"<div class=\"row\">" +
						"<div class=\"col-xs-12\">" +
							"<h2>Rate Vendors Used</h2>" +
						"</div>" +
					"</div>" +
				"<form id=\"rate-form\" action=\"./orderHistory.jsp\" method=\"POST\">" +
					"<div class=\"row\">" + 
						"<div class=\"col-xs-12 col-sm-6\">";
				
			for (int i=0; i<unratedVendors.size(); i++) {
        Integer vendorId = unratedVendors.get(i);
				PreparedStatement vendorNamePS = con.prepareStatement("SELECT firstName, lastName FROM Account WHERE accountId=?");
		    vendorNamePS.setInt(1, vendorId);
		    ResultSet vendorNameRS = vendorNamePS.executeQuery();
		    vendorNameRS.next();
				
		    rateHtml += String.format(
		    		"<div class=\"form-group\">" +
		    			"<label for=\"vendor-name-%d\">%s %s</label>" +
		    			"<select name=\"vendor-name-%d\">" +
		    				"<option value=\"-\">-</option>" +
		    				"<option value=0>0</option>" +
		    				"<option value=1>1</option>" +
		    				"<option value=2>2</option>" +
		    				"<option value=3>3</option>" +
		    				"<option value=4>4</option>" +
		    				"<option value=5>5</option>" +
		    			"</select>" +
		    		"</div>",
		    		vendorId,
		    		vendorNameRS.getString("firstName"),
		    		vendorNameRS.getString("lastName"),
		    		vendorId
		    		);
			}
			
			rateHtml += "</div>" +
					"</div>" +
						"<div class=\"col-xs-12\">" +
							"<button class=\"btn btn-success\" type=\"submit\">Rate</button>" +
						"</div>" +
					"</div>" +
				"</form>" +
				"</div>";
			
			out.println(rateHtml);
		}
		
	}

%>
		<div class="container-fluid">
      <div class="row">
        <div class="col-xs-12">
          <h1>Order History</h1>
        </div>
      </div>

      <table id="order-summary-table" class="table table-hover">
      
<%
  boolean addedWhere = false;
  String orderQuery = "SELECT O.orderId, O.orderDate, A.firstName, A.lastName, CP.quantity, LP.price, P.categoryName, P.partName, P.description, S.toAddress, S.toCity, S.toProvinceState, S.toCountry, S.toPostalCode, LP.vendorId " +
        "FROM PartOrder O " +
          "JOIN Account A ON A.accountId=O.customerId " +
          "JOIN ContainsPart CP ON CP.orderId=O.orderId " +
          "JOIN ListedPart LP ON LP.listId=CP.listId " +
          "JOIN Part P ON P.partId=LP.partId " +
          "JOIN Shipment S ON S.orderId=O.orderId ";
  ArrayList<String> orderQueryParams = new ArrayList<String>();

  String orderIdFilter = request.getParameter("orderId");
  String customerIdFilter = request.getParameter("customerId");

  // set customerIdFilter to currrent user if they aren't an admin
  if (!user.get("accountType").equals("admin"))
  {
    customerIdFilter = user.get("accountId");
  }

  if (orderIdFilter != null)
  {
    orderQuery += "WHERE O.orderId=? ";
    orderQueryParams.add(orderIdFilter);

    addedWhere = true;
  }
  if (customerIdFilter != null)
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
    orderQueryParams.add(customerIdFilter);

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
             "<th class=\"order-header-cell\" colspan=\"6\">" +
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
             "<th>Vendor Name</th>" +
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
    
    PreparedStatement vendorNamePS = con.prepareStatement("SELECT firstName, lastName FROM Account WHERE accountId=?");
    vendorNamePS.setString(1, orderRS.getString("vendorId"));
    ResultSet vendorNameRS = vendorNamePS.executeQuery();
    vendorNameRS.next();

    String partHtml = String.format(
           "<tr>" +
             "<td>%s</td>" +
             "<td>%s</td>" +
             "<td>%s</td>" +
             "<td>$%s</td>" +
             "<td>%s</td>" +
             "<td>%s</td>" +
           "</tr>",
      orderRS.getString("partName"),
      (vendorNameRS.getString("firstName") + " " + vendorNameRS.getString("lastName")),
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