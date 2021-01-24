import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:weather/ui/screen.dart';
import 'package:weather/ui/widgets.dart';

import 'ui_constants.dart';
import 'weather_details_widget.dart';

class ListItemWidget extends StatelessWidget {
  final weather;
  final onTap;
  ListItemWidget({
    Key key,
    @required this.weather,
    @required this.onTap,
  }) : super(key: key);

  // void showDetail(weather, context) {
  //   generateDummyData(weather);
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(12),
  //       ),
  //     ),
  //     builder: (_) {
  //       return SingleChildScrollView(
  //           child: DetailWidget(weathers: dummyWeathers));
  //     },
  //   );
  // }
  //   generateDummyData(weather) {
  //   DateTime dateTime = DateTime.now();
  //   weather.day = dateTime.format('l');
  //   dummyWeathers = [weather];
  //   for (int i = 0; i < 6; i++) {
  //     final _rand = new Random();
  //     int temp = weather.temp - 5 + _rand.nextInt(10);
  //     dateTime = dateTime.add(Duration(days: 1));
  //     Weather randomWeather = Weather(temp: temp, day: dateTime.format('l'));
  //     dummyWeathers.add(randomWeather);
  //   }
  // }

  Widget weatherItemWidget(weather, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 100.0,
          width: Adapt.px(330),
          child: GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: Adapt.px(5)),
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
                        Wrap(children: [
                          Text(
                            weather.description,
                            textAlign: TextAlign.center,
                            style: textStyle,
                          )
                        ])
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ClipPath(
        child: Stack(
          children: [
            WeatherBg(
              weatherType: weather.animaType,
              width: MediaQuery.of(context).size.width,
              // width: MediaQuery.of(context).size.width*0.9,
              height: 100,
            ),
            weatherItemWidget(weather, context)
          ],
        ),
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)))),
      ),
    );
  }
}
