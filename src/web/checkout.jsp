<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ include file="util_connection.jsp" %>
<%@ include file="util_user.jsp" %>


<% Connection con = connectionManager.open(); %>


<!doctype html>
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

    <form class="container-fluid">
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
    "SELECT price " +
      "FROM ListedPart " +
      "WHERE listId=?;"
  );
  NumberFormat formatter = NumberFormat.getCurrencyInstance();
  Float total = 0.f;

  for (Map.Entry<String, ArrayList<String>> entry : cart.entrySet())
  {
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


<% connectionManager.close(); %>
