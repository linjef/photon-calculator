<?xml version="1.0" encoding="ISO-8859-1" ?>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Psych 221: Photon Calculator</title>
<link rel="stylesheet" href="style.css" type="text/css" media="screen" />
<script language="javascript" type="text/javascript" src="jquery.min.js"></script>
<%-- <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js" ></script>--%>
<link rel="stylesheet" type="text/css" href="css/imgareaselect-default.css" />
<%-- <script type="text/javascript" src="scripts/jquery.min.js"></script>--%>
<script type="text/javascript" src="scripts/jquery.imgareaselect.pack.js"></script>

<%-- jqplot required js's --%>
<!--[if lt IE 9]><script language="javascript" type="text/javascript" src="excanvas.js"></script><![endif]-->

<script language="javascript" type="text/javascript" src="jquery.jqplot.min.js"></script>
<script type="text/javascript" src="plugins/jqplot.json2.min.js"></script>
<script type="text/javascript" src="plugins/jqplot.canvasTextRenderer.js"></script>
<script type="text/javascript" src="plugins/jqplot.canvasAxisLabelRenderer.js"></script>
<link rel="stylesheet" type="text/css" href="jquery.jqplot.css" />
    
<script type="text/javascript">
function preview(img, selection) {
    if (!selection.width || !selection.height)
        return;
    
    var scaleX = 100 / selection.width;
    var scaleY = 100 / selection.height;

    $('#preview img').css({
        width: Math.round(scaleX * document.getElementById("photo").clientWidth),
        height: Math.round(scaleY * document.getElementById("photo").clientHeight),
        marginLeft: -Math.round(scaleX * selection.x1),
        marginTop: -Math.round(scaleY * selection.y1)
    });

    $('#x1').val(selection.x1);
    $('#y1').val(selection.y1);
    $('#x2').val(selection.x2);
    $('#y2').val(selection.y2);
    $('#w').val(selection.width);
    $('#h').val(selection.height);    
}

$(function () {
    $('#photo').imgAreaSelect({ aspectRatio: false, handles: true,
        fadeSpeed: 200, onSelectChange: preview });
});

$(document).ready(function () {
	window.plot2 = $.jqplot('chartIrr',  [[[1, 2],[3,5.12],[5,13.1],[7,33.6],[9,85.9],[11,219.9]]]);
	window.plot3 = $.jqplot('chartRad',  [[[1, 2],[3,5.12],[5,13.1],[7,33.6],[9,85.9],[11,219.9]]]);
	ChangeIll(1); 
	$('.helpDiv').toggle("slow");// hide help items. 
	loadSensor(1); 
	loadOpticsImage(1);
});

