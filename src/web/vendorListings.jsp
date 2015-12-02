<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.sql.Date"%>

<%@ include file="util_user.jsp" %>

<%
	if (user == null) 
	{
		response.sendRedirect("signIn.jsp");
	} else if (user.get("accountType").equals("admin") || user.get("accountType").equals("customer")) 
	{
		response.sendRedirect("index.jsp");
	}

	Connection con = connectionManager.open();
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