import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class JuliaSet extends PApplet {

/*
 Name: Grace Zhang
 Date: 12/20/14
 Notes: 
 -To zoom in, hit 'z' or the right or up arrow keys. The fractal
 will recenter at your mouse position.
 -To zoom out, hit 'x' or the left or down arrow keys. The fractal
 will recenter at your mouse position.
 -mouseWheel can be used to zoom in and out (zoom recentering at
 your mouse position)
 -User can drag the fractal by its center around on the screen
 -Previous Fractals Button: Allows the user to cycle through 
 previous Julia Sets that he/she had generated
 -Uses ControlP5 to add textfields that allow the user to 
 enter the a complex number (its real & imaginary components)
 and generates a Julia Set from this complex number 
 (try-catch is used to catch parsing exceptions)
 -If no number is entered, the number is assumed to be zero
 -Uses ControlP5 to add textfields that allow the user to enter 
 the desired number of iterations
 -Uses ControlP5 to allow user to select different color schemes
 -Immediately shows effect (in the image of the fractal) when the
 number of iterations, complex number (for Julia Set), color scheme, 
 etc. is changed
 -Previously generated Julia Sets are saved as .png files in the folder named "juliasets"
 -Uses relative coordinates
 -Button colors invert when mouse hovers over them
 -Coordinates only print out when mouse is in the area of the fractal image
 */

ControlP5 cp5;
int fIter=50;//final number of iterations
int clickCount=0;//number of times clicked
PImage jBack;//juliaSet as background
float zoom=0.9f, zoomOut=1.1f;//zoom factor
float xZoom=4, yZoom=3;// x and y width of coordinate plane
float cX=0, cY=0;//center coordinates
int currentSet=0; //0-mandelbrot
int w=800;
int h=PApplet.parseInt(.6f*w);
int fWidth=PApplet.parseInt(w*.8f), fHeight=h;
int picNum=0;//for previous julia sets
//int gifCount=0;
ComplexNumber juliaNum=new ComplexNumber(0, 0);
Textfield tReal;
Textfield tImag;
Textfield tIter;
RadioButton rColors;
float jReal=0, jImag=0;
int rColorScheme=3;
float xOffset=0;
float yOffset=0;
boolean dragged=false;

public void setup() {
  //frame.setResizable(true);
  size(w, h);
  imageMode(CORNER);
  PImage mFractal=drawMand(fIter, fWidth, fHeight);
  image(mFractal, 0, 0);
  rectMode(CENTER);
  colorMode(RGB, 255);
  noStroke();
  fill(200);
  rect(fWidth+(width-fWidth)/2, height/2, width-fWidth, height);
  PFont font = createFont("arial", 20);
  cp5 = new ControlP5(this);
  tReal = cp5.addTextfield("Real Component")
    .setPosition(fWidth+(width-fWidth-(0.08f*width))/2, (3*height)/9)
      .setSize(PApplet.parseInt(0.08f*width), PApplet.parseInt((4*height)/75))
        .setFont(font)
          .setColor(color(255, 0, 0))
            .setColorLabel(color(0))
              .setAutoClear(false)
                .setText("0.00")
                  .setInputFilter(3)
                    ;
  tImag = cp5.addTextfield("Imaginary Component")
    .setPosition(fWidth+(width-fWidth-(0.08f*width))/2, (32*height)/75)
      .setSize(PApplet.parseInt(0.08f*width), PApplet.parseInt((4*height)/75))
        .setFont(font)
          .setColor(color(255, 0, 0))
            .setColorLabel(color(0))
              .setAutoClear(false)
                .setText("0.00")
                  .setInputFilter(2)
                    ;
  tIter = cp5.addTextfield("Number of Iterations")
    .setPosition(fWidth+(width-fWidth-(0.08f*width))/2, (48*height)/75)
      .setSize(PApplet.parseInt(0.08f*width), PApplet.parseInt((4*height)/75))
        .setFont(font)
          .setColor(color(255, 0, 0))
            .setColorLabel(color(0))
              .setAutoClear(false)
                .setText("50")
                  .setInputFilter(1)
                    ;
  rColors = cp5.addRadioButton("Color Scheme")
    .setPosition(fWidth+(width-fWidth-(0.08f*width))/2, (64*height)/75)
      .setSize(40, 20)
        .setColorActive(color(255))
          .setColorLabel(color(255))
            .setItemsPerRow(1)
              .setSpacingColumn(50)
                .setColorLabel(color(0))
                  .addItem("Grayscale", 1)
                    .addItem("Orangeish", 2)
                      .addItem("Colorful", 3)
                        ;
}

public void draw() {
  //saveFrame("test.png");
  if (width<1100) textSize(8);
  textAlign(CENTER, CENTER);
  colorMode(RGB, 255);
  rectMode(CORNER);
  noStroke();
  fill(204);
  rect(fWidth, 0, width-fWidth, height);
  rectMode(CENTER);
  noStroke();
  fill(204);
  fill(255);
  rect(fWidth+(width-fWidth)/2, (height*3)/30, width*0.16f, (height*2)/15);//previous fractals button
  fill(0);
  text("Previous Fractals", fWidth+(width-fWidth)/2, (height*3)/30);
  if (mouseX>((fWidth+(width-fWidth)/2)-(width*0.08f)) && mouseX<((fWidth+(width-fWidth)/2)+(width*0.08f)) && mouseY>(((height*3)/30)-((height*2)/30)) && mouseY<(((height*3)/30)+((height*2)/30))) {
    noStroke();
    fill(0);
    rect(fWidth+(width-fWidth)/2, (height*3)/30, PApplet.parseInt(width*0.16f), PApplet.parseInt((height*2)/15));
    fill(255);
    text("Previous Fractals", fWidth+(width-fWidth)/2, (height*3)/30);
  } 
  stroke(0);
  line(fWidth, (19*height)/75, width, (19*height)/75);

  noStroke();
  fill(204);
  rect(fWidth+(width-fWidth)/2, (0.184f*width)+(height-fHeight)/2, width-fWidth-1, height/15);//gray space
  fill(0);
  text("Complex Number to Generate Fractal\nReal & Imaginary Components:", fWidth+(width-fWidth)/2, (0.184f*width));
  fill(255);
  noStroke();
  rect(fWidth+(width-fWidth)/2, 0.54f*height, 0.08f*width, height/15);//enter button for complex number
  fill(0);
  text("Enter", fWidth+(width-fWidth)/2, 0.54f*height);
  if (mouseX>(fWidth+(width-fWidth)/2-0.04f*width) && mouseX<(fWidth+(width-fWidth)/2+0.04f*width) && mouseY>((0.54f*height)-height/30) && mouseY<((0.54f*height)+height/30)) {
    fill(0);
    rect(fWidth+(width-fWidth)/2, 0.54f*height, 0.08f*width, height/15);
    fill(255);
    text("Enter", fWidth+(width-fWidth)/2, 0.54f*height);
  }

  noStroke();
  fill(204);
  rect(fWidth+(width-fWidth)/2, (47*height)/75, width-fWidth-1, height/15);
  fill(0);
  text("Number of Iterations:", fWidth+(width-fWidth)/2, (47*height)/75);
  stroke(0);
  line(fWidth, 0.6f*height, width, 0.6f*height);
  fill(255);
  noStroke();
  rect(fWidth+(width-fWidth)/2, (113*height)/150, 0.08f*width, height/15);
  fill(0);
  text("Enter", fWidth+(width-fWidth)/2, (113*height)/150);
  if (mouseX>((fWidth+(width-fWidth)/2)-0.04f*width) && mouseX<((fWidth+(width-fWidth)/2)+0.04f*width) && mouseY>(((113*height)/150)-height/30) && mouseY<(((113*height)/150)+height/30)) {
    fill(0);
    rect(fWidth+(width-fWidth)/2, (113*height)/150, 0.08f*width, height/15);
    fill(255);
    text("Enter", fWidth+(width-fWidth)/2, (113*height)/150);
  }
  stroke(0);
  line(fWidth, (253*height)/300, width, (253*height)/300);
  if (mouseX<fWidth && mouseY<height) {//display coordinates
    noStroke();
    fill(204);
    rect(fWidth+(width-fWidth)/2, 6*height/30, width-fWidth-20, height/15);
    float xCoor=(mouseX/((float)fWidth/xZoom)+(cX-xZoom/2));
    float yCoor=(cY+yZoom/2)-(mouseY/((float)fHeight/yZoom));
    ComplexNumber display=new ComplexNumber(xCoor, yCoor);
    textAlign(CENTER, CENTER);
    fill(0);
    text("Coordinates: " + display, fWidth+(width-fWidth)/2, 6*height/30);
  }
  if (dragged) {
    redrawFractal();
  }
}

public void mouseClicked() {
  PImage prevFractal;
  if (mouseX<fWidth && mouseY<height) {//clicking the fractal screen
    if (clickCount%2==0) {//julia set
      currentSet=1;
      jReal=(mouseX/((float)fWidth/xZoom)+(cX-xZoom/2));
      jImag=(cY+yZoom/2)-(mouseY/((float)fHeight/yZoom));
      tReal.setText(nf(jReal, 0, 2));
      tImag.setText(nf(jImag, 0, 2));
      juliaNum=new ComplexNumber(jReal, jImag);
      PImage julia=drawJulia(fIter, fWidth, fHeight, juliaNum);
      jBack=julia.get(fWidth/8-90, fHeight/8-15, 180, 30);
      imageMode(CORNER);
      image(julia, 0, 0);
      julia.save("juliasets/fractals"+clickCount+".png");
    } else {//mandelbrot set
      currentSet=0;
      imageMode(CORNER);
      PImage mFractal=drawMand(fIter, fWidth, fHeight);
      image(mFractal, 0, 0);
    }
    clickCount++;
  }
  if (mouseX>((fWidth+(width-fWidth)/2)-(width*0.08f)) && mouseX<((fWidth+(width-fWidth)/2)+(width*0.08f)) && mouseY>(((height*2)/15)-((height*2)/30)) && mouseY<(((height*2)/15)+((height*2)/30))) {//previous fractal
    if (clickCount>0) {
      if (picNum>=clickCount) picNum=0;
      prevFractal=loadImage("juliasets/fractals"+picNum+".png");
      imageMode(CENTER);
      image(prevFractal, fWidth/2, fHeight/2);
      picNum+=2;
      if (clickCount%2==0) clickCount--;
    }
  }
  if (mouseX>(fWidth+(width-fWidth)/2-0.04f*width) && mouseX<(fWidth+(width-fWidth)/2+0.04f*width) && mouseY>((0.54f*height)-height/30) && mouseY<((0.54f*height)+height/30)) {//Enter button for complex number to generate a julia set
    if (clickCount%2!=0) clickCount++;
    float realC=0;
    float imagC=0;
    String realText=null;
    String imagText=null;
    realText=tReal.getText();
    imagText=tImag.getText();
    if (realText.length()>0 && realText!=null) {
      try {
        realC=Float.parseFloat(realText);
      } 
      catch (Exception e) {
        tReal.setText(nf(realC, 0, 2));
      }
    } else {
      realC=0;
      tReal.setText(nf(realC, 0, 2));
    }
    if (imagText.length()>0 && imagText!=null) {
      try {
        imagC=Float.parseFloat(imagText);
      } 
      catch (Exception e) {
        tImag.setText(nf(imagC, 0, 2));
      }
    } else {
      imagC=0;
      tImag.setText(nf(imagC, 0, 2));
    }
    currentSet=1;
    juliaNum=new ComplexNumber(realC, imagC);
    PImage julia=drawJulia(fIter, fWidth, fHeight, juliaNum);
    jBack=julia.get(fWidth/8-90, fHeight/8-15, 180, 30);
    imageMode(CORNER);
    image(julia, 0, 0);
    julia.save("juliasets/fractals"+clickCount+".png");
    clickCount+=2;
    if (clickCount%2==0) clickCount--;
  }
  if (mouseX>((fWidth+(width-fWidth)/2)-0.04f*width) && mouseX<((fWidth+(width-fWidth)/2)+0.04f*width) && mouseY>(((113*height)/150)-height/30) && mouseY<(((113*height)/150)+height/30)) {//Enter button for # of iterations
    String iterText=null;
    iterText=cp5.get(Textfield.class, "Number of Iterations").getText();
    if (iterText.length()>0 && iterText!=null) {
      fIter=Integer.parseInt(iterText);
      PImage iterPic;
      if (clickCount%2==1) iterPic=drawJuliaZoomed(fIter, fWidth, fHeight, juliaNum, cX, cY, 1);
      else iterPic=drawMandelbrotZoomed(fIter, fWidth, fHeight, cX, cY, 1);
      imageMode(CORNER);
      image(iterPic, 0, 0);
    }
  }
}

public void keyReleased() {
  if (mouseX<fWidth && mouseY<height) {
    if (key == 'z' || key == 'Z' || keyCode==RIGHT || keyCode==UP) {
      zoomInMethod();
    } else if (key == 'x' || key == 'X' || keyCode==LEFT || keyCode==DOWN) {
      zoomOutMethod();
    }
  }
}

public void mousePressed() {
  if (mouseX<fWidth && mouseY<height) {
    xOffset = (mouseX/((float)fWidth/xZoom)+(cX-xZoom/2))-cX;
    yOffset = (cY+yZoom/2)-(mouseY/((float)fHeight/yZoom))-cY;
  }
}

public void mouseWheel(MouseEvent event) {
  if (mouseX<fWidth && mouseY<height) {
    float e = event.getCount();
    if (e<0) {
      zoomInMethod();
    } else if (e>0) {
      zoomOutMethod();
    }
  }
}

public void mouseDragged() {
  if (mouseX<fWidth && mouseY<height) {
    dragged=true;
  }
}

public void mouseReleased() {
  dragged=false;
}

public int mandelbrot(ComplexNumber prev, ComplexNumber orig, int iter, int maxI) {
  ComplexNumber next=orig.add(prev.square());
  if (iter>=maxI) return maxI;
  else {
    if (next.magnitude()>=2) {
      return iter+1;
    } else {
      return mandelbrot(next, orig, iter+1, maxI);
    }
  }
}

public PImage drawMand(int iter, int mWidth, int mHeight) {
  cX=0;
  cY=0;
  xZoom=4;
  yZoom=3;
  ComplexNumber zero=new ComplexNumber(0, 0);
  PImage mandelb=createImage(mWidth, mHeight, ARGB);
  colorMode(HSB, iter);
  mandelb.loadPixels();
  for (int h=0; h<mandelb.height; h++) {
    for (int w=0; w<mandelb.width; w++) {
      ComplexNumber a=new ComplexNumber(w/(float)(mandelb.width/4)-2, 1.5f-(h/(float)(mandelb.height/3)));
      if (mandelbrot(zero, a, 0, iter)==iter) mandelb.pixels[h*mandelb.width+w]=color(0);
      else {
        if (rColorScheme==3 || rColorScheme==-1) mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(zero, a, 0, iter)%15, 0, 15, 0, iter), iter*.75f, iter);
        else if (rColorScheme==2) mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(zero, a, 0, iter), iter*.75f, iter);
        else mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(zero, a, 0, iter)%15, 0, 15, 0, iter));
      }
    }
  }
  mandelb.updatePixels();
  return mandelb;
}

