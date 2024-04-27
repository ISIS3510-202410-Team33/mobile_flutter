import "package:flutter/material.dart";
import "../../mvvm_components/observer.dart";

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State createState() => NotificationViewState();
}

class NotificationViewState extends State<NotificationView> implements EventObserver{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  void notify(ViewEvent event) {
    // TODO: implement notify
  }


}