</script>
<script>
	function loadXMLDoc() {
		var xmlhttp;
		if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
		  xmlhttp=new XMLHttpRequest();
		} else {// code for IE6, IE5
		  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		}
		xmlhttp.onreadystatechange=function() {
		  if (xmlhttp.readyState==4 && xmlhttp.status==200) {
		    document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
		  }
		}
		xmlhttp.open("GET","demo_get.jsp",true);
		xmlhttp.send();
	}; 
	// this function only needs to change irradiance when set to false
	function ChangeIll(fullChange) {
		var lens = $('input:radio[name=lens]:checked').val();
		var fNo = document.getElementById("fNo").value; 
		var imgName = $('input:radio[name=group1]:checked').val();
		var ill = $('input:radio[name=ill]:checked').val();
		if (ill==undefined) {
			ill = "D65.mat";
		}
		if (imgName==undefined) {
			imgName = "hats.jpg";
		}
		var txt = "<img id=\"photo\" src=\"create_image.jsp?img="+imgName+"&ill="+ill+"\" onload=\"loadImage()\" /> ";
		var txt2 = "<img src=\"create_image.jsp?img="+imgName+"&ill="+ill+"\" style=\"width: 100px; height: 100px;\" /> ";
		console.log(txt);
		// The url for our json data
		if ($('#x1').val() == "-") {
			var jsonRad = "create_rad.jsp?img="+imgName+"&ill="+ill+"&f="+fNo; 
			var jsonIrr = "create_irr.jsp?img="+imgName+"&ill="+ill+"&f="+fNo+"&l="+lens;
		}
		else {
			var jsonRad = "create_rad.jsp?img="+imgName+"&ill="+ill+"&f="+fNo+"&x1="+$('#x1').val()+"&y1="+$('#y1').val()+"&w="+$('#w').val()+"&h="+$('#h').val();
			var jsonIrr = "create_irr.jsp?img="+imgName+"&ill="+ill+"&f="+fNo+"&l="+lens+"&x1="+$('#x1').val()+"&y1="+$('#y1').val()+"&w="+$('#w').val()+"&h="+$('#h').val();
		}
		
		
		console.log(jsonIrr);
		
		if(fullChange) {
			document.getElementById("imageGoesHere").innerHTML=txt;
			document.getElementById("preview").innerHTML=txt2;
			$('#photo').imgAreaSelect({ aspectRatio: '1:1', handles: true,
		        fadeSpeed: 200, onSelectChange: preview });
		}
		// Our ajax data renderer which here retrieves a text file.
		// it could contact any source and pull data, however.
		// The options argument isn't used in this renderer.
		var ajaxDataRenderer = function(url, plot, options) {
		  var ret = null;
		  $.ajax({
		    // have to use synchronous here, else the function 
		    // will return before the data is fetched
		    async: false,
		    url: url,
		    dataType:"json",
		    success: function(data) {
		      ret = data;
		    }
		  });
		  return ret;
		};

		var oldPlot = window.plot2; 
		oldPlot.destroy();
		if (fullChange) {
			oldPlot = window.plot3; 
			oldPlot.destroy();
		}
		// passing in the url string as the jqPlot data argument is a handy
		// shortcut for our renderer.  You could also have used the
		// "dataRendererOptions" option to pass in the url.
		window.plot2 = $.jqplot('chartIrr', jsonIrr,{
			// Turns on animatino for all series in this plot.
	        animate: true,
	        // Will animate plot on calls to plot1.replot({resetAxes:true})
	        animateReplot: true,
			title: "Calculated Irradiance",
			axes:{
				  xaxis:{
				    label:'wavelength (nm)', 
				    min:400, max:700, numberTicks:31
				  },
				  yaxis:{
				    label:'Irradiance (photons / s / m^2 / nm)', 
				    labelRenderer: $.jqplot.CanvasAxisLabelRenderer
				  }
				},
			dataRenderer: ajaxDataRenderer,
		});
		if (fullChange) {
			window.plot3 = $.jqplot('chartRad', jsonRad,{
				// Turns on animatino for all series in this plot.
		        animate: true,
		        // Will animate plot on calls to plot1.replot({resetAxes:true})
		        animateReplot: true,
				title: "Extrapolated Radiance",
				axes:{ xaxis:{}},
				axes:{
				  xaxis:{
				    label:'wavelength (nm)', 
				    min:400, max:700, numberTicks:31
				  },
				  yaxis:{
				    label:'Radiance (photons / s / sr / m^2 / nm)', 
				    labelRenderer: $.jqplot.CanvasAxisLabelRenderer
				  }
				},
				dataRenderer: ajaxDataRenderer,
			});
		}
		var rad = (window.plot3.data)[0].reduce(function(a, b){return [a[0]+b[0],a[1] + b[1]];});
		rad = rad[1]*10;
		document.getElementById("valueRad").innerHTML="Value over 400-700nm: "+rad+" photons / s / sr / m^2";
		var irr = (window.plot2.data)[0].reduce(function(a, b){return [a[0]+b[0],a[1] + b[1]];});
		irr = irr[1]*10;
		document.getElementById("valueIrr").innerHTML="Value over 400-700nm: "+irr+" photons / s / m^2";
		
		loadSensor(1); 
		loadOpticsImage();
	} 
	function loadImage() {
		var o = document.getElementById("imageGoesHere");
		o.style.width = document.getElementById("photo").clientWidth+"px";
		console.log(document.getElementById("photo").clientWidth+"px");
		o.style.height = document.getElementById("photo").clientHeight+"px";
	} 
	function loadSensor() {
		var lens = $('input:radio[name=lens]:checked').val();
		var fNo = document.getElementById("fNo").value; 
		var imgName = $('input:radio[name=group1]:checked').val();
		var ill = $('input:radio[name=ill]:checked').val();
		if (ill==undefined) {
			ill = "D65.mat";
		}
		if (imgName==undefined) {
			imgName = "hats.jpg";
		}		
		
		if ($('#x1').val() == "-") { 
			var txt = "<img id=\"photo\" src=\"create_sensor.jsp?img="+imgName+"&ill="+ill+"&f="+fNo+"&l="+lens+"\" onload=\"loadImage()\" /> ";
		}
		else {
			var txt = "<img id=\"photo\" src=\"create_sensor.jsp?img="+imgName+"&ill="+ill+"&f="+fNo+"&l="+lens+"&x1="+$('#x1').val()+"&y1="+$('#y1').val()+"&w="+$('#w').val()+"&h="+$('#h').val()+"\" onload=\"loadImage()\" /> ";
		}
		document.getElementById("sensor_imageGoesHere").innerHTML=txt;
	}
	function loadOpticsImage() {
		var lens = $('input:radio[name=lens]:checked').val();
		var fNo = document.getElementById("fNo").value; 
		var imgName = $('input:radio[name=group1]:checked').val();
		var ill = $('input:radio[name=ill]:checked').val();
		if (ill==undefined) {
			ill = "D65.mat";
		}
		if (imgName==undefined) {
			imgName = "hats.jpg";
		}		
		
		if ($('#x1').val() == "-") { 
			var txt = "<img id=\"photo\" src=\"create_optics.jsp?img="+imgName+"&ill="+ill+"&f="+fNo+"&l="+lens+"\" onload=\"loadImage()\" /> ";
		}
		else {
			var txt = "<img id=\"photo\" src=\"create_optics.jsp?img="+imgName+"&ill="+ill+"&f="+fNo+"&l="+lens+"&x1="+$('#x1').val()+"&y1="+$('#y1').val()+"&w="+$('#w').val()+"&h="+$('#h').val()+"\" onload=\"loadImage()\" /> ";
		}
		document.getElementById("optics_imageGoesHere").innerHTML=txt;
	}
