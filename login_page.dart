// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/Pages/register_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  late String _email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset('assets/todo.jpg'),
            Padding(
              padding: const EdgeInsets.only(top: 250.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 50.0)],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0)),
                    color: Color.fromARGB(255, 92, 178, 249)),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    children: [
                      Title(
                        color: Colors.black,
                        child: Text(
                          "Login Your Account",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30.0),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        // ignore: prefer_const_literals_to_create_immutables
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 20.0,
                          )
                        ]),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                          onChanged: ((value) {
                            setState(() {
                              _email = value;
                            });
                          }),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      // ignore: prefer_const_literals_to_create_immutables
                      Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 20.0,
                          )
                        ]),
                        child: TextFormField(
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              labelText: "password",
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                          onChanged: ((value) {
                            setState(() {
                              password = value;
                            });
                          }),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      ElevatedButton(
                          onPressed: (() {
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: _email, password: password)
                                .then((value) {
                              Navigator.pushNamed(context, '/homepage');
                            }).catchError((e) {
                              Fluttertoast.showToast(
                                  msg: "email doest not exist");
                            });
                          }),
                          child: Text('sign in')),
                      // ElevatedButton(
                      //     onPressed: (() {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => Register()));
                      //     }),
                      //     child: Text('sign up')),
                      SizedBox(height: 15.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text.rich((TextSpan(
                            text: 'Dont have an account? |  Register here'))),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
