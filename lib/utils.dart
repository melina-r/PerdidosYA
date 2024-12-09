import 'package:flutter/material.dart';

void callFunction(VoidCallback function) {
  function();
}

String splitAndGetEnum(Enum object) {
  return object.toString().split('.').last;
}

int getIntValueFromEnum(Enum object) {
  return object.index;
}