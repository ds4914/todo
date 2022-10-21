
import 'package:auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // ignore: unused_field
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late String email;
  late String password;
  bool _obscureText = true;
  bool _obscureText1 = true;
  bool isCheck = false;

  TextEditingController fnamecontroller = TextEditingController();
  TextEditingController lnamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController cpasscontroller = TextEditingController();
  @override
  bool validmail() {
    var isValid = EmailValidator.validate(emailcontroller.text);
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset('assets/todo.jpg'),
            Padding(
              padding: const EdgeInsets.only(top: 250.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.95,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 50.0)],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0)),
                    color: Color.fromARGB(255, 92, 178, 249)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: Title(
                          color: Colors.black,
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30.0)),
                    _CommonView(
                        title: "Enter first name",
                        icon: Icons.supervised_user_circle_sharp,
                        controller: fnamecontroller),
                    const SizedBox(height: 5.0),
                    _CommonView(
                        title: "Enter Last name",
                        icon: Icons.supervised_user_circle_sharp,
                        controller: lnamecontroller),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const BoxDecoration(boxShadow: [
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
                          obscureText: false,
                          controller: emailcontroller,
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "email",
                              suffixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 20.0,
                          )
                        ]),
                        child: IntlPhoneField(
                          controller: phonecontroller,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.call),
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          initialCountryCode: 'IN',
                          onChanged: (phone) {
                            print(phone.completeNumber);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const BoxDecoration(boxShadow: [
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
                          onChanged: ((value) {
                            setState(() {
                              password = value;
                            });
                          }),
                          controller: passcontroller,
                          obscureText: _obscureText1,
                          decoration: InputDecoration(
                              hintText: "Enter your password",
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText1 = !_obscureText1;
                                  });
                                },
                                child: Icon(_obscureText1
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const BoxDecoration(boxShadow: [
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
                          controller: cpasscontroller,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              hintText: "Confirm password",
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
                        ),
                      ),
                    ),
                    Container(
                      child: CheckboxListTile(
                        value: isCheck,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheck = value!;
                          });
                        },
                        title: const Text(
                          'Agree all Terms & Conditions',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          var mail = validmail();
                          if (fnamecontroller.text == '') {
                            Fluttertoast.showToast(msg: "Enter Full Name");
                          } else if (lnamecontroller.text == '') {
                            Fluttertoast.showToast(msg: "Enter Last Name");
                          } else if (emailcontroller.text == '') {
                            Fluttertoast.showToast(
                                msg: "Email Cannot be empty");
                          } else if (mail == false) {
                            Fluttertoast.showToast(msg: "Email syntax error");
                          } else {
                            if (phonecontroller.text == '') {
                              Fluttertoast.showToast(msg: "enter phone no.");
                            } else if (passcontroller.text.length < 7 &&
                                passcontroller.text == '') {
                              Fluttertoast.showToast(
                                  msg: "Enter 6 digit password");
                            } else if (isCheck == false) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Please Agree to the Terms & Conditions");
                            } else if (passcontroller.text !=
                                cpasscontroller.text) {
                              Fluttertoast.showToast(
                                  msg:
                                      "confirm password and create password does not match");
                            } else {
                              //   FirebaseAuth.instance
                              //       .createUserWithEmailAndPassword(
                              //           email: email, password: password)
                              //       .then((signedInUser) {
                              //     _firestore.collection('users').add({
                              //       'email': email,
                              //       'pass': password,

                              //     }).then((value) {
                              //       if (signedInUser != null) {
                              //         Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) => Login()));
                              //       }
                              //     }).catchError((e) {
                              //       print(e);
                              //     });
                              //   }).catchError((e) {
                              //     print(e);
                              //   });
                              // }

                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: email, password: password)
                                    .then((value) {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/login', (route) => false);
                                });
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .set({
                                  'email': email,
                                  'password': password,
                                });
                              } catch (e) {
                                print(e);
                              }
                            }
                          }
                        },
                        child: Text.rich(TextSpan(text: "Register"))),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: Text.rich(TextSpan(
                          text: 'Already have an Account? | Login here')),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _CommonView(
      {required String title,
      required IconData icon,
      bool isObscureText = false,
      required controller}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(boxShadow: [
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
          obscureText: isObscureText,
          controller: controller,
          decoration: InputDecoration(
              hintText: title,
              suffixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              )),
        ),
      ),
    );
  }
}
