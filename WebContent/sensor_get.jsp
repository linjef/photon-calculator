<%@page import="photons.*"%><%@page import="matlabcontrol.*"%><% 	
	String command = request.getParameter("c");
	System.out.println(command);
	Object[] returnArguments;  
	if (!(command.substring(0, 9).equals(  "sensorGet") || 
			command.substring(0, 9).equals("opticsGet") || 
			command.substring(0, 5).equals("oiGet") || 
			command.substring(0, 8).equals("sceneGet"))) {
		System.out.println("invalid input"); 
		returnArguments = new String[]{"invalid input"}; 
	}
	else {
		MatlabProxy proxy = (MatlabProxy) request.getServletContext().getAttribute("proxy");
		returnArguments = proxy.returningEval("num2str("+command+")", 1);
		if (returnArguments[0].toString().contains("[D@]")){
			//MatlabTypeConverter processor = new MatlabTypeConverter(proxy);
		    //MatlabNumericArray array = processor.getNumericArray("array");
		}
	}
	out.println("<p><code>");
	for (Object i : returnArguments) {
		if (i instanceof Object[]) {
			for (Object j : (Object []) i) {
				out.println(j);
			}
		}
		else 
			out.println(i); 
	}
	out.println("</p></code>");
%>