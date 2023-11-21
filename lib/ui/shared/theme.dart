import 'package:flutter/material.dart';

extension CustomTextStyles on TextTheme {

  //*** กรณีต้องการเพิ่ม style ที่นอกเหนือจาก fontSize ให้ใช้วิธี copyWith และระบุ style ที่ต้องการไปเลย แทน การเพิ่ม style ที่นี่

  TextStyle get smaller => const TextStyle(
    fontSize: 12,
  );

  TextStyle get small => const TextStyle(
    fontSize: 14,
  );

  TextStyle get normal => const TextStyle(
    fontSize: 16,
  );

  TextStyle get large => const TextStyle(
    fontSize: 20,
  );

  TextStyle get larger => const TextStyle(
    fontSize: 24,
  );

  TextStyle get xlarger => const TextStyle(
    fontSize: 30,
  );

  TextStyle get xxlarger => const TextStyle(
    fontSize: 36,
  );

}
