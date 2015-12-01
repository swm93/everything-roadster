<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>

<%@ include file="util_user.jsp" %>

<%
  if (user != null) 
  {
    response.sendRedirect("index.jsp");
  }
  Connection con = connectionManager.open();
%>

<%!
  void signIn(HttpServletRequest request, Connection connection, HttpSession session) {

    String[] accountInfoKeys = { "email", "password" };

    List<String> accountDets = new ArrayList<String>();

    for (String accountInfoKey : accountInfoKeys) {
      accountDets.add((String) request.getParameter(accountInfoKey));
    }

    try {
      PreparedStatement preparedStatement = null;
      String query = "SELECT accountId FROM Account WHERE email = ? and password = ?;";
      preparedStatement = connection.prepareStatement(query);
      preparedStatement.setString(1, accountDets.get(0));
      preparedStatement.setString(2, accountDets.get(1));
      ResultSet rs = preparedStatement.executeQuery();

      if (rs.next()) {
        Integer AccountId = rs.getInt(1);
        //HashMap<String, ArrayList<String>> userHashMap = createUserHash(AccountId, connection);
        //request.getSession().setAttribute("user", userHashMap);
        createUserHash(AccountId, connection, session);
        System.out.println("signed In!");
        session.setAttribute("message", Arrays.asList("success", "You have been signed in!"));
      } else {
        System.out.println("wrong e-mail/password combination");
        session.setAttribute("message", Arrays.asList("danger", "Invalid email/password combination."));
      }
      ;
    } catch (SQLException e) {

      System.out.println(e);
      session.setAttribute("message", Arrays.asList("danger", "Failed to sign in."));
    }

  }
%>

<%!//HashMap<String, ArrayList<String>> 
  void createUserHash(int accountId, Connection connection, HttpSession session) {
    String[] accountInfoKeys = { "accountType", "email", "password", "firstName", "lastName", "phoneNumber",
        "streetAddress", "city", "provinceState", "country", "postalCode" };
    HashMap<String, String> userHash = new HashMap<String, String>();
    ArrayList<String> accountDets = new ArrayList<String>();
    try {
      PreparedStatement preparedStatement = null;
      String query = "SELECT accountType, email, firstName, lastName ,password,  phoneNumber, streetAddress, city, provinceState, country, postalCode from Account where accountId = ?;";

      preparedStatement = connection.prepareStatement(query);
      preparedStatement.setInt(1, accountId);

      ResultSet rs = preparedStatement.executeQuery();

      rs.next();
      for (int i = 0; i < accountInfoKeys.length; i++) {
        userHash.put(accountInfoKeys[i], rs.getString(accountInfoKeys[i]));
      }
      userHash.put("accountId", String.valueOf(accountId));
      session.setAttribute("user", userHash);

    } catch (SQLException e) {

      System.out.println(e);
    }

    //return userHash;
  }
%>

<%
  if ((request.getParameter("email") != null) && (request.getParameter("password") != null)) {
    signIn(request, con, session);
    /* try {
        Thread.sleep(3000);
        response.sendRedirect("index.jsp");
    } catch(InterruptedException ex) {
        Thread.currentThread().interrupt();
    } */
  } else {
    System.out.println("Check fail");
  }
%>


<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
      <title>EverythingRoadster - Sign In</title>
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
        <div class="col-md-4 col-md-offset-4">
          <h1>Account Sign In</h1>
        </div>
      </div>

      <form id="sign-in-form" action="./signIn.jsp" method="POST">
        <div class="row">
          <div class="col-md-4 col-md-offset-4">
            <div class="form-group">
              <label for="email-input">Email</label>
              <input id="email-input" class="form-control" type="text" name="email" size=50 />
            </div>
            <div class="form-group">
              <label for="password-input">Password</label>
              <input id="password-input" class="form-control" type="password" name="password" size=50 />
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-md-4 col-md-offset-4">
            <button class="btn btn-success" type="submit">Sign In</button>
          </div>
        </div>
      </form>
    </div>

    <%@ include file="util_copyright.jsp" %>

  </body>
</html>

<% connectionManager.close(); %>
