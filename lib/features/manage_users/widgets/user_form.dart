import 'package:flutter/material.dart';

class UserForm extends StatelessWidget {
  const UserForm({
    super.key, required this.title, this.hintText,
  });

  final String title;
  final String ? hintText;

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
          decoration:  InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6D6F73),
            ),
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