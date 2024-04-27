import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/services.dart";

import "package:ventura_front/screens/home/view.dart";
import "package:ventura_front/services/view_models/connection_viewmodel.dart";
import "package:ventura_front/services/view_models/user_viewModel.dart";

import "../../mvvm_components/observer.dart";
import "../../services/repositories/user_repository.dart";


class  SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State createState() => SignUpViewState();
}

class SignUpViewState extends State<SignUpView> implements EventObserver{

  final UserViewModel _viewModel = UserViewModel();
  bool _isLoading = true;
  bool _hasConnection = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  static final ConnectionViewModel _connectionViewModel = ConnectionViewModel();
 
  @override
  void initState() {
    super.initState();
    _viewModel.subscribe(this);
    _connectionViewModel.subscribe(this);
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.unsubscribe(this);
  }

  @override
  void notify(ViewEvent event) {  

    if (event is ConnectionEvent) {
    setState(() {
      _hasConnection = event.connection; // Actualiza el estado de la conexión
    });
    }
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
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      _viewModel.signIn(email, password);

    } else if (event is SignUpFailedEvent) {
      print("Failed");
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
    } else if (event is SignInSuccessEvent) {
      print("Success sign in");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeView(), // Reemplaza LoginView() con la pantalla siguiente
        ),
      );
    } else if (event is SignInFailedEvent) {
      print("No Credentials");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SignUpView(), // Reemplaza LoginView() con la pantalla siguiente
        ),
      );
    }
    if (event is ConnectionEvent) {
      if (event.connection){
        print("Conexión establecida");
        // Conexión restablecida, mostrar mensaje en verde
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('You are connected again'),
        ),
      );
      }
      else {
        print("Conexión perdida");
        // Conexión perdida, mostrar mensaje en rojo
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('You can\'t sign up because you don\'t have connection'),
        ),
      );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: () async {
        if (! _hasConnection) {
          // Si no hay conexión, evita el retroceso
          return false;
        } else {
          // Si hay conexión, permite el retroceso
          return true;
        }
      },
      child: Container(
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
                        Column(
                          children: [
                            const SizedBox(
                              height: 30,
                              width: double.infinity,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: [
                                    _hasConnection
                                      ? BackButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            )
                          ],
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
                                  children: [
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
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: _hasConnection
                                                ? () {
                                                    final email = emailController.text.trim();
                                                    final password = passwordController.text.trim();
                                                    _viewModel.signIn(email, password);
                                                  }
                                                : null, // Desactiva el botón si no hay conexión
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey[700],
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
      ),
    );
  }
}
