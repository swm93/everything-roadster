<%@ include file="util_cart.jsp" %>


<%!
  HashMap<String, ArrayList<String>> addToCart(HashMap<String, ArrayList<String>> cart, String listId, String name, String quantity)
  {
    if (listId == null || name == null || quantity == null)
    {
      return null;
    }

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

    return cart;
  }
%>

<%!
  HashMap<String, ArrayList<String>> removeFromCart(HashMap<String, ArrayList<String>> cart, String listId)
  {
    if (listId == null || !cart.containsKey(listId))
    {
      return null;
    }

    cart.remove(listId);
    return cart;
  }
%>

<%!
  HashMap<String, ArrayList<String>> emptyCart(HttpSession session)
  {
    session.removeAttribute("shoppingCart");

    return new HashMap<String, ArrayList<String>>();
  }
%>

<%
  String method = request.getMethod();
  String action = request.getParameter("action");
  String listId = request.getParameter("listId");
  String name = request.getParameter("name");
  String quantity = request.getParameter("quantity");

  if (method.equals("POST"))
  {
    if (action.equals("add"))
    {
      cart = addToCart(cart, listId, name, quantity);
    }
    else if (action.equals("remove"))
    {
      cart = removeFromCart(cart, listId);
    }
    else if (action.equals("empty"))
    {
      cart = emptyCart(session);
    }
  }

  if (cart != null)
  {
    session.setAttribute("shoppingCart", cart);
  }

  response.sendRedirect(request.getHeader("referer"));
%>