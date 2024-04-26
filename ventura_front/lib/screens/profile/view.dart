import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:provider/provider.dart";
import "package:ventura_front/services/models/user_model.dart";
import "package:ventura_front/services/repositories/user_repository.dart";
import "package:ventura_front/services/view_models/profile_viewmodel.dart";

import '../components/header_component.dart';
import '../home/components/university_component.dart';
import "components/progress_bar.dart";

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: ProfileViewContent(),
    );
  }
}

class ProfileViewContent extends StatefulWidget {
  @override
  State<ProfileViewContent> createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileViewContent> {
  UserModel user = UserModel(uuid: 0, name: "Default", studentCode: 0);

  late ProfileViewModel profileViewModel;

  final UserModel _user = UserRepository.getState().state;
  @override
  void initState() {
    super.initState();
    loadDatos();
    user = _user;
  }

  void loadDatos() async {
    profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    await profileViewModel.loadCalorias();
    await profileViewModel.loadPasos();
    setState(() {});
  }

  void setPasos(int n) async {
    await profileViewModel.setPasos(n);
    setState(() {});
  }

  void setCalorias(int n) async {
    await profileViewModel.setCalorias(n);
    setState(() {});
  }

  Widget editar(int id) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (id == 0)
          Text(
              "Today lost calories:    " +
                  '${profileViewModel.caloriasHoy}' +
                  '/' +
                  '${profileViewModel.calorias}',
              style: TextStyle(color: Colors.white, fontSize: 20))
        else if (id == 1)
          Text(
              "Today steps:    " +
                  '${profileViewModel.pasosHoy}' +
                  '/' +
                  '${profileViewModel.pasos}',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Daily goal"),
                  content: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Only numbers",
                    ),
                    onChanged: (value) {
                      if (id == 0) {
                        setCalorias(int.parse(value));
                      } else if (id == 1) {
                        setPasos(int.parse(value));
                      }
                      ;
                    },
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Save"),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF16171B), Color(0xFF353A40)],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Header(
                  showUserInfo: false,
                  user: user,
                  showHomeIcon: true,
                  showLogoutIcon: true,
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF353A40), width: 1.5),
                  ),
                  child: const CircleAvatar(
                    radius: 80,
                    backgroundImage:
                        AssetImage('lib/icons/perfil-de-usuario.png'),
                  ),
                ),
                SizedBox(height: 20),
                const University(),
                SizedBox(height: 20),
                Material(
                    color: const Color(0xFF262E32),
                    elevation: 10,
                    shadowColor: Colors.black,
                    borderRadius: BorderRadius.circular(60),
                    child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFF262E32),
                            borderRadius: BorderRadius.circular(60)),
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 50, right: 50),
                        child: Row(
                          children: [
                            Icon(Icons.account_circle,
                                color: Colors.white, size: 30),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    user.name[0].toUpperCase() +
                                        user.name.substring(1),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ],
                            ),
                          ],
                        ))),
                SizedBox(height: 20),
                Material(
                    color: const Color(0xFF262E32),
                    elevation: 10,
                    shadowColor: Colors.black,
                    borderRadius: BorderRadius.circular(60),
                    child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFF262E32),
                            borderRadius: BorderRadius.circular(60)),
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 50, right: 50),
                        child: Row(
                          children: [
                            Icon(Icons.email, color: Colors.white, size: 30),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Email",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                                Text(user.name,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14)),
                              ],
                            ),
                          ],
                        ))),
                SizedBox(height: 20),
                editar(1), //pasos
                SizedBox(height: 10),
                ProgressBarY(
                    valor: profileViewModel.pasosHoy / profileViewModel.pasos),
                SizedBox(height: 20),
                editar(0), //calorias
                SizedBox(height: 10),
                ProgressBarY(
                    valor: profileViewModel.caloriasHoy /
                        profileViewModel.calorias),
                SizedBox(height: 10),
                Text(
                    "This information is stored locally and will be deleted at 12:00am of each day.",
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
