var fIter = 50; //final number of iterations
var clickCount = 0; //number of times clicked
var jBack; //juliaSet as background
var zoom = 0.9; //zoom factor
var zoomOut = 1.1; //zoom factor
var xZoom = 4; //x width of coordinate plane
var yZoom = 3; // y width of coordinate plane
var cX = 0; //center coordinates
var cY = 0; //center coordinates
var currentSet = 0; //0-mandelbrot
var fWidth = 1000;
var fHeight = 750;
var picNum = 0; //for previous julia sets
var juliaNum = new ComplexNumber(0, 0);
var zero = new ComplexNumber(0, 0);

function setup() {
  var cnv = createCanvas(fWidth, fHeight);
  cnv.parent("myContainer");
  textSize(14);
  textFont("Helvetica");
  textStyle(NORMAL);
  imageMode(CORNER);
  var mFractal = drawMand(fIter, fWidth, fHeight);
  image(mFractal, 0, 0);
  /*rectMode(CENTER);
  colorMode(RGB, 255);
  fill(200);
  rect(fWidth + (width - fWidth) / 2, height / 2, width - fWidth, height);*/
  var button = createButton("Save Current Fractal");
  button.mousePressed(saveClicked);
}

function draw() {

}

function saveClicked(){
  save("myFractal.png");
}

var drawJulia = function(iter, mWidth, mHeight, c) {
  var mandelb = createImage(mWidth, mHeight);
  colorMode(HSB);
  mandelb.loadPixels();
  for (var h = 0.0; h < 4.0 * mandelb.height; h += 4.0) {
    for (var w = 0.0; w < 4.0 * mandelb.width; w += 4.0) {
      var a = new ComplexNumber((w / 4.0) / (mandelb.width / 4.0) - 2.0, 1.5 - ((h / 4.0) / (mandelb.height / 3.0)));
      //mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(zero, a, 0, iter), iter*0.75, iter);
      var color1 = color(map(mandelbrot(a, c, 0, iter), 0, iter, 0, 255), 191, 255);
      mandelb.pixels[h * mandelb.width + w] = red(color1);
      mandelb.pixels[h * mandelb.width + w + 1] = green(color1);
      mandelb.pixels[h * mandelb.width + w + 2] = blue(color1);
      mandelb.pixels[h * mandelb.width + w + 3] = 255;
    }
  }
  mandelb.updatePixels();
  return mandelb;
};

var drawMand = function(iter, mWidth, mHeight) {
  var mandelb = createImage(mWidth, mHeight);
  colorMode(HSB);
  mandelb.loadPixels();
  for (var h = 0.0; h < 4.0 * mandelb.height; h += 4.0) {
    for (var w = 0.0; w < 4.0 * mandelb.width; w += 4.0) {
      var a = new ComplexNumber((w / 4.0) / (mandelb.width / 4.0) - 2.0, 1.5 - ((h / 4.0) / (mandelb.height / 3.0)));
      //mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(zero, a, 0, iter), iter*0.75, iter);
      var color1 = color(map(mandelbrot(zero, a, 0, iter), 0, iter, 0, 255), 191, 255);
      mandelb.pixels[h * mandelb.width + w] = red(color1);
      mandelb.pixels[h * mandelb.width + w + 1] = green(color1);
      mandelb.pixels[h * mandelb.width + w + 2] = blue(color1);
      mandelb.pixels[h * mandelb.width + w + 3] = 255;
    }
  }
  mandelb.updatePixels();
  return mandelb;
};

var mandelbrot = function(prev, orig, iter, maxI) {
  var next = orig.add(prev.square());
  if (iter >= maxI) return maxI;
  else {
    if (next.magnitude() >= 2) {
      return iter + 1;
    } else {
      return mandelbrot(next, orig, iter + 1, maxI);
    }
  }
};

