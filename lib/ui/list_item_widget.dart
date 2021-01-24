import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:weather/ui/screen.dart';
import 'package:weather/ui/widgets.dart';

import 'ui_constants.dart';

class ListItemWidget extends StatelessWidget {
  final weather;
  final onTap;
 
  ListItemWidget({
    Key key,
    @required this.weather,
    @required this.onTap,
    
  }) : super(key: key);

  Widget weatherItemWidget(weather, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 100.0,
          width: Adapt.px(330),
          // child: GestureDetector(
          //   onTap: onTap,
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
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
      ),
    );
  }
}
