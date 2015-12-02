<%@ include file="util_connection.jsp"%>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.sql.Date"%>

<%@ include file="util_user.jsp" %>

<%
	Connection con = connectionManager.open();
%>

<%!void createListedPart(HttpServletRequest request, Connection connection, HttpSession session, HashMap<String, String> user) {
		String[] PartInfoKeys = {"partId", "quantity", "price"};

		List<String> PartDets = new ArrayList<String>();

		for (String PartInfoKey : PartInfoKeys) {
			PartDets.add((String) request.getParameter(PartInfoKey));
		}

		try {
			if (user != null && user.get("accountType").equals("vendor")) {
				PreparedStatement preparedStatement = null;
	
				String query = "SELECT MAX(listId) FROM ListedPart;";
	
				preparedStatement = connection.prepareStatement(query);
				ResultSet rs = preparedStatement.executeQuery(query);
	
				rs.next();
				Integer k = rs.getInt(1);
	
				String insertTableSQL = "INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)"
						+ "VALUES" + "(?,?,?,?,?,?)";
	
				preparedStatement = connection.prepareStatement(insertTableSQL);
	
				preparedStatement.setInt(1, k + 1);
				preparedStatement.setInt(2, Integer.parseInt(user.get("accountId")));
				preparedStatement.setInt(3, Integer.parseInt(PartDets.get(0)));
				preparedStatement.setInt(4, Integer.parseInt(PartDets.get(1)));
				preparedStatement.setDouble(5, Double.parseDouble(PartDets.get(2)));
				
				long time = System.currentTimeMillis();
				java.sql.Date date = new java.sql.Date(time);
				preparedStatement.setDate(6, date);
				
				preparedStatement.executeUpdate();
	
				System.out.println("Your part has been added");
				session.setAttribute("message", Arrays.asList("success", "Your part has been listed successfully"));

			} // int toBePass = k+1; (k+1 = partId)
		} catch (Exception e) {
			System.out.println(e);
			session.setAttribute("message", Arrays.asList("danger", "Failed to list your part, please try again"));
		}
	}%>
<%

	boolean valid = true;
	for (String val : request.getParameterMap().keySet()) {
		if (request.getParameter(val) == null || request.getParameter(val).equals("")) {
			valid = false;
		}
	}
	if (valid && request.getMethod().equals("POST")) {  
		createListedPart(request, con, session, user);
		response.sendRedirect("fitsIn.jsp");
	}
	
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>EverythingRoadster - List Part</title>
<meta name="description" content="">
<meta name="viewport" content="width=device-width, initial-scale=1">

<link rel="stylesheet" href="vendor/stylesheets/bootstrap.min.css">
<link rel="stylesheet" href="stylesheets/main.css">
<link rel="stylesheet" href="stylesheets/createPart.css">

<script src="vendor/javascripts/modernizr-2.8.3-respond-1.4.2.min.js"></script>
<script src="vendor/javascripts/jquery-2.1.4.min.js"></script>
<script src="vendor/javascripts/bootstrap.min.js"></script>
</head>

<body>
	<%@ include file="util_navbar.jsp"%>
	<%@ include file="util_message.jsp"%>

	<div class="container-fluid">
		<div class="row">
			<div class="col-xs-12">
				<h1>Create Part</h1>
			</div>
		</div>

		<form class="add-part-form row" action="./listPart.jsp" method="POST">
			<div class="col-xs-12">
				<div class="form-group">
					<label for="part-name-input">Part Name</label> <input
						id="part-name-input" class="form-control" type="text"
						name="partName" />
				</div>
				<div class="form-group">
					<label for="category-name-input">Category Name</label> <select
						id="category-name-input" class="form-control" name="categoryName">

						<%
							PreparedStatement categoryNamesPS = con.prepareStatement("SELECT categoryName " + "FROM PartCategory;");
							ResultSet categoryNamesRS = categoryNamesPS.executeQuery();

							while (categoryNamesRS.next()) {
								String categoryName = categoryNamesRS.getString("categoryName");
								String categoryOptionHtml = String.format("<option value=\"%s\">%s</option>", categoryName,
										categoryName);

								out.println(categoryOptionHtml);
							}
						%>

					</select>
				</div>
				<div class="form-group">
					<label for="description-input">Description</label> <input
						id="description-input" class="form-control" type="text"
						name="description" />
				</div>
				<div class="form-group">
					<label for="image-path-input">Image Path</label> <input
						id="image-path-input" class="form-control" type="text"
						name="imagePath" />
				</div>

				<button class="btn btn-success" type="submit">Add Part</button>
			</div>
		</form>
	</div>

	<%@ include file="util_copyright.jsp"%>

</body>
</html>

<%
	connectionManager.close();
%>