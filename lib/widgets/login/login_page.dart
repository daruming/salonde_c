import 'package:flutter/material.dart';
// myprofile
import 'package:salondec/component/custom_form_buttom.dart';
import 'package:salondec/component/custom_input_field.dart';
import 'package:salondec/component/page_header.dart';
import 'package:salondec/component/page_heading.dart';

import 'package:get/get.dart';
import 'package:salondec/page/mainPage.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
//import 'common/custom_form_buttom.dart';
//import 'common/custom_input_field.dart';
//import 'common/page_header.dart';
//import 'common/page_heading.dart';
//develop
import 'signup_page.dart';
import 'package:email_validator/email_validator.dart';
import 'forget_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //
  AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  final _loginFormKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Form(
              key: _loginFormKey,
              child: Column(children: [
                const PageHeader(),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const PageHeading(
                        title: 'Login',
                      ),
                      CustomInputField(
                          controller: _email,
                          labelText: '??????',
                          hintText: '????????? ????????? ???????????????',
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return '???????????? ???????????????!';
                            }
                            if (!EmailValidator.validate(
                                textValue.replaceAll(" ", ""))) {
                              return '????????? ???????????? ???????????????';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomInputField(
                        controller: _password,
                        labelText: '????????????',
                        hintText: '??????????????? ???????????????',
                        obscureText: true,
                        suffixIcon: true,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return '??????????????? ???????????????!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: size.width * 0.80,
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgetPasswordPage()))
                          },
                          child: const Text(
                            '??????????????? ?????????????',
                            style: TextStyle(
                              color: Color(0xff939393),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomFormButton(
                        innerText: '????????????',
                        onPressed: _handleLoginUser,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      SizedBox(
                        width: size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '????????? ????????????????',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff939393),
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupPage()))
                              },
                              child: const Text(
                                '????????????',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff748288),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ));
  }

  Future _handleLoginUser() async {
    if (_loginFormKey.currentState!.validate()) {
      try {
        // await FirebaseAuth.instance.signInWithEmailAndPassword(
        //     email: _email.text.trim(), password: _password.text.trim());
<<<<<<< HEAD
        _email.text = _email.text.replaceAll(" ", "");
        await _authViewModel.signInWithEmail(
            email: _email.text.trim(), password: _password.text.trim());
        if (_authViewModel.user != null) {
          await _authViewModel.getUserInfo();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('?????????????????? ???????????? ???????????????!')),
            );
          }
          Get.toNamed(MainPage.routeName);
          // } else if() {
        } else {
          if (_authViewModel.errorState == ErrorState.network) {
            // ????????????
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("???????????? ??????????????????.")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("???????????? ??????????????????.")),
            );
          }
        }
=======
        await _authViewModel.signInWithEmail(
            email: _email.text.trim(), password: _password.text.trim());
        await _authViewModel.getUserInfo(uid: _authViewModel.user!.uid);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('?????????????????? ???????????? ???????????????!')),
          );
        }
        Get.toNamed(MainPage.routeName);
>>>>>>> 8239899606af8655f2c3ae272f42ae6154d99f2b
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}
