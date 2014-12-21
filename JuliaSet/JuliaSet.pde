/*
 Name: Grace Zhang
 Date: 12/20/14
 Notes:
 */

int fIter=100;//final number of iterations
int clickCount=0;//number of times clicked
PImage jBack;//juliaSet as background
float zoom=0.9;//zoom factor
float zoomOut=1.1;//zoom factor
float xZoom=4;//x width of coordinate plane
float yZoom=3;// y width of coordinate plane
float cX=0, cY=0;//center coordinates
int currentSet=0; //0-mandelbrot
//int gifCount=0;
ComplexNumber juliaNum=new ComplexNumber(0, 0);

void setup() {
  size(1200, 900);
  imageMode(CORNER);
  PImage mFractal=drawMand(fIter, width, height);
  image(mFractal, 0, 0);
}

void draw() {
  //PImage back=drawMand(fIter, width, height).get(width/8-90, height/8-15, 180, 30);
  colorMode(RGB, 255);
  rectMode(CENTER);
  fill(255);
  noStroke();
  rect(width/8, height/8, 180, 30);
  //  imageMode(CENTER);
  //  if (clickCount%2==0)image(back, width/8, height/8);
  //  else image(jBack, width/8, height/8);
  fill(0);
  stroke(0);
  float xCoor=(mouseX/((float)width/xZoom)+(cX-xZoom/2));
  float yCoor=(cY+yZoom/2)-(mouseY/((float)height/yZoom));
  ComplexNumber display=new ComplexNumber(xCoor, yCoor);
  textAlign(CENTER, CENTER);
  text("Coordinates: " + display, width/8, height/8);
}

void mouseClicked() {
  clickCount++;
  if (clickCount%2==1) {//julia set
    currentSet=1;
    cX=0;
    cY=0;
    xZoom=4;
    yZoom=3;
    float xCoor=(mouseX/((float)width/4)-2);
    float yCoor=-1*(mouseY/((float)height/3)-1.5);
    juliaNum=new ComplexNumber(xCoor, yCoor);
    PImage julia=drawJulia(fIter, width, height, juliaNum);
    jBack=julia.get(width/8-90, height/8-15, 180, 30);
    imageMode(CORNER);
    image(julia, 0, 0);
  } else {//mandelbrot set
    currentSet=0;
    cX=0;
    cY=0;
    xZoom=4;
    yZoom=3;
    imageMode(CORNER);
    PImage mFractal=drawMand(fIter, width, height);
    image(mFractal, 0, 0);
  }
}

void keyReleased() {
  PImage zoomed;
  if (key == 'z' || key == 'Z' || keyCode==RIGHT || keyCode==UP) {
    cX=(mouseX/((float)width/xZoom)+(cX-xZoom/2));
    cY=(cY+yZoom/2)-(mouseY/((float)height/yZoom));
    if (clickCount%2==1) {
      zoomed=drawJuliaZoomed(fIter, width, height, juliaNum, cX, cY, zoom);
      //saveFrame("fractals"+gifCount+".gif");
      //gifCount++;
    } else zoomed=drawMandelbrotZoomed(fIter, width, height, cX, cY, zoom);
    imageMode(CORNER);
    image(zoomed, 0, 0);
  } else if (key == 'x' || key == 'X' || keyCode==LEFT || keyCode==DOWN) {
    cX=(mouseX/((float)width/xZoom)+(cX-xZoom/2));
    cY=(cY+yZoom/2)-(mouseY/((float)height/yZoom));
    if (clickCount%2==1) zoomed=drawJuliaZoomed(fIter, width, height, juliaNum, cX, cY, zoomOut); 
    else zoomed=drawMandelbrotZoomed(fIter, width, height, cX, cY, zoom);
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
  println(xZoom);
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
  println(xZoom);
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