public PImage drawJulia(int iter, int mWidth, int mHeight, ComplexNumber c) {
  cX=0;
  cY=0;
  xZoom=4;
  yZoom=3;
  PImage mandelb=createImage(mWidth, mHeight, ARGB);
  colorMode(HSB, iter);
  mandelb.loadPixels();
  for (int h=0; h<mandelb.height; h++) {
    for (int w=0; w<mandelb.width; w++) {
      ComplexNumber a=new ComplexNumber(w/(float)(mandelb.width/4)-2, 1.5f-(h/(float)(mandelb.height/3)));
      if (mandelbrot(a, c, 0, iter)==iter)mandelb.pixels[h*mandelb.width+w]=color(0);
      else {
        if (rColorScheme==3 || rColorScheme==-1) mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(a, c, 0, iter)%15, 0, 15, 0, iter), iter*.75f, iter);
        else if (rColorScheme==2) mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(a, c, 0, iter), iter*.75f, iter);
        else mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(a, c, 0, iter)%15, 0, 15, 0, iter));
      }
    }
  }
  mandelb.updatePixels();
  return mandelb;
}

public PImage drawMandelbrotZoomed(int iter, int mWidth, int mHeight, float x1, float y1, float zoom1) {
  xZoom*=zoom1;
  yZoom*=zoom1;
  ComplexNumber zero=new ComplexNumber(0, 0);
  PImage mandelb=createImage(mWidth, mHeight, ARGB);
  colorMode(HSB, iter);
  mandelb.loadPixels();
  for (int h=0; h<mandelb.height; h++) {
    for (int w=0; w<mandelb.width; w++) {
      ComplexNumber a=new ComplexNumber(w/(float)(mandelb.width/xZoom)+(x1-xZoom/2), (y1+yZoom/2)-(h/(float)(mandelb.height/yZoom)));
      if (mandelbrot(zero, a, 0, iter)==iter) mandelb.pixels[h*mandelb.width+w]=color(0);
      else {
        if (rColorScheme==3 || rColorScheme==-1) mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(zero, a, 0, iter)%15, 0, 15, 0, iter), iter*.75f, iter);
        else if (rColorScheme==2) mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(zero, a, 0, iter), iter*.75f, iter);
        else mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(zero, a, 0, iter)%15, 0, 15, 0, iter));
      }
    }
  }
  mandelb.updatePixels();
  return mandelb;
}