</script>

<script> // script uses tutorial from http://monc.se/wp-content/uploads/shade.png
	var btn = { init : function() {
		console.log('doing btn');
		if (!document.getElementById || !document.createElement || 
				!document.appendChild) 
			return false; 
		as = btn.getElementsByClassName('btn(.*)'); 
		for (i=0; i<as.length; i++) { 
			if ( as[i].tagName == "INPUT" && 
					( as[i].type.toLowerCase() == "submit" || 
							as[i].type.toLowerCase() == "button" ) ) { 
				var tt = document.createTextNode(as[i].value); 
				var a1 = document.createElement("a"); 
				a1.className = as[i].className; 
				a1.id = as[i].id; 
				as[i] = as[i].parentNode.replaceChild(a1, as[i]); 
				as[i] = a1; as[i].style.cursor = "pointer"; }
			else if (as[i].tagName == "A") { 
				var tt = as[i].firstChild; } 
			else { return false }; 
			var i1 = document.createElement('i'); 
			var i2 = document.createElement('i'); 
			var s1 = document.createElement('span'); 
			var s2 = document.createElement('span'); 
			s1.appendChild(i1); s1.appendChild(s2); 
			s1.appendChild(tt); as[i].appendChild(s1); 
			as[i] = as[i].insertBefore(i2, s1); }},
		findForm : function(f) { 
			while(f.tagName != "FORM") { f = f.parentNode; } 
			return f; }, 
		addEvent : function(obj, type, fn) { 
			console.log('adding event2:!');
			console.log(obj);
			console.log(type);
			console.log(fn);
			if (obj.addEventListener) { 
				obj.addEventListener(type, fn, false); } 
			else if (obj.attachEvent) { 
				obj["e"+type+fn] = fn; 
				obj[type+fn] = function() { 
					obj["e"+type+fn]( window.event ); } 
				obj.attachEvent("on"+type, obj[type+fn]); } }, 
		getElementsByClassName : function(className, tag, elm) { 
			var testClass = new RegExp("(^|\s)" + className + "(\s|$)"); 
			var tag = tag || "*"; var elm = elm || document; 
			var elements = (tag == "*" && elm.all)? elm.all : elm.getElementsByTagName(tag); 
			var returnElements = []; var current; 
			var length = elements.length; 
			for(var i=0; i<length; i++){ 
				current = elements[i]; 
				if(testClass.test(current.className)){ returnElements.push(current); } } 
			return returnElements; } }
	btn.init();
