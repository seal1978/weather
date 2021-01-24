import 'dart:convert';

Weather weatherFromJson(String str) => Weather.fromJson(
      json.decode(str),
    );

class Weather {
  Weather({this.city, this.temp, this.iconUrl, this.description, this.day});
  String city;
  int temp;
  List<dynamic> iconUrl;
  String description;
  String day;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        city: json['location']["name"] as String,
        temp: json['current']["temperature"] as int,
        iconUrl: json['current']["weather_icons"] as List<dynamic>,
        description: json['current']['weather_descriptions'][0] as String,
      );
}

 

