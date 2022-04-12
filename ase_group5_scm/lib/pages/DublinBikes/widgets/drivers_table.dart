import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ase_group5_scm/constants/style.dart';
import 'package:ase_group5_scm/widgets/custom_text.dart';

/// Example without datasource
class DriversTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  (index) => DataRow(cells: [
                        DataCell(CustomText(text: "Santos Enoque")),
                        DataCell(CustomText(text: "New yourk city")),
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
                            CustomText(
                              text: "4.5",
                            )
                          ],
                        )),
                      ]))),
    );
  }
}
