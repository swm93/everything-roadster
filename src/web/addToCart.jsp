<%@ include file="util_cart.jsp" %>


<%
  String listId = request.getParameter("listId");
  String name = request.getParameter("name");
  String quantity = request.getParameter("quantity");

  ArrayList<String> item = cart.get(listId);

  if (item != null)
  {
    Integer existingQuantity = Integer.parseInt(item.get(1));
    Integer newQuantity = Integer.parseInt(quantity);

    item.set(1, Integer.toString(existingQuantity + newQuantity));
  }
  else
  {
    item = new ArrayList<String>();
    item.add(name);
    item.add(quantity);
  }

  cart.put(listId, item);
  session.setAttribute("shoppingCart", cart);
  response.sendRedirect(request.getHeader("referer"));
%>