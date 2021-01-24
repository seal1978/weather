import 'package:flutter/material.dart';
import 'package:weather/ui/widgets.dart';

import '../model/weather.dart';
import 'ui_constants.dart';

class DetailWidget extends StatelessWidget {
  final List<Weather> weathers;

  DetailWidget({Key key, this.weathers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: Icon(Icons.close_outlined),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
              ),
              Text(
                weathers[0].city,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: weatherPicWidget(weathers[0].iconUrl[0], 70),
              ),
              Text(
                "${weathers[0].temp.toString()}°C",
                style: textStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 120,
                                  child:
                                      Text(weathers[index].day, style: textStyle),
                                ),
                                Text('${weathers[index].temp.toString()}°C',
                                    style: textStyle),
                                weatherPicWidget(weathers[0].iconUrl[0], 30),
                                //  SizedBox(width:20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
