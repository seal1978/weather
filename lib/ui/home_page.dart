import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../model/weather.dart';
import 'ui_constants.dart';
import 'weather_details_widget.dart';

DateFormat format = DateFormat('E, dd MMM yyyy');

class HomePage extends StatefulWidget {
 

  const HomePage({
    Key key,
 
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> cities = ["Vancouver", "London", "Tokyo"];
  List<Weather> weathers = [];
  String tip;
  TextEditingController cityInputController = TextEditingController();
FocusNode _focus = FocusNode();

  void showDetail(weather,context) {
  _focus.unfocus(); 
    showModalBottomSheet(
      isScrollControlled: true,  
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            8.0,
          ),
        ),
      ),
      builder: (_) {
        return SingleChildScrollView( 
        // return Container(height: 200, color: Colors.blue);
       child: DetailWidget(weather:weather)
        );
      },
    );
  }

  handleCitySubmit({newCity}) async {
    _focus.unfocus(); 
    print(cityInputController.text);
    String newCity = cityInputController.text;
    if (cities.contains(newCity)) {
      cities.remove(newCity);
    }
    cities.add(newCity);
    await getWeathers();
    if (cities.length == weathers.length) {
      saveCity(cityInputController.text);
    } else {
      cities.remove(newCity);
      setState(() {
        tip = "There is no data of $newCity!";
      });
    }
    setState(() {});
  }

  Future getCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List citiesInLocal = prefs.getStringList("cities");
    if (citiesInLocal.length > 3)
      setState(() {
        cities = citiesInLocal;
      });
  }

  Future<void> saveCity(String city) async {
    if (cities.contains(city)) {
      throw Exception('The city already exists');
    }

    cities.add(city);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      "cities",
      cities,
    );
  }

  Future getWeathers() async {
    weathers = [];
    for (int i = cities.length - 1; i > -1; i--) {
      final url =
          'http://api.weatherstack.com/forecast?access_key=3b37b4d5e43ef10e4c7baacf8432775a&query=${cities[i]}';
      Response res = await get(url);
      // Response res = await get(weatherApiUrl);
      if (res.statusCode == 200) {
        Weather weather = Weather.fromJson(json.decode(res.body));
        print(
            "3${weathers.length} ${weather.city} ${weather.temp} ${weather.iconUrl}");
        weathers.add(weather);
      } else {
        throw "Can't get weather forecast";
      }
    }
  }

  initData() async {
    await getCities();
    print("1$cities");
    if (cities.length < 3) cities = ["Vancouver", "London", "Tokyo"];
    print("2$cities");
    await getWeathers();
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  Widget weatherItemWidget(weather,context) {
    TextStyle _textStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      shadows: shadows,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          // alignment: Alignment.,
          height: 100.0,
          width: 350,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 0.5),
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular((10.0))),

          // alignment: Alignment.center,
          // Stack(
          //   fit: StackFit.expand,
          //   children: [
          child: GestureDetector(
            onTap: () {
              showDetail(weather,context);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Image.network(
                    weather.iconUrl[0],
                    height: 25,
                  ),
                ),
                Center(
                  child: Text(
                    weather.city,
                    textAlign: TextAlign.center,
                    style: _textStyle,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Align(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                '${weather.temp}°C',
                                style: _textStyle,
                              ),
                            ),
                            Text(
                              weather.description,
                              style: _textStyle,
                            )
                          ],
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
    );
  }

  Widget weathersWidget(context) {
    return weathers.length > 0
        ? ListView.builder(
            itemCount: weathers.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: ( context, int index) {
              return Padding(
                  padding: const EdgeInsets.all(5),
                  child: weatherItemWidget(weathers[index],context)
                  // WeatherItem(
                  //   weather: weathers[index],
                  //   onTap: () => showDetail(index),
                  // )
                  );
            })
        : Container();
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
                  fillColor: Colors.grey[200],
                  suffixIcon: GestureDetector(
                    onTap: handleCitySubmit,
                    //  onTap: (){print(cityInputController.text);},
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
//          Column(
//            children: [
          Expanded(
            child: FutureBuilder(
                future: getWeathers(),
                builder: (context, weathers) {
                  return weathersWidget(context);
                }),
          )
          //    ],
          //  )
        ],
      ),
    ));
  }
}

class WeatherItem extends StatelessWidget {
  final Weather weather;
  final VoidCallback onTap;

  const WeatherItem({
    Key key,
    this.weather,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      shadows: shadows,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          // alignment: Alignment.,
          height: 100.0,
          width: 350,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 0.5),
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular((10.0))),

          // alignment: Alignment.center,
          // Stack(
          //   fit: StackFit.expand,
          //   children: [
          child: GestureDetector(
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Image.network(
                    weather.iconUrl[0],
                    height: 25,
                  ),
                ),
                Center(
                  child: Text(
                    weather.city,
                    textAlign: TextAlign.center,
                    style: _textStyle,
                  ),
                ),

                // Text(
                //   format.format(weather.applicableDate),
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     color: Colors.white,
                //     shadows: shadows,
                //   ),
                // ),
                const SizedBox(
                  height: 50,
                ),
                Align(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                '${weather.temp}°C',
                                style: _textStyle,
                              ),
                            ),
                            Text(
                              weather.description,
                              style: _textStyle,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Text(
                //   weather.weatherStateName,
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     color: Colors.white,
                //     shadows: shadows,
                //     fontSize: 22,
                //   ),
                // ),
                // const SizedBox(
                //   height: 70,
                // ),
              ],
            ),
          ),
          // Center(
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 30.0),
          //     child: IconButton(
          //       onPressed: onTap,
          //       icon: Icon(
          //         Icons.keyboard_arrow_up,
          //         color: Colors.white,
          //         size: 50,
          //       ),
          //     ),
          //   ),
          // ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Row(children: [
          //           Expanded(
          //             child: _WeatherItemDetails(
          //               title: 'Viento',
          //               value: "${weather.windSpeed.toStringAsFixed(2)} mph",
          //             ),
          //           ),
          //           Expanded(
          //             child: _WeatherItemDetails(
          //               title: 'Presión de aire',
          //               value: '${weather.airPressure.toStringAsFixed(2)} mbar',
          //             ),
          //           ),
          //           Expanded(
          //             child: _WeatherItemDetails(
          //               title: 'Humedad',
          //               value: '${weather.humidity}%',
          //             ),
          //           ),
          //         ]),
          //         const SizedBox(
          //           height: 15,
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: [
          //             _WeatherItemDetails(
          //               title: 'Temp min',
          //               value: weather.minTemp.toStringAsFixed(2),
          //             ),
          //             _WeatherItemDetails(
          //               title: 'Temp Max',
          //               value: weather.maxTemp.toStringAsFixed(2),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // ],
        ),
      ],
    );
  }
}

class _WeatherItemDetails extends StatelessWidget {
  final String city;
  final String value;

  const _WeatherItemDetails({Key key, this.city, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "city",
          style: TextStyle(color: Colors.white, shadows: shadows),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          "value",
          style: TextStyle(
            color: Colors.white,
            shadows: shadows,
          ),
        ),
      ],
    );
  }
}
