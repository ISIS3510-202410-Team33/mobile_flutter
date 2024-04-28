import 'package:flutter/material.dart';
import 'package:ventura_front/mvvm_components/observer.dart';
import 'package:ventura_front/screens/loading/view.dart';
import 'package:ventura_front/services/view_models/connection_viewmodel.dart';

class LoadingNoConnectionView extends StatefulWidget {
  const LoadingNoConnectionView({super.key});

  @override
  State<LoadingNoConnectionView> createState() => LoadingNoConnectionState ();
}

class LoadingNoConnectionState extends State<LoadingNoConnectionView> implements EventObserver{

  ConnectionViewModel _connectionViewModel = ConnectionViewModel();

  @override
  initState() {
    super.initState();
    _connectionViewModel.subscribe(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectionViewModel.unsubscribe(this);
    
  }

  @override
  Widget build(BuildContext context) {
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Expanded(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
  
                children: [
                  
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 20,
                      ), 
                      Text(
                        'Trying to reconnect',
                        style: TextStyle(
                          color: Color.fromARGB(255, 53, 18, 59),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                              height: 20,
                            ),
                  
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage('lib/icons/goose-complete.png'),
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft,
                      ),
                    ),
                    child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        SizedBox(
                          width: double.infinity,
                        ),
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:  [
                            Text(
                              'Looks',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'like you',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'have no connection',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'to the internet',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                          ],
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

  @override
  void notify(ViewEvent event) {
    if (event is ConnectionEvent) {
      if (event.connection) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoadingView(),
          ), 
        );
        _connectionViewModel.unsubscribe(this);
      }
    }
  }
}