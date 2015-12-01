<%@ include file="util_user.jsp" %>

<%
  if (user != null) 
  {
	  session.removeAttribute("user");
	  session.removeAttribute("shoppingCart");
	  response.sendRedirect("index.jsp");
  }
%>