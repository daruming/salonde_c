import 'package:flutter/material.dart';

class CustomInputField_multi extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String? Function(String?) validator;
  final bool suffixIcon;
  final bool? isDense;
  final bool obscureText;
  final TextEditingController controller;


  const CustomInputField_multi({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.validator,
    required this.controller,
    this.suffixIcon = false,
    this.isDense,
    this.obscureText = false
  }) : super(key: key);

  @override
  State<CustomInputField_multi> createState() => _CustomInputField_multiState();
}

class _CustomInputField_multiState extends State<CustomInputField_multi> {
  //
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.labelText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          ),
          TextFormField(
            obscureText: (widget.obscureText && _obscureText),
            controller: widget.controller,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, bottom: 10), // Set new height here
              isDense: (widget.isDense != null) ? widget.isDense : false,
              hintText: widget.hintText,
              suffixIcon: widget.suffixIcon ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.remove_red_eye : Icons.visibility_off_outlined,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ): null,
              suffixIconConstraints: (widget.isDense != null) ? const BoxConstraints(
              ): null,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}