import 'package:flutter/material.dart';
import 'package:ventura_front/mvvm_components/observer.dart';

class SignOutComponent extends StatefulWidget {
  const SignOutComponent({super.key});
  @override
  State<SignOutComponent> createState() => SignOutComponentState();
}

class SignOutComponentState extends State<SignOutComponent> implements EventObserver {

  @override
  Widget build(BuildContext context) {
    return 
    Material(
      elevation: 15,
      shadowColor: Colors.black,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Add the following code to the onPressed function
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const HomeView())
              // );
            },
          ),
          const Text("Sign Out", style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      )
        
      
    )
    ;
  }
  
  @override
  void notify(ViewEvent event) {
    // TODO: implement notify
  }

}
 