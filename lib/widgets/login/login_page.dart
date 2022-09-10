import 'package:flutter/material.dart';
// myprofile
import 'package:salondec/component/custom_form_buttom.dart';
import 'package:salondec/component/custom_input_field.dart';
import 'package:salondec/component/page_header.dart';
import 'package:salondec/component/page_heading.dart';

import 'package:get/get.dart';
import 'package:salondec/core/define.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';

//develop
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
                          labelText: '메일',
                          hintText: '이메일 주소를 입력하세요',
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return '이메일이 필요합니다!';
                            }
                            if (!EmailValidator.validate(
                                textValue.replaceAll(" ", ""))) {
                              return '유효한 이메일을 입력하세요';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomInputField(
                        controller: _password,
                        labelText: '비밀번호',
                        hintText: '비밀번호를 입력하세요',
                        obscureText: true,
                        suffixIcon: true,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return '비밀번호가 필요합니다!';
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
                            '비밀번호를 잊었나요?',
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
                        innerText: '입장하기',
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
                              '계정이 없으신가요?',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff939393),
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                _authViewModel.userSignUpState.value = true;
                                // setState(() {});
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const SignupPage()))
                              },
                              child: const Text(
                                '가입하기',
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
        _email.text = _email.text.replaceAll(" ", "");
        await _authViewModel.signInWithEmail(
            email: _email.text.trim(), password: _password.text.trim());
        if (_authViewModel.user != null) {
          // await _authViewModel.getUserInfo();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('살롱드청담에 오신것을 환영합니다!')),
            );
          }
          // Get.toNamed(MainPage.routeName);
          // Get.toNamed(LoginScreen.routeName);
          // Get.until((route) => Get.currentRoute == LoginScreen.routeName);
          // } else if() {
        } else {
          if (_authViewModel.errorState == ErrorState.network) {
            // 임시방편
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("인터넷에 연결해주세요.")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("로그인에 실패했습니다.")),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}
