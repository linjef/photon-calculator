package photons;
import matlabcontrol.*;
import matlabcontrol.extensions.*;

public class TestSetGet {
	public static void main(String[] args) throws MatlabConnectionException, MatlabInvocationException
	{
	    //Create a proxy, which we will use to control MATLAB
//	    MatlabProxyFactory factory = new MatlabProxyFactory();
	    MatlabProxy proxy = MyMatlab.getConnection();

	    //Set a variable, add to it, retrieve it, and print the result
	    proxy.setVariable("a", 5);
	    proxy.eval("a = a + 6");
	    double result = ((double[]) proxy.getVariable("a"))[0];
	    System.out.println("Result: " + result);
	    
	  //Create a 4x3x2 array filled with random values
	    proxy.eval("array = randn(4,3,2)");

	    //Print a value of the array into the MATLAB Command Window
	    proxy.eval("disp(['entry: ' num2str(array(3, 2, 1))])");

	    //Get the array from MATLAB
	    MatlabTypeConverter processor = new MatlabTypeConverter(proxy);
	    MatlabNumericArray array = processor.getNumericArray("array");
	    
	    //Print out the same entry, using Java's 0-based indexing
	    System.out.println("entry: " + array.getRealValue(2, 1, 0));
	    
	    //Convert to a Java array and print the same value again    
	    double[][][] javaArray = array.getRealArray3D();
	    System.out.println("entry: " + javaArray[2][1][0]);
	    
	    proxy.eval("cd E:\\SkyDrive\\Documents\\MATLAB\\");
	    
	    Object[] pwd = proxy.returningEval("pwd", 1);
	    System.out.println("MATLAB Directory: " + pwd[0]);
	    
	    proxy.eval("startup");
	    
	    pwd = proxy.returningFeval("which", 1, "hats.jpg");
	    System.out.println("which hats : " + pwd[0]);
	    
	    double photons = ((double[]) proxy.returningFeval("countPhotons", 1, "hats.jpg")[0])[0];
//	    Object[] photons = proxy.returningFeval("countPhotons", 1, "hats.jpg"); 
	    System.out.println("Photon Number: " + photons);

	    //Disconnect the proxy from MATLAB
	    proxy.disconnect();
	}
}
