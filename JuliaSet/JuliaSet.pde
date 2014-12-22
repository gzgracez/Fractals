/*
 Name: Grace Zhang
 Date: 12/20/14
 Notes: 
 -Previous Fractals Button: Allows the user to cycle through previous Julia Sets that he/she had generated
 -Uses ControlP5 to add textfields that allow the user to enter the a complex number (its real & imaginary components)
 and generates a Julia Set from this complex number
   -The textfield is restricted so that the user can only enter floats
   -If no number is entered, the number is assumed to be zero
 -Uses ControlP5 to add textfields that allow the user to enter the desired number of iterations
   -Immediately shows effect (in the image of the fractal) when number of iterations is changed
 -Previously generated Julia Sets are saved as .png files in the folder named "juliasets"
 -Button colors invert when mouse hovers over them
 -Coordinates only print out when mouse is in the area of the fractal image
 */
import controlP5.*;
ControlP5 cp5;
int fIter=50;//final number of iterations
int clickCount=0;//number of times clicked
PImage jBack;//juliaSet as background
float zoom=0.9;//zoom factor
float zoomOut=1.1;//zoom factor
float xZoom=4;//x width of coordinate plane
float yZoom=3;// y width of coordinate plane
float cX=0, cY=0;//center coordinates
int currentSet=0; //0-mandelbrot
int fWidth=1000;
int fHeight=750;
int picNum=0;//for previous julia sets
//int gifCount=0;
ComplexNumber juliaNum=new ComplexNumber(0, 0);

void setup() {
  size(1250, 750);
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
  cp5.addTextfield("Real Component")
    .setPosition(fWidth+(width-fWidth-100)/2, 250)
      .setSize(100, 40)
        .setFont(font)
          .setFocus(true)
            .setColor(color(255, 0, 0))
              .setAutoClear(false)
                .setText("0")
                  .setInputFilter(2)
                    ;
  cp5.addTextfield("Imaginary Component")
    .setPosition(fWidth+(width-fWidth-100)/2, 320)
      .setSize(100, 40)
        .setFont(font)
          .setColor(color(255, 0, 0))
            .setAutoClear(false)
              .setText("0")
                .setInputFilter(2)
                  ;
  cp5.addTextfield("Number of Iterations:")
    .setPosition(fWidth+(width-fWidth-100)/2, 480)
      .setSize(100, 40)
        .setFont(font)
          .setColor(color(255, 0, 0))
            .setAutoClear(false)
              .setText("50")
                .setInputFilter(1)
                  ;
}

void draw() {
  colorMode(RGB, 255);
  rectMode(CENTER);
  noStroke();
  fill(255);
  rect(fWidth+(width-fWidth)/2, 100, 200, 100);//previous fractals button
  fill(0);
  text("Previous Fractals", fWidth+(width-fWidth)/2, 100);
  if (mouseX>1025 && mouseX<1225 && mouseY>50 && mouseY<150) {
    noStroke();
    fill(0);
    rect(fWidth+(width-fWidth)/2, 100, 200, 100);
    fill(255);
    text("Previous Fractals", fWidth+(width-fWidth)/2, 100);
  } 
  stroke(0);
  line(fWidth, 190, width, 190);
  
  noStroke();
  fill(200);
  rect(fWidth+(width-fWidth)/2, 230+(height-fHeight)/2, width-fWidth-1, 50);
  fill(0);
  text("Complex Number to Generate Fractal\nReal & Imaginary Components:", fWidth+(width-fWidth)/2, 230);
  fill(255);
  noStroke();
  rect(fWidth+(width-fWidth)/2, 405, 100, 50);
  fill(0);
  text("Enter", fWidth+(width-fWidth)/2, 405);
  if (mouseX>1075 && mouseX<1175 && mouseY>380 && mouseY<430) {
    fill(0);
    rect(fWidth+(width-fWidth)/2, 405, 100, 50);
    fill(255);
    text("Enter", fWidth+(width-fWidth)/2, 405);
  }
  
  noStroke();
  fill(200);
  rect(fWidth+(width-fWidth)/2, 470, width-fWidth-1, 50);
  fill(0);
  text("Number of Iterations:", fWidth+(width-fWidth)/2, 470);
  stroke(0);
  line(fWidth, 450, width, 450);
  fill(255);
  noStroke();
  rect(fWidth+(width-fWidth)/2, 565, 100, 50);
  fill(0);
  text("Enter", fWidth+(width-fWidth)/2, 565);
  if (mouseX>1075 && mouseX<1175 && mouseY>540 && mouseY<590) {
    fill(0);
    rect(fWidth+(width-fWidth)/2, 565, 100, 50);
    fill(255);
    text("Enter", fWidth+(width-fWidth)/2, 565);
  }
  stroke(0);
  line(fWidth, 632.5, width, 632.5);
  if (mouseX<1000 && mouseY<750) {//display coordinates
    noStroke();
    fill(200);
    rect(fWidth+(width-fWidth)/2, 9*height/10, width-fWidth-20, 50);
    float xCoor=(mouseX/((float)fWidth/xZoom)+(cX-xZoom/2));
    float yCoor=(cY+yZoom/2)-(mouseY/((float)fHeight/yZoom));
    ComplexNumber display=new ComplexNumber(xCoor, yCoor);
    textAlign(CENTER, CENTER);
    fill(0);
    text("Coordinates: " + display, fWidth+(width-fWidth)/2, 9*height/10);
  }
}

