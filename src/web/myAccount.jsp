<!-- due to the FK restraints it's prone to errors -->

<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>

<%@ include file="util_user.jsp" %>

<%
	if (user == null || user.get("accountType") != "Customer" || user.get("accountType") != "Vendor") 
	{
		String redirectURL = "http://whatever.com/myJSPFile.jsp";
        response.sendRedirect(redirectURL);
	}
%>
<%
	Connection con = connectionManager.open(); 
%>

<%!
void updateAccountDetails(HttpServletRequest request, Connection connection) {
    String[] accountInfoKeys = {"accountType", "email", "password", "firstName", "lastName", "phoneNumber",
        "streetAddress", "city", "provinceState", "country", "postalCode" };

    List<String> accountDets = new ArrayList<String>();

    for (String accountInfoKey : accountInfoKeys) {
      accountDets.add((String) request.getParameter(accountInfoKey));
    }

    try {

      PreparedStatement preparedStatement = null;

      String insertTableSQL = "INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode) "
          + "VALUES" + "(?,?,?,?,?,?,?,?,?,?,?,?)";

      preparedStatement = connection.prepareStatement(insertTableSQL);

      int i = 2;
      for (String column : accountDets) {
        preparedStatement.setString(i, accountDets.get(i - 2));
        i++;
      }

      // execute insert SQL stetement
      preparedStatement.executeUpdate();
    } catch (Exception e) {
      System.out.println(e);
    }

  }
%>

<!DOCTYPE html>
<html>

  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>EverythingRoadster - My Account</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="vendor/stylesheets/bootstrap.min.css">
    <link rel="stylesheet" href="stylesheets/main.css">
    <link rel="stylesheet" href="stylesheets/signUp.css">

    <script src="vendor/javascripts/modernizr-2.8.3-respond-1.4.2.min.js"></script>
    <script src="vendor/javascripts/jquery-2.1.4.min.js"></script>
    <script src="vendor/javascripts/bootstrap.min.js"></script>
  </head>

  <body>
    <%@ include file="util_navbar.jsp" %>

    <div class="container-fluid">
      <div class="row">
        <div class="col-xs-12">
          <h1>My Account Details</h1>
        </div>
      </div>

      <form id="details-form" action="./myAccount.jsp" method="POST">
        <div class="row">
          <div class="col-xs-12 col-sm-6">
            <div class="form-group">
              <label for="account-type-input">Account Type</label>
              <input id="account-type-input" class="form-control" name="accountType" value=<%= user.get("accountType") %> readonly />
            </div>
            <div class="form-group">
              <label for="email-input">Email</label>
              <input id="email-input" class="form-control" type="text" name="email" readonly/>
            </div>
            <div class="form-group">
              <label for="password-input">Password</label>
              <input id="password-input" class="form-control" type="password" name="password" />
            </div>
            <div class="form-group">
              <label for="first-name-input">First Name</label>
              <input id="first-name-input" class="form-control" type="text" name="firstName" />
            </div>
            <div class="form-group">
              <label for="last-name-input">Last Name</label>
              <input id="last-name-input" class="form-control" type="text" name="lastName" />
            </div>
            <div class="form-group">
              <label for="phone-number-input">Phone Number</label>
              <input id="phone-number-input" class="form-control" type="text" name="phoneNumber" />
            </div>
          </div>
          <div class="col-xs-12 col-sm-6">
            <div class="form-group">
              <label for="street-address-input">Street Address</label>
              <input id="street-address-input" class="form-control" type="text" name="streetAddress" />
            </div>
            <div class="form-group">
              <label for="city-input">City</label>
              <input id="city-input" class="form-control" type="text" name="city" />
            </div>
            <div class="form-group">
              <label for="province-state-input">Province or State</label>
              <input id="province-state-input" class="form-control" type="text" name="provinceState" />
            </div>
            <div class="form-group">
              <label for="country-input">Country</label>
              <input id="country-input" class="form-control" type="text" name="country" />
            </div>
            <div class="form-group">
              <label for="postal-code-input">Postal Code</label>
              <input id="postal-code-input" class="form-control" type="text" name="postalCode" />
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-xs-12">
            <button class="btn btn-success" type="submit">Update</button>
          </div>
        </div>
      </form>
    </div>

<%
  // I mean, I guess it should
  if (request.getParameter("password") != null || request.getParameter("firstName") != null ||
  request.getParameter("lastName") != null || request.getParameter("streetAddress") != null || 
  request.getParameter("city") != null || request.getParameter("provinceState") != null || 
  request.getParameter("country") != null || request.getParameter("postalCode") != null) {  
    System.out.println("updating account details");
    updateAccountDetails(request, con);
  }
%>

    <%@ include file="util_copyright.jsp" %>

  </body>
</html>

<% connectionManager.close(); %>