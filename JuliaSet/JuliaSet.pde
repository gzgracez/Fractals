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
}

void draw() {
  //PImage back=drawMand(fIter, width, height).get(width/8-90, height/8-15, 180, 30);
  colorMode(RGB, 255);
  rectMode(CENTER);
  fill(255);
  noStroke();
  rect(fWidth/8, fHeight/8, 180, 30);
  //  imageMode(CENTER);
  //  if (clickCount%2==0)image(back, width/8, height/8);
  //  else image(jBack, width/8, height/8);
  fill(0);
  stroke(0);
  float xCoor=(mouseX/((float)fWidth/xZoom)+(cX-xZoom/2));
  float yCoor=(cY+yZoom/2)-(mouseY/((float)fHeight/yZoom));
  ComplexNumber display=new ComplexNumber(xCoor, yCoor);
  textAlign(CENTER, CENTER);
  text("Coordinates: " + display, fWidth/8, fHeight/8);
  fill(255);
  noStroke();
  rect(fWidth+(width-fWidth)/2, 100+(height-fHeight)/2, 200, 100);
  fill(0);
  text("Previous Fractals", 1125, 100);
  if (mouseX>1025 && mouseX<1225 && mouseY>50 && mouseY<150) {
    fill(0);
    rect(fWidth+(width-fWidth)/2, 100+(height-fHeight)/2, 200, 100);
    fill(255);
    text("Previous Fractals", 1125, 100);
  }
}

void mouseClicked() {
  PImage prevFractal;
  if (mouseX<1000 && mouseY<750) {
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
      julia.save("fractals"+clickCount+".png");
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
  if (mouseX>1025 && mouseX<1225 && mouseY>50 && mouseY<150) {
    if (clickCount>0) {
      if (picNum>=clickCount) picNum=0;
      prevFractal=loadImage("fractals"+picNum+".png");
      imageMode(CENTER);
      image(prevFractal, fWidth/2, fHeight/2);
      picNum+=2;
      if (clickCount%2==0) clickCount--;
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
    else zoomed=drawMandelbrotZoomed(fIter, fWidth, fHeight, cX, cY, zoom);
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
