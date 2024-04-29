import 'package:flutter/material.dart';
import 'package:ventura_front/screens/login/view.dart';
import 'package:ventura_front/services/repositories/locations_repository.dart';
import 'package:ventura_front/services/view_models/connection_viewmodel.dart';
import 'package:ventura_front/services/view_models/user_viewModel.dart';

class SignOutComponent extends StatelessWidget {

  static final UserViewModel _userViewModel = UserViewModel();
  static final ConnectionViewModel  _connectionViewModel = ConnectionViewModel();
  static final LocationRepository _locationsRepository = LocationRepository();

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
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
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: !isLoading && _connectionViewModel.isConnected() ? () {
                _userViewModel.signOut();
                isLoading = true;
                _locationsRepository.cleanCache();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginView(), // Reemplaza LoginView() con la pantalla siguiente
                  ),
                );
              } : null,
            )
          ],
        ));
  }

}
