import 'dart:convert';

import 'package:flutter_weather_bg/flutter_weather_bg.dart';

Weather weatherFromJson(String str) => Weather.fromJson(
      json.decode(str),
    );

class Weather {
  Weather(
      {this.city,
      this.localTime,
      this.temp,
      this.iconUrl,
      this.description,
      this.day,
      this.weatherCode,
      this.animaType});
  String city;
  int localTime;
  int temp;
  List<dynamic> iconUrl;
  String description;
  String day;
  int weatherCode;
  WeatherType animaType;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        city: json['location']["name"] as String,
        localTime: json['location']["localtime_epoch"] as int,
        temp: json['current']["temperature"] as int,
        iconUrl: json['current']["weather_icons"] as List<dynamic>,
        description: json['current']['weather_descriptions'][0] as String,
        weatherCode: json['current']['weather_code'] as int,
      );
}
