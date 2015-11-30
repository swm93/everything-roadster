<%
    boolean isAuthenticated = session.getAttribute("authenticatedUser") == null ? false : true;
    if (!isAuthenticated)
    {
        RequestDispatcher disp = request.getRequestDispatcher("/login.jsp");
        disp.forward(request, response);
    }
%>