</script>
<script>
	function showHelp() {
		console.log('button hit!');
		$('.helpDiv').toggle("slow");
	}
</script>


</head>
<body>
<div id="helpbar">
<a href="#" class="btn green" id="submit_btn" onclick="showHelp()">Help?</a>

</div>
<div id="content" class="container">
<div class="post single">
<h1>Psych 221: Photon Calculator</h1>
<h3>Choose a sample image -- scene radiance will be extrapolated</h3>
<div class="helpDiv">
	<p>
		What is scene radiance? Instead of answering this immediately, we can first start
		by defining two other radiometric units first.
	</p>
	<p>
		Radiant flux is a measure of all captured light from a point source--it is as if 
		you placed a large sphere around a point source and measured exactly how much
		energy impinged upon this sphere. Therefore, it has units that correspond to
		how much light is emitted from a point: joules (energy) per second (time) per 
		nanometer (wavelength). 
	</p>
	<p>
		As you'll soon see, all radiometric units are a function of wavelength 
		(and thus will have nanometers in their denominator). 
	</p>
	<p>
		Radiant intensity is a measure of light emitted from a point source into
		a solid angle. A solid angle is the surface area on the unit sphere
		intersected by a cone (with its apex at the center of the unit sphere).  
	</p>
	<p align="center">
		<img src="images/steradian.png" title="Image sourced from Wikipedia"></img>  
	</p>
	<p>
		The surface area of this intersection can be measured in steradians, as 
		seen in the image above. A sphere is 4pi steradians. As a result, radiant intensity
		has units of: joules (energy) per second (time) per nanometer (wavelength) per steradian
		(solid angle).   
	</p>
	<p>
		Finally, we get to spectral radiance. Spectral radiance adds in another dimension--that
		of an extended source with a particular viewing angle. As you know, a light seen head-on
		throws more photons into your eye than does a light seen from a perpendicular angle. 
	</p>
	<p align="center">
		<img src="images/radiance.png" title="Image sourced from Professor Wandell's slides"></img>  
	</p>
	<p>
		Furthermore, we are no longer dealing with a point source--instead we are dealing with
		a source that is flat on a surface, and has some dimension (and area). Thus, this unit
		is radiant intensity as a function of surface area and angle; thus, it is radiant intensity
		divided by the source area and cosine of the viewing angle. Spectral radiance has units 
		of joules (energy) per second (time) per nanometer (wavelength) per steradian
		(solid angle) per meter-squared (area). 
	</p>
	<p>
		Spectral radiance is a good count of how much light comes from an extended source in a given direction. 
		As you may expect, spectral radiance normally is expensive to measure--digital cameras images, for example, 
		are a better representation of spectral irradiance (which we will get to later). Spectral radiance is normally
		measured by spectroradiometric measurers (such as a Photoresearch PR-655, which has some optics and a diffraction grating on a photodetector); 
		however, in this tutorial, we will be able to 
		transform normal Jpeg images into radiance measurements using software developed by Professor Wandell and 
		Dr. Farrell, VSET. Using the sceneFromFile function, a spectral measurement is extrapolated by using
		an image and a calibration illumination image. 
	</p>
	<p>
		In summary:  
	</p>
	<p align="center">
		<img src="images/radiancesummary.png" title="Image sourced from Professor Wandell's slides" width="600px"></img>  
	</p>
