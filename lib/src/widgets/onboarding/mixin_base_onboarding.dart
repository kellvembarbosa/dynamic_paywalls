import 'package:flutter/material.dart';

mixin BaseOnboardingLayoutMixin<T extends StatefulWidget> on State<T> {
  int currentStep = 0;
  List<dynamic> items = <dynamic>[];
  List<Widget> children = <Widget>[];
  List<String> btnTexts = <String>[];
  List<Function> btnActions = <Function>[];
  Map<String, dynamic> data = <String, dynamic>{};
  bool isFirst = false;
  bool isLast = false;
  Function? onDonePressed;
  Function? onSkipPressed;

  void setCurrentStep(int currentStep) {
    setState(() {
      this.currentStep = currentStep;
    });
  }

  void setItems(List<dynamic> items) {
    setState(() {
      this.items = items;
    });
  }

  void setChildren(List<Widget> children) {
    setState(() {
      this.children = children;
    });
  }

  void setBtnTexts(List<String> btnTexts) {
    setState(() {
      this.btnTexts = btnTexts;
    });
  }

  void setBtnActions(List<Function> btnActions) {
    setState(() {
      this.btnActions = btnActions;
    });
  }

  void setIsFirst(bool isFirst) {
    setState(() {
      this.isFirst = isFirst;
    });
  }

  void setIsLast(bool isLast) {
    setState(() {
      this.isLast = isLast;
    });
  }

  void setOnDonePressed(Function? onDonePressed) {
    setState(() {
      this.onDonePressed = onDonePressed;
    });
  }

  void setOnSkipPressed(Function? onSkipPressed) {
    setState(() {
      this.onSkipPressed = onSkipPressed;
    });
  }

  void setData(Map<String, dynamic> newData) {
    setState(() {
      data = data..addAll(newData);
    });
  }
}
