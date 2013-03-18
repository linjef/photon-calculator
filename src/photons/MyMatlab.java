package photons;

import matlabcontrol.*;
import matlabcontrol.extensions.*;
 
public class MyMatlab {
		
		private static MatlabProxyFactory factory;
	    private static MatlabProxy proxy;
		
		static {
			try {
				factory = new MatlabProxyFactory();
			    MatlabProxyFactoryOptions options = new MatlabProxyFactoryOptions.Builder().
			      setUsePreviouslyControlledSession(true).
			      setHidden(true).
//			      setMatlabStartingDirectory(new java.io.File("E:\\SkyDrive\\Documents\\MATLAB\\")).
			      build();
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
