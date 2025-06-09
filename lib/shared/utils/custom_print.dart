import 'dart:developer';

import 'package:flutter/foundation.dart';
void miPrint(dynamic message){
  if(kDebugMode){
    log(message.toString(), name: 'CustomPrint');
  }
}