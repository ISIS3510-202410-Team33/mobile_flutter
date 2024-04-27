import 'package:flutter/material.dart';
import 'package:ventura_front/screens/home/components/notifications_button.dart';
import 'package:ventura_front/screens/home/view.dart';
import 'package:ventura_front/services/models/user_model.dart';
import 'package:ventura_front/screens/home/components/signout_button.dart';

class Header extends StatelessWidget {
  final bool showUserInfo;
  final bool showHomeIcon;
  final bool showLogoutIcon;
  final bool showNotiIcon;  
  final UserModel user;
  const Header(
      {super.key,
      required this.showUserInfo,
      required this.user,
      required this.showHomeIcon,
      required this.showLogoutIcon,
      required this.showNotiIcon});

  String actualDate() {
    DateTime now = DateTime.now();
    var months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    String formattedDate =
        "Today ${months[now.month - 1]} ${now.day}, ${now.year}";
    return formattedDate;
  }

  Widget getUserWidget() {
    // Add a return statement at the end of the function
    if (showUserInfo) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Hey, ${user.name}!",
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 2),
          Text(actualDate(),
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget getHomeIcon(BuildContext context) {
    if (showHomeIcon) {
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
                icon: const Icon(Icons.home_filled, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ));
    } else {
      return Container();
    }
  }

  Widget getLogoutIcon() {
    if (showLogoutIcon) {
      return const SignOutComponent();
    } else {
      return Container();
    }
  }

  Widget getNotiIcon() {
    if (showNotiIcon) {
      return const NotificationComponent();
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getUserWidget(),
        const Spacer(),
        getLogoutIcon(),
        const SizedBox(width: 20),
        getHomeIcon(context),
        getNotiIcon(),
        const SizedBox(width: 20),
      ],
    );
  }
}
