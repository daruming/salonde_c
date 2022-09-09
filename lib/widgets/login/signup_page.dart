import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
//myprofile
import 'package:salondec/component/custom_form_buttom.dart';
import 'package:salondec/component/custom_input_field.dart';
import 'package:salondec/component/page_header.dart';
import 'package:salondec/component/page_heading.dart';
import 'package:salondec/menu/loginScreen.dart';

import 'package:salondec/page/mainPage.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
//import 'common/custom_form_buttom.dart';
//import 'common/custom_input_field.dart';
//import 'common/page_header.dart';
//develop
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? _profileImage;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();

  final _signupFormKey = GlobalKey<FormState>();
  final navigatorKey = GlobalKey<NavigatorState>();
  String singup = "가입하기";

  // String gender = '남';

  int _value = 0;
  AuthViewModel _authViewModel = Get.find<AuthViewModel>();

  Future _pickProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => _profileImage = imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _signupFormKey,
            child: Column(
              children: [
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
                        title: 'Sign-up',
                      ),
                      /*
                      SizedBox(
                        width: 130,
                        height: 130,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: _pickProfileImage,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade400,
                                      border: Border.all(color: Colors.white, width: 3),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_sharp,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16,),
                      CustomInputField(
                          controller: _name,
                          labelText: '이름',
                          hintText: '강살롱',
                          isDense: true,
                          validator: (textValue) {
                            if(textValue == null || textValue.isEmpty) {
                              return '이름이 필요합니다!';
                            }
                            return null;
                          }
                      ),
                      const SizedBox(height: 16,),*/
                      CustomInputField(
                          controller: _email,
                          labelText: '이메일',
                          hintText: '이메일 주소',
                          isDense: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return '이메일이 필요합니다!';
                            }
                            if (!EmailValidator.validate(textValue)) {
                              return '유효한 이메일을 입력하세요';
                            }
                            return null;
                          }),
                      /*const SizedBox(height: 16,),
                      CustomInputField(
                          labelText: 'Contact no.',
                          hintText: 'Your contact number',
                          isDense: true,
                          validator: (textValue) {
                            if(textValue == null || textValue.isEmpty) {
                              return 'Contact number is required!';
                            }
                            return null;
                          }
                      ),*/
                      const SizedBox(
                        height: 16,
                      ),
                      CustomInputField(
                        controller: _password,
                        labelText: '비밀번호',
                        hintText: '비밀번호',
                        isDense: true,
                        obscureText: true,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return '비밀번호가 필요합니다';
                          }
                          return null;
                        },
                        suffixIcon: true,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _genderWidget("남"),
                          _genderWidget("여"),
                        ],
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      CustomFormButton(
                        innerText: singup,
                        onPressed: _handleSignupUser,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              '이미 계정이 있나요 ? ',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff939393),
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                _authViewModel.userSignUpState.value = false;
                                // setState(() {});
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const LoginPage()))
                              },
                              child: const Text(
                                '로그인하기',
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
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _genderWidget(String gender) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _authViewModel.gender = gender;
          });
        },
        child: Row(
          children: <Widget>[
            _authViewModel.gender == gender
                ? Image.asset(
                    "assets/image/btn_radio_over.png", // 바꿔야함
                    width: 23,
                  )
                : Image.asset(
                    "assets/image/btn_radio_default.png",
                    width: 23,
                  ),
            Container(
                padding: const EdgeInsets.only(left: 7, top: 10, bottom: 10),
                child: Text(gender,
                    style: TextStyle(fontWeight: FontWeight.w400))),
          ],
        ));
  }

  Future _handleSignupUser() async {
    if (_signupFormKey.currentState!.validate()) {
      try {
        // await FirebaseAuth.instance.createUserWithEmailAndPassword(
        //     email: _email.text.trim(), password: _password.text.trim());
        bool result = await _authViewModel.signUpWithEmail(
            email: _email.text.trim(),
            password: _password.text.trim(),
            gender: _authViewModel.gender);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: result
                    // ? Text('회원가입이 되었습니다. 로그인 해보세요!')
                    ? Text('회원가입이 되었습니다.')
                    : Text('가입에 실패했습니다.')),
          );
        }
        if (result) {
          _authViewModel.userSignUpState.value = false;

          //   await _authViewModel.signInWithEmail(
          //       email: _email.text.trim(), password: _password.text.trim());
          //   // Get.toNamed(MainPage.routeName);
          //   Get.back();
          //   // Get.until((route) => Get.currentRoute == LoginScreen.routeName);
        }
        // try {
        //   await FirebaseAuth.instance.signOut();
        //   Navigator.of(context).popUntil((route) => route.isFirst);
        // } on FirebaseAuthException catch (e) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(e.toString())),
        //   );
        // }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message.toString())),
        );
      }
    }
  }
}
