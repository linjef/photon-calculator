package photons;

import matlabcontrol.*;
import matlabcontrol.extensions.*;

public class Images {
	public static int[][][] getImage(String img, String ill) {
		MatlabProxy proxy = MyMatlab.getConnection();
		double[][][] javaArray = new double[1][1][1];
		try {
			String file = 
			  "sFile = fullfile(isetRootPath,'data','images','rgb','"+img+"')"; 
			proxy.eval(file);
			proxy.eval("scene = sceneFromFile(sFile,'rgb');");
			proxy.eval("scene = sceneAdjustIlluminant(scene,'"+ill+"')");
			proxy.eval("rgb = sceneShowImageReturn(scene, 1, 0.6); ");
			
			MatlabTypeConverter processor = new MatlabTypeConverter(proxy);
		    MatlabNumericArray array = processor.getNumericArray("rgb");
		    
		    javaArray = array.getRealArray3D();
			
		} catch (MatlabInvocationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		int[][][] returnArray = new int[javaArray.length]
		                               [javaArray[0].length]
		                               [javaArray[0][0].length]; 
		for (int i = 0; i < javaArray.length; i++ ) {
			for (int j = 0; j < javaArray[i].length; j++) {
				for (int k = 0; k < javaArray[i][j].length; k++) {
					returnArray[i][j][k] = (int) Math.round(javaArray[i][j][k]*255); 
					if (returnArray[i][j][k] > 255)
						System.out.println("wtf"); 
				}
			}
		}
		return returnArray;
	}
	/**
	 * Rect comes in in form of x1, y1, width, height
	 * @param img
	 * @param ill
	 * @param rect
	 * @return
	 */
	public static String getRadiance(String img, String ill, int[] rect) {
		MatlabProxy proxy = MyMatlab.getConnection();
		StringBuilder sb = new StringBuilder();
		double[] radiance = new double[1];
		double[] wavelengths = new double[1];
		try {
			String file = 
			  "sFile = fullfile(isetRootPath,'data','images','rgb','"+img+"')"; 
			proxy.eval(file);
			proxy.eval("scene = sceneFromFile(sFile,'rgb');");
			proxy.eval("scene = sceneAdjustIlluminant(scene,'"+ill+"')");
			//proxy.eval("rgb = sceneShowImageReturn(scene, 1, 0.6); ");
			if (rect == null)
				proxy.eval("roiRect = [0, 0, size(scene.data.photons, 2), size(scene.data.photons, 1)];");
			else
				proxy.eval("roiRect = ["+rect[0]+", "+rect[1]+", "+rect[2]+", "+rect[3]+"];");
			proxy.eval("roiLocs = ieRoi2Locs(roiRect);");
			proxy.eval("[udata, f] = plotScene(scene,'radiance photons roi',roiLocs);");
			proxy.eval("a = udata.photons(:)");
			proxy.eval("b = udata.wave(:)");

			proxy.eval("close all;");
			
			radiance = ((double[]) proxy.getVariable("a"));
			wavelengths = ((double[]) proxy.getVariable("b"));
		} catch (MatlabInvocationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		sb.append("[[");
		String prefix = "";
		for (int i = 0; i < radiance.length; i++) {
			sb.append(prefix);
			prefix = ",";
			sb.append("["+wavelengths[i]+", "+Long.toString((long) radiance[i])+"]");
		}
		sb.append("]]");
		
		return sb.toString();
	}
	/**
	 * Rect comes in in form of x1, y1, width, height
	 * @param img
	 * @param ill
	 * @param rect
	 * @return
	 */
	public static String getIrradiance(String img, String ill, int[] rect, String fNo, String lens) {
		MatlabProxy proxy = MyMatlab.getConnection();
		StringBuilder sb = new StringBuilder();
		double[] radiance = new double[1];
		double[] wavelengths = new double[1];
		try {
			String file = 
			  "sFile = fullfile(isetRootPath,'data','images','rgb','"+img+"')"; 
			proxy.eval(file);
			proxy.eval("scene = sceneFromFile(sFile,'rgb');");
			proxy.eval("scene = sceneAdjustIlluminant(scene,'"+ill+"')");
			proxy.eval("oi = oiCreate; optics = oiGet(oi,'optics');");
			proxy.eval("optics = opticsSet(optics,'f number',"+fNo+");");
			proxy.eval("data = load('"+lens+"') ;");
			System.out.println("load "+lens+" ;"); 
			proxy.eval("optics = opticsSet(optics, 'transmittance', data);");
			proxy.eval("oi = oiSet(oi,'optics',optics);");
			proxy.eval("oi = oiCompute(scene,oi);");
			//proxy.eval("rgb = sceneShowImageReturn(scene, 1, 0.6); ");
			if (rect == null)
				proxy.eval("roiRect = [0, 0, size(scene.data.photons, 2), size(scene.data.photons, 1)];");
			else
				proxy.eval("roiRect = ["+rect[0]+", "+rect[1]+", "+rect[2]+", "+rect[3]+"];");
			proxy.eval("plotOI(oi,'irradiance photons roi', roiRect);");
			proxy.eval("udata = get(gcf,'userdata');");
			proxy.eval("a = udata.y(:)");
			proxy.eval("b = udata.x(:)");

			proxy.eval("close all;");
			
			radiance = ((double[]) proxy.getVariable("a"));
			wavelengths = ((double[]) proxy.getVariable("b"));
		} catch (MatlabInvocationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		sb.append("[[");
		String prefix = "";
		for (int i = 0; i < radiance.length; i++) {
			sb.append(prefix);
			prefix = ",";
			sb.append("["+wavelengths[i]+", "+Long.toString((long) radiance[i])+"]");
		}
		sb.append("]]");
		
		return sb.toString();
	}
	
	
	public static int[][][] getSensor(String img, String ill, int[] rect, String fNo, String lens) {
		MatlabProxy proxy = MyMatlab.getConnection();
		double[][][] javaArray = new double[1][1][1];
		try {
//			img = "hats.jpg";
//			ill = "D65.mat";
//			fNo = "2";
//			lens = "glassTrans.dat"; 
			System.out.println(img);
			System.out.println(ill);
			System.out.println(fNo);
			System.out.println(lens);
			
			String file = 
				  "sFile = fullfile(isetRootPath,'data','images','rgb','"+img+"')"; 
				proxy.eval(file);
				proxy.eval("set(0,'DefaultFigureVisible','off');");
				proxy.eval("scene = sceneFromFile(sFile,'rgb');");
				proxy.eval("scene = sceneAdjustIlluminant(scene,'"+ill+"')");
				// temporarily hard-code to create only human optics for the sensor
				proxy.eval("oi = oiCreate('human'); optics = oiGet(oi,'optics');");
				proxy.eval("optics = opticsSet(optics,'f number',"+fNo+");");
				proxy.eval("data = load('"+lens+"') ;");
				System.out.println("load "+lens+" ;"); 
				proxy.eval("optics = opticsSet(optics, 'transmittance', data);");
				proxy.eval("oi = oiSet(oi,'optics',optics);");
				proxy.eval("oi = oiCompute(scene,oi);");
				//proxy.eval("rgb = sceneShowImageReturn(scene, 1, 0.6); ");
				if (rect == null)
					proxy.eval("roiRect = [0, 0, size(scene.data.photons, 2), size(scene.data.photons, 1)];");
				else
					proxy.eval("roiRect = ["+rect[0]+", "+rect[1]+", "+rect[2]+", "+rect[3]+"];");
				proxy.eval("cSensor = sensorCreate('human');");
				proxy.eval("[eyehistogram, sensor, optics, scene] = func_s_HumanSensor(scene, oi);");
				proxy.eval("eyehistogram = cast(eyehistogram, 'double');");
				
//			proxy.eval("rgb = sceneShowImageReturn(scene, 1, 0.6); ");
			
			MatlabTypeConverter processor = new MatlabTypeConverter(proxy);
		    MatlabNumericArray array = processor.getNumericArray("eyehistogram");
		    
		    javaArray = array.getRealArray3D();
			
		} catch (MatlabInvocationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		int[][][] returnArray = new int[javaArray.length]
		                               [javaArray[0].length]
		                               [javaArray[0][0].length]; 
		for (int i = 0; i < javaArray.length; i++ ) {
			for (int j = 0; j < javaArray[i].length; j++) {
				for (int k = 0; k < javaArray[i][j].length; k++) {
					returnArray[i][j][k] = (int) Math.round(javaArray[i][j][k]); 
					if (returnArray[i][j][k] > 255)
						System.out.println("wtf"); 
				}
			}
		}
		return returnArray;
	}
	public static int[][][] getOIImage(String img, String ill, int[] rect, String fNo, String lens) {
		MatlabProxy proxy = MyMatlab.getConnection();
		double[][][] javaArray = new double[1][1][1];
		try {
//			img = "hats.jpg";
//			ill = "D65.mat";
//			fNo = "2";
//			lens = "glassTrans.dat"; 
			System.out.println(img);
			System.out.println(ill);
			System.out.println(fNo);
			System.out.println(lens);
			
  
				proxy.eval("vcAddAndSelectObject(oi); ");
				proxy.eval("img = oiGet(oi,'photons');rgb = imageSPD(img,oiGet(oi,'wavelength'));ieViewer(rgb);");
				proxy.eval("apicture = hardcopy(gcf, '-Dzbuffer', '-r0');");
				
				proxy.eval("apicture = cast(apicture, 'double');");
				
//			proxy.eval("rgb = sceneShowImageReturn(scene, 1, 0.6); ");
			
			MatlabTypeConverter processor = new MatlabTypeConverter(proxy);
		    MatlabNumericArray array = processor.getNumericArray("apicture");
		    
		    javaArray = array.getRealArray3D();
			
		} catch (MatlabInvocationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		int[][][] returnArray = new int[javaArray.length]
		                               [javaArray[0].length]
		                               [javaArray[0][0].length]; 
		for (int i = 0; i < javaArray.length; i++ ) {
			for (int j = 0; j < javaArray[i].length; j++) {
				for (int k = 0; k < javaArray[i][j].length; k++) {
					returnArray[i][j][k] = (int) Math.round(javaArray[i][j][k]); 
					if (returnArray[i][j][k] > 255)
						System.out.println("wtf"); 
				}
			}
		}
		return returnArray;
	}
}
