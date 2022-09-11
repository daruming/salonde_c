import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salondec/component/custom_alert_dialog.dart';
import 'package:salondec/data/model/gender_model.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:salondec/page/viewmodel/rating_viewmodel.dart';

class CustomLoveLetter extends StatefulWidget {
  CustomLoveLetter({
    Key? key,
    required this.func,
    required this.title,
    required this.hint,
    required this.genderModel,
  }) : super(key: key);
  final Function func;
  final String title, hint;
  final GenderModel genderModel;

  @override
  _CustomLoveLetterState createState() => _CustomLoveLetterState();
}

class _CustomLoveLetterState extends State<CustomLoveLetter> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "${widget.title}",
              style: TextStyle(
                color: Color(0xff365859),
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "${widget.hint}",
                  hintStyle:
                      TextStyle(fontSize: 14.0, color: Color(0xffAFAFAF))),
              autofocus: true,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: RaisedButton(
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text("호감 보내기"),
                  color: Color(0xFF365859),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    setState(() {
                      widget.func(context, _textEditingController.text);
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
