import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

extension Buttons on ElevatedButton {
  ElevatedButton loadingIndicator(context, bool isLoading) {
    if (isLoading) {
      return ElevatedButton(
          onPressed: null,
          child: SpinKitChasingDots(
            color: Theme.of(context).primaryColor,
            size: 50.0,
          ));
    }
    return ElevatedButton(onPressed: onPressed, child: child);
  }
}
