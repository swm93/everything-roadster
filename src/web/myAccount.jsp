<!-- due to the FK restraints it's prone to errors -->

<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Arrays"%>

<%@ include file="util_user.jsp" %>

<%
	if (user == null) 
	{
		response.sendRedirect("signIn.jsp");
	} else if (user.get("accountType") == "Admin") 
	{
		response.sendRedirect("index.jsp");
	}
%>

<%
	Connection con = connectionManager.open(); 
%>

<%!
void updateAccountDetails(HttpServletRequest request, Connection connection, HttpSession session, HashMap<String, String> user) {
    String[] accountInfoKeys = {"password", "firstName", "lastName", "phoneNumber",
        "streetAddress", "city", "provinceState", "country", "postalCode" };

    List<String> accountDets = new ArrayList<String>();

    for (String accountInfoKey : accountInfoKeys) {
      accountDets.add((String) request.getParameter(accountInfoKey));
    }

    try {

      PreparedStatement preparedStatement = null;

      String insertTableSQL = "UPDATE Account SET password=?, firstName=?, lastName=?, "
    		  + "phoneNumber=?, streetAddress=?, city=?, provinceState=?, country=?, postalCode=? "
          + "WHERE accountId=" + user.get("accountId") + ";";

      preparedStatement = connection.prepareStatement(insertTableSQL);

      int i = 0;
      for (String column : accountDets) {
        preparedStatement.setString(i, accountDets.get(i));
        i++;
      }

      // execute insert SQL stetement
      preparedStatement.executeUpdate();
      i = 0;
      for (String column : accountDets) {
          user.put(accountInfoKeys[i], accountDets.get(i));
          i++;
      }
      session.setAttribute("message", Arrays.asList("success", "Your settings have been updated successfully"));
    } catch (Exception e) {
      System.out.println(e);
      session.setAttribute("message", Arrays.asList("danger", "Failed to update your settings"));
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
    <%@ include file="util_message.jsp" %>

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
              <input id="account-type-input" class="form-control" name="accountType" value="<% if (user != null) { out.println(user.get("accountType")); } %>" readonly />
            </div>
            <div class="form-group">
              <label for="email-input">Email</label>
              <input id="email-input" class="form-control" type="text" name="email" value="<% if (user != null) { out.println(user.get("email")); } %>" readonly/>
            </div>
            <div class="form-group">
              <label for="password-input">Password</label>
              <input id="password-input" class="form-control" type="password" name="password" value="<% if (user != null) { out.println(user.get("password")); } %>"/>
            </div>
            <div class="form-group">
              <label for="first-name-input">First Name</label>
              <input id="first-name-input" class="form-control" type="text" name="firstName" value="<% if (user != null) { out.println(user.get("firstName")); } %>"/>
            </div>
            <div class="form-group">
              <label for="last-name-input">Last Name</label>
              <input id="last-name-input" class="form-control" type="text" name="lastName" value="<% if (user != null) { out.println(user.get("lastName")); } %>"/>
            </div>
            <div class="form-group">
              <label for="phone-number-input">Phone Number</label>
              <input id="phone-number-input" class="form-control" type="text" name="phoneNumber" value="<% if (user != null) { out.println(user.get("phoneNumber")); } %>"/>
            </div>
          </div>
          <div class="col-xs-12 col-sm-6">
            <div class="form-group">
              <label for="street-address-input">Street Address</label>
              <input id="street-address-input" class="form-control" type="text" name="streetAddress" value="<% if (user != null) { out.println(user.get("streetAddress")); } %>"/>
            </div>
            <div class="form-group">
              <label for="city-input">City</label>
              <input id="city-input" class="form-control" type="text" name="city" value="<% if (user != null) { out.println(user.get("city")); } %>"/>
            </div>
            <div class="form-group">
              <label for="province-state-input">Province or State</label>
              <input id="province-state-input" class="form-control" type="text" name="provinceState" value="<% if (user != null) { out.println(user.get("provinceState")); } %>"/>
            </div>
            <div class="form-group">
              <label for="country-input">Country</label>
              <input id="country-input" class="form-control" type="text" name="country" value="<% if (user != null) { out.println(user.get("country")); } %>"/>
            </div>
            <div class="form-group">
              <label for="postal-code-input">Postal Code</label>
              <input id="postal-code-input" class="form-control" type="text" name="postalCode" value="<% if (user != null) { out.println(user.get("postalCode")); } %>"/>
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
	boolean valid = true;
	for (String val : request.getParameterMap().keySet()) {
		if (request.getParameter(val) == null || request.getParameter(val).equals("")) {
			valid = false;
		}
	}
	if (valid && request.getMethod().equals("POST")) {  
	  System.out.println("updating account details");
	  updateAccountDetails(request, con, session, user);
	}
%>

    <%@ include file="util_copyright.jsp" %>

  </body>
</html>

<% connectionManager.close(); %>