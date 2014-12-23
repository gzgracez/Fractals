var iterSlider;
var text;
var textC;

var fIter = 30; //final number of iterations
var clickCount = 0; //number of times clicked
var jBack; //juliaSet as background
var zoom = 0.9; //zoom factor
var zoomOut = 1.1; //zoom factor
var xZoom = 4; //x width of coordinate plane
var yZoom = 3; // y width of coordinate plane
var cX = 0; //center coordinates
var cY = 0; //center coordinates
var currentSet = 0; //0-mandelbrot
var fWidth = 400; //1000
var fHeight = 300; //750
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
  var button = createButton("Save");
  button.parent("buttonPos");
  button.mousePressed(saveClicked);
  iterSlider = createSlider(3, 100, 30);
  iterSlider.parent("sliderPos");
  iterSlider.size(300);
  fIter = iterSlider.value();
  text = createDiv(iterSlider.value());
  text.parent("iterTextPos");
}

function draw() {
  iterSlider.mouseReleased(numCheck);
}

function saveClicked() {
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
      var color1;
      if (mandelbrot(a, c, 0, iter)==iter) color1=color(0);
      else color1 = color(map(mandelbrot(a, c, 0, iter), 0, iter, 0, 255), 191, 255);
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
      var color1;
      if (mandelbrot(zero, a, 0, iter)===iter) color1=color(0);
      else color1 = color(map(mandelbrot(zero, a, 0, iter), 0, iter, 0, 255), 191, 255);
      mandelb.pixels[h * mandelb.width + w] = red(color1);
      mandelb.pixels[h * mandelb.width + w + 1] = green(color1);
      mandelb.pixels[h * mandelb.width + w + 2] = blue(color1);
      mandelb.pixels[h * mandelb.width + w + 3] = 255;
    }
  }
  mandelb.updatePixels();
  return mandelb;
};

var drawJuliaZoomed = function(iter, mWidth, mHeight, c, x1, y1, zoom1) {
  xZoom *= zoom1;
  yZoom *= zoom1;
  var mandelb = createImage(mWidth, mHeight);
  colorMode(HSB);
  mandelb.loadPixels();
  for (var h = 0.0; h < 4.0 * mandelb.height; h += 4.0) {
    for (var w = 0.0; w < 4.0 * mandelb.width; w += 4.0) {
      var a = new ComplexNumber((w / 4.0) / (mandelb.width / xZoom) + (x1 - xZoom / 2), (y1 + yZoom / 2) - ((h / 4.0) / (mandelb.height / yZoom)));
      //mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(zero, a, 0, iter), iter*0.75, iter);
      var color1;
      if (mandelbrot(a, c, 0, iter)===iter) color1=color(0);
      else color1 = color(map(mandelbrot(a, c, 0, iter), 0, iter, 0, 255), 191, 255);
      mandelb.pixels[h * mandelb.width + w] = red(color1);
      mandelb.pixels[h * mandelb.width + w + 1] = green(color1);
      mandelb.pixels[h * mandelb.width + w + 2] = blue(color1);
      mandelb.pixels[h * mandelb.width + w + 3] = 255;
    }
  }
  mandelb.updatePixels();
  return mandelb;
};

var drawMandZoomed = function(iter, mWidth, mHeight, x1, y1, zoom1) {
  xZoom *= zoom1;
  yZoom *= zoom1;
  var mandelb = createImage(mWidth, mHeight);
  colorMode(HSB);
  mandelb.loadPixels();
  for (var h = 0.0; h < 4.0 * mandelb.height; h += 4.0) {
    for (var w = 0.0; w < 4.0 * mandelb.width; w += 4.0) {
      var a = new ComplexNumber((w / 4.0) / (mandelb.width / xZoom) + (x1 - xZoom / 2.0), (y1 + yZoom / 2) - ((h / 4.0) / (mandelb.height / yZoom)));
      //mandelb.pixels[h*mandelb.width+w]=color(mandelbrot(zero, a, 0, iter), iter*0.75, iter);
      var color1;
      if (mandelbrot(zero, a, 0, iter)===iter) color1=color(0);
      else color1 = color(map(mandelbrot(zero, a, 0, iter), 0, iter, 0, 255), 191, 255);
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

}

function mouseClicked() {
  if (mouseX > 0 && mouseX < fWidth && mouseY > 0 && mouseY < fHeight) {
    if (clickCount % 2 === 0) { //julia set
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

function keyReleased() {
  var zoomed;
  if (key === 'z' || key === 'Z' || keyCode === RIGHT_ARROW || keyCode === UP_ARROW) {
    cX = (mouseX / (fWidth / xZoom) + (cX - xZoom / 2));
    cY = (cY + yZoom / 2) - (mouseY / (fHeight / yZoom));
    if (clickCount % 2 === 1) {
      zoomed = drawJuliaZoomed(fIter, fWidth, fHeight, juliaNum, cX, cY, zoom);
    } else zoomed = drawMandZoomed(fIter, fWidth, fHeight, cX, cY, zoom);
    imageMode(CORNER);
    image(zoomed, 0, 0);
  } else if (key === 'x' || key === 'X' || keyCode === LEFT_ARROW || keyCode === DOWN_ARROW) {
    cX = (mouseX / (fWidth / xZoom) + (cX - xZoom / 2));
    cY = (cY + yZoom / 2) - (mouseY / (fHeight / yZoom));
    if (clickCount % 2 == 1) zoomed = drawJuliaZoomed(fIter, fWidth, fHeight, juliaNum, cX, cY, zoomOut);
    else zoomed = drawMandZoomed(fIter, fWidth, fHeight, cX, cY, zoomOut);
    imageMode(CORNER);
    image(zoomed, 0, 0);
  }
}

function numCheck() {
  if (iterSlider.value() != fIter) {
    text.remove();
    text = createDiv(iterSlider.value());
    text.parent("iterTextPos");
    fIter = iterSlider.value();
    var iterPic;
    if (clickCount % 2 == 1) iterPic = drawJuliaZoomed(fIter, fWidth, fHeight, juliaNum, cX, cY, 1);
    else iterPic = drawMandZoomed(fIter, fWidth, fHeight, cX, cY, 1);
    imageMode(CORNER);
    image(iterPic, 0, 0);
  }
}