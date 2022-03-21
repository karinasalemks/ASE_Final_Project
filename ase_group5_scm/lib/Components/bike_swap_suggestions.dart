import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class BikeSwapSuggestions extends StatelessWidget {
  const BikeSwapSuggestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFF9CBFC9),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),

      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Bikes_Swap_Suggestions').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              var bike_swap_suggestions = snapshot.data!.docs[0].get("swap_suggestions")[0];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                  child: Container(

                    padding: EdgeInsets.all(5.0),

                  
                    width: double.infinity,
                    child: generateDataTable2(bike_swap_suggestions["occupied_stations"]),
                    color: Color(0xFF9CBFC9),
                    alignment: Alignment.center,
                  )
                  ),
                  SizedBox(
                    height:20
                  ),
                  SizedBox(
                  child: Container(

                    padding: EdgeInsets.all(5.0),

                    width: double.infinity,
                    child: generateDataTable(bike_swap_suggestions["free_stations"]),
                    color: Color(0xFF9CBFC9),
                    alignment: Alignment.center,
                  ),
                  )
                ],
              );
            }
            else{
              return Text("Shubham");
            }
          }
      ),
    );
  }
}


//  for occupied stations

DataTable2 generateDataTable(bike_swap_suggestions){
  return DataTable2(
    border: TableBorder(top:BorderSide(color: Colors.black, width: 3),
        bottom: BorderSide(color: Colors.black, width: 3),
        horizontalInside: BorderSide(color: Colors.black, width: 1),
        verticalInside: BorderSide(color: Colors.black, width: 1),
        left:BorderSide(color: Colors.black, width: 3),
        right:BorderSide(color: Colors.black, width: 3),),
    columnSpacing: 16.0,

    columns: [

      DataColumn(
        label: Text("Source Station"),
      ),
      DataColumn(
        label: Text("Distance"),
      ),
      DataColumn(
        label: Text("Swap Suggestions"),
      ),
    ],
    rows: List.generate(5, (index) => generateSuggestionRow(bike_swap_suggestions[index])),
  );
}

// for free stations
DataTable2 generateDataTable2(bike_swap_suggestions){
  return DataTable2(
    border: TableBorder(top:BorderSide(color: Colors.black, width: 3),
      bottom: BorderSide(color: Colors.black, width: 3),
      horizontalInside: BorderSide(color: Colors.black, width: 1),
      verticalInside: BorderSide(color: Colors.black, width: 1),
      left:BorderSide(color: Colors.black, width: 3),
      right:BorderSide(color: Colors.black, width: 3),),
    columnSpacing: 16.0,
    columns: [
      DataColumn(
        label: Text("Swap Suggestions"),
      ),
      DataColumn(
        label: Text("Distance"),
      ),
      DataColumn(
        label: Text("Source Station"),
      ),
    ],
    rows: List.generate(5, (index) => generateSuggestionRow(bike_swap_suggestions[index])),
  );
}



DataRow generateSuggestionRow(swap_suggestions){
  var source_station = swap_suggestions["occupied_station"];
  var source_station_name = source_station["station_name"];
  var source_station_occupancy = source_station["occupancy"];
  var source_station_ab = source_station["available_bikes"];
  var dst_station = swap_suggestions["suggested_station"];
  var dst_station_name = dst_station["station_name"];
  var dst_station_occupancy = dst_station["occupancy"];
  var dst_station_ab = dst_station["available_bikes"];
  var distance=source_station["distance"];

  return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(source_station_name),
              Row(
                children: [
                  Text("Occupancy: $source_station_occupancy | Available Bikes: $source_station_ab")
                ],
              ),
            ],
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("$distance Km"),
            ],
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(dst_station_name),
              Row(
                children: [
                  Text("Occupancy: $dst_station_occupancy | Available Bikes: $dst_station_ab")
                ],
              ),
            ],
          ),
        ),
      ]
  );
}
