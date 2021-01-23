import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

 

import '../model/weather.dart';

// // class DetailWidget extends StatelessWidget {
// //   final Weather weather;
// //   DetailWidget({Key key, @required this.weather}) : super(key: key);
// class DetailWidget extends StatefulWidget {
//   // final List<String> cities;
//   // final VoidCallback onTap;
//   final Weather weather;
//   const DetailWidget({Key key, this.weather
//       // this.cities,
//       // this.onTap,
//       })
//       : super(key: key);

//   @override
//   _DetailWidgetState createState() => _DetailWidgetState();
// }

// class _DetailWidgetState extends State<DetailWidget> {
//   List<Weather> dummyWeathers = [];

//   generateDummyData() {
//     dummyWeathers.add(widget.weather);
//     for (int i = 0; i < 7; i++) {
//       final _rand = new Random();
//       int temp = widget.weather.temp - 5 + _rand.nextInt(10);
//       Weather randomWeather = Weather(temp: temp);
//       dummyWeathers.add(randomWeather);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     generateDummyData();
//     return Scaffold(
//      body:Column(
//        children: [
//          Row(children: [
// Text(dummyWeathers[0].city)
//          ],),
//                   Row(children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   child: Image.network(
//                     dummyWeathers[0].iconUrl[0],
//                     height: 25,
//                   ),
//                 ),
//          ],),
//                   Row(children: [
// Text(dummyWeathers[0].temp.toString())
//          ],),
//          ListView.builder(
//               itemCount: dummyWeathers.length,
//               itemBuilder: (context, index) {
//                 return ListTile(title: Text(dummyWeathers[index].temp.toString()),);
//               },
//             ),
//        ],
//     ));
//   }
// }
// final dayFormat = DateFormat('EEEE');

class DetailWidget extends StatelessWidget {
  final Weather weather;
  // final List<Weather> dummyData = [weather,
  //   Weather(temp:21,),Weather(temp:21,),Weather(temp:21,),Weather(temp:21,),Weather(temp:21,),Weather(temp:21,),
  // ];
  DetailWidget({Key key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(weather.city,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 7,
                itemBuilder: (context, index) {
                  // final weather = city.weathers[index];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                // Text(
                                //   dayFormat.format(
                                //     weather.applicableDate,
                                //   ),
                                //   style: TextStyle(
                                //     fontSize: 18,
                                //     fontWeight: FontWeight.w700,
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Image.network(
                                   " https://assets.weatherstack.com/images/wsymbols01_png_64/wsymbol_0017_cloudy_with_light_rain.png",
                                    // '${server}static/img/weather/png/64/${weather.weatherStateAbbr}.png',
                                    // weather.iconUrl,
                                    height: 25,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  // '${weather.theTemp.toInt().toString()}°C',
                                  '21°C',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
