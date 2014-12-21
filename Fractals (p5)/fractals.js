var fIter = 50; //final number of iterations
var clickCount = 0; //number of times clicked
var jBack; //juliaSet as background
var zoom = 0.9; //zoom factor
var zoomOut = 1.1; //zoom factor
var xZoom = 4; //x width of coordinate plane
var yZoom = 3; // y width of coordinate plane
var cX = 0,
  cY = 0; //center coordinates
var currentSet = 0; //0-mandelbrot
var fWidth = 1000;
var fHeight = 750;
var picNum = 0; //for previous julia sets
var juliaNum = new ComplexNumber(0, 0);
var zero = new ComplexNumber(0, 0);

function setup() {
  var cnv = createCanvas(1250, 750);
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

  for (i = 0; i < 2; i += 0.5) {
    var cN=new ComplexNumber(i,0);
    print(mandelbrot(zero, cN, 0, fIter));
  }
}

function draw() {

}

var drawMand = function(iter, mWidth, mHeight) {
  mandelb = createImage(mWidth, mHeight);
  colorMode(HSB, iter);
  mandelb.loadPixels();
  for (var h = 0.0; h < mandelb.height; h+=1.0) {
    for (var w = 0.0; w < mandelb.width; w+=1.0) {
      var a = new ComplexNumber(w/(mandelb.width/4.0) - 2.0, 1.5 - (h/(mandelb.height/3.0)));
      var color1 = color(mandelbrot(zero, a, 0, iter), iter * .75, iter);
      mandelb.set(w, h, color1);
    }
  }
  mandelb.updatePixels();
  return mandelb;
}

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
}

function ComplexNumber(a, b) {

  this.getReal = function() {
    return a;
  }

  this.getImag = function() {
    return b;
  }

  this.toString = function() {
    var result = "";
    if (a == 0) {
      if (b < 0) {
        result = nfc(b, 2) + "i";
      } else if (b == 0) {
        result = "0.0";
      } else {
        result = nfc(b, 2) + "i";
      }
    } else {
      if (b < 0) {
        result = nfc(a, 2) + " - " + nfc(abs(b), 2) + "i";
      } else if (b == 0) {
        result = nfc(a, 2) + "";
      } else {
        result = nfc(a, 2) + " + " + nfc(b, 2) + "i";
      }
    }
    return result;
  }

  this.add = function(c) {
    var cReal = a + c.getReal();
    var cImag = b + c.getImag();
    var d = new ComplexNumber(cReal, cImag);
    return d;
  }

  this.subtract = function(c) {
    var cReal = a - c.getReal();
    var cImag = b - c.getImag();
    var d = new ComplexNumber(cReal, cImag);
    return d;
  }

  this.multiply = function(c) {
    var cReal = a * c.getReal() + (-1 * b * c.getImag());
    var cImag = a * c.getImag() + (b * c.getReal());
    var d = new ComplexNumber(cReal, cImag);
    return d;
  }

  this.divide = function(c) {
    if ((c.getReal() + c.getImag()) == 0) {
      var d = new ComplexNumber(a, b);
      print("Not valid; returning the dividend");
      return d;
    }
    var denom = (c.getReal() * c.getReal()) + (c.getImag() * c.getImag());
    var numReal = a * c.getReal() + (b * c.getImag());
    var numImag = -1 * a * c.getImag() + (b * c.getReal());
    var cReal = numReal / denom;
    var cImag = numImag / denom;
    var d = new ComplexNumber(cReal, cImag);
    return d;
  }

  this.conjugate = function() {
    var d = new ComplexNumber(a, -1 * b);
    return d;
  }

  this.equals = function(c) {
    if (a != c.getReal()) return false;
    if (b != c.getImag()) return false;
    return true;
  }

  this.magnitude = function() {
    var d = Math.sqrt(a * a + b * b);
    return d;
  }

  this.power = function(exp) {
    var d = new ComplexNumber(1, 0);
    var c = new ComplexNumber(a, b);
    for (var i = 0; i < exp; i++) {
      d = d.multiply(c);
    }
    return d;
  }

  this.square = function() {
    var cReal = a * a - b * b;
    var cImag = 2 * a * b;
    var d = new ComplexNumber(cReal, cImag);
    return d;
  }

}

function mouseClicked() {
  if (mouseButton == LEFT) {
    for (var i = 0; i < nodes.length; i++) {
      var p = nodes[i];
      if (dist(mouseX, mouseY, p.x, p.y) < 5) {
        nodes[i].selected = !nodes[i].selected;
        for (var j = 0; j < nodes.length; j++) {
          if (j != i) {
            nodes[j].selected = false;
          }
        }
      }
    }
  }

  if (mouseButton == RIGHT) {
    nodes.length = 0;
    nodeNum = nodeNumSlider.value();
    for (var i = 0; i < nodeNum; i++) {
      nodes.push(new Node(map(i, 0, nodeNum - 1, 30, width - 80), height / 2));
    }
    initialU = calculateU();
    initialK = calculateK();
    initialAction = calculateK() - calculateU();
    most = max(initialAction, initialU, abs(initialK));
  }
}


function myFunction() {
  var e = document.getElementById("menu1");
  potential = e.options[e.selectedIndex].value;
}