public PImage drawJuliaZoomed(int iter, int mWidth, int mHeight, ComplexNumber c, float x1, float y1, float zoom1) {
  xZoom*=zoom1;
  yZoom*=zoom1;
  PImage mandelb=createImage(mWidth, mHeight, ARGB);
  colorMode(HSB, iter);
  mandelb.loadPixels();
  for (int h=0; h<mandelb.height; h++) {
    for (int w=0; w<mandelb.width; w++) {
      ComplexNumber a=new ComplexNumber(w/(float)(mandelb.width/xZoom)+(x1-xZoom/2), (y1+yZoom/2)-(h/(float)(mandelb.height/yZoom)));
      if (mandelbrot(a, c, 0, iter)==iter)mandelb.pixels[h*mandelb.width+w]=color(0);
      else {
        if (rColorScheme==3 || rColorScheme==-1) mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(a, c, 0, iter)%15, 0, 15, 0, iter), iter*.75f, iter);
        else if (rColorScheme==2) mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(a, c, 0, iter), iter*.75f, iter);
        else mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(a, c, 0, iter)%15, 0, 15, 0, iter));
      }
    }
  }
  mandelb.updatePixels();
  return mandelb;
}

public void zoomInMethod() {
  PImage zoomed;
  cX=(mouseX/((float)fWidth/xZoom)+(cX-xZoom/2));
  cY=(cY+yZoom/2)-(mouseY/((float)fHeight/yZoom));
  if (clickCount%2==1) {
    zoomed=drawJuliaZoomed(fIter, fWidth, fHeight, juliaNum, cX, cY, zoom);
    //zoomed.save("fractal"+gifCount+".gif");
    //gifCount++;
  } else zoomed=drawMandelbrotZoomed(fIter, fWidth, fHeight, cX, cY, zoom);
  imageMode(CORNER);
  image(zoomed, 0, 0);
}