</div>
<form name="imgSelect"">
<div align="center"><br>
	<input type="radio" name="group1" value="eagle.jpg" onclick="ChangeIll(1)">Eagle
	<input type="radio" name="group1" value="hats.jpg" onclick="ChangeIll(1)" checked>Hats
	<input type="radio" name="group1" value="Ma_Lion_6459.jpg" onclick="ChangeIll(1)">Lion
	<hr>
</div>
</form>

<h3>Choose an illuminant</h3>
<div class="helpDiv">
	<p>
		What is an illuminant? Illuminants are a function of wavelength (and can be measured in relative energy) 
		which represent the spectral quality of a white light source in a scene. You see everyday examples 
		in just your house; fluorescent and incandescent light have different spectral qualities,  for example:  
	</p>
	<p align="center">
		<img src="images/colortempcomparison.png" title="Image sourced from Wikipedia"></img>  
	</p>
	<p>
		Three common CIE-defined illuminants follow: D65 (representative of noon daylight), 
		fluorescent (cool white fluorescent, similar to what is used in offices), and 
		tungsten/incandescent light sources (often found in homes).  
	</p>
	<p>
		VSET will take your selection and apply it to the scene chosen above. 
	</p>
</div>
<form name="illSelect"">
<div align="center"><br>
	<input type="radio" name="ill" value="D65.mat" onclick="ChangeIll(1)" checked>D65
	<input type="radio" name="ill" value="Fluorescent.mat" onclick="ChangeIll(1)">Fluorescent
	<input type="radio" name="ill" value="Tungsten.mat" onclick="ChangeIll(1)">Tungsten
	<hr>
</div>
</form>

<h3>Choose a region</h3>
<div class="helpDiv">
	<p>
		Choose a region of interest to perform calculations on.  
	</p>
	<p>
		This region applies to radiance/irradiance calculations, but not to the sensor calculation as of yet. 
	</p>
</div>
<div class="container demo">
  <div style="float: left; width: 70%;">
    <p class="instructions">
      Click and drag on the image to select an area. 
    </p>
 
    <div id="imageGoesHere" class="frame" style="margin: 0 0.3em; width: 300px; height: 300px;">
      <img id="photo" src="flower2.jpg" />
    </div>
  </div>
 
  <div style="float: left; width: 30%;">
    <p style="font-size: 110%; font-weight: bold; padding-left: 0.1em;">
      Selection Preview
    </p>
  
    <div class="frame" 
      style="margin: 0 1em; width: 100px; height: 100px;">
      <div id="preview" style="width: 100px; height: 100px; overflow: hidden;">
        <img src="flower2.jpg" style="width: 100px; height: 100px;" />
      </div>
    </div>

    <table style="margin-top: 1em;">
      <thead>
        <tr>
          <th colspan="2" style="font-size: 110%; font-weight: bold; text-align: left; padding-left: 0.1em;">
            Coordinates
          </th>
          <th colspan="2" style="font-size: 110%; font-weight: bold; text-align: left; padding-left: 0.1em;">
            Dimensions
          </th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td style="width: 10%;"><b>X<sub>1</sub>:</b></td>
 		      <td style="width: 30%;"><input type="text" id="x1" value="-" /></td>
 		      <td style="width: 20%;"><b>Width:</b></td>
   		    <td><input type="text" value="-" id="w" /></td>
        </tr>
        <tr>
          <td><b>Y<sub>1</sub>:</b></td>
          <td><input type="text" id="y1" value="-" /></td>
          <td><b>Height:</b></td>
          <td><input type="text" id="h" value="-" /></td>
        </tr>
        <tr>
          <td><b>X<sub>2</sub>:</b></td>
          <td><input type="text" id="x2" value="-" /></td>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td><b>Y<sub>2</sub>:</b></td>
          <td><input type="text" id="y2" value="-" /></td>
          <td></td>
          <td><button type="button" onclick="ChangeIll(1)">Confirm region</button></td>
        </tr>
      </tbody>
    </table>
  </div>
