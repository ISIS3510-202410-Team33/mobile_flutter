import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";
import "../../mvvm_components/observer.dart";
import "../../services/repositories/locations_repository.dart";
import "../../services/view_models/locations_viewmodel.dart";

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State createState() => NotificationViewState();
}

class NotificationViewState extends State<NotificationView> implements EventObserver{
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Lógica para regresar a la pantalla anterior
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          _launchURL(); // Llama a la función para abrir la URL al hacer clic
        },
        child: Text(
          "Your most recommended location is ML Building",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ),
  ],
),
      ),
    );
  }

  _launchURL() async {
  const url = 'https://campusinfo.uniandes.edu.co/es/recursos/edificios/bloqueml'; 
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


  @override
  void notify(ViewEvent event) {
    // TODO: implement notify
  }


}