public void zoomOutMethod() {
  PImage zoomed;
  cX=(mouseX/((float)fWidth/xZoom)+(cX-xZoom/2));
  cY=(cY+yZoom/2)-(mouseY/((float)fHeight/yZoom));
  if (clickCount%2==1) zoomed=drawJuliaZoomed(fIter, fWidth, fHeight, juliaNum, cX, cY, zoomOut); 
  else zoomed=drawMandelbrotZoomed(fIter, fWidth, fHeight, cX, cY, zoomOut);
  imageMode(CORNER);
  image(zoomed, 0, 0);
}

public void redrawFractal() {
  PImage zoomed;
  cX-=(mouseX/((float)fWidth/xZoom)+(cX-xZoom/2));
  cY-=(cY+yZoom/2)-(mouseY/((float)fHeight/yZoom));
  if (clickCount%2==1) zoomed=drawJuliaZoomed(fIter, fWidth, fHeight, juliaNum, cX, cY, 1); 
  else zoomed=drawMandelbrotZoomed(fIter, fWidth, fHeight, cX, cY, 1);
  imageMode(CORNER);
  image(zoomed, 0, 0);
}

public void clear() {
  cp5.get(Textfield.class, "textValue").clear();
}

public void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(rColors)) {
    rColorScheme = PApplet.parseInt(theEvent.group().value());
    PImage colorPic;
    if (clickCount%2==1) colorPic=drawJuliaZoomed(fIter, fWidth, fHeight, juliaNum, cX, cY, 1);
    else colorPic=drawMandelbrotZoomed(fIter, fWidth, fHeight, cX, cY, 1);
    imageMode(CORNER);
    image(colorPic, 0, 0);
  }
}

