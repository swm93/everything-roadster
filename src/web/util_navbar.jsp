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
    <ul class="nav navbar-nav navbar-left">
      <li>
        <a href="browse.jsp">Browse</a>
      </li>
    </ul>
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
              <a href="checkout.jsp" class="cart-dropdown-checkout btn btn-link <%= cart.size() == 0 ? "hidden" : "" %>">Checkout</a>
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
      
<%
	Object userObjNav = session.getAttribute("user");
	HashMap<String, String> userNav = null;
	
	if ((userObjNav != null) && (userObjNav instanceof java.util.HashMap))
	{
		  userNav = (HashMap<String, String>)userObjNav;
	}
	
	if (userNav == null) {
		out.println(
		           "<li class=\"navbar-form\">" +
						"<a href=\"signIn.jsp\" class=\"btn btn-danger\">Sign In</a>" +
					"</li>" +
					"<li class=\"navbar-form\">" +
						"<a href=\"signUp.jsp\" class=\"btn btn-danger\">Sign Up</a>" +
					"</li>"
		    );
	}
	if (userNav != null) {
		out.println(
			"<li class=\"dropdown\"" +
				"<a href=\"#\" class=\"dropdown-toggle\" data-toggle=\"dropdown\" role=\"button\" aria-haspopup=\"true\" aria-expanded=\"false\">" +
					"<span>" + userNav.get("firstName") + " " + userNav.get("lastName") + "</span>" +
					"<span class=\"caret\"></span>" +
				"</a>" +
				"<ul class=\"dropdown-menu\">"
		);
		
		if (userNav.get("accountType").equals("admin") || userNav.get("accountType").equals("vendor")) {
			out.println(
				"<li>" +
					"<a href=\"createPart.jsp\">Create Part</a>" +
				"</li>"
			);
		}
		
		if (userNav.get("accountType").equals("admin")) {
			out.println(
				"<li>" +
					"<a href=\"createVehicle.jsp\">Create Vehicle</a>" +
				"</li>"
			);
		}
		
		if (userNav.get("accountType").equals("admin")) {
			out.println(
				"<li>" +
					"<a href=\"removeVehicle.jsp\">Remove Vehicle</a>" +
				"</li>"
			);
		}
		
		if (userNav.get("accountType").equals("customer") || userNav.get("accountType").equals("vendor")) {
			out.println(
				"<li>" +
					"<a href=\"myAccount.jsp\">Account Settings</a>" +
				"</li>"
			);
		}
		
		out.println(
			"<li role=\"separator\" class=\"divider\"></li>" +
			"<li>" +
				"<a href=\"logout.jsp\">Logout</a>" +
			"</li>" +
			"</ul>" +
			"</li>"
		);
	}
%>

    </ul>
  </div>
</div>
</nav>