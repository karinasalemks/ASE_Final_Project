import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ase_group5_scm/constants/style.dart';
import 'package:ase_group5_scm/helpers/reponsiveness.dart';
import 'package:logging/logging.dart';
import 'custom_text.dart';

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(
      leading: !ResponsiveWidget.isSmallScreen(context)
          ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Image.asset(
                    "assets/icons/logo.png",
                    width: 28,
                  ),
                ),
              ],
            )
          : IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                key.currentState!.openDrawer();
              }),
      title: Container(
        child: Row(
          children: [
            Visibility(
                visible: !ResponsiveWidget.isSmallScreen(context),
                child: CustomText(
                  text: "insights!",
                  color: lightGrey,
                  size: 24,
                  weight: FontWeight.bold,
                )),
            Expanded(child: Container()),
            IconButton(
                icon: Icon(
                  Icons.bug_report,
                  color: dark,
                ),
                onPressed: () {
                  TextEditingController bugReportController = TextEditingController();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text("write a short description about the bug!"),
                        actions: <Widget>[
                          new TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: bugReportController,
                          ),
                          new TextButton(
                            child: new Text("OK"),
                            onPressed: () {
                              String? UserName = "anonymous";
                              UserName = FirebaseAuth.instance.currentUser?.displayName;
                              final log = new Logger("bug_report"+UserName.toString());
                              log.info('User bug report '+UserName.toString());
                              try {
                                throw Exception();
                              } catch (error, stackTrace) {
                                log.severe( bugReportController.text, error, stackTrace);
                              }
                              Navigator.of(context).pop();
                            },
                          ),

                        ],
                      );
                    },
                  );
                }),

            Stack(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: dark.withOpacity(.7),
                    ),
                    onPressed: () {}),
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    width: 12,
                    height: 12,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: active,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: light, width: 2)),
                  ),
                )
              ],
            ),
            Container(
              width: 1,
              height: 22,
              color: lightGrey,
            ),
            SizedBox(
              width: 24,
            ),
            CustomText(
              text: "YPKM",
              color: lightGrey,
            ),
            SizedBox(
              width: 16,
            ),
            Container(
              decoration: BoxDecoration(
                  color: active.withOpacity(.5),
                  borderRadius: BorderRadius.circular(30)),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.all(2),
                margin: EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundColor: light,
                  child: Icon(
                    Icons.person_outline,
                    color: dark,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      iconTheme: IconThemeData(color: dark),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
