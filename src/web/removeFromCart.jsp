<%@ include file="util_cart.jsp" %>


<%
    cart.remove(request.getParameter("listId"));

    session.setAttribute("shoppingCart", cart);
    response.sendRedirect(request.getHeader("referer"));
%>