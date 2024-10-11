
import 'dart:ui';

class ColorConverter
{

  static stringToHex(String color)
  {

  return  Color(int.parse(color.substring(1, 7), radix: 16) + 0xFF000000);

  }


}