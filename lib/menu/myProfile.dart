import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:salondec/component/custom_form_buttom.dart';
import 'package:salondec/component/custom_input_field.dart';

import 'package:salondec/data/model/user_model.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:flutter/cupertino.dart';

const double _kItemExtent = 32.0;
const List<String> _fruitNames = <String>[
  '155 미만',
  '155-160',
  '161-165',
  '166-170',
  '171-175',
  '176-180',
  '181-185',
  '186 이상',
];

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  //firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  AuthViewModel _authViewModel = Get.find<AuthViewModel>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _mbtiController = TextEditingController();

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _bodyTypeController = TextEditingController();
  final TextEditingController _introductionController = TextEditingController();
  final TextEditingController _characterController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _religionController = TextEditingController();

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  final String _chars =
      "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
  final Random _rnd = Random();
  final user = FirebaseAuth.instance.currentUser!;

  int _selectedFruit = 3;

  @override
  void initState() {
    // _authViewModel.currentUser();
    _authViewModel.getUserInfo();
    super.initState();
    
  }


  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  // String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
  //     length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future imgFromGallery(String pictureOrder) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        _authViewModel.photoMap[pictureOrder] = _photo!;
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera(String pictureOrder) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        _authViewModel.photoMap[pictureOrder] = _photo!;
      } else {
        print('No image selected.');
      }
    });
  }

  UserModel _makeTempUserModel() {
    int age = 0;
    int height = 0;
    if (_ageController.text.isNotEmpty) {
      age = int.parse(_ageController.text);
    }
    if (_heightController.text.isNotEmpty) {
      height = int.parse(_heightController.text);
    }
    return UserModel(
      uid: _authViewModel.user!.uid,
      email: _authViewModel.userModel.value!.email,
      gender: _authViewModel.userModel.value!.gender,
      name: _nameController.text,
      age: age,
      height: height,
      job: _jobController.text,
      religion: _religionController.text,
      mbti: _mbtiController.text,
      bodytype: _bodyTypeController.text,
      introduction: _introductionController.text,
      character: _characterController.text,
      interest: _interestController.text,
    );
  }

  Future uploadFile(BuildContext context) async {
    var userModel = _makeTempUserModel();
    if (_authViewModel.photoMap.isNotEmpty) {
      await _authViewModel.uploadUpdateImages(
          photoMap: _authViewModel.photoMap);
      await _authViewModel.getDownloadURLs();
      await _authViewModel.updateUserInfo(userModelTemp: userModel);
      await _authViewModel.getUserInfo();
    } else {
      await _authViewModel.updateUserInfo(userModelTemp: userModel);
      await _authViewModel.getUserInfo();
    }
    Navigator.pop(context);
    print("완료");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Obx(() {
          return SingleChildScrollView(
              child: Column(children: [
            const SizedBox(height: 32),
            Center(
              child: GestureDetector(
                onTap: () {
                  print("클릭");
                  _showPicker(context, pictureOrder: "profileImageUrl");
                },
                child: Container(
                  child: (_authViewModel.userModel.value != null &&
                          _authViewModel.userModel.value?.profileImageUrl !=
                              null &&
                          _authViewModel.userModel.value?.profileImageUrl !=
                              '' &&
                          _authViewModel.photoMap["profileImageUrl"] == null)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            _authViewModel.userModel.value!.profileImageUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : _authViewModel.photoMap["profileImageUrl"] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                _authViewModel.photoMap["profileImageUrl"]!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitHeight,
                              ))
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(user.email!),
            const SizedBox(height: 20),
            CustomInputField(
                controller: _nameController,
                labelText: '이름',
                hintText: _hintText(
                    _authViewModel.userModel.value?.name!, '이름을 넣어주세요!'),
                validator: (textValue) {
                  if (textValue == null || textValue.isEmpty) {
                    return '이름을 넣어주세요!';
                  }
                  return null;
                }),
            const SizedBox(height: 20),
            Card(
              margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
              elevation: 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // <- Add this

                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _ageController,
                            decoration: InputDecoration(
                              // hintText: '나이',
                              hintText: _hintText(
                                  _authViewModel.userModel.value?.age
                                          .toString() ??
                                      "",
                                  '나이'),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _heightController,
                            decoration: InputDecoration(
                              hintText: _hintText(
                                  _authViewModel.userModel.value?.height
                                          .toString() ??
                                      "",
                                  '키'),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onTap: () {
                              _showDialog(
                              CupertinoPicker(
                                magnification: 1.22,
                                squeeze: 1.2,
                                useMagnifier: true,
                                itemExtent: _kItemExtent,
                                // This is called when selected item is changed.
                                onSelectedItemChanged: (int selectedItem) {
                                  setState(() {
                                    _selectedFruit = selectedItem;
                                  });
                                },
                                children:
                                    List<Widget>.generate(_fruitNames.length, (int index) {
                                  return Center(
                                    child: Text(
                                      _fruitNames[index],
                                    ),
                                  );
                                }),
                              ),
                            );}
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _jobController,
                            decoration: InputDecoration(
                              // hintText: '직업',
                              hintText: _hintText(
                                  _authViewModel.userModel.value?.job ?? "",
                                  '직업'),
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _bodyTypeController,
                            decoration: InputDecoration(
                              // hintText: '체형',
                              hintText: _hintText(
                                  _authViewModel.userModel.value?.bodytype ??
                                      "",
                                  '체형'),
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _religionController,
                            decoration: InputDecoration(
                              // hintText: '종교',
                              hintText: _hintText(
                                  _authViewModel.userModel.value?.religion ??
                                      "",
                                  '종교'),
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _mbtiController,
                            decoration: InputDecoration(
                              hintText: _hintText(
                                  _authViewModel.userModel.value?.mbti ?? "",
                                  'MBTI'),
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
                margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                elevation: 0.0,
                child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch, // <- Add this

                    children: <Widget>[
                      Text(
                        "첫번째사진",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            print("클릭");
                            _showPicker(context, pictureOrder: "imgUrl1");
                          },
                          child: Container(
                            child: (_authViewModel.userModel.value != null &&
                                    _authViewModel.userModel.value?.imgUrl1 !=
                                        null &&
                                    _authViewModel.userModel.value?.imgUrl1 !=
                                        '' &&
                                    _authViewModel.photoMap["imgUrl1"] == null)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: Image.network(
                                      _authViewModel.userModel.value!.imgUrl1!,
                                      height: 250.0,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )
                                : _authViewModel.photoMap["imgUrl1"] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Image.file(
                                          _authViewModel.photoMap["imgUrl1"]!,
                                          height: 250.0,
                                          fit: BoxFit.fitHeight,
                                        ))
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                        width: 250,
                                        height: 250,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    ])),
            const SizedBox(height: 20),
            CustomInputField(
                controller: _introductionController,
                labelText: '자기소개',
                hintText: _hintText(
                    _authViewModel.userModel.value?.introduction ?? "",
                    '자기소개를 해주세요'),
                validator: (textValue) {
                  if (textValue == null || textValue.isEmpty) {
                    return '자기소개를 넣어주세요!';
                  }
                  return null;
                }),
            const SizedBox(height: 20),
            Card(
                margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                elevation: 0.0,
                child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch, // <- Add this

                    children: <Widget>[
                      Text(
                        "두번째사진",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            print("클릭");
                            _showPicker(context, pictureOrder: "imgUrl2");
                          },
                          child: Container(
                            child: (_authViewModel.userModel.value != null &&
                                    _authViewModel.userModel.value?.imgUrl2 !=
                                        null &&
                                    _authViewModel.userModel.value?.imgUrl2 !=
                                        '' &&
                                    _authViewModel.photoMap["imgUrl2"] == null)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: Image.network(
                                      _authViewModel.userModel.value!.imgUrl2!,
                                      height: 250.0,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )
                                : _authViewModel.photoMap["imgUrl2"] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Image.file(
                                          _authViewModel.photoMap["imgUrl2"]!,
                                          height: 250.0,
                                          fit: BoxFit.fitHeight,
                                        ))
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                        width: 250,
                                        height: 250,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    ])),
            const SizedBox(height: 20),
            CustomInputField(
                controller: _characterController,
                labelText: '성격',
                hintText: _hintText(
                    _authViewModel.userModel.value?.character ?? "",
                    '자신의 성격을 설명해주세요'),
                validator: (textValue) {
                  if (textValue == null || textValue.isEmpty) {
                    return '성격을 넣어주세요!';
                  }
                  return null;
                }),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Card(
                margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                elevation: 0.0,
                child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch, // <- Add this

                    children: <Widget>[
                      Text(
                        "세번째사진",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            print("클릭");
                            _showPicker(context, pictureOrder: "imgUrl3");
                          },
                          child: Container(
                            child: (_authViewModel.userModel.value != null &&
                                    _authViewModel.userModel.value?.imgUrl3 !=
                                        null &&
                                    _authViewModel.userModel.value?.imgUrl3 !=
                                        '' &&
                                    _authViewModel.photoMap["imgUrl3"] == null)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: Image.network(
                                      _authViewModel.userModel.value!.imgUrl3!,
                                      height: 250.0,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )
                                : _authViewModel.photoMap["imgUrl3"] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Image.file(
                                          _authViewModel.photoMap["imgUrl3"]!,
                                          height: 250.0,
                                          fit: BoxFit.fitHeight,
                                        ))
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                        width: 250,
                                        height: 250,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    ])),
            const SizedBox(height: 20),
            CustomInputField(
                controller: _interestController,
                labelText: '관심사',
                hintText: _hintText(
                    _authViewModel.userModel.value?.interest ?? "",
                    '최근 관심있는 것을 말해주세요'),
                validator: (textValue) {
                  if (textValue == null || textValue.isEmpty) {
                    return '관심사를 넣어주세요!';
                  }
                  return null;
                }),
            SizedBox(
              height: 32,
            ),
            CustomFormButton(
              innerText: '저장하기',
              onPressed: () {
                uploadFile(context);
              },
            ),
            SizedBox(
              height: 32,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                child: Text('로그아웃'),
                onPressed: () {
                  _handleLogoutUser();
                }),
          ]));
        }));
  }

  Future _handleLogoutUser() async {
    try {
      // await FirebaseAuth.instance.signOut();
      _authViewModel.signOut();
      if (_authViewModel.user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그아웃 되었습니다.')),
          );
        }
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _showPicker(context, {required String pictureOrder}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery(pictureOrder);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera(pictureOrder);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  String _hintText(String? text, String hintText) {
    if (_authViewModel.userModel.value != null && text != '') {
      return text!;
    }
    return hintText;
  }
}
