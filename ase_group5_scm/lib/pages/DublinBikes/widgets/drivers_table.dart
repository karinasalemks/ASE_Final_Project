import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ase_group5_scm/constants/style.dart';
import 'package:ase_group5_scm/widgets/custom_text.dart';

/// Example without datasource
class DriversTable extends StatefulWidget {
  final snapshot;
  const DriversTable({Key? key, required this.snapshot}) : super(key: key);

  @override
  _DriversTableState createState() => _DriversTableState();
  }

  class _DriversTableState extends State<DriversTable>{

  @override
  Widget build(BuildContext context) {
    var bike_swap_suggestions = widget.snapshot.docs[0].get("swap_suggestions")[0]['free_stations'];


    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: active.withOpacity(.4), width: .5),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 6),
              color: lightGrey.withOpacity(.1),
              blurRadius: 12)
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 30),
      child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 600,
              columns: [
                DataColumn2(
                  label: Text("Source Station"),
                  size: ColumnSize.L,
                ),
                DataColumn(
                  label: Text('Swap Suggestion'),
                ),
                DataColumn(
                  label: Text('Distance'),
                ),
              ],
              rows: List<DataRow>.generate(
                  5,
                  (index) => generateSuggestionRow(bike_swap_suggestions[index])),
    ));
  }
}

DataRow generateSuggestionRow(swap_suggestions){
  var source_station = swap_suggestions["occupied_station"];
  var source_station_name = source_station["station_name"];
  var source_station_occupancy = source_station["occupancy"];
  var source_station_ab = source_station["available_bikes"];
  var dst_station = swap_suggestions["suggested_station"];
  var dst_station_occupancy = dst_station["occupancy"];
  var dst_station_ab = dst_station["available_bikes"];
  var dst_station_name = dst_station["station_name"];
  var distance=source_station["distance"].toString();

  return DataRow(
      cells: [
        DataCell( Column(
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
        )),
       DataCell(Column(
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
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.social_distance,
              color: Colors.deepOrange,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Text(distance)
          ],
        )
       )]);
 }
