<%@page import="photons.*"%>
<%@page import="matlabcontrol.*"%>
<% 	MatlabProxy proxy = (MatlabProxy) request.getServletContext().getAttribute("proxy");
	double photons = ((double[]) proxy.returningFeval("countPhotons", 1, "hats.jpg")[0])[0];
%>
<p><%=photons %></p>