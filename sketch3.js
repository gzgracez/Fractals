var nodeNumSlider;

var pChoice0;
var pChoice1;
var pChoice2;
var pChoice3;
var pChoice4;
var pChoice5;

var nodes = [];
var potential = 1;
var nodeNum = 9;
var initialAction = 1;
var initialU = 1;
var initialK = 0;
var scaleFactor;
var most=100;
var K_;
var U_;

function setup() {
  var cnv = createCanvas(800, 400);
   cnv.parent("myContainer");
  textSize(14);
  textFont("Helvetica");
  textStyle(NORMAL);

  nodeNumSlider = createSlider(3,17,11);
  nodeNumSlider.parent("sliderPos");
  nodeNumSlider.size(300);  
  

  stroke(100);
  noStroke();
  for (var i = 0; i<nodeNumSlider.value(); i++) {
    nodes.push(new Node(map(i, 0, nodeNumSlider.value()-1, 30, width-80), height/2));
  }

   initialU = calculateU();
   initialK = calculateK();
   initialAction = calculateK() - calculateU();  
   most = max(initialAction, initialU, abs(initialK));  

}

function draw() {
  background(255);
  strokeWeight(2);
  grid(true);
  myFunction();

  if (potential == 3) {
    strokeWeight(2);
    stroke(0, 250, 0);
    line(0, width/2+height/2, width/2+height/2, 0);
  }

  if (potential == 4) {
    fill(0, 255, 0);
    ellipse(width/2, height/2, 12, 12);
  }

  if (potential == 5) {
    strokeWeight(2);
    stroke(120);  
    for (var i = 0; i<height; i=i+10) {
      line(width/2, i, width/2, i+5);
    }
  }

  if (keyIsPressed===true) {
    optimizer();
  }

  nodeNumSlider.mouseReleased(numCheck);
  
  for (var i = 0; i<nodes.length; i++) {
    nodes[i].clickedOn();
    nodes[i].display();
    if (i>0) {
        stroke(0);
        strokeWeight(2);
        line(nodes[i].x, nodes[i].y, nodes[i-1].x, nodes[i-1].y);
    }
  }

  energyBars();
 
}

function grid(y) {
  if (y == true) {
    strokeWeight(0.5);
    stroke(150);
    for (var i = 1; i<9*2; i++) {
      line(width, .5*i*height/9, 0, .5*i*height/9);
    }
    for (var i = 1; i<9*4; i++) {
      line(.5*i*height/9, 0, .5*i*height/9, height);
    }
  }
}

function Node(ix, iy) {
  this.x = ix;
  this.y = iy;
  this.selected = false;

  this.display = function() {
    noStroke();
    if (this.selected == false) {
      fill(0);
    }
    else {
      fill(255, 0, 0);
    }
    ellipse(this.x, this.y, 8, 8);
  }

 this.clickedOn = function() {
    if (this.selected == true) {
      this.x = mouseX;
      this.y = mouseY;
    }
  }
}

function calculateK() {
  var K = 0;
  for (var i=0; i<nodes.length; i++) {  
    if (i>0) {
      K = K + sq(dist(nodes[i].x, nodes[i].y, nodes[i-1].x, nodes[i-1].y));
    }
  }
  return K;
}

function calculateU() {
  U = 0;
  for (var i=0; i<nodes.length; i++) {  
    U = U + getPE(nodes[i]);
  }
  return U;
}


function getPE(q) {
  if (potential == 1){
      return -(2000/(nodeNum*nodeNum)*(q.y) -3800000/(nodeNum*nodeNum)  );
  }
    
  else if (potential == 2) {
    return -(2000/(nodeNum*nodeNum)*(q.x) - 1900000/(nodeNum*nodeNum) );
  }
      
  else if (potential == 3) {
     if (q.x + q.y > width/2 + height/2 ) {
        return -(30000);
      }
      else {
        return 0;
      }
  }
    
  else if (potential == 4) {
    return -(300000)*(1/(dist(q.x, q.y, width/2, height/2)));
  }

 else if (potential == 5) {
    return (10.0/(nodeNum*nodeNum))*(sq(q.x-width/2));
  }

  else {
    return 0;
  }
 }



function numCheck(){
if (nodeNum != nodeNumSlider.value()){
 nodes.length = 0;
    nodeNum = nodeNumSlider.value();
   for (var i = 0; i<nodeNum; i++) {
    nodes.push(new Node(map(i, 0, nodeNum-1, 30, width-80), height/2));
  }
   initialU = calculateU();
   initialK = calculateK();
   initialAction = calculateK() - calculateU();  
   most = max(initialAction, initialU, abs(initialK)); 
  }
}

function mouseClicked() {
  if (mouseButton == LEFT) {
    for (var i = 0; i < nodes.length; i++) {
      var p = nodes[i];
      if (dist(mouseX, mouseY, p.x, p.y) < 5) {
        nodes[i].selected =  !nodes[i].selected;
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
   for (var i = 0; i<nodeNum; i++) {
    nodes.push(new Node(map(i, 0, nodeNum-1, 30, width-80), height/2));
  }
   initialU = calculateU();
   initialK = calculateK();
   initialAction = calculateK() - calculateU();  
   most = max(initialAction, initialU, abs(initialK));  
  }
}

function optimizer() {
  var jump = 1;
  if (potential ==3){
    jump = 20;
  }
  for (var j = 0; j<400; j++) {
    for (var i = 1;  i<nodeNumSlider.value()-1; i++) {
      var oldAction = calculateK() - calculateU();
      var tempX = nodes[i].x;
      var tempY = nodes[i].y;
      nodes[i].x = nodes[i].x + randomGaussian()*jump;
      nodes[i].y = nodes[i].y + randomGaussian()*jump;
      if ( calculateK() - calculateU() > oldAction) {
        nodes[i].x  = tempX;
        nodes[i].y = tempY;
      }
    }
  }  
}

function energyBars(){
    stroke(200, 0, 0);
    fill(200, 0, 0);
    var K_ = calculateK();
    var U_ = calculateU();

    rect(width-60, 2*height/3, 10, -(K_/most)*100);
    

    stroke(0, 200, 0);
    fill(0, 200, 0);
    rect(width-40, 2*height/3, 10, -(U_/most)*100);
    fill(0);
   

    stroke(0, 0, 200);
    fill(0, 0, 200);

    rect(width-20, 2*height/3, 10, (-(K_-U_)/most)*100);
    fill(0);
    stroke(0,0,0);
    text("K", width-60+2, height/6-10);
    text("U", width-40+2, height/6-10);
    text("S", width-20+2, height/6-10);
    text("Action = " + String(Math.round( calculateK()/100-calculateU()/100 )), width/2, 17);
}


function myFunction() {
  var e = document.getElementById("menu1");
  potential = e.options[e.selectedIndex].value;
  }
