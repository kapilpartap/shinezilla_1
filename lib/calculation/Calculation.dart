

// class Calculation
// {
//
//   static double getGstAmt(base_amt,tax_amt)
//   {
//     return (base_amt*tax_amt/100)+base_amt;
//   }
//
// }



class Calculation {

  static double getGstAmt(double base_amt, double tax_amt) {
    return (base_amt * tax_amt / 100) + base_amt;
  }

  static String getFormattedGstAmt(double base_amt, double tax_amt) {
    double totalAmt = getGstAmt(base_amt, tax_amt);
    return totalAmt.toStringAsFixed(2);
  }

  static String getAfterSpecialOfferGstAmt(double base_amt, double tax_amt,int specailoffer) {
    base_amt= base_amt-base_amt*specailoffer/100;
    double totalAmt = getGstAmt(base_amt, tax_amt);
    return totalAmt.toStringAsFixed(2);
  }
}
