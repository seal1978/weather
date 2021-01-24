import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:weather/ui/screen.dart';

import '../model/weather.dart';
import 'loader_widget.dart';
import 'ui_constants.dart';
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
        getWeathers(); //if resume, will reload the weathers data
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
    // await getWeathers();
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
      }
      // ErrorInfo err = ErrorInfo.fromJson(json.decode(res.body));
      // if (!err.success) {
      //   //treat when wrong city name input to API, but the API feedback "200"
      //   weather = Weather(city: "615");
      // } else {
      //   // "200"and get info
      //   weather = Weather.fromJson(json.decode(res.body));
      // }
    } else {
      //treat wrong
      weather = Weather(city: "615");
      throw "Can't get weather forecast";
    }
    return weather;
  }

  Future getWeathers() async {
    weathers = [];
    for (int i = 0; i < cities.length; i++) {
      Weather weather = await getWeather(cities[i]);
      if (weather.city != "615") weathers.add(weather);
      // print(
      //     "3${weathers.length} ${weather.city} ${weather.temp} ${weather.iconUrl}");
    }
  }

  generateDummyData(weather) {
    DateTime dateTime = DateTime.now();
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
  Widget weatherItemWidget(weather, context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 100.0,
          width: Adapt.px(364),
          decoration: BoxDecoration(
              // border: Border.all(color: Colors.white, width: 0.5),
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular((10.0))),
          child: GestureDetector(
            onTap: () {
              showDetail(weather, context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding:  EdgeInsets.symmetric(horizontal: Adapt.px(5)),
                    child: weatherPicWidget(weather.iconUrl[0], 50)),
                SizedBox(
                  width: 100,
                  child: Center(
                    child: Text(
                      weather.city,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Align(
                          child: Text(
                            '${weather.temp}°C',
                            style: textStyle,
                          ),
                        ),
                        Wrap(children:[Text(
                          weather.description,
                          textAlign: TextAlign.center,
                          style: textStyle,
                        )])
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
                  child: weatherItemWidget(weathers[indexReversed], context));
            })
        // : Container();
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