</div>

<div id="radiance">
	<h3>Extrapolated Radiance</h3>
	<div class="helpDiv">
	<p>
		Radiance is now shown here, as extrapolated by VSET from the Jpeg file. 
	</p>
	<p>
		Note that, in this case, the units are with respect to photons instead of to joules (energy). 
		However, you can always do a calculation of energy from the wavelength of a photon, or do it backwards
		(photon to energy).  
	</p>
	</div>
	<p><h4 id="valueRad">Value: </h4></p>
	<div id="chartRad" style="height:400px;"></div>
</div>

<h3>Choose a lens (for transmission calculations)</h3>
	<div class="helpDiv">
	<p>
		Up to now, everything has been calculated using only the scene. Now, we can consider adding in
		optics to the equation(s). A lens stands in between a source of light and a sensor of light, and 
		often changes the spectral quality of the light.  
	</p>
	<p>
		The lens quantities you can work with here are that of transmittance and of f/# (as we are assuming 
		diffraction-limited optics). A uniform transmittance lens has uniform transmittance, while glass, CR-39, and 
		the Nikon 55mm have their own characteristic transmittance curves. They do, of course, strive to be 
		uniform transmittance lenses, as otherwise the scene can be tinted particular colors. The Nikon's transmittance is shown below:   
	</p>
	<p align="center">
		<img src="images/lens.gif"></img>
	</p>
	<p>
		For fun, there are also a set of filters with less-uniform transmittances to choose from (from left to right, 02 to 16):    
	</p>
	<p align="center">
		<img src="images/filters.gif"></img>
	</p>
	</div>
<form name="lensSelect"">
<div align="center"><br>
	<input type="radio" name="lens" value="uniformTrans.dat" onclick="ChangeIll(0)" checked>Uniform transmittance
	<input type="radio" name="lens" value="glassTrans.dat" onclick="ChangeIll(0)">Glass lens
	<input type="radio" name="lens" value="cr39Trans.dat" onclick="ChangeIll(0)">CR-39 pink-tint plastic
	<input type="radio" name="lens" value="nikon55Trans.dat" onclick="ChangeIll(0)">Nikon 55mm 
	<hr>
	<h5>Melles Griot visible 80 filter set</h5>
	<input type="radio" name="lens" value="F1Trans.dat" onclick="ChangeIll(0)">Filter 02
	<input type="radio" name="lens" value="F2Trans.dat" onclick="ChangeIll(0)">Filter 04
	<input type="radio" name="lens" value="F3Trans.dat" onclick="ChangeIll(0)">Filter 06
	<input type="radio" name="lens" value="F4Trans.dat" onclick="ChangeIll(0)">Filter 08
	<input type="radio" name="lens" value="F5Trans.dat" onclick="ChangeIll(0)">Filter 12
	<input type="radio" name="lens" value="F6Trans.dat" onclick="ChangeIll(0)">Filter 14
	<input type="radio" name="lens" value="F7Trans.dat" onclick="ChangeIll(0)">Filter 16
	<hr>
	f/#: <input type="text" id="fNo" value="2" />
	<hr>
