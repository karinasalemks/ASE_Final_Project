import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ase_group5_scm/constants/style.dart';

/// Example without datasource
class EventsTable extends StatefulWidget {
  final snapshot;

  const EventsTable({Key? key, required this.snapshot}) : super(key: key);

  @override
  _EventsTableState createState() => _EventsTableState();
}

class _EventsTableState extends State<EventsTable> {
  List eventLocation = ["Aviva Stadium", "Bord Gais Energy Theatre", "Gaiety Theatre", "National Stadium", "3Arena"];
  List eventCount = [0, 0, 0, 0, 0];
  List capacity = [0, 0, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    if (widget.snapshot.docs.length > 0) {
      var eventList = widget.snapshot.docs;
      for (int i = 0; i < eventList.length; i++) {
        var events = eventList[i].get("events");
        var location_name = eventList[i].get("location_name");
        switch(location_name) {
          case "Aviva Stadium":
            //Dublin 4
            eventCount[0] = events.length;
            capacity[0] = 51700;
            break;
          case "Bord Gais Energy Theatre":
            //Dublin 2
            capacity[1] = 2111;
            eventCount[1] = events.length;
            break;
          case "Gaiety Theatre":
            //Dublin 2
            capacity[2] = 1145;
            eventCount[2] = events.length;
            break;
          case "National Stadium":
            //Dublin 8
            capacity[3] = 2000;
            eventCount[3] = events.length;
            break;
          case "3Arena":
            //Dublin 1
            capacity[4] = 13000;
            eventCount[4] = events.length;
            break;
        }
      }
    }
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
          columnSpacing: 10,
          horizontalMargin: 12,
          minWidth: 320,
          columns: [
            DataColumn2(
              label: Text("Event Location"),
            ),
            DataColumn(
              label: Text('No of Events'),
            )
          ],
          rows: List<DataRow>.generate(
              eventLocation.length,
                  (index) => generateEventRows(eventLocation[index], eventCount[index], capacity[index])),
      ),
    );
  }
}

DataRow generateEventRows(var location, var count, var capacity) {
  return DataRow(
      cells: [
        DataCell(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("$location"),
            Row(
              children: [
                Text(
                    "Capcity:$capacity")
              ],
            ),
          ],
        )),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("$count")
          ],
        )
        )
      ]);
}