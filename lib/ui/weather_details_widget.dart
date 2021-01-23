// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
 
// import 'package:weatherflut/model/weather.dart';

// final dayFormat = DateFormat('EEEE');

// class WeatherDetailsWidget extends StatelessWidget {
//   final String city;
//   final List<Weather> dummyData = [
//     Weather(temp:21,),Weather(temp:21,),Weather(temp:21,),Weather(temp:21,),Weather(temp:21,),Weather(temp:21,),
//   ];
//   WeatherDetailsWidget({Key key, this.city}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.7,
//       child: Align(
//         alignment: Alignment.bottomCenter,
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 30,
//             ),
//             Text(
//               'test',
//               // 'Pronóstico de ${city.weathers.length} Días',
//               style: TextStyle(
//                 fontWeight: FontWeight.w700,
//                 fontSize: 25,
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Expanded(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: 7,
//                 itemBuilder: (context, index) {
//                   // final weather = city.weathers[index];
//                   return Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Card(
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: Row(
//                               children: [
//                                 // Text(
//                                 //   dayFormat.format(
//                                 //     weather.applicableDate,
//                                 //   ),
//                                 //   style: TextStyle(
//                                 //     fontSize: 18,
//                                 //     fontWeight: FontWeight.w700,
//                                 //   ),
//                                 // ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10.0),
//                                   child: Image.network(
//                                    " https://assets.weatherstack.com/images/wsymbols01_png_64/wsymbol_0017_cloudy_with_light_rain.png",
//                                     // '${server}static/img/weather/png/64/${weather.weatherStateAbbr}.png',
//                                     // weather.iconUrl,
//                                     height: 25,
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Text(
//                                   // '${weather.theTemp.toInt().toString()}°C',
//                                   '21°C',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 17,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
  
//                           const SizedBox(
//                             height: 15,
//                           ),
  
//                           const SizedBox(
//                             height: 15,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
