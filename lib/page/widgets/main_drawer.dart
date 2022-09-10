import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';

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
      width: MediaQuery.of(context).size.width, // 75% of screen will be occupied
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff365859),
                image: DecorationImage(image: AssetImage('assets/image/logo.png'), fit:BoxFit.fitHeight)
              ), child: null,
          )
          ),
          ListTile(
            dense: true, visualDensity: VisualDensity(vertical: 3),   
            title: new Center(
              child: const Text('공지사항', style: TextStyle(
                  color: Color(0xff3E3E3E),
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0)
                  )
            ),
            shape: Border(bottom: BorderSide(color: Color(0xffE5E5E5))),
            onTap: () {
              /*
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyPageScreen()));
              */
            },
          ),
          ListTile(
            dense: true, visualDensity: VisualDensity(vertical: 3),   
            title: new Center(
              child: const Text('코인샵', style: TextStyle(
                  color: Color(0xff3E3E3E),
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0)
                  )
            ),
            shape: Border(bottom: BorderSide(color: Color(0xffE5E5E5))),
            onTap: () {
              /*
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyPageScreen()));
              */
            },
          ),
          ListTile(
            dense: true, visualDensity: VisualDensity(vertical: 3),   
            title: new Center(
              child: const Text('청담드살롱이란?', style: TextStyle(
                  color: Color(0xff3E3E3E),
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0)
                  )
            ),
            shape: Border(bottom: BorderSide(color: Color(0xffE5E5E5))),
            onTap: () {
              /*
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyPageScreen()));
              */
            },
          ),
          ListTile(
            dense: true, visualDensity: VisualDensity(vertical: 3),   
            title: new Center(
              child: const Text('청담드살롱 멤버쉽', style: TextStyle(
                  color: Color(0xff3E3E3E),
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0)
                  )
            ),
            shape: Border(bottom: BorderSide(color: Color(0xffE5E5E5))),
            onTap: () {
              /*
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyPageScreen()));
              */
            },
          ),
          ListTile(
            dense: true, visualDensity: VisualDensity(vertical: 3),   
            title: new Center(
              child: const Text('문의사항', style: TextStyle(
                  color: Color(0xff3E3E3E),
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0)
                  )
            ),
            shape: Border(bottom: BorderSide(color: Color(0xffE5E5E5))),
            onTap: () {
              /*
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyPageScreen()));
              */
            },
          ),
        ],
      ),
    );
  }
}
