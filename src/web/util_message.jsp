<%@ page import="java.util.List" %>


<%
  // valid types for message: success, info, warning, danger
  Object messageObj = session.getAttribute("message");

  if (messageObj != null && messageObj instanceof java.util.List)
  {
    List<String> message = (List<String>)messageObj;
    String messageHtml = String.format(
      "<div class=\"alert alert-%s alert-dismissible fade in\">" +
        "<button class=\"close\" data-dismiss=\"alert\">" +
          "<span>&times;</span>" +
        "</button>" +
        "<span>%s</span>" +
      "</div>",
    message.get(0), message.get(1));

    out.println(messageHtml);
  }

  session.removeAttribute("message");
%>