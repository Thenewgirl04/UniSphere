import 'package:flutter/material.dart';
import 'package:flutter_projects/widgets/custom_scaffold.dart';

import '../theme/theme.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formForgetPasswordKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Center(
      child: SizedBox(
            height: 500,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.5,
                ),
                ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formForgetPasswordKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot your Password',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                      color: lightColorScheme.primary,
                    ),
                     ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      Text(
                        'Please enter the email address you\'ll like your reset link to be sent to',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email Address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(' Enter Email Address'),
                          hintText: 'Please enter the email address',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                          if (_formForgetPasswordKey.currentState!.validate()) {
                            showDialog(context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Reset Link Sent'),
                                  content: Text(
                                      'A password reset link has been sent to your email address'),
                                  actions: [
                                    TextButton(onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                      child: Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          },
                          child: const Text('Request Reset Link'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ),
          )
      ),
    );
  }
}
