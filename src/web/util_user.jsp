<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>


<%
  // user is a HashMap<String, String>

  // get user
  Object userObj = session.getAttribute("user");
  HashMap<String, String> user;

  if ((userObj != null) && (userObj instanceof java.util.HashMap))
  {
	  user = (HashMap<String, String>)userObj;
  }
%>