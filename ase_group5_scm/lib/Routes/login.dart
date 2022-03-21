import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
/*
* Login screen class is used to implement authentication of users
*
* */
class loginScreen extends StatelessWidget {
  static const String _title = 'Sustainable City Management';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  //user name field
  TextEditingController userNameController = TextEditingController();

  //password field
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Enter credentials',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                key: Key("username-field"),
                controller: userNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',

                ),
              ),

            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              child: TextField(
                key: Key("password-field"),
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () {
                      signIn(userNameController.text, passwordController.text)
                          .then((result) {
                        if (result == "success") {
                          Navigator.of(context).pushNamed("/DublinBikesDashboard",arguments: "Dublin Bikes");
                        } else if (result == "network-request-failed") {
                          return showSimpleNotification(
                              Text(
                                  'No Internet detected. Try again after connecting to internet',
                                  style: TextStyle(color: Colors.white)),
                              background: Colors.red);
                        } else {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("Invalid credentials!"),
                                content: result == "unknown"
                                    ? new Text("Empty username or password")
                                    : new Text(result),
                                actions: <Widget>[
                                  new TextButton(
                                    child: new Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      });
                    })),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: new GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/DublinBikesDashboard",arguments: "Dublin Bikes");
                      },
                      child: new Text(
                        "Continue as a guest",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                      ),
                    )))
          ]));
  }

  /*
  * signIn method is used to authenticate credentials with firebase
  *
  * @param String email
  * @param String password
  * @return Future<String> (success or auth message)
  * */
  Future<String> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

}
