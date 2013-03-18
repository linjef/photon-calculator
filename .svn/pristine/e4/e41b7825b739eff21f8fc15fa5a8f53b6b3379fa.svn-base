<%@ page import="photons.*"
%><%
	String img = request.getParameter("img");
	String ill = request.getParameter("ill");
	String fNo = request.getParameter("f");
	String l = request.getParameter("l");
	int[] into = null; 
	if (request.getParameterMap().containsKey("x1")) {
		int x1 = Integer.parseInt(request.getParameter("x1"));
		int y1 = Integer.parseInt(request.getParameter("y1"));
		int w = Integer.parseInt(request.getParameter("w"));
		int h = Integer.parseInt(request.getParameter("h"));
		into = new int[]{x1, y1, w, h};
	}

	out.print(Images.getIrradiance(img, ill, into, fNo, l)); 
%>