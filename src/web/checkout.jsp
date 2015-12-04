<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.io.IOException" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ include file="util_connection.jsp" %>
<%@ include file="util_user.jsp" %>


<% Connection con = connectionManager.open(); %>

<%
  Date currentDate = new Date();

  HashMap<String, Float> carrierCosts = new HashMap<String, Float>();
  carrierCosts.put("UPS", 5.f);
  carrierCosts.put("USPS", 4.f);
  carrierCosts.put("FedEx", 3.f);
  carrierCosts.put("Canada Post", 2.f);

  HashMap<String, Float> shippingCosts = new HashMap<String, Float>();
  shippingCosts.put("Normal", 2.f);
  shippingCosts.put("Express", 5.f);
  shippingCosts.put("Overnight", 10.f);

  HashMap<String, Date> shippingDates = new HashMap<String, Date>();
  shippingDates.put("Normal", new Date(currentDate.getTime() + 7 * 24 * 60 * 60 * 1000));
  shippingDates.put("Express", new Date(currentDate.getTime() + 3 * 24 * 60 * 60 * 1000));
  shippingDates.put("Overnight", new Date(currentDate.getTime() + 1 * 24 * 60 * 60 * 1000));
%>

<%!
  public void processOrder(
    HashMap<String, ArrayList<String>> cart,
    HashMap<String, String> user,
    HashMap<String, Float> carrierCosts,
    HashMap<String, Float> shippingCosts,
    HashMap<String, Date> shippingDates,
    Connection connection,
    HttpSession session,
    HttpServletRequest request,
    HttpServletResponse response
  )
  {
    try
    {
      // disable auto commit so we can rollback inserts if an error occurs
      connection.setAutoCommit(false);

      Date currentDate = new Date();

      // get next order id
      Integer orderId = 1;
      PreparedStatement lastOrderIdPS = connection.prepareStatement(
        "SELECT MAX(orderId) AS orderId " +
          "FROM PartOrder;"
      );
      ResultSet lastOrderIdRS = lastOrderIdPS.executeQuery();
      if (lastOrderIdRS.next())
      {
        orderId = lastOrderIdRS.getInt("orderId") + 1;
      }

      // get next shipment id
      Integer shipmentId = 1;
      PreparedStatement lastShipmentIdPS = connection.prepareStatement(
        "SELECT MAX(shipmentId) AS shipmentId " +
          "FROM Shipment;"
      );
      ResultSet lastShipmentIdRS = lastShipmentIdPS.executeQuery();
      if (lastShipmentIdRS.next())
      {
        shipmentId = lastShipmentIdRS.getInt("shipmentId") + 1;
      }

      // get next payment id
      Integer paymentId = 1;
      PreparedStatement lastPaymentIdPS = connection.prepareStatement(
        "SELECT MAX(paymentId) AS paymentId " +
          "FROM Payment;"
      );
      ResultSet lastPaymentIdRS = lastPaymentIdPS.executeQuery();
      if (lastPaymentIdRS.next())
      {
        paymentId = lastPaymentIdRS.getInt("paymentId") + 1;
      }

      // create order
      PreparedStatement createOrderPS = connection.prepareStatement(
        "INSERT INTO PartOrder(orderId, customerId, orderDate) " +
          "VALUES (?, ?, ?);"
      );
      createOrderPS.setInt(1, orderId);
      createOrderPS.setInt(2, Integer.parseInt(user.get("accountId")));
      createOrderPS.setDate(3, new java.sql.Date(currentDate.getTime()));
      createOrderPS.executeUpdate();

      // create shipment
      String shipOption = (String)request.getParameter("shipOption");
      String shipCarrier = (String)request.getParameter("carrier");
      float carrierCost = carrierCosts.get(shipCarrier);
      float shipCost = shippingCosts.get(shipOption);
      Date shipDate = shippingDates.get(shipOption);
      PreparedStatement createShipmentPS = connection.prepareStatement(
        "INSERT INTO Shipment(shipmentId, orderId, trackingNumber, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode) " +
          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
      );
      createShipmentPS.setInt(1, shipmentId);
      createShipmentPS.setInt(2, orderId);
      createShipmentPS.setInt(3, (int)(Math.random() * 1000000000));
      createShipmentPS.setString(4, shipCarrier);
      createShipmentPS.setString(5, (String)request.getParameter("instruction"));
      createShipmentPS.setFloat(6, carrierCost + shipCost);
      createShipmentPS.setDate(7, new java.sql.Date(shipDate.getTime()));
      createShipmentPS.setString(8, shipOption);
      createShipmentPS.setString(9, (String)request.getParameter("toAddress"));
      createShipmentPS.setString(10, (String)request.getParameter("toCity"));
      createShipmentPS.setString(11, (String)request.getParameter("toProvinceState"));
      createShipmentPS.setString(12, (String)request.getParameter("toCountry"));
      createShipmentPS.setString(13, (String)request.getParameter("toPostalCode"));
      createShipmentPS.executeUpdate();

      // create payment
      PreparedStatement createPaymentPS = connection.prepareStatement(
        "INSERT INTO Payment(paymentId, shipmentId, accountNumber, paymentType) " +
          "VALUES (?, ?, ?, ?);"
      );
      createPaymentPS.setInt(1, paymentId);
      createPaymentPS.setInt(2, shipmentId);
      createPaymentPS.setInt(3, Integer.parseInt(request.getParameter("accountNumber")));
      createPaymentPS.setString(4, request.getParameter("paymentType"));
      createPaymentPS.executeUpdate();

      // create contains part insert prepared statement
      PreparedStatement createContainsPS = connection.prepareStatement(
        "INSERT INTO ContainsPart(orderId, listId, quantity) " +
          "VALUES (?, ?, ?);"
      );

      // create available quantity lookup prepared statement
      PreparedStatement listedPartPS = connection.prepareStatement(
        "SELECT LP.quantity, LP.quantity - SUM(CP.quantity) AS remainingQuantity " +
          "FROM ListedPart LP " +
            "JOIN ContainsPart CP ON CP.listId=LP.listId " +
          "WHERE LP.listId=? " +
          "GROUP BY LP.listId;"
      );

      Iterator cartIt = cart.entrySet().iterator();
      while (cartIt.hasNext())
      {
        Map.Entry<String, ArrayList<String>> entry = (Map.Entry<String, ArrayList<String>>)cartIt.next();
        Integer listId = Integer.parseInt(entry.getKey());
        String partName = entry.getValue().get(0);
        Integer requestedQuantity = Integer.parseInt(entry.getValue().get(1));

        listedPartPS.setInt(1, listId);
        ResultSet listedPartRS = listedPartPS.executeQuery();
        listedPartRS.next();

        Integer maxQuantity = listedPartRS.getInt("remainingQuantity");
        Integer quantity = Math.min(requestedQuantity, maxQuantity);

        // less parts available than requested; inform user of this
        if (quantity != requestedQuantity)
        {
          session.setAttribute("message", Arrays.asList("info", "Some of the parts you have requested are unavailable. They were removed from your order and you were not charged for them."));
        }

        createContainsPS.setInt(1, orderId);
        createContainsPS.setInt(2, listId);
        createContainsPS.setInt(3, quantity);
        createContainsPS.executeUpdate();
      }

      connection.commit();

      session.removeAttribute("shoppingCart");
      response.sendRedirect("orderHistory.jsp?orderId=" + orderId);
    }
    catch (Exception e)
    {
      System.out.println(e);

      try
      {
    	  if (!connection.isClosed()) {
        	connection.rollback();
    	  }
      }
      catch (SQLException re) {
        System.out.println(re);
      }

      session.setAttribute("message", Arrays.asList("danger", "Failed to process your order."));
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


<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>EverythingRoadster - Checkout</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="vendor/stylesheets/bootstrap.min.css">
    <link rel="stylesheet" href="stylesheets/main.css">
    <link rel="stylesheet" href="stylesheets/checkout.css">

    <script src="vendor/javascripts/modernizr-2.8.3-respond-1.4.2.min.js"></script>
    <script src="vendor/javascripts/jquery-2.1.4.min.js"></script>
    <script src="vendor/javascripts/bootstrap.min.js"></script>
    <script src="javascripts/checkout.js"></script>
  </head>

  <body>
    <%@ include file="util_navbar.jsp" %>
    <%@ include file="util_message.jsp" %>

    <form action="./checkout.jsp" method="POST" class="container-fluid">
      <div class="row">
        <div class="col-xs-12">
          <h1>Checkout</h1>
        </div>
      </div>

      <div class="row">
        <div class="col-xs-12 col-sm-6 col-lg-8">
          <h3>Shipping Options</h3>
          <div class="form-group">
            <label for="shipping-carrier-input">Carrier</label>
            <select id="shipping-carrier-input" class="form-control" name="carrier">
              <option value="UPS">UPS</option>
              <option value="USPS">USPS</option>
              <option value="FedEx">FedEx</option>
              <option value="Canada Post">Canada Post</option>
            </select>
          </div>
          <div class="form-group">
            <label for="shipping-option-input">Option</label>
            <select id="shipping-option-input" class="form-control" name="shipOption">
              <option value="Normal">Normal</option>
              <option value="Express">Express</option>
              <option value="Overnight">Overnight</option>
            </select>
          </div>
          <div class="form-group">
            <label for="shipping-instruction-input">Instructions</label>
            <textarea id="shipping-instruction-input" class="form-control" name="instruction"></textarea>
          </div>

          <h3>Shipping Address</h3>
          <div class="form-group">
            <label for="shipping-address-input">Address</label>
            <input id="shipping-address-input" class="form-control" name="toAddress" value="<%= user != null ? user.get("streetAddress") : "" %>" />
          </div>
          <div class="form-group">
            <label for="shipping-city-input">City</label>
            <input id="shipping-city-input" class="form-control" name="toCity" value="<%= user != null ? user.get("city") : "" %>" />
          </div>
          <div class="form-group">
            <label for="shipping-province-state-input">Province or State</label>
            <input id="shipping-province-state-input" class="form-control" name="toProvinceState" value="<%= user != null ? user.get("provinceState") : "" %>" />
          </div>
          <div class="form-group">
            <label for="shipping-postal-code-input">Postal Code</label>
            <input id="shipping-postal-code-input" class="form-control" name="toPostalCode" value="<%= user != null ? user.get("postalCode") : "" %>" />
          </div>
          <div class="form-group">
            <label for="shipping-country-input">Country</label>
            <input id="shipping-country-input" class="form-control" name="toCountry" value="<%= user != null ? user.get("country") : "" %>" />
          </div>

          <h3>Payment Options</h3>
          <div class="form-group">
            <label for="payment-card-number-input">Card Number</label>
            <input id="payment-cart-number-input" class="form-control" name="accountNumber" />
          </div>
          <div class="form-group">
            <label for="payment-type-input">Payment Type</label>
            <select id="payment-type-input" class="form-control" name="paymentType">
              <option value="Paypal">Paypal</option>
              <option value="Visa">Visa</option>
              <option value="MasterCard">MasterCard</option>
            </select>
          </div>
        </div>

        <div class="order-summary-container col-xs-12 col-sm-6 col-lg-4">
          <h3 class="pull-left">Order Summary</h3>
          <button id="checkout-btn" class="btn btn-success" type="submit">Checkout</button>

          <table class="table">
            <thead>
              <tr>
                <th>Item</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Subtotal</th>
              </tr>
            </thead>

            <tbody>

<%
  PreparedStatement listedPartPS = con.prepareStatement(
    "SELECT price, quantity " +
      "FROM ListedPart " +
      "WHERE listId=?;"
  );

  NumberFormat formatter = NumberFormat.getCurrencyInstance();
  Float total = 0.f;

  Iterator cartIt = cart.entrySet().iterator();
  while (cartIt.hasNext())
  {
    Map.Entry<String, ArrayList<String>> entry = (Map.Entry<String, ArrayList<String>>)cartIt.next();
    String listId = entry.getKey();
    ArrayList<String> item = entry.getValue();
    ResultSet listedPartRS;

    listedPartPS.setInt(1, Integer.parseInt(listId));
    listedPartRS = listedPartPS.executeQuery();
    listedPartRS.next();

    Integer quantity = Integer.parseInt(item.get(1));
    Float price = listedPartRS.getFloat("price");
    Float subtotal = price * quantity;
    String listedPartHtml = String.format(
             "<tr>" +
               "<td>%s</td>" +
               "<td>%s</td>" +
               "<td>%s</td>" +
               "<td>%s</td>" +
             "</tr>",
    item.get(0), formatter.format(price), item.get(1), formatter.format(subtotal));

    out.println(listedPartHtml);

    total += subtotal;
  }
%>
            </tbody>

            <tfoot>
              <tr>
                <td class="order-footer-cell-label" colspan="3">Order Cost:</td>
                <td id="order-cost-cell" data-value="<%= total %>"><%= formatter.format(total) %></td>
              </tr>
              <tr>
                <td class="order-footer-cell-label" colspan="3">Shipping Cost:</td>
                <td id="order-shipping-cell"></td>
              </tr>
              <tr>
                <td class="order-footer-cell-label" colspan="3">Total:</td>
                <td id="order-total-cell"></td>
              </tr>
            </tfoot>
          </table>
        </div>
      </div>
    </form>

    <%@ include file="util_copyright.jsp" %>

  </body>
</html>


<%
	if (user == null || (user != null && user.get("accountType").equals("admin"))) {
		session.setAttribute("message", Arrays.asList("warning", "Cannot checkout unless signed in as a customer or vendor!"));
	  response.sendRedirect("browse.jsp");
	} else if (cart.size() == 0)
  {
    session.setAttribute("message", Arrays.asList("warning", "Cannot checkout without adding items to your cart!"));
    response.sendRedirect("browse.jsp");
  }

	boolean valid = true;
  Iterator checkoutParamsIt = request.getParameterMap().keySet().iterator();
  while (checkoutParamsIt.hasNext()) {
    String val = (String)checkoutParamsIt.next();
		if ((request.getParameter(val) == null || request.getParameter(val).equals("")) && !val.equals("instruction") && request.getMethod().equals("POST")) {
			valid = false;
		}
		if (val.equals("accountNumber") && valid) {
			try {
				Integer accIsInt = Integer.parseInt(request.getParameter(val));
			}
			catch(NumberFormatException nfe) {  
				valid = false;  
			}  
		}
	}
	if (user != null && valid && request.getMethod().equals("POST")) {  
	  System.out.println("creating order");
	  processOrder(cart, user, carrierCosts, shippingCosts, shippingDates, con, session, request, response);
	}

%>

<% connectionManager.close(); %>
