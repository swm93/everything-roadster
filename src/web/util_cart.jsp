<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>


<%
  // cart is a HashMap<String, ArrayList<String>>
  //   - the key is the list id
  //   - the value is an array where the first element is the part name and
  //     the second element is the quantity

  // create or get cart
  Object cartObj = session.getAttribute("shoppingCart");
  HashMap<String, ArrayList<String>> cart;

  if ((cartObj == null) || !(cartObj instanceof java.util.HashMap))
  {
    cart = new HashMap<String, ArrayList<String>>();
  }
  else
  {
    cart = (HashMap<String, ArrayList<String>>)cartObj;
  }
%>