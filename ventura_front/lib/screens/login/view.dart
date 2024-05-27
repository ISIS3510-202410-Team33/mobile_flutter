import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:ventura_front/screens/home/view.dart";
import "package:ventura_front/screens/signUp/view.dart";

import "package:ventura_front/services/view_models/connection_viewmodel.dart";
import "package:ventura_front/services/view_models/user_viewModel.dart";


import "../../mvvm_components/observer.dart";


class  LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> implements EventObserver{

  final UserViewModel _viewModel = UserViewModel();
  bool _isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _hasConnection = true;
  static final ConnectionViewModel _connectionViewModel = ConnectionViewModel();
 
  @override
  void initState() {
    print("Sign up init");
    super.initState();
    madeConnection();
  }

  void madeConnection() {
    _viewModel.subscribe(this);
    _connectionViewModel.subscribe(this);
    _connectionViewModel.isInternetConnected().then((value) {
      setState(() {
        _hasConnection = value;
      });
      if(value){
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
      }
      else {
        notify(ConnectionEvent(connection: false));
      }
    });
  }


  @override
  void dispose() {
    super.dispose();
    _viewModel.unsubscribe(this);
    _connectionViewModel.unsubscribe(this);
    
  }

  @override
  void notify(ViewEvent event) {  

    if (event is ConnectionEvent && event.connection != _hasConnection) {
      setState(() {
        _hasConnection = event.connection;
      });
      if (event.connection){
        // Conexión restablecida, mostrar mensaje en verde
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
          content: Text('You are connected again'),
        ),
      );
      }
      else {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(days: 1),
            backgroundColor: Colors.red,
            content: Text('You can\'t sign in because you don\'t have connection'),
          ),
        );
      }
    }
    else if (event is LoadingUserEvent) {
      setState(() {
        _isLoading = event.isLoading;
      });
    } else if (event is SignInSuccessEvent) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeView(), // Reemplaza LoginView() con la pantalla siguiente
        ),
      );
    } else if (event is SignInFailedEvent) {
      showDialog<String>(

        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Sign In Failed"),
          content: const Text("Please enter valid email and password"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Ok');
              },
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
            alignment: Alignment.bottomLeft,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(

                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SignUpView(), // Reemplaza LoginView() con la pantalla siguiente
                              ),
                            );
                            madeConnection();
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).padding.top,
                                width: double.infinity,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("First time using ventura?", style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text("Sign up here", style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ),
                                ],
                              )
                            ],),

                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.7,
                          alignment: Alignment.centerLeft,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              image: AssetImage('lib/icons/gooseLogin.png'),
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.bottomLeft,
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
                                  children: [
                                    Text(
                                      'Join us',
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
                                              fontWeight: FontWeight.w400),
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
                                              fontWeight: FontWeight.w400),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            height: 50,
                                            child: ElevatedButton(

                                              onPressed: _hasConnection && !_isLoading
                                                  ? () {
                                                      final email = emailController.text.trim();
                                                      final password = passwordController.text.trim();
                                                      _viewModel.signIn(email, password);
                                                    }
                                                  : null, // Desactiva el botón si no hay conexión
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: _hasConnection && !_isLoading
                                                    ? Colors.grey[700]
                                                    : Colors.grey,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Text(
                                                "Login",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            height: 50,
                                            child: ElevatedButton(

                                              onPressed: !_isLoading
                                                  ? () async {
                                                      await Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (context) => const SignUpView(), // Reemplaza LoginView() con la pantalla siguiente
                                                        ),
                                                      );
                                                      madeConnection();
                                                    }
                                                  : null, // Desactiva el botón si no hay conexión
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: _hasConnection && !_isLoading
                                                    ? Colors.grey[700]
                                                    : Colors.grey,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Text(
                                                "Sign Up",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],),
                                      
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
