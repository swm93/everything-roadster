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
    for (ArrayList<String> item : cart.values())
    {
      String html = String.format(
           "<li>" +
             "<a href=\"#\">" +
               "<span class=\"badge\">%s</span> " +
               "<span>%s</span>" +
             "</a>" +
           "</li>",
      item.get(1), item.get(0));

      out.println(html);
    }
  }
%>

        </ul>
      </li>
      <li class="navbar-form">
        <form action="signIn.jsp" method="GET">
          <button class="btn btn-danger" type="submit">Sign In</button>
        </form>
      </li>

      <li class="navbar-form">
        <form action="signUp.jsp" method="GET">
          <button class="btn btn-danger" type="submit">Sign Up</button>
        </form>
      </li>
    </ul>
  </div>
</div>
</nav>