void mouseClicked() {
  PImage prevFractal;
  if (mouseX<1000 && mouseY<750) {//clicking the fractal screen
    if (clickCount%2==0) {//julia set
      currentSet=1;
      cX=0;
      cY=0;
      xZoom=4;
      yZoom=3;
      float xCoor=(mouseX/((float)fWidth/4)-2);
      float yCoor=-1*(mouseY/((float)fHeight/3)-1.5);
      juliaNum=new ComplexNumber(xCoor, yCoor);
      PImage julia=drawJulia(fIter, fWidth, fHeight, juliaNum);
      jBack=julia.get(fWidth/8-90, fHeight/8-15, 180, 30);
      imageMode(CORNER);
      image(julia, 0, 0);
      julia.save("juliasets/fractals"+clickCount+".png");
    } else {//mandelbrot set
      currentSet=0;
      cX=0;
      cY=0;
      xZoom=4;
      yZoom=3;
      imageMode(CORNER);
      PImage mFractal=drawMand(fIter, fWidth, fHeight);
      image(mFractal, 0, 0);
    }
    clickCount++;
  }
  if (mouseX>1025 && mouseX<1225 && mouseY>50 && mouseY<150) {//previous fractal
    if (clickCount>0) {
      if (picNum>=clickCount) picNum=0;
      prevFractal=loadImage("juliasets/fractals"+picNum+".png");
      imageMode(CENTER);
      image(prevFractal, fWidth/2, fHeight/2);
      picNum+=2;
      if (clickCount%2==0) clickCount--;
    }
  }
  if (mouseX>1075 && mouseX<1175 && mouseY>380 && mouseY<430) {//Enter button for complex number to generate a julia set
    if (clickCount%2!=0) clickCount++;
    float realC=0;
    float imagC=0;
    String realText=null;
    String imagText=null;
    realText=cp5.get(Textfield.class, "Real Component").getText();
    imagText=cp5.get(Textfield.class, "Imaginary Component").getText();
    if (realText.length()>0 && realText!=null) realC=Float.parseFloat(realText);
    else realC=0;
    if (imagText.length()>0 && imagText!=null) imagC=Float.parseFloat(imagText);
    else imagC=0;
    currentSet=1;
    cX=0;
    cY=0;
    xZoom=4;
    yZoom=3;
    juliaNum=new ComplexNumber(realC, imagC);
    PImage julia=drawJulia(fIter, fWidth, fHeight, juliaNum);
    jBack=julia.get(fWidth/8-90, fHeight/8-15, 180, 30);
    imageMode(CORNER);
    image(julia, 0, 0);
    julia.save("juliasets/fractals"+clickCount+".png");
    clickCount+=2;
    if (clickCount%2==0) clickCount--;
  }
  if (mouseX>1075 && mouseX<1175 && mouseY>540 && mouseY<590) {//Enter button for # of iterations
    String iterText=null;
    iterText=cp5.get(Textfield.class, "Number of Iterations:").getText();
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

void keyReleased() {
  PImage zoomed;
  if (key == 'z' || key == 'Z' || keyCode==RIGHT || keyCode==UP) {
    cX=(mouseX/((float)fWidth/xZoom)+(cX-xZoom/2));
    cY=(cY+yZoom/2)-(mouseY/((float)fHeight/yZoom));
    if (clickCount%2==1) {
      zoomed=drawJuliaZoomed(fIter, fWidth, fHeight, juliaNum, cX, cY, zoom);
      //saveFrame("fractals"+gifCount+".gif");
      //gifCount++;
    } else zoomed=drawMandelbrotZoomed(fIter, fWidth, fHeight, cX, cY, zoom);
    imageMode(CORNER);
    image(zoomed, 0, 0);
  } else if (key == 'x' || key == 'X' || keyCode==LEFT || keyCode==DOWN) {
    cX=(mouseX/((float)fWidth/xZoom)+(cX-xZoom/2));
    cY=(cY+yZoom/2)-(mouseY/((float)fHeight/yZoom));
    if (clickCount%2==1) zoomed=drawJuliaZoomed(fIter, fWidth, fHeight, juliaNum, cX, cY, zoomOut); 
    else zoomed=drawMandelbrotZoomed(fIter, fWidth, fHeight, cX, cY, zoomOut);
    imageMode(CORNER);
    image(zoomed, 0, 0);
  }
}

int mandelbrot(ComplexNumber prev, ComplexNumber orig, int iter, int maxI) {
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

PImage drawMand(int iter, int mWidth, int mHeight) {
  ComplexNumber zero=new ComplexNumber(0, 0);
  PImage mandelb=createImage(mWidth, mHeight, ARGB);
  colorMode(HSB, iter);
  mandelb.loadPixels();
  for (int h=0; h<mandelb.height; h++) {
    for (int w=0; w<mandelb.width; w++) {
      ComplexNumber a=new ComplexNumber(w/(float)(mandelb.width/4)-2, 1.5-(h/(float)(mandelb.height/3)));
      mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(zero, a, 0, iter), iter*.75, iter);
    }
  }
  mandelb.updatePixels();
  return mandelb;
}

PImage drawJulia(int iter, int mWidth, int mHeight, ComplexNumber c) {
  PImage mandelb=createImage(mWidth, mHeight, ARGB);
  colorMode(HSB, iter);
  mandelb.loadPixels();
  for (int h=0; h<mandelb.height; h++) {
    for (int w=0; w<mandelb.width; w++) {
      ComplexNumber a=new ComplexNumber(w/(float)(mandelb.width/4)-2, 1.5-(h/(float)(mandelb.height/3)));
      mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(a, c, 0, iter), iter*.75, iter);
    }
  }
  mandelb.updatePixels();
  return mandelb;
}

PImage drawMandelbrotZoomed(int iter, int mWidth, int mHeight, float x1, float y1, float zoom1) {
  xZoom*=zoom1;
  yZoom*=zoom1;
  ComplexNumber zero=new ComplexNumber(0, 0);
  PImage mandelb=createImage(mWidth, mHeight, ARGB);
  colorMode(HSB, iter);
  mandelb.loadPixels();
  for (int h=0; h<mandelb.height; h++) {
    for (int w=0; w<mandelb.width; w++) {
      ComplexNumber a=new ComplexNumber(w/(float)(mandelb.width/xZoom)+(x1-xZoom/2), (y1+yZoom/2)-(h/(float)(mandelb.height/yZoom)));
      mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(zero, a, 0, iter), iter*.75, iter);
    }
  }
  mandelb.updatePixels();
  return mandelb;
}

PImage drawJuliaZoomed(int iter, int mWidth, int mHeight, ComplexNumber c, float x1, float y1, float zoom1) {
  xZoom*=zoom1;
  yZoom*=zoom1;
  PImage mandelb=createImage(mWidth, mHeight, ARGB);
  colorMode(HSB, iter);
  mandelb.loadPixels();
  for (int h=0; h<mandelb.height; h++) {
    for (int w=0; w<mandelb.width; w++) {
      ComplexNumber a=new ComplexNumber(w/(float)(mandelb.width/xZoom)+(x1-xZoom/2), (y1+yZoom/2)-(h/(float)(mandelb.height/yZoom)));
      mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(a, c, 0, iter), iter*.75, iter);
    }
  }
  mandelb.updatePixels();
  return mandelb;
}

public void clear() {
  cp5.get(Textfield.class, "textValue").clear();
}

/*void controlEvent(ControlEvent theEvent) {
 if (theEvent.isAssignableFrom(Textfield.class)) {
 println("controlEvent: accessing a string from controller '"
 +theEvent.getName()+"': "
 +theEvent.getStringValue()
 );
 }
 }*/
