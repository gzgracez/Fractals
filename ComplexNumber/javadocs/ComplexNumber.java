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
				if (b==-1) result= "-i";
				else result = b + "i";
			} else if (b == 0) {
				result = "0.0";
			} else {
				if (b==1) result= "i";
				else result = b + "i";
			}
		} 
		else {
			if (b < 0) {
				if (b==-1) result = a + " - "+ "i";
				else result = a + " - " + Math.abs(b) + "i";
			} else if (b == 0) {
				result = a + "";
			} else {
				if (b==1) result= a + " + " + "i";
				else result = a + " + " + b + "i";
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
			throw new ArithmeticException("Cannot Divide By Zero");
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
	 * This method raises a ComplexNumber to a power
	 * @param exp This is the exponent the ComplexNumber should be raised to
	 * @return d This is the ComplexNumber that is returned when the ComplexNumber is raised to a powere
	 */
	public ComplexNumber power(int exp){
		if (exp<0) throw new IllegalArgumentException("Exponent Cannot Be Negative");
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
	public boolean equals(Object c){
		ComplexNumber that=(ComplexNumber)(c);
		if (a!=that.getReal())return false;
		if (b!=that.getImag())return false;
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
	 * This method compares the magnitude of two ComplexNumbers
	 * @param c This is the ComplexNumber that the original ComplexNumber will be compared to
	 * @return double This returns 0.0 if the two ComplexNumbers are equal, -1.0 if the original ComplexNumber is less than the ComplexNumber c, and 1.0 if the original ComplexNumber is greater than the ComplexNumber c
	 */
	public double comparesTo(Object c){
		ComplexNumber that=(ComplexNumber)(c);
		double mag=Math.sqrt(a*a+b*b);
		if (mag==that.magnitude()) return 0;
		if (mag>=that.magnitude()) return 1;
		else return -1;
	}

	/**
	 * A tester method
	 * @param args
	 */
	public static void main(String[] args) {
		ComplexNumber c = new ComplexNumber(1,2);
		ComplexNumber d = new ComplexNumber(4,7);
		ComplexNumber defaultC = new ComplexNumber();
		ComplexNumber zero = new ComplexNumber(0,0);
		ComplexNumber z1 = new ComplexNumber(0,1);
		ComplexNumber z2 = new ComplexNumber(0,-1);
		ComplexNumber z3 = new ComplexNumber(1,0);
		ComplexNumber z4 = new ComplexNumber(-1,0);
		ComplexNumber z5 = new ComplexNumber(1,1);
		ComplexNumber z6 = new ComplexNumber(1,-1);
		ComplexNumber z7 = new ComplexNumber(-1,1);
		ComplexNumber z8 = new ComplexNumber(-1,-1);
		ComplexNumber z9 = new ComplexNumber(2,3);
		ComplexNumber z10 = new ComplexNumber(2,-3);
		ComplexNumber z11 = new ComplexNumber(-2,3);
		ComplexNumber z12 = new ComplexNumber(-2,-3);
		ComplexNumber orig = new ComplexNumber(-3,9);
		ComplexNumber copy = new ComplexNumber(orig);
		System.out.println(zero);
		System.out.println(z1);
		System.out.println(z2);
		System.out.println(z3);
		System.out.println(z4);
		System.out.println(z5);
		System.out.println(z6);
		System.out.println(z7);
		System.out.println(z8);
		System.out.println(z9);
		System.out.println(z10);
		System.out.println(z11);
		System.out.println(z12);
		System.out.println("Default constructor: " + defaultC);
		System.out.println("Regular constructor: " + orig);
		System.out.println("Copy constructor: " + copy);
		System.out.println("(" + orig + ").getReal() = " + orig.getReal());
		System.out.println("(" + orig + ").getImag() = " + orig.getImag());
		System.out.println("(" + orig + ").add(" + d + ") = " + orig.add(d));
		System.out.println("(" + orig + ").subtract(" + d + ") = " + orig.subtract(d));
		System.out.println("(" + orig + ").multiply(" + d + ") = " + orig.multiply(d));
		System.out.println("(" + orig + ").divide(" + d + ") = " + orig.divide(d));
		try{
			ComplexNumber f = c.divide(zero);
			System.out.println(f);
		} catch (ArithmeticException e){
			System.out.println("Caught ArithmeticException: " + e.getMessage());
		}
		System.out.println("(" + orig + ").power(5) = " + orig.power(5));
		try{
			ComplexNumber f = c.power(-2);
			System.out.println(f);
		} catch (IllegalArgumentException e){
			System.out.println("Caught IllegalArgumentException: " + e.getMessage());
		}
		System.out.println("(" + orig + ").square() = " + orig.square());
		System.out.println("(" + orig + ").equals(" + copy + ") = " + orig.equals(copy));
		System.out.println("(" + orig + ").equals(" + d + ") = " + orig.equals(d));
		System.out.println("(" + orig + ").magnitude() = " + orig.magnitude());
		System.out.println("(" + orig + ").comparesTo(" + new ComplexNumber(3.5,9) + ") = " + orig.comparesTo(new ComplexNumber(3.5,9)));
		System.out.println("(" + orig + ").comparesTo(" + new ComplexNumber(3,9) + ") = " + orig.comparesTo(new ComplexNumber(3,9)));
		System.out.println("(" + orig + ").comparesTo(" + d + ") = " + orig.comparesTo(d));
	}

}
