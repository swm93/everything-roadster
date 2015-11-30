<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>

<%@ include file="util_cart.jsp" %>


<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
      <span class="sr-only">Toggle navigation</span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
    </button>
    <a class="navbar-brand" href="/">
      <img class="navbar-brand-image" src="assets/images/logo02.jpg" />
      <span>EverythingRoadster</span>
    </a>
  </div>
  <div id="navbar" class="navbar-collapse collapse">
    <ul class="nav navbar-nav navbar-right">
      <li class="dropdown">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
          <span class="glyphicon glyphicon-shopping-cart"></span>
          <span>Cart</span>
          <span class="badge"><%= cart.size() %></span>
        </a>
        <ul class="dropdown-menu">
          <li class="cart-dropdown-header clearfix">
            <span>
              <span class="cart-dropdown-header-label">Cart</span>
              <a href="checkout.jsp" class="cart-dropdown-checkout btn btn-link">Checkout</a>
              <form action="cart.jsp" method="POST">
                <button class="cart-dropdown-empty btn btn-link" type="submit" name="action" value="empty">Empty</button>
              </form>
            </span>
          </li>

<%
  if (cart.size() == 0)
  {
    out.println(
           "<li>" +
             "<a href=\"browse.jsp\">" +
               "<p>There are no items in your cart.</p>" +
               "<p><b>Shop Now!</b></p>" +
             "</a>" +
           "</li>"
    );
  }
  else
  {
    for (Map.Entry<String, ArrayList<String>> entry : cart.entrySet())
    {
      String listId = entry.getKey();
      ArrayList<String> item = entry.getValue();

      String html = String.format(
           "<li class=\"cart-dropdown-item\">" +
             "<a href=\"#\" class=\"cart-dropdown-label\">" +
               "<span class=\"badge\">%s</span> " +
               "<span>%s</span>" +
               "<form action=\"cart.jsp\" method=\"POST\">" +
                 "<input type=\"hidden\" name=\"action\" value=\"remove\" />" +
                 "<button class=\"cart-dropdown-remove glyphicon glyphicon-remove\" type=\"submit\" name=\"listId\" value=\"%s\"></button>" +
               "</form>" +
             "</a>" +
           "</li>",
      item.get(1), item.get(0), listId);

      out.println(html);
    }
  }
%>

        </ul>
      </li>
      <li class="navbar-form">
        <a href="signIn.jsp" class="btn btn-danger">Sign In</a>
      </li>

      <li class="navbar-form">
        <a href="signUp.jsp" class="btn btn-danger">Sign Up</a>
      </li>
      
      <li class="navbar-form">
        <a href="addPart.jsp" class="btn btn-danger">addPart</a>
      </li>
      
       
      <li class="navbar-form">
        <a href="removeVehicle.jsp" class="btn btn-danger">removeVehicle</a>
      </li>
      
      <li class="navbar-form">
        <a href="myAccount.jsp" class="btn btn-danger">Account</a>
      </li>
      
    </ul>
  </div>
</div>
</nav>