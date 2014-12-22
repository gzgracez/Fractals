/**
 * <h1>ComplexNumber class</h1>
 * The ComplexNumber class allows the use of complex numbers
 * @author Grace Zhang
 * @version 1.0
 * @since 2014-12-20
 *
 */

public class ComplexNumber {

	private double a, b;
	/**
	 * Creates a new ComplexNumber 2i
	 */
	public ComplexNumber() {
		a = 0;
		b = 2;
	}
	
	/**
	 * Creates a new ComplexNumber with a1+b1i
	 * @param a1 This is the real component of the ComplexNumber
	 * @param b1 This is the imaginary component of the ComplexNumber
	 */
	public ComplexNumber(double a1, double b1) {
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
	public double getReal() {
		return a;
	}

	/**
	 * An "accessor" method that returns the imaginary component of this ComplexNumber
	 * @return a The imaginary component of this ComplexNumber
	 */
	public double getImag() {
		return b;
	}

	/**
	 * This method allows the ComplexNumber to be written nicely as a String
	 */
	public String toString() {
		String result = "";
		if (a == 0) {
			if (b < 0) {
				result = b + "i";
			} else if (b == 0) {
				result = "0.0";
			} else {
				result = b + "i";
			}
		} 
		else {
			if (b < 0) {
				result = a + " - " + Math.abs(b) + "i";
			} else if (b == 0) {
				result = a + "";
			} else {
				result = a + " + " + b + "i";
			}
		}
		return result;
	}

	/**
	 * This method adds two ComplexNumbers
	 * @param c This is the ComplexNumber to be added to the original ComplexNumber
	 * @return d The sum of the two ComplexNumbers
	 */
	public ComplexNumber add (ComplexNumber c){
		double cReal=a+c.getReal();
		double cImag=b+c.getImag();
		ComplexNumber d=new ComplexNumber(cReal,cImag);
		return d;
	}

	/**
	 * This method subtracts two ComplexNumbers
	 * @param c This is the ComplexNumber to be subtracted from the original ComplexNumber
	 * @return d This is the difference between the two ComplexNumbers
	 */
	public ComplexNumber subtract (ComplexNumber c){
		double cReal=a-c.getReal();
		double cImag=b-c.getImag();
		ComplexNumber d=new ComplexNumber(cReal,cImag);
		return d;
	}

	/**
	 * This method multiplies two ComplexNumbers
	 * @param c This is the ComplexNumber to be multiplied by the original ComplexNumber
	 * @return d This is the product of the two ComplexNumbers
	 */
	public ComplexNumber multiply (ComplexNumber c){
		double cReal=a*c.getReal()+(-1*b*c.getImag());
		double cImag=a*c.getImag()+(b*c.getReal());
		ComplexNumber d=new ComplexNumber(cReal,cImag);
		return d;
	}

	/**
	 * This method divides two ComplexNumbers
	 * @param c This is the ComplexNumber that the original ComplexNumber is divided by
	 * @return d This is the quotient of the two ComplexNumbers
	 */
	public ComplexNumber divide (ComplexNumber c) {
		if ((c.getReal()+c.getImag())==0) {
			ComplexNumber d=new ComplexNumber(a,b);
			System.out.println("Not valid; returning the dividend");
			return d;
		}
		double denom=(c.getReal()*c.getReal())+(c.getImag()*c.getImag());
		double numReal=a*c.getReal()+(b*c.getImag());
		double numImag=-1*a*c.getImag()+(b*c.getReal());
		double cReal=numReal/denom;
		double cImag=numImag/denom;
		ComplexNumber d=new ComplexNumber(cReal,cImag);
		return d;
	}

	/**
	 * This method returns the conjugate of a ComplexNumber
	 * @return d This is the conjugate of the original ComplexNumber
	 */
	public ComplexNumber conjugate(){
		ComplexNumber d=new ComplexNumber(a,-1*b);
		return d;
	}

	/**
	 * This method checks if two ComplexNumbers are equal
	 * @param c This is the ComplexNumber the original ComplexNumber should be checked against
	 * @return boolean Returns whether the two ComplexNumbers are equal
	 */
	public boolean equals(ComplexNumber c){
		if (a!=c.getReal())return false;
		if (b!=c.getImag())return false;
		return true;
	}

	/**
	 * This method returns the magnitude of a ComplexNumber
	 * @return d The magnitude of this ComplexNumber
	 */
	public double magnitude(){
		double d=Math.sqrt(a*a+b*b);
		return d;
	}

	/**
	 * This method raises a ComplexNumber to a power
	 * @param exp This is the exponent the ComplexNumber should be raised to
	 * @return d This is the ComplexNumber that is returned when a ComplexNumber is raised to a power
	 */
	public ComplexNumber power(int exp){
		ComplexNumber d=new ComplexNumber(1,0);
		ComplexNumber c=new ComplexNumber(a,b);
		for (int i=0; i<exp; i++){
			d=d.multiply(c);
		}
		return d;
	}

	/**
	 * This method squares this ComplexNumber
	 * @return d The square of this ComplexNumber
	 */
	public ComplexNumber square(){
		double cReal=a*a-b*b;
		double cImag=2*a*b;
		ComplexNumber d=new ComplexNumber(cReal,cImag);
		return d;
	}

	/**
	 * This method compares the magnitude of two ComplexNumbers
	 * @param c This is the ComplexNumber that the original ComplexNumber will be compared to
	 * @return double This is the greater magnitude of the two ComplexNumbers
	 */
	public double comparesTo(ComplexNumber c){
		double mag=Math.sqrt(a*a+b*b);
		if (mag>=c.magnitude()) return mag;
		else return c.magnitude();
	}
	
	/**
	 * A tester method
	 * @param args
	 */
	public static void main(String[] args) {
		ComplexNumber c = new ComplexNumber(1,2);
		ComplexNumber d = new ComplexNumber(0,0);
		ComplexNumber e = c.divide(d);
		System.out.println(e);
	}

}