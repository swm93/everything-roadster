<%@ include file="util_connection.jsp"%>
<%@ include file="util_user.jsp"%>

<%
	if (user != null) {
		request.getSession().setAttribute("user", null);
		System.out.println("loggedOut");
		response.sendRedirect("index.jsp");
	}
%>