function ComplexNumber(a, b) {

  this.getReal = function() {
    return a;
  };

  this.getImag = function() {
    return b;
  };

  this.toString = function() {
    var result = "";
    if (a === 0) {
      if (b < 0) {
        result = nfc(b, 2) + "i";
      } else if (b === 0) {
        result = "0.0";
      } else {
        result = nfc(b, 2) + "i";
      }
    } else {
      if (b < 0) {
        result = nfc(a, 2) + " - " + nfc(abs(b), 2) + "i";
      } else if (b === 0) {
        result = nfc(a, 2) + "";
      } else {
        result = nfc(a, 2) + " + " + nfc(b, 2) + "i";
      }
    }
    return result;
  };

  this.add = function(c) {
    var cReal = a + c.getReal();
    var cImag = b + c.getImag();
    var d = new ComplexNumber(cReal, cImag);
    return d;
  };

  this.subtract = function(c) {
    var cReal = a - c.getReal();
    var cImag = b - c.getImag();
    var d = new ComplexNumber(cReal, cImag);
    return d;
  };

  this.multiply = function(c) {
    var cReal = a * c.getReal() + (-1 * b * c.getImag());
    var cImag = a * c.getImag() + (b * c.getReal());
    var d = new ComplexNumber(cReal, cImag);
    return d;
  };

  this.divide = function(c) {
    if ((c.getReal() + c.getImag()) === 0) {
      var d = new ComplexNumber(a, b);
      print("Not valid; returning the dividend");
      return d;
    }
    var denom = (c.getReal() * c.getReal()) + (c.getImag() * c.getImag());
    var numReal = a * c.getReal() + (b * c.getImag());
    var numImag = -1 * a * c.getImag() + (b * c.getReal());
    var cReal = numReal / denom;
    var cImag = numImag / denom;
    var e = new ComplexNumber(cReal, cImag);
    return e;
  };

  this.conjugate = function() {
    var d = new ComplexNumber(a, -1 * b);
    return d;
  };

  this.equals = function(c) {
    if (a != c.getReal()) return false;
    if (b != c.getImag()) return false;
    return true;
  };

  this.magnitude = function() {
    var d = Math.sqrt(a * a + b * b);
    return d;
  };

  this.power = function(exp) {
    var d = new ComplexNumber(1, 0);
    var c = new ComplexNumber(a, b);
    for (var i = 0; i < exp; i++) {
      d = d.multiply(c);
    }
    return d;
  };

  this.square = function() {
    var cReal = a * a - b * b;
    var cImag = 2 * a * b;
    var d = new ComplexNumber(cReal, cImag);
    return d;
  };

};

var HSBtoRGB = function(h, s, b) {
  var c = (1 - Math.abs(2 * b - 1)) * s;
  var x = c * (1 - Math.abs((h / 60) % 2 - 1));
  var m = b - (c / 2);
  var test = h / 60.0;
  var r;
  var g;
  var B;
  switch (true) {
    case test < 1:
    r = c + m;
    g = x + m;
    B = m;
    break;
    case test < 2:
    r = x + m;
    g = c + m;
    B = m;
    break;
    case test < 3:
    r = m;
    g = c + m;
    B = x + m;
    break;
    case test < 4:
    r = m;
    g = x + m;
    B = c + m;
    break;
    case test < 5:
    r = x + m;
    g = m;
    B = c + m;
    break;
    case test < 6:
    r = c + m;
    g = m;
    B = x + m;
    break;
  }
  return [r, g, B];
};

function mouseClicked() {
  if (mouseX>0 && mouseX<fWidth && mouseY>0 && mouseY<fHeight){
  if (clickCount % 2 == 0) { //julia set
    currentSet = 1;
    cX = 0;
    cY = 0;
    xZoom = 4;
    yZoom = 3;
    var xCoor = (mouseX / (fWidth / 4.0) - 2.0);
    var yCoor = -1.0 * (mouseY / (fHeight / 3.0) - 1.5);
    juliaNum = new ComplexNumber(xCoor, yCoor);
    var julia = drawJulia(fIter, fWidth, fHeight, juliaNum);
    imageMode(CORNER);
    image(julia, 0, 0);
    // julia.save("juliasets/fractals"+clickCount+".png");
  } else { //mandelbrot set
    currentSet = 0;
    cX = 0;
    cY = 0;
    xZoom = 4;
    yZoom = 3;
    imageMode(CORNER);
    var mFractal = drawMand(fIter, fWidth, fHeight);
    image(mFractal, 0, 0);
  }
  clickCount++;
}
}


/*function myFunction() {
  var e = document.getElementById("menu1");
  potential = e.options[e.selectedIndex].value;
}*/