/**
 * <h1>ComplexNumber class</h1>
 * The ComplexNumber class allows the use of complex numbers
 * @author Grace Zhang
 * @version 1.0
 * @since 2014-12-20
 *
 */

public class ComplexNumber {// implements Comparable<ComplexNumber>

  private float a, b;
  /**
   * Default constructor - Creates a new ComplexNumber 2 + 3i
   */
  public ComplexNumber() {
    a = 2;
    b = 3;
  }

  /**
   * "Regular" constructor - Creates a new ComplexNumber a1+b1i
   * @param a1 This is the real component of the ComplexNumber
   * @param b1 This is the imaginary component of the ComplexNumber
   */
  public ComplexNumber(float a1, float b1) {
    a = a1;
    b = b1;
  }

  /**
   * The "copy constructor"
   * @param cN1 This is a ComplexNumber that gets copied
   */
  public ComplexNumber(ComplexNumber cN1) {
    a = cN1.getReal();
    b = cN1.getImag();
  }

  /**
   * An "accessor" method that returns the real component of this ComplexNumber
   * @return a The real component of this ComplexNumber
   */
  public float getReal() {
    return a;
  }

  /**
   * An "accessor" method that returns the imaginary component of this ComplexNumber
   * @return a The imaginary component of this ComplexNumber
   */
  public float getImag() {
    return b;
  }

