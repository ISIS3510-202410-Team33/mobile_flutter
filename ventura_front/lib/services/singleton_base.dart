import 'package:flutter/material.dart';

base class SingletonBase<T> {
  // T is the class that will be used as the state of the singleton
  @protected
  late T initialState;

  @protected
  late T state;

  T get currentText => state;

  void setState(T newState) {
    state = newState;
  }
  void reset() {
    state = initialState;
  }

}