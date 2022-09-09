import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salondec/component/custom_picker.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:salondec/menu/myPageScreen.dart';

class MainDrawer extends StatelessWidget {
  MainDrawer({
    Key? key,
    // required TextEditingController username,
  }) : super(key: key);

  // final TextEditingController _username;
  final AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  String? _username = '';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text("header"),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
            ),
            title: const Text('나의 프로필'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyPageScreen()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
            ),
            title: const Text('피커'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CustomPicker()));
            },
          ),
        ],
      ),
    );
  }
}
