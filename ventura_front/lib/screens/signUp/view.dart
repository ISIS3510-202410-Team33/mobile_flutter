import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:ventura_front/screens/home/view.dart";
import "package:ventura_front/services/view_models/user_viewModel.dart";

import "../../mvvm_components/observer.dart";


class  SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State createState() => SignUpViewState();
}

class SignUpViewState extends State<SignUpView> implements EventObserver{

  final UserViewModel _viewModel = UserViewModel();
  bool _isLoading = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
 
  @override
  void initState() {
    super.initState();
    _viewModel.subscribe(this);
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.unsubscribe(this);
  }

  @override
  void notify(ViewEvent event) {  

    if (event is LoadingUserEvent) {
      setState(() {
        _isLoading = event.isLoading;
      });
    } else if (event is SignUpSuccessEvent) {

      print("Sing up success");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User created successfully'),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
      );

    } else if (event is SignUpFailedEvent) {
      print("Sing up failed");
      print(event.reason);
      showDialog<String>(

        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Sign Up Failed"),
          content: const Text("Please enter valid email and password"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, "Ok"),
              child: const Text("Ok"),
            )
          ],
        ),
      );
    }  

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage('lib/icons/gooseLogin.png'),
            fit: BoxFit.contain,
            alignment: Alignment.bottomLeft),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          Expanded(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
  
                children: [
                   Column(children: [

                    const SizedBox(
                        height: 30,
                        width: double.infinity,
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(children: [
                        BackButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],),
                    )
                  
                  ],),
                  
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.7,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage('lib/icons/gooseLogin.png'),
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft,
                      ),
                    ),
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                        const SizedBox(
                          width: double.infinity,
                        ),
                        
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:  [
                            Text(
                              'Create your',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'account',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'using your',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'college',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'credentials',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextField(
                                controller: emailController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Email',
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Password',
                  
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              Align(
                                alignment: Alignment.center,
                                child:  Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final email = emailController.text.trim();
                                      final password = passwordController.text.trim();
                                      
                                      _viewModel.signUp(email, password);
                                      
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[700],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text("Sign Up",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        )
                                    )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                  
                  
                ],)
              ),
              )
        )

        ],)
      ) 
    );
  }
}
