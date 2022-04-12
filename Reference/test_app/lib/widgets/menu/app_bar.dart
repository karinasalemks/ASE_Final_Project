import 'package:flutter/material.dart';
import 'package:test_app/widgets/responsive_app/ResponsiveScreen.dart';
import 'package:test_app/constants/styles.dart';


AppBar topNavigationBar(BuildContext context,  GlobalKey<ScaffoldState> key) =>
    AppBar(
      leading: ResponsiveWidget.isSmallScreen(context) ?
        IconButton(icon: Icon(Icons.menu,color: light,), onPressed: (){
          key.currentState?.openDrawer();
        }) :
        Row(
          children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Image.asset("assets/icons/logo.png", width: 28,),
          ),
          ],
        ),
      elevation: 0,
      title: Container(
        child: Row(
          children: [
            Visibility(
                visible: !ResponsiveWidget.isSmallScreen(context),
                child: Text("Sample Text"),
            ),
            Expanded(child: Container()),
            IconButton(icon: Icon(Icons.settings, color: light,), onPressed: (){}),

            Stack(
              children: [
                IconButton(icon: Icon(Icons.notifications, color: light.withOpacity(.7),), onPressed: (){}),
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
                        border: Border.all(color: light, width: 2)
                    ),
                  ),
                )
              ],
            ),

            Container(
              width: 1,
              height: 22,
              color: lightGrey,
            ),
            SizedBox(width: 24,),
            Text("Sample Text"),
            SizedBox(width: 16,),
            Container(
              decoration: BoxDecoration(
                  color: active.withOpacity(.5),
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.all(2),
                margin: EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundColor: light,
                  child: Icon(Icons.person_outline, color: dark,),
                ),
              ),
            )
          ],
        ),
      ),
      iconTheme: IconThemeData(color: dark),
      backgroundColor: Colors.black,
    );