</div>
</form>

<div id="irradiance">
	<div class="helpDiv">
	<p>
		Now, image irradiance can be calculated from scene radiance. Optics (lenses) as above turn 
		radiance into irradiance, which is a measure of how much light gets onto an image sensor. 
		It can be explained as the light density incident on a plane.  
	</p>
	<p>
		The basic irradiance formula used in this calculation is:     
	</p>
	<p align="center">
		<img src="images/irradianceformula.png" title="Sourced from Professor Wandell's slides"></img>
	</p>
	<p>
		Where E is the calculated irradiance, T is transmittance, m is the magnification of the 
		lens, and L is the scene radiance.     
	</p>
	<p>
		Furthermore, most lenses will suffer from vignetting, or cos-4th fall-off. Essentially, 
		light in the corners of a lens will be less well-captured: 
	</p>
	<p align="center">
		<img src="images/vignetting.png" title="Sourced from Professor Wandell's slides"></img>
	</p>
	<p>
		And, as foreshadowed earlier, we will have spatial blurring from the lens, which will be 
		modeled with a diffraction-limited optics equation: 
	</p>
	<p align="center">
		<img src="images/diffraction.png" title="Sourced from Professor Wandell's slides" width="600px"></img>
	</p>
	<p>
		Real lenses in fact have many distortions (unfortunately) and are not diffraction-limited. 
		For example, you probably have seen fish-eye lenses, which are no longer rectilinear in their
		output, but instead have a strong hemispherical distortion. Lenses often have chromatic aberration, 
		in which different wavelengths of light impinge on different parts of the desired sensor target. 
		A few common examples are illustrated below: 
	</p>
	<p align="center">
		<img src="images/lensproblems.png" title="Sourced from Professor Wandell's slides"  width="600px"></img>
	</p>
	</div>
	
	<h3>Calculated Irradiance</h3>
	<p><h4 id="valueIrr">Value: </h4></p>
	<div id="chartIrr" style="height:400px;"></div>
</div>

<div id="opticsImage">
	<h3>Image from VSET's oi</h3>
	<div class="helpDiv">
	<p>
		Here's a representation of what the sensor will soon see, as given by VSET's 
		oi object. Play around with the filters to see bigger results; for example, 
		Filter 14 should give an astoundingly red image. 
	</p>
	</div>
	<p><h4>Image: </h4></p>
	<div id="optics_imageGoesHere"  width="700px"  align="center">
      <img id="photo" src="flower2.jpg" />
    </div>
    <button type="button" onclick="loadOpticsImage(1)">Reload data</button>
</div>


<div id="sensorImage">
	<h3>Absorption histogram for the human eye</h3>
	<div class="helpDiv">
	<p>
		Here's a basic sensor: the human eye! Actually, sadly/happily, the human eye is not really
		that basic; it's actually quite sophisticated. 
	</p>
	<p>
		As you can see in the chart, there are red bars, green bars, and blue bars. These are plotted 
		using a tutorial in VSET called s_HumanSensor, which constructs optics and sensors that correspond
		roughly to the human eye. The red, green, and blue bars correspond to L, M, and S cones in the eye. 
		These are absorption histograms corresponding to these cones, with a little dark current, 
		read noise, and some photon noise.   
	</p>
	<p align="center">
		<img src="images/retina.png" title="Sourced from Professor Wandell's slides" width="600px"></img>
	</p>
	<p>
		In the back of the human eye is the retina, which has a photoreceptor mosaic (as above) formed of L, M, and S cones, as 
		well as rods. Rods are used primarily for low-light (scotopic) vision, and have very little role in color vision. 
		However, L, M, and S cones are able to react to light of different frequency, thus forming the basis of color vision.
		Rods have the common pigment rhodopsin, while cones each have three different pigments and also sizes.   
	</p>
	<p>
		As the colors may have perhaps indicated, each cone type corresponds to a sensitivity to a particular wavelength of light:  
	</p>
	<p align="center">
		<img src="images/conesensitivity.png" title="Sourced from Professor Wandell's slides"></img>
	</p>
	<p>
		And thus, we build a histogram much as expected: 
	</p>
	</div>
	<p><h4>Chart: </h4></p>
	<div id="sensor_imageGoesHere"  width="700px"  align="center">
      <img id="photo" src="flower2.jpg" />
    </div>
    <button type="button" onclick="loadSensor(1)">Reload sensor data</button>
