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

