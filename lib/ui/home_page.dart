import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';

import '../model/weather.dart';
import 'list_item_widget.dart';
import 'loader_widget.dart';

import 'weather_details_widget.dart';
import 'widgets.dart';

DateFormat format = DateFormat('E, dd MMM yyyy');

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<String> cities = ["Vancouver", "London", "Tokyo"];
  List<Weather> weathers = [];
  List<Weather> dummyWeathers = [];
  TextEditingController cityInputController = TextEditingController();
  FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    initData();
    WidgetsBinding.instance.addObserver(this); //monitor status of APP
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("--" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive:
        print("AppLifecycleState.inactive");
        break;
      case AppLifecycleState.resumed:
        print("AppLifecycleState.resumed");

        ///if resume, will reload the weathers data
        setState(() {});
        break;
      case AppLifecycleState.paused:
        print("AppLifecycleState.paused");
        break;
      case AppLifecycleState.detached:
        print("AppLifecycleState.detached");
        break;
    }
  }

  ///init Data
  initData() async {
    cities = await getCities();
    if (null == cities) cities = ["Vancouver", "London", "Tokyo"];
  }

  void showDetail(weather, context) {
    generateDummyData(weather);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      builder: (_) {
        return SingleChildScrollView(
            child: DetailWidget(weathers: dummyWeathers));
      },
    );
  }

  handleCitySubmit({newCity}) async {
    _focus.unfocus();
    // print(cityInputController.text);
    String newCity = cityInputController.text;
    Weather weather = await getWeather(newCity);
    if (weather.city != "615") {
      cities.add(newCity);
      weathers.add(weather);
      for (int i = 0; i < weathers.length - 1; i++) {
        //remove the same city data
        if (weathers[i].city == weather.city) {
          weathers.removeAt(i);
          cities.removeAt(i);
        }
      }
      cityInputController.text = ""; //clear search word
      setState(() {});
      saveCities(cities); // save city data to local
    } else {
      showToast(context);
    }
  }

  ///localize data
  Future getCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cities = prefs.getStringList("cities");
    return cities;
  }

  Future<void> saveCities(List<String> cities) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      "cities",
      cities,
    );
  }

  ///API
  Future getWeather(city) async {
    final url =
        'http://api.weatherstack.com/forecast?access_key=3b37b4d5e43ef10e4c7baacf8432775a&query=$city';
    Response res = await get(url);
    print(res.statusCode);
    print(res.body);
    Weather weather;

    if (res.statusCode == 200) {
      if (res.body.contains("success")) {
        //treat when wrong city name input to API, but the API feedback "200"
        weather = Weather(city: "615");
      }
      if (res.body.contains("weather_descriptions")) {
        // status:ok
        weather = Weather.fromJson(json.decode(res.body));
        weather.animaType = getAnimaType(weather.weatherCode);
      }

    } else {
      //treat wrong
      weather = Weather(city: "615");
      throw "Can't get weather forecast";
    }
    return weather;
  }

 

  getAnimaType(int code) {
    WeatherType animaType;
    if ((code > 373 && code < 390) ||
        (code > 352 && code < 366) ||
        code == 308 ||
        code == 305) animaType = WeatherType.heavyRainy;

    if (code == 395 ||
        code == 371 ||
        code == 368 ||
        (code < 351 && code > 335) ||
        code == 230 ||
        code == 227) animaType = WeatherType.heavySnow;
    if (code == 392 || code == 332 || code == 329)
      animaType = WeatherType.middleSnow;
    if (code == 200) animaType = WeatherType.thunder;

    if (code == 311 ||
        (code < 297 && code > 262) ||
        code == 185 ||
        code == 182 ||
        code == 176) animaType = WeatherType.lightRainy;
    if (code == 326 || code == 323) animaType = WeatherType.lightSnow;
    // if (code ==  296|| code == 2)animaType = WeatherType.sunnyNight;
    if (code < 117) animaType = WeatherType.sunny;

    if (code == 119) animaType = WeatherType.cloudy;
    //if (code ==  296|| code == 2)animaType = WeatherType.cloudyNight;
    if ((code < 321 && code > 313) || code == 302 || code == 299 || code == 179)
      animaType = WeatherType.middleRainy;
    if (code == 122) animaType = WeatherType.overcast;

    if (code == 143) animaType = WeatherType.hazy;
    if (code == 248 || code == 260) animaType = WeatherType.foggy;
    // if (code ==  143)animaType = WeatherType.dusty;

    return animaType;
  }

  Future getWeathers() async {
    weathers = [];

    for (int i = 0; i < cities.length; i++) {
      Weather weather = await getWeather(cities[i]);
      if (weather.city != "615") {
        weathers.add(weather);
        print(weather.city);
        print(i);
        print(cities.length);
        print(weathers.length);
      }
    }
  }

  generateDummyData(weather) {
    DateTime dateTime = DateTime.now();
    // print(dateTime);
    // int nowS = DateTime.now().millisecondsSinceEpoch;
    // print(nowS);
    // print(DateTime.fromMillisecondsSinceEpoch(nowS));

    weather.day = dateTime.format('l');
    dummyWeathers = [weather];
    for (int i = 0; i < 6; i++) {
      final _rand = new Random();
      int temp = weather.temp - 5 + _rand.nextInt(10);
      dateTime = dateTime.add(Duration(days: 1));
      Weather randomWeather = Weather(temp: temp, day: dateTime.format('l'));
      dummyWeathers.add(randomWeather);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ///UI
  Widget weathersWidget(context) {
    return weathers.length > 0
        ? ListView.builder(
            itemCount: weathers.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, int index) {
              int indexReversed = weathers.length - 1 - index;
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                  child: ListItemWidget(
                      weather: weathers[indexReversed],
                      onTap: () {
                        showDetail(weathers[indexReversed], context);
                      }));
            })
        : LoaderWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: TextField(
                keyboardType: TextInputType.name,
                controller: cityInputController,
                onSubmitted: (v) {
                  handleCitySubmit(newCity: v);
                },
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  filled: true,
                  hintText: 'Search City',
                  fillColor: Colors.grey[300],
                  suffixIcon: GestureDetector(
                    onTap: handleCitySubmit,
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              FutureBuilder(
                  future: getWeathers(),
                  builder: (context, weathers) {
                    return weathersWidget(context);
                  }),
            ],
          ),
        ],
      ),
    ));
  }
}
