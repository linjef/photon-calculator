package photons;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSession;
import matlabcontrol.*;

/**
 * Application Lifecycle Listener implementation class OpenListener
 *
 */
@WebListener
public class OpenListener implements ServletContextListener {

    /**
     * Default constructor. 
     */
    public OpenListener() {
        // TODO Auto-generated constructor stub
    }

	/**
     * @see ServletContextListener#contextInitialized(ServletContextEvent)
     */
    public void contextInitialized(ServletContextEvent arg0) {
        // open up the matlab connection and store it. forever, hopefully
    	MatlabProxy proxy = MyMatlab.getConnection();
    	
    	try{
	    	proxy.eval("cd E:\\SkyDrive\\Documents\\MATLAB\\");
		    
		    Object[] pwd = proxy.returningEval("pwd", 1);
		    System.out.println("MATLAB Directory: " + pwd[0]);
		    
		    proxy.eval("startup");
    	} catch (Exception e) {
			e.printStackTrace();
		}
	    
	    arg0.getServletContext().setAttribute("proxy", proxy);
    }

	/**
     * @see ServletContextListener#contextDestroyed(ServletContextEvent)
     */
    public void contextDestroyed(ServletContextEvent arg0) {
        // TODO Auto-generated method stub
    }
	
}
