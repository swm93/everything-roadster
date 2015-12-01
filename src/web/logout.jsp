<%@ include file="util_user.jsp"%>

<%
	if (user != null) {
		session.removeAttribute("user");
		session.removeAttribute("shoppingCart");
		System.out.println("loggedOut");
		response.sendRedirect("index.jsp");
	}
%>