  /**
   * This method allows the ComplexNumber to be written nicely as a String
   */
  public String toString() {
    String result = "";
    if (a == 0) {
      if (b < 0) {
        if (b==-1) result= "-i";
        else result = nfc(b, 2) + "i";
      } else if (b == 0) {
        result = "0.0";
      } else {
        if (b==1) result= "i";
        else result = nfc(b, 2) + "i";
      }
    } else {
      if (b < 0) {
        if (b==-1) result = nfc(a, 2) + " - "+ "i";
        else result = nfc(a, 2) + " - " + nfc(Math.abs(b), 2) + "i";
      } else if (b == 0) {
        result = nfc(a, 2) + "";
      } else {
        if (b==1) result= nfc(a, 2) + " + " + "i";
        else result = nfc(a, 2) + " + " + nfc(b, 2) + "i";
      }
    }
    return result;
  }

  /**
   * This method adds two ComplexNumbers
   * @param c This is the ComplexNumber to be added to the original ComplexNumber
   * @return d The sum of the two ComplexNumbers
   */
  public ComplexNumber add (ComplexNumber c) {
    float cReal=a+c.getReal();
    float cImag=b+c.getImag();
    ComplexNumber d=new ComplexNumber(cReal, cImag);
    return d;
  }

  /**
   * This method subtracts two ComplexNumbers
   * @param c This is the ComplexNumber to be subtracted from the original ComplexNumber
   * @return d This is the difference between the two ComplexNumbers
   */
  public ComplexNumber subtract (ComplexNumber c) {
    float cReal=a-c.getReal();
    float cImag=b-c.getImag();
    ComplexNumber d=new ComplexNumber(cReal, cImag);
    return d;
  }

