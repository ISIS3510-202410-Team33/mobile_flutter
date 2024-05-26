import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:ventura_front/screens/home/view.dart";
import "package:ventura_front/services/view_models/profile_viewmodel.dart";
import "package:ventura_front/services/view_models/user_viewModel.dart";

import '../components/header_component.dart';
import '../home/components/university_component.dart';
import "components/progress_bar.dart";

class ProfileView extends StatelessWidget {
  final HomeViewContentState homeViewContentState;
  const ProfileView({super.key, required this.homeViewContentState});

  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: ProfileViewContent(homeViewContentState: homeViewContentState),
    );
  }
}

class ProfileViewContent extends StatefulWidget {
  final HomeViewContentState homeViewContentState;
  const ProfileViewContent({super.key, required this.homeViewContentState});

  @override
  State<ProfileViewContent> createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileViewContent> {
  static final UserViewModel _userViewModel = UserViewModel();
  late ProfileViewModel profileViewModel;
  @override
  void initState() {
    super.initState();
    loadDatos();
  }


  void loadDatos() async {
    profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    await profileViewModel.loadCalorias();
    await profileViewModel.loadPasos();
    await profileViewModel.loadImage();
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
              style: const TextStyle(color: Colors.white, fontSize: 20))
        else if (id == 1)
          Text(
              "Today steps:    " +
                  '${profileViewModel.pasosHoy}' +
                  '/' +
                  '${profileViewModel.pasos}',
              style: const TextStyle(color: Colors.white, fontSize: 20)),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Daily goal"),
                  content: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
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
                      child: const Text("Save"),
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
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top+ 10,
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
                  user: _userViewModel.user,
                  showHomeIcon: true,
                  showLogoutIcon: true,
                  showNotiIcon: true,
                  homeViewContentState: widget.homeViewContentState,
                ),
                const SizedBox(height: 20),
                
                GestureDetector(
                  onTap: () async {
                    await profileViewModel.pickImage();
                    setState(() {});
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: profileViewModel.image != null
                        ? Image.file(profileViewModel.image!).image
                        : AssetImage('lib/icons/perfil-de-usuario.png'),
                    backgroundColor: Colors.grey,
                  ),
                ),


                const SizedBox(height: 20),
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
                            const Icon(Icons.account_circle,
                                color: Colors.white, size: 30),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    _userViewModel.user.name[0].toUpperCase() +
                                        _userViewModel.user.name.substring(1),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ],
                            ),
                          ],
                        ))),
                const SizedBox(height: 20),
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
                            const Icon(Icons.email, color: Colors.white, size: 30),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Email",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                                Text(_userViewModel.user.email,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14)),
                              ],
                            ),
                          ],
                        ))),
                const SizedBox(height: 20),
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
                            const Icon(Icons.home,
                                color: Colors.white, size: 30),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Universidad de los Andes",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ],
                            ),
                          ],
                        ))),
                const SizedBox(height: 20),
                editar(1), //pasos
                const SizedBox(height: 10),
                ProgressBarY(
                    valor: profileViewModel.pasosHoy / profileViewModel.pasos),
                const SizedBox(height: 20),
                editar(0), //calorias
                const SizedBox(height: 10),
                ProgressBarY(
                    valor: profileViewModel.caloriasHoy /
                        profileViewModel.calorias),
                const SizedBox(height: 10),
                const Text(
                    "This information is stored locally",
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