import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/theme/app_theme.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/screens/splash_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'core/common/constants/stripe_key.dart';
import 'core/init/app_initializer.dart';

void main() async {
  await AppInitializer.initializeApp();

  Stripe.publishableKey = StripeKey.publishableKey;
  Stripe.merchantIdentifier = 'merchant.com.yourapp';
  await Stripe.instance.applySettings();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: SplashScreen(),
    );
  }
}