  /**
   * This method multiplies two ComplexNumbers
   * @param c This is the ComplexNumber to be multiplied by the original ComplexNumber
   * @return d This is the product of the two ComplexNumbers
   */
  public ComplexNumber multiply (ComplexNumber c) {
    float cReal=a*c.getReal()+(-1*b*c.getImag());
    float cImag=a*c.getImag()+(b*c.getReal());
    ComplexNumber d=new ComplexNumber(cReal, cImag);
    return d;
  }

  /**
   * This method divides two ComplexNumbers
   * @param c This is the ComplexNumber that the original ComplexNumber is divided by
   * @return d This is the quotient of the two ComplexNumbers
   */
  public ComplexNumber divide (ComplexNumber c) {
    if ((c.getReal()+c.getImag())==0) {
      throw new ArithmeticException("Cannot Divide By Zero");
    }
    float denom=(c.getReal()*c.getReal())+(c.getImag()*c.getImag());
    float numReal=a*c.getReal()+(b*c.getImag());
    float numImag=-1*a*c.getImag()+(b*c.getReal());
    float cReal=numReal/denom;
    float cImag=numImag/denom;
    ComplexNumber d=new ComplexNumber(cReal, cImag);
    return d;
  }

  /**
   * This method raises a ComplexNumber to a power
   * @param exp This is the exponent the ComplexNumber should be raised to
   * @return d This is the ComplexNumber that is returned when the ComplexNumber is raised to a powere
   */
  public ComplexNumber power(int exp) {
    if (exp<0) throw new IllegalArgumentException("Exponent Cannot Be Negative");
    ComplexNumber d=new ComplexNumber(1, 0);
    ComplexNumber c=new ComplexNumber(a, b);
    for (int i=0; i<exp; i++) {
      d=d.multiply(c);
    }
    return d;
  }

  /**
   * This method squares this ComplexNumber
   * @return d The square of this ComplexNumber
   */
  public ComplexNumber square() {
    float cReal=a*a-b*b;
    float cImag=2*a*b;
    ComplexNumber d=new ComplexNumber(cReal, cImag);
    return d;
  }

  /**
   * This method returns the conjugate of a ComplexNumber
   * @return d This is the conjugate of the original ComplexNumber
   */
  public ComplexNumber conjugate() {
    ComplexNumber d=new ComplexNumber(a, -1*b);
    return d;
  }

  /**
   * This method checks if two ComplexNumbers are equal
   * @param c This is the ComplexNumber the original ComplexNumber should be checked against
   * @return boolean Returns whether the two ComplexNumbers are equal
   */
  public boolean equals(Object c) {
    ComplexNumber that=(ComplexNumber)(c);
    if (a!=that.getReal())return false;
    if (b!=that.getImag())return false;
    return true;
  }

  /**
   * This method returns the magnitude of a ComplexNumber
   * @return d The magnitude of this ComplexNumber
   */
  public float magnitude() {
    float d=(float)Math.sqrt(a*a+b*b);
    return d;
  }

  /**
   * This method compares the magnitude of two ComplexNumbers
   * @param c This is the ComplexNumber that the original ComplexNumber will be compared to
   * @return float This returns 0.0 if the two ComplexNumbers are equal, -1.0 if the original ComplexNumber is less than the ComplexNumber c, and 1.0 if the original ComplexNumber is greater than the ComplexNumber c
   */
  public float compareTo(Object c) {
    ComplexNumber that=(ComplexNumber)(c);
    float mag=(float)Math.sqrt(a*a+b*b);
    if (mag==that.magnitude()) return 0;
    if (mag>=that.magnitude()) return 1;
    else return -1;
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "JuliaSet" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
