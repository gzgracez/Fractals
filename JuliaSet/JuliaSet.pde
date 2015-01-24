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
 -Uses relative coordinates
 -Button colors invert when mouse hovers over them
 -Coordinates only print out when mouse is in the area of the fractal image
 */
import controlP5.*;
ControlP5 cp5;
int fIter=50;//final number of iterations
int clickCount=0;//number of times clicked
PImage jBack;//juliaSet as background
float zoom=0.9, zoomOut=1.1;//zoom factor
float xZoom=4, yZoom=3;// x and y width of coordinate plane
float cX=0, cY=0;//center coordinates
int currentSet=0; //0-mandelbrot
int w=800;
int h=int(.6*w);
int fWidth=int(w*.8), fHeight=h;
int picNum=0;//for previous julia sets
//int gifCount=0;
ComplexNumber juliaNum=new ComplexNumber(0, 0);
Textfield tReal;
Textfield tImag;
Textfield tIter;
RadioButton rColors;
float jReal=0, jImag=0;
int rColorScheme=3;

void setup() {
  frame.setResizable(true);
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
    .setPosition(fWidth+(width-fWidth-(0.08*width))/2, (3*height)/9)
      .setSize(int(0.08*width), int((4*height)/75))
        .setFont(font)
          //.setFocus(true)
          .setColor(color(255, 0, 0))
            .setColorLabel(color(0))
              //.setColorBackground(color(255))
              .setAutoClear(false)
                .setText("0")
                  .setInputFilter(3)
                    ;
  tImag = cp5.addTextfield("Imaginary Component")
    .setPosition(fWidth+(width-fWidth-(0.08*width))/2, (32*height)/75)
      .setSize(int(0.08*width), int((4*height)/75))
        .setFont(font)
          .setColor(color(255, 0, 0))
            .setColorLabel(color(0))
              .setAutoClear(false)
                .setText("0")
                  .setInputFilter(2)
                    ;
  tIter = cp5.addTextfield("Number of Iterations")
    .setPosition(fWidth+(width-fWidth-(0.08*width))/2, (48*height)/75)
      .setSize(int(0.08*width), int((4*height)/75))
        .setFont(font)
          .setColor(color(255, 0, 0))
            .setColorLabel(color(0))
              .setAutoClear(false)
                .setText("50")
                  .setInputFilter(1)
                    ;
  rColors = cp5.addRadioButton("Color Scheme")
    .setPosition(fWidth+(width-fWidth-(0.08*width))/2, (64*height)/75)
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

void draw() {
  //println(tReal.getText());
  //  if (w!=width) {
  //    w=width;
  //    h=int(.6*width);
  //    frame.setSize(width, h);
  //    println(w + "w, width" + width);
  //    PImage mFractal=drawMand(fIter, fWidth, fHeight);
  //    image(mFractal, 0, 0);
  //  }
  //  println(w + "w, width" + width);

  fWidth=int(width*.8);
  fHeight=height;
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
  rect(fWidth+(width-fWidth)/2, (height*3)/30, width*0.16, (height*2)/15);//previous fractals button
  fill(0);
  text("Previous Fractals", fWidth+(width-fWidth)/2, (height*3)/30);
  if (mouseX>((fWidth+(width-fWidth)/2)-(width*0.08)) && mouseX<((fWidth+(width-fWidth)/2)+(width*0.08)) && mouseY>(((height*3)/30)-((height*2)/30)) && mouseY<(((height*3)/30)+((height*2)/30))) {
    noStroke();
    fill(0);
    rect(fWidth+(width-fWidth)/2, (height*3)/30, int(width*0.16), int((height*2)/15));
    fill(255);
    text("Previous Fractals", fWidth+(width-fWidth)/2, (height*3)/30);
  } 
  stroke(0);
  line(fWidth, (19*height)/75, width, (19*height)/75);

  noStroke();
  fill(204);
  rect(fWidth+(width-fWidth)/2, (0.184*width)+(height-fHeight)/2, width-fWidth-1, height/15);//gray space
  fill(0);
  text("Complex Number to Generate Fractal\nReal & Imaginary Components:", fWidth+(width-fWidth)/2, (0.184*width));
  fill(255);
  noStroke();
  rect(fWidth+(width-fWidth)/2, 0.54*height, 0.08*width, height/15);//enter button for complex number
  fill(0);
  text("Enter", fWidth+(width-fWidth)/2, 0.54*height);
  if (mouseX>(fWidth+(width-fWidth)/2-0.04*width) && mouseX<(fWidth+(width-fWidth)/2+0.04*width) && mouseY>((0.54*height)-height/30) && mouseY<((0.54*height)+height/30)) {
    fill(0);
    rect(fWidth+(width-fWidth)/2, 0.54*height, 0.08*width, height/15);
    fill(255);
    text("Enter", fWidth+(width-fWidth)/2, 0.54*height);
  }

  noStroke();
  fill(204);
  rect(fWidth+(width-fWidth)/2, (47*height)/75, width-fWidth-1, height/15);
  fill(0);
  text("Number of Iterations:", fWidth+(width-fWidth)/2, (47*height)/75);
  stroke(0);
  line(fWidth, 0.6*height, width, 0.6*height);
  fill(255);
  noStroke();
  rect(fWidth+(width-fWidth)/2, (113*height)/150, 0.08*width, height/15);
  fill(0);
  text("Enter", fWidth+(width-fWidth)/2, (113*height)/150);
  if (mouseX>((fWidth+(width-fWidth)/2)-0.04*width) && mouseX<((fWidth+(width-fWidth)/2)+0.04*width) && mouseY>(((113*height)/150)-height/30) && mouseY<(((113*height)/150)+height/30)) {
    fill(0);
    rect(fWidth+(width-fWidth)/2, (113*height)/150, 0.08*width, height/15);
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
}

void mouseClicked() {
  PImage prevFractal;
  if (mouseX<fWidth && mouseY<height) {//clicking the fractal screen
    if (clickCount%2==0) {//julia set
      currentSet=1;
      cX=0;
      cY=0;
      xZoom=4;
      yZoom=3;
      jReal=(mouseX/((float)fWidth/4)-2);
      jImag=-1*(mouseY/((float)fHeight/3)-1.5);
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
  if (mouseX>((fWidth+(width-fWidth)/2)-(width*0.08)) && mouseX<((fWidth+(width-fWidth)/2)+(width*0.08)) && mouseY>(((height*2)/15)-((height*2)/30)) && mouseY<(((height*2)/15)+((height*2)/30))) {//previous fractal
    if (clickCount>0) {
      if (picNum>=clickCount) picNum=0;
      prevFractal=loadImage("juliasets/fractals"+picNum+".png");
      imageMode(CENTER);
      image(prevFractal, fWidth/2, fHeight/2);
      picNum+=2;
      if (clickCount%2==0) clickCount--;
    }
  }
  if (mouseX>(fWidth+(width-fWidth)/2-0.04*width) && mouseX<(fWidth+(width-fWidth)/2+0.04*width) && mouseY>((0.54*height)-height/30) && mouseY<((0.54*height)+height/30)) {//Enter button for complex number to generate a julia set
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
  if (mouseX>((fWidth+(width-fWidth)/2)-0.04*width) && mouseX<((fWidth+(width-fWidth)/2)+0.04*width) && mouseY>(((113*height)/150)-height/30) && mouseY<(((113*height)/150)+height/30)) {//Enter button for # of iterations
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

void keyReleased() {
  if (mouseX<fWidth && mouseY<height) {
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
}

/*void keyPressed() {
 switch(key) {
 case('d'): 
 rColors.deactivateAll(); 
 break;
 case('g'): 
 rColors.activate(0); 
 break;
 case('o'): 
 rColors.activate(1); 
 break;
 case('c'): 
 rColors.activate(2); 
 break;
 }
 }*/

void keyPressed() {
  switch(key) {
    case('d'): 
    rColors.deactivateAll(); 
    break;
    case('g'): 
    rColors.activate(0); 
    break;
    case('o'): 
    rColors.activate(1); 
    break;
    case('c'): 
    rColors.activate(2); 
    break;
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
      if (mandelbrot(zero, a, 0, iter)==iter) mandelb.pixels[h*mandelb.width+w]=color(0);
      //else mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(zero, a, 0, iter),0,10,0,iter), iter*.75, iter);
      else {
        if (rColorScheme==3 || rColorScheme==-1) mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(zero, a, 0, iter)%15, 0, 15, 0, iter), iter*.75, iter);
        else if (rColorScheme==2) mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(zero, a, 0, iter), iter*.75, iter);
        else mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(zero, a, 0, iter)%15, 0, 15, 0, iter));
      }
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
      if (mandelbrot(a, c, 0, iter)==iter)mandelb.pixels[h*mandelb.width+w]=color(0);
      else {
        if (rColorScheme==3 || rColorScheme==-1) mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(a, c, 0, iter)%15, 0, 15, 0, iter), iter*.75, iter);
        else if (rColorScheme==2) mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(a, c, 0, iter), iter*.75, iter);
        else {
          mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(a, c, 0, iter)%15, 0, 15, 0, iter));
        }
      }
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
      if (mandelbrot(zero, a, 0, iter)==iter) mandelb.pixels[h*mandelb.width+w]=color(0);
      else {
        if (rColorScheme==3 || rColorScheme==-1) mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(zero, a, 0, iter)%15, 0, 15, 0, iter), iter*.75, iter);
        else if (rColorScheme==2) mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(zero, a, 0, iter), iter*.75, iter);
        else mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(zero, a, 0, iter)%15, 0, 15, 0, iter));
      }
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
      if (mandelbrot(a, c, 0, iter)==iter)mandelb.pixels[h*mandelb.width+w]=color(0);
      else {
        if (rColorScheme==3 || rColorScheme==-1) mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(a, c, 0, iter)%15, 0, 15, 0, iter), iter*.75, iter);
        else if (rColorScheme==2) mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(a, c, 0, iter), iter*.75, iter);
        else mandelb.pixels[h*mandelb.width+w]=color(map(mandelbrot(a, c, 0, iter)%15, 0, 15, 0, iter));
      }
    }
  }
  mandelb.updatePixels();
  return mandelb;
}

public void clear() {
  cp5.get(Textfield.class, "textValue").clear();
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(rColors)) {
    print("got an event from "+theEvent.getName()+"\t");
    println("\t "+theEvent.getValue());
    rColorScheme = int(theEvent.group().value());
    PImage colorPic;
    if (clickCount%2==1) colorPic=drawJuliaZoomed(fIter, fWidth, fHeight, juliaNum, cX, cY, 1);
    else colorPic=drawMandelbrotZoomed(fIter, fWidth, fHeight, cX, cY, 1);
    imageMode(CORNER);
    image(colorPic, 0, 0);
  }
}

