import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:ventura_front/mvvm_components/observer.dart';
import 'package:ventura_front/services/models/weather_model.dart';
import 'package:ventura_front/services/view_models/connection_viewmodel.dart';
import 'package:ventura_front/services/view_models/user_viewModel.dart';
import 'package:ventura_front/services/view_models/weather_viewmodel.dart';
import '../components/header_component.dart';
import './components/weather_component.dart';
import './components/university_component.dart';
import './components/options_component.dart';
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherViewModel(),
      child: const HomeViewContent(),
    );
  }
}

class HomeViewContent extends StatefulWidget {
  const HomeViewContent({super.key});

  @override
  State<HomeViewContent> createState() => HomeViewContentState();
}

class HomeViewContentState extends State<HomeViewContent>
    implements EventObserver {

  Position? position;
  late WeatherViewModel weatherViewModel;
  static final ConnectionViewModel _connectionViewModel = ConnectionViewModel();
  static final UserViewModel _userViewModel = UserViewModel();
  bool _hasConnection = true;

  Future<Position> determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getCurrentLocation() async {
    try {
      position = await determinePosition();
      weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
      await weatherViewModel.getWeather(
          position!.latitude, position!.longitude);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getWeather() async {
    try {
      weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
      await weatherViewModel.getWeather(
          position!.latitude, position!.longitude);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    madeConnection();
  }

  void madeConnection() {
    print("Home View");

    _connectionViewModel.subscribe(this);
    _connectionViewModel.isInternetConnected().then((value) {

      if(value){
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
      }
      else{
        notify(ConnectionEvent(connection: false));
      }
      setState(() {
        _hasConnection = value;
        if (weatherViewModel.weatherData != null) {
            weatherViewModel.weatherData!.signal = value;
          }
      });
    });
  }

  @override
  void dispose() {
    _connectionViewModel.unsubscribe(this);
    super.dispose();
  }

  
  @override
  void notify(ViewEvent event) {
    if (event is ConnectionEvent ) {
      if (event.connection ) {
        print("Conexión establecida");
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
            content: Text('You are connected again'),
          ),
        );
        setState(() {
          if (weatherViewModel.weatherData != null) {
            weatherViewModel.weatherData!.signal = true;
          }
        });
        getWeather();
      } else {
        print("Conexión perdida");
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(days: 1),
            backgroundColor: Colors.red,
            content: Text('No internet connection'),
          ),
        );
        setState(() {
          if (weatherViewModel.weatherData != null) {
            weatherViewModel.weatherData!.signal = false;
          }
        });
      }
      setState(() {
        _hasConnection = event.connection;
      });
    }
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
            padding:  EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Header(
                  showUserInfo: true,
                  user: _userViewModel.user,
                  showHomeIcon: false,
                  showLogoutIcon: true,
                  showNotiIcon: true,
                  homeViewContentState: this,
                ),
                const SizedBox(height: 20),
              
                Consumer<WeatherViewModel>(
                  builder: (context, weatherViewModel, _) {
                    final weatherData = weatherViewModel.weatherData;
                    if (weatherData != null) {
                      return Weather(
                        weather: weatherData,
                      );
                    } else if (_hasConnection) {
                      return const CircularProgressIndicator();
                    } else {
                      final model = WeatherModel(description: '', location: '', temperature: 0, feelsLike: 0, pressure: 0, humidity: 0, signal: false);
                      return Weather(weather: model);
                    }
                  },
                ),
                const SizedBox(height: 30),
                const University(),
                const SizedBox(height: 10),
                Expanded( // Envuelve el widget Options en Expanded
                  child: Options(homeViewContentState: this),
                ),
              ],
            ),
          ),
        ),
      );
  }

}
