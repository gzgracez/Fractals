public class ComplexNumber {

  private float a, b;

  public ComplexNumber() {
    a = 0;
    b = 2;
  }

  public ComplexNumber(float a1, float b1) {
    a = a1;
    b = b1;
  }

  public ComplexNumber(ComplexNumber cN1) {
    a = cN1.getReal();
    b = cN1.getImag();
  }

  public float getReal() {
    return a;
  }

  public float getImag() {
    return b;
  }

  public String toString() {
    String result = "";
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

  public ComplexNumber add (ComplexNumber c) {
    float cReal=a+c.getReal();
    float cImag=b+c.getImag();
    ComplexNumber d=new ComplexNumber(cReal, cImag);
    return d;
  }

  public ComplexNumber subtract (ComplexNumber c) {
    float cReal=a-c.getReal();
    float cImag=b-c.getImag();
    ComplexNumber d=new ComplexNumber(cReal, cImag);
    return d;
  }

  public ComplexNumber multiply (ComplexNumber c) {
    float cReal=a*c.getReal()+(-1*b*c.getImag());
    float cImag=a*c.getImag()+(b*c.getReal());
    ComplexNumber d=new ComplexNumber(cReal, cImag);
    return d;
  }

  public ComplexNumber divide (ComplexNumber c) {
    if ((c.getReal()+c.getImag())==0) {
      ComplexNumber d=new ComplexNumber(a, b);
      System.out.println("Not valid; returning the dividend");
      return d;
    }
    float denom=(c.getReal()*c.getReal())+(c.getImag()*c.getImag());
    float numReal=a*c.getReal()+(b*c.getImag());
    float numImag=-1*a*c.getImag()+(b*c.getReal());
    float cReal=numReal/denom;
    float cImag=numImag/denom;
    ComplexNumber d=new ComplexNumber(cReal, cImag);
    return d;
  }

  public ComplexNumber conjugate() {
    ComplexNumber d=new ComplexNumber(a, -1*b);
    return d;
  }

  public boolean equals(ComplexNumber c) {
    if (a!=c.getReal())return false;
    if (b!=c.getImag())return false;
    return true;
  }

  public double magnitude() {
    double d=Math.sqrt(a*a+b*b);
    return d;
  }

  public ComplexNumber power(int exp) {
    ComplexNumber d=new ComplexNumber(1, 0);
    ComplexNumber c=new ComplexNumber(a, b);
    for (int i=0; i<exp; i++) {
      d=d.multiply(c);
    }
    return d;
  }

  public ComplexNumber square() {
    float cReal=a*a-b*b;
    float cImag=2*a*b;
    ComplexNumber d=new ComplexNumber(cReal, cImag);
    return d;
  }


  /*public int comparesTo(ComplexNumber c){
   
   }*/

  /*public void main(String[] args) {
   ComplexNumber c = new ComplexNumber(1,2);
   ComplexNumber d = new ComplexNumber(0,0);
   ComplexNumber e = c.divide(d);
   System.out.println(e);
   }*/
}

