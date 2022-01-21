import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _credentials_invalid = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: TextField(
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
                    setState(() {
                      if (nameController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        _credentials_invalid = true;
                      } else {
                        _credentials_invalid = false;
                        signIn(nameController.text, passwordController.text)
                            .then((result) {
                          if (result == null) {
                            Navigator.of(context).pushNamed("/dublinBikesMap");
                          }
                          else{
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text("Invalid credentials!"),
                                  content: new Text("username or password is incorrect! Try again"),
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
                      }
                    });
                  })),
          Container(
            height: 100,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
            child: (_credentials_invalid)
                ? Text(
                    'Username or password cannot be empty',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )
                : Text(''),
          ),
        ]));
  }

  Future signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
