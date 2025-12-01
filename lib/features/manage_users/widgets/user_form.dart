import 'package:flutter/material.dart';

class UserForm extends StatelessWidget {
  const UserForm({
    super.key, 
    required this.title, 
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.readOnly = false,
  });

  final String title;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 16,),
            Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),),
          ],
        ),
        const SizedBox(height: 08,),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          decoration:  InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6D6F73),
            ),
            filled: readOnly,
            fillColor: readOnly ? Colors.grey.shade100 : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(28),),
              borderSide: BorderSide(color: Color(0xFFE9EDF5), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(28),),
              borderSide: BorderSide(color: Color(0xFFE9EDF5), width: 1),
            ),

          ),
        )
      ],
    );
  }
}