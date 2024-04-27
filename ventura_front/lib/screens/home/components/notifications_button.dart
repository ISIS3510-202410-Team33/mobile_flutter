import 'package:flutter/material.dart';
import 'package:ventura_front/mvvm_components/observer.dart';
import 'package:ventura_front/screens/login/view.dart';
import 'package:ventura_front/screens/notifications/view.dart';
import 'package:ventura_front/services/repositories/user_repository.dart';
import 'package:ventura_front/services/view_models/user_viewModel.dart';

class NotificationComponent extends StatefulWidget {
  const NotificationComponent({super.key});
  @override
  State<NotificationComponent> createState() => NotificationComponentState();
}

class NotificationComponentState extends State<NotificationComponent> implements EventObserver {

  static final UserViewModel _userViewModel = UserViewModel();

  @override
  void initState() {
    super.initState();
    _userViewModel.subscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: const LinearGradient(
              colors: [Color(0xFF1C1F22), Color(0xFF2F353A)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NotificationView()));
                print("NotificationComponent: onPressed");
              },
            )
          ],
        ));
  }
  
  @override
  void notify(ViewEvent event) {
    // TODO: implement notify
  }

}