</div>

<script>
function sensorGet(t) {
	// t.disabled=true;
	var xmlhttp;
	var txt = $('#getSensorText').val();
	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
	  xmlhttp=new XMLHttpRequest();
	} else {// code for IE6, IE5
	  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange=function() {
		//console.log(xmlhttp.responseText);
	  if (xmlhttp.readyState==4 && xmlhttp.status==200) {
		//console.log(xmlhttp.responseText);
	    //$('#sensor_putGetData').innerhtml=xmlhttp.responseText;
	    document.getElementById("sensor_putGetData").innerHTML=xmlhttp.responseText;
	}
	}
	xmlhttp.open("GET","sensor_get.jsp?c="+txt,true);
	xmlhttp.send();
}; 
</script>

<div id="sensorGet">
	<h3>Get statistics from the sensor/optics/scene</h3>
	<div class="helpDiv">
	<p>
		Advanced users may wish to type in a VSET sensorGet/oiGet/sceneGet command in order to 
		find statistics on the respective objects that have been created in this tutorial.
		For example, you may try (no semicolon please!): 
	</p>
	<p>
		<code>sensorGet(sensor, 'name')</code>
		<code>sensorGet(sensor, 'type')</code>
		<code>sensorGet(sensor, 'height')</code>
		<code>sensorGet(sensor, 'volts') // for the adventurous!</code>
	</p>
	</div>
	<p><h4>Command:</h4></p>
	  <p><input type="text" id="getSensorText" style="width: 600px;" /></p>
	  <p><button type="button" onclick="sensorGet(this)">Submit request</button></p>
	<p><h4>Data:</h4></p>
	<div id="sensor_getData"  width: 700px; >
      <p id="sensor_putGetData"><code>awaiting input</code></p>
    </div>
    <%--<p><h4>Relevant chart: </h4></p>
	<div id="sensor_getDataChart"  width: 700px; ">
      <img id="photo" src="flower2.jpg" />
    </div>
    <button type="button" onclick="getSensor(1)">Get sensor data</button> --%>
</div>

<%--
<button type="button" onclick="loadXMLDoc()">Request data</button>
<div id="myDiv"></div>
--%>

<div id="credits">
	<h3>Credits</h3>
	<p>This project uses: </p>
	<ul>
		<li>Matlab/ISET-4.0, developed by ImagEval Consulting, provided by Professor Brian Wandell and Dr. Joyce Farrell; </li>
		<li>matlabcontrol, developed by Joshua Kaplan; </li>
		<li>jqPlot, developed by Chris Leonello; </li>
		<li>imgAreaSelect, developed by Michal Wojciechowski. </li>
	</ul>
	<p>Data credits: </p>
	<ul>
		<li>Nikon 55mm and filters data from <a href="http://www.graphics.cornell.edu/online/measurements/filter-spectra/index.html">NSF Graphics and Visualization Center</a></li>
		<li>Glass and CR-39 data from <a href="http://www.oculist.net/downaton502/prof/ebook/duanes/pages/v1/v1c051d.html">Ophthalmic Lens Tints and Coatings</a> by Gregory L. Stephens and John K. Davis</li> 
	</ul>
</div>		<!-- End credits div  -->
</div>		<!-- End post single div  -->
</div>		<!-- End container div  -->

</body>
</html>