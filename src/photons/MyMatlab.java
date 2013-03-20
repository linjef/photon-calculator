package photons;

import matlabcontrol.*;
import matlabcontrol.extensions.*;
 
public class MyMatlab {
		
		private static MatlabProxyFactory factory;
	    private static MatlabProxy proxy;
		
		static {
			try {
				String os = OSCheck.getOS();
				MatlabProxyFactoryOptions options; 
				// if we're on Windows, we can most likely use standard
				// options
				if (os.equals("windows")) {
				    options = new MatlabProxyFactoryOptions.Builder().
				      setUsePreviouslyControlledSession(true).
				      setHidden(true).
				      build();
				}
				// if we're on Linux, think about using specific settings
				// particularly on Ivory, default Matlab seems linked to
				// Matlab 2005 or so. 
				else {
					options = new MatlabProxyFactoryOptions.Builder().
				      setUsePreviouslyControlledSession(true).
				      setHidden(true).
//				      setMatlabStartingDirectory(new java.io.File("E:\\SkyDrive\\Documents\\MATLAB\\")).
				      setMatlabStartingDirectory(new java.io.File("/home/linjef")).
				      setMatlabLocation("/usr/local/matlab/r2012b/bin/matlab").
				      setProxyTimeout(20000).
				      build();
				}
				factory = new MatlabProxyFactory(options);
			    proxy = factory.getProxy();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		public static MatlabProxy getConnection() {
			return proxy;
		}
		
		public static void close() {
			try {
				proxy.disconnect();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
}
