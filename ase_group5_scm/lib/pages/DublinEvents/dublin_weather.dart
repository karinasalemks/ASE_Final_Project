import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttericon/meteocons_icons.dart';

class DublinWeather extends StatefulWidget {
  final snapshot;

  const DublinWeather({Key? key, required this.snapshot}) : super(key: key);

  @override
  _DublinWeatherState createState() => _DublinWeatherState();
}

class _DublinWeatherState extends State<DublinWeather> {

  late BitmapDescriptor rainIcon;

  var noDays = 30;
  getMapIcon() async {
    rainIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/rain.png');}
  // List<Map<String, IconData>> _categories = [
  //   {
  //     'name': "Sports",
  //     'icon': rainIcon,
  //   },
  //   {
  //     'name': 'Politics',
  //     'icon': Icons.gavel,
  //   },
  //   {
  //     'name': 'Science',
  //     'icon': Icons.wb_sunny,
  //   },
  // ];
  void updateNumDays(num) {
    setState(() {
      noDays = num;
    });
  }

  @override
  Widget build(BuildContext context) {
    var forecast = widget.snapshot.docs[0].get("data");
    final sortedForecast =
        SplayTreeMap<String, dynamic>.from(forecast, (a, b) => a.compareTo(b));
    var dates = sortedForecast.keys.toList();
    // var weather_values = sortedForecast[dates[idx]];
    return Container(
        height: (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android)
            ? 800 :200,
        width: 500,
        child: Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: dates.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = dates.elementAt(index);
                  var weather_value = sortedForecast[key];
                  var warning = weather_value["warning"];
                  var date = DateTime.parse(key);
                  var currentDate = DateTime.now();

                  return Card(
                    child: ListTile(
                      contentPadding:EdgeInsets.fromLTRB(12, 12, 14, 18),
                       leading: weather_value["cloudiness"]>50 ?const Icon(
                        Meteocons.rain,
                        color: Colors.blue,
                        size: 64,):const Icon(
                         Icons.wb_sunny,
                         color: Colors.yellow,
                         size: 64,),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(14.0),
                      //   border:
                      //   Border.all(color: Colors.grey, width: 0.5),
                      // // ),
                      trailing: warning!=null ?   PopupMenuButton(
                          padding: const EdgeInsets.all(15.0),
                          icon: Icon(Icons.warning, color:Colors.red,size: 45,),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child:  Text("Certanity : ${warning["certainty"]} \n"
                                  "Description : ${warning["description"]} \n"
                                  "Onset : ${warning["onset"]} \n"
                                  "Expiry : ${warning["expiry"]} \n"
                                  "Type : ${warning["type"]} \n"
                                  "Status : ${warning["status"]} \n"
                                  "Headline : ${warning["headline"]} \n"
                                  "Level : ${warning["level"]} \n"
                              ),
                              value: 1,
                            ),
                          ]
                      ):null,
                      title:Text("$key") ,
                      isThreeLine: true,
                      subtitle: Text("Temperature: ${weather_value["max_temp"]} °C | ${weather_value["min_temp"]} °C \n "
                          "Rainfall: ${weather_value["rainfall"]} mm | ${weather_value["rain_prob"]}% \n "
                          "Wind Speed: ${weather_value["wind_speed"]} km/h \n"
                          "Cloudiness: ${weather_value["cloudiness"]}%"),),
                  );ListTile(
                    contentPadding:EdgeInsets.fromLTRB(12, 12, 12, 18),
                      leading: const Icon(
                          Icons.wb_sunny_rounded,
                          color: Colors.yellow,
                          size: 64,
                        ),
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(14.0),
                        //   border:
                        //   Border.all(color: Colors.grey, width: 0.5),
                        // // ),
                      trailing: warning!=null ? Text("Certanity : ${warning["certainty"]} \n"
                          "Description : ${warning["description"]} \n"
                          "Expiry : ${warning["expiry"]} \n"
                          "Type : ${warning["type"]} \n"
                          "Status : ${warning["status"]} \n"
                          "Headline : ${warning["headline"]} \n"
                          "Level : ${warning["level"]} \n"
                            ):null,
                      title:Text("$key") ,
                      isThreeLine: true,
                      subtitle: Text("Temperature: ${weather_value["max_temp"]} °C | ${weather_value["min_temp"]} °C \n "
                          "Rainfall: ${weather_value["rainfall"]} mm | ${weather_value["rain_prob"]}% \n "
                          "Wind Speed: ${weather_value["wind_speed"]} km/h \n"
                          "Cloudiness: ${weather_value["cloudiness"]}%")
                   );
                  //     padding: const EdgeInsets.all(5.0),
                  //     child: Column(
                  //       children: [
                  //         Text("$key"),
                  //         Container(
                  //           padding: EdgeInsets.all(5.0),
                  //           child: Icon(
                  //             Icons.wb_sunny_rounded,
                  //             color: Colors.yellow,
                  //             size: 64,
                  //           ),
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(14.0),
                  //             border:
                  //                 Border.all(color: Colors.grey, width: 0.5),
                  //           ),
                  //         ),
                  //         Text(
                  //             "${weather_value["max_temp"]} °C | ${weather_value["min_temp"]} °C"),
                  //         Text(
                  //             "${weather_value["rainfall"]} mm | ${weather_value["rain_prob"]}%"),
                  //         Text(
                  //             "wind speed: ${weather_value["wind_speed"]} km/h"),
                  //         Text("cloudiness: ${weather_value["cloudiness"]}%"),
                  //       ],
                  //     ));
                })));
  }
}
