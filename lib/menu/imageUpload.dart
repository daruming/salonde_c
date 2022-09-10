import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageUploads extends StatefulWidget {
  const ImageUploads({Key? key}) : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {
  //firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  TextEditingController _title = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _job = TextEditingController();
  TextEditingController _mbti = TextEditingController();
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  final String _chars =
      "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
  final Random _rnd = Random();
  final user = FirebaseAuth.instance.currentUser!;

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile(BuildContext context) async {
    try {
      // 스토리지에 업로드할 파일 경로
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('file') //'post'라는 folder를 만들고
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final UploadTask task = firebaseStorageRef.putFile(
          _photo!, SettableMetadata(contentType: 'image/jpg'));
      // 완료까지 기다림
      print("완료를 기다리는 중");
      await task.whenComplete(() => null);

      // 업로드 완료 후 url
      final downloadUrl = await firebaseStorageRef.getDownloadURL();

      // 문서 작성
      String postKey = getRandomString(16);
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('woman').doc(postKey).set({
        'title': _title.text,
        'age': _age.text,
        'job': _job.text,
        'mbti': _mbti.text,
        'userPhotoUrl': downloadUrl,
      });
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
    print("완료");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                print("클릭");
                _showPicker(context);
              },
              child: Container(
                child: _photo != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _photo!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      )
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
          SizedBox(
            height: 10,
          ),
          Text(user.email!),
          Container(
            child: TextField(
              controller: _title,
              decoration: InputDecoration(
                hintText: '이름',
                contentPadding: EdgeInsets.all(20),
              ),
            ),
          ),
          Container(
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(signed: true),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              controller: _age,
              decoration: InputDecoration(
                hintText: '나이',
                contentPadding: EdgeInsets.all(20),
              ),
            ),
          ),
          Container(
            child: TextField(
              controller: _job,
              decoration: InputDecoration(
                hintText: '직업',
                contentPadding: EdgeInsets.all(20),
              ),
            ),
          ),
          Container(
            child: TextField(
              controller: _mbti,
              decoration: InputDecoration(
                hintText: 'MBTI',
                contentPadding: EdgeInsets.all(20),
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          ElevatedButton(
              onPressed: () {
                uploadFile(context);
              },
              child: const Text("저장하기")),
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
        ],
      ),
    );
  }

  Future _handleLogoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("로그아웃되었나요?");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그아웃 되었습니다.')),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _showPicker(context) {
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
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
