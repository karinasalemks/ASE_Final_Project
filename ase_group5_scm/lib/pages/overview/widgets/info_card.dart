import 'package:flutter/material.dart';
import 'package:ase_group5_scm/constants/style.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color topColor;
  final bool isActive;
  final void Function()? onTap;

  const InfoCard(
      {Key? key,
      required this.title,
      required this.value,
      this.isActive = false,
      required this.onTap,
      this.topColor = Colors.black45})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 136,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 6),
                  color: lightGrey.withOpacity(.1),
                  blurRadius: 12)
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                    color: topColor,
                    height: 5,
                  ))
                ],
              ),
              Expanded(child: Container()),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: "$title\n",
                        style: TextStyle(
                            fontSize: 16, color: isActive ? active : dark)),
                    TextSpan(
                        text: "$value",
                        style: TextStyle(
                            fontSize: 24,
                            color: isActive ? active : dark,
                            fontWeight: FontWeight.bold)),
                  ])),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
