import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';

import '../../../core/widgets/custom_appbar.dart';
import '../widgets/user_form.dart';

class AddDriverScreen extends StatelessWidget {
  const AddDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: "Add Driver",
            titleCenter: true,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32,),
              UserForm(title: 'Name'),
              const SizedBox(height: 16,),
              UserForm(title: 'Email'),
              const SizedBox(height: 16,),
              UserForm(title: 'Phone'),
              const SizedBox(height: 16,),
              UserForm(title: 'Password',),
              const SizedBox(height: 16,),
              UserForm(title: 'Confirm Password',),
              const SizedBox(height: 36,),
              ElevatedButton( style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: const Color(0xFFFFFFFF),
                padding: EdgeInsets.symmetric(vertical: 12.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                )
              ), onPressed: (){},
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 24,),
                  const SizedBox(width: 8,),
                  Text('Add', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),)
                ],
              ))


            ],
          ),
        ));
  }
}


