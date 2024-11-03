import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'colors.dart';

// class TypographyStyles {
//   static const h1 = TextStyle(
//       fontSize: 40,
//       fontWeight: FontWeight.w700,
//       height: 1.3,
//       color: Colors.black);
//   static const h2 = TextStyle(
//       fontSize: 32,
//       fontWeight: FontWeight.w700,
//       height: 1.3,
//       color: Colors.black);
//   static const h3 = TextStyle(
//       fontSize: 24,
//       fontWeight: FontWeight.w700,
//       height: 1.3,
//       color: Colors.black);
//   static const h4 = TextStyle(
//       fontSize: 20,
//       fontWeight: FontWeight.w700,
//       height: 1.3,
//       color: Colors.black);

//   static const b1 = TextStyle(
//       fontSize: 16,
//       fontWeight: FontWeight.w400,
//       height: 1.5,
//       color: Colors.black);
//   static const b2 = TextStyle(
//       fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black);
//   static const b3 = TextStyle(
//       fontSize: 10, fontWeight: FontWeight.normal, color: Colors.black);

//   static const button1 =
//       TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);

//   static const button2 =
//       TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black);
// }

// const poppins105 = TextStyle(fontSize: 10, fontWeight: FontWeight.w500);
// const poppins124 = TextStyle(fontSize: 12, color: primaryGrey);
// const poppins125 =
//     TextStyle(fontSize: 12, color: primaryGrey, fontWeight: FontWeight.w500);
// const poppins126 =
//     TextStyle(fontSize: 12, color: primaryGrey, fontWeight: FontWeight.w600);
// const poppins146 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
// const poppins169 = TextStyle(fontSize: 16, fontWeight: FontWeight.w900);
// const poppins189 = TextStyle(fontSize: 18, fontWeight: FontWeight.w900);

const h1 = TextStyle(fontSize: 60);
const h2 = TextStyle(fontSize: 48);
const h3 = TextStyle(fontSize: 36);
const h4 = TextStyle(fontSize: 30);
const h5 = TextStyle(fontSize: 24);

const title1 = TextStyle(fontSize: 20);
const title2 = TextStyle(fontSize: 18);
const title3 = TextStyle(fontSize: 16);

const body = TextStyle(fontSize: 14);

const caption = TextStyle(fontSize: 12);

extension WeightModifier on TextStyle {
  TextStyle medium({Color color = primaryBlack}) {
    return copyWith(fontWeight: FontWeight.w500, color: color);
  }

  TextStyle semibold({Color color = primaryBlack}) {
    return copyWith(fontWeight: FontWeight.w600, color: color);
  }

  TextStyle bold({Color color = primaryBlack}) {
    return copyWith(fontWeight: FontWeight.w700, color: